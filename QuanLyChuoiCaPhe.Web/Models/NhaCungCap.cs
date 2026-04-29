using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("NhaCungCap")]
    public class NhaCungCap
    {
        [Key]
        [StringLength(10)]
        public string MaNCC { get; set; } = null!;
        
        [Required]
        [StringLength(100)]
        public string TenNCC { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string DienThoai { get; set; } = null!;
        
        [StringLength(100)]
        public string? Email { get; set; }
        
        [StringLength(200)]
        public string? DiaChi { get; set; }
        
        [Required]
        [StringLength(20)]
        public string TrangThai { get; set; } = null!;
        
        public virtual ICollection<NguyenLieu> NguyenLieus { get; set; } = new List<NguyenLieu>();
    }
}
