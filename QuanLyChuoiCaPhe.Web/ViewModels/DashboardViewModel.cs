namespace QuanLyChuoiCaPhe.Web.ViewModels
{
    public class DashboardViewModel
    {
        public int TongChiNhanh { get; set; }
        public int TongNhanVien { get; set; }
        public int TongSanPham { get; set; }
        public int TongDonHang { get; set; }
        public decimal DoanhThuHomNay { get; set; }
        public int SoCanhBaoTonKho { get; set; }
        public decimal BangLuongTamTinh { get; set; }
        public List<DonHangGanDay> DonHangGanDay { get; set; } = new List<DonHangGanDay>();
        public List<DoanhThuThang> DoanhThuTheoThang { get; set; } = new List<DoanhThuThang>();
    }

    public class DonHangGanDay
    {
        public string MaDH { get; set; } = null!;
        public string TenChiNhanh { get; set; } = null!;
        public string TenNhanVien { get; set; } = null!;
        public decimal TongTien { get; set; }
        public DateTime NgayTao { get; set; }
        public string TrangThai { get; set; } = null!;
    }

    public class DoanhThuThang
    {
        public int Thang { get; set; }
        public decimal DoanhThu { get; set; }
    }
}
