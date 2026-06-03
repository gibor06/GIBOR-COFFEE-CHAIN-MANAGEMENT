using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Services;
using QuanLyChuoiCaPhe.Web.ViewModels;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    public class AccountController : Controller
    {
        private readonly AuthService _authService;
        private readonly QuanLyChuoiCaPheContext _context;
        private readonly PasswordService _passwordService;

        public AccountController(AuthService authService, QuanLyChuoiCaPheContext context, PasswordService passwordService)
        {
            _authService = authService;
            _context = context;
            _passwordService = passwordService;
        }

        [HttpGet]
        public IActionResult Login()
        {
            // Nếu đã đăng nhập thì chuyển về trang phù hợp với vai trò
            var maTK = _authService.GetCurrentMaTK();
            if (!string.IsNullOrEmpty(maTK))
            {
                var vaiTro = _authService.GetCurrentVaiTro();
                return vaiTro switch
                {
                    "ADMIN" => RedirectToAction("Index", "Dashboard"),
                    "QUAN_LY" => RedirectToAction("Index", "Dashboard"),
                    "NHAN_VIEN" => RedirectToAction("Menu", "SanPham"),
                    "KE_TOAN" => RedirectToAction("Index", "BangLuong"),
                    "KHO" => RedirectToAction("Index", "Kho"),
                    _ => RedirectToAction("Index", "Dashboard")
                };
            }

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                var taiKhoan = await _authService.LoginAsync(model.TenDangNhap, model.MatKhau);

                if (taiKhoan == null)
                {
                    TempData["Error"] = "Tên đăng nhập hoặc mật khẩu không đúng!";
                    return View(model);
                }

                await _authService.SetSessionAsync(taiKhoan);
                TempData["Success"] = $"Chào mừng {taiKhoan.TenDangNhap}!";

                // Redirect theo vai trò để tránh redirect loop
                return taiKhoan.VaiTro switch
                {
                    "ADMIN" => RedirectToAction("Index", "Dashboard"),
                    "QUAN_LY" => RedirectToAction("Index", "Dashboard"),
                    "NHAN_VIEN" => RedirectToAction("Menu", "SanPham"),
                    "KE_TOAN" => RedirectToAction("Index", "BangLuong"),
                    "KHO" => RedirectToAction("Index", "Kho"),
                    _ => RedirectToAction("Index", "Dashboard")
                };
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi đăng nhập: {ex.Message}";
                return View(model);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Logout()
        {
            _authService.ClearSession();
            TempData["Success"] = "Đăng xuất thành công!";
            return RedirectToAction("Login");
        }

        [HttpGet]
        [RoleAuthorize]
        public IActionResult ChangePassword()
        {
            var tenDangNhap = _authService.GetCurrentTenDangNhap();
            ViewBag.TenDangNhap = tenDangNhap;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize]
        public async Task<IActionResult> ChangePassword(string oldPassword, string newPassword, string confirmPassword)
        {
            try
            {
                var maTK = _authService.GetCurrentMaTK();
                if (string.IsNullOrEmpty(maTK))
                {
                    return RedirectToAction("Login");
                }

                // Validate input
                if (string.IsNullOrEmpty(oldPassword))
                {
                    TempData["Error"] = "Vui lòng nhập mật khẩu cũ!";
                    return View();
                }

                if (string.IsNullOrEmpty(newPassword))
                {
                    TempData["Error"] = "Vui lòng nhập mật khẩu mới!";
                    return View();
                }

                if (newPassword != confirmPassword)
                {
                    TempData["Error"] = "Mật khẩu mới và xác nhận không khớp!";
                    return View();
                }

                if (newPassword.Length < 6)
                {
                    TempData["Error"] = "Mật khẩu mới phải có ít nhất 6 ký tự!";
                    return View();
                }

                // Lấy tài khoản hiện tại
                var taiKhoan = await _context.HeThongTaiKhoans.FindAsync(maTK);
                if (taiKhoan == null)
                {
                    TempData["Error"] = "Không tìm thấy tài khoản!";
                    return View();
                }

                // Kiểm tra mật khẩu cũ
                // TODO: So sánh với hash khi implement password hashing
                if (!_passwordService.VerifyPassword(taiKhoan, oldPassword, out _))
                {
                    TempData["Error"] = "Mật khẩu cũ không đúng!";
                    return View();
                }

                // Không cho đổi sang mật khẩu giống cũ
                if (oldPassword == newPassword)
                {
                    TempData["Error"] = "Mật khẩu mới phải khác mật khẩu cũ!";
                    return View();
                }

                // Cập nhật mật khẩu mới
                // TODO: Hash password khi implement password hashing
                taiKhoan.MatKhauHash = _passwordService.HashPassword(taiKhoan, newPassword);
                await _context.SaveChangesAsync();

                TempData["Success"] = "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.";
                
                // Đăng xuất để bắt đăng nhập lại với mật khẩu mới
                _authService.ClearSession();
                return RedirectToAction("Login");
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                return View();
            }
        }
    }
}
