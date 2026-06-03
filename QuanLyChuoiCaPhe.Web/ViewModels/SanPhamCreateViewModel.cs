using System.ComponentModel.DataAnnotations;

namespace QuanLyChuoiCaPhe.Web.ViewModels
{
    public class SanPhamCreateViewModel
    {
        [Required(ErrorMessage = "Vui lòng chọn danh mục")]
        [StringLength(10)]
        public string MaDanhMuc { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng nhập tên sản phẩm")]
        [StringLength(150, ErrorMessage = "Tên sản phẩm tối đa 150 ký tự")]
        public string TenSanPham { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng nhập giá size Nhỏ")]
        [Range(typeof(decimal), "1", "79228162514264337593543950335", ErrorMessage = "Giá size Nhỏ phải lớn hơn 0")]
        public decimal? GiaSizeNho { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập giá size Vừa")]
        [Range(typeof(decimal), "1", "79228162514264337593543950335", ErrorMessage = "Giá size Vừa phải lớn hơn 0")]
        public decimal? GiaSizeVua { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập giá size Lớn")]
        [Range(typeof(decimal), "1", "79228162514264337593543950335", ErrorMessage = "Giá size Lớn phải lớn hơn 0")]
        public decimal? GiaSizeLon { get; set; }

        public bool TrangThai { get; set; } = true;

        [StringLength(255, ErrorMessage = "Mô tả tối đa 255 ký tự")]
        public string? MoTa { get; set; }

        public List<string> MaChiNhanhs { get; set; } = new();
    }
}
