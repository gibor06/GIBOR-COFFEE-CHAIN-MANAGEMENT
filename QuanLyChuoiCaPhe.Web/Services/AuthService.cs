using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Models;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class AuthService
    {
        private readonly QuanLyChuoiCaPheContext _context;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly PasswordService _passwordService;

        public AuthService(
            QuanLyChuoiCaPheContext context,
            IHttpContextAccessor httpContextAccessor,
            PasswordService passwordService)
        {
            _context = context;
            _httpContextAccessor = httpContextAccessor;
            _passwordService = passwordService;
        }

        public async Task<HeThongTaiKhoan?> LoginAsync(string tenDangNhap, string matKhau)
        {
            var taiKhoan = await _context.HeThongTaiKhoans
                .FirstOrDefaultAsync(t => t.TenDangNhap == tenDangNhap);

            if (taiKhoan == null ||
                !_passwordService.VerifyPassword(taiKhoan, matKhau, out var needsRehash) ||
                !taiKhoan.TrangThai)
            {
                return null;
            }

            if (taiKhoan.VaiTro != "ADMIN")
            {
                var taiKhoanNV = await _context.TaiKhoanNhanViens
                    .Include(t => t.ThongTinNhanVien)
                    .FirstOrDefaultAsync(t => t.MaTK == taiKhoan.MaTK);

                if (taiKhoanNV == null ||
                    taiKhoanNV.ThongTinNhanVien.NgayNghiViec != null ||
                    !taiKhoanNV.ThongTinNhanVien.TrangThai)
                {
                    return null;
                }
            }

            if (needsRehash)
            {
                taiKhoan.MatKhauHash = _passwordService.HashPassword(taiKhoan, matKhau);
                await _context.SaveChangesAsync();
            }

            return taiKhoan;
        }

        public async Task SetSessionAsync(HeThongTaiKhoan taiKhoan)
        {
            var session = _httpContextAccessor.HttpContext?.Session;
            if (session == null)
            {
                return;
            }

            session.SetString("MaTK", taiKhoan.MaTK);
            session.SetString("TenDangNhap", taiKhoan.TenDangNhap);
            session.SetString("VaiTro", taiKhoan.VaiTro);
            session.SetString("UserRole", taiKhoan.VaiTro);

            session.Remove("MaNV");
            session.Remove("MaChiNhanh");

            if (taiKhoan.VaiTro == "ADMIN")
            {
                return;
            }

            var taiKhoanNV = await _context.TaiKhoanNhanViens
                .Include(t => t.ThongTinNhanVien)
                .FirstOrDefaultAsync(t => t.MaTK == taiKhoan.MaTK);

            if (taiKhoanNV != null)
            {
                session.SetString("MaNV", taiKhoanNV.MaNV);
                session.SetString("MaChiNhanh", taiKhoanNV.ThongTinNhanVien.MaChiNhanh);
            }
        }

        public void ClearSession()
        {
            _httpContextAccessor.HttpContext?.Session.Clear();
        }

        public string? GetCurrentMaTK()
        {
            return _httpContextAccessor.HttpContext?.Session.GetString("MaTK");
        }

        public string? GetCurrentVaiTro()
        {
            return _httpContextAccessor.HttpContext?.Session.GetString("VaiTro");
        }

        public string? GetCurrentTenDangNhap()
        {
            return _httpContextAccessor.HttpContext?.Session.GetString("TenDangNhap");
        }

        public string? GetCurrentMaNV()
        {
            return _httpContextAccessor.HttpContext?.Session.GetString("MaNV");
        }

        public string? GetCurrentMaChiNhanh()
        {
            return _httpContextAccessor.HttpContext?.Session.GetString("MaChiNhanh");
        }

        public bool IsAdmin()
        {
            return GetCurrentVaiTro() == "ADMIN";
        }

        public bool IsQuanLy()
        {
            return GetCurrentVaiTro() == "QUAN_LY";
        }

        public bool IsNhanVien()
        {
            return GetCurrentVaiTro() == "NHAN_VIEN";
        }
    }
}
