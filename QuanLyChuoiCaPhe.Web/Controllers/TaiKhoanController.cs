using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.Services;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN")]
    public class TaiKhoanController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public TaiKhoanController(QuanLyChuoiCaPheContext context, AuthService authService) 
            : base(authService)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? search, string? vaiTro, bool? trangThai)
        {
            var query = _context.HeThongTaiKhoans
                .Include(t => t.TaiKhoanNhanViens)
                    .ThenInclude(tn => tn.ThongTinNhanVien)
                .AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(t => t.TenDangNhap.Contains(search) || t.MaTK.Contains(search));
            }

            if (!string.IsNullOrEmpty(vaiTro))
            {
                query = query.Where(t => t.VaiTro == vaiTro);
            }

            if (trangThai.HasValue)
            {
                query = query.Where(t => t.TrangThai == trangThai.Value);
            }

            ViewBag.Search = search;
            ViewBag.VaiTro = vaiTro;
            ViewBag.TrangThai = trangThai;

            return View(await query.OrderBy(t => t.TenDangNhap).ToListAsync());
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            // Lấy danh sách nhân viên chưa có tài khoản
            var nhanViensWithAccount = await _context.TaiKhoanNhanViens
                .Select(t => t.MaNV)
                .ToListAsync();

            var nhanViensAvailable = await _context.ThongTinNhanViens
                .Include(n => n.ChiNhanh)  // Include ChiNhanh
                .Where(n => n.TrangThai == true && !nhanViensWithAccount.Contains(n.MaNV))
                .OrderBy(n => n.HoTenNV)
                .ToListAsync();

            ViewBag.NhanViens = nhanViensAvailable;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(HeThongTaiKhoan model, string? maNV)
        {
            // Remove validation for auto-generated fields
            ModelState.Remove("MaTK");

            if (!ModelState.IsValid)
            {
                // Reload danh sách nhân viên
                var nhanViensWithAccount = await _context.TaiKhoanNhanViens
                    .Select(t => t.MaNV)
                    .ToListAsync();
                var nhanViensAvailable = await _context.ThongTinNhanViens
                    .Include(n => n.ChiNhanh)  // Include ChiNhanh
                    .Where(n => n.TrangThai == true && !nhanViensWithAccount.Contains(n.MaNV))
                    .OrderBy(n => n.HoTenNV)
                    .ToListAsync();
                ViewBag.NhanViens = nhanViensAvailable;
                return View(model);
            }

            try
            {
                // Kiểm tra tên đăng nhập đã tồn tại chưa
                var exists = await _context.HeThongTaiKhoans
                    .AnyAsync(t => t.TenDangNhap == model.TenDangNhap);
                
                if (exists)
                {
                    TempData["Error"] = "Tên đăng nhập đã tồn tại!";
                    // Reload danh sách nhân viên
                    var nhanViensWithAccount = await _context.TaiKhoanNhanViens
                        .Select(t => t.MaNV)
                        .ToListAsync();
                    var nhanViensAvailable = await _context.ThongTinNhanViens
                        .Include(n => n.ChiNhanh)  // Include ChiNhanh
                        .Where(n => n.TrangThai == true && !nhanViensWithAccount.Contains(n.MaNV))
                        .OrderBy(n => n.HoTenNV)
                        .ToListAsync();
                    ViewBag.NhanViens = nhanViensAvailable;
                    return View(model);
                }

                // Tạo mã tài khoản tự động
                var lastTK = await _context.HeThongTaiKhoans
                    .OrderByDescending(t => t.MaTK)
                    .FirstOrDefaultAsync();
                
                int nextNumber = 1;
                if (lastTK != null && lastTK.MaTK.StartsWith("TK"))
                {
                    if (int.TryParse(lastTK.MaTK.Substring(2), out int lastNumber))
                    {
                        nextNumber = lastNumber + 1;
                    }
                }
                model.MaTK = $"TK{nextNumber:D3}";

                // Set ngày tạo
                model.NgayTao = DateTime.Now;

                // TODO: Hash password (hiện tại lưu trực tiếp để test)
                // model.MatKhauHash = HashPassword(model.MatKhauHash);

                _context.HeThongTaiKhoans.Add(model);
                await _context.SaveChangesAsync();

                // Nếu có chọn nhân viên, tạo liên kết
                if (!string.IsNullOrEmpty(maNV))
                {
                    var taiKhoanNV = new TaiKhoanNhanVien
                    {
                        MaTK = model.MaTK,
                        MaNV = maNV
                    };
                    _context.TaiKhoanNhanViens.Add(taiKhoanNV);
                    await _context.SaveChangesAsync();
                }

                TempData["Success"] = "Tạo tài khoản thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                // Reload danh sách nhân viên
                var nhanViensWithAccount = await _context.TaiKhoanNhanViens
                    .Select(t => t.MaNV)
                    .ToListAsync();
                var nhanViensAvailable = await _context.ThongTinNhanViens
                    .Include(n => n.ChiNhanh)  // Include ChiNhanh
                    .Where(n => n.TrangThai == true && !nhanViensWithAccount.Contains(n.MaNV))
                    .OrderBy(n => n.HoTenNV)
                    .ToListAsync();
                ViewBag.NhanViens = nhanViensAvailable;
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return NotFound();
            }

            var taiKhoan = await _context.HeThongTaiKhoans.FindAsync(id);
            if (taiKhoan == null)
            {
                return NotFound();
            }

            return View(taiKhoan);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, HeThongTaiKhoan model)
        {
            if (id != model.MaTK)
            {
                return NotFound();
            }

            // Remove validation for password (không bắt buộc khi edit)
            ModelState.Remove("MatKhauHash");

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                var taiKhoan = await _context.HeThongTaiKhoans.FindAsync(id);
                if (taiKhoan == null)
                {
                    return NotFound();
                }

                // Kiểm tra tên đăng nhập đã tồn tại chưa (trừ chính nó)
                var exists = await _context.HeThongTaiKhoans
                    .AnyAsync(t => t.TenDangNhap == model.TenDangNhap && t.MaTK != id);
                
                if (exists)
                {
                    TempData["Error"] = "Tên đăng nhập đã tồn tại!";
                    return View(model);
                }

                // Cập nhật thông tin (không cập nhật mật khẩu ở đây)
                taiKhoan.TenDangNhap = model.TenDangNhap;
                taiKhoan.VaiTro = model.VaiTro;
                taiKhoan.TrangThai = model.TrangThai;

                await _context.SaveChangesAsync();

                TempData["Success"] = "Cập nhật tài khoản thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> ResetPassword(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return NotFound();
            }

            var taiKhoan = await _context.HeThongTaiKhoans.FindAsync(id);
            if (taiKhoan == null)
            {
                return NotFound();
            }

            ViewBag.MaTK = taiKhoan.MaTK;
            ViewBag.TenDangNhap = taiKhoan.TenDangNhap;

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetPassword(string id, string newPassword, string confirmPassword)
        {
            try
            {
                if (string.IsNullOrEmpty(newPassword))
                {
                    TempData["Error"] = "Vui lòng nhập mật khẩu mới!";
                    return RedirectToAction(nameof(ResetPassword), new { id });
                }

                if (newPassword != confirmPassword)
                {
                    TempData["Error"] = "Mật khẩu xác nhận không khớp!";
                    return RedirectToAction(nameof(ResetPassword), new { id });
                }

                var taiKhoan = await _context.HeThongTaiKhoans.FindAsync(id);
                if (taiKhoan == null)
                {
                    return NotFound();
                }

                // TODO: Hash password (hiện tại lưu trực tiếp để test)
                // taiKhoan.MatKhauHash = HashPassword(newPassword);
                taiKhoan.MatKhauHash = newPassword;

                await _context.SaveChangesAsync();

                TempData["Success"] = "Đặt lại mật khẩu thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                return RedirectToAction(nameof(ResetPassword), new { id });
            }
        }

        [HttpPost]
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
                var taiKhoan = await _context.HeThongTaiKhoans.FindAsync(id);
                if (taiKhoan == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy tài khoản!" });
                }

                // Không cho xóa tài khoản đang đăng nhập
                var currentMaTK = HttpContext.Session.GetString("MaTK");
                if (taiKhoan.MaTK == currentMaTK)
                {
                    return Json(new { success = false, message = "Không thể xóa tài khoản đang đăng nhập!" });
                }

                // Kiểm tra xem có liên kết với nhân viên không
                var hasEmployee = await _context.TaiKhoanNhanViens
                    .AnyAsync(t => t.MaTK == id);

                if (hasEmployee)
                {
                    return Json(new { success = false, message = "Không thể xóa tài khoản đã liên kết với nhân viên! Hãy khóa tài khoản thay vì xóa." });
                }

                _context.HeThongTaiKhoans.Remove(taiKhoan);
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Xóa tài khoản thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> ToggleStatus(string id)
        {
            try
            {
                var taiKhoan = await _context.HeThongTaiKhoans.FindAsync(id);
                if (taiKhoan == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy tài khoản!" });
                }

                // Chỉ ADMIN mới được khóa/mở tài khoản
                var currentVaiTro = HttpContext.Session.GetString("VaiTro");
                if (currentVaiTro != "ADMIN")
                {
                    return Json(new { success = false, message = "Bạn không có quyền thực hiện thao tác này!" });
                }

                taiKhoan.TrangThai = !taiKhoan.TrangThai;
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Cập nhật trạng thái thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }
    }
}
