using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Filters;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.Services;

namespace QuanLyChuoiCaPhe.Web.Controllers
{
    [RoleAuthorize("ADMIN", "QUAN_LY", "KE_TOAN")]
    public class PhatDiMuonController : BaseController
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public PhatDiMuonController(QuanLyChuoiCaPheContext context, AuthService authService)
            : base(authService)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? maNV, int? thang, int? nam)
        {
            var query = _context.PhatDiMuons
                .Include(p => p.ThongTinNhanVien)
                .Include(p => p.ChamCong)
                .AsQueryable();

            // Phân quyền theo chi nhánh
            var chiNhanhFilter = GetChiNhanhFilter();
            if (chiNhanhFilter != null)
            {
                query = query.Where(p => p.ThongTinNhanVien!.MaChiNhanh == chiNhanhFilter);
            }

            if (!string.IsNullOrEmpty(maNV))
            {
                query = query.Where(p => p.MaNV == maNV);
            }

            if (thang.HasValue)
            {
                query = query.Where(p => p.NgayPhat.Month == thang.Value);
            }

            if (nam.HasValue)
            {
                query = query.Where(p => p.NgayPhat.Year == nam.Value);
            }

            var data = await query.OrderByDescending(p => p.NgayPhat).ToListAsync();

            ViewBag.MaNV = maNV;
            ViewBag.Thang = thang;
            ViewBag.Nam = nam;
            ViewBag.TongLanPhat = data.Count;
            ViewBag.TongTienPhat = data.Sum(p => p.SoTien);

            // Load dropdown nhân viên
            var chiNhanhFilterDd = GetChiNhanhFilter();
            var nhanViensQuery = _context.ThongTinNhanViens.AsQueryable();
            if (chiNhanhFilterDd != null)
            {
                nhanViensQuery = nhanViensQuery.Where(n => n.MaChiNhanh == chiNhanhFilterDd);
            }
            var nhanViens = await nhanViensQuery.OrderBy(n => n.HoTenNV).ToListAsync();
            ViewBag.NhanViens = nhanViens.Select(n => new SelectListItem
            {
                Value = n.MaNV,
                Text = $"{n.MaNV} - {n.HoTenNV}"
            }).ToList();

            return View(data);
        }
    }
}
