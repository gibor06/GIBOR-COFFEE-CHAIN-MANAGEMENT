using System.ComponentModel.DataAnnotations;

namespace QuanLyChuoiCaPhe.Web.ViewModels
{
    public class BangLuongCreateViewModel
    {
        [Required(ErrorMessage = "Vui lòng chọn tháng")]
        [Range(1, 12, ErrorMessage = "Tháng phải từ 1-12")]
        public byte Thang { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn năm")]
        [Range(2024, 2100, ErrorMessage = "Năm không hợp lệ")]
        public short Nam { get; set; }
    }
}
