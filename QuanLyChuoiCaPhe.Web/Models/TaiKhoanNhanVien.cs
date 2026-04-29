using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("TaiKhoanNhanVien")]
    public class TaiKhoanNhanVien
    {
        [StringLength(10)]
        public string MaTK { get; set; } = null!;
        
        [StringLength(10)]
        public string MaNV { get; set; } = null!;
        
        [ForeignKey("MaTK")]
        public virtual HeThongTaiKhoan HeThongTaiKhoan { get; set; } = null!;
        
        [ForeignKey("MaNV")]
        public virtual ThongTinNhanVien ThongTinNhanVien { get; set; } = null!;
    }
}
