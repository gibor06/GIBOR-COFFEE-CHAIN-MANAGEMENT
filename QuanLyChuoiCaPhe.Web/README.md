# HƯỚNG DẪN CHẠY PROJECT - QUẢN LÝ CHUỖI CÀ PHÊ

## YÊU CẦU HỆ THỐNG

- .NET 6.0 SDK trở lên
- SQL Server 2019 trở lên
- Visual Studio 2022 hoặc VS Code

## BƯỚC 1: CÀI ĐẶT DATABASE

1. Mở SQL Server Management Studio (SSMS)
2. Chạy file `DB_DA_QuanLyQuanCF_Professional.sql` để tạo database
3. Kiểm tra database `QuanLyChuoiCaPhe` đã được tạo thành công

## BƯỚC 2: CÀI ĐẶT PROJECT

### Cách 1: Sử dụng Visual Studio 2022

1. Mở file `QuanLyChuoiCaPhe.Web.csproj` bằng Visual Studio
2. Restore NuGet packages (tự động)
3. Build project (Ctrl + Shift + B)
4. Chạy project (F5)

### Cách 2: Sử dụng Command Line

```bash
cd QuanLyChuoiCaPhe.Web

# Cài đặt packages
dotnet restore

# Build project
dotnet build

# Chạy project
dotnet run
```

## BƯỚC 3: KIỂM TRA KẾT NỐI

1. Mở file `appsettings.json`
2. Kiểm tra connection string:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.;Database=QuanLyChuoiCaPhe;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

3. Nếu SQL Server không dùng tên `.`, thay đổi thành:
   - `Server=localhost;...` hoặc
   - `Server=(local);...` hoặc
   - `Server=TÊN_MÁY_TÍNH;...`

## BƯỚC 4: TÀI KHOẢN TEST

Sau khi chạy file SQL, hệ thống sẽ có sẵn các tài khoản test. Để lấy tài khoản, chạy query:

```sql
USE QuanLyChuoiCaPhe;
SELECT MaTK, TenDangNhap, MatKhauHash, VaiTro, TrangThai
FROM HeThongTaiKhoan
WHERE TrangThai = 1;
```

**LƯU Ý:** Hiện tại hệ thống so sánh mật khẩu trực tiếp (chưa hash). Khi triển khai thực tế cần thay bằng SHA256.

### Tài khoản mẫu (nếu có trong database):

- **ADMIN:**
  - Username: admin
  - Password: (xem trong database)

- **QUAN_LY:**
  - Username: quanly
  - Password: (xem trong database)

- **NHAN_VIEN:**
  - Username: nhanvien
  - Password: (xem trong database)

- **KHO:**
  - Username: kho
  - Password: (xem trong database)

- **KE_TOAN:**
  - Username: ketoan
  - Password: (xem trong database)

## BƯỚC 5: TRUY CẬP HỆ THỐNG

1. Sau khi chạy project, truy cập: `https://localhost:5001` hoặc `http://localhost:5000`
2. Đăng nhập bằng tài khoản test
3. Hệ thống sẽ chuyển đến Dashboard

## CẤU TRÚC CHỨC NĂNG

### ADMIN - Toàn quyền

- Dashboard
- Quản lý tài khoản
- Quản lý chi nhánh
- Quản lý nhân viên
- Quản lý sản phẩm
- Quản lý đơn hàng
- Quản lý kho
- Quản lý lương
- Báo cáo

### QUAN_LY - Quản lý

- Dashboard
- Quản lý chi nhánh
- Quản lý nhân viên
- Quản lý sản phẩm
- Quản lý đơn hàng
- Báo cáo

### NHAN_VIEN - Nhân viên

- Dashboard cá nhân
- Xem menu
- Tạo đơn hàng
- Xem đơn hàng của mình

### KHO - Quản lý kho

- Dashboard kho
- Quản lý nguyên liệu
- Giao dịch kho (Nhập/Xuất)
- Cảnh báo tồn kho

### KE_TOAN - Kế toán

- Dashboard kế toán
- Quản lý bảng lương
- Khởi tạo bảng lương
- Báo cáo lương

## STORED PROCEDURES QUAN TRỌNG

### 1. sp_TaoDonHang

Tạo đơn hàng mới và tự động cập nhật tổng tiền, điểm tích lũy.

```sql
EXEC sp_TaoDonHang
    @MaDH = 'DH0001',
    @MaChiNhanh = 'CN001',
    @MaNV = 'NV001',
    @MaKH = NULL,
    @GiamGia = 0,
    @PhuongThucThanhToan = N'Tiền mặt';
```

### 2. sp_GhiNhanGiaoDichKho

Ghi nhận giao dịch nhập/xuất kho và tự động cập nhật tồn kho.

```sql
EXEC sp_GhiNhanGiaoDichKho
    @LogID = 'L0001',
    @MaChiNhanh = 'CN001',
    @MaNguyenLieu = 'NL001',
    @LoaiGiaoDich = N'Nhập',
    @SoLuong = 100,
    @GhiChu = N'Nhập hàng đầu tháng';
```

