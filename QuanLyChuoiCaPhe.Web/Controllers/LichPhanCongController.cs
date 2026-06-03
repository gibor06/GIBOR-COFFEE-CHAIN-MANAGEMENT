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
    public class LichPhanCongController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public LichPhanCongController(QuanLyChuoiCaPheContext context, AuthService authService)
            : base(authService)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(DateTime? ngay, string? maNV, string? maCa, string? trangThai, int? thang, int? nam)
        {
            var query = _context.LichPhanCongs
                .Include(l => l.ThongTinNhanVien)
                .Include(l => l.CaLamViec)
                .AsQueryable();

            // Phân quyền theo chi nhánh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(l => l.ThongTinNhanVien!.MaChiNhanh == chiNhanhFilter);
            }

            if (ngay.HasValue)
            {
                query = query.Where(l => l.NgayLamViec.Date == ngay.Value.Date);
            }

            if (!string.IsNullOrEmpty(maNV))
            {
                query = query.Where(l => l.MaNV == maNV);
            }

            if (!string.IsNullOrEmpty(maCa))
            {
                query = query.Where(l => l.MaCa == maCa);
            }

            if (!string.IsNullOrEmpty(trangThai))
            {
                query = query.Where(l => l.TrangThai == trangThai);
            }

            if (thang.HasValue && nam.HasValue)
            {
                query = query.Where(l => l.NgayLamViec.Month == thang.Value && l.NgayLamViec.Year == nam.Value);
            }
            else if (nam.HasValue)
            {
                query = query.Where(l => l.NgayLamViec.Year == nam.Value);
            }

            ViewBag.Ngay = ngay;
            ViewBag.MaNV = maNV;
            ViewBag.MaCa = maCa;
            ViewBag.TrangThai = trangThai;
            ViewBag.Thang = thang;
            ViewBag.Nam = nam;

            await LoadDropdownsAsync();

            return View(await query.OrderByDescending(l => l.NgayLamViec).ThenBy(l => l.MaNV).ToListAsync());
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            await LoadDropdownsAsync();
            var model = new LichPhanCong
            {
                NgayLamViec = DateTime.Today,
                TrangThai = "Đã phân công"
            };
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(LichPhanCong model)
        {
            ModelState.Remove("ThongTinNhanVien");
            ModelState.Remove("CaLamViec");
            ModelState.Remove("ChamCongs");
            ModelState.Remove("MaLich");

            // Validate nhân viên tồn tại
            var nv = await _context.ThongTinNhanViens.FindAsync(model.MaNV);
            if (nv == null)
            {
                ModelState.AddModelError("MaNV", "Nhân viên không tồn tại.");
            }
            else
            {
                // Kiểm tra quyền chi nhánh
                if (!CanAccessChiNhanh(nv.MaChiNhanh))
                {
                    ModelState.AddModelError("MaNV", "Bạn không có quyền phân công nhân viên chi nhánh khác.");
                }
                // Kiểm tra nhân viên đã nghỉ việc
                if (!nv.TrangThai || nv.NgayNghiViec != null)
                {
                    ModelState.AddModelError("MaNV", "Không thể phân ca cho nhân viên đã nghỉ việc.");
                }
                // Kiểm tra ngày phân công không trước ngày vào làm
                if (model.NgayLamViec.Date < nv.NgayVaoLam.Date)
                {
                    ModelState.AddModelError("NgayLamViec", "Không thể phân ca trước ngày vào làm của nhân viên.");
                }
            }

            // Validate ca tồn tại
            if (!await _context.CaLamViecs.AnyAsync(c => c.MaCa == model.MaCa))
            {
                ModelState.AddModelError("MaCa", "Ca làm việc không tồn tại.");
            }

            // Validate trạng thái
            var validTrangThai = new[] { "Đã phân công", "Hủy ca", "Nghỉ phép" };
            if (!validTrangThai.Contains(model.TrangThai))
            {
                ModelState.AddModelError("TrangThai", "Trạng thái không hợp lệ.");
            }

            // Kiểm tra trùng
            if (await _context.LichPhanCongs.AnyAsync(l =>
                l.MaNV == model.MaNV && l.MaCa == model.MaCa && l.NgayLamViec.Date == model.NgayLamViec.Date))
            {
                ModelState.AddModelError("", "Lịch phân công trùng: Nhân viên này đã được phân ca này vào ngày này.");
            }

            if (!ModelState.IsValid)
            {
                await LoadDropdownsAsync();
                return View(model);
            }

            try
            {
                // Auto generate MaLich
                model.MaLich = await GenerateMaLichAsync();
                _context.LichPhanCongs.Add(model);
                await _context.SaveChangesAsync();
                TempData["Success"] = "Thêm lịch phân công thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                var errorMsg = ex.InnerException?.Message ?? ex.Message;
                TempData["Error"] = $"Lỗi: {errorMsg}";
                await LoadDropdownsAsync();
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            var lich = await _context.LichPhanCongs
                .Include(l => l.ThongTinNhanVien)
                .Include(l => l.CaLamViec)
                .FirstOrDefaultAsync(l => l.MaLich == id);

            if (lich == null)
            {
                TempData["Error"] = "Không tìm thấy lịch phân công!";
                return RedirectToAction(nameof(Index));
            }

            // Kiểm tra quyền chi nhánh
            if (lich.ThongTinNhanVien != null && !CanAccessChiNhanh(lich.ThongTinNhanVien.MaChiNhanh))
            {
                TempData["Error"] = "Bạn không có quyền chỉnh sửa lịch này!";
                return RedirectToAction(nameof(Index));
            }

            return View(lich);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(LichPhanCong model)
        {
            ModelState.Remove("ThongTinNhanVien");
            ModelState.Remove("CaLamViec");
            ModelState.Remove("ChamCongs");

            var validTrangThai = new[] { "Đã phân công", "Hủy ca", "Nghỉ phép" };
            if (!validTrangThai.Contains(model.TrangThai))
            {
                ModelState.AddModelError("TrangThai", "Trạng thái không hợp lệ.");
            }

            if (!ModelState.IsValid)
            {
                var lichReload = await _context.LichPhanCongs
                    .Include(l => l.ThongTinNhanVien)
                    .Include(l => l.CaLamViec)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(l => l.MaLich == model.MaLich);
                if (lichReload != null)
                {
                    model.ThongTinNhanVien = lichReload.ThongTinNhanVien;
                    model.CaLamViec = lichReload.CaLamViec;
                    model.MaNV = lichReload.MaNV;
                    model.MaCa = lichReload.MaCa;
                    model.NgayLamViec = lichReload.NgayLamViec;
                }
                return View(model);
            }

            try
            {
                var lich = await _context.LichPhanCongs
                    .Include(l => l.ThongTinNhanVien)
                    .FirstOrDefaultAsync(l => l.MaLich == model.MaLich);

                if (lich == null)
                {
                    TempData["Error"] = "Không tìm thấy lịch phân công!";
                    return RedirectToAction(nameof(Index));
                }

                if (lich.ThongTinNhanVien != null && !CanAccessChiNhanh(lich.ThongTinNhanVien.MaChiNhanh))
                {
                    TempData["Error"] = "Bạn không có quyền chỉnh sửa lịch này!";
                    return RedirectToAction(nameof(Index));
                }

                lich.TrangThai = model.TrangThai;
                lich.GhiChu = model.GhiChu;

                await _context.SaveChangesAsync();
                TempData["Success"] = "Cập nhật lịch phân công thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                var lichReload = await _context.LichPhanCongs
                    .Include(l => l.ThongTinNhanVien)
                    .Include(l => l.CaLamViec)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(l => l.MaLich == model.MaLich);
                if (lichReload != null)
                {
                    model.ThongTinNhanVien = lichReload.ThongTinNhanVien;
                    model.CaLamViec = lichReload.CaLamViec;
                    model.MaNV = lichReload.MaNV;
                    model.MaCa = lichReload.MaCa;
                    model.NgayLamViec = lichReload.NgayLamViec;
                }
                return View(model);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
                var lich = await _context.LichPhanCongs
                    .Include(l => l.ThongTinNhanVien)
                    .FirstOrDefaultAsync(l => l.MaLich == id);

                if (lich == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy lịch phân công!" });
                }

                if (lich.ThongTinNhanVien != null && !CanAccessChiNhanh(lich.ThongTinNhanVien.MaChiNhanh))
                {
                    return Json(new { success = false, message = "Bạn không có quyền xóa lịch này!" });
                }

                // Kiểm tra đã có chấm công chưa
                var hasChamCong = await _context.ChamCongs.AnyAsync(c => c.MaLich == id);
                if (hasChamCong)
                {
                    return Json(new { success = false, message = "Không thể xóa lịch phân công đã có chấm công!" });
                }

                _context.LichPhanCongs.Remove(lich);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Xóa lịch phân công thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        private async Task LoadDropdownsAsync()
        {
            var chiNhanhFilter = GetChiNhanhFilter();
            var nhanViensQuery = _context.ThongTinNhanViens.Where(n => n.TrangThai);
            if (chiNhanhFilter != null)
            {
                nhanViensQuery = nhanViensQuery.Where(n => n.MaChiNhanh == chiNhanhFilter);
            }

            var nhanViens = await nhanViensQuery.OrderBy(n => n.HoTenNV).ToListAsync();
            ViewBag.NhanViens = nhanViens.Select(n => new SelectListItem
            {
                Value = n.MaNV,
                Text = $"{n.MaNV} - {n.HoTenNV}"
            }).ToList();

            var caLamViecs = await _context.CaLamViecs.OrderBy(c => c.MaCa).ToListAsync();
            ViewBag.CaLamViecs = caLamViecs.Select(c => new SelectListItem
            {
                Value = c.MaCa,
                Text = $"{c.MaCa} - {c.TenCa} ({c.GioBatDau:hh\\:mm} - {c.GioKetThuc:hh\\:mm})"
            }).ToList();
        }

        private async Task<string> GenerateMaLichAsync()
        {
            var existingCodes = await _context.LichPhanCongs
                .AsNoTracking()
                .Select(l => l.MaLich)
                .ToListAsync();

            return CodeGenerator.GenerateNext("LPC", 7, existingCodes);
        }
    }
}
