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
    public class ChamCongController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public ChamCongController(QuanLyChuoiCaPheContext context, AuthService authService)
            : base(authService)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? maNV, string? trangThai, int? thang, int? nam)
        {
            var query = _context.ChamCongs
                .Include(c => c.ThongTinNhanVien)
                .Include(c => c.LichPhanCong)
                    .ThenInclude(l => l!.CaLamViec)
                .AsQueryable();

            // Phân quyền theo chi nhánh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(c => c.ThongTinNhanVien!.MaChiNhanh == chiNhanhFilter);
            }

            if (!string.IsNullOrEmpty(maNV))
            {
                query = query.Where(c => c.MaNV == maNV);
            }

            if (!string.IsNullOrEmpty(trangThai))
            {
                query = query.Where(c => c.TrangThai == trangThai);
            }

            if (thang.HasValue)
            {
                query = query.Where(c => c.GioVao.Month == thang.Value);
            }

            if (nam.HasValue)
            {
                query = query.Where(c => c.GioVao.Year == nam.Value);
            }

            ViewBag.MaNV = maNV;
            ViewBag.TrangThai = trangThai;
            ViewBag.Thang = thang;
            ViewBag.Nam = nam;

            await LoadNhanVienDropdownAsync();

            return View(await query.OrderByDescending(c => c.GioVao).ToListAsync());
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            await LoadLichPhanCongDropdownAsync();
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ChamCong model)
        {
            ModelState.Remove("ThongTinNhanVien");
            ModelState.Remove("LichPhanCong");
            ModelState.Remove("MaChamCong");
            ModelState.Remove("MaNV");
            ModelState.Remove("TrangThai");
            ModelState.Remove("HeSoNgay");
            ModelState.Remove("HeSoCa");
            ModelState.Remove("LuongThucTe");

            // Validate LichPhanCong tồn tại
            var lichPhanCong = await _context.LichPhanCongs
                .Include(l => l.ThongTinNhanVien)
                .FirstOrDefaultAsync(l => l.MaLich == model.MaLich);

            if (lichPhanCong == null)
            {
                ModelState.AddModelError("MaLich", "Lịch phân công không tồn tại.");
            }
            else
            {
                // Kiểm tra quyền chi nhánh
                if (lichPhanCong.ThongTinNhanVien != null && !CanAccessChiNhanh(lichPhanCong.ThongTinNhanVien.MaChiNhanh))
                {
                    ModelState.AddModelError("MaLich", "Bạn không có quyền chấm công nhân viên chi nhánh khác.");
                }

                // Không chấm công ca Hủy ca/Nghỉ phép
                if (lichPhanCong.TrangThai == "Hủy ca" || lichPhanCong.TrangThai == "Nghỉ phép")
                {
                    ModelState.AddModelError("MaLich", $"Không thể chấm công cho lịch có trạng thái '{lichPhanCong.TrangThai}'.");
                }

                // Lấy MaNV từ LichPhanCong
                model.MaNV = lichPhanCong.MaNV;

                // Kiểm tra trùng chấm công
                if (await _context.ChamCongs.AnyAsync(c => c.MaNV == model.MaNV && c.MaLich == model.MaLich))
                {
                    ModelState.AddModelError("MaLich", "Nhân viên đã được chấm công cho lịch phân công này.");
                }
            }

            if (model.GioVao == default)
            {
                ModelState.AddModelError("GioVao", "Giờ vào không được để trống.");
            }

            if (model.GioRa == default)
            {
                ModelState.AddModelError("GioRa", "Giờ ra không được để trống.");
            }

            if (!ModelState.IsValid)
            {
                await LoadLichPhanCongDropdownAsync();
                return View(model);
            }

            try
            {
                // Auto generate MaChamCong
                model.MaChamCong = await GenerateMaChamCongAsync();

                // Không set các trường trigger tự tính
                model.TrangThai = null;
                model.HeSoNgay = null;
                model.HeSoCa = null;
                model.LuongThucTe = null;

                _context.ChamCongs.Add(model);
                await _context.SaveChangesAsync();

                TempData["Success"] = "Chấm công đã được lưu. Hệ thống đã tự động tính trạng thái và lương thực tế.";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                var errorMsg = ex.InnerException?.Message ?? ex.Message;
                TempData["Error"] = $"Lỗi: {errorMsg}";
                await LoadLichPhanCongDropdownAsync();
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            var chamCong = await _context.ChamCongs
                .Include(c => c.ThongTinNhanVien)
                .Include(c => c.LichPhanCong)
                    .ThenInclude(l => l!.CaLamViec)
                .FirstOrDefaultAsync(c => c.MaChamCong == id);

            if (chamCong == null)
            {
                TempData["Error"] = "Không tìm thấy bản ghi chấm công!";
                return RedirectToAction(nameof(Index));
            }

            if (chamCong.ThongTinNhanVien != null && !CanAccessChiNhanh(chamCong.ThongTinNhanVien.MaChiNhanh))
            {
                TempData["Error"] = "Bạn không có quyền chỉnh sửa chấm công này!";
                return RedirectToAction(nameof(Index));
            }

            return View(chamCong);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(ChamCong model)
        {
            ModelState.Remove("ThongTinNhanVien");
            ModelState.Remove("LichPhanCong");
            ModelState.Remove("TrangThai");
            ModelState.Remove("HeSoNgay");
            ModelState.Remove("HeSoCa");
            ModelState.Remove("LuongThucTe");

            if (model.GioVao == default)
            {
                ModelState.AddModelError("GioVao", "Giờ vào không được để trống.");
            }
            if (model.GioRa == default)
            {
                ModelState.AddModelError("GioRa", "Giờ ra không được để trống.");
            }

            if (!ModelState.IsValid)
            {
                var ccReload = await _context.ChamCongs
                    .Include(c => c.ThongTinNhanVien)
                    .Include(c => c.LichPhanCong)
                        .ThenInclude(l => l!.CaLamViec)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(c => c.MaChamCong == model.MaChamCong);
                if (ccReload != null)
                {
                    model.ThongTinNhanVien = ccReload.ThongTinNhanVien;
                    model.LichPhanCong = ccReload.LichPhanCong;
                    model.MaNV = ccReload.MaNV;
                    model.MaLich = ccReload.MaLich;
                }
                return View(model);
            }

            try
            {
                var chamCong = await _context.ChamCongs
                    .Include(c => c.ThongTinNhanVien)
                    .FirstOrDefaultAsync(c => c.MaChamCong == model.MaChamCong);

                if (chamCong == null)
                {
                    TempData["Error"] = "Không tìm thấy bản ghi chấm công!";
                    return RedirectToAction(nameof(Index));
                }

                if (chamCong.ThongTinNhanVien != null && !CanAccessChiNhanh(chamCong.ThongTinNhanVien.MaChiNhanh))
                {
                    TempData["Error"] = "Bạn không có quyền chỉnh sửa chấm công này!";
                    return RedirectToAction(nameof(Index));
                }

                chamCong.GioVao = model.GioVao;
                chamCong.GioRa = model.GioRa;
                // Không gán TrangThai, HeSoNgay, HeSoCa, LuongThucTe - trigger tự tính

                await _context.SaveChangesAsync();

                // Reload dữ liệu từ database để lấy kết quả trigger
                await _context.Entry(chamCong).ReloadAsync();

                TempData["Success"] = "Chấm công đã được lưu. Hệ thống đã tự động tính trạng thái và lương thực tế.";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                var errorMsg = ex.InnerException?.Message ?? ex.Message;
                TempData["Error"] = $"Lỗi: {errorMsg}";

                var ccReload = await _context.ChamCongs
                    .Include(c => c.ThongTinNhanVien)
                    .Include(c => c.LichPhanCong)
                        .ThenInclude(l => l!.CaLamViec)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(c => c.MaChamCong == model.MaChamCong);
                if (ccReload != null)
                {
                    model.ThongTinNhanVien = ccReload.ThongTinNhanVien;
                    model.LichPhanCong = ccReload.LichPhanCong;
                    model.MaNV = ccReload.MaNV;
                    model.MaLich = ccReload.MaLich;
                }
                return View(model);
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

        private async Task LoadLichPhanCongDropdownAsync()
        {
            var chiNhanhFilter = GetChiNhanhFilter();
            var lichQuery = _context.LichPhanCongs
                .Include(l => l.ThongTinNhanVien)
                .Include(l => l.CaLamViec)
                .Where(l => l.TrangThai == "Đã phân công");

            if (chiNhanhFilter != null)
            {
                lichQuery = lichQuery.Where(l => l.ThongTinNhanVien!.MaChiNhanh == chiNhanhFilter);
            }

            // Chỉ hiển thị lịch chưa chấm công
            var lichDaChamCong = _context.ChamCongs.Select(c => c.MaLich);
            lichQuery = lichQuery.Where(l => !lichDaChamCong.Contains(l.MaLich));

            var lichList = await lichQuery.OrderByDescending(l => l.NgayLamViec).ToListAsync();
            ViewBag.LichPhanCongs = lichList.Select(l => new SelectListItem
            {
                Value = l.MaLich,
                Text = $"{l.MaLich} - {l.ThongTinNhanVien?.HoTenNV} - {l.CaLamViec?.TenCa} - {l.NgayLamViec:dd/MM/yyyy}"
            }).ToList();
        }

        private async Task<string> GenerateMaChamCongAsync()
        {
            var existingCodes = await _context.ChamCongs
                .AsNoTracking()
                .Select(c => c.MaChamCong)
                .ToListAsync();

            return CodeGenerator.GenerateNext("CC", 8, existingCodes);
        }
    }
}
