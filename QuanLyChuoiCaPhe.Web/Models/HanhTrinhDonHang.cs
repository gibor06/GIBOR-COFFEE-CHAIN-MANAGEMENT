using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("HanhTrinhDonHang")]
    public class HanhTrinhDonHang
    {
        [Key]
        public int MaHanhTrinh { get; set; }

        [Required]
        [StringLength(6)]
        public string MaDH { get; set; } = null!;

        [Required]
        [StringLength(255)]
        public string HanhDong { get; set; } = null!;

        [Required]
        [StringLength(100)]
        public string NguoiThucHien { get; set; } = null!;

        public DateTime ThoiGian { get; set; }

        [ForeignKey("MaDH")]
        public virtual DonHang? DonHang { get; set; }
    }
}
