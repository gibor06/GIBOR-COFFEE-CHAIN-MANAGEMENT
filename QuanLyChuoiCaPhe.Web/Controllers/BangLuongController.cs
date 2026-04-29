using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.Services;
using QuanLyChuoiCaPhe.Web.ViewModels;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN", "KE_TOAN", "QUAN_LY")]
    public class BangLuongController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;
        private readonly BangLuongService _bangLuongService;

        public BangLuongController(QuanLyChuoiCaPheContext context, BangLuongService bangLuongService, AuthService authService)
            : base(authService)
        {
            _context = context;
            _bangLuongService = bangLuongService;
        }

        public async Task<IActionResult> Index(byte? thang, short? nam)
        {
            var query = _context.VwBangLuongTongHops.AsQueryable();

            // Phân quyền: QUAN_LY chỉ xem bảng lương nhân viên chi nhánh của mình
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(b => b.MaChiNhanh == chiNhanhFilter);
            }

            if (thang.HasValue)
            {
                query = query.Where(b => b.Thang == thang.Value);
            }

            if (nam.HasValue)
            {
                query = query.Where(b => b.Nam == nam.Value);
            }

            ViewBag.Thang = thang;
            ViewBag.Nam = nam;

            return View(await query.ToListAsync());
        }

        [HttpGet]
        [RoleAuthorize("ADMIN", "KE_TOAN")] // Chỉ ADMIN và KE_TOAN được khởi tạo bảng lương
        public IActionResult KhoiTao()
        {
            var model = new BangLuongCreateViewModel
            {
                Thang = (byte)DateTime.Now.Month,
                Nam = (short)DateTime.Now.Year
            };
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("ADMIN", "KE_TOAN")] // Chỉ ADMIN và KE_TOAN được khởi tạo bảng lương
        public async Task<IActionResult> KhoiTao(BangLuongCreateViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                await _bangLuongService.KhoiTaoBangLuongAsync(model);
                TempData["Success"] = $"Khởi tạo bảng lương tháng {model.Thang}/{model.Nam} thành công!";
                return RedirectToAction(nameof(Index), new { thang = model.Thang, nam = model.Nam });
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                return View(model);
            }
        }

        [HttpPost]
        [RoleAuthorize("ADMIN", "KE_TOAN")] // Chỉ ADMIN và KE_TOAN được cập nhật thưởng/khấu trừ
        public async Task<IActionResult> CapNhatThuongKhauTru(string maNV, byte thang, short nam, decimal? thuong, decimal? khauTru)
        {
            try
            {
                var bangLuong = await _context.BangLuongs
                    .Include(b => b.ThongTinNhanVien)
                    .FirstOrDefaultAsync(b => b.MaNV == maNV && b.Thang == thang && b.Nam == nam);
                    
                if (bangLuong == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy bảng lương!" });
                }

                if (bangLuong.TrangThai == "Đã thanh toán")
                {
                    return Json(new { success = false, message = "Không thể sửa bảng lương đã thanh toán!" });
                }

                if (thuong.HasValue)
                {
                    bangLuong.TongThuong = thuong.Value;
                }

                if (khauTru.HasValue)
                {
                    bangLuong.TongKhauTru = khauTru.Value;
                }

                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Cập nhật thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        [HttpPost]
        [RoleAuthorize("ADMIN", "KE_TOAN")] // Chỉ ADMIN và KE_TOAN được xác nhận thanh toán
        public async Task<IActionResult> XacNhanThanhToan(string maNV, byte thang, short nam)
        {
            try
            {
                var bangLuong = await _context.BangLuongs.FindAsync(maNV, thang, nam);
                if (bangLuong == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy bảng lương!" });
                }

                bangLuong.TrangThai = "Đã thanh toán";
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Xác nhận thanh toán thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }
    }
}
