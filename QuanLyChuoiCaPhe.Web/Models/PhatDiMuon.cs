using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("PhatDiMuon")]
    public class PhatDiMuon
    {
        [Key]
        [StringLength(10)]
        public string MaChamCong { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaNV { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal SoTien { get; set; }
        
        public DateTime NgayPhat { get; set; }

        [ForeignKey("MaNV")]
        [ValidateNever]
        public virtual ThongTinNhanVien? ThongTinNhanVien { get; set; }

        [ForeignKey("MaChamCong")]
        [ValidateNever]
        public virtual ChamCong? ChamCong { get; set; }
    }
}
