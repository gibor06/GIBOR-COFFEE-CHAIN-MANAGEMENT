using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.ViewModels;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class KhoService
    {
        private static readonly string[] ValidTransactionTypes =
        [
            "Nhập",
            "Xuất",
            "Hao hụt",
            "Hết hạn",
            "Điều chỉnh"
        ];

        private static readonly string[] StockReductionTypes =
        [
            "Xuất",
            "Hao hụt",
            "Hết hạn",
            "Điều chỉnh"
        ];

        private readonly QuanLyChuoiCaPheContext _context;

        public KhoService(QuanLyChuoiCaPheContext context)
        {
            _context = context;
        }

        public async Task GhiNhanGiaoDichKhoAsync(KhoGiaoDichViewModel model)
        {
            ValidateGiaoDich(model);

            await using var transaction = await _context.Database.BeginTransactionAsync(IsolationLevel.Serializable);

            var tonKho = await _context.TonKhoNguyenLieus
                .AsNoTracking()
                .FirstOrDefaultAsync(t => t.MaChiNhanh == model.MaChiNhanh && t.MaNguyenLieu == model.MaNguyenLieu);

            if (tonKho == null)
            {
                throw new InvalidOperationException("Chưa khởi tạo tồn kho cho chi nhánh và nguyên liệu này.");
            }

            if (StockReductionTypes.Contains(model.LoaiGiaoDich) && tonKho.SoLuongTon < model.SoLuong)
            {
                throw new InvalidOperationException("Số lượng tồn kho không đủ để thực hiện giao dịch xuất/trừ.");
            }

            var logID = await GenerateLogIDAsync();

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

            await transaction.CommitAsync();
        }

        public async Task CanhBaoTonKhoAsync()
        {
            await _context.Database.ExecuteSqlRawAsync("EXEC sp_CanhBaoTonKho");
        }

        private static void ValidateGiaoDich(KhoGiaoDichViewModel model)
        {
            if (string.IsNullOrWhiteSpace(model.MaChiNhanh) || string.IsNullOrWhiteSpace(model.MaNguyenLieu))
            {
                throw new InvalidOperationException("Chi nhánh và nguyên liệu là bắt buộc.");
            }

            if (!ValidTransactionTypes.Contains(model.LoaiGiaoDich))
            {
                throw new InvalidOperationException("Loại giao dịch kho không hợp lệ.");
            }

            if (model.SoLuong <= 0)
            {
                throw new InvalidOperationException("Số lượng phải lớn hơn 0.");
            }
        }

        private async Task<string> GenerateLogIDAsync()
        {
            var existingCodes = await _context.LichSuKhos
                .AsNoTracking()
                .Select(l => l.LogID)
                .ToListAsync();

            return CodeGenerator.GenerateNext("L", 9, existingCodes);
        }
    }
}
