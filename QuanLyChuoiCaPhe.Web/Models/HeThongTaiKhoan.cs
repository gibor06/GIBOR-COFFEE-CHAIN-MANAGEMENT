using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("HeThongTaiKhoan")]
    public class HeThongTaiKhoan
    {
        [Key]
        [StringLength(10)]
        public string MaTK { get; set; } = null!;

        [Required]
        [StringLength(50)]
        public string TenDangNhap { get; set; } = null!;

        [Required]
        [StringLength(200)]
        public string MatKhauHash { get; set; } = null!;

        [Required]
        [StringLength(30)]
        public string VaiTro { get; set; } = null!;

        public bool TrangThai { get; set; }

        public DateTime NgayTao { get; set; }

        // Navigation property
        public virtual ICollection<TaiKhoanNhanVien> TaiKhoanNhanViens { get; set; } = new List<TaiKhoanNhanVien>();
    }
}
