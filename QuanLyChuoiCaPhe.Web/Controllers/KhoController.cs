using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Services;
using QuanLyChuoiCaPhe.Web.ViewModels;
using QuanLyChuoiCaPhe.Web.Models;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN", "KHO", "QUAN_LY")]
    public class KhoController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;
        private readonly KhoService _khoService;

        public KhoController(QuanLyChuoiCaPheContext context, KhoService khoService, AuthService authService)
            : base(authService)
        {
            _context = context;
            _khoService = khoService;
        }

        public async Task<IActionResult> Index(string? chiNhanh)
        {
            var query = _context.TonKhoNguyenLieus
                .Include(t => t.ChiNhanh)
                .Include(t => t.NguyenLieu)
                .AsQueryable();

            var userRole = HttpContext.Session.GetString("UserRole") ?? CurrentVaiTro;
            if (userRole == "QUAN_LY")
            {
                var maChiNhanhSession = HttpContext.Session.GetString("MaChiNhanh") ?? CurrentMaChiNhanh;
                query = query.Where(t => t.MaChiNhanh == maChiNhanhSession);
                chiNhanh = maChiNhanhSession;
            }
            else
            {
                var chiNhanhFilter = GetChiNhanhFilter();
                if (chiNhanhFilter != null)
                {
                    query = query.Where(t => t.MaChiNhanh == chiNhanhFilter);
                }

                if (!string.IsNullOrEmpty(chiNhanh))
                {
                    query = query.Where(t => t.MaChiNhanh == chiNhanh);
                }
            }

            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (userRole == "QUAN_LY")
            {
                var maChiNhanhSession = HttpContext.Session.GetString("MaChiNhanh") ?? CurrentMaChiNhanh;
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == maChiNhanhSession);
            }
            else
            {
                var chiNhanhFilter = GetChiNhanhFilter();
                if (chiNhanhFilter != null)
                {
                    chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }
            }

            ViewBag.ChiNhanhs = await chiNhanhsQuery.ToListAsync();
            ViewBag.ChiNhanh = chiNhanh;

            var tonKho = await query.ToListAsync();

            return View(tonKho);
        }

        [HttpGet]
        [RoleAuthorize("ADMIN", "KHO")]
        public async Task<IActionResult> GiaoDich()
        {
            // Lá» c danh sÃ¡ch chi nhÃ¡nh theo quyá» n
            var chiNhanhFilter = GetChiNhanhFilter();
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
            var nguyenLieus = await _context.NguyenLieus.Where(n => n.TrangThai == "Đang sử dụng").ToListAsync();
            ViewBag.NguyenLieus = new SelectList(nguyenLieus, "MaNguyenLieu", "TenNguyenLieu");
            ViewBag.NguyenLieuRawList = nguyenLieus;
            
            var model = new KhoGiaoDichViewModel();
            // Tá»± Ä‘á»™ng chá» n chi nhÃ¡nh náº¿u khÃ´ng pháº£i ADMIN
            if (chiNhanhFilter != null)
            {
                model.MaChiNhanh = chiNhanhFilter;
            }
            
            return View(model);
        }

        [HttpPost]
        [RoleAuthorize("ADMIN", "KHO", "QUAN_LY")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GiaoDich(KhoGiaoDichViewModel model)
        {
            var userRole = HttpContext.Session.GetString("UserRole") ?? CurrentVaiTro;
            if (userRole == "QUAN_LY")
            {
                return Json(new { success = false, message = "Lỗi bảo mật: Vai trò Quản lý chi nhánh chỉ có quyền giám sát, không có quyền tạo hoặc chỉnh sửa dữ liệu kho vật lý!" });
            }

            // Kiểm tra quyền truy cập chi nhánh
            var accessCheck = CheckChiNhanhAccess(model.MaChiNhanh);
            if (accessCheck != null) return accessCheck;

            if (!ModelState.IsValid)
            {
                var chiNhanhFilter = GetChiNhanhFilter();
                var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
                if (chiNhanhFilter != null)
                {
                    chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }

                ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
                var nguyenLieus = await _context.NguyenLieus.Where(n => n.TrangThai == "Đang sử dụng").ToListAsync();
                ViewBag.NguyenLieus = new SelectList(nguyenLieus, "MaNguyenLieu", "TenNguyenLieu");
                ViewBag.NguyenLieuRawList = nguyenLieus;
                return View(model);
            }

            try
            {
                var nguyenLieu = await _context.NguyenLieus.FindAsync(model.MaNguyenLieu);
                if (nguyenLieu != null)
                {
                    if (!FormatHelper.IsMeasurableUnit(nguyenLieu.DonViTinh))
                    {
                        model.SoLuong = Math.Round(model.SoLuong, 0, MidpointRounding.AwayFromZero);
                    }
                }

                await _khoService.GhiNhanGiaoDichKhoAsync(model);
                TempData["Success"] = "Ghi nhận giao dịch kho thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                
                var chiNhanhFilter = GetChiNhanhFilter();
                var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
                if (chiNhanhFilter != null)
                {
                    chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }

                ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
                var nguyenLieus = await _context.NguyenLieus.Where(n => n.TrangThai == "Đang sử dụng").ToListAsync();
                ViewBag.NguyenLieus = new SelectList(nguyenLieus, "MaNguyenLieu", "TenNguyenLieu");
                ViewBag.NguyenLieuRawList = nguyenLieus;
                return View(model);
            }
        }

        public async Task<IActionResult> CanhBao()
        {
            try
            {
                await _khoService.CanhBaoTonKhoAsync();
                var query = _context.VwCanhBaoTonKhos
                    .AsNoTracking()
                    .AsQueryable();
                
                var userRole = HttpContext.Session.GetString("UserRole") ?? CurrentVaiTro;
                if (userRole == "QUAN_LY")
                {
                    var maChiNhanhSession = HttpContext.Session.GetString("MaChiNhanh") ?? CurrentMaChiNhanh;
                    query = query.Where(c => c.MaChiNhanh == maChiNhanhSession);
                }
                else
                {
                    var chiNhanhFilter = GetChiNhanhFilter();
                    if (chiNhanhFilter != null)
                    {
                        query = query.Where(c => c.MaChiNhanh == chiNhanhFilter);
                    }
                }
                
                var canhBao = await query
                    .OrderBy(c => c.MaChiNhanh)
                    .ThenBy(c => c.TenNguyenLieu)
                    .ToListAsync();
                return View(canhBao);
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lá»—i: {ex.Message}";
                return View(new List<Models.VwCanhBaoTonKho>());
            }
        }

        public async Task<IActionResult> LichSu(string? chiNhanh, DateTime? tuNgay, DateTime? denNgay)
        {
            if (tuNgay.HasValue && denNgay.HasValue && tuNgay.Value.Date > denNgay.Value.Date)
            {
                ModelState.AddModelError(string.Empty, "Khoảng thời gian không hợp lệ: 'Từ ngày' phải nhỏ hơn hoặc bằng 'Đến ngày'.");

                var userRoleInvalid = HttpContext.Session.GetString("UserRole") ?? CurrentVaiTro;
                var chiNhanhsInvalidQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
                if (userRoleInvalid == "QUAN_LY")
                {
                    var maChiNhanhSession = HttpContext.Session.GetString("MaChiNhanh") ?? CurrentMaChiNhanh;
                    chiNhanhsInvalidQuery = chiNhanhsInvalidQuery.Where(c => c.MaChiNhanh == maChiNhanhSession);
                    chiNhanh = maChiNhanhSession;
                }
                else
                {
                    var chiNhanhFilterInvalid = GetChiNhanhFilter();
                    if (chiNhanhFilterInvalid != null)
                    {
                        chiNhanhsInvalidQuery = chiNhanhsInvalidQuery.Where(c => c.MaChiNhanh == chiNhanhFilterInvalid);
                    }
                }

                ViewBag.ChiNhanhs = await chiNhanhsInvalidQuery.ToListAsync();
                ViewBag.ChiNhanh = chiNhanh;
                ViewBag.TuNgay = tuNgay?.ToString("yyyy-MM-dd");
                ViewBag.DenNgay = denNgay?.ToString("yyyy-MM-dd");
                return View(new List<LichSuKho>());
            }

            var query = _context.LichSuKhos
                .Include(l => l.ChiNhanh)
                .Include(l => l.NguyenLieu)
                .AsQueryable();

            var userRole = HttpContext.Session.GetString("UserRole") ?? CurrentVaiTro;
            if (userRole == "QUAN_LY")
            {
                var maChiNhanhSession = HttpContext.Session.GetString("MaChiNhanh") ?? CurrentMaChiNhanh;
                query = query.Where(l => l.MaChiNhanh == maChiNhanhSession);
                chiNhanh = maChiNhanhSession;
            }
            else
            {
                var chiNhanhFilter = GetChiNhanhFilter();
                if (chiNhanhFilter != null)
                {
                    query = query.Where(l => l.MaChiNhanh == chiNhanhFilter);
                }

                if (!string.IsNullOrEmpty(chiNhanh))
                {
                    query = query.Where(l => l.MaChiNhanh == chiNhanh);
                }
            }

            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (userRole == "QUAN_LY")
            {
                var maChiNhanhSession = HttpContext.Session.GetString("MaChiNhanh") ?? CurrentMaChiNhanh;
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == maChiNhanhSession);
            }
            else
            {
                var chiNhanhFilter = GetChiNhanhFilter();
                if (chiNhanhFilter != null)
                {
                    chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }
            }

            ViewBag.ChiNhanhs = await chiNhanhsQuery.ToListAsync();
            ViewBag.ChiNhanh = chiNhanh;
            ViewBag.TuNgay = tuNgay?.ToString("yyyy-MM-dd");
            ViewBag.DenNgay = denNgay?.ToString("yyyy-MM-dd");

            return View(await query.OrderByDescending(l => l.ThoiGian).ToListAsync());
        }

        [HttpGet]
        public async Task<IActionResult> GetTonKhoHienTai(string maNguyenLieu, string maChiNhanh)
        {
            var tonKho = await _context.TonKhoNguyenLieus
                .Include(t => t.NguyenLieu)
                .FirstOrDefaultAsync(t => t.MaChiNhanh == maChiNhanh && t.MaNguyenLieu == maNguyenLieu);

            if (tonKho == null)
            {
                var nguyenLieu = await _context.NguyenLieus.FindAsync(maNguyenLieu);
                return Json(new { 
                    soLuongTon = 0, 
                    donViTinh = nguyenLieu?.DonViTinh ?? "" 
                });
            }

            return Json(new { 
                soLuongTon = tonKho.SoLuongTon, 
                donViTinh = tonKho.NguyenLieu?.DonViTinh ?? "" 
            });
        }

        [HttpPost]
        [RoleAuthorize("ADMIN", "KHO", "QUAN_LY")]
        public async Task<IActionResult> UpdateQuick(string maChiNhanh, string maNguyenLieu, DateTime? hanSuDung, decimal soLuongDaDat)
        {
            var userRole = HttpContext.Session.GetString("UserRole") ?? CurrentVaiTro;
            if (userRole == "QUAN_LY")
            {
                return Json(new { success = false, message = "Lỗi bảo mật: Vai trò Quản lý chi nhánh chỉ có quyền giám sát, không có quyền tạo hoặc chỉnh sửa dữ liệu kho vật lý!" });
            }

            var accessCheck = CheckChiNhanhAccess(maChiNhanh);
            if (accessCheck != null) return Json(new { success = false, message = "Không có quyền cập nhật chi nhánh này." });

            if (soLuongDaDat < 0)
            {
                return Json(new { success = false, message = "Số lượng đã đặt không được nhỏ hơn 0." });
            }

            if (hanSuDung.HasValue && hanSuDung.Value.Date < DateTime.Today)
            {
                return Json(new { success = false, message = "Hạn sử dụng không được là ngày trong quá khứ." });
            }

            var tonKho = await _context.TonKhoNguyenLieus
                .FirstOrDefaultAsync(t => t.MaChiNhanh == maChiNhanh && t.MaNguyenLieu == maNguyenLieu);

            if (tonKho == null)
            {
                return Json(new { success = false, message = "Không tìm thấy nguyên liệu trong kho." });
            }

            // Làm tròn nếu là đơn vị đếm được
            var nguyenLieu = await _context.NguyenLieus.FindAsync(maNguyenLieu);
            if (nguyenLieu != null && !FormatHelper.IsMeasurableUnit(nguyenLieu.DonViTinh))
            {
                soLuongDaDat = Math.Round(soLuongDaDat, 0, MidpointRounding.AwayFromZero);
            }

            tonKho.HanSuDung = hanSuDung;
            tonKho.SoLuongDaDat = soLuongDaDat;

            try
            {
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Cập nhật thông tin nhanh thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}" });
            }
        }
    }
}

