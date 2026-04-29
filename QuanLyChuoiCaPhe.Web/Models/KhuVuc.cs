using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("KhuVuc")]
    public class KhuVuc
    {
        [Key]
        [StringLength(10)]
        public string MaKhuVuc { get; set; } = null!;
        
        [Required]
        [StringLength(100)]
        public string TenKhuVuc { get; set; } = null!;
        
        public virtual ICollection<ChiNhanh> ChiNhanhs { get; set; } = new List<ChiNhanh>();
    }
}
