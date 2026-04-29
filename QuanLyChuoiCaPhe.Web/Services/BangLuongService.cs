using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.ViewModels;
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

        public async Task KhoiTaoBangLuongAsync(BangLuongCreateViewModel model)
        {
            var parameters = new[]
            {
                new SqlParameter("@Thang", SqlDbType.TinyInt) { Value = model.Thang },
                new SqlParameter("@Nam", SqlDbType.SmallInt) { Value = model.Nam }
            };

            await _context.Database.ExecuteSqlRawAsync(
                "EXEC sp_KhoiTaoBangLuong @Thang, @Nam",
                parameters);
        }
    }
}
