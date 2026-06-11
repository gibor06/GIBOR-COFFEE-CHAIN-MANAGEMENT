# ☕ GIBOR Coffee Chain Management

**GIBOR Coffee Chain Management** là hệ thống quản lý chuỗi cửa hàng cà phê được xây dựng bằng **ASP.NET Core MVC**, **Entity Framework Core** và **SQL Server**.
Dự án mô phỏng quy trình vận hành thực tế của một chuỗi cà phê, hỗ trợ quản lý chi nhánh, nhân viên, sản phẩm, đơn hàng, kho nguyên liệu, bảng lương, báo cáo doanh thu và phân quyền người dùng.

---

## 🌐 Demo

Demo website:
`https://quanlycaphegibor.runasp.net/`

---

## 📌 Mục tiêu dự án

Dự án được xây dựng nhằm hỗ trợ doanh nghiệp quản lý hoạt động của chuỗi cửa hàng cà phê một cách tập trung, khoa học và hiệu quả hơn.
Thay vì quản lý thủ công bằng giấy tờ hoặc file rời rạc, hệ thống cho phép người dùng theo dõi dữ liệu trên cùng một nền tảng, từ bán hàng, kho, nhân sự đến báo cáo tổng hợp.

---

## ✨ Tính năng chính

### 🔐 Xác thực và phân quyền

* Đăng nhập hệ thống.
* Quản lý phiên đăng nhập bằng Session.
* Phân quyền chức năng theo vai trò người dùng.
* Hiển thị giao diện và menu phù hợp với từng quyền.

Các vai trò chính gồm:

* Admin
* Quản lý
* Nhân viên
* Kho
* Kế toán

---

### 🏢 Quản lý chi nhánh

* Xem danh sách chi nhánh.
* Thêm, sửa thông tin chi nhánh.
* Theo dõi trạng thái hoạt động của chi nhánh.
* Tìm kiếm và lọc dữ liệu chi nhánh.

---

### 👥 Quản lý nhân viên

* Quản lý hồ sơ nhân viên.
* Theo dõi chức vụ, thông tin liên hệ và trạng thái làm việc.
* Quản lý tài khoản đăng nhập của nhân viên.
* Hỗ trợ nghiệp vụ chấm công và tính lương.

---

### ☕ Quản lý sản phẩm

* Quản lý danh mục sản phẩm.
* Quản lý sản phẩm theo từng chi nhánh.
* Quản lý biến thể sản phẩm.
* Quản lý tùy chọn thêm.
* Xem menu sản phẩm theo chi nhánh.

---

### 🧾 Quản lý đơn hàng

* Tạo đơn hàng mới.
* Thêm sản phẩm vào đơn hàng.
* Tính tổng tiền tự động.
* Ghi nhận phương thức thanh toán.
* Áp dụng giảm giá.
* Xem chi tiết đơn hàng.

---

### 📦 Quản lý kho nguyên liệu

* Quản lý danh sách nguyên liệu.
* Quản lý nhà cung cấp.
* Ghi nhận giao dịch nhập kho.
* Ghi nhận giao dịch xuất kho.
* Theo dõi số lượng tồn kho.
* Cảnh báo nguyên liệu sắp hết.

---

### 💰 Quản lý bảng lương

* Khởi tạo bảng lương theo tháng.
* Tính lương nhân viên.
* Cập nhật thưởng và khấu trừ.
* Xác nhận trạng thái thanh toán lương.
* Xem báo cáo lương tổng hợp.

---

### 📊 Báo cáo và thống kê

* Dashboard tổng quan.
* Báo cáo doanh thu.
* Báo cáo đơn hàng.
* Báo cáo tồn kho.
* Báo cáo bảng lương.
* Thống kê hoạt động hệ thống.

---

## 🛠️ Công nghệ sử dụng

| Nhóm công nghệ   | Công nghệ                         |
| ---------------- | --------------------------------- |
| Backend          | ASP.NET Core MVC                  |
| Framework        | .NET 6                            |
| ORM              | Entity Framework Core             |
| Database         | SQL Server                        |
| Frontend         | HTML, CSS, JavaScript, Razor View |
| Ngôn ngữ         | C#, T-SQL                         |
| IDE khuyến nghị  | Visual Studio 2022                |
| Quản lý mã nguồn | Git, GitHub                       |

---

## 📁 Cấu trúc thư mục

