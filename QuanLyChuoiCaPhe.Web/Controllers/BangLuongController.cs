using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
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

        public async Task<IActionResult> Index(byte? thang, short? nam, string? maNV, string? trangThai)
        {
            var query = _context.BangLuongs
                .Include(b => b.ThongTinNhanVien)
                .AsQueryable();

            // Phân quyền: QUAN_LY chỉ xem bảng lương nhân viên chi nhánh của mình
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(b => b.ThongTinNhanVien.MaChiNhanh == chiNhanhFilter);
            }

            if (thang.HasValue)
            {
                query = query.Where(b => b.Thang == thang.Value);
            }

            if (nam.HasValue)
            {
                query = query.Where(b => b.Nam == nam.Value);
            }

            if (!string.IsNullOrEmpty(maNV))
            {
                query = query.Where(b => b.MaNV == maNV);
            }

            if (!string.IsNullOrEmpty(trangThai))
            {
                query = query.Where(b => b.TrangThai == trangThai);
            }

            var data = await query.OrderByDescending(b => b.Nam).ThenByDescending(b => b.Thang).ThenBy(b => b.MaNV).ToListAsync();

            ViewBag.Thang = thang;
            ViewBag.Nam = nam;
            ViewBag.MaNV = maNV;
            ViewBag.TrangThaiFilter = trangThai;

            // Thống kê
            ViewBag.TongLuongCa = data.Sum(b => b.TongLuongCa);
            ViewBag.TongThuong = data.Sum(b => b.TongThuong);
            ViewBag.TongKhauTru = data.Sum(b => b.TongKhauTru);
            ViewBag.TongThucLanh = data.Sum(b => b.ThucLanh ?? 0);

            // Load dropdown nhân viên
            await LoadNhanVienDropdownAsync();

            return View(data);
        }

        [HttpGet]
        [RoleAuthorize("ADMIN", "KE_TOAN")]
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
        [RoleAuthorize("ADMIN", "KE_TOAN")]
        public async Task<IActionResult> KhoiTao(BangLuongCreateViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                var chiNhanhFilter = GetChiNhanhFilter();
                await _bangLuongService.KhoiTaoBangLuongAsync(model, chiNhanhFilter);
                TempData["Success"] = $"Khởi tạo bảng lương tháng {model.Thang}/{model.Nam} thành công!";
                return RedirectToAction(nameof(Index), new { thang = model.Thang, nam = model.Nam });
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                return View(model);
            }
        }

        [HttpGet]
        [RoleAuthorize("ADMIN", "KE_TOAN", "QUAN_LY")]
        public async Task<IActionResult> Create()
        {
            await LoadNhanVienDropdownAsync();
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("ADMIN", "KE_TOAN", "QUAN_LY")]
        public async Task<IActionResult> Create(BangLuong model)
        {
            ModelState.Remove("ThongTinNhanVien");
            ModelState.Remove("ThucLanh");

            // Validate
            if (string.IsNullOrWhiteSpace(model.MaNV))
            {
                ModelState.AddModelError("MaNV", "Nhân viên không được để trống.");
            }
            else
            {
                var nv = await _context.ThongTinNhanViens.FindAsync(model.MaNV);
                if (nv == null)
                {
                    ModelState.AddModelError("MaNV", "Nhân viên không tồn tại.");
                }
                else if (!CanAccessChiNhanh(nv.MaChiNhanh))
                {
                    ModelState.AddModelError("MaNV", "Bạn không có quyền tạo bảng lương cho nhân viên chi nhánh khác.");
                }
            }

            if (model.Thang < 1 || model.Thang > 12)
            {
                ModelState.AddModelError("Thang", "Tháng phải từ 1 đến 12.");
            }
            if (model.Nam < 2024 || model.Nam > 2100)
            {
                ModelState.AddModelError("Nam", "Năm không hợp lệ.");
            }
            if (model.TongGioThucTe < 0) ModelState.AddModelError("TongGioThucTe", "Tổng giờ phải >= 0.");
            if (model.TongLuongCa < 0) ModelState.AddModelError("TongLuongCa", "Tổng lương ca phải >= 0.");
            if (model.TongThuong < 0) ModelState.AddModelError("TongThuong", "Tổng thưởng phải >= 0.");
            if (model.TongKhauTru < 0) ModelState.AddModelError("TongKhauTru", "Tổng khấu trừ phải >= 0.");

            var validTrangThai = new[] { "Tạm tính", "Đã thanh toán" };
            if (!validTrangThai.Contains(model.TrangThai))
            {
                ModelState.AddModelError("TrangThai", "Trạng thái không hợp lệ.");
            }

            // Check trùng
            if (await _context.BangLuongs.AnyAsync(b => b.MaNV == model.MaNV && b.Thang == model.Thang && b.Nam == model.Nam))
            {
                ModelState.AddModelError("", "Bảng lương cho nhân viên này trong tháng/năm này đã tồn tại.");
            }

            if (!ModelState.IsValid)
            {
                await LoadNhanVienDropdownAsync();
                return View(model);
            }

            try
            {
                // Không set ThucLanh - computed column
                _context.BangLuongs.Add(model);
                await _context.SaveChangesAsync();
                TempData["Success"] = "Thêm bảng lương thành công!";
                return RedirectToAction(nameof(Index), new { thang = model.Thang, nam = model.Nam });
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                await LoadNhanVienDropdownAsync();
                return View(model);
            }
        }

        [HttpGet]
        [RoleAuthorize("ADMIN", "KE_TOAN", "QUAN_LY")]
        public async Task<IActionResult> Edit(string maNV, byte thang, short nam)
        {
            var bangLuong = await _context.BangLuongs
                .Include(b => b.ThongTinNhanVien)
                .FirstOrDefaultAsync(b => b.MaNV == maNV && b.Thang == thang && b.Nam == nam);

            if (bangLuong == null)
            {
                TempData["Error"] = "Không tìm thấy bảng lương!";
                return RedirectToAction(nameof(Index));
            }

            if (!CanAccessChiNhanh(bangLuong.ThongTinNhanVien?.MaChiNhanh))
            {
                TempData["Error"] = "Bạn không có quyền chỉnh sửa bảng lương này!";
                return RedirectToAction(nameof(Index));
            }

            if (bangLuong.TrangThai == "Đã thanh toán")
            {
                TempData["Error"] = "Bảng lương đã thanh toán thì không được phép chỉnh sửa.";
                return RedirectToAction(nameof(Index));
            }

            return View(bangLuong);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("ADMIN", "KE_TOAN", "QUAN_LY")]
        public async Task<IActionResult> Edit(BangLuong model)
        {
            ModelState.Remove("ThongTinNhanVien");
            ModelState.Remove("ThucLanh");

            if (model.TongGioThucTe < 0) ModelState.AddModelError("TongGioThucTe", "Tổng giờ phải >= 0.");
            if (model.TongLuongCa < 0) ModelState.AddModelError("TongLuongCa", "Tổng lương ca phải >= 0.");
            if (model.TongThuong < 0) ModelState.AddModelError("TongThuong", "Tổng thưởng phải >= 0.");
            if (model.TongKhauTru < 0) ModelState.AddModelError("TongKhauTru", "Tổng khấu trừ phải >= 0.");

            var validTrangThai = new[] { "Tạm tính", "Đã thanh toán" };
            if (!validTrangThai.Contains(model.TrangThai))
            {
                ModelState.AddModelError("TrangThai", "Trạng thái không hợp lệ.");
            }

            if (!ModelState.IsValid)
            {
                var blReload = await _context.BangLuongs
                    .Include(b => b.ThongTinNhanVien)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(b => b.MaNV == model.MaNV && b.Thang == model.Thang && b.Nam == model.Nam);
                if (blReload != null) model.ThongTinNhanVien = blReload.ThongTinNhanVien!;
                return View(model);
            }

            try
            {
                var bangLuong = await _context.BangLuongs
                    .Include(b => b.ThongTinNhanVien)
                    .FirstOrDefaultAsync(b => b.MaNV == model.MaNV && b.Thang == model.Thang && b.Nam == model.Nam);

                if (bangLuong == null)
                {
                    TempData["Error"] = "Không tìm thấy bảng lương!";
                    return RedirectToAction(nameof(Index));
                }

                if (!CanAccessChiNhanh(bangLuong.ThongTinNhanVien?.MaChiNhanh))
                {
                    TempData["Error"] = "Bạn không có quyền chỉnh sửa bảng lương này!";
                    return RedirectToAction(nameof(Index));
                }

                if (bangLuong.TrangThai == "Đã thanh toán")
                {
                    TempData["Error"] = "Bảng lương đã thanh toán thì không được phép chỉnh sửa.";
                    return RedirectToAction(nameof(Index));
                }

                bangLuong.TongGioThucTe = model.TongGioThucTe;
                bangLuong.TongLuongCa = model.TongLuongCa;
                bangLuong.TongThuong = model.TongThuong;
                bangLuong.TongKhauTru = model.TongKhauTru;
                bangLuong.TrangThai = model.TrangThai;
                // ThucLanh is computed - DO NOT set

                await _context.SaveChangesAsync();
                TempData["Success"] = "Cập nhật bảng lương thành công!";
                return RedirectToAction(nameof(Index), new { thang = model.Thang, nam = model.Nam });
            }
            catch (Exception ex)
            {
                var errorMsg = ex.InnerException?.Message ?? ex.Message;
                if (errorMsg.Contains("thanh toán") || errorMsg.Contains("khóa"))
                {
                    TempData["Error"] = "Bảng lương đã thanh toán thì không được phép chỉnh sửa.";
                }
                else
                {
                    TempData["Error"] = $"Lỗi: {errorMsg}";
                }
                var blReload = await _context.BangLuongs
                    .Include(b => b.ThongTinNhanVien)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(b => b.MaNV == model.MaNV && b.Thang == model.Thang && b.Nam == model.Nam);
                if (blReload != null) model.ThongTinNhanVien = blReload.ThongTinNhanVien!;
                return View(model);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("ADMIN", "KE_TOAN")]
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

                if (!CanAccessChiNhanh(bangLuong.ThongTinNhanVien.MaChiNhanh))
                {
                    return Json(new { success = false, message = "Bạn không có quyền thao tác bảng lương của chi nhánh khác!" });
                }

                if (bangLuong.TrangThai == "Đã thanh toán")
                {
                    return Json(new { success = false, message = "Không thể sửa bảng lương đã thanh toán!" });
                }

                if ((thuong.HasValue && thuong.Value < 0) || (khauTru.HasValue && khauTru.Value < 0))
                {
                    return Json(new { success = false, message = "Thưởng và khấu trừ không được nhỏ hơn 0!" });
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
        [ValidateAntiForgeryToken]
        [RoleAuthorize("ADMIN", "KE_TOAN")]
        public async Task<IActionResult> XacNhanThanhToan(string maNV, byte thang, short nam)
        {
            try
            {
                var employee = await _context.ThongTinNhanViens.FindAsync(maNV);
                if (employee == null || !CanAccessChiNhanh(employee.MaChiNhanh))
                {
                    return Json(new { success = false, message = "Bạn không có quyền thanh toán lương của chi nhánh khác!" });
                }

                var bangLuong = await _context.BangLuongs.FindAsync(maNV, thang, nam);
                if (bangLuong == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy bảng lương!" });
                }

                if (bangLuong.TrangThai == "Đã thanh toán")
                {
                    return Json(new { success = false, message = "Bảng lương này đã được thanh toán trước đó!" });
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("ADMIN", "KE_TOAN")]
        public async Task<IActionResult> Delete(string maNV, byte thang, short nam)
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

                if (!CanAccessChiNhanh(bangLuong.ThongTinNhanVien?.MaChiNhanh))
                {
                    return Json(new { success = false, message = "Bạn không có quyền xóa bảng lương này!" });
                }

                if (bangLuong.TrangThai == "Đã thanh toán")
                {
                    return Json(new { success = false, message = "Không thể xóa bảng lương đã thanh toán!" });
                }

                _context.BangLuongs.Remove(bangLuong);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Xóa bảng lương thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        private async Task LoadNhanVienDropdownAsync()
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
        }
    }
}
