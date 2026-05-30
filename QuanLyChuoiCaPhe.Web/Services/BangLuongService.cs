using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.ViewModels;
using QuanLyChuoiCaPhe.Web.Models;
using System.Data;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class BangLuongService
    {
        private readonly QuanLyChuoiCaPheContext _context;

        public BangLuongService(QuanLyChuoiCaPheContext context)
        {
            _context = context;
        }

        public async Task KhoiTaoBangLuongAsync(BangLuongCreateViewModel model, string? maChiNhanhFilter)
        {
            // Bước 1: Khởi tạo các dòng trống trong bảng BangLuong cho nhân viên thuộc chi nhánh lọc
            var employeesQuery = _context.ThongTinNhanViens.Where(nv => nv.TrangThai);
            if (!string.IsNullOrEmpty(maChiNhanhFilter))
            {
                employeesQuery = employeesQuery.Where(nv => nv.MaChiNhanh == maChiNhanhFilter);
            }
            
            var employees = await employeesQuery.ToListAsync();
            foreach (var nv in employees)
            {
                var exists = await _context.BangLuongs.AnyAsync(bl => bl.MaNV == nv.MaNV && bl.Thang == model.Thang && bl.Nam == model.Nam);
                if (!exists)
                {
                    var bl = new BangLuong
                    {
                        MaNV = nv.MaNV,
                        Thang = model.Thang,
                        Nam = model.Nam,
                        TongGioThucTe = 0,
                        TongLuongCa = 0,
                        TongThuong = 0,
                        TongKhauTru = 0,
                        TrangThai = "Tạm tính"
                    };
                    _context.BangLuongs.Add(bl);
                }
            }
            await _context.SaveChangesAsync();

            // Bước 2: Cập nhật thống kê giờ làm, lương ca, khấu trừ phạt cho các dòng bảng lương vừa tạo
            var updateParams = new List<SqlParameter>
            {
                new SqlParameter("@Thang", SqlDbType.TinyInt) { Value = model.Thang },
                new SqlParameter("@Nam", SqlDbType.SmallInt) { Value = model.Nam }
            };

            string branchCondition = "";
            if (!string.IsNullOrEmpty(maChiNhanhFilter))
            {
                branchCondition = " AND nv.MaChiNhanh = @MaChiNhanh ";
                updateParams.Add(new SqlParameter("@MaChiNhanh", SqlDbType.Char, 10) { Value = maChiNhanhFilter });
            }

            var updateQuery = $@"
                UPDATE bl
                SET bl.TongGioThucTe = ISNULL(cc.Gio, 0),
                    bl.TongLuongCa = ISNULL(cc.Luong, 0),
                    bl.TongKhauTru = ISNULL(pd.Phat, 0)
                FROM dbo.BangLuong bl
                JOIN dbo.ThongTinNhanVien nv ON bl.MaNV = nv.MaNV
                OUTER APPLY (
                    SELECT SUM(dbo.fn_SoGioLamViec(GioVao, GioRa)) AS Gio,
                           SUM(LuongThucTe) AS Luong
                    FROM dbo.ChamCong
                    WHERE MaNV = bl.MaNV
                      AND MONTH(GioVao) = @Thang
                      AND YEAR(GioVao) = @Nam
                ) cc
                OUTER APPLY (
                    SELECT SUM(SoTien) AS Phat
                    FROM dbo.PhatDiMuon
                    WHERE MaNV = bl.MaNV
                      AND MONTH(NgayPhat) = @Thang
                      AND YEAR(NgayPhat) = @Nam
                ) pd
                WHERE bl.Thang = @Thang AND bl.Nam = @Nam{branchCondition}";

            await _context.Database.ExecuteSqlRawAsync(updateQuery, updateParams.ToArray());
        }
    }
}