```text
GIBOR-COFFEE-CHAIN-MANAGEMENT/
│
├── QuanLyChuoiCaPhe.Web/
│   ├── Controllers/          # Xử lý request và điều hướng nghiệp vụ
│   ├── Data/                 # DbContext và cấu hình dữ liệu
│   ├── Filters/              # Bộ lọc phân quyền
│   ├── Models/               # Entity Models ánh xạ database
│   ├── Services/             # Tầng xử lý nghiệp vụ
│   ├── ViewModels/           # Model trung gian cho View
│   ├── Views/                # Razor Views
│   ├── wwwroot/              # Static files: CSS, JS, images
│   ├── Program.cs            # Cấu hình ứng dụng
│   ├── appsettings.json      # Cấu hình connection string
│   └── QuanLyChuoiCaPhe.Web.csproj
│
├── DB_DA_QuanLyQuanCF_Professional.sql   # Script tạo database
├── Tài khoản.txt                          # Tài khoản test
├── README.md
└── .gitignore
```

---

## ⚙️ Yêu cầu hệ thống

Trước khi chạy dự án, cần cài đặt:

* .NET 6 SDK trở lên
* SQL Server 2019 trở lên
* SQL Server Management Studio hoặc Azure Data Studio
* Visual Studio 2022 hoặc Visual Studio Code
* Git

---

## 🚀 Cài đặt và chạy dự án

### 1. Clone repository

```bash
git clone https://github.com/gibor06/GIBOR-COFFEE-CHAIN-MANAGEMENT.git
cd GIBOR-COFFEE-CHAIN-MANAGEMENT
```

---

### 2. Tạo cơ sở dữ liệu

Mở **SQL Server Management Studio** và chạy file:

```text
DB_DA_QuanLyQuanCF_Professional.sql
```

Script sẽ tạo database:

```text
QuanLyChuoiCaPhe
```

---

### 3. Cấu hình connection string

Mở file:

```text
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

Một số cấu hình Server thường dùng:

```text
Server=.;
Server=localhost;
Server=(local);
Server=TEN_MAY_CUA_BAN;
```

---

### 4. Restore package

```bash
cd QuanLyChuoiCaPhe.Web
dotnet restore
```

---

### 5. Build project

```bash
dotnet build
```

---

### 6. Chạy project

```bash
dotnet run
```

Sau đó truy cập:

```text
https://localhost:5001
```

hoặc:

```text
http://localhost:5000
```

---

## 🗄️ Cơ sở dữ liệu

Database chính của hệ thống:

```text
QuanLyChuoiCaPhe
```

Một số nhóm bảng chính:

* HeThongTaiKhoan
* TaiKhoanNhanVien
* ThongTinNhanVien
* ChiNhanh
* SanPham
* DanhMuc
* DonHang
* ChiTietDonHang
* KhachHang
* NguyenLieu
* TonKhoNguyenLieu
* LichSuKho
* BangLuong
* ChamCong

---

## 👤 Tài khoản đăng nhập

Dự án có file tài khoản test:

```text
Tài khoản.txt
```

Ngoài ra, có thể kiểm tra tài khoản trong database bằng câu lệnh:

```sql
USE QuanLyChuoiCaPhe;

