using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("LichPhanCong")]
    public class LichPhanCong
    {
        [Key]
        [StringLength(15)]
        public string MaLich { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaNV { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaCa { get; set; } = null!;
        
        public DateTime NgayLamViec { get; set; }
        
        [Required]
        [StringLength(20)]
        public string TrangThai { get; set; } = null!;
        
        [StringLength(200)]
        public string? GhiChu { get; set; }

        [ForeignKey("MaNV")]
        [ValidateNever]
        public virtual ThongTinNhanVien? ThongTinNhanVien { get; set; }

        [ForeignKey("MaCa")]
        [ValidateNever]
        public virtual CaLamViec? CaLamViec { get; set; }

        [ValidateNever]
        public virtual ICollection<ChamCong> ChamCongs { get; set; } = new List<ChamCong>();
    }
}
