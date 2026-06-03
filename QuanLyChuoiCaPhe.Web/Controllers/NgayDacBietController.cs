using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.Services;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN", "QUAN_LY")]
    public class NgayDacBietController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public NgayDacBietController(QuanLyChuoiCaPheContext context, AuthService authService)
            : base(authService)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? search, int? nam)
        {
            var query = _context.NgayDacBiets.AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(n => n.TenNgay.Contains(search));
            }

            if (nam.HasValue)
            {
                query = query.Where(n => n.Ngay.Year == nam.Value);
            }

            ViewBag.Search = search;
            ViewBag.Nam = nam;

            return View(await query.OrderByDescending(n => n.Ngay).ToListAsync());
        }

        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(NgayDacBiet model)
        {
            if (string.IsNullOrWhiteSpace(model.TenNgay))
            {
                ModelState.AddModelError("TenNgay", "Tên ngày không được để trống.");
            }
            if (model.HeSoLuong < 1)
            {
                ModelState.AddModelError("HeSoLuong", "Hệ số lương phải >= 1.");
            }

            if (await _context.NgayDacBiets.AnyAsync(n => n.Ngay.Date == model.Ngay.Date))
            {
                ModelState.AddModelError("Ngay", "Ngày đặc biệt này đã tồn tại.");
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                _context.NgayDacBiets.Add(model);
                await _context.SaveChangesAsync();
                TempData["Success"] = "Thêm ngày đặc biệt thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(DateTime id)
        {
            var ngay = await _context.NgayDacBiets.FindAsync(id);
            if (ngay == null)
            {
                TempData["Error"] = "Không tìm thấy ngày đặc biệt!";
                return RedirectToAction(nameof(Index));
            }
            return View(ngay);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(NgayDacBiet model)
        {
            if (string.IsNullOrWhiteSpace(model.TenNgay))
            {
                ModelState.AddModelError("TenNgay", "Tên ngày không được để trống.");
            }
            if (model.HeSoLuong < 1)
            {
                ModelState.AddModelError("HeSoLuong", "Hệ số lương phải >= 1.");
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                var ngay = await _context.NgayDacBiets.FindAsync(model.Ngay);
                if (ngay == null)
                {
                    TempData["Error"] = "Không tìm thấy ngày đặc biệt!";
                    return RedirectToAction(nameof(Index));
                }

                ngay.TenNgay = model.TenNgay;
                ngay.HeSoLuong = model.HeSoLuong;

                await _context.SaveChangesAsync();
                TempData["Success"] = "Cập nhật ngày đặc biệt thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                return View(model);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(DateTime id)
        {
            try
            {
                var ngay = await _context.NgayDacBiets.FindAsync(id);
                if (ngay == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy ngày đặc biệt!" });
                }

                _context.NgayDacBiets.Remove(ngay);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Xóa ngày đặc biệt thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }
    }
}
