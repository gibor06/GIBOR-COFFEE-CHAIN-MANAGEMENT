using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("DuLieuHeThong")]
    public class DuLieuHeThong
    {
        [Key]
        [StringLength(15)]
        public string MaDuLieu { get; set; } = null!;
        
        [StringLength(10)]
        public string? MaTK { get; set; }
        
        [Required]
        [StringLength(100)]
        public string HanhDong { get; set; } = null!;
        
        [Required]
        [StringLength(100)]
        public string TenBang { get; set; } = null!;
        
        public int SoLuongTacDong { get; set; }
        
        [StringLength(250)]
        public string? NoiDung { get; set; }
        
        public DateTime ThoiGian { get; set; }
        
        [ForeignKey("MaTK")]
        public virtual HeThongTaiKhoan? HeThongTaiKhoan { get; set; }
    }
}
