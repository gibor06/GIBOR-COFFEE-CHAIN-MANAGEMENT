using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("CongThucPhaChe")]
    public class CongThucPhaChe
    {
        [StringLength(10)]
        public string MaCongThuc { get; set; } = null!;
        
        [StringLength(10)]
        public string MaNguyenLieu { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaBienThe { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal SoLuongSuDung { get; set; }
    }
}
