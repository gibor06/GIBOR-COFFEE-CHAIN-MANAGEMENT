using System.ComponentModel.DataAnnotations;

namespace QuanLyChuoiCaPhe.Web.ViewModels
{
    public class KhoGiaoDichViewModel
    {
        [Required(ErrorMessage = "Vui lòng chọn chi nhánh")]
        public string MaChiNhanh { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng chọn nguyên liệu")]
        public string MaNguyenLieu { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng chọn loại giao dịch")]
        public string LoaiGiaoDich { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng nhập số lượng")]
        [Range(0.01, double.MaxValue, ErrorMessage = "Số lượng phải > 0")]
        public decimal SoLuong { get; set; }

        public string? GhiChu { get; set; }
    }
}
