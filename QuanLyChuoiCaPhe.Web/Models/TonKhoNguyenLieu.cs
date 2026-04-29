using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("TonKhoNguyenLieu")]
    public class TonKhoNguyenLieu
    {
        [StringLength(10)]
        public string MaChiNhanh { get; set; } = null!;
        
        [StringLength(10)]
        public string MaNguyenLieu { get; set; } = null!;
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal SoLuongTon { get; set; }
        
        [Column(TypeName = "decimal(18,2)")]
        public decimal MucCanhBao { get; set; }
        
        [ForeignKey("MaChiNhanh")]
        public virtual ChiNhanh? ChiNhanh { get; set; }
        
        [ForeignKey("MaNguyenLieu")]
        public virtual NguyenLieu? NguyenLieu { get; set; }
    }
}
