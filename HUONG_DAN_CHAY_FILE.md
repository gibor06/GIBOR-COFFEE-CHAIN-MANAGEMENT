# HƯỚNG DẪN CHẠY FILE SQL

## 📋 Mục lục
1. [Chuẩn bị](#chuẩn-bị)
2. [Các bước thực hiện](#các-bước-thực-hiện)
3. [Dữ liệu mẫu](#dữ-liệu-mẫu)
4. [Xử lý lỗi](#xử-lý-lỗi)

---

## 🔧 Chuẩn bị

### Yêu cầu hệ thống:
- SQL Server 2019 trở lên
- SQL Server Management Studio (SSMS)
- Quyền tạo database

---

## 📝 Các bước thực hiện

### Bước 1: Xóa database cũ (nếu có)
```sql
-- Chạy file này TRƯỚC KHI chạy file chính
-- File: DROP_DATABASE_TRUOC_KHI_CHAY.sql
```

### Bước 2: Tạo database và dữ liệu cơ bản
```sql
-- Chạy file chính
-- File: GIBOR_COFFEE_COMPLETE.sql
-- Thời gian: ~2-3 phút
```

**File này sẽ tạo:**
- ✅ Database và schema
- ✅ 50 Chi nhánh
- ✅ 50 Nhân viên
- ✅ 50 Khách hàng
- ✅ 10 Nhà cung cấp
- ✅ 50 Nguyên liệu
- ✅ 5 Danh mục
- ✅ 50 Sản phẩm
- ✅ 134 Biến thể
- ✅ 50 Ca làm việc
- ✅ 50 Ngày đặc biệt

### Bước 3: Thêm dữ liệu đơn hàng (tùy chọn)
```sql
-- Chạy file này SAU KHI chạy file chính
-- File: INSERT_DON_HANG.sql
-- Thời gian: ~30 giây
```

**File này sẽ thêm:**
- ✅ 50 Đơn hàng
- ✅ 148 Chi tiết đơn hàng
- ✅ Tổng doanh thu: ~22,000,000 VNĐ

---

## 📊 Dữ liệu mẫu

### Tài khoản đăng nhập:
| Username | Password | Vai trò |
|----------|----------|---------|
| admin | admin123 | ADMIN |
| trangiabao | 123123 | ADMIN |
| tranduonggiabao | 123123 | NHAN_VIEN |

### Chi nhánh:
- 50 chi nhánh trải dài khắp Việt Nam
- Từ CN00000001 đến CN00000050
- Các thành phố: Huế, Đà Nẵng, TP.HCM, Hà Nội, Nha Trang, v.v.

### Sản phẩm:
- **Cà phê**: 15 món (SP0001-SP0015)
- **Trà & Trà sữa**: 12 món (SP0016-SP0027)
- **Đá xay**: 10 món (SP0028-SP0037)
- **Bánh & Snack**: 8 món (SP0038-SP0045)
- **Nước ép & Soda**: 5 món (SP0046-SP0050)

### Khách hàng:
- 50 khách hàng (KH0001-KH0050)
- Điểm tích lũy từ 95-890 điểm

### Đơn hàng:
- 50 đơn hàng (DH0001-DH0050)
- Thời gian: 01/05/2026 - 07/05/2026
- Phương thức thanh toán: Tiền mặt, Thẻ, Chuyển khoản, QR, Ví điện tử
- Tổng doanh thu: ~22 triệu VNĐ

---

## ⚠️ Xử lý lỗi

### Lỗi: "Database already exists"
**Giải pháp:**
```sql
-- Chạy file DROP_DATABASE_TRUOC_KHI_CHAY.sql
-- Sau đó chạy lại file chính
```

### Lỗi: "PRIMARY KEY violation"
**Nguyên nhân:** Database chưa được xóa hoàn toàn

**Giải pháp:**
1. Đóng tất cả kết nối đến database
2. Chạy DROP_DATABASE_TRUOC_KHI_CHAY.sql
3. Chạy lại GIBOR_COFFEE_COMPLETE.sql

### Lỗi: "FOREIGN KEY violation"
**Nguyên nhân:** Thứ tự INSERT không đúng

**Giải pháp:**
- File đã được sắp xếp đúng thứ tự
- Chạy lại từ đầu

### Lỗi khi chạy INSERT_DON_HANG.sql
**Nguyên nhân:** Chưa chạy file chính

**Giải pháp:**
1. Chạy GIBOR_COFFEE_COMPLETE.sql trước
2. Sau đó mới chạy INSERT_DON_HANG.sql

---

## 📞 Hỗ trợ

Nếu gặp vấn đề, vui lòng kiểm tra:
1. ✅ SQL Server đã khởi động
2. ✅ Có quyền tạo database
3. ✅ Không có database cũ đang mở
4. ✅ Chạy đúng thứ tự file

---

## 🎉 Hoàn thành!

Sau khi chạy xong, bạn có thể:
- Đăng nhập vào ứng dụng web
- Xem dữ liệu trong SSMS
- Thực hiện các thao tác quản lý

**Chúc bạn thành công!** ☕
