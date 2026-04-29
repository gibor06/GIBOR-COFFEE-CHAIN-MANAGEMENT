using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("LichSuKho")]
    public class LichSuKho
    {
        [Key]
        [StringLength(10)]
        public string LogID { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaChiNhanh { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaNguyenLieu { get; set; } = null!;
        
        [Required]
        [StringLength(20)]
        public string LoaiGiaoDich { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal SoLuong { get; set; }
        
        public DateTime ThoiGian { get; set; }
        
        [StringLength(255)]
        public string? GhiChu { get; set; }
    }
}
