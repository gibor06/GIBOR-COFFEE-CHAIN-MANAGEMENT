# ☕ GIBOR Coffee Chain Management

**GIBOR Coffee Chain Management** là hệ thống quản lý chuỗi cửa hàng cà phê được xây dựng bằng **ASP.NET Core MVC**, **Entity Framework Core** và **SQL Server**.  
Dự án hỗ trợ các nghiệp vụ chính trong vận hành chuỗi cà phê như quản lý chi nhánh, nhân viên, sản phẩm, đơn hàng, kho nguyên liệu, bảng lương, báo cáo và phân quyền người dùng.

🌐 Demo: https://quanlycaphegibor.runasp.net/

---

## 📌 Mục lục

- [Giới thiệu](#-giới-thiệu)
- [Tính năng chính](#-tính-năng-chính)
- [Công nghệ sử dụng](#-công-nghệ-sử-dụng)
- [Cấu trúc thư mục](#-cấu-trúc-thư-mục)
- [Yêu cầu hệ thống](#-yêu-cầu-hệ-thống)
- [Cài đặt và chạy dự án](#-cài-đặt-và-chạy-dự-án)
- [Cấu hình cơ sở dữ liệu](#-cấu-hình-cơ-sở-dữ-liệu)
- [Tài khoản đăng nhập](#-tài-khoản-đăng-nhập)
- [Phân quyền người dùng](#-phân-quyền-người-dùng)
- [Stored Procedures & Views](#-stored-procedures--views)
- [Kiểm thử chức năng](#-kiểm-thử-chức-năng)
- [Lỗi thường gặp](#-lỗi-thường-gặp)
- [Định hướng phát triển](#-định-hướng-phát-triển)
- [Tác giả](#-tác-giả)

---

## 📖 Giới thiệu

Dự án **GIBOR Coffee Chain Management** mô phỏng một hệ thống quản lý chuỗi cửa hàng cà phê chuyên nghiệp.  
Hệ thống tập trung vào các nghiệp vụ nội bộ của doanh nghiệp, giúp quản lý:

- Thông tin chi nhánh
- Nhân viên và tài khoản đăng nhập
- Sản phẩm, danh mục, biến thể sản phẩm
- Đơn hàng và chi tiết đơn hàng
- Kho nguyên liệu, nhập/xuất kho
- Bảng lương và chấm công
- Báo cáo doanh thu, tồn kho, lương
- Phân quyền theo vai trò người dùng

---

## ✨ Tính năng chính

### 🔐 Xác thực & phân quyền

- Đăng nhập hệ thống
- Quản lý phiên đăng nhập bằng Session
- Phân quyền theo vai trò:
  - Admin
  - Quản lý
  - Nhân viên
  - Kho
  - Kế toán

### 🏢 Quản lý chi nhánh

- Xem danh sách chi nhánh
- Thêm, sửa thông tin chi nhánh
- Khóa hoặc mở hoạt động chi nhánh
- Tìm kiếm và lọc dữ liệu

### 👥 Quản lý nhân viên

- Quản lý hồ sơ nhân viên
- Theo dõi chức vụ, ca làm việc, lịch phân công
- Quản lý trạng thái làm việc
- Hỗ trợ nghiệp vụ chấm công và tính lương

### ☕ Quản lý sản phẩm

- Quản lý danh mục sản phẩm
- Quản lý sản phẩm theo chi nhánh
- Quản lý biến thể sản phẩm
- Quản lý tùy chọn thêm
- Xem menu theo từng chi nhánh

### 🧾 Quản lý đơn hàng

- Tạo đơn hàng
- Thêm sản phẩm vào đơn hàng
- Tính tổng tiền
- Áp dụng giảm giá
- Ghi nhận phương thức thanh toán
- Xem chi tiết đơn hàng

### 📦 Quản lý kho

- Quản lý nguyên liệu
- Quản lý nhà cung cấp
- Ghi nhận giao dịch nhập kho
- Ghi nhận giao dịch xuất kho
- Theo dõi tồn kho nguyên liệu
- Cảnh báo nguyên liệu sắp hết

### 💰 Quản lý bảng lương

- Khởi tạo bảng lương theo tháng
- Tính lương nhân viên
- Cập nhật thưởng, khấu trừ
- Xác nhận thanh toán
- Báo cáo lương tổng hợp

### 📊 Báo cáo

- Dashboard tổng quan
- Báo cáo doanh thu
- Báo cáo đơn hàng
- Báo cáo tồn kho
- Báo cáo bảng lương
- Thống kê hoạt động hệ thống

---

## 🛠 Công nghệ sử dụng

| Nhóm | Công nghệ |
|---|---|
| Backend | ASP.NET Core MVC |
| Framework | .NET 6 |
| ORM | Entity Framework Core |
| Database | SQL Server |
| Frontend | HTML, CSS, JavaScript, Razor View |
| Ngôn ngữ | C#, T-SQL |
| IDE khuyến nghị | Visual Studio 2022 |
| Quản lý mã nguồn | Git, GitHub |

---

## 🗂 Cấu trúc thư mục

```txt
GIBOR-COFFEE-CHAIN-MANAGEMENT/
│
├── QuanLyChuoiCaPhe.Web/
│   ├── Controllers/          # Xử lý request và điều hướng nghiệp vụ
│   ├── Data/                 # DbContext và cấu hình dữ liệu
│   ├── Filters/              # Bộ lọc phân quyền / xử lý request
│   ├── Models/               # Entity models ánh xạ database
│   ├── Services/             # Tầng xử lý nghiệp vụ
│   ├── ViewModels/           # Model trung gian cho View
│   ├── Views/                # Razor Views
│   ├── wwwroot/              # Static files: CSS, JS, images
│   ├── Program.cs            # Cấu hình ứng dụng
│   ├── appsettings.json      # Cấu hình connection string
│   └── QuanLyChuoiCaPhe.Web.csproj
│
├── DB_DA_QuanLyQuanCF_Professional.sql  # Script tạo database
├── Tài khoản.txt                         # Tài khoản test
└── .gitignore
```

---

## 💻 Yêu cầu hệ thống

Trước khi chạy dự án, cần cài đặt:

- .NET 6 SDK trở lên
- SQL Server 2019 trở lên
- SQL Server Management Studio, Azure Data Studio hoặc công cụ tương đương
- Visual Studio 2022 hoặc Visual Studio Code
- Git

---

## 🚀 Cài đặt và chạy dự án

### 1. Clone repository

```bash
git clone https://github.com/gibor06/GIBOR-COFFEE-CHAIN-MANAGEMENT.git
cd GIBOR-COFFEE-CHAIN-MANAGEMENT
```

### 2. Tạo cơ sở dữ liệu

Mở SQL Server Management Studio và chạy file:

```txt
DB_DA_QuanLyQuanCF_Professional.sql
```

Script sẽ tạo database:

```sql
QuanLyChuoiCaPhe
```

### 3. Cấu hình connection string

Mở file:

```txt
QuanLyChuoiCaPhe.Web/appsettings.json
```

Kiểm tra hoặc chỉnh lại connection string cho phù hợp với SQL Server trên máy:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.;Database=QuanLyChuoiCaPhe;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

Một số cấu hình Server thường gặp:

```txt
Server=.;
Server=localhost;
Server=(local);
Server=YOUR_COMPUTER_NAME;
```

### 4. Restore package

```bash
cd QuanLyChuoiCaPhe.Web
dotnet restore
```

### 5. Build project

```bash
dotnet build
```

### 6. Chạy project

```bash
dotnet run
```

Sau đó truy cập:

```txt
https://localhost:5001
```

hoặc:

```txt
http://localhost:5000
```

---

## 🗄 Cấu hình cơ sở dữ liệu

Database chính của hệ thống là:

```txt
QuanLyChuoiCaPhe
```

Một số nhóm bảng chính:

- `HeThongTaiKhoan`
- `TaiKhoanNhanVien`
- `ThongTinNhanVien`
- `ChiNhanh`
- `SanPham`
- `DanhMuc`
- `DonHang`
- `ChiTietDonHang`
- `KhachHang`
- `NguyenLieu`
- `TonKhoNguyenLieu`
- `LichSuKho`
- `BangLuong`
- `ChamCong`

---

## 🔑 Tài khoản đăng nhập

Dự án có file tài khoản test:

```txt
Tài khoản.txt
```

Ngoài ra, có thể kiểm tra tài khoản trực tiếp trong database bằng câu lệnh:

```sql
USE QuanLyChuoiCaPhe;

SELECT MaTK, TenDangNhap, VaiTro, TrangThai
FROM HeThongTaiKhoan
WHERE TrangThai = 1;
```

> Lưu ý: Không nên sử dụng tài khoản test cho môi trường production.  
> Khi triển khai thực tế, cần đổi mật khẩu và áp dụng cơ chế hash mật khẩu an toàn.

---

## 👤 Phân quyền người dùng

### Admin

- Toàn quyền hệ thống
- Quản lý tài khoản
- Quản lý chi nhánh
- Quản lý nhân viên
- Quản lý sản phẩm
- Quản lý đơn hàng
- Quản lý kho
- Quản lý bảng lương
- Xem báo cáo

### Quản lý

- Xem dashboard
- Quản lý chi nhánh
- Quản lý nhân viên
- Quản lý sản phẩm
- Quản lý đơn hàng
- Xem báo cáo

### Nhân viên

- Xem dashboard cá nhân
- Xem menu
- Tạo đơn hàng
- Xem đơn hàng của mình

### Kho

- Xem dashboard kho
- Quản lý nguyên liệu
- Ghi nhận nhập/xuất kho
- Xem cảnh báo tồn kho

### Kế toán

- Xem dashboard kế toán
- Quản lý bảng lương
- Khởi tạo bảng lương
- Cập nhật thưởng/khấu trừ
- Xem báo cáo lương

---

## ⚙️ Stored Procedures & Views

### Stored Procedures quan trọng

| Stored Procedure | Mô tả |
|---|---|
| `sp_TaoDonHang` | Tạo đơn hàng mới và cập nhật tổng tiền, điểm tích lũy |
| `sp_GhiNhanGiaoDichKho` | Ghi nhận giao dịch nhập/xuất kho |
| `sp_KhoiTaoBangLuong` | Khởi tạo bảng lương theo tháng |
| `sp_CanhBaoTonKho` | Kiểm tra nguyên liệu sắp hết |

Ví dụ:

```sql
EXEC sp_CanhBaoTonKho;
```

### Views quan trọng

| View | Mô tả |
|---|---|
| `vw_MenuChiNhanh` | Xem menu sản phẩm theo chi nhánh |
| `vw_CanhBaoTonKho` | Xem danh sách nguyên liệu cần cảnh báo |
| `vw_BangLuongTongHop` | Xem bảng lương tổng hợp |

Ví dụ:

```sql
SELECT * 
FROM vw_MenuChiNhanh 
WHERE MaChiNhanh = 'CN001';
```

---

## ✅ Kiểm thử chức năng

### Chức năng cơ bản

- [ ] Đăng nhập thành công
- [ ] Hiển thị dashboard đúng theo vai trò
- [ ] Sidebar menu hoạt động
- [ ] Đăng xuất thành công

### Quản lý chi nhánh

- [ ] Xem danh sách chi nhánh
- [ ] Thêm chi nhánh mới
- [ ] Sửa thông tin chi nhánh
- [ ] Khóa/mở chi nhánh
- [ ] Tìm kiếm, lọc chi nhánh

### Quản lý nhân viên

- [ ] Xem danh sách nhân viên
- [ ] Thêm nhân viên
- [ ] Sửa thông tin nhân viên
- [ ] Cập nhật trạng thái nhân viên
- [ ] Tìm kiếm, lọc nhân viên

### Quản lý sản phẩm

- [ ] Xem danh sách sản phẩm
- [ ] Thêm sản phẩm
- [ ] Sửa sản phẩm
- [ ] Khóa/mở sản phẩm
- [ ] Xem menu theo chi nhánh

### Quản lý đơn hàng

- [ ] Tạo đơn hàng mới
- [ ] Chọn sản phẩm
- [ ] Tính tổng tiền
- [ ] Áp dụng giảm giá
- [ ] Lưu đơn hàng
- [ ] Xem chi tiết đơn hàng

### Quản lý kho

- [ ] Xem tồn kho
- [ ] Ghi nhận nhập kho
- [ ] Ghi nhận xuất kho
- [ ] Cập nhật tồn kho
- [ ] Xem cảnh báo tồn kho

### Quản lý lương

- [ ] Xem bảng lương
- [ ] Khởi tạo bảng lương tháng mới
- [ ] Cập nhật thưởng/khấu trừ
- [ ] Xác nhận thanh toán
- [ ] Xem báo cáo lương

---

## 🧯 Lỗi thường gặp

### Không kết nối được SQL Server

Cách xử lý:

- Kiểm tra SQL Server đang chạy
- Kiểm tra connection string trong `appsettings.json`
- Kiểm tra tên server: `.`, `localhost`, `(local)` hoặc tên máy
- Kiểm tra quyền Windows Authentication hoặc SQL Authentication

### Database không tồn tại

Cách xử lý:

- Chạy lại file `DB_DA_QuanLyQuanCF_Professional.sql`
- Kiểm tra database `QuanLyChuoiCaPhe` đã được tạo
- Kiểm tra tên database trong connection string

### Không đăng nhập được

Cách xử lý:

- Kiểm tra tài khoản trong bảng `HeThongTaiKhoan`
- Kiểm tra trường `TrangThai = 1`
- Kiểm tra đúng vai trò và mật khẩu test

### Lỗi trigger hoặc stored procedure

Cách xử lý:

- Kiểm tra dữ liệu đầu vào
- Kiểm tra điều kiện nghiệp vụ
- Đọc thông báo lỗi SQL Server trả về
- Kiểm tra lại thứ tự chạy script database

---

## 🧭 Định hướng phát triển

- [ ] Mã hóa mật khẩu bằng SHA256, BCrypt hoặc ASP.NET Identity
- [ ] Thêm chức năng quên mật khẩu
- [ ] Tối ưu giao diện responsive
- [ ] Thêm biểu đồ thống kê nâng cao
- [ ] Xuất báo cáo PDF/Excel
- [ ] Thêm API cho mobile app
- [ ] Tích hợp thanh toán online
- [ ] Bổ sung unit test và integration test
- [ ] Triển khai CI/CD bằng GitHub Actions

---

## 👨‍💻 Tác giả

**Trần Gia Bảo**

- GitHub: [gibor06](https://github.com/gibor06)
- Dự án: [GIBOR Coffee Chain Management](https://github.com/gibor06/GIBOR-COFFEE-CHAIN-MANAGEMENT)

---

## 📄 Giấy phép

Dự án được xây dựng phục vụ mục đích học tập và nghiên cứu.  
Bạn có thể bổ sung file `LICENSE` nếu muốn phát hành dự án dưới giấy phép mã nguồn mở như MIT, Apache-2.0 hoặc GPL.

---

## ⭐ Góp ý

Nếu bạn thấy dự án hữu ích, hãy để lại một ⭐ trên GitHub để ủng hộ tác giả.
