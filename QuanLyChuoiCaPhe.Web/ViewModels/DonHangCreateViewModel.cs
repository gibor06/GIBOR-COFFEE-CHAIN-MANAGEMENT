using System.ComponentModel.DataAnnotations;

namespace QuanLyChuoiCaPhe.Web.ViewModels
{
    public class DonHangCreateViewModel
    {
        [Required(ErrorMessage = "Vui lòng chọn chi nhánh")]
        public string MaChiNhanh { get; set; } = null!;

        [Required(ErrorMessage = "Vui lòng chọn nhân viên")]
        public string MaNV { get; set; } = null!;

        public string? MaKH { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn phương thức thanh toán")]
        public string PhuongThucThanhToan { get; set; } = "Tiền mặt";

        [Range(0, double.MaxValue, ErrorMessage = "Giảm giá thủ công phải >= 0")]
        public decimal GiamGiaThuCong { get; set; } = 0;

        [Range(0, int.MaxValue, ErrorMessage = "Điểm sử dụng phải >= 0")]
        public int DiemSuDung { get; set; } = 0;

        public List<ChiTietDonHangItem> ChiTietDonHangs { get; set; } = new List<ChiTietDonHangItem>();
    }

    public class ChiTietDonHangItem
    {
        [Required]
        public string MaBienThe { get; set; } = null!;

        [Range(1, int.MaxValue, ErrorMessage = "Số lượng phải >= 1")]
        public int SoLuong { get; set; }

    }
}
