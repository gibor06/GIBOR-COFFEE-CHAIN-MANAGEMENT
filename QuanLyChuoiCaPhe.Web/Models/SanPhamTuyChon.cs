using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("SanPham_TuyChon")]
    public class SanPhamTuyChon
    {
        [StringLength(10)]
        public string MaSanPham { get; set; } = null!;
        
        [StringLength(10)]
        public string MaTuyChon { get; set; } = null!;
    }
}
