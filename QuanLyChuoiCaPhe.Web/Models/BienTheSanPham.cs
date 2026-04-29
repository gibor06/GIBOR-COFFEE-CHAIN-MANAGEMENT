using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("BienTheSanPham")]
    public class BienTheSanPham
    {
        [Key]
        [StringLength(10)]
        public string MaBienThe { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaSanPham { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string Size { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal GiaCongThem { get; set; }
        
        public bool TrangThai { get; set; }
        
        [ForeignKey("MaSanPham")]
        public virtual SanPham SanPham { get; set; } = null!;
    }
}
