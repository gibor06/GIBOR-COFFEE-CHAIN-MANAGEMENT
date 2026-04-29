using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("DanhMuc")]
    public class DanhMuc
    {
        [Key]
        [StringLength(10)]
        public string MaDanhMuc { get; set; } = null!;
        
        [Required]
        [StringLength(100)]
        public string TenDanhMuc { get; set; } = null!;
        
        [StringLength(255)]
        public string? MoTa { get; set; }
        
        public virtual ICollection<SanPham> SanPhams { get; set; } = new List<SanPham>();
    }
}
