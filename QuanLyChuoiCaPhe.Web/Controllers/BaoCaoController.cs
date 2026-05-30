using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Services;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN", "QUAN_LY", "KE_TOAN")]
    public class BaoCaoController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;
        private readonly BaoCaoService _baoCaoService;

        public BaoCaoController(QuanLyChuoiCaPheContext context, BaoCaoService baoCaoService, AuthService authService)
            : base(authService)
        {
            _context = context;
            _baoCaoService = baoCaoService;
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                // Lấy filter chi nhánh
                var chiNhanhFilter = GetChiNhanhFilter();
                
                ViewBag.DoanhThuTheoChiNhanh = await _baoCaoService.GetDoanhThuTheoChiNhanhAsync(chiNhanhFilter);
                ViewBag.TopSanPham = await _baoCaoService.GetTopSanPhamBanChayAsync(10, chiNhanhFilter);
                int? topKhachHangChiNhanh = null;
                var userRole = HttpContext.Session.GetString("UserRole") ?? CurrentVaiTro;
                if (userRole == "QUAN_LY")
                {
                    var maCNStr = HttpContext.Session.GetString("MaChiNhanh") ?? CurrentMaChiNhanh;
                    if (!string.IsNullOrEmpty(maCNStr))
                    {
                        if (int.TryParse(maCNStr.Replace("CN", ""), out int parsed))
                        {
                            topKhachHangChiNhanh = parsed;
                        }
                    }
                }
                ViewBag.TopKhachHang = await _baoCaoService.GetTopKhachHangAsync(topKhachHangChiNhanh, 10);

                // Doanh thu theo ngày (7 ngày gần nhất, không khuyết ngày)
                var dates = Enumerable.Range(0, 7)
                    .Select(offset => DateTime.Today.AddDays(-6 + offset))
                    .ToList();

                var startQueryDate = DateTime.Today.AddDays(-6);
                var doanhThuDb = await _context.DonHangs
                    .Where(d => d.NgayTao >= startQueryDate)
                    .Where(d => chiNhanhFilter == null || d.MaChiNhanh == chiNhanhFilter)
                    .GroupBy(d => d.NgayTao.Date)
                    .Select(g => new
                    {
                        Ngay = g.Key,
                        DoanhThu = g.Sum(d => d.TongTien - d.GiamGia)
                    })
                    .ToDictionaryAsync(x => x.Ngay, x => x.DoanhThu);

                var doanhThuTheoNgay = dates.Select(date => new
                {
                    Ngay = date,
                    DoanhThu = doanhThuDb.ContainsKey(date) ? doanhThuDb[date] : 0m
                }).ToList();

                ViewBag.DoanhThuTheoNgay = doanhThuTheoNgay;

                // Nhật ký hệ thống (Ẩn HeThongTaiKhoan đối với các vai trò không phải ADMIN)
                var nhatKyQuery = _context.DuLieuHeThongs
                    .Include(d => d.HeThongTaiKhoan)
                    .AsQueryable();

                if (CurrentVaiTro != "ADMIN")
                {
                    nhatKyQuery = nhatKyQuery.Where(d => d.TenBang != "HeThongTaiKhoan");
                }

                var nhatKy = await nhatKyQuery
                    .OrderByDescending(d => d.ThoiGian)
                    .Take(50)
                    .ToListAsync();

                ViewBag.NhatKy = nhatKy;

                return View();
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi tải báo cáo: {ex.Message}";
                
                // Khởi tạo ViewBag với giá trị mặc định
                ViewBag.DoanhThuTheoChiNhanh = new Dictionary<string, decimal>();
                ViewBag.TopSanPham = new List<object>();
                ViewBag.TopKhachHang = new List<object>();
                ViewBag.DoanhThuTheoNgay = new List<object>();
                ViewBag.NhatKy = new List<Models.DuLieuHeThong>();
                
                return View();
            }
        }
    }
}
