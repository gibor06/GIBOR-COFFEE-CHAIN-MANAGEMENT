using System.ComponentModel.DataAnnotations;

namespace QuanLyChuoiCaPhe.Web.ViewModels
{
    public class KhoKhoiTaoViewModel
    {
        [Required(ErrorMessage = "Vui lòng chọn chi nhánh")]
        [Display(Name = "Chi nhánh")]
        public string MaChiNhanh { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng chọn nguyên liệu")]
        [Display(Name = "Nguyên liệu")]
        public string MaNguyenLieu { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng nhập mức cảnh báo")]
        [Range(0, double.MaxValue, ErrorMessage = "Mức cảnh báo phải >= 0")]
        [Display(Name = "Mức cảnh báo")]
        public decimal MucCanhBao { get; set; }

        [Display(Name = "Hạn sử dụng")]
        public DateTime? HanSuDung { get; set; }
    }
}
