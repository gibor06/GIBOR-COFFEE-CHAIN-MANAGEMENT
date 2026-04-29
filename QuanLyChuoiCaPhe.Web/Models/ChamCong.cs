using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("ChamCong")]
    public class ChamCong
    {
        [Key]
        [StringLength(10)]
        public string MaChamCong { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaNV { get; set; } = null!;
        
        [Required]
        [StringLength(15)]
        public string MaLich { get; set; } = null!;
        
        public DateTime GioVao { get; set; }
        
        public DateTime GioRa { get; set; }
        
        [StringLength(20)]
        public string? TrangThai { get; set; }
        
        [Column(TypeName = "decimal(5,2)")]
        public decimal? HeSoNgay { get; set; }
        
        [Column(TypeName = "decimal(5,2)")]
        public decimal? HeSoCa { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal? LuongThucTe { get; set; }
    }
}
