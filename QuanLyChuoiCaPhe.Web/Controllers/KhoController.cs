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

            // PhÃ¢n quyá»n theo chi nhÃ¡nh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(t => t.MaChiNhanh == chiNhanhFilter);
            }

            if (!string.IsNullOrEmpty(chiNhanh))
            {
                query = query.Where(t => t.MaChiNhanh == chiNhanh);
            }

            // Lá»c danh sÃ¡ch chi nhÃ¡nh theo quyá»n
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
            // Lá»c danh sÃ¡ch chi nhÃ¡nh theo quyá»n
            var chiNhanhFilter = GetChiNhanhFilter();
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
            ViewBag.NguyenLieus = new SelectList(await _context.NguyenLieus.Where(n => n.TrangThai == "Äang sá»­ dá»¥ng").ToListAsync(), "MaNguyenLieu", "TenNguyenLieu");
            
            var model = new KhoGiaoDichViewModel();
            // Tá»± Ä‘á»™ng chá»n chi nhÃ¡nh náº¿u khÃ´ng pháº£i ADMIN
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
            // Kiá»ƒm tra quyá»n truy cáº­p chi nhÃ¡nh
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
                ViewBag.NguyenLieus = new SelectList(await _context.NguyenLieus.Where(n => n.TrangThai == "Äang sá»­ dá»¥ng").ToListAsync(), "MaNguyenLieu", "TenNguyenLieu");
                return View(model);
            }

            try
            {
                await _khoService.GhiNhanGiaoDichKhoAsync(model);
                TempData["Success"] = "Ghi nháº­n giao dá»‹ch kho thÃ nh cÃ´ng!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lá»—i: {ex.InnerException?.Message ?? ex.Message}";
                
                var chiNhanhFilter = GetChiNhanhFilter();
                var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
                if (chiNhanhFilter != null)
                {
                    chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }

                ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
                ViewBag.NguyenLieus = new SelectList(await _context.NguyenLieus.Where(n => n.TrangThai == "Äang sá»­ dá»¥ng").ToListAsync(), "MaNguyenLieu", "TenNguyenLieu");
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
                    .Where(x => x.SoLuongTon.HasValue && x.MucCanhBao.HasValue && x.SoLuongTon.Value <= x.MucCanhBao.Value)
                    .AsQueryable();
                
                // PhÃ¢n quyá»n theo chi nhÃ¡nh
                var chiNhanhFilter = GetChiNhanhFilter();
                if (chiNhanhFilter != null)
                {
                    query = query.Where(c => c.MaChiNhanh == chiNhanhFilter);
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
            var query = _context.LichSuKhos.AsQueryable();

            // PhÃ¢n quyá»n theo chi nhÃ¡nh
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

            // Lá»c danh sÃ¡ch chi nhÃ¡nh theo quyá»n
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

