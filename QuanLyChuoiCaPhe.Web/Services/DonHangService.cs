using System.Data;
using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Data;
using QuanLyChuoiCaPhe.Web.Models;
using QuanLyChuoiCaPhe.Web.ViewModels;

namespace QuanLyChuoiCaPhe.Web.Services
{
    public class DonHangService
    {
        private static readonly string[] ValidPaymentMethods =
        [
            "Tiền mặt",
            "Thẻ",
            "Chuyển khoản",
            "QR",
            "Ví điện tử"
        ];

        private readonly QuanLyChuoiCaPheContext _context;

        public DonHangService(QuanLyChuoiCaPheContext context)
        {
            _context = context;
        }

        public async Task<string> TaoDonHangAsync(DonHangCreateViewModel model, string nguoiThucHien)
        {
            ValidateOrderRequest(model);

            await using var transaction = await _context.Database.BeginTransactionAsync(IsolationLevel.Serializable);
            try
            {
                var maDH = await GenerateMaDonHangAsync();
                var now = DateTime.Now;

                var donHang = new DonHang
                {
                    MaDH = maDH,
                    MaChiNhanh = model.MaChiNhanh,
                    MaNV = model.MaNV,
                    MaKH = string.IsNullOrWhiteSpace(model.MaKH) ? null : model.MaKH,
                    TongTien = 0,
                    GiamGia = model.GiamGia,
                    PhuongThucThanhToan = model.PhuongThucThanhToan,
                    TrangThai = "Khởi tạo",
                    NgayTao = now
                };

                _context.DonHangs.Add(donHang);
                _context.HanhTrinhDonHangs.Add(new HanhTrinhDonHang
                {
                    MaDH = maDH,
                    HanhDong = "Khởi tạo đơn hàng mới",
                    NguoiThucHien = nguoiThucHien,
                    ThoiGian = now
                });

                await _context.SaveChangesAsync();

                var groupedItems = model.ChiTietDonHangs
                    .GroupBy(i => i.MaBienThe.Trim(), StringComparer.OrdinalIgnoreCase)
                    .Select(g => new
                    {
                        MaBienThe = g.Key,
                        SoLuong = g.Sum(i => i.SoLuong)
                    })
                    .ToList();
                var generatedDetailCodes = new List<string>();

                foreach (var item in groupedItems)
                {
                    if (item.SoLuong <= 0)
                    {
                        throw new InvalidOperationException("Số lượng không hợp lệ");
                    }

                    var priceResult = await GetDonGiaBienTheAsync(item.MaBienThe, model.MaChiNhanh);
                    if (!priceResult.IsValid)
                    {
                        throw new InvalidOperationException(priceResult.Message);
                    }

                    var maCTDH = await GenerateMaChiTietDonHangAsync(generatedDetailCodes);
                    generatedDetailCodes.Add(maCTDH);
                    _context.ChiTietDonHangs.Add(new ChiTietDonHang
                    {
                        MaCTDH = maCTDH,
                        MaDH = maDH,
                        MaBienThe = item.MaBienThe,
                        SoLuong = item.SoLuong,
                        DonGia = priceResult.DonGia
                    });

                    _context.HanhTrinhDonHangs.Add(new HanhTrinhDonHang
                    {
                        MaDH = maDH,
                        HanhDong = $"Thêm món: {priceResult.TenSanPham} (Size {priceResult.Size}), Số lượng: {item.SoLuong}, Đơn giá: {priceResult.DonGia:N0} đ",
                        NguoiThucHien = nguoiThucHien,
                        ThoiGian = DateTime.Now
                    });
                }

                await _context.SaveChangesAsync();
                await _context.Entry(donHang).ReloadAsync();

                if (donHang.TongTien <= 0)
                {
                    throw new InvalidOperationException("Không thể xác định đơn giá sản phẩm");
                }

                if (donHang.GiamGia > donHang.TongTien)
                {
                    throw new InvalidOperationException("Giảm giá không được vượt quá tổng tiền đơn hàng");
                }

                if (donHang.GiamGia > 0)
                {
                    _context.HanhTrinhDonHangs.Add(new HanhTrinhDonHang
                    {
                        MaDH = maDH,
                        HanhDong = $"Áp dụng giảm giá: {donHang.GiamGia:N0} đ",
                        NguoiThucHien = nguoiThucHien,
                        ThoiGian = DateTime.Now
                    });
                }

                donHang.TrangThai = "Hoàn tất";
                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                return maDH;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<DonGiaBienTheResult> GetDonGiaBienTheAsync(string maBienThe, string maChiNhanh)
        {
            if (string.IsNullOrWhiteSpace(maBienThe))
            {
                return DonGiaBienTheResult.Invalid("Sản phẩm không tồn tại");
            }

            var bienThe = await _context.BienTheSanPhams
                .AsNoTracking()
                .Include(b => b.SanPham)
                .FirstOrDefaultAsync(b => b.MaBienThe == maBienThe);

            if (bienThe == null)
            {
                return DonGiaBienTheResult.Invalid("Sản phẩm không tồn tại");
            }

            if (!bienThe.TrangThai || !bienThe.SanPham.TrangThai)
            {
                return DonGiaBienTheResult.Invalid("Sản phẩm đã ngừng bán");
            }

            var sanPhamChiNhanh = await _context.SanPhamChiNhanhs
                .AsNoTracking()
                .FirstOrDefaultAsync(s => s.MaChiNhanh == maChiNhanh && s.MaSanPham == bienThe.MaSanPham);

            if (sanPhamChiNhanh == null)
            {
                return DonGiaBienTheResult.Invalid("Sản phẩm không bán tại chi nhánh này");
            }

            if (!sanPhamChiNhanh.TrangThai)
            {
                return DonGiaBienTheResult.Invalid("Sản phẩm đã ngừng bán");
            }

            var basePrice = sanPhamChiNhanh.GiaBan > 0
                ? sanPhamChiNhanh.GiaBan
                : bienThe.SanPham.GiaCoBan;
            var donGia = basePrice + bienThe.GiaCongThem;

            if (donGia <= 0)
            {
                return DonGiaBienTheResult.Invalid("Không thể xác định đơn giá sản phẩm");
            }

            return DonGiaBienTheResult.Valid(
                donGia,
                bienThe.SanPham.TenSanPham,
                bienThe.Size);
        }

        private static void ValidateOrderRequest(DonHangCreateViewModel model)
        {
            if (string.IsNullOrWhiteSpace(model.MaChiNhanh) || string.IsNullOrWhiteSpace(model.MaNV))
            {
                throw new InvalidOperationException("Tài khoản không được liên kết với nhân viên hoặc chi nhánh hợp lệ");
            }

            if (model.ChiTietDonHangs == null || model.ChiTietDonHangs.Count == 0)
            {
                throw new InvalidOperationException("Vui lòng thêm ít nhất một sản phẩm");
            }

            if (model.ChiTietDonHangs.Any(i => i.SoLuong <= 0))
            {
                throw new InvalidOperationException("Số lượng không hợp lệ");
            }

            if (model.GiamGia < 0)
            {
                throw new InvalidOperationException("Giảm giá phải lớn hơn hoặc bằng 0");
            }

            if (!ValidPaymentMethods.Contains(model.PhuongThucThanhToan))
            {
                throw new InvalidOperationException("Phương thức thanh toán không hợp lệ");
            }
        }

        private async Task<string> GenerateMaDonHangAsync()
        {
            var existingCodes = await _context.DonHangs
                .AsNoTracking()
                .Select(d => d.MaDH)
                .ToListAsync();

            return CodeGenerator.GenerateNext("DH", 8, existingCodes);
        }

        private async Task<string> GenerateMaChiTietDonHangAsync(IEnumerable<string> pendingCodes)
        {
            var existingCodes = await _context.ChiTietDonHangs
                .AsNoTracking()
                .Select(c => c.MaCTDH)
                .ToListAsync();
            existingCodes.AddRange(pendingCodes);

            return CodeGenerator.GenerateNext("CT", 8, existingCodes);
        }
    }

    public sealed class DonGiaBienTheResult
    {
        private DonGiaBienTheResult(bool isValid, string message, decimal donGia, string tenSanPham, string size)
        {
            IsValid = isValid;
            Message = message;
            DonGia = donGia;
            TenSanPham = tenSanPham;
            Size = size;
        }

        public bool IsValid { get; }
        public string Message { get; }
        public decimal DonGia { get; }
        public string TenSanPham { get; }
        public string Size { get; }

        public static DonGiaBienTheResult Valid(decimal donGia, string tenSanPham, string size)
        {
            return new DonGiaBienTheResult(true, string.Empty, donGia, tenSanPham, size);
        }

        public static DonGiaBienTheResult Invalid(string message)
        {
            return new DonGiaBienTheResult(false, message, 0, string.Empty, string.Empty);
        }
    }
}
