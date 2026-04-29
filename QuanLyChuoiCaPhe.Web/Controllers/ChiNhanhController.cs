using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.Services;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN", "QUAN_LY")]
    public class ChiNhanhController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public ChiNhanhController(QuanLyChuoiCaPheContext context, AuthService authService)
            : base(authService)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? search, string? khuVuc, bool? trangThai)
        {
            var query = _context.ChiNhanhs.Include(c => c.KhuVuc).AsQueryable();

            // Phân quyền: QUAN_LY chỉ xem chi nhánh của mình
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(c => c.TenChiNhanh.Contains(search) 
                                      || c.SoDienThoai.Contains(search) 
                                      || c.DiaChi.Contains(search));
            }

            if (!string.IsNullOrEmpty(khuVuc))
            {
                query = query.Where(c => c.MaKhuVuc == khuVuc);
            }

            if (trangThai.HasValue)
            {
                query = query.Where(c => c.TrangThai == trangThai.Value);
            }

            ViewBag.KhuVucs = await _context.KhuVucs.ToListAsync();
            ViewBag.Search = search;
            ViewBag.KhuVuc = khuVuc;
            ViewBag.TrangThai = trangThai;

            return View(await query.OrderBy(c => c.TenChiNhanh).ToListAsync());
        }

        [HttpGet]
        [RoleAuthorize("ADMIN")] // Chỉ ADMIN mới được tạo chi nhánh mới
        public async Task<IActionResult> Create()
        {
            ViewBag.KhuVucs = new SelectList(await _context.KhuVucs.ToListAsync(), "MaKhuVuc", "TenKhuVuc");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("ADMIN")] // Chỉ ADMIN mới được tạo chi nhánh mới
        public async Task<IActionResult> Create(ChiNhanh model)
        {
            // Xóa validation error cho MaChiNhanh (sẽ được tạo tự động)
            ModelState.Remove("MaChiNhanh");
            
            // Xóa validation errors cho navigation properties
            ModelState.Remove("KhuVuc");
            ModelState.Remove("ThongTinNhanViens");
            ModelState.Remove("SanPhamChiNhanhs");
            ModelState.Remove("TonKhoNguyenLieus");
            ModelState.Remove("DonHangs");
            
            if (!ModelState.IsValid)
            {
                ViewBag.KhuVucs = new SelectList(await _context.KhuVucs.ToListAsync(), "MaKhuVuc", "TenKhuVuc");
                return View(model);
            }

            try
            {
                model.MaChiNhanh = GenerateMaChiNhanh();
                _context.ChiNhanhs.Add(model);
                await _context.SaveChangesAsync();

                TempData["Success"] = "Thêm chi nhánh thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                ViewBag.KhuVucs = new SelectList(await _context.KhuVucs.ToListAsync(), "MaKhuVuc", "TenKhuVuc");
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            var chiNhanh = await _context.ChiNhanhs.FindAsync(id);
            if (chiNhanh == null)
            {
                TempData["Error"] = "Không tìm thấy chi nhánh!";
                return RedirectToAction(nameof(Index));
            }

            // Kiểm tra quyền: QUAN_LY chỉ sửa chi nhánh của mình
            var accessCheck = CheckChiNhanhAccess(chiNhanh.MaChiNhanh);
            if (accessCheck != null) return accessCheck;

            ViewBag.KhuVucs = new SelectList(await _context.KhuVucs.ToListAsync(), "MaKhuVuc", "TenKhuVuc", chiNhanh.MaKhuVuc);
            return View(chiNhanh);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(ChiNhanh model)
        {
            // Kiểm tra quyền: QUAN_LY chỉ sửa chi nhánh của mình
            var accessCheck = CheckChiNhanhAccess(model.MaChiNhanh);
            if (accessCheck != null) return accessCheck;

            // Xóa validation errors cho navigation properties
            ModelState.Remove("KhuVuc");
            ModelState.Remove("ThongTinNhanViens");
            ModelState.Remove("SanPhamChiNhanhs");
            ModelState.Remove("TonKhoNguyenLieus");
            ModelState.Remove("DonHangs");
            
            if (!ModelState.IsValid)
            {
                ViewBag.KhuVucs = new SelectList(await _context.KhuVucs.ToListAsync(), "MaKhuVuc", "TenKhuVuc", model.MaKhuVuc);
                return View(model);
            }

            try
            {
                _context.ChiNhanhs.Update(model);
                await _context.SaveChangesAsync();

                TempData["Success"] = "Cập nhật chi nhánh thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                ViewBag.KhuVucs = new SelectList(await _context.KhuVucs.ToListAsync(), "MaKhuVuc", "TenKhuVuc", model.MaKhuVuc);
                return View(model);
            }
        }

        [HttpPost]
        [RoleAuthorize("ADMIN")] // Chỉ ADMIN mới được bật/tắt chi nhánh
        public async Task<IActionResult> ToggleStatus(string id)
        {
            try
            {
                var chiNhanh = await _context.ChiNhanhs.FindAsync(id);
                if (chiNhanh == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy chi nhánh!" });
                }

                chiNhanh.TrangThai = !chiNhanh.TrangThai;
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Cập nhật trạng thái thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        private string GenerateMaChiNhanh()
        {
            var random = new Random();
            var number = random.Next(1000, 9999);
            return $"CN{number}";
        }
    }
}
