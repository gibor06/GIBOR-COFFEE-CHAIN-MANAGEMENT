using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.Services;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN", "QUAN_LY")]
    public class CaLamViecController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public CaLamViecController(QuanLyChuoiCaPheContext context, AuthService authService)
            : base(authService)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? search, byte? loaiCa)
        {
            var query = _context.CaLamViecs.AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(c => c.MaCa.Contains(search) || c.TenCa.Contains(search));
            }

            if (loaiCa.HasValue)
            {
                query = query.Where(c => c.LoaiCa == loaiCa.Value);
            }

            ViewBag.Search = search;
            ViewBag.LoaiCa = loaiCa;
            ViewBag.TongSoCa = await _context.CaLamViecs.CountAsync();

            return View(await query.OrderBy(c => c.MaCa).ToListAsync());
        }

        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(CaLamViec model)
        {
            ModelState.Remove("LichPhanCongs");

            if (string.IsNullOrWhiteSpace(model.MaCa))
            {
                ModelState.AddModelError("MaCa", "Mã ca không được để trống.");
            }
            if (string.IsNullOrWhiteSpace(model.TenCa))
            {
                ModelState.AddModelError("TenCa", "Tên ca không được để trống.");
            }
            if (model.LoaiCa != 1 && model.LoaiCa != 2)
            {
                ModelState.AddModelError("LoaiCa", "Loại ca chỉ nhận giá trị 1 (Fulltime) hoặc 2 (Parttime).");
            }
            if (model.HeSoCa <= 0)
            {
                ModelState.AddModelError("HeSoCa", "Hệ số ca phải lớn hơn 0.");
            }

            if (!string.IsNullOrWhiteSpace(model.MaCa) && await _context.CaLamViecs.AnyAsync(c => c.MaCa == model.MaCa))
            {
                ModelState.AddModelError("MaCa", "Mã ca đã tồn tại.");
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                _context.CaLamViecs.Add(model);
                await _context.SaveChangesAsync();
                TempData["Success"] = "Thêm ca làm việc thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            var ca = await _context.CaLamViecs.FindAsync(id);
            if (ca == null)
            {
                TempData["Error"] = "Không tìm thấy ca làm việc!";
                return RedirectToAction(nameof(Index));
            }
            return View(ca);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(CaLamViec model)
        {
            ModelState.Remove("LichPhanCongs");

            if (string.IsNullOrWhiteSpace(model.TenCa))
            {
                ModelState.AddModelError("TenCa", "Tên ca không được để trống.");
            }
            if (model.LoaiCa != 1 && model.LoaiCa != 2)
            {
                ModelState.AddModelError("LoaiCa", "Loại ca chỉ nhận giá trị 1 (Fulltime) hoặc 2 (Parttime).");
            }
            if (model.HeSoCa <= 0)
            {
                ModelState.AddModelError("HeSoCa", "Hệ số ca phải lớn hơn 0.");
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                var ca = await _context.CaLamViecs.FindAsync(model.MaCa);
                if (ca == null)
                {
                    TempData["Error"] = "Không tìm thấy ca làm việc!";
                    return RedirectToAction(nameof(Index));
                }

                ca.TenCa = model.TenCa;
                ca.LoaiCa = model.LoaiCa;
                ca.HeSoCa = model.HeSoCa;
                ca.GioBatDau = model.GioBatDau;
                ca.GioKetThuc = model.GioKetThuc;

                await _context.SaveChangesAsync();
                TempData["Success"] = "Cập nhật ca làm việc thành công!";
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
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
                var ca = await _context.CaLamViecs.FindAsync(id);
                if (ca == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy ca làm việc!" });
                }

                // Kiểm tra ca đã được dùng trong lịch phân công chưa
                var isUsed = await _context.LichPhanCongs.AnyAsync(l => l.MaCa == id);
                if (isUsed)
                {
                    return Json(new { success = false, message = "Không thể xóa ca này vì đã được sử dụng trong lịch phân công!" });
                }

                _context.CaLamViecs.Remove(ca);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Xóa ca làm việc thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }
    }
}
