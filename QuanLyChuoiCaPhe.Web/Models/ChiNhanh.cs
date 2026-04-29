using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("ChiNhanh")]
    public class ChiNhanh
    {
        [Key]
        [StringLength(10)]
        public string MaChiNhanh { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaKhuVuc { get; set; } = null!;
        
        [Required]
        [StringLength(100)]
        public string TenChiNhanh { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string SoDienThoai { get; set; } = null!;
        
        [Required]
        [StringLength(200)]
        public string DiaChi { get; set; } = null!;
        
        public bool TrangThai { get; set; }
        
        public DateTime NgayThanhLap { get; set; }
        
        [ForeignKey("MaKhuVuc")]
        public virtual KhuVuc KhuVuc { get; set; } = null!;
        
        public virtual ICollection<ThongTinNhanVien> ThongTinNhanViens { get; set; } = new List<ThongTinNhanVien>();
        public virtual ICollection<DonHang> DonHangs { get; set; } = new List<DonHang>();
    }
}
