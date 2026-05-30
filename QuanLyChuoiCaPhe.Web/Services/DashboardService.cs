using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.ViewModels;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class DashboardService
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public DashboardService(QuanLyChuoiCaPheContext context)
        {
            _context = context;
        }

        public async Task<DashboardViewModel> GetDashboardDataAsync()
        {
            var today = DateTime.Today;
            var currentYear = DateTime.Now.Year;
            var startOfLast7Days = today.AddDays(-6);

            var model = new DashboardViewModel
            {
                TongChiNhanh = await _context.ChiNhanhs.CountAsync(c => c.TrangThai),
                TongNhanVien = await _context.ThongTinNhanViens.CountAsync(n => n.TrangThai),
                TongSanPham = await _context.SanPhams.CountAsync(s => s.TrangThai),
                TongDonHang = await _context.DonHangs.CountAsync(),
                DoanhThuHomNay = await _context.DonHangs
                    .Where(d => d.NgayTao.Date == today)
                    .SumAsync(d => (decimal?)d.TongTien - d.GiamGia) ?? 0,
                SoCanhBaoTonKho = await _context.VwCanhBaoTonKhos.CountAsync(),
                BangLuongTamTinh = await _context.BangLuongs
                    .Where(b => b.TrangThai == "Tạm tính")
                    .SumAsync(b => (decimal?)b.ThucLanh) ?? 0
            };

            // Doanh thu 7 ngày gần nhất (liên tục, kể cả ngày không có đơn).
            var revenueByDate = await _context.DonHangs
                .Where(d => d.NgayTao.Date >= startOfLast7Days && d.NgayTao.Date <= today)
                .GroupBy(d => d.NgayTao.Date)
                .Select(g => new
                {
                    Ngay = g.Key,
                    DoanhThu = g.Sum(d => d.TongTien - d.GiamGia)
                })
                .ToListAsync();

            var revenueLookup = revenueByDate.ToDictionary(x => x.Ngay, x => x.DoanhThu);
            model.DoanhThu7Ngay = Enumerable.Range(0, 7)
                .Select(offset =>
                {
                    var ngay = startOfLast7Days.AddDays(offset);
                    return new DoanhThuNgay
                    {
                        Ngay = ngay,
                        DoanhThu = revenueLookup.TryGetValue(ngay, out var doanhThu) ? doanhThu : 0m
                    };
                })
                .ToList();

            // Đơn hàng gần đây
            model.DonHangGanDay = await _context.DonHangs
                .AsNoTracking()
                .Include(d => d.ChiNhanh)
                .Include(d => d.ThongTinNhanVien)
                .OrderByDescending(d => d.NgayTao)
                .Take(10)
                .Select(d => new DonHangGanDay
                {
                    MaDH = d.MaDH,
                    TenChiNhanh = d.ChiNhanh.TenChiNhanh,
                    TenNhanVien = d.ThongTinNhanVien.HoTenNV,
                    TongTien = d.TongTien - d.GiamGia,
                    NgayTao = d.NgayTao,
                    TrangThai = d.TrangThai
                })
                .ToListAsync();

            // Doanh thu theo tháng
            model.DoanhThuTheoThang = await _context.DonHangs
                .AsNoTracking()
                .Where(d => d.NgayTao.Year == currentYear)
                .GroupBy(d => d.NgayTao.Month)
                .Select(g => new DoanhThuThang
                {
                    Thang = g.Key,
                    DoanhThu = g.Sum(d => d.TongTien - d.GiamGia)
                })
                .OrderBy(d => d.Thang)
                .ToListAsync();

            // Đảm bảo có đủ 12 tháng
            for (int i = 1; i <= 12; i++)
            {
                if (!model.DoanhThuTheoThang.Any(d => d.Thang == i))
                {
                    model.DoanhThuTheoThang.Add(new DoanhThuThang { Thang = i, DoanhThu = 0 });
                }
            }

            model.DoanhThuTheoThang = model.DoanhThuTheoThang.OrderBy(d => d.Thang).ToList();
            return model;
        }
    }
}
