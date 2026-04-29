using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("ChucVuNhanVien")]
    public class ChucVuNhanVien
    {
        [Key]
        [StringLength(10)]
        public string MaChucVu { get; set; } = null!;
        
        [Required]
        [StringLength(100)]
        public string TenChucVu { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal LuongCoBanGio { get; set; }
        
        public virtual ICollection<ThongTinNhanVien> ThongTinNhanViens { get; set; } = new List<ThongTinNhanVien>();
    }
}
