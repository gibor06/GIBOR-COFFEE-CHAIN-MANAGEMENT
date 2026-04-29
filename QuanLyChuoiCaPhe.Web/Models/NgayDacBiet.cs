using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("NgayDacBiet")]
    public class NgayDacBiet
    {
        [Key]
        public DateTime Ngay { get; set; }
        
        [Required]
        [StringLength(100)]
        public string TenNgay { get; set; } = null!;
        
        [Column(TypeName = "decimal(5,2)")]
        public decimal HeSoLuong { get; set; }
    }
}
