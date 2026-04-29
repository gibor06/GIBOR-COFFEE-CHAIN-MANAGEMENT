using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    public class VwCanhBaoTonKho
    {
        public string? MaChiNhanh { get; set; }
        public string? TenChiNhanh { get; set; }
        public string? MaNguyenLieu { get; set; }
        public string? TenNguyenLieu { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal? SoLuongTon { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal? MucCanhBao { get; set; }
        
        public string? MucDo { get; set; }
    }
}
