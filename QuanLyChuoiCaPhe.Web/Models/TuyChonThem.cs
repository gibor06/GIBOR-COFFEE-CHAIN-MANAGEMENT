using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("TuyChonThem")]
    public class TuyChonThem
    {
        [Key]
        [StringLength(10)]
        public string MaTuyChon { get; set; } = null!;
        
        [Required]
        [StringLength(100)]
        public string TenTuyChon { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal GiaCongThem { get; set; }
        
        public bool TrangThai { get; set; }
    }
}
