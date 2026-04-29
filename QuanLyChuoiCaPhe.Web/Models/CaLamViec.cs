using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("CaLamViec")]
    public class CaLamViec
    {
        [Key]
        [StringLength(10)]
        public string MaCa { get; set; } = null!;
        
        public byte LoaiCa { get; set; }
        
        [Required]
        [StringLength(100)]
        public string TenCa { get; set; } = null!;
        
        [Column(TypeName = "decimal(5,2)")]
        public decimal HeSoCa { get; set; }
        
        public TimeSpan GioBatDau { get; set; }
        
        public TimeSpan GioKetThuc { get; set; }
    }
}
