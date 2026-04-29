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
                ViewBag.TopKhachHang = await _baoCaoService.GetTopKhachHangAsync();

                // Doanh thu theo ngày (7 ngày gần nhất)
                var doanhThuQuery = _context.DonHangs
                    .Where(d => d.NgayTao >= DateTime.Now.AddDays(-7))
                    .AsQueryable();
                
                // Filter theo chi nhánh
                if (chiNhanhFilter != null)
                {
                    doanhThuQuery = doanhThuQuery.Where(d => d.MaChiNhanh == chiNhanhFilter);
                }
                
                var doanhThuTheoNgay = await doanhThuQuery
                    .GroupBy(d => d.NgayTao.Date)
                    .Select(g => new
                    {
                        Ngay = g.Key,
                        DoanhThu = g.Sum(d => d.TongTien - d.GiamGia)
                    })
                    .OrderBy(x => x.Ngay)
                    .ToListAsync();

                ViewBag.DoanhThuTheoNgay = doanhThuTheoNgay;

                // Nhật ký hệ thống
                var nhatKy = await _context.DuLieuHeThongs
                    .Include(d => d.HeThongTaiKhoan)
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