### 3. sp_KhoiTaoBangLuong

Khởi tạo bảng lương cho tất cả nhân viên trong tháng.

```sql
EXEC sp_KhoiTaoBangLuong
    @Thang = 12,
    @Nam = 2024;
```

### 4. sp_CanhBaoTonKho

Kiểm tra và cảnh báo các nguyên liệu sắp hết.

```sql
EXEC sp_CanhBaoTonKho;
```

## VIEWS QUAN TRỌNG

### 1. vw_MenuChiNhanh

Xem menu sản phẩm theo chi nhánh.

```sql
SELECT * FROM vw_MenuChiNhanh WHERE MaChiNhanh = 'CN001';
```

### 2. vw_CanhBaoTonKho

Xem danh sách nguyên liệu cần cảnh báo.

```sql
SELECT * FROM vw_CanhBaoTonKho;
```

### 3. vw_BangLuongTongHop

Xem bảng lương tổng hợp.

```sql
SELECT * FROM vw_BangLuongTongHop WHERE Thang = 12 AND Nam = 2024;
```

## XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi 1: Không kết nối được SQL Server

**Giải pháp:**

- Kiểm tra SQL Server đang chạy
- Kiểm tra connection string trong appsettings.json
- Kiểm tra Windows Authentication hoặc SQL Authentication

### Lỗi 2: Database không tồn tại

**Giải pháp:**

- Chạy lại file SQL để tạo database
- Kiểm tra tên database trong connection string

### Lỗi 3: Trigger báo lỗi khi thao tác

**Giải pháp:**

- Đây là tính năng bảo vệ dữ liệu
- Kiểm tra điều kiện nghiệp vụ (ví dụ: không xóa chi nhánh đang có nhân viên)
- Xem message lỗi để biết nguyên nhân cụ thể

### Lỗi 4: Không đăng nhập được

**Giải pháp:**

- Kiểm tra tài khoản trong bảng HeThongTaiKhoan
- Kiểm tra TrangThai = 1 (đang hoạt động)
- Kiểm tra mật khẩu (hiện tại so sánh trực tiếp)

## CHECKLIST KIỂM THỬ

### Chức năng cơ bản

- [ ] Đăng nhập thành công
- [ ] Hiển thị Dashboard
- [ ] Sidebar menu hoạt động
- [ ] Đăng xuất thành công

### Quản lý Chi nhánh

- [ ] Xem danh sách chi nhánh
- [ ] Thêm chi nhánh mới
- [ ] Sửa thông tin chi nhánh
- [ ] Khóa/mở chi nhánh
- [ ] Tìm kiếm, lọc chi nhánh

### Quản lý Nhân viên

- [ ] Xem danh sách nhân viên
- [ ] Thêm nhân viên mới
- [ ] Sửa thông tin nhân viên
- [ ] Cho nhân viên nghỉ việc
- [ ] Tìm kiếm, lọc nhân viên

### Quản lý Sản phẩm

- [ ] Xem danh sách sản phẩm
- [ ] Thêm sản phẩm mới
- [ ] Sửa thông tin sản phẩm
- [ ] Khóa/mở sản phẩm
- [ ] Xem menu theo chi nhánh

### Quản lý Đơn hàng (POS)

- [ ] Tạo đơn hàng mới
- [ ] Chọn sản phẩm, tính tổng tiền
- [ ] Áp dụng giảm giá
- [ ] Gọi sp_TaoDonHang thành công
- [ ] Xem chi tiết đơn hàng
- [ ] In hóa đơn

### Quản lý Kho

- [ ] Xem tồn kho
- [ ] Ghi nhận giao dịch nhập kho
- [ ] Ghi nhận giao dịch xuất kho
- [ ] Gọi sp_GhiNhanGiaoDichKho thành công
- [ ] Xem cảnh báo tồn kho
- [ ] Gọi sp_CanhBaoTonKho thành công

### Quản lý Lương

- [ ] Xem bảng lương
- [ ] Khởi tạo bảng lương tháng mới
- [ ] Gọi sp_KhoiTaoBangLuong thành công
- [ ] Cập nhật thưởng/khấu trừ
- [ ] Xác nhận thanh toán
- [ ] Trigger khóa bảng lương đã thanh toán

### Báo cáo

- [ ] Xem doanh thu theo chi nhánh
- [ ] Xem top sản phẩm bán chạy
- [ ] Xem top khách hàng
- [ ] Xem nhật ký hệ thống
- [ ] Biểu đồ doanh thu

### Phân quyền

- [ ] ADMIN truy cập được tất cả
- [ ] QUAN_LY không thấy menu Tài khoản
- [ ] NHAN_VIEN chỉ thấy menu cơ bản
- [ ] KHO chỉ thấy menu kho
- [ ] KE_TOAN chỉ thấy menu lương và báo cáo

## LIÊN HỆ HỖ TRỢ

Nếu gặp vấn đề, vui lòng kiểm tra:

1. Log trong Visual Studio Output
2. SQL Server Error Log
3. Browser Console (F12)
