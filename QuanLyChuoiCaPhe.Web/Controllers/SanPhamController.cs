using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.Services;
using QuanLyChuoiCaPhe.Web.ViewModels;
using System.Data;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    public class SanPhamController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public SanPhamController(QuanLyChuoiCaPheContext context, AuthService authService)
            : base(authService)
        {
            _context = context;
        }

        [RoleAuthorize("ADMIN", "QUAN_LY")]
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
        [RoleAuthorize("ADMIN")]
        public async Task<IActionResult> Create()
        {
            await PopulateCreateViewDataAsync();
            return View(new SanPhamCreateViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("ADMIN")]
        public async Task<IActionResult> Create(SanPhamCreateViewModel model)
        {
            NormalizeCreateModel(model);
            ValidateCreatePrices(model);

            var selectedBranchCodes = model.MaChiNhanhs
                .Where(m => !string.IsNullOrWhiteSpace(m))
                .Distinct()
                .ToList();

            if (selectedBranchCodes.Count == 0)
            {
                ModelState.AddModelError(nameof(model.MaChiNhanhs), "Vui lòng chọn ít nhất một chi nhánh bán sản phẩm");
            }

            if (!ModelState.IsValid)
            {
                await PopulateCreateViewDataAsync(model.MaDanhMuc);
                return View(model);
            }

            var danhMucExists = await _context.DanhMucs
                .AsNoTracking()
                .AnyAsync(d => d.MaDanhMuc == model.MaDanhMuc);

            if (!danhMucExists)
            {
                ModelState.AddModelError(nameof(model.MaDanhMuc), "Danh mục không hợp lệ");
            }

            var activeBranchCodes = await _context.ChiNhanhs
                .AsNoTracking()
                .Where(c => c.TrangThai && selectedBranchCodes.Contains(c.MaChiNhanh))
                .Select(c => c.MaChiNhanh)
                .ToListAsync();

            if (activeBranchCodes.Count != selectedBranchCodes.Count)
            {
                ModelState.AddModelError(nameof(model.MaChiNhanhs), "Danh sách chi nhánh đã chọn không hợp lệ hoặc đã ngừng hoạt động");
            }

            var isDuplicateName = await _context.SanPhams
                .AsNoTracking()
                .AnyAsync(s => s.TenSanPham == model.TenSanPham);

            if (isDuplicateName)
            {
                ModelState.AddModelError(nameof(model.TenSanPham), "Tên sản phẩm đã tồn tại");
            }

            if (!ModelState.IsValid)
            {
                await PopulateCreateViewDataAsync(model.MaDanhMuc);
                return View(model);
            }

            try
            {
                await using var transaction = await _context.Database.BeginTransactionAsync(IsolationLevel.Serializable);

                var maSanPham = await GenerateMaSanPhamAsync();
                var giaCoBan = model.GiaSizeNho!.Value;
                var sanPham = new SanPham
                {
                    MaSanPham = maSanPham,
                    MaDanhMuc = model.MaDanhMuc,
                    TenSanPham = model.TenSanPham,
                    GiaCoBan = giaCoBan,
                    TrangThai = model.TrangThai,
                    MoTa = model.MoTa
                };

                _context.SanPhams.Add(sanPham);
                await _context.SaveChangesAsync();

                var existingBranchMappings = await _context.SanPhamChiNhanhs
                    .Where(s => s.MaSanPham == maSanPham)
                    .ToListAsync();
                var selectedBranchSet = selectedBranchCodes.ToHashSet();

                foreach (var branchMapping in existingBranchMappings)
                {
                    if (selectedBranchSet.Contains(branchMapping.MaChiNhanh))
                    {
                        branchMapping.GiaBan = giaCoBan;
                        branchMapping.TrangThai = model.TrangThai;
                    }
                    else
                    {
                        _context.SanPhamChiNhanhs.Remove(branchMapping);
                    }
                }

                var existingBranchSet = existingBranchMappings
                    .Select(s => s.MaChiNhanh)
                    .ToHashSet();

                foreach (var maChiNhanh in selectedBranchCodes.Where(m => !existingBranchSet.Contains(m)))
                {
                    _context.SanPhamChiNhanhs.Add(new SanPhamChiNhanh
                    {
                        MaChiNhanh = maChiNhanh,
                        MaSanPham = maSanPham,
                        GiaBan = giaCoBan,
                        TrangThai = model.TrangThai
                    });
                }

                var existingBienTheCodes = await _context.BienTheSanPhams
                    .AsNoTracking()
                    .Select(b => b.MaBienThe)
                    .ToListAsync();

                _context.BienTheSanPhams.AddRange(BuildBienTheSanPhams(maSanPham, model, existingBienTheCodes));
                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                TempData["Success"] = "Thêm sản phẩm thành công!";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Lỗi: {ex.InnerException?.Message ?? ex.Message}";
                await PopulateCreateViewDataAsync(model.MaDanhMuc);
                return View(model);
            }
        }

        [HttpGet]
        [RoleAuthorize("ADMIN", "QUAN_LY")]
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
        [RoleAuthorize("ADMIN", "QUAN_LY")]
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
                var sanPham = await _context.SanPhams.FindAsync(model.MaSanPham);
                if (sanPham == null)
                {
                    TempData["Error"] = "Không tìm thấy sản phẩm!";
                    return RedirectToAction(nameof(Index));
                }

                sanPham.MaDanhMuc = model.MaDanhMuc;
                sanPham.TenSanPham = model.TenSanPham;
                sanPham.GiaCoBan = model.GiaCoBan;
                sanPham.TrangThai = model.TrangThai;
                sanPham.MoTa = model.MoTa;

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
        [RoleAuthorize("ADMIN", "QUAN_LY")]
        [ValidateAntiForgeryToken]
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

        [RoleAuthorize("ADMIN", "NHAN_VIEN", "QUAN_LY")]
        public async Task<IActionResult> Menu(string? chiNhanh)
        {
            // Phân quyền theo chi nhánh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                // Nhân viên/Quản lý: Chỉ xem chi nhánh của mình
                chiNhanh = chiNhanhFilter;
            }

            // Lọc danh sách chi nhánh theo quyền
            var chiNhanhsQuery = _context.ChiNhanhs.Where(c => c.TrangThai);
            if (chiNhanhFilter != null)
            {
                chiNhanhsQuery = chiNhanhsQuery.Where(c => c.MaChiNhanh == chiNhanhFilter);
            }

            var chiNhanhs = await chiNhanhsQuery.OrderBy(c => c.TenChiNhanh).ToListAsync();
            ViewBag.ChiNhanhs = chiNhanhs;
            ViewBag.IsAdmin = chiNhanhFilter == null; // Admin không có filter chi nhánh

            // Admin chưa chọn chi nhánh: Mặc định chọn chi nhánh đầu tiên
            if (chiNhanhFilter == null && string.IsNullOrEmpty(chiNhanh))
            {
                chiNhanh = chiNhanhs.FirstOrDefault()?.MaChiNhanh;
                
                // Nếu không có chi nhánh nào, trả về empty
                if (string.IsNullOrEmpty(chiNhanh))
                {
                    ViewBag.ChiNhanh = null;
                    return View(new List<VwMenuChiNhanh>());
                }
            }

            ViewBag.ChiNhanh = chiNhanh;

            // Truy vấn trực tiếp từ bảng để đồng bộ 100% với sản phẩm, danh mục, biến thể và giá bán chi nhánh thực tế
            var query = from spcn in _context.SanPhamChiNhanhs
                        join cn in _context.ChiNhanhs on spcn.MaChiNhanh equals cn.MaChiNhanh
                        join sp in _context.SanPhams on spcn.MaSanPham equals sp.MaSanPham
                        join dm in _context.DanhMucs on sp.MaDanhMuc equals dm.MaDanhMuc
                        join bt in _context.BienTheSanPhams on sp.MaSanPham equals bt.MaSanPham
                        where cn.TrangThai && sp.TrangThai && bt.TrangThai && spcn.TrangThai
                        select new VwMenuChiNhanh
                        {
                            MaChiNhanh = cn.MaChiNhanh,
                            TenChiNhanh = cn.TenChiNhanh,
                            TenDanhMuc = dm.TenDanhMuc,
                            MaSanPham = sp.MaSanPham,
                            TenSanPham = sp.TenSanPham,
                            MaBienThe = bt.MaBienThe,
                            Size = bt.Size,
                            GiaBanThucTe = spcn.GiaBan + bt.GiaCongThem,
                            TrangThaiMenu = spcn.TrangThai
                        };

            // Lọc theo chi nhánh đã chọn (bắt buộc phải có)
            if (!string.IsNullOrEmpty(chiNhanh))
            {
                query = query.Where(m => m.MaChiNhanh == chiNhanh);
            }

            return View(await query.ToListAsync());
        }

        private async Task PopulateCreateViewDataAsync(string? selectedDanhMuc = null)
        {
            ViewBag.DanhMucs = new SelectList(
                await _context.DanhMucs
                    .AsNoTracking()
                    .OrderBy(d => d.TenDanhMuc)
                    .ToListAsync(),
                "MaDanhMuc",
                "TenDanhMuc",
                selectedDanhMuc);

            ViewBag.ChiNhanhs = await _context.ChiNhanhs
                .AsNoTracking()
                .Where(c => c.TrangThai)
                .OrderBy(c => c.TenChiNhanh)
                .ToListAsync();
        }

        private static void NormalizeCreateModel(SanPhamCreateViewModel model)
        {
            model.MaDanhMuc = model.MaDanhMuc?.Trim() ?? string.Empty;
            model.TenSanPham = model.TenSanPham?.Trim() ?? string.Empty;
            model.MoTa = string.IsNullOrWhiteSpace(model.MoTa) ? null : model.MoTa.Trim();
            model.MaChiNhanhs = model.MaChiNhanhs?
                .Where(m => !string.IsNullOrWhiteSpace(m))
                .Select(m => m.Trim())
                .Distinct()
                .ToList() ?? new List<string>();
        }

        private void ValidateCreatePrices(SanPhamCreateViewModel model)
        {
            if (model.GiaSizeNho.HasValue &&
                model.GiaSizeVua.HasValue &&
                model.GiaSizeVua.Value < model.GiaSizeNho.Value)
            {
                ModelState.AddModelError(nameof(model.GiaSizeVua), "Giá size Vừa phải lớn hơn hoặc bằng giá size Nhỏ");
            }

            if (model.GiaSizeVua.HasValue &&
                model.GiaSizeLon.HasValue &&
                model.GiaSizeLon.Value < model.GiaSizeVua.Value)
            {
                ModelState.AddModelError(nameof(model.GiaSizeLon), "Giá size Lớn phải lớn hơn hoặc bằng giá size Vừa");
            }
        }

        private static List<BienTheSanPham> BuildBienTheSanPhams(
            string maSanPham,
            SanPhamCreateViewModel model,
            ICollection<string> existingBienTheCodes)
        {
            var giaSizeNho = model.GiaSizeNho!.Value;

            return new List<BienTheSanPham>
            {
                new()
                {
                    MaBienThe = GenerateMaBienThe(existingBienTheCodes),
                    MaSanPham = maSanPham,
                    Size = "Nhỏ",
                    GiaCongThem = 0,
                    TrangThai = model.TrangThai
                },
                new()
                {
                    MaBienThe = GenerateMaBienThe(existingBienTheCodes),
                    MaSanPham = maSanPham,
                    Size = "Vừa",
                    GiaCongThem = model.GiaSizeVua!.Value - giaSizeNho,
                    TrangThai = model.TrangThai
                },
                new()
                {
                    MaBienThe = GenerateMaBienThe(existingBienTheCodes),
                    MaSanPham = maSanPham,
                    Size = "Lớn",
                    GiaCongThem = model.GiaSizeLon!.Value - giaSizeNho,
                    TrangThai = model.TrangThai
                }
            };
        }

        private static string GenerateMaBienThe(ICollection<string> existingCodes)
        {
            var newCode = CodeGenerator.GenerateNext("BT", 8, existingCodes);
            existingCodes.Add(newCode);
            return newCode;
        }

        private async Task<string> GenerateMaSanPhamAsync()
        {
            var existingCodes = await _context.SanPhams
                .AsNoTracking()
                .Select(s => s.MaSanPham)
                .ToListAsync();

            return CodeGenerator.GenerateNext("SP", 8, existingCodes);
        }

    }
}
