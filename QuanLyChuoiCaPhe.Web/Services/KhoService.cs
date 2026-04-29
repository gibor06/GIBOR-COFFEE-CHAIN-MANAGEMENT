using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.ViewModels;
using System.Data;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class KhoService
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public KhoService(QuanLyChuoiCaPheContext context)
        {
            _context = context;
        }

        public async Task GhiNhanGiaoDichKhoAsync(KhoGiaoDichViewModel model)
        {
            var logID = GenerateLogID();

            var parameters = new[]
            {
                new SqlParameter("@LogID", SqlDbType.Char, 10) { Value = logID },
                new SqlParameter("@MaChiNhanh", SqlDbType.Char, 10) { Value = model.MaChiNhanh },
                new SqlParameter("@MaNguyenLieu", SqlDbType.Char, 10) { Value = model.MaNguyenLieu },
                new SqlParameter("@LoaiGiaoDich", SqlDbType.NVarChar, 20) { Value = model.LoaiGiaoDich },
                new SqlParameter("@SoLuong", SqlDbType.Decimal) { Value = model.SoLuong, Precision = 18, Scale = 2 },
                new SqlParameter("@GhiChu", SqlDbType.NVarChar, 255) { Value = (object?)model.GhiChu ?? DBNull.Value }
            };

            await _context.Database.ExecuteSqlRawAsync(
                "EXEC sp_GhiNhanGiaoDichKho @LogID, @MaChiNhanh, @MaNguyenLieu, @LoaiGiaoDich, @SoLuong, @GhiChu",
                parameters);
        }

        public async Task CanhBaoTonKhoAsync()
        {
            await _context.Database.ExecuteSqlRawAsync("EXEC sp_CanhBaoTonKho");
        }

        private string GenerateLogID()
        {
            var random = new Random();
            var number = random.Next(1000000000, int.MaxValue);
            return $"L{number}";
        }
    }
}
