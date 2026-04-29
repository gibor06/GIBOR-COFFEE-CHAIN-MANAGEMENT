using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("ThongTinNhanVien")]
    public class ThongTinNhanVien
    {
        [Key]
        [StringLength(10)]
        public string MaNV { get; set; } = null!;
        
        public byte LoaiNV { get; set; }
        
        [Required]
        [StringLength(100)]
        public string HoTenNV { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaChucVu { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaChiNhanh { get; set; } = null!;
        
        public DateTime NgayVaoLam { get; set; }
        
        public DateTime? NgayNghiViec { get; set; }
        
        [Required]
        [StringLength(10)]
        public string SoDienThoai { get; set; } = null!;
        
        [Required]
        [StringLength(12)]
        public string SoCanCuoc { get; set; } = null!;
        
        [StringLength(100)]
        public string? Email { get; set; }
        
        public bool TrangThai { get; set; }
        
        [ForeignKey("MaChucVu")]
        public virtual ChucVuNhanVien ChucVuNhanVien { get; set; } = null!;
        
        [ForeignKey("MaChiNhanh")]
        public virtual ChiNhanh ChiNhanh { get; set; } = null!;
        
        public virtual ICollection<DonHang> DonHangs { get; set; } = new List<DonHang>();
        public virtual ICollection<BangLuong> BangLuongs { get; set; } = new List<BangLuong>();
        public virtual ICollection<TaiKhoanNhanVien> TaiKhoanNhanViens { get; set; } = new List<TaiKhoanNhanVien>();
    }
}
