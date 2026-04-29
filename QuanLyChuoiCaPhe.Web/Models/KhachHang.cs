using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("KhachHang")]
    public class KhachHang
    {
        [Key]
        [StringLength(6)]
        public string MaKH { get; set; } = null!;
        
        [Required]
        [StringLength(100)]
        public string TenKH { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string SoDienThoai { get; set; } = null!;
        
        public int DiemTichLuy { get; set; }
        
        public virtual ICollection<DonHang> DonHangs { get; set; } = new List<DonHang>();
    }
}
