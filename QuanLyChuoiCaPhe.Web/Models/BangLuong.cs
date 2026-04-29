using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("BangLuong")]
    public class BangLuong
    {
        [Required]
        [StringLength(10)]
        public string MaNV { get; set; } = null!;
        
        public byte Thang { get; set; }
        
        public short Nam { get; set; }
        
        [Column(TypeName = "decimal(12,2)")]
        public decimal TongGioThucTe { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal TongLuongCa { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal TongThuong { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal TongKhauTru { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        public decimal? ThucLanh { get; set; }
        
        [Required]
        [StringLength(20)]
        public string TrangThai { get; set; } = null!;
        
        [ForeignKey("MaNV")]
        public virtual ThongTinNhanVien ThongTinNhanVien { get; set; } = null!;
    }
}
