using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    public class VwMenuChiNhanh
    {
        public string? MaChiNhanh { get; set; }
        public string? TenChiNhanh { get; set; }
        public string? TenDanhMuc { get; set; }
        public string? MaSanPham { get; set; }
        public string? TenSanPham { get; set; }
        public string? MaBienThe { get; set; }
        public string? Size { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal? GiaBanThucTe { get; set; }
        
        public bool? TrangThaiMenu { get; set; }
    }
}
