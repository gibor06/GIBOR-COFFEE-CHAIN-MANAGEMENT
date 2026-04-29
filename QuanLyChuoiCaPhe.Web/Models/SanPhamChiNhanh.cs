using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("SanPham_ChiNhanh")]
    public class SanPhamChiNhanh
    {
        [StringLength(10)]
        public string MaChiNhanh { get; set; } = null!;
        
        [StringLength(10)]
        public string MaSanPham { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal GiaBan { get; set; }
        
        public bool TrangThai { get; set; }
    }
}
