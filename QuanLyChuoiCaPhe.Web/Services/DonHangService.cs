using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.ViewModels;
using QuanLyChuoiCaPhe.Web.Models;
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

        public async Task<string> TaoDonHangAsync(DonHangCreateViewModel model, string nguoiThucHien)
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

            // Ghi nhật ký hành trình: Khởi tạo đơn hàng
            _context.HanhTrinhDonHangs.Add(new HanhTrinhDonHang
            {
                MaDH = maDH,
                HanhDong = "Khởi tạo đơn hàng mới",
                NguoiThucHien = nguoiThucHien,
                ThoiGian = DateTime.Now
            });

            // Ghi nhật ký hành trình: Áp dụng voucher/giảm giá nếu có
            if (model.GiamGia > 0)
            {
                _context.HanhTrinhDonHangs.Add(new HanhTrinhDonHang
                {
                    MaDH = maDH,
                    HanhDong = $"Áp dụng giảm giá: {model.GiamGia.ToString("N0")} đ",
                    NguoiThucHien = nguoiThucHien,
                    ThoiGian = DateTime.Now
                });
            }

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

                // Lấy thông tin sản phẩm để ghi log chi tiết
                var bienThe = await _context.BienTheSanPhams
                    .Include(b => b.SanPham)
                    .FirstOrDefaultAsync(b => b.MaBienThe == item.MaBienThe);
                var detailName = bienThe != null ? $"{bienThe.SanPham.TenSanPham} (Size {bienThe.Size})" : item.MaBienThe;

                _context.HanhTrinhDonHangs.Add(new HanhTrinhDonHang
                {
                    MaDH = maDH,
                    HanhDong = $"Thêm món: {detailName}, Số lượng: {item.SoLuong}, Đơn giá: {item.DonGia.ToString("N0")} đ",
                    NguoiThucHien = nguoiThucHien,
                    ThoiGian = DateTime.Now
                });
            }

            // Cập nhật trạng thái đơn hàng thành 'Hoàn tất' sau khi chèn xong tất cả các chi tiết từ C#
            var donHang = await _context.DonHangs.FindAsync(maDH);
            if (donHang != null)
            {
                donHang.TrangThai = "Hoàn tất";
            }

            await _context.SaveChangesAsync();

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
