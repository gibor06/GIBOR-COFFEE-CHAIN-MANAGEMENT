using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("SanPham")]
    public class SanPham
    {
        [Key]
        [StringLength(10)]
        public string MaSanPham { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaDanhMuc { get; set; } = null!;
        
        [Required]
        [StringLength(150)]
        public string TenSanPham { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal GiaCoBan { get; set; }
        
        public bool TrangThai { get; set; }
        
        [StringLength(255)]
        public string? MoTa { get; set; }
        
        [ForeignKey("MaDanhMuc")]
        public virtual DanhMuc DanhMuc { get; set; } = null!;
        
        public virtual ICollection<BienTheSanPham> BienTheSanPhams { get; set; } = new List<BienTheSanPham>();
    }
}
