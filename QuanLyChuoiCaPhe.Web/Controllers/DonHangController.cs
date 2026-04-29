using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Services;
using QuanLyChuoiCaPhe.Web.ViewModels;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize]
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

        public async Task<IActionResult> Index(string? search, DateTime? tuNgay, DateTime? denNgay, string? chiNhanh)
        {
            var query = _context.DonHangs
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

            return View(await query.OrderByDescending(d => d.NgayTao).ToListAsync());
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

            // Lọc nhân viên theo chi nhánh
            var nhanViensQuery = _context.ThongTinNhanViens.Where(n => n.TrangThai);
            if (chiNhanhFilter != null)
            {
                nhanViensQuery = nhanViensQuery.Where(n => n.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
            ViewBag.NhanViens = new SelectList(await nhanViensQuery.ToListAsync(), "MaNV", "HoTenNV");
            ViewBag.KhachHangs = new SelectList(await _context.KhachHangs.ToListAsync(), "MaKH", "TenKH");
            ViewBag.BienThes = await _context.BienTheSanPhams
                .Include(b => b.SanPham)
                .Where(b => b.TrangThai && b.SanPham.TrangThai)
                .ToListAsync();

            // Tự động chọn chi nhánh nếu không phải ADMIN
            var model = new DonHangCreateViewModel();
            if (chiNhanhFilter != null)
            {
                model.MaChiNhanh = chiNhanhFilter;
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(DonHangCreateViewModel model)
        {
            // Kiểm tra quyền truy cập chi nhánh
            var accessCheck = CheckChiNhanhAccess(model.MaChiNhanh);
            if (accessCheck != null) return accessCheck;

            if (!ModelState.IsValid)
            {
                var chiNhanhFilter = GetChiNhanhFilter();
                var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
                if (chiNhanhFilter != null)
                {
                    chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }

                var nhanViensQuery = _context.ThongTinNhanViens.Where(n => n.TrangThai);
                if (chiNhanhFilter != null)
                {
                    nhanViensQuery = nhanViensQuery.Where(n => n.MaChiNhanh == chiNhanhFilter);
                }

                ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
                ViewBag.NhanViens = new SelectList(await nhanViensQuery.ToListAsync(), "MaNV", "HoTenNV");
                ViewBag.KhachHangs = new SelectList(await _context.KhachHangs.ToListAsync(), "MaKH", "TenKH");
                ViewBag.BienThes = await _context.BienTheSanPhams
                    .Include(b => b.SanPham)
                    .Where(b => b.TrangThai && b.SanPham.TrangThai)
                    .ToListAsync();
                return View(model);
            }

            if (model.ChiTietDonHangs == null || !model.ChiTietDonHangs.Any())
            {
                TempData["Error"] = "Vui lòng thêm ít nhất một sản phẩm!";
                
                var chiNhanhFilter = GetChiNhanhFilter();
                var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
                if (chiNhanhFilter != null)
                {
                    chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
                }

                var nhanViensQuery = _context.ThongTinNhanViens.Where(n => n.TrangThai);
                if (chiNhanhFilter != null)
                {
                    nhanViensQuery = nhanViensQuery.Where(n => n.MaChiNhanh == chiNhanhFilter);
                }

                ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
                ViewBag.NhanViens = new SelectList(await nhanViensQuery.ToListAsync(), "MaNV", "HoTenNV");
                ViewBag.KhachHangs = new SelectList(await _context.KhachHangs.ToListAsync(), "MaKH", "TenKH");
                ViewBag.BienThes = await _context.BienTheSanPhams
                    .Include(b => b.SanPham)
                    .Where(b => b.TrangThai && b.SanPham.TrangThai)
                    .ToListAsync();
                return View(model);
            }

            try
            {
                var maDH = await _donHangService.TaoDonHangAsync(model);
                TempData["Success"] = $"Tạo đơn hàng {maDH} thành công!";
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

                var nhanViensQuery = _context.ThongTinNhanViens.Where(n => n.TrangThai);
                if (chiNhanhFilter != null)
                {
                    nhanViensQuery = nhanViensQuery.Where(n => n.MaChiNhanh == chiNhanhFilter);
                }

                ViewBag.ChiNhanhs = new SelectList(await chiNhanhsQuery.ToListAsync(), "MaChiNhanh", "TenChiNhanh");
                ViewBag.NhanViens = new SelectList(await nhanViensQuery.ToListAsync(), "MaNV", "HoTenNV");
                ViewBag.KhachHangs = new SelectList(await _context.KhachHangs.ToListAsync(), "MaKH", "TenKH");
                ViewBag.BienThes = await _context.BienTheSanPhams
                    .Include(b => b.SanPham)
                    .Where(b => b.TrangThai && b.SanPham.TrangThai)
                    .ToListAsync();
                return View(model);
            }
        }

        public async Task<IActionResult> Details(string id)
        {
            var donHang = await _context.DonHangs
                .Include(d => d.ChiNhanh)
                .Include(d => d.ThongTinNhanVien)
                .Include(d => d.KhachHang)
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

            return View(donHang);
        }

        [HttpGet]
        public async Task<IActionResult> GetBienThePrice(string id)
        {
            var bienThe = await _context.BienTheSanPhams
                .Include(b => b.SanPham)
                .FirstOrDefaultAsync(b => b.MaBienThe == id);

            if (bienThe == null)
            {
                return Json(new { success = false });
            }

            var price = bienThe.SanPham.GiaCoBan + bienThe.GiaCongThem;
            return Json(new { success = true, price = price, tenSanPham = bienThe.SanPham.TenSanPham, size = bienThe.Size });
        }

        [HttpPost]
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

                donHang.TrangThai = trangThai;
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = $"Cập nhật trạng thái thành '{trangThai}' thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        [HttpPost]
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

                // Chỉ cho phép hủy đơn hàng ở trạng thái "Khởi tạo"
                if (donHang.TrangThai == "Hoàn tất")
                {
                    return Json(new { success = false, message = "Không thể hủy đơn hàng đã hoàn tất!" });
                }

                if (donHang.TrangThai == "Hủy")
                {
                    return Json(new { success = false, message = "Đơn hàng đã được hủy trước đó!" });
                }

                donHang.TrangThai = "Hủy";
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Hủy đơn hàng thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }
    }
}
