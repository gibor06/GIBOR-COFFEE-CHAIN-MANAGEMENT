using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    public class VwBangLuongTongHop
    {
        public string? MaNV { get; set; }
        public string? HoTenNV { get; set; }
        public string? MaChiNhanh { get; set; }
        public string? TenChiNhanh { get; set; }
        public byte? Thang { get; set; }
        public short? Nam { get; set; }
        
        [Column(TypeName = "decimal(12,2)")]
        public decimal? TongGioThucTe { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal? TongLuongCa { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal? TongThuong { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal? TongKhauTru { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal? ThucLanh { get; set; }
        
        public string? TrangThai { get; set; }
    }
}
