using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("DonHang")]
    public class DonHang
    {
        [Key]
        [StringLength(6)]
        public string MaDH { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaChiNhanh { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaNV { get; set; } = null!;
        
        [StringLength(6)]
        public string? MaKH { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal TongTien { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal GiamGia { get; set; }
        
        [Required]
        [StringLength(30)]
        public string PhuongThucThanhToan { get; set; } = null!;
        
        [Required]
        [StringLength(20)]
        public string TrangThai { get; set; } = null!;
        
        public DateTime NgayTao { get; set; }
        
        [ForeignKey("MaChiNhanh")]
        public virtual ChiNhanh ChiNhanh { get; set; } = null!;
        
        [ForeignKey("MaNV")]
        public virtual ThongTinNhanVien ThongTinNhanVien { get; set; } = null!;
        
        [ForeignKey("MaKH")]
        public virtual KhachHang? KhachHang { get; set; }
        
        public virtual ICollection<ChiTietDonHang> ChiTietDonHangs { get; set; } = new List<ChiTietDonHang>();
    }
}
