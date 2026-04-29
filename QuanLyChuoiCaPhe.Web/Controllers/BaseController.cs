using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using QuanLyChuoiCaPhe.Web.Services;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    public class BaseController : Controller
    {
        protected readonly AuthService _authService;

        public BaseController(AuthService authService)
        {
            _authService = authService;
        }

        // Các thuộc tính helper để truy cập thông tin user
        protected string? CurrentMaTK => _authService.GetCurrentMaTK();
        protected string? CurrentVaiTro => _authService.GetCurrentVaiTro();
        protected string? CurrentMaNV => _authService.GetCurrentMaNV();
        protected string? CurrentMaChiNhanh => _authService.GetCurrentMaChiNhanh();
        protected bool IsAdmin => _authService.IsAdmin();
        protected bool IsQuanLy => _authService.IsQuanLy();
        protected bool IsNhanVien => _authService.IsNhanVien();

        /// <summary>
        /// Kiểm tra xem user có quyền truy cập chi nhánh này không
        /// </summary>
        protected bool CanAccessChiNhanh(string? maChiNhanh)
        {
            // ADMIN có thể truy cập tất cả
            if (IsAdmin) return true;

            // QUAN_LY và NHAN_VIEN chỉ truy cập chi nhánh của mình
            if (string.IsNullOrEmpty(maChiNhanh)) return false;
            return CurrentMaChiNhanh == maChiNhanh;
        }

        /// <summary>
        /// Lấy mã chi nhánh để filter dữ liệu
        /// - ADMIN: null (xem tất cả)
        /// - QUAN_LY/NHAN_VIEN: mã chi nhánh của họ
        /// </summary>
        protected string? GetChiNhanhFilter()
        {
            return IsAdmin ? null : CurrentMaChiNhanh;
        }

        /// <summary>
        /// Kiểm tra quyền truy cập và trả về Forbidden nếu không có quyền
        /// </summary>
        protected IActionResult? CheckChiNhanhAccess(string? maChiNhanh)
        {
            if (!CanAccessChiNhanh(maChiNhanh))
            {
                TempData["Error"] = "Bạn không có quyền truy cập dữ liệu của chi nhánh này!";
                return Forbid();
            }
            return null;
        }

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            // Truyền thông tin user vào ViewBag để sử dụng trong View
            ViewBag.CurrentVaiTro = CurrentVaiTro;
            ViewBag.CurrentMaChiNhanh = CurrentMaChiNhanh;
            ViewBag.IsAdmin = IsAdmin;
            ViewBag.IsQuanLy = IsQuanLy;
            ViewBag.IsNhanVien = IsNhanVien;

            base.OnActionExecuting(context);
        }
    }
}
