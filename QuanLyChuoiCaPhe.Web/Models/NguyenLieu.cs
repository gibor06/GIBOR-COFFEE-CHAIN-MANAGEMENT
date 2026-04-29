using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("NguyenLieu")]
    public class NguyenLieu
    {
        [Key]
        [StringLength(10)]
        public string MaNguyenLieu { get; set; } = null!;
        
        [Required]
        [StringLength(100)]
        public string TenNguyenLieu { get; set; } = null!;
        
        [Required]
        [StringLength(20)]
        public string DonViTinh { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal GiaNhap { get; set; }
        
        [Required]
        [StringLength(10)]
        public string MaNCC { get; set; } = null!;
        
        public bool CoHanSuDung { get; set; }
        
        [Required]
        [StringLength(20)]
        public string TrangThai { get; set; } = null!;
        
        [ForeignKey("MaNCC")]
        public virtual NhaCungCap NhaCungCap { get; set; } = null!;
    }
}
