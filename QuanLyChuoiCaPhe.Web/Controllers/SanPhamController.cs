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
    public class SanPhamController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public SanPhamController(QuanLyChuoiCaPheContext context, AuthService authService)
            : base(authService)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? search, string? danhMuc, bool? trangThai)
        {
            var query = _context.SanPhams.Include(s => s.DanhMuc).AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(s => s.TenSanPham.Contains(search));
            }

            if (!string.IsNullOrEmpty(danhMuc))
            {
                query = query.Where(s => s.MaDanhMuc == danhMuc);
            }

            if (trangThai.HasValue)
            {
                query = query.Where(s => s.TrangThai == trangThai.Value);
            }

            ViewBag.DanhMucs = await _context.DanhMucs.ToListAsync();
            ViewBag.Search = search;
            ViewBag.DanhMuc = danhMuc;
            ViewBag.TrangThai = trangThai;

            return View(await query.OrderBy(s => s.TenSanPham).ToListAsync());
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            ViewBag.DanhMucs = new SelectList(await _context.DanhMucs.ToListAsync(), "MaDanhMuc", "TenDanhMuc");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(SanPham model)
        {
            // Xóa validation error cho MaSanPham (sẽ được tạo tự động)
            ModelState.Remove("MaSanPham");
            
            // Xóa validation errors cho navigation properties
            ModelState.Remove("DanhMuc");
            ModelState.Remove("BienTheSanPhams");
            ModelState.Remove("SanPhamChiNhanhs");
            ModelState.Remove("SanPhamTuyChons");
            ModelState.Remove("CongThucPhaChe");
            ModelState.Remove("ChiTietDonHangs");
            
            if (!ModelState.IsValid)
            {
                ViewBag.DanhMucs = new SelectList(await _context.DanhMucs.ToListAsync(), "MaDanhMuc", "TenDanhMuc");
                return View(model);
            }

            try
            {
                model.MaSanPham = GenerateMaSanPham();
                _context.SanPhams.Add(model);
                await _context.SaveChangesAsync();

                TempData["Success"] = "Thêm sản phẩm thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                ViewBag.DanhMucs = new SelectList(await _context.DanhMucs.ToListAsync(), "MaDanhMuc", "TenDanhMuc");
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            var sanPham = await _context.SanPhams.FindAsync(id);
            if (sanPham == null)
            {
                TempData["Error"] = "Không tìm thấy sản phẩm!";
                return RedirectToAction(nameof(Index));
            }

            ViewBag.DanhMucs = new SelectList(await _context.DanhMucs.ToListAsync(), "MaDanhMuc", "TenDanhMuc", sanPham.MaDanhMuc);
            return View(sanPham);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(SanPham model)
        {
            // Xóa validation errors cho navigation properties
            ModelState.Remove("DanhMuc");
            ModelState.Remove("BienTheSanPhams");
            ModelState.Remove("SanPhamChiNhanhs");
            ModelState.Remove("SanPhamTuyChons");
            ModelState.Remove("CongThucPhaChe");
            ModelState.Remove("ChiTietDonHangs");
            
            if (!ModelState.IsValid)
            {
                ViewBag.DanhMucs = new SelectList(await _context.DanhMucs.ToListAsync(), "MaDanhMuc", "TenDanhMuc", model.MaDanhMuc);
                return View(model);
            }

            try
            {
                _context.SanPhams.Update(model);
                await _context.SaveChangesAsync();

                TempData["Success"] = "Cập nhật sản phẩm thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                ViewBag.DanhMucs = new SelectList(await _context.DanhMucs.ToListAsync(), "MaDanhMuc", "TenDanhMuc", model.MaDanhMuc);
                return View(model);
            }
        }

        [HttpPost]
        public async Task<IActionResult> ToggleStatus(string id)
        {
            try
            {
                var sanPham = await _context.SanPhams.FindAsync(id);
                if (sanPham == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy sản phẩm!" });
                }

                sanPham.TrangThai = !sanPham.TrangThai;
                await _context.SaveChangesAsync();

                return Json(new { success = true, message = "Cập nhật trạng thái thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.InnerException?.Message ?? ex.Message });
            }
        }

        [RoleAuthorize]
        public async Task<IActionResult> Menu(string? chiNhanh)
        {
            var query = _context.VwMenuChiNhanhs.AsQueryable();

            // Phân quyền theo chi nhánh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(m => m.MaChiNhanh == chiNhanhFilter);
            }

            if (!string.IsNullOrEmpty(chiNhanh))
            {
                query = query.Where(m => m.MaChiNhanh == chiNhanh);
            }

            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            ViewBag.ChiNhanhs = await chiNhanhsQuery.ToListAsync();
            ViewBag.ChiNhanh = chiNhanh;

            return View(await query.Where(m => m.TrangThaiMenu == true).ToListAsync());
        }

        private string GenerateMaSanPham()
        {
            var random = new Random();
            var number = random.Next(1000, 9999);
            return $"SP{number}";
        }
    }
}
