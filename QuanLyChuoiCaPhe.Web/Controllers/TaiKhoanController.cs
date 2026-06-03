using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.Services;
using System.Text.RegularExpressions;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN")]
    public class TaiKhoanController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;
        private readonly PasswordService _passwordService;

        public TaiKhoanController(QuanLyChuoiCaPheContext context, AuthService authService, PasswordService passwordService)
            : base(authService)
        {
            _context = context;
            _passwordService = passwordService;
        }

        // Helper method: Validate password strength
        private (bool isValid, string message) ValidatePassword(string password)
        {
            if (string.IsNullOrWhiteSpace(password))
                return (false, "Mật khẩu không được để trống");

            if (password.Length < 6)
                return (false, "Mật khẩu phải có ít nhất 6 ký tự");

            if (password.Length > 50)
                return (false, "Mật khẩu không được quá 50 ký tự");

            // Check for at least one letter and one number
            if (!Regex.IsMatch(password, @"[a-zA-Z]") || !Regex.IsMatch(password, @"\d"))
                return (false, "Mật khẩu phải chứa cả chữ và số");

            return (true, string.Empty);
        }

        // Helper method: Validate username
        private (bool isValid, string message) ValidateUsername(string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                return (false, "Tên đăng nhập không được để trống");

            if (username.Length < 3)
                return (false, "Tên đăng nhập phải có ít nhất 3 ký tự");

            if (username.Length > 50)
                return (false, "Tên đăng nhập không được quá 50 ký tự");

            // Only allow alphanumeric and underscore
            if (!Regex.IsMatch(username, @"^[a-zA-Z0-9_]+$"))
                return (false, "Tên đăng nhập chỉ được chứa chữ, số và dấu gạch dưới");

            return (true, string.Empty);
        }

        private static bool IsValidRole(string role)
        {
            return role is "ADMIN" or "QUAN_LY" or "NHAN_VIEN" or "KHO" or "KE_TOAN";
        }

        // Helper method: Generate next account ID
        private async Task<string> GenerateNextMaTK()
        {
            var existingCodes = await _context.HeThongTaiKhoans
                .AsNoTracking()
                .Select(t => t.MaTK)
                .ToListAsync();

            return CodeGenerator.GenerateNext("TK", 8, existingCodes);
        }

        // GET: TaiKhoan/Index
        public async Task<IActionResult> Index(string? search, string? vaiTro, bool? trangThai, int page = 1, int pageSize = 20)
        {
            var query = _context.HeThongTaiKhoans
                .Include(t => t.TaiKhoanNhanViens)
                    .ThenInclude(tn => tn.ThongTinNhanVien)
                        .ThenInclude(nv => nv.ChiNhanh)
                .AsQueryable();

            // Search filter
            if (!string.IsNullOrEmpty(search))
            {
                search = search.Trim();
                query = query.Where(t => 
                    t.TenDangNhap.Contains(search) || 
                    t.MaTK.Contains(search) ||
                    t.TaiKhoanNhanViens.Any(tn => tn.ThongTinNhanVien.HoTenNV.Contains(search))
                );
            }

            // Role filter
            if (!string.IsNullOrEmpty(vaiTro))
            {
                query = query.Where(t => t.VaiTro == vaiTro);
            }

            // Status filter
            if (trangThai.HasValue)
            {
                query = query.Where(t => t.TrangThai == trangThai.Value);
            }

            // Get total count for pagination
            var totalRecords = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalRecords / (double)pageSize);

            // Apply pagination
            var accounts = await query
                .OrderByDescending(t => t.NgayTao)
                .ThenBy(t => t.TenDangNhap)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Pass data to view
            ViewBag.Search = search;
            ViewBag.VaiTro = vaiTro;
            ViewBag.TrangThai = trangThai;
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.TotalRecords = totalRecords;
            ViewBag.PageSize = pageSize;

            // Statistics
            ViewBag.TotalAccounts = await _context.HeThongTaiKhoans.CountAsync();
            ViewBag.ActiveAccounts = await _context.HeThongTaiKhoans.CountAsync(t => t.TrangThai);
            ViewBag.InactiveAccounts = await _context.HeThongTaiKhoans.CountAsync(t => !t.TrangThai);
            ViewBag.AdminAccounts = await _context.HeThongTaiKhoans.CountAsync(t => t.VaiTro == "ADMIN");

            return View(accounts);
        }

        // GET: TaiKhoan/Create
        [HttpGet]
        public async Task<IActionResult> Create()
        {
            // Get employees without accounts
            var nhanViensWithAccount = await _context.TaiKhoanNhanViens
                .Select(t => t.MaNV)
                .ToListAsync();

            var nhanViensAvailable = await _context.ThongTinNhanViens
                .Include(n => n.ChiNhanh)
                .Include(n => n.ChucVuNhanVien)
                .Where(n => n.TrangThai == true && !nhanViensWithAccount.Contains(n.MaNV))
                .OrderBy(n => n.HoTenNV)
                .ToListAsync();

            ViewBag.NhanViens = nhanViensAvailable;
            
            // Create default model
            var model = new HeThongTaiKhoan
            {
                TrangThai = true,
                VaiTro = "NHAN_VIEN"
            };

            return View(model);
        }

        // POST: TaiKhoan/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(HeThongTaiKhoan model, string? maNV, string? confirmPassword)
        {
            // Remove validation for auto-generated fields
            ModelState.Remove("MaTK");
            ModelState.Remove("NgayTao");

            // Validate username
            var usernameValidation = ValidateUsername(model.TenDangNhap);
            if (!usernameValidation.isValid)
            {
                ModelState.AddModelError("TenDangNhap", usernameValidation.message);
            }

            // Validate password
            var passwordValidation = ValidatePassword(model.MatKhauHash);
            if (!passwordValidation.isValid)
            {
                ModelState.AddModelError("MatKhauHash", passwordValidation.message);
            }

            // Check password confirmation
            if (model.MatKhauHash != confirmPassword)
            {
                ModelState.AddModelError("confirmPassword", "Mật khẩu xác nhận không khớp!");
            }

            if (!IsValidRole(model.VaiTro))
            {
                ModelState.AddModelError("VaiTro", "Vai trò không hợp lệ!");
            }

            if (model.VaiTro != "ADMIN" && string.IsNullOrWhiteSpace(maNV))
            {
                ModelState.AddModelError("maNV", "Tài khoản không phải ADMIN phải liên kết với nhân viên hợp lệ!");
            }

            if (!string.IsNullOrWhiteSpace(maNV))
            {
                var employeeExists = await _context.ThongTinNhanViens
                    .AnyAsync(n => n.MaNV == maNV && n.TrangThai);

                if (!employeeExists)
                {
                    ModelState.AddModelError("maNV", "Nhân viên liên kết không hợp lệ hoặc đã nghỉ việc!");
                }
            }

            // Check if username already exists
            var usernameExists = await _context.HeThongTaiKhoans
                .AnyAsync(t => t.TenDangNhap.ToLower() == model.TenDangNhap.ToLower());
            
            if (usernameExists)
            {
                ModelState.AddModelError("TenDangNhap", "Tên đăng nhập đã tồn tại!");
            }

            if (!ModelState.IsValid)
            {
                // Reload employee list
                var nhanViensWithAccount = await _context.TaiKhoanNhanViens
                    .Select(t => t.MaNV)
                    .ToListAsync();
                var nhanViensAvailable = await _context.ThongTinNhanViens
                    .Include(n => n.ChiNhanh)
                    .Include(n => n.ChucVuNhanVien)
                    .Where(n => n.TrangThai == true && !nhanViensWithAccount.Contains(n.MaNV))
                    .OrderBy(n => n.HoTenNV)
                    .ToListAsync();
                ViewBag.NhanViens = nhanViensAvailable;
                return View(model);
            }

            try
            {
                // Generate account ID
                model.MaTK = await GenerateNextMaTK();
                
                // Set creation date
                model.NgayTao = DateTime.Now;

                // Hash password
                model.MatKhauHash = _passwordService.HashPassword(model, model.MatKhauHash);

                // Add account
                _context.HeThongTaiKhoans.Add(model);
                await _context.SaveChangesAsync();

                // Link with employee if selected
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

                TempData["Success"] = $"Tạo tài khoản '{model.TenDangNhap}' thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi khi tạo tài khoản: {ex.InnerException?.Message ?? ex.Message}";
                
                // Reload employee list
                var nhanViensWithAccount = await _context.TaiKhoanNhanViens
                    .Select(t => t.MaNV)
                    .ToListAsync();
                var nhanViensAvailable = await _context.ThongTinNhanViens
                    .Include(n => n.ChiNhanh)
                    .Include(n => n.ChucVuNhanVien)
                    .Where(n => n.TrangThai == true && !nhanViensWithAccount.Contains(n.MaNV))
                    .OrderBy(n => n.HoTenNV)
                    .ToListAsync();
                ViewBag.NhanViens = nhanViensAvailable;
                return View(model);
            }
        }

        // GET: TaiKhoan/Edit/{id}
        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return NotFound();
            }

            var taiKhoan = await _context.HeThongTaiKhoans
                .Include(t => t.TaiKhoanNhanViens)
                    .ThenInclude(tn => tn.ThongTinNhanVien)
                        .ThenInclude(nv => nv.ChiNhanh)
                .FirstOrDefaultAsync(t => t.MaTK == id);

            if (taiKhoan == null)
            {
                return NotFound();
            }

            return View(taiKhoan);
        }

        // POST: TaiKhoan/Edit/{id}
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, HeThongTaiKhoan model)
        {
            if (id != model.MaTK)
            {
                return NotFound();
            }

            // Remove validation for password and date fields
            ModelState.Remove("MatKhauHash");
            ModelState.Remove("NgayTao");

            // Validate username
            var usernameValidation = ValidateUsername(model.TenDangNhap);
            if (!usernameValidation.isValid)
            {
                ModelState.AddModelError("TenDangNhap", usernameValidation.message);
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            if (!IsValidRole(model.VaiTro))
            {
                ModelState.AddModelError("VaiTro", "Vai trò không hợp lệ!");
                return View(model);
            }

            try
            {
                var taiKhoan = await _context.HeThongTaiKhoans.FindAsync(id);
                if (taiKhoan == null)
                {
                    return NotFound();
                }

                var hasEmployeeLink = await _context.TaiKhoanNhanViens.AnyAsync(t => t.MaTK == id);
                if (model.VaiTro != "ADMIN" && !hasEmployeeLink)
                {
                    ModelState.AddModelError("VaiTro", "Tài khoản không phải ADMIN phải liên kết với nhân viên hợp lệ!");
                    return View(model);
                }

                // Check if username already exists (except current account)
                var usernameExists = await _context.HeThongTaiKhoans
                    .AnyAsync(t => t.TenDangNhap.ToLower() == model.TenDangNhap.ToLower() && t.MaTK != id);
                
                if (usernameExists)
                {
                    ModelState.AddModelError("TenDangNhap", "Tên đăng nhập đã tồn tại!");
                    return View(model);
                }

                // Update account info (don't update password here)
                taiKhoan.TenDangNhap = model.TenDangNhap;
                taiKhoan.VaiTro = model.VaiTro;
                taiKhoan.TrangThai = model.TrangThai;

                await _context.SaveChangesAsync();

                TempData["Success"] = $"Cập nhật tài khoản '{taiKhoan.TenDangNhap}' thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi khi cập nhật: {ex.InnerException?.Message ?? ex.Message}";
                return View(model);
            }
        }

        // GET: TaiKhoan/ResetPassword/{id}
        [HttpGet]
        public async Task<IActionResult> ResetPassword(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return NotFound();
            }

            var taiKhoan = await _context.HeThongTaiKhoans
                .Include(t => t.TaiKhoanNhanViens)
                    .ThenInclude(tn => tn.ThongTinNhanVien)
                .FirstOrDefaultAsync(t => t.MaTK == id);

            if (taiKhoan == null)
            {
                return NotFound();
            }

            ViewBag.TaiKhoan = taiKhoan;
            return View();
        }

        // POST: TaiKhoan/ResetPassword/{id}
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetPassword(string id, string newPassword, string confirmPassword)
        {
            try
            {
                // Validate new password
                var passwordValidation = ValidatePassword(newPassword);
                if (!passwordValidation.isValid)
                {
                    TempData["Error"] = passwordValidation.message;
                    return RedirectToAction(nameof(ResetPassword), new { id });
                }

                // Check password confirmation
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

                // Hash and update password
                taiKhoan.MatKhauHash = _passwordService.HashPassword(taiKhoan, newPassword);
                await _context.SaveChangesAsync();

                TempData["Success"] = $"Đặt lại mật khẩu cho tài khoản '{taiKhoan.TenDangNhap}' thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi khi đặt lại mật khẩu: {ex.InnerException?.Message ?? ex.Message}";
                return RedirectToAction(nameof(ResetPassword), new { id });
            }
        }

        // POST: TaiKhoan/Delete/{id}
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string id)
        {
            try
            {
                var taiKhoan = await _context.HeThongTaiKhoans
                    .Include(t => t.TaiKhoanNhanViens)
                    .FirstOrDefaultAsync(t => t.MaTK == id);

                if (taiKhoan == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy tài khoản!" });
                }

                // Don't allow deleting current logged-in account
                var currentMaTK = HttpContext.Session.GetString("MaTK");
                if (taiKhoan.MaTK == currentMaTK)
                {
                    return Json(new { success = false, message = "Không thể xóa tài khoản đang đăng nhập!" });
                }

                // Don't allow deleting admin accounts
                if (taiKhoan.VaiTro == "ADMIN")
                {
                    var adminCount = await _context.HeThongTaiKhoans.CountAsync(t => t.VaiTro == "ADMIN");
                    if (adminCount <= 1)
                    {
                        return Json(new { success = false, message = "Không thể xóa tài khoản ADMIN duy nhất!" });
                    }
                }

                // Check if linked with employee
                if (taiKhoan.TaiKhoanNhanViens.Any())
                {
                    return Json(new { 
                        success = false, 
                        message = "Không thể xóa tài khoản đã liên kết với nhân viên! Hãy khóa tài khoản thay vì xóa." 
                    });
                }

                _context.HeThongTaiKhoans.Remove(taiKhoan);
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = $"Đã xóa tài khoản '{taiKhoan.TenDangNhap}' thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}" });
            }
        }

        // POST: TaiKhoan/ToggleStatus/{id}
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleStatus(string id)
        {
            try
            {
                var taiKhoan = await _context.HeThongTaiKhoans.FindAsync(id);
                if (taiKhoan == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy tài khoản!" });
                }

                // Don't allow locking current logged-in account
                var currentMaTK = HttpContext.Session.GetString("MaTK");
                if (taiKhoan.MaTK == currentMaTK && taiKhoan.TrangThai)
                {
                    return Json(new { success = false, message = "Không thể khóa tài khoản đang đăng nhập!" });
                }

                // Don't allow locking the last active admin
                if (taiKhoan.VaiTro == "ADMIN" && taiKhoan.TrangThai)
                {
                    var activeAdminCount = await _context.HeThongTaiKhoans
                        .CountAsync(t => t.VaiTro == "ADMIN" && t.TrangThai);
                    
                    if (activeAdminCount <= 1)
                    {
                        return Json(new { success = false, message = "Không thể khóa tài khoản ADMIN duy nhất đang hoạt động!" });
                    }
                }

                // Toggle status
                taiKhoan.TrangThai = !taiKhoan.TrangThai;
                await _context.SaveChangesAsync();

                var statusText = taiKhoan.TrangThai ? "mở khóa" : "khóa";
                return Json(new { 
                    success = true, 
                    message = $"Đã {statusText} tài khoản '{taiKhoan.TenDangNhap}' thành công!",
                    newStatus = taiKhoan.TrangThai
                });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}" });
            }
        }

        // GET: TaiKhoan/Details/{id}
        [HttpGet]
        public async Task<IActionResult> Details(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return NotFound();
            }

            var taiKhoan = await _context.HeThongTaiKhoans
                .Include(t => t.TaiKhoanNhanViens)
                    .ThenInclude(tn => tn.ThongTinNhanVien)
                        .ThenInclude(nv => nv.ChiNhanh)
                .Include(t => t.TaiKhoanNhanViens)
                    .ThenInclude(tn => tn.ThongTinNhanVien)
                        .ThenInclude(nv => nv.ChucVuNhanVien)
                .FirstOrDefaultAsync(t => t.MaTK == id);

            if (taiKhoan == null)
            {
                return NotFound();
            }

            return View(taiKhoan);
        }
    }
}
