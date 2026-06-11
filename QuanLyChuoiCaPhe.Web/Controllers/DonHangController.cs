using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Services;
using QuanLyChuoiCaPhe.Web.ViewModels;
using QuanLyChuoiCaPhe.Web.Models;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN", "NHAN_VIEN", "QUAN_LY")]
    public class DonHangController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;
        private readonly DonHangService _donHangService;

        public DonHangController(QuanLyChuoiCaPheContext context, DonHangService donHangService, AuthService authService)
            : base(authService)
        {
            _context = context;
            _donHangService = donHangService;
        }

        public async Task<IActionResult> Index(string? search, DateTime? tuNgay, DateTime? denNgay, string? chiNhanh, string? trangThai)
        {
            if (tuNgay.HasValue && denNgay.HasValue && tuNgay.Value.Date > denNgay.Value.Date)
            {
                ModelState.AddModelError(string.Empty, "Khoảng thời gian không hợp lệ: 'Từ ngày' phải nhỏ hơn hoặc bằng 'Đến ngày'.");

                var chiNhanhFilterInvalid = GetChiNhanhFilter();
                var chiNhanhsInvalidQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
                if (chiNhanhFilterInvalid != null)
                {
                    chiNhanhsInvalidQuery = chiNhanhsInvalidQuery.Where(c => c.MaChiNhanh == chiNhanhFilterInvalid);
                }

                ViewBag.ChiNhanhs = await chiNhanhsInvalidQuery.AsNoTracking().ToListAsync();
                ViewBag.Search = search;
                ViewBag.TuNgay = tuNgay?.ToString("yyyy-MM-dd");
                ViewBag.DenNgay = denNgay?.ToString("yyyy-MM-dd");
                ViewBag.ChiNhanh = chiNhanh;
                ViewBag.TrangThai = trangThai;
                return View(new List<Models.DonHang>());
            }

            var query = _context.DonHangs
                .AsNoTracking()
                .Include(d => d.ChiNhanh)
                .Include(d => d.ThongTinNhanVien)
                .Include(d => d.KhachHang)
                .AsQueryable();

            // Phân quyền theo chi nhánh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(d => d.MaChiNhanh == chiNhanhFilter);
            }

            if (CurrentVaiTro == "NHAN_VIEN" && !string.IsNullOrWhiteSpace(CurrentMaNV))
            {
                query = query.Where(d => d.MaNV == CurrentMaNV);
            }

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(d => d.MaDH.Contains(search));
            }

            if (tuNgay.HasValue)
            {
                query = query.Where(d => d.NgayTao.Date >= tuNgay.Value.Date);
            }

            if (denNgay.HasValue)
            {
                query = query.Where(d => d.NgayTao.Date <= denNgay.Value.Date);
            }

            if (!string.IsNullOrEmpty(chiNhanh))
            {
                query = query.Where(d => d.MaChiNhanh == chiNhanh);
            }

            if (!string.IsNullOrEmpty(trangThai))
            {
                query = query.Where(d => d.TrangThai == trangThai);
            }

            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = await chiNhanhsQuery.ToListAsync();
            ViewBag.Search = search;
            ViewBag.TuNgay = tuNgay?.ToString("yyyy-MM-dd");
            ViewBag.DenNgay = denNgay?.ToString("yyyy-MM-dd");
            ViewBag.ChiNhanh = chiNhanh;
            ViewBag.TrangThai = trangThai;

            return View(await query.OrderByDescending(d => d.NgayTao).ToListAsync());
        }

        [HttpGet]
        [RoleAuthorize("NHAN_VIEN", "QUAN_LY")]
        public async Task<IActionResult> Create()
        {
            var chiNhanhFilter = GetChiNhanhFilter();
            if (string.IsNullOrEmpty(chiNhanhFilter))
            {
                TempData["Error"] = "Tài khoản của bạn không được liên kết với chi nhánh nào!";
                return RedirectToAction(nameof(Index));
            }

            await PrepareCreateViewBagAsync(chiNhanhFilter);

            var model = new DonHangCreateViewModel
            {
                MaChiNhanh = chiNhanhFilter,
                MaNV = CurrentMaNV ?? ""
            };

            return View(model);
        }

        [HttpPost]
        [RoleAuthorize("NHAN_VIEN", "QUAN_LY")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(DonHangCreateViewModel model)
        {
            // Bắt buộc lấy từ session để bảo mật chống giả mạo
            model.MaNV = CurrentMaNV ?? "";
            model.MaChiNhanh = CurrentMaChiNhanh ?? "";

            ModelState.Remove(nameof(model.MaNV));
            ModelState.Remove(nameof(model.MaChiNhanh));

            if (string.IsNullOrEmpty(model.MaNV) || string.IsNullOrEmpty(model.MaChiNhanh))
            {
                TempData["Error"] = "Tài khoản của bạn không được liên kết với nhân viên hoặc chi nhánh nào!";
                return RedirectToAction(nameof(Index));
            }

            // Kiểm tra quyền truy cập chi nhánh
            var accessCheck = CheckChiNhanhAccess(model.MaChiNhanh);
            if (accessCheck != null) return accessCheck;

            if (!ModelState.IsValid)
            {
                await PrepareCreateViewBagAsync(model.MaChiNhanh);
                return View(model);
            }

            if (model.ChiTietDonHangs == null || !model.ChiTietDonHangs.Any())
            {
                TempData["Error"] = "Vui lòng thêm ít nhất một sản phẩm!";
                await PrepareCreateViewBagAsync(model.MaChiNhanh);
                return View(model);
            }

            try
            {
                var currentUsername = _authService.GetCurrentTenDangNhap() ?? "Hệ thống";
                var maDH = await _donHangService.TaoDonHangAsync(model, currentUsername);
                TempData["Success"] = $"Tạo đơn hàng {maDH} thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                var errorMsg = ex.InnerException?.Message ?? ex.Message;
                TempData["Error"] = $"[Giao dịch thất bại - Hệ thống đã ROLLBACK] Chi tiết lỗi: {errorMsg}. Toàn bộ thao tác tạo đơn hàng và cập nhật điểm tích lũy đã được hủy bỏ để bảo toàn dữ liệu nhất quán.";
                await PrepareCreateViewBagAsync(model.MaChiNhanh);
                return View(model);
            }
        }

        public async Task<IActionResult> Details(string id)
        {
            var donHang = await _context.DonHangs
                .Include(d => d.ChiNhanh)
                .Include(d => d.ThongTinNhanVien)
                .Include(d => d.KhachHang)
                .Include(d => d.HanhTrinhDonHangs)
                .Include(d => d.ChiTietDonHangs)
                    .ThenInclude(ct => ct.BienTheSanPham)
                        .ThenInclude(bt => bt.SanPham)
                .FirstOrDefaultAsync(d => d.MaDH == id);

            if (donHang == null)
            {
                TempData["Error"] = "Không tìm thấy đơn hàng!";
                return RedirectToAction(nameof(Index));
            }

            // Kiểm tra quyền truy cập
            var accessCheck = CheckChiNhanhAccess(donHang.MaChiNhanh);
            if (accessCheck != null) return accessCheck;

            if (!CanAccessOrder(donHang))
            {
                TempData["Error"] = "Bạn không có quyền truy cập đơn hàng này!";
                return RedirectToAction(nameof(Index));
            }

            return View(donHang);
        }

        [HttpGet]
        public async Task<IActionResult> GetBienThePrice(string id)
        {
            var chiNhanh = CurrentMaChiNhanh;
            if (string.IsNullOrEmpty(chiNhanh))
            {
                return Json(new { success = false, message = "Không xác định được chi nhánh hiện tại" });
            }

            var result = await _donHangService.GetDonGiaBienTheAsync(id, chiNhanh);
            if (!result.IsValid)
            {
                return Json(new { success = false, message = result.Message });
            }

            return Json(new { success = true, price = result.DonGia, tenSanPham = result.TenSanPham, size = result.Size });
        }

        private async Task PrepareCreateViewBagAsync(string chiNhanhFilter)
        {
            var nhanVien = await _context.ThongTinNhanViens
                .Include(n => n.ChiNhanh)
                .FirstOrDefaultAsync(n => n.MaNV == CurrentMaNV);
            
            ViewBag.CurrentTenNhanVien = nhanVien?.HoTenNV ?? "N/A";
            ViewBag.CurrentTenChiNhanh = nhanVien?.ChiNhanh?.TenChiNhanh ?? "N/A";

            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai && c.MaChiNhanh == chiNhanhFilter);
            var nhanViensQuery = _context.ThongTinNhanViens.Where(n => n.TrangThai && n.MaNV == (CurrentMaNV ?? ""));

            ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
            ViewBag.NhanViens = new SelectList(await nhanViensQuery.ToListAsync(), "MaNV", "HoTenNV");
            ViewBag.KhachHangs = new SelectList(
                await _context.KhachHangs
                    .AsNoTracking()
                    .OrderBy(kh => kh.TenKH)
                    .ToListAsync(),
                "MaKH",
                "TenKH");
            ViewBag.KhachHangInfos = await _context.KhachHangs
                .AsNoTracking()
                .OrderBy(kh => kh.TenKH)
                .Select(kh => new
                {
                    kh.MaKH,
                    kh.TenKH,
                    kh.SoDienThoai,
                    kh.DiemTichLuy
                })
                .ToListAsync();
            
            // Chỉ lấy biến thể thuộc menu/sản phẩm của chi nhánh hiện tại
            var bienThes = await _context.BienTheSanPhams
                .Include(b => b.SanPham)
                .Where(b => b.TrangThai && b.SanPham.TrangThai)
                .Where(b => _context.SanPhamChiNhanhs.Any(spcn => spcn.MaChiNhanh == chiNhanhFilter && spcn.MaSanPham == b.MaSanPham && spcn.TrangThai))
                .ToListAsync();

            var priceByBienThe = await (
                from bt in _context.BienTheSanPhams
                join sp in _context.SanPhams on bt.MaSanPham equals sp.MaSanPham
                join spcn in _context.SanPhamChiNhanhs on sp.MaSanPham equals spcn.MaSanPham
                where spcn.MaChiNhanh == chiNhanhFilter
                      && spcn.TrangThai
                      && sp.TrangThai
                      && bt.TrangThai
                select new
                {
                    bt.MaBienThe,
                    DonGia = spcn.GiaBan + bt.GiaCongThem
                })
                .ToDictionaryAsync(x => x.MaBienThe, x => x.DonGia);

            ViewBag.BienThes = bienThes;
            ViewBag.BienThePrices = priceByBienThe;
        }

        [HttpPost]
        [RoleAuthorize("ADMIN", "NHAN_VIEN", "QUAN_LY")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CapNhatTrangThai(string id, string trangThai)
        {
            try
            {
                var donHang = await _context.DonHangs.FindAsync(id);
                if (donHang == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy đơn hàng!" });
                }

                // Kiểm tra quyền truy cập
                if (!CanAccessChiNhanh(donHang.MaChiNhanh))
                {
                    return Json(new { success = false, message = "Bạn không có quyền thao tác đơn hàng này!" });
                }

                if (!CanAccessOrder(donHang))
                {
                    return Json(new { success = false, message = "Bạn không có quyền thao tác đơn hàng này!" });
                }

                // Kiểm tra trạng thái hợp lệ (phải khớp với CHECK constraint trong database)
                var validStatuses = new[] { "Khởi tạo", "Hoàn tất", "Hủy" };
                if (!validStatuses.Contains(trangThai))
                {
                    return Json(new { success = false, message = "Trạng thái không hợp lệ!" });
                }

                // Không cho phép cập nhật đơn hàng đã hoàn tất hoặc đã hủy
                if (donHang.TrangThai == "Hoàn tất" || donHang.TrangThai == "Hủy")
                {
                    return Json(new { success = false, message = $"Không thể cập nhật đơn hàng đã {donHang.TrangThai.ToLower()}!" });
                }

                var oldStatus = donHang.TrangThai;
                donHang.TrangThai = trangThai;

                // Ghi nhật ký hành trình đơn hàng
                var currentUsername = _authService.GetCurrentTenDangNhap() ?? "Hệ thống";
                _context.HanhTrinhDonHangs.Add(new HanhTrinhDonHang
                {
                    MaDH = id,
                    HanhDong = $"Cập nhật trạng thái từ '{oldStatus}' thành '{trangThai}'",
                    NguoiThucHien = currentUsername,
                    ThoiGian = DateTime.Now
                });

                await _context.SaveChangesAsync();

                return Json(new { success = true, message = $"Cập nhật trạng thái thành '{trangThai}' thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        [HttpPost]
        [RoleAuthorize("ADMIN", "NHAN_VIEN", "QUAN_LY")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> HuyDonHang(string id)
        {
            try
            {
                var donHang = await _context.DonHangs.FindAsync(id);
                if (donHang == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy đơn hàng!" });
                }

                // Kiểm tra quyền truy cập
                if (!CanAccessChiNhanh(donHang.MaChiNhanh))
                {
                    return Json(new { success = false, message = "Bạn không có quyền thao tác đơn hàng này!" });
                }

                if (!CanAccessOrder(donHang))
                {
                    return Json(new { success = false, message = "Bạn không có quyền thao tác đơn hàng này!" });
                }

                // Chỉ cho phép hủy đơn hàng ở trạng thái "Khởi tạo"
                if (donHang.TrangThai == "Hoàn tất")
                {
                    return Json(new { success = false, message = "Không thể hủy đơn hàng đã hoàn tất!" });
                }

                if (donHang.TrangThai == "Hủy")
                {
                    return Json(new { success = false, message = "Đơn hàng đã được hủy trước đó!" });
                }

                var oldStatus = donHang.TrangThai;
                donHang.TrangThai = "Hủy";

                // Ghi nhật ký hành trình đơn hàng
                var currentUsername = _authService.GetCurrentTenDangNhap() ?? "Hệ thống";
                _context.HanhTrinhDonHangs.Add(new HanhTrinhDonHang
                {
                    MaDH = id,
                    HanhDong = $"Hủy đơn hàng (Trạng thái trước đó: '{oldStatus}')",
                    NguoiThucHien = currentUsername,
                    ThoiGian = DateTime.Now
                });

                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Hủy đơn hàng thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        private bool CanAccessOrder(Models.DonHang donHang)
        {
            return CurrentVaiTro != "NHAN_VIEN" || donHang.MaNV == CurrentMaNV;
        }
    }
}
