using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.ViewModels;
using System.Data;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class DonHangService
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public DonHangService(QuanLyChuoiCaPheContext context)
        {
            _context = context;
        }

        public async Task<string> TaoDonHangAsync(DonHangCreateViewModel model)
        {
            var maDH = GenerateMaDonHang();

            // Tạo parameters cho stored procedure
            var parameters = new[]
            {
                new SqlParameter("@MaDH", SqlDbType.Char, 6) { Value = maDH },
                new SqlParameter("@MaChiNhanh", SqlDbType.Char, 10) { Value = model.MaChiNhanh },
                new SqlParameter("@MaNV", SqlDbType.Char, 10) { Value = model.MaNV },
                new SqlParameter("@MaKH", SqlDbType.Char, 6) { Value = (object?)model.MaKH ?? DBNull.Value },
                new SqlParameter("@PhuongThucThanhToan", SqlDbType.NVarChar, 30) { Value = model.PhuongThucThanhToan },
                new SqlParameter("@GiamGia", SqlDbType.Decimal) { Value = model.GiamGia, Precision = 18, Scale = 2 }
            };

            // Gọi stored procedure sp_TaoDonHang
            await _context.Database.ExecuteSqlRawAsync(
                "EXEC sp_TaoDonHang @MaDH, @MaChiNhanh, @MaNV, @MaKH, @PhuongThucThanhToan, @GiamGia",
                parameters);

            // Thêm chi tiết đơn hàng
            foreach (var item in model.ChiTietDonHangs)
            {
                var maCTDH = GenerateMaChiTietDonHang();
                
                var detailParams = new[]
                {
                    new SqlParameter("@MaCTDH", SqlDbType.Char, 10) { Value = maCTDH },
                    new SqlParameter("@MaDH", SqlDbType.Char, 6) { Value = maDH },
                    new SqlParameter("@MaBienThe", SqlDbType.Char, 10) { Value = item.MaBienThe },
                    new SqlParameter("@SoLuong", SqlDbType.Int) { Value = item.SoLuong },
                    new SqlParameter("@DonGia", SqlDbType.Decimal) { Value = item.DonGia, Precision = 18, Scale = 2 }
                };

                await _context.Database.ExecuteSqlRawAsync(
                    @"INSERT INTO ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia) 
                      VALUES (@MaCTDH, @MaDH, @MaBienThe, @SoLuong, @DonGia)",
                    detailParams);
            }

            return maDH;
        }

        private string GenerateMaDonHang()
        {
            var random = new Random();
            var number = random.Next(100000, 999999);
            return $"DH{number}";
        }

        private string GenerateMaChiTietDonHang()
        {
            var random = new Random();
            var number = random.Next(10000000, 99999999);
            return $"CT{number}";
        }
    }
}
