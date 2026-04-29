using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class BaoCaoService
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public BaoCaoService(QuanLyChuoiCaPheContext context)
        {
            _context = context;
        }

        public async Task<Dictionary<string, decimal>> GetDoanhThuTheoChiNhanhAsync(string? maChiNhanh = null)
        {
            var query = _context.DonHangs.Include(d => d.ChiNhanh).AsQueryable();
            
            // Filter theo chi nhánh nếu có
            if (!string.IsNullOrEmpty(maChiNhanh))
            {
                query = query.Where(d => d.MaChiNhanh == maChiNhanh);
            }
            
            var result = await query
                .GroupBy(d => d.ChiNhanh.TenChiNhanh)
                .Select(g => new { TenChiNhanh = g.Key, DoanhThu = g.Sum(d => d.TongTien - d.GiamGia) })
                .ToDictionaryAsync(x => x.TenChiNhanh, x => x.DoanhThu);
            
            return result ?? new Dictionary<string, decimal>();
        }

        public async Task<List<SanPhamBanChay>> GetTopSanPhamBanChayAsync(int top = 10, string? maChiNhanh = null)
        {
            var query = _context.ChiTietDonHangs
                .Include(c => c.DonHang)
                .Include(c => c.BienTheSanPham)
                    .ThenInclude(bt => bt.SanPham)
                .AsQueryable();
            
            // Filter theo chi nhánh nếu có
            if (!string.IsNullOrEmpty(maChiNhanh))
            {
                query = query.Where(c => c.DonHang.MaChiNhanh == maChiNhanh);
            }
            
            var result = await query
                .GroupBy(c => c.MaBienThe)
                .Select(g => new SanPhamBanChay
                {
                    MaBienThe = g.Key,
                    TenSanPham = g.First().BienTheSanPham.SanPham.TenSanPham,
                    Size = g.First().BienTheSanPham.Size,
                    SoLuongBan = g.Sum(c => c.SoLuong),
                    DoanhThu = g.Sum(c => c.SoLuong * c.DonGia)
                })
                .OrderByDescending(x => x.SoLuongBan)
                .Take(top)
                .ToListAsync();
            
            return result ?? new List<SanPhamBanChay>();
        }

        public async Task<List<KhachHangThanThiet>> GetTopKhachHangAsync(int top = 10)
        {
            var result = await _context.KhachHangs
                .OrderByDescending(k => k.DiemTichLuy)
                .Take(top)
                .Select(k => new KhachHangThanThiet
                {
                    MaKH = k.MaKH,
                    TenKH = k.TenKH,
                    SoDienThoai = k.SoDienThoai,
                    DiemTichLuy = k.DiemTichLuy
                })
                .ToListAsync();
            
            return result ?? new List<KhachHangThanThiet>();
        }
    }

    // Helper classes
    public class SanPhamBanChay
    {
        public string MaBienThe { get; set; } = null!;
        public string TenSanPham { get; set; } = null!;
        public string Size { get; set; } = null!;
        public int SoLuongBan { get; set; }
        public decimal DoanhThu { get; set; }
    }

    public class KhachHangThanThiet
    {
        public string MaKH { get; set; } = null!;
        public string TenKH { get; set; } = null!;
        public string SoDienThoai { get; set; } = null!;
        public int DiemTichLuy { get; set; }
    }
}