SELECT MaTK, TenDangNhap, VaiTro, TrangThai
FROM HeThongTaiKhoan
WHERE TrangThai = 1;
```

> Lưu ý: Không nên sử dụng tài khoản test cho môi trường production.
> Khi triển khai thực tế, cần đổi mật khẩu và áp dụng cơ chế mã hóa mật khẩu an toàn.

---

## 🧑‍💼 Phân quyền người dùng

### Admin

* Toàn quyền hệ thống.
* Quản lý tài khoản.
* Quản lý chi nhánh.
* Quản lý nhân viên.
* Quản lý sản phẩm.
* Quản lý đơn hàng.
* Quản lý kho.
* Quản lý bảng lương.
* Xem báo cáo tổng hợp.

### Quản lý

* Xem dashboard.
* Quản lý chi nhánh.
* Quản lý nhân viên.
* Quản lý sản phẩm.
* Quản lý đơn hàng.
* Xem báo cáo.

### Nhân viên

* Xem dashboard cá nhân.
* Xem menu sản phẩm.
* Tạo đơn hàng.
* Xem đơn hàng của mình.

### Kho

* Xem dashboard kho.
* Quản lý nguyên liệu.
* Ghi nhận nhập kho.
* Ghi nhận xuất kho.
* Theo dõi cảnh báo tồn kho.

### Kế toán

* Xem dashboard kế toán.
* Quản lý bảng lương.
* Khởi tạo bảng lương.
* Cập nhật thưởng và khấu trừ.
* Xem báo cáo lương.

---

## ⚙️ Stored Procedures & Views

### Stored Procedures quan trọng

| Stored Procedure      | Mô tả                                                 |
| --------------------- | ----------------------------------------------------- |
| sp_TaoDonHang         | Tạo đơn hàng mới và cập nhật tổng tiền, điểm tích lũy |
| sp_GhiNhanGiaoDichKho | Ghi nhận giao dịch nhập/xuất kho                      |
| sp_KhoiTaoBangLuong   | Khởi tạo bảng lương theo tháng                        |
| sp_CanhBaoTonKho      | Kiểm tra nguyên liệu sắp hết                          |

Ví dụ:

```sql
EXEC sp_CanhBaoTonKho;
```

---

### Views quan trọng

| View                | Mô tả                                  |
| ------------------- | -------------------------------------- |
| vw_MenuChiNhanh     | Xem menu sản phẩm theo chi nhánh       |
| vw_CanhBaoTonKho    | Xem danh sách nguyên liệu cần cảnh báo |
| vw_BangLuongTongHop | Xem bảng lương tổng hợp                |

Ví dụ:

```sql
SELECT *
FROM vw_MenuChiNhanh
WHERE MaChiNhanh = 'CN001';
```

---

## ✅ Kiểm thử chức năng

Một số chức năng cần kiểm thử khi chạy dự án:

### Chức năng chung

* Đăng nhập thành công.
* Dashboard hiển thị đúng theo vai trò.
* Sidebar menu hoạt động đúng.
* Đăng xuất thành công.

### Quản lý chi nhánh

* Xem danh sách chi nhánh.
* Thêm chi nhánh mới.
* Sửa thông tin chi nhánh.
* Khóa hoặc mở chi nhánh.
* Tìm kiếm và lọc chi nhánh.

### Quản lý nhân viên

* Xem danh sách nhân viên.
* Thêm nhân viên mới.
* Sửa thông tin nhân viên.
* Cập nhật trạng thái nhân viên.
* Tìm kiếm và lọc nhân viên.

### Quản lý sản phẩm

* Xem danh sách sản phẩm.
* Thêm sản phẩm mới.
* Sửa thông tin sản phẩm.
* Khóa hoặc mở sản phẩm.
* Xem menu theo chi nhánh.

### Quản lý đơn hàng

* Tạo đơn hàng mới.
* Chọn sản phẩm.
* Tính tổng tiền.
* Áp dụng giảm giá.
* Lưu đơn hàng.
* Xem chi tiết đơn hàng.

### Quản lý kho

* Xem danh sách nguyên liệu.
* Ghi nhận nhập kho.
* Ghi nhận xuất kho.
* Cập nhật tồn kho.
* Kiểm tra cảnh báo tồn kho.

### Quản lý bảng lương

* Xem danh sách bảng lương.
* Khởi tạo bảng lương.
* Cập nhật thưởng và khấu trừ.
* Xác nhận thanh toán lương.
* Xem báo cáo lương.

---

## ❗ Lỗi thường gặp

### 1. Không kết nối được database

Kiểm tra lại connection string trong file:

```text
appsettings.json
```

Đảm bảo SQL Server đang chạy và tên database đúng là:

```text
QuanLyChuoiCaPhe
```

---

### 2. Không đăng nhập được

Kiểm tra:

* Đã chạy script database chưa.
* Bảng tài khoản có dữ liệu chưa.
* Tài khoản có đang ở trạng thái hoạt động không.
* Đã nhập đúng username và password trong file tài khoản test chưa.

---

### 3. Lỗi thiếu package

Chạy lại lệnh:

```bash
dotnet restore
```

Sau đó build lại project:

```bash
dotnet build
```

---

## 🔮 Định hướng phát triển

Trong tương lai, hệ thống có thể được mở rộng thêm:

* Mã hóa mật khẩu người dùng.
* Thêm chức năng quên mật khẩu.
* Xuất báo cáo doanh thu ra Excel/PDF.
* Thêm biểu đồ thống kê trực quan.
* Tối ưu giao diện responsive trên điện thoại.
* Tích hợp thanh toán điện tử.
* Quản lý khuyến mãi và voucher.
* Ghi log hoạt động người dùng.
* Phân tích doanh thu theo thời gian thực.

---

## 👨‍💻 Tác giả

Dự án được phát triển bởi nhóm **GIBOR**.

Repository:
`https://github.com/gibor06/GIBOR-COFFEE-CHAIN-MANAGEMENT`

