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
    public class NhanVienController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public NhanVienController(QuanLyChuoiCaPheContext context, AuthService authService) 
            : base(authService)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? search, string? chiNhanh, string? chucVu, bool? trangThai)
        {
            var query = _context.ThongTinNhanViens
                .Include(n => n.ChiNhanh)
                .Include(n => n.ChucVuNhanVien)
                .AsQueryable();

            // Phân quyền theo chi nhánh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(n => n.MaChiNhanh == chiNhanhFilter);
            }

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(n => n.HoTenNV.Contains(search) 
                                      || n.SoDienThoai.Contains(search) 
                                      || n.Email!.Contains(search));
            }

            if (!string.IsNullOrEmpty(chiNhanh))
            {
                query = query.Where(n => n.MaChiNhanh == chiNhanh);
            }

            if (!string.IsNullOrEmpty(chucVu))
            {
                query = query.Where(n => n.MaChucVu == chucVu);
            }

            if (trangThai.HasValue)
            {
                query = query.Where(n => n.TrangThai == trangThai.Value);
            }

            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = await chiNhanhsQuery.ToListAsync();
            ViewBag.ChucVus = await _context.ChucVuNhanViens.ToListAsync();
            ViewBag.Search = search;
            ViewBag.ChiNhanh = chiNhanh;
            ViewBag.ChucVu = chucVu;
            ViewBag.TrangThai = trangThai;

            return View(await query.OrderBy(n => n.HoTenNV).ToListAsync());
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhFilter = GetChiNhanhFilter();
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
            ViewBag.ChucVus = new SelectList(await _context.ChucVuNhanViens.ToListAsync(), "MaChucVu", "TenChucVu");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ThongTinNhanVien model)
        {
            // Kiểm tra quyền truy cập chi nhánh
            var accessCheck = CheckChiNhanhAccess(model.MaChiNhanh);
            if (accessCheck != null) return accessCheck;

            // Xóa validation errors cho navigation properties
            ModelState.Remove("ChucVuNhanVien");
            ModelState.Remove("ChiNhanh");
            ModelState.Remove("DonHangs");
            ModelState.Remove("BangLuongs");
            
            // TẠM THỜI BỎ QUA VALIDATION ĐỂ TEST
            ModelState.Clear();
            
            // Validate thủ công các trường bắt buộc
            if (string.IsNullOrEmpty(model.HoTenNV))
            {
                ModelState.AddModelError("HoTenNV", "Họ tên là bắt buộc");
            }
            if (string.IsNullOrEmpty(model.SoDienThoai))
            {
                ModelState.AddModelError("SoDienThoai", "Số điện thoại là bắt buộc");
            }
            if (string.IsNullOrEmpty(model.SoCanCuoc))
            {
                ModelState.AddModelError("SoCanCuoc", "Số căn cước là bắt buộc");
            }
            if (string.IsNullOrEmpty(model.MaChiNhanh))
            {
                ModelState.AddModelError("MaChiNhanh", "Chi nhánh là bắt buộc");
            }
            if (string.IsNullOrEmpty(model.MaChucVu))
            {
                ModelState.AddModelError("MaChucVu", "Chức vụ là bắt buộc");
            }
            
            if (!ModelState.IsValid)
            {
                var chiNhanhFilter = GetChiNhanhFilter();
                var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
                if (chiNhanhFilter != null)
                {
                    chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }
                
                ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
                ViewBag.ChucVus = new SelectList(await _context.ChucVuNhanViens.ToListAsync(), "MaChucVu", "TenChucVu");
                return View(model);
            }

            try
            {
                model.MaNV = GenerateMaNhanVien();
                model.TrangThai = true;
                
                _context.ThongTinNhanViens.Add(model);
                await _context.SaveChangesAsync();

                TempData["Success"] = "Thêm nhân viên thành công!";
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
                ViewBag.ChucVus = new SelectList(await _context.ChucVuNhanViens.ToListAsync(), "MaChucVu", "TenChucVu");
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            var nhanVien = await _context.ThongTinNhanViens.FindAsync(id);
            if (nhanVien == null)
            {
                TempData["Error"] = "Không tìm thấy nhân viên!";
                return RedirectToAction(nameof(Index));
            }

            // Kiểm tra quyền truy cập
            var accessCheck = CheckChiNhanhAccess(nhanVien.MaChiNhanh);
            if (accessCheck != null) return accessCheck;

            var chiNhanhFilter = GetChiNhanhFilter();
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh", nhanVien.MaChiNhanh);
            ViewBag.ChucVus = new SelectList(await _context.ChucVuNhanViens.ToListAsync(), "MaChucVu", "TenChucVu", nhanVien.MaChucVu);
            return View(nhanVien);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(ThongTinNhanVien model)
        {
            // Kiểm tra quyền truy cập chi nhánh
            var accessCheck = CheckChiNhanhAccess(model.MaChiNhanh);
            if (accessCheck != null) return accessCheck;
            
            // Xóa validation errors cho navigation properties
            ModelState.Remove("ChucVuNhanVien");
            ModelState.Remove("ChiNhanh");
            ModelState.Remove("DonHangs");
            ModelState.Remove("BangLuongs");
            
            if (!ModelState.IsValid)
            {
                var chiNhanhFilter = GetChiNhanhFilter();
                var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
                if (chiNhanhFilter != null)
                {
                    chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }
                
                ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh", model.MaChiNhanh);
                ViewBag.ChucVus = new SelectList(await _context.ChucVuNhanViens.ToListAsync(), "MaChucVu", "TenChucVu", model.MaChucVu);
                return View(model);
            }

            try
            {
                _context.ThongTinNhanViens.Update(model);
                await _context.SaveChangesAsync();

                TempData["Success"] = "Cập nhật nhân viên thành công!";
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
                
                ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh", model.MaChiNhanh);
                ViewBag.ChucVus = new SelectList(await _context.ChucVuNhanViens.ToListAsync(), "MaChucVu", "TenChucVu", model.MaChucVu);
                return View(model);
            }
        }

        [HttpPost]
        public async Task<IActionResult> NghiViec(string id)
        {
            try
            {
                var nhanVien = await _context.ThongTinNhanViens.FindAsync(id);
                if (nhanVien == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy nhân viên!" });
                }

                // Kiểm tra quyền truy cập
                if (!CanAccessChiNhanh(nhanVien.MaChiNhanh))
                {
                    return Json(new { success = false, message = "Bạn không có quyền thao tác nhân viên này!" });
                }

                nhanVien.NgayNghiViec = DateTime.Now;
                nhanVien.TrangThai = false;
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Cập nhật nghỉ việc thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        private string GenerateMaNhanVien()
        {
            var random = new Random();
            var number = random.Next(10000, 99999);
            return $"NV{number}";
        }
    }
}
