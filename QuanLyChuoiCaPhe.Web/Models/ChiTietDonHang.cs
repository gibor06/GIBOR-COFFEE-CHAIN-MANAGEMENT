using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("ChiTietDonHang")]
    public class ChiTietDonHang
    {
        [Key]
        [StringLength(10)]
        public string MaCTDH { get; set; } = null!;
        
        [StringLength(6)]
        public string MaDH { get; set; } = null!;
        
        [StringLength(10)]
        public string MaBienThe { get; set; } = null!;
        
        public int SoLuong { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal DonGia { get; set; }
        
        [StringLength(200)]
        public string? GhiChu { get; set; }
        
        [ForeignKey("MaDH")]
        public virtual DonHang DonHang { get; set; } = null!;
        
        [ForeignKey("MaBienThe")]
        public virtual BienTheSanPham BienTheSanPham { get; set; } = null!;
        
        [NotMapped]
        public decimal ThanhTien => SoLuong * DonGia;
    }
}
