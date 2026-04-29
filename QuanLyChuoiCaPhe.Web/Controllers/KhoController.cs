using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Services;
using QuanLyChuoiCaPhe.Web.ViewModels;

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

            // Phân quyền theo chi nhánh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(t => t.MaChiNhanh == chiNhanhFilter);
            }

            if (!string.IsNullOrEmpty(chiNhanh))
            {
                query = query.Where(t => t.MaChiNhanh == chiNhanh);
            }

            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = await chiNhanhsQuery.ToListAsync();
            ViewBag.ChiNhanh = chiNhanh;

            var tonKho = await query.ToListAsync();

            return View(tonKho);
        }

        [HttpGet]
        public async Task<IActionResult> GiaoDich()
        {
            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhFilter = GetChiNhanhFilter();
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
            ViewBag.NguyenLieus = new SelectList(await _context.NguyenLieus.Where(n => n.TrangThai == "Đang sử dụng").ToListAsync(), "MaNguyenLieu", "TenNguyenLieu");
            
            var model = new KhoGiaoDichViewModel();
            // Tự động chọn chi nhánh nếu không phải ADMIN
            if (chiNhanhFilter != null)
            {
                model.MaChiNhanh = chiNhanhFilter;
            }
            
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GiaoDich(KhoGiaoDichViewModel model)
        {
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
                ViewBag.NguyenLieus = new SelectList(await _context.NguyenLieus.Where(n => n.TrangThai == "Đang sử dụng").ToListAsync(), "MaNguyenLieu", "TenNguyenLieu");
                return View(model);
            }

            try
            {
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
                ViewBag.NguyenLieus = new SelectList(await _context.NguyenLieus.Where(n => n.TrangThai == "Đang sử dụng").ToListAsync(), "MaNguyenLieu", "TenNguyenLieu");
                return View(model);
            }
        }

        public async Task<IActionResult> CanhBao()
        {
            try
            {
                await _khoService.CanhBaoTonKhoAsync();
                var query = _context.VwCanhBaoTonKhos.AsQueryable();
                
                // Phân quyền theo chi nhánh
                var chiNhanhFilter = GetChiNhanhFilter();
                if (chiNhanhFilter != null)
                {
                    query = query.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }
                
                var canhBao = await query.ToListAsync();
                return View(canhBao);
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.Message}";
                return View(new List<Models.VwCanhBaoTonKho>());
            }
        }

        public async Task<IActionResult> LichSu(string? chiNhanh, DateTime? tuNgay, DateTime? denNgay)
        {
            var query = _context.LichSuKhos.AsQueryable();

            // Phân quyền theo chi nhánh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(l => l.MaChiNhanh == chiNhanhFilter);
            }

            if (!string.IsNullOrEmpty(chiNhanh))
            {
                query = query.Where(l => l.MaChiNhanh == chiNhanh);
            }

            if (tuNgay.HasValue)
            {
                query = query.Where(l => l.ThoiGian.Date >= tuNgay.Value.Date);
            }

            if (denNgay.HasValue)
            {
                query = query.Where(l => l.ThoiGian.Date <= denNgay.Value.Date);
            }

            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = await chiNhanhsQuery.ToListAsync();
            ViewBag.ChiNhanh = chiNhanh;
            ViewBag.TuNgay = tuNgay?.ToString("yyyy-MM-dd");
            ViewBag.DenNgay = denNgay?.ToString("yyyy-MM-dd");

            return View(await query.OrderByDescending(l => l.ThoiGian).ToListAsync());
        }
    }
}
