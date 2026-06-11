using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.Services;
using System.Data;
using System.Text.RegularExpressions;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN", "QUAN_LY", "NHAN_VIEN")]
    public class KhachHangController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public KhachHangController(QuanLyChuoiCaPheContext context, AuthService authService)
            : base(authService)
        {
            _context = context;
        }

        // GET: KhachHang
        public async Task<IActionResult> Index(string? search)
        {
            var query = _context.KhachHangs.AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(k => k.TenKH.Contains(search) || k.SoDienThoai.Contains(search) || k.MaKH.Contains(search));
            }

            ViewBag.Search = search;
            ViewBag.TongSoKH = await _context.KhachHangs.CountAsync();

            var list = await query.OrderBy(k => k.MaKH).ToListAsync();
            return View(list);
        }

        // POST: KhachHang/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(string tenKH, string soDienThoai)
        {
            if (string.IsNullOrWhiteSpace(tenKH))
            {
                TempData["Error"] = "Tên khách hàng không được để trống.";
                return RedirectToAction(nameof(Index));
            }

            if (string.IsNullOrWhiteSpace(soDienThoai) || soDienThoai.Length > 10)
            {
                TempData["Error"] = "Số điện thoại không hợp lệ, tối đa 10 số.";
                return RedirectToAction(nameof(Index));
            }
            if (!Regex.IsMatch(soDienThoai, @"^(03|05|07|08|09)[0-9]{8}$"))
            {
                TempData["Error"] = "Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 số di động Việt Nam (đầu số 03, 05, 07, 08, 09) và không chứa ký tự đặc biệt.";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                var maKHParam = new SqlParameter
                {
                    ParameterName = "@MaKH",
                    SqlDbType = SqlDbType.Char,
                    Size = 6,
                    Direction = ParameterDirection.Output
                };

                await _context.Database.ExecuteSqlRawAsync(
                    "EXEC dbo.sp_ThemKhachHang @TenKH, @SoDienThoai, @MaKH OUTPUT",
                    new SqlParameter("@TenKH", tenKH.Trim()),
                    new SqlParameter("@SoDienThoai", soDienThoai.Trim()),
                    maKHParam
                );

                string maKH = maKHParam.Value.ToString() ?? "";
                TempData["Success"] = $"Thêm khách hàng thành công! Mã KH: {maKH}";
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: KhachHang/Edit
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string maKH, string tenKH, string soDienThoai)
        {
            if (string.IsNullOrWhiteSpace(tenKH))
            {
                TempData["Error"] = "Tên khách hàng không được để trống.";
                return RedirectToAction(nameof(Index));
            }

            if (string.IsNullOrWhiteSpace(soDienThoai) || soDienThoai.Length > 10)
            {
                TempData["Error"] = "Số điện thoại không hợp lệ, tối đa 10 số.";
                return RedirectToAction(nameof(Index));
            }
            if (!Regex.IsMatch(soDienThoai, @"^(03|05|07|08|09)[0-9]{8}$"))
            {
                TempData["Error"] = "Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 số di động Việt Nam (đầu số 03, 05, 07, 08, 09) và không chứa ký tự đặc biệt.";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                await _context.Database.ExecuteSqlRawAsync(
                    "EXEC dbo.sp_SuaKhachHang @MaKH, @TenKH, @SoDienThoai",
                    new SqlParameter("@MaKH", maKH),
                    new SqlParameter("@TenKH", tenKH.Trim()),
                    new SqlParameter("@SoDienThoai", soDienThoai.Trim())
                );

                TempData["Success"] = "Cập nhật thông tin khách hàng thành công!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: KhachHang/Delete
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string id)
        {
            // Chỉ ADMIN hoặc QUAN_LY mới được phép xóa khách hàng
            var vaiTro = GetCurrentVaiTro();
            if (vaiTro != "ADMIN" && vaiTro != "QUAN_LY")
            {
                return Json(new { success = false, message = "Bạn không có quyền thực hiện chức năng này!" });
            }

            try
            {
                await _context.Database.ExecuteSqlRawAsync(
                    "EXEC dbo.sp_XoaKhachHang @MaKH",
                    new SqlParameter("@MaKH", id)
                );

                return Json(new { success = true, message = "Xóa khách hàng thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }



        private string GetCurrentVaiTro()
        {
            return HttpContext.Session.GetString("VaiTro") ?? "";
        }
    }
}
