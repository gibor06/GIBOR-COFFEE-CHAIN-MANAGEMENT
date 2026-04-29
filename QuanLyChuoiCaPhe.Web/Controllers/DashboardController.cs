using Microsoft.AspNetCore.Mvc;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Services;
using QuanLyChuoiCaPhe.Web.ViewModels;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize]
    public class DashboardController : BaseController
    {
        private readonly DashboardService _dashboardService;

        public DashboardController(DashboardService dashboardService, AuthService authService) 
            : base(authService)
        {
            _dashboardService = dashboardService;
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                var model = await _dashboardService.GetDashboardDataAsync();
                return View(model);
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi tải dashboard: {ex.Message}";
                
                // Trả về model rỗng để tránh lỗi view
                var emptyModel = new DashboardViewModel
                {
                    TongChiNhanh = 0,
                    TongNhanVien = 0,
                    TongSanPham = 0,
                    TongDonHang = 0,
                    DoanhThuHomNay = 0,
                    SoCanhBaoTonKho = 0,
                    BangLuongTamTinh = 0,
                    DonHangGanDay = new List<DonHangGanDay>(),
                    DoanhThuTheoThang = new List<DoanhThuThang>()
                };
                
                return View(emptyModel);
            }
        }
    }
}
