using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Models;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class AuthService
    {
        private readonly QuanLyChuoiCaPheContext _context;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public AuthService(QuanLyChuoiCaPheContext context, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<HeThongTaiKhoan?> LoginAsync(string tenDangNhap, string matKhau)
        {
            // TODO: Thay thế bằng SHA256 hash khi triển khai thực tế
            // Hiện tại so sánh trực tiếp để test
            var taiKhoan = await _context.HeThongTaiKhoans
                .FirstOrDefaultAsync(t => t.TenDangNhap == tenDangNhap 
                                       && t.MatKhauHash == matKhau);

            if (taiKhoan == null)
            {
                return null;
            }

            // Kiểm tra tài khoản có bị khóa không
            if (!taiKhoan.TrangThai)
            {
                return null; // Tài khoản bị khóa
            }

            // Nếu không phải ADMIN, kiểm tra trạng thái nhân viên
            if (taiKhoan.VaiTro != "ADMIN")
            {
                var taiKhoanNV = await _context.TaiKhoanNhanViens
                    .Include(t => t.ThongTinNhanVien)
                    .FirstOrDefaultAsync(t => t.MaTK == taiKhoan.MaTK);

                if (taiKhoanNV != null)
                {
                    // Kiểm tra nhân viên có nghỉ việc không
                    if (taiKhoanNV.ThongTinNhanVien.NgayNghiViec != null)
                    {
                        return null; // Nhân viên đã nghỉ việc
                    }

                    // Kiểm tra trạng thái nhân viên
                    if (!taiKhoanNV.ThongTinNhanVien.TrangThai)
                    {
                        return null; // Nhân viên bị vô hiệu hóa
                    }
                }
            }

            return taiKhoan;
        }

        public async Task SetSessionAsync(HeThongTaiKhoan taiKhoan)
        {
            var session = _httpContextAccessor.HttpContext?.Session;
            if (session != null)
            {
                session.SetString("MaTK", taiKhoan.MaTK);
                session.SetString("TenDangNhap", taiKhoan.TenDangNhap);
                session.SetString("VaiTro", taiKhoan.VaiTro);
                
                // Lấy thông tin nhân viên nếu không phải ADMIN
                if (taiKhoan.VaiTro != "ADMIN")
                {
                    var taiKhoanNV = await _context.TaiKhoanNhanViens
                        .Include(t => t.ThongTinNhanVien)
                        .FirstOrDefaultAsync(t => t.MaTK == taiKhoan.MaTK);
                    
                    if (taiKhoanNV != null)
                    {
                        session.SetString("MaNV", taiKhoanNV.MaNV);
                        session.SetString("MaChiNhanh", taiKhoanNV.ThongTinNhanVien.MaChiNhanh);
                    }
                }
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
