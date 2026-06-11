/*
    ======================================================================
                        ĐỒ ÁN QUẢN LÝ CHUỖI CỬA HÀNG CÀ PHÊ
    ======================================================================
*/

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */

/* ========================= 0. TẠO CSDL ========================= */
-- Tạo cơ sở dữ liệu --
CREATE DATABASE QuanLyChuoiCaPhe
ON PRIMARY
(
	NAME = 'DB_QuanLyChuoiCaPhe',
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DB_QuanLyChuoiCaPhe.mdf',
	SIZE = 10MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 10%
)
LOG ON
(
	NAME = 'DB_QuanLyChuoiCaPhe_Log',
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DB_QuanLyChuoiCaPhe_Log.ldf',
	SIZE = 10MB,
	MAXSIZE = 30MB,
	FILEGROWTH = 10%
)
GO

-- Sử dụng cơ sở dữ liệu --
USE QuanLyChuoiCaPhe
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET NOCOUNT ON; -- Không đếm các dòng thực thi
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */

/* ========================= 1. DỌN MÔI TRƯỜNG KHI CHẠY LẠI ========================= */
IF OBJECT_ID(N'dbo.sp_TaoDonHang', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_TaoDonHang;
IF OBJECT_ID(N'dbo.sp_GhiNhanGiaoDichKho', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_GhiNhanGiaoDichKho;
IF OBJECT_ID(N'dbo.sp_KhoiTaoBangLuong', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_KhoiTaoBangLuong;
IF OBJECT_ID(N'dbo.sp_CanhBaoTonKho', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_CanhBaoTonKho;
IF OBJECT_ID(N'dbo.sp_DongBoSanPhamVaoChiNhanh', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_DongBoSanPhamVaoChiNhanh;
IF OBJECT_ID(N'dbo.sp_DongBoTatCaSanPham', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_DongBoTatCaSanPham;
GO

IF TYPE_ID(N'dbo.TVP_ChiTietDonHang') IS NOT NULL DROP TYPE dbo.TVP_ChiTietDonHang;
GO

IF OBJECT_ID(N'dbo.fn_TinhTongTienDonHang', N'FN') IS NOT NULL DROP FUNCTION dbo.fn_TinhTongTienDonHang;
IF OBJECT_ID(N'dbo.fn_TinhDiemTichLuyDonHang', N'FN') IS NOT NULL DROP FUNCTION dbo.fn_TinhDiemTichLuyDonHang;
IF OBJECT_ID(N'dbo.fn_SoGioLamViec', N'FN') IS NOT NULL DROP FUNCTION dbo.fn_SoGioLamViec;
GO

IF OBJECT_ID(N'dbo.vw_MenuChiNhanh', N'V') IS NOT NULL DROP VIEW dbo.vw_MenuChiNhanh;
IF OBJECT_ID(N'dbo.vw_CanhBaoTonKho', N'V') IS NOT NULL DROP VIEW dbo.vw_CanhBaoTonKho;
IF OBJECT_ID(N'dbo.vw_BangLuongTongHop', N'V') IS NOT NULL DROP VIEW dbo.vw_BangLuongTongHop;
GO

IF OBJECT_ID(N'dbo.TR_HeThongTaiKhoan_NhatKy', N'TR') IS NOT NULL DROP TRIGGER dbo.TR_HeThongTaiKhoan_NhatKy;
IF OBJECT_ID(N'dbo.TRG_ChiNhanh_NhatKy', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_ChiNhanh_NhatKy;
IF OBJECT_ID(N'dbo.TRG_ThongTinNhanVien_SetTrangThai', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_ThongTinNhanVien_SetTrangThai;
IF OBJECT_ID(N'dbo.TRG_LichPhanCong_Validate', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_LichPhanCong_Validate;
IF OBJECT_ID(N'dbo.TRG_ChamCong_XuLy', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_ChamCong_XuLy;
IF OBJECT_ID(N'dbo.TRG_BangLuong_KhoaDuLieu', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_BangLuong_KhoaDuLieu;
IF OBJECT_ID(N'dbo.TRG_SanPham_DongBoTrangThaiChiNhanh', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_SanPham_DongBoTrangThaiChiNhanh;
IF OBJECT_ID(N'dbo.TRG_SanPham_TuDongDongBoChiNhanh', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_SanPham_TuDongDongBoChiNhanh;
IF OBJECT_ID(N'dbo.TRG_SanPham_CapNhatTrangThaiBienThe', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_SanPham_CapNhatTrangThaiBienThe;
IF OBJECT_ID(N'dbo.TRG_LichSuKho_CapNhatTon', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_LichSuKho_CapNhatTon;
IF OBJECT_ID(N'dbo.TRG_ChiTietDonHang_CapNhatTongTien', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_ChiTietDonHang_CapNhatTongTien;
IF OBJECT_ID(N'dbo.TRG_DonHang_CapNhatDiem', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_DonHang_CapNhatDiem;
GO

IF OBJECT_ID(N'dbo.HanhTrinhDonHang', N'U') IS NOT NULL DROP TABLE dbo.HanhTrinhDonHang;
IF OBJECT_ID(N'dbo.ChiTietDonHang', N'U') IS NOT NULL DROP TABLE dbo.ChiTietDonHang;
IF OBJECT_ID(N'dbo.DonHang', N'U') IS NOT NULL DROP TABLE dbo.DonHang;
IF OBJECT_ID(N'dbo.KhachHang', N'U') IS NOT NULL DROP TABLE dbo.KhachHang;
IF OBJECT_ID(N'dbo.LichSuKho', N'U') IS NOT NULL DROP TABLE dbo.LichSuKho;
IF OBJECT_ID(N'dbo.CongThucPhaChe', N'U') IS NOT NULL DROP TABLE dbo.CongThucPhaChe;
IF OBJECT_ID(N'dbo.TonKhoNguyenLieu', N'U') IS NOT NULL DROP TABLE dbo.TonKhoNguyenLieu;
IF OBJECT_ID(N'dbo.NguyenLieu', N'U') IS NOT NULL DROP TABLE dbo.NguyenLieu;
IF OBJECT_ID(N'dbo.NhaCungCap', N'U') IS NOT NULL DROP TABLE dbo.NhaCungCap;
IF OBJECT_ID(N'dbo.SanPham_TuyChon', N'U') IS NOT NULL DROP TABLE dbo.SanPham_TuyChon;
IF OBJECT_ID(N'dbo.TuyChonThem', N'U') IS NOT NULL DROP TABLE dbo.TuyChonThem;
IF OBJECT_ID(N'dbo.BienTheSanPham', N'U') IS NOT NULL DROP TABLE dbo.BienTheSanPham;
IF OBJECT_ID(N'dbo.SanPham_ChiNhanh', N'U') IS NOT NULL DROP TABLE dbo.SanPham_ChiNhanh;
IF OBJECT_ID(N'dbo.SanPham', N'U') IS NOT NULL DROP TABLE dbo.SanPham;
IF OBJECT_ID(N'dbo.DanhMuc', N'U') IS NOT NULL DROP TABLE dbo.DanhMuc;
IF OBJECT_ID(N'dbo.PhatDiMuon', N'U') IS NOT NULL DROP TABLE dbo.PhatDiMuon;
IF OBJECT_ID(N'dbo.ChamCong', N'U') IS NOT NULL DROP TABLE dbo.ChamCong;
IF OBJECT_ID(N'dbo.LichPhanCong', N'U') IS NOT NULL DROP TABLE dbo.LichPhanCong;
IF OBJECT_ID(N'dbo.NgayDacBiet', N'U') IS NOT NULL DROP TABLE dbo.NgayDacBiet;
IF OBJECT_ID(N'dbo.CaLamViec', N'U') IS NOT NULL DROP TABLE dbo.CaLamViec;
IF OBJECT_ID(N'dbo.BangLuong', N'U') IS NOT NULL DROP TABLE dbo.BangLuong;
IF OBJECT_ID(N'dbo.TaiKhoanNhanVien', N'U') IS NOT NULL DROP TABLE dbo.TaiKhoanNhanVien;
IF OBJECT_ID(N'dbo.ThongTinNhanVien', N'U') IS NOT NULL DROP TABLE dbo.ThongTinNhanVien;
IF OBJECT_ID(N'dbo.ChucVuNhanVien', N'U') IS NOT NULL DROP TABLE dbo.ChucVuNhanVien;
IF OBJECT_ID(N'dbo.ChiNhanh', N'U') IS NOT NULL DROP TABLE dbo.ChiNhanh;
IF OBJECT_ID(N'dbo.KhuVuc', N'U') IS NOT NULL DROP TABLE dbo.KhuVuc;
IF OBJECT_ID(N'dbo.DuLieuHeThong', N'U') IS NOT NULL DROP TABLE dbo.DuLieuHeThong;
IF OBJECT_ID(N'dbo.HeThongTaiKhoan', N'U') IS NOT NULL DROP TABLE dbo.HeThongTaiKhoan;
GO

IF OBJECT_ID(N'dbo.SEQ_MaNV', N'SO') IS NOT NULL DROP SEQUENCE dbo.SEQ_MaNV;
IF OBJECT_ID(N'dbo.SEQ_MaLich', N'SO') IS NOT NULL DROP SEQUENCE dbo.SEQ_MaLich;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI NGUYỄN THẾ ANH --

/* =============================================================================================================== */

/*=================================================== 2. Quản lý Hệ Thống ======================================*/
CREATE TABLE dbo.HeThongTaiKhoan
(
    MaTK            CHAR(10)        NOT NULL,
    TenDangNhap     VARCHAR(50)     NOT NULL,
    MatKhauHash     VARCHAR(200)    NOT NULL,
    VaiTro          NVARCHAR(30)    NOT NULL,
    TrangThai       BIT             NOT NULL CONSTRAINT DF_HeThongTaiKhoan_TrangThai DEFAULT 1,
    NgayTao         DATETIME2(0)    NOT NULL CONSTRAINT DF_HeThongTaiKhoan_NgayTao DEFAULT SYSDATETIME(),
    CONSTRAINT PK_HeThongTaiKhoan PRIMARY KEY (MaTK),
    CONSTRAINT UQ_HeThongTaiKhoan_TenDangNhap UNIQUE (TenDangNhap),
    CONSTRAINT CHK_HeThongTaiKhoan_VaiTro CHECK (VaiTro IN (N'ADMIN', N'QUAN_LY', N'NHAN_VIEN', N'KHO', N'KE_TOAN')),
    CONSTRAINT CHK_HeThongTaiKhoan_TrangThai CHECK (TrangThai IN (0,1))
);
/*
			Chức năng
	•	Quản lý các tài khoản đăng nhập vào hệ thống quản lý quán cà phê.
	•	Lưu trữ thông tin tài khoản, mật khẩu.
	•	Xác định trạng thái hoạt động của tài khoản (còn hoạt động hoặc bị khóa).

			Đặc điểm
	•	Mỗi tài khoản có một mã duy nhất (MaTK) làm khóa chính.
	•	Có phân quyền thông qua trường ChucVu (Quản lý, Nhân viên,…).
	•	Có ràng buộc kiểm tra giá trị trạng thái chỉ nhận 0 hoặc 1.

	*/
GO

CREATE TABLE dbo.DuLieuHeThong
(
    MaDuLieu        CHAR(15)        NOT NULL,
    MaTK            CHAR(10)        NULL,
    HanhDong        NVARCHAR(100)   NOT NULL,
    TenBang         NVARCHAR(100)   NOT NULL,
    SoLuongTacDong  INT             NOT NULL,
    NoiDung         NVARCHAR(250)   NULL,
    ThoiGian        DATETIME2(0)    NOT NULL CONSTRAINT DF_DuLieuHeThong_ThoiGian DEFAULT SYSDATETIME(),
    CONSTRAINT PK_DuLieuHeThong PRIMARY KEY (MaDuLieu),
    CONSTRAINT FK_DuLieuHeThong_HeThongTaiKhoan FOREIGN KEY (MaTK) REFERENCES dbo.HeThongTaiKhoan(MaTK)
);
/*
			Chức năng
	•	Lưu trữ nhật ký hoạt động của hệ thống.
	•	Ghi nhận các hành động như thêm, sửa, xóa dữ liệu trên các bảng quan trọng.
	•	Theo dõi thời gian và nội dung của từng thao tác.

			Đặc điểm
	•	Mỗi bản ghi có mã dữ liệu (MaDuLieu) làm khóa chính.
	•	Liên kết với bảng HeThongTaiKhoan thông qua khóa ngoại MaTK.
	•	Thời gian được tự động ghi nhận bằng GETDATE().

	*/
GO

/* =============================================================================================================== */

                                            -- CODE BỞI NGUYỄN THẾ ANH --

/* =============================================================================================================== */

/*=================================================== 3. Quản Lý Chi Nhánh ======================================*/
CREATE TABLE dbo.KhuVuc
(
    MaKhuVuc        CHAR(10)        NOT NULL,
    TenKhuVuc       NVARCHAR(100)   NOT NULL,
    CONSTRAINT PK_KhuVuc PRIMARY KEY (MaKhuVuc),
    CONSTRAINT UQ_KhuVuc_Ten UNIQUE (TenKhuVuc)
);
/*
			Chức năng
	•	Quản lý các khu vực địa lý của hệ thống quán cà phê.
	•	Làm cơ sở để phân chia và quản lý các chi nhánh.

			Đặc điểm
	•	Mỗi khu vực có mã riêng (MaKhuVuc) làm khóa chính.
	•	Thiết kế đơn giản, dễ mở rộng khi thêm khu vực mới.

	*/
GO

CREATE TABLE dbo.ChiNhanh
(
    MaChiNhanh      CHAR(10)        NOT NULL,
    MaKhuVuc        CHAR(10)        NOT NULL,
    TenChiNhanh     NVARCHAR(100)   NOT NULL,
    SoDienThoai     VARCHAR(10)     NOT NULL,
    DiaChi          NVARCHAR(200)   NOT NULL,
    TrangThai       BIT             NOT NULL CONSTRAINT DF_ChiNhanh_TrangThai DEFAULT 1,
    NgayThanhLap    DATE            NOT NULL CONSTRAINT DF_ChiNhanh_NgayThanhLap DEFAULT CONVERT(DATE, GETDATE()),
    CONSTRAINT PK_ChiNhanh PRIMARY KEY (MaChiNhanh),
    CONSTRAINT FK_ChiNhanh_KhuVuc FOREIGN KEY (MaKhuVuc) REFERENCES dbo.KhuVuc(MaKhuVuc),
    CONSTRAINT UQ_ChiNhanh_Ten UNIQUE (TenChiNhanh),
    CONSTRAINT UQ_ChiNhanh_SDT UNIQUE (SoDienThoai),
    CONSTRAINT CHK_ChiNhanh_SDT CHECK (SoDienThoai NOT LIKE '%[^0-9]%' AND LEN(SoDienThoai)=10),
    CONSTRAINT CHK_ChiNhanh_TrangThai CHECK (TrangThai IN (0,1))
);
/*
			Chức năng
	•	Quản lý thông tin các chi nhánh của quán cà phê.
	•	Lưu trữ thông tin liên hệ, trạng thái hoạt động và ngày thành lập.

			Đặc điểm
	•	Mỗi chi nhánh có mã riêng (MaChiNhanh) làm khóa chính.
	•	Có khóa ngoại liên kết với bảng KhuVuc.
	•	Ngày thành lập được tự động gán giá trị mặc định.
	•	Có ràng buộc kiểm tra giá trị trạng thái chỉ nhận 0 hoặc 1.

	*/
GO

/* ========================= 4. NHÂN SỰ - CHẤM CÔNG - LƯƠNG ========================= */

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */

/* ========================================  NHÂN SỰ  ========================= */
CREATE TABLE dbo.ChucVuNhanVien
(
    MaChucVu        CHAR(10)        NOT NULL,
    TenChucVu       NVARCHAR(100)   NOT NULL,
    LuongCoBanGio   DECIMAL(18,2)   NOT NULL,
    CONSTRAINT PK_ChucVuNhanVien PRIMARY KEY (MaChucVu),
    CONSTRAINT UQ_ChucVuNhanVien_Ten UNIQUE (TenChucVu),
    CONSTRAINT CHK_ChucVuNhanVien_Luong CHECK (LuongCoBanGio > 0)
);
/*
            Chức năng:
    •	Lưu trữ danh sách các chức vụ trong hệ thống.
    •	Mỗi chức vụ gắn với một mức lương cơ bản theo giờ.

            Đặc điểm:
    •	Khóa chính: MaChucVu.
    •	Ràng buộc lương cơ bản luôn > 0.
    •	Là cơ sở để tính lương thực tế khi chấm công.
    */
GO

CREATE TABLE dbo.ThongTinNhanVien
(
    MaNV            CHAR(10)        NOT NULL,
    LoaiNV          TINYINT         NOT NULL, -- 1 fulltime, 2 parttime
    HoTenNV         NVARCHAR(100)   NOT NULL,
    MaChucVu        CHAR(10)        NOT NULL,
    MaChiNhanh      CHAR(10)        NOT NULL,
    NgayVaoLam      DATE            NOT NULL,
    NgayNghiViec    DATE            NULL,
    SoDienThoai     VARCHAR(10)     NOT NULL,
    SoCCCD          VARCHAR(12)     NULL,
    Email           VARCHAR(100)    NULL,
    TrangThai       BIT             NOT NULL CONSTRAINT DF_ThongTinNhanVien_TrangThai DEFAULT 1,
    CONSTRAINT PK_ThongTinNhanVien PRIMARY KEY (MaNV),
    CONSTRAINT FK_ThongTinNhanVien_ChucVu FOREIGN KEY (MaChucVu) REFERENCES dbo.ChucVuNhanVien(MaChucVu),
    CONSTRAINT FK_ThongTinNhanVien_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT UQ_ThongTinNhanVien_SDT UNIQUE (SoDienThoai),
    CONSTRAINT CHK_ThongTinNhanVien_Loai CHECK (LoaiNV IN (1,2)),
    CONSTRAINT CHK_ThongTinNhanVien_SDT CHECK (SoDienThoai NOT LIKE '%[^0-9]%' AND LEN(SoDienThoai)=10),
    CONSTRAINT CHK_ThongTinNhanVien_Ngay CHECK (NgayNghiViec IS NULL OR NgayNghiViec >= NgayVaoLam)
);
GO

-- BẮT ĐẦU TRẦN DƯƠNG GIA BẢO CHỈNH SỬA
-- Khởi tạo Filtered Unique Index: Loại bỏ các giá trị NULL ra khỏi chỉ mục duy nhất để cho phép để trống nhiều dòng
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'UQ_NhanVien_CCCD_Filtered' AND object_id = OBJECT_ID('dbo.ThongTinNhanVien'))
BEGIN
    DROP INDEX UQ_NhanVien_CCCD_Filtered ON dbo.ThongTinNhanVien;
END
GO

CREATE UNIQUE NONCLUSTERED INDEX UQ_NhanVien_CCCD_Filtered 
ON dbo.ThongTinNhanVien(SoCCCD) 
WHERE SoCCCD IS NOT NULL;
GO

-- Thiết lập Check Constraint cấu trúc phủ định kép chặn hoàn toàn ký tự chữ
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'CHK_NhanVien_CCCD' AND type = 'C')
BEGIN
    ALTER TABLE dbo.ThongTinNhanVien DROP CONSTRAINT CHK_NhanVien_CCCD;
END
GO

ALTER TABLE dbo.ThongTinNhanVien ADD CONSTRAINT CHK_NhanVien_CCCD 
CHECK (
    LEN(SoCCCD) = 12                     -- Bắt buộc chuỗi đạt độ dài chuẩn 12 ký tự
    AND SoCCCD NOT LIKE '%[^0-9]%'       -- Nếu tìm thấy bất kỳ ký tự nào ngoài khoảng từ 0 đến 9 sẽ trả về FALSE
);
GO
-- KẾT THÚC TRẦN DƯƠNG GIA BẢO CHỈNH SỬA
/*
                Chức năng:
        •	Quản lý thông tin cá nhân và tình trạng làm việc của nhân viên.
        •	Phân loại nhân viên Fulltime / Parttime.
        •	Liên kết với chi nhánh và chức vụ.
        
                Đặc điểm:
        •	Khóa chính: MaNV.
        •	Ràng buộc:
            o	CCCD là duy nhất.
            o	Ngày nghỉ việc >= ngày vào làm.
            o	Số điện thoại hợp lệ.
        •	Trạng thái nhân viên tự động cập nhật (đang làm / nghỉ).

    */
GO

CREATE TABLE dbo.TaiKhoanNhanVien
(
    MaTK            CHAR(10)        NOT NULL,
    MaNV            CHAR(10)        NOT NULL,
    CONSTRAINT PK_TaiKhoanNhanVien PRIMARY KEY (MaTK, MaNV),
    CONSTRAINT FK_TaiKhoanNhanVien_TK FOREIGN KEY (MaTK) REFERENCES dbo.HeThongTaiKhoan(MaTK),
    CONSTRAINT FK_TaiKhoanNhanVien_NV FOREIGN KEY (MaNV) REFERENCES dbo.ThongTinNhanVien(MaNV)
);
GO

/* ================================================================================================ */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */

/* =========================  CHẤM CÔNG  ========================= */

CREATE TABLE dbo.CaLamViec
(
    MaCa            CHAR(10)        NOT NULL,
    LoaiCa          TINYINT         NOT NULL,
    TenCa           NVARCHAR(100)   NOT NULL,
    HeSoCa          DECIMAL(5,2)    NOT NULL CONSTRAINT DF_CaLamViec_HeSo DEFAULT 1,
    GioBatDau       TIME            NOT NULL,
    GioKetThuc      TIME            NOT NULL,
    CONSTRAINT PK_CaLamViec PRIMARY KEY (MaCa),
    CONSTRAINT CHK_CaLamViec_Loai CHECK (LoaiCa IN (1,2)),
    CONSTRAINT CHK_CaLamViec_HeSo CHECK (HeSoCa > 0)
);
/*
            Chức năng:
    •	Quản lý các ca làm việc: sáng, chiều, đêm, part-time.
    •	Xác định loại ca (Fulltime / Parttime).
    •	Xác định hệ số ca (ca đêm, ca lễ có hệ số cao hơn).
        
            Đặc điểm:
    •	Khóa chính: MaCa.
    •	Ràng buộc loại ca chỉ nhận giá trị hợp lệ (1 hoặc 2).
    •	Lưu giờ bắt đầu – kết thúc để xác định đi muộn / về sớm.

    */
GO

CREATE TABLE dbo.NgayDacBiet
(
    Ngay            DATE            NOT NULL,
    TenNgay         NVARCHAR(100)   NOT NULL,
    HeSoLuong       DECIMAL(5,2)    NOT NULL,
    CONSTRAINT PK_NgayDacBiet PRIMARY KEY (Ngay),
    CONSTRAINT CHK_NgayDacBiet_HeSo CHECK (HeSoLuong >= 1)
);
/*
            Chức năng:
    •	Lưu các ngày lễ, Tết, ngày đặc biệt.
    •	Áp dụng hệ số lương cao hơn trong những ngày này.
            
            Ý nghĩa:
    •	Phục vụ tính thưởng lễ, Tết.
    •	Kết hợp trực tiếp với tính lương trong bảng chấm công.

    */
GO

CREATE TABLE dbo.LichPhanCong
(
    MaLich          CHAR(15)        NOT NULL,
    MaNV            CHAR(10)        NOT NULL,
    MaCa            CHAR(10)        NOT NULL,
    NgayLamViec     DATE            NOT NULL,
    TrangThai       NVARCHAR(20)    NOT NULL CONSTRAINT DF_LichPhanCong_TrangThai DEFAULT N'Đã phân công',
    GhiChu          NVARCHAR(200)   NULL,
    CONSTRAINT PK_LichPhanCong PRIMARY KEY (MaLich),
    CONSTRAINT FK_LichPhanCong_NV FOREIGN KEY (MaNV) REFERENCES dbo.ThongTinNhanVien(MaNV),
    CONSTRAINT FK_LichPhanCong_Ca FOREIGN KEY (MaCa) REFERENCES dbo.CaLamViec(MaCa),
    CONSTRAINT UQ_LichPhanCong UNIQUE (MaNV, MaCa, NgayLamViec),
    CONSTRAINT CHK_LichPhanCong_TrangThai CHECK (TrangThai IN (N'Đã phân công', N'Hủy ca', N'Nghỉ phép'))
);
/*
                Chức năng:
        •	Phân ca làm việc cho nhân viên theo từng ngày.
        •	Ghi nhận trạng thái ca: đã phân công, hủy ca, nghỉ phép.

                Ràng buộc nghiệp vụ:
        •	Một nhân viên không được trùng ca trong cùng ngày.
        •	Không phân ca cho nhân viên đã nghỉ việc.
        •	Không phân ca trước ngày vào làm.
    */
GO

CREATE TABLE dbo.ChamCong
(
    MaChamCong      CHAR(10)        NOT NULL,
    MaNV            CHAR(10)        NOT NULL,
    MaLich          CHAR(15)        NOT NULL,
    GioVao          DATETIME2(0)    NOT NULL,
    GioRa           DATETIME2(0)    NOT NULL,
    TrangThai       NVARCHAR(20)    NULL,
    HeSoNgay        DECIMAL(5,2)    NULL,
    HeSoCa          DECIMAL(5,2)    NULL,
    LuongThucTe     DECIMAL(18,2)   NULL,
    CONSTRAINT PK_ChamCong PRIMARY KEY (MaChamCong),
    CONSTRAINT FK_ChamCong_NV FOREIGN KEY (MaNV) REFERENCES dbo.ThongTinNhanVien(MaNV),
    CONSTRAINT FK_ChamCong_Lich FOREIGN KEY (MaLich) REFERENCES dbo.LichPhanCong(MaLich),
    CONSTRAINT UQ_ChamCong UNIQUE (MaNV, MaLich),
    CONSTRAINT CHK_ChamCong_TrangThai CHECK (TrangThai IS NULL OR TrangThai IN (N'Hợp lệ', N'Đi muộn', N'Về sớm'))
);
    /*
            Chức năng:
    •	Ghi nhận giờ vào – giờ ra của nhân viên.
    •	Xác định trạng thái: hợp lệ, đi muộn, về sớm.

    */
GO

CREATE TABLE dbo.PhatDiMuon
(
    MaChamCong      CHAR(10)        NOT NULL,
    MaNV            CHAR(10)        NOT NULL,
    SoTien          DECIMAL(18,2)   NOT NULL,
    NgayPhat        DATE            NOT NULL,
    CONSTRAINT PK_PhatDiMuon PRIMARY KEY (MaChamCong),
    CONSTRAINT FK_PhatDiMuon_ChamCong FOREIGN KEY (MaChamCong) REFERENCES dbo.ChamCong(MaChamCong),
    CONSTRAINT FK_PhatDiMuon_NV FOREIGN KEY (MaNV) REFERENCES dbo.ThongTinNhanVien(MaNV),
    CONSTRAINT CHK_PhatDiMuon_SoTien CHECK (SoTien >= 0)
);
    /*
            Chức năng:
    •	Lưu thông tin phạt khi nhân viên đi muộn.
    •	Mức phạt cố định: 30.000 VNĐ / lần.
        
            Tự động hóa:
    •	Tạo bản ghi phạt khi trạng thái chuyển sang “Đi muộn”.
    •	Tự động xóa phạt nếu sửa lại chấm công hợp lệ.
    */
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */
/* =========================  LƯƠNG  ========================= */

CREATE TABLE dbo.BangLuong
(
    MaNV            CHAR(10)        NOT NULL,
    Thang           TINYINT         NOT NULL,
    Nam             SMALLINT        NOT NULL,
    TongGioThucTe   DECIMAL(12,2)   NOT NULL CONSTRAINT DF_BangLuong_Gio DEFAULT 0,
    TongLuongCa     DECIMAL(18,2)   NOT NULL CONSTRAINT DF_BangLuong_Luong DEFAULT 0,
    TongThuong      DECIMAL(18,2)   NOT NULL CONSTRAINT DF_BangLuong_Thuong DEFAULT 0,
    TongKhauTru     DECIMAL(18,2)   NOT NULL CONSTRAINT DF_BangLuong_Tru DEFAULT 0,
    ThucLanh        AS (TongLuongCa + TongThuong - TongKhauTru) PERSISTED,
    TrangThai       NVARCHAR(20)    NOT NULL CONSTRAINT DF_BangLuong_TrangThai DEFAULT N'Tạm tính',
        
    CONSTRAINT PK_BangLuong PRIMARY KEY (MaNV, Thang, Nam),
    CONSTRAINT FK_BangLuong_NV FOREIGN KEY (MaNV) REFERENCES dbo.ThongTinNhanVien(MaNV),
    CONSTRAINT CHK_BangLuong_Thang CHECK (Thang BETWEEN 1 AND 12),
    CONSTRAINT CHK_BangLuong_Nam CHECK (Nam BETWEEN 2024 AND 2100),
    CONSTRAINT CHK_BangLuong_TrangThai CHECK (TrangThai IN (N'Tạm tính', N'Đã thanh toán')),
    CONSTRAINT CHK_BangLuong_SoTien CHECK (TongLuongCa >= 0 AND TongThuong >= 0 AND TongKhauTru >= 0)
);
GO

/* =============================================================================================================== */

                                            -- CODE BỞI NGUYỄN NGỌC CHÂU --

/* =============================================================================================================== */
/* ========================= 5. BÁN HÀNG - MENU ========================= */
CREATE TABLE dbo.DanhMuc
(
    MaDanhMuc       CHAR(10)        NOT NULL,
    TenDanhMuc      NVARCHAR(100)   NOT NULL,
    MoTa            NVARCHAR(255)   NULL,
    CONSTRAINT PK_DanhMuc PRIMARY KEY (MaDanhMuc),
    CONSTRAINT UQ_DanhMuc_Ten UNIQUE (TenDanhMuc)
);
GO

CREATE TABLE dbo.SanPham
(
    MaSanPham       CHAR(10)        NOT NULL,
    MaDanhMuc       CHAR(10)        NOT NULL,
    TenSanPham      NVARCHAR(150)   NOT NULL,
    GiaCoBan        DECIMAL(18,2)   NOT NULL,
    TrangThai       BIT             NOT NULL CONSTRAINT DF_SanPham_TrangThai DEFAULT 1,
    MoTa            NVARCHAR(255)   NULL,
    CONSTRAINT PK_SanPham PRIMARY KEY (MaSanPham),
    CONSTRAINT FK_SanPham_DanhMuc FOREIGN KEY (MaDanhMuc) REFERENCES dbo.DanhMuc(MaDanhMuc),
    CONSTRAINT UQ_SanPham_Ten UNIQUE (TenSanPham),
    CONSTRAINT CHK_SanPham_Gia CHECK (GiaCoBan > 0),
    CONSTRAINT CHK_SanPham_TrangThai CHECK (TrangThai IN (0,1))
);
GO

CREATE TABLE dbo.SanPham_ChiNhanh
(
    MaChiNhanh      CHAR(10)        NOT NULL,
    MaSanPham       CHAR(10)        NOT NULL,
    GiaBan          DECIMAL(18,2)   NOT NULL,
    TrangThai       BIT             NOT NULL CONSTRAINT DF_SanPham_ChiNhanh_TrangThai DEFAULT 1,
    CONSTRAINT PK_SanPham_ChiNhanh PRIMARY KEY (MaChiNhanh, MaSanPham),
    CONSTRAINT FK_SanPham_ChiNhanh_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_SanPham_ChiNhanh_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham),
    CONSTRAINT CHK_SanPham_ChiNhanh_Gia CHECK (GiaBan > 0),
    CONSTRAINT CHK_SanPham_ChiNhanh_TrangThai CHECK (TrangThai IN (0,1))
);
GO

CREATE TABLE dbo.BienTheSanPham
(
    MaBienThe       CHAR(10)        NOT NULL,
    MaSanPham       CHAR(10)        NOT NULL,
    Size            NVARCHAR(10)    NOT NULL,
    GiaCongThem     DECIMAL(18,2)   NOT NULL CONSTRAINT DF_BienTheSanPham_GiaCong DEFAULT 0,
    TrangThai       BIT             NOT NULL CONSTRAINT DF_BienTheSanPham_TrangThai DEFAULT 1,
    CONSTRAINT PK_BienTheSanPham PRIMARY KEY (MaBienThe),
    CONSTRAINT FK_BienTheSanPham_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham),
    CONSTRAINT UQ_BienTheSanPham UNIQUE (MaSanPham, Size),
    CONSTRAINT CHK_BienTheSanPham_Size CHECK (Size IN (N'Nhỏ', N'Vừa', N'Lớn')),
    CONSTRAINT CHK_BienTheSanPham_GiaCong CHECK (GiaCongThem >= 0),
    CONSTRAINT CHK_BienTheSanPham_TrangThai CHECK (TrangThai IN (0,1))
);
GO

CREATE TABLE dbo.TuyChonThem
(
    MaTuyChon       CHAR(10)        NOT NULL,
    TenTuyChon      NVARCHAR(100)   NOT NULL,
    GiaCongThem     DECIMAL(18,2)   NOT NULL,
    TrangThai       BIT             NOT NULL CONSTRAINT DF_TuyChonThem_TrangThai DEFAULT 1,
    CONSTRAINT PK_TuyChonThem PRIMARY KEY (MaTuyChon),
    CONSTRAINT UQ_TuyChonThem_Ten UNIQUE (TenTuyChon),
    CONSTRAINT CHK_TuyChonThem_Gia CHECK (GiaCongThem >= 0),
    CONSTRAINT CHK_TuyChonThem_TrangThai CHECK (TrangThai IN (0,1))
);
GO

CREATE TABLE dbo.SanPham_TuyChon
(
    MaSanPham       CHAR(10)        NOT NULL,
    MaTuyChon       CHAR(10)        NOT NULL,
    CONSTRAINT PK_SanPham_TuyChon PRIMARY KEY (MaSanPham, MaTuyChon),
    CONSTRAINT FK_SanPham_TuyChon_SanPham FOREIGN KEY (MaSanPham) REFERENCES dbo.SanPham(MaSanPham),
    CONSTRAINT FK_SanPham_TuyChon_TuyChon FOREIGN KEY (MaTuyChon) REFERENCES dbo.TuyChonThem(MaTuyChon)
);
GO

/* =============================================================================================================== */

                                            -- CODE BỞI LÊ QUANG BẢO --

/* =============================================================================================================== */
/* ========================= 6. KHO - CÔNG THỨC ========================= */
CREATE TABLE dbo.NhaCungCap
(
    MaNCC           CHAR(10)        NOT NULL,
    TenNCC          NVARCHAR(100)   NOT NULL,
    DienThoai       VARCHAR(10)     NOT NULL,
    Email           VARCHAR(100)    NULL,
    DiaChi          NVARCHAR(200)   NULL,
    TrangThai       NVARCHAR(20)    NOT NULL,
    CONSTRAINT PK_NhaCungCap PRIMARY KEY (MaNCC),
    CONSTRAINT UQ_NhaCungCap_Ten UNIQUE (TenNCC),
    CONSTRAINT UQ_NhaCungCap_SDT UNIQUE (DienThoai),
    CONSTRAINT CHK_NhaCungCap_TrangThai CHECK (TrangThai IN (N'Đang hợp tác', N'Ngừng hợp tác')),
    CONSTRAINT CHK_NhaCungCap_SDT CHECK (DienThoai NOT LIKE '%[^0-9]%' AND LEN(DienThoai)=10)
);
GO

CREATE TABLE dbo.NguyenLieu
(
    MaNguyenLieu    CHAR(10)        NOT NULL,
    TenNguyenLieu   NVARCHAR(100)   NOT NULL,
    DonViTinh       NVARCHAR(20)    NOT NULL,
    GiaNhap         DECIMAL(18,2)   NOT NULL,
    MaNCC           CHAR(10)        NOT NULL,
    CoHanSuDung     BIT             NOT NULL CONSTRAINT DF_NguyenLieu_HSD DEFAULT 0,
    TrangThai       NVARCHAR(20)    NOT NULL,
    CONSTRAINT PK_NguyenLieu PRIMARY KEY (MaNguyenLieu),
    CONSTRAINT FK_NguyenLieu_NCC FOREIGN KEY (MaNCC) REFERENCES dbo.NhaCungCap(MaNCC),
    CONSTRAINT UQ_NguyenLieu_Ten UNIQUE (TenNguyenLieu),
    CONSTRAINT CHK_NguyenLieu_Gia CHECK (GiaNhap > 0),
    CONSTRAINT CHK_NguyenLieu_TrangThai CHECK (TrangThai IN (N'Đang sử dụng', N'Ngưng sử dụng'))
);
GO

CREATE TABLE dbo.TonKhoNguyenLieu
(
    MaChiNhanh      CHAR(10)        NOT NULL,
    MaNguyenLieu    CHAR(10)        NOT NULL,
    SoLuongTon      DECIMAL(18,2)   NOT NULL CONSTRAINT DF_TonKhoNguyenLieu_Ton DEFAULT 0,
    MucCanhBao      DECIMAL(18,2)   NOT NULL CONSTRAINT DF_TonKhoNguyenLieu_CanhBao DEFAULT 0,
    HanSuDung       DATE            NULL,
    SoLuongDaDat    DECIMAL(18,2)   NOT NULL CONSTRAINT DF_TonKhoNguyenLieu_DaDat DEFAULT 0,
    CONSTRAINT PK_TonKhoNguyenLieu PRIMARY KEY (MaChiNhanh, MaNguyenLieu),
    CONSTRAINT FK_TonKhoNguyenLieu_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_TonKhoNguyenLieu_NguyenLieu FOREIGN KEY (MaNguyenLieu) REFERENCES dbo.NguyenLieu(MaNguyenLieu),
    CONSTRAINT CHK_TonKhoNguyenLieu_SoLuong CHECK (SoLuongTon >= 0 AND MucCanhBao >= 0 AND SoLuongDaDat >= 0)
);
GO

CREATE TABLE dbo.CongThucPhaChe
(
    MaCongThuc      CHAR(10)        NOT NULL,
    MaBienThe       CHAR(10)        NOT NULL,
    MaNguyenLieu    CHAR(10)        NOT NULL,
    SoLuongSuDung   DECIMAL(18,2)   NOT NULL,
    CONSTRAINT PK_CongThucPhaChe PRIMARY KEY (MaCongThuc, MaNguyenLieu),
    CONSTRAINT FK_CongThucPhaChe_BienThe FOREIGN KEY (MaBienThe) REFERENCES dbo.BienTheSanPham(MaBienThe),
    CONSTRAINT FK_CongThucPhaChe_NguyenLieu FOREIGN KEY (MaNguyenLieu) REFERENCES dbo.NguyenLieu(MaNguyenLieu),
    CONSTRAINT CHK_CongThucPhaChe_SoLuong CHECK (SoLuongSuDung > 0)
);
GO

CREATE TABLE dbo.LichSuKho
(
    LogID           CHAR(10)        NOT NULL,
    MaChiNhanh      CHAR(10)        NOT NULL,
    MaNguyenLieu    CHAR(10)        NOT NULL,
    LoaiGiaoDich    NVARCHAR(20)    NOT NULL,
    SoLuong         DECIMAL(18,2)   NOT NULL,
    ThoiGian        DATETIME2(0)    NOT NULL CONSTRAINT DF_LichSuKho_ThoiGian DEFAULT SYSDATETIME(),
    GhiChu          NVARCHAR(255)   NULL,
    CONSTRAINT PK_LichSuKho PRIMARY KEY (LogID),
    CONSTRAINT FK_LichSuKho_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_LichSuKho_NguyenLieu FOREIGN KEY (MaNguyenLieu) REFERENCES dbo.NguyenLieu(MaNguyenLieu),
    CONSTRAINT CHK_LichSuKho_Loai CHECK (LoaiGiaoDich IN (N'Nhập', N'Xuất', N'Hao hụt', N'Hết hạn', N'Điều chỉnh')),
    CONSTRAINT CHK_LichSuKho_SoLuong CHECK (SoLuong > 0)
);
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN DƯƠNG GIA BẢO --

/* =============================================================================================================== */
/* ========================= 7. KHÁCH HÀNG - ĐƠN HÀNG ========================= */
-- Trần Dương Gia Bảo code phần này: Bảng khách hàng lưu điểm tích lũy để thu ngân dùng khi thanh toán
CREATE TABLE dbo.KhachHang
(
    MaKH            CHAR(6)         NOT NULL,
    TenKH           NVARCHAR(100)   NOT NULL,
    SoDienThoai     VARCHAR(10)     NOT NULL,
    DiemTichLuy     INT             NOT NULL CONSTRAINT DF_KhachHang_Diem DEFAULT 0,
    CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH),
    CONSTRAINT UQ_KhachHang_SDT UNIQUE (SoDienThoai),
    CONSTRAINT CHK_KhachHang_SDT CHECK (SoDienThoai NOT LIKE '%[^0-9]%' AND LEN(SoDienThoai)=10),
    CONSTRAINT CHK_KhachHang_Diem CHECK (DiemTichLuy >= 0)
);
GO

-- Trần Dương Gia Bảo code phần này: Bảng đơn hàng có tách giảm giá thủ công, điểm sử dụng và điểm cộng
CREATE TABLE dbo.DonHang
(
    MaDH                CHAR(10)        NOT NULL,
    MaChiNhanh          CHAR(10)        NOT NULL,
    MaNV                CHAR(10)        NOT NULL,
    MaKH                CHAR(6)         NULL,
    TongTien            DECIMAL(18,2)   NOT NULL CONSTRAINT DF_DonHang_TongTien DEFAULT 0,
    GiamGia             DECIMAL(18,2)   NOT NULL CONSTRAINT DF_DonHang_GiamGia DEFAULT 0,
    GiamGiaThuCong      DECIMAL(18,2)   NOT NULL CONSTRAINT DF_DonHang_GiamGiaThuCong DEFAULT 0,
    DiemSuDung          INT             NOT NULL CONSTRAINT DF_DonHang_DiemSuDung DEFAULT 0,
    TienGiamTuDiem      DECIMAL(18,2)   NOT NULL CONSTRAINT DF_DonHang_TienGiamTuDiem DEFAULT 0,
    DiemCong            INT             NOT NULL CONSTRAINT DF_DonHang_DiemCong DEFAULT 0,
    PhuongThucThanhToan NVARCHAR(30)    NOT NULL CONSTRAINT DF_DonHang_PTTT DEFAULT N'Tiền mặt',
    TrangThai           NVARCHAR(20)    NOT NULL CONSTRAINT DF_DonHang_TrangThai DEFAULT N'Khởi tạo',
    NgayTao             DATETIME2(0)    NOT NULL CONSTRAINT DF_DonHang_NgayTao DEFAULT SYSDATETIME(),
    CONSTRAINT PK_DonHang PRIMARY KEY (MaDH),
    CONSTRAINT FK_DonHang_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_DonHang_NV FOREIGN KEY (MaNV) REFERENCES dbo.ThongTinNhanVien(MaNV),
    CONSTRAINT FK_DonHang_KH FOREIGN KEY (MaKH) REFERENCES dbo.KhachHang(MaKH),
    CONSTRAINT CHK_DonHang_Tien CHECK (
        TongTien >= 0
        AND GiamGia >= 0
        AND GiamGiaThuCong >= 0
        AND DiemSuDung >= 0
        AND TienGiamTuDiem >= 0
        AND DiemCong >= 0
        AND TienGiamTuDiem = DiemSuDung * 100
        AND TienGiamTuDiem <= 10000
        AND GiamGia = GiamGiaThuCong + TienGiamTuDiem
        AND (
            TrangThai IN (N'Khởi tạo', N'Hủy')
            OR GiamGia <= TongTien
        )
    ),
    CONSTRAINT CHK_DonHang_TrangThai CHECK (TrangThai IN (N'Khởi tạo', N'Hoàn tất', N'Hủy')),
    CONSTRAINT CHK_DonHang_PTTT CHECK (PhuongThucThanhToan IN (N'Tiền mặt', N'Thẻ', N'Chuyển khoản', N'QR', N'Ví điện tử'))
);
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'CHK_DonHang_Tien' AND type = 'C')
BEGIN
    ALTER TABLE dbo.DonHang DROP CONSTRAINT CHK_DonHang_Tien;
END
GO

ALTER TABLE dbo.DonHang ADD CONSTRAINT CHK_DonHang_Tien CHECK (
    -- Tổng tiền sau cùng của hóa đơn tuyệt đối không được là số âm
    TongTien >= 0 
    -- Số tiền chiết khấu giảm giá của Voucher không được nhỏ hơn 0
    AND GiamGia >= 0 
    -- Cho phép số tiền giảm giá lớn hơn tổng tiền khi đơn hàng ở trạng thái nháp (Khởi tạo) hoặc bị Hủy.
    -- Chỉ bắt buộc kiểm tra số tiền giảm giá không vượt quá tổng tiền gốc khi đơn hàng đã chuyển trạng thái Hoàn tất.
    AND (TrangThai = N'Khởi tạo' OR TrangThai = N'Hủy' OR GiamGia <= TongTien)
);
GO

CREATE TABLE dbo.ChiTietDonHang
(
    MaCTDH          CHAR(10)        NOT NULL,
    MaDH            CHAR(10)        NOT NULL,
    MaBienThe       CHAR(10)        NOT NULL,
    SoLuong         INT             NOT NULL,
    DonGia          DECIMAL(18,2)   NOT NULL,
    GhiChu          NVARCHAR(200)   NULL,
    CONSTRAINT PK_ChiTietDonHang PRIMARY KEY (MaCTDH),
    CONSTRAINT FK_ChiTietDonHang_DonHang FOREIGN KEY (MaDH) REFERENCES dbo.DonHang(MaDH),
    CONSTRAINT FK_ChiTietDonHang_BienThe FOREIGN KEY (MaBienThe) REFERENCES dbo.BienTheSanPham(MaBienThe),
    CONSTRAINT UQ_ChiTietDonHang UNIQUE (MaDH, MaBienThe),
    CONSTRAINT CHK_ChiTietDonHang_SoLuong CHECK (SoLuong > 0),
    CONSTRAINT CHK_ChiTietDonHang_DonGia CHECK (DonGia > 0)
);
GO

IF OBJECT_ID('dbo.HanhTrinhDonHang', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.HanhTrinhDonHang;
END
GO

CREATE TABLE dbo.HanhTrinhDonHang
(
    MaHanhTrinh     INT IDENTITY(1,1) NOT NULL,
    MaDH            CHAR(10)          NOT NULL,
    HanhDong        NVARCHAR(255)     NOT NULL,
    NguoiThucHien   NVARCHAR(100)     NOT NULL,
    ThoiGian        DATETIME2(0)      NOT NULL CONSTRAINT DF_HanhTrinhDonHang_ThoiGian DEFAULT SYSDATETIME(),

    CONSTRAINT PK_HanhTrinhDonHang PRIMARY KEY (MaHanhTrinh),
    CONSTRAINT FK_HanhTrinhDonHang_DonHang FOREIGN KEY (MaDH) REFERENCES dbo.DonHang(MaDH)
);
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */
/* ========================= 8. SEQUENCE ========================= */
-- sinh số tự động
CREATE SEQUENCE dbo.SEQ_MaNV START WITH 1 INCREMENT BY 1;
GO
CREATE SEQUENCE dbo.SEQ_MaLich START WITH 1 INCREMENT BY 1;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */
/* ========================= 9. FUNCTION ========================= */
CREATE FUNCTION dbo.fn_SoGioLamViec
(
    @GioVao DATETIME2(0),
    @GioRa  DATETIME2(0)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @KetQua DECIMAL(12,2);
    IF @GioRa < @GioVao
        SET @KetQua = DATEDIFF(MINUTE, @GioVao, DATEADD(DAY, 1, @GioRa)) / 60.0;
    ELSE
        SET @KetQua = DATEDIFF(MINUTE, @GioVao, @GioRa) / 60.0;
    RETURN @KetQua;
END;
GO
/* =============================================================================================================== */

CREATE FUNCTION dbo.fn_TinhTongTienDonHang
(
    @MaDH CHAR(10)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TongTien DECIMAL(18,2);
    SELECT @TongTien = ISNULL(SUM(SoLuong * DonGia), 0)
    FROM dbo.ChiTietDonHang
    WHERE MaDH = @MaDH;
    RETURN ISNULL(@TongTien, 0);
END;
GO

-- Trần Dương Gia Bảo code phần này: Hàm tính điểm cộng từ thành tiền thực thanh toán
CREATE FUNCTION dbo.fn_TinhDiemTichLuyDonHang
(
    @TongSauGiam DECIMAL(18,2)
)
RETURNS INT
AS
BEGIN
    RETURN CASE
        WHEN @TongSauGiam <= 0 THEN 0
        ELSE FLOOR(@TongSauGiam / 10000.0)
    END;
END;
GO

/* ========================= 10. TRIGGER ========================= */
/* =============================================================================================================== */

                                            -- CODE BỞI NGUYỄN THẾ ANH --

/* =============================================================================================================== */
CREATE TRIGGER dbo.TR_HeThongTaiKhoan_NhatKy
ON dbo.HeThongTaiKhoan
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Prefix CHAR(8) = CONVERT(CHAR(8), GETDATE(), 112);
    DECLARE @HanhDong NVARCHAR(100);
    DECLARE @SoLuong INT;

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SELECT @HanhDong = N'Cập nhật tài khoản', @SoLuong = COUNT(*) FROM inserted;
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SELECT @HanhDong = N'Thêm tài khoản', @SoLuong = COUNT(*) FROM inserted;
    ELSE
        SELECT @HanhDong = N'Xóa tài khoản', @SoLuong = COUNT(*) FROM deleted;

    INSERT INTO dbo.DuLieuHeThong(MaDuLieu, MaTK, HanhDong, TenBang, SoLuongTacDong, NoiDung)
    VALUES
    (
        'DL' + RIGHT(@Prefix, 6) + RIGHT('000' + CAST((SELECT COUNT(*) + 1 FROM dbo.DuLieuHeThong) AS VARCHAR(3)), 3),
        NULL,
        @HanhDong,
        N'HeThongTaiKhoan',
        @SoLuong,
        N'Hệ thống ghi nhận thay đổi trên bảng tài khoản'
    );
END;
GO


/* =============================================================================================================== */

                                            -- CODE BỞI NGUYỄN THẾ ANH --

/* =============================================================================================================== */
CREATE TRIGGER dbo.TRG_ChiNhanh_NhatKy
ON dbo.ChiNhanh
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @SoLuong INT;
    DECLARE @HanhDong NVARCHAR(100);

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        SELECT @HanhDong = N'Cập nhật chi nhánh', @SoLuong = COUNT(*) FROM inserted;
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        SELECT @HanhDong = N'Thêm chi nhánh', @SoLuong = COUNT(*) FROM inserted;
    ELSE
        SELECT @HanhDong = N'Xóa chi nhánh', @SoLuong = COUNT(*) FROM deleted;

    INSERT INTO dbo.DuLieuHeThong(MaDuLieu, MaTK, HanhDong, TenBang, SoLuongTacDong, NoiDung)
    VALUES
    (
        'DL' + CONVERT(CHAR(6), GETDATE(), 12) + RIGHT('000' + CAST((SELECT COUNT(*) + 1 FROM dbo.DuLieuHeThong) AS VARCHAR(3)), 3),
        NULL,
        @HanhDong,
        N'ChiNhanh',
        @SoLuong,
        N'Hệ thống ghi nhận thay đổi trên bảng chi nhánh'
    );
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */

CREATE TRIGGER dbo.TRG_ThongTinNhanVien_SetTrangThai
ON dbo.ThongTinNhanVien
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;
    UPDATE nv
    SET TrangThai = CASE WHEN i.NgayNghiViec IS NULL THEN 1 ELSE 0 END
    FROM dbo.ThongTinNhanVien nv
    JOIN inserted i ON nv.MaNV = i.MaNV;
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */
CREATE TRIGGER dbo.TRG_LichPhanCong_Validate
ON dbo.LichPhanCong
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.ThongTinNhanVien nv ON i.MaNV = nv.MaNV
        WHERE nv.TrangThai = 0
    )
    BEGIN
        RAISERROR(N'Không thể phân ca cho nhân viên đã nghỉ việc.', 16, 1);
    END;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.ThongTinNhanVien nv ON i.MaNV = nv.MaNV
        WHERE i.NgayLamViec < nv.NgayVaoLam
    )
    BEGIN
        RAISERROR(N'Ngày làm việc phải lớn hơn hoặc bằng ngày vào làm.', 16, 1);
    END;
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */
CREATE OR ALTER TRIGGER dbo.TRG_ChamCong_XuLy
ON dbo.ChamCong
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;

    -- Có INSERT hoặc UPDATE
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        -- Không cho chấm công với ca bị hủy hoặc nghỉ phép
        IF EXISTS
        (
            SELECT 1
            FROM inserted i
            INNER JOIN dbo.LichPhanCong l
                ON i.MaLich = l.MaLich
            WHERE l.TrangThai IN (N'Hủy ca', N'Nghỉ phép')
        )
        BEGIN
            RAISERROR(N'Không thể chấm công cho ca hủy hoặc nghỉ phép.', 16, 1);
        END;

        ;WITH DuLieuXuLy AS
        (
            SELECT
                cc.MaChamCong,
                cc.MaNV,
                cc.GioVao,
                cc.GioRa,
                ca.HeSoCa,
                ISNULL(ndb.HeSoLuong, 1.0) AS HeSoNgay,
                cv.LuongCoBanGio,

                -- Ghép ngày làm việc + giờ bắt đầu ca
                DATEADD(
                    SECOND,
                    DATEDIFF(SECOND, CAST('00:00:00' AS time), ca.GioBatDau),
                    CAST(l.NgayLamViec AS datetime2)
                ) AS ThoiDiemBatDauCa,

                -- Ghép ngày làm việc + giờ kết thúc ca
                CASE
                    WHEN ca.GioKetThuc <= ca.GioBatDau THEN
                        DATEADD(
                            DAY, 1,
                            DATEADD(
                                SECOND,
                                DATEDIFF(SECOND, CAST('00:00:00' AS time), ca.GioKetThuc),
                                CAST(l.NgayLamViec AS datetime2)
                            )
                        )
                    ELSE
                        DATEADD(
                            SECOND,
                            DATEDIFF(SECOND, CAST('00:00:00' AS time), ca.GioKetThuc),
                            CAST(l.NgayLamViec AS datetime2)
                        )
                END AS ThoiDiemKetThucCa
            FROM dbo.ChamCong cc
            INNER JOIN inserted i
                ON cc.MaChamCong = i.MaChamCong
            INNER JOIN dbo.LichPhanCong l
                ON cc.MaLich = l.MaLich
            INNER JOIN dbo.CaLamViec ca
                ON l.MaCa = ca.MaCa
            INNER JOIN dbo.ThongTinNhanVien nv
                ON cc.MaNV = nv.MaNV
            INNER JOIN dbo.ChucVuNhanVien cv
                ON nv.MaChucVu = cv.MaChucVu
            LEFT JOIN dbo.NgayDacBiet ndb
                ON l.NgayLamViec = ndb.Ngay
        )
        UPDATE cc
        SET
            TrangThai =
                CASE
                    WHEN dx.GioVao > DATEADD(MINUTE, 10, dx.ThoiDiemBatDauCa) THEN N'Đi muộn'
                    WHEN dx.GioRa  < DATEADD(MINUTE, -10, dx.ThoiDiemKetThucCa) THEN N'Về sớm'
                    ELSE N'Hợp lệ'
                END,
            HeSoNgay = dx.HeSoNgay,
            HeSoCa = dx.HeSoCa,
            LuongThucTe =
                dbo.fn_SoGioLamViec(dx.GioVao, dx.GioRa)
                * dx.LuongCoBanGio
                * dx.HeSoCa
                * dx.HeSoNgay
        FROM dbo.ChamCong cc
        INNER JOIN DuLieuXuLy dx
            ON cc.MaChamCong = dx.MaChamCong;

        -- Xóa phạt cũ của các bản ghi vừa insert/update
        DELETE FROM dbo.PhatDiMuon
        WHERE MaChamCong IN (SELECT MaChamCong FROM inserted);

        -- Thêm phạt đi muộn mới
        INSERT INTO dbo.PhatDiMuon (MaChamCong, MaNV, SoTien, NgayPhat)
        SELECT
            cc.MaChamCong,
            cc.MaNV,
            30000,
            CAST(cc.GioVao AS date)
        FROM dbo.ChamCong cc
        WHERE cc.MaChamCong IN (SELECT MaChamCong FROM inserted)
          AND cc.TrangThai = N'Đi muộn';
    END;

    -- Chỉ DELETE
    IF EXISTS (SELECT 1 FROM deleted)
       AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        DELETE FROM dbo.PhatDiMuon
        WHERE MaChamCong IN (SELECT MaChamCong FROM deleted);
    END;
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */
CREATE TRIGGER dbo.TRG_BangLuong_KhoaDuLieu
ON dbo.BangLuong
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.BangLuong bl ON i.MaNV = bl.MaNV AND i.Thang = bl.Thang AND i.Nam = bl.Nam
        WHERE bl.TrangThai = N'Đã thanh toán'
    )
    BEGIN
        RAISERROR(N'Bảng lương đã thanh toán thì không được phép chỉnh sửa.', 16, 1);
    END;

    UPDATE bl
    SET bl.TongGioThucTe = i.TongGioThucTe,
        bl.TongLuongCa = i.TongLuongCa,
        bl.TongThuong = i.TongThuong,
        bl.TongKhauTru = i.TongKhauTru,
        bl.TrangThai = i.TrangThai
    FROM dbo.BangLuong bl
    JOIN inserted i ON bl.MaNV = i.MaNV AND bl.Thang = i.Thang AND bl.Nam = i.Nam;
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI NGUYỄN NGỌC CHÂU --

/* =============================================================================================================== */
CREATE TRIGGER dbo.TRG_SanPham_DongBoTrangThaiChiNhanh
ON dbo.SanPham
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(TrangThai)
    BEGIN
        -- Đồng bộ trạng thái sang SanPham_ChiNhanh
        UPDATE spcn
        SET spcn.TrangThai = i.TrangThai
        FROM dbo.SanPham_ChiNhanh spcn
        JOIN inserted i ON spcn.MaSanPham = i.MaSanPham;
        
        -- Đồng bộ trạng thái sang BienTheSanPham
        UPDATE bt
        SET bt.TrangThai = i.TrangThai
        FROM dbo.BienTheSanPham bt
        JOIN inserted i ON bt.MaSanPham = i.MaSanPham;
    END;
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI LÊ QUANG BẢO --

/* =============================================================================================================== */
CREATE TRIGGER dbo.TRG_LichSuKho_CapNhatTon
ON dbo.LichSuKho
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.TonKhoNguyenLieu tk
          ON tk.MaChiNhanh = i.MaChiNhanh
         AND tk.MaNguyenLieu = i.MaNguyenLieu
        WHERE i.LoaiGiaoDich IN (N'Xuất', N'Hao hụt', N'Hết hạn', N'Điều chỉnh')
          AND tk.SoLuongTon < i.SoLuong
    )
    BEGIN
        RAISERROR(N'Số lượng tồn kho không đủ để thực hiện giao dịch xuất/trừ.', 16, 1);
    END;

    UPDATE tk
    SET tk.SoLuongTon = tk.SoLuongTon + CASE WHEN i.LoaiGiaoDich = N'Nhập' THEN i.SoLuong ELSE -i.SoLuong END
    FROM dbo.TonKhoNguyenLieu tk
    JOIN inserted i
      ON tk.MaChiNhanh = i.MaChiNhanh
     AND tk.MaNguyenLieu = i.MaNguyenLieu;
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN DƯƠNG GIA BẢO --

/* =============================================================================================================== */

CREATE TRIGGER dbo.TRG_ChiTietDonHang_CapNhatTongTien
ON dbo.ChiTietDonHang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH X AS
    (
        SELECT MaDH FROM inserted
        UNION
        SELECT MaDH FROM deleted
    )
    UPDATE dh
    SET TongTien = dbo.fn_TinhTongTienDonHang(dh.MaDH)
    FROM dbo.DonHang dh
    JOIN X ON dh.MaDH = X.MaDH;
END;
GO


/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN DƯƠNG GIA BẢO --

/* =============================================================================================================== */
-- Trần Dương Gia Bảo code phần này: Trigger tự động cập nhật điểm tích lũy khi đơn hàng hoàn tất
CREATE TRIGGER dbo.TRG_DonHang_CapNhatDiem
ON dbo.DonHang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Cu AS
    (
        SELECT
            MaKH,
            SUM(DiemCong) AS DiemCong,
            SUM(DiemSuDung) AS DiemSuDung
        FROM deleted
        WHERE MaKH IS NOT NULL
          AND TrangThai = N'Hoàn tất'
        GROUP BY MaKH
    ),
    Moi AS
    (
        SELECT
            MaKH,
            SUM(DiemCong) AS DiemCong,
            SUM(DiemSuDung) AS DiemSuDung
        FROM inserted
        WHERE MaKH IS NOT NULL
          AND TrangThai = N'Hoàn tất'
        GROUP BY MaKH
    ),
    BienDong AS
    (
        SELECT
            MaKH,
            -DiemCong + DiemSuDung AS Delta
        FROM Cu

        UNION ALL

        SELECT
            MaKH,
            DiemCong - DiemSuDung AS Delta
        FROM Moi
    ),
    TongHop AS
    (
        SELECT
            MaKH,
            SUM(Delta) AS Delta
        FROM BienDong
        GROUP BY MaKH
    )
    UPDATE kh
    SET kh.DiemTichLuy =
        CASE
            WHEN kh.DiemTichLuy + th.Delta < 0 THEN 0
            ELSE kh.DiemTichLuy + th.Delta
        END
    FROM dbo.KhachHang kh
    JOIN TongHop th ON kh.MaKH = th.MaKH;
END;
GO

/* =============================================================================================================== */
CREATE TRIGGER dbo.TRG_SanPham_TuDongDongBoChiNhanh
ON dbo.SanPham
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SanPham_ChiNhanh (MaChiNhanh, MaSanPham, GiaBan, TrangThai)
    SELECT
        cn.MaChiNhanh,
        i.MaSanPham,
        i.GiaCoBan,
        i.TrangThai
    FROM inserted i
    CROSS JOIN dbo.ChiNhanh cn
    WHERE cn.TrangThai = 1
      AND i.TrangThai = 1
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.SanPham_ChiNhanh spcn
          WHERE spcn.MaChiNhanh = cn.MaChiNhanh
            AND spcn.MaSanPham = i.MaSanPham
      );
END;
GO

/* ========================= 11. PROCEDURE - TRANSACTION - CURSOR ========================= */
/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */
CREATE PROCEDURE dbo.sp_KhoiTaoBangLuong
    @Thang INT,
    @Nam INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.BangLuong(MaNV, Thang, Nam)
    SELECT
        nv.MaNV,
        @Thang,
        @Nam
    FROM dbo.ThongTinNhanVien nv
    WHERE nv.TrangThai = 1
      AND NOT EXISTS (
            SELECT 1
            FROM dbo.BangLuong bl
            WHERE bl.MaNV = nv.MaNV AND bl.Thang = @Thang AND bl.Nam = @Nam
      );

    UPDATE bl
    SET bl.TongGioThucTe = ISNULL(cc.Gio, 0),
        bl.TongLuongCa = ISNULL(cc.Luong, 0),
        bl.TongKhauTru = ISNULL(pd.Phat, 0)
    FROM dbo.BangLuong bl
    OUTER APPLY (
        SELECT SUM(dbo.fn_SoGioLamViec(GioVao, GioRa)) AS Gio,
               SUM(LuongThucTe) AS Luong
        FROM dbo.ChamCong
        WHERE MaNV = bl.MaNV
          AND MONTH(GioVao) = @Thang
          AND YEAR(GioVao) = @Nam
    ) cc
    OUTER APPLY (
        SELECT SUM(SoTien) AS Phat
        FROM dbo.PhatDiMuon
        WHERE MaNV = bl.MaNV
          AND MONTH(NgayPhat) = @Thang
          AND YEAR(NgayPhat) = @Nam
    ) pd
    WHERE bl.Thang = @Thang AND bl.Nam = @Nam;
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI LÊ QUANG BẢO --

/* =============================================================================================================== */
CREATE PROCEDURE dbo.sp_GhiNhanGiaoDichKho
    @LogID CHAR(10),
    @MaChiNhanh CHAR(10),
    @MaNguyenLieu CHAR(10),
    @LoaiGiaoDich NVARCHAR(20),
    @SoLuong DECIMAL(18,2),
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (
            SELECT 1 FROM dbo.TonKhoNguyenLieu
            WHERE MaChiNhanh = @MaChiNhanh AND MaNguyenLieu = @MaNguyenLieu
        )
        BEGIN
            RAISERROR(N'Chưa khởi tạo tồn kho cho chi nhánh và nguyên liệu này.', 16, 1);
        END;

        INSERT INTO dbo.LichSuKho(LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong, GhiChu)
        VALUES (@LogID, @MaChiNhanh, @MaNguyenLieu, @LoaiGiaoDich, @SoLuong, @GhiChu);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT; SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY(), @ErrState = ERROR_STATE(); RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN DƯƠNG GIA BẢO --

/* =============================================================================================================== */
CREATE PROCEDURE dbo.sp_TaoDonHang
    @MaDH CHAR(10),
    @MaChiNhanh CHAR(10),
    @MaNV CHAR(10),
    @MaKH CHAR(6) = NULL,
    @PhuongThucThanhToan NVARCHAR(30) = N'Tiền mặt',
    @GiamGiaThuCong DECIMAL(18,2) = 0,
    @DiemSuDung INT = 0,
    @NguoiThucHien NVARCHAR(100) = NULL,
    @ChiTiet dbo.TVP_ChiTietDonHang READONLY
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        SET @MaKH = NULLIF(LTRIM(RTRIM(@MaKH)), '');
        SET @NguoiThucHien = ISNULL(NULLIF(LTRIM(RTRIM(@NguoiThucHien)), N''), N'Hệ thống');

        IF NOT EXISTS (SELECT 1 FROM @ChiTiet)
        BEGIN
            RAISERROR(N'Vui lòng thêm ít nhất một sản phẩm.', 16, 1);
        END;

        IF EXISTS (SELECT 1 FROM @ChiTiet WHERE SoLuong <= 0)
        BEGIN
            RAISERROR(N'Số lượng không hợp lệ.', 16, 1);
        END;

        IF @GiamGiaThuCong < 0 OR @DiemSuDung < 0
        BEGIN
            RAISERROR(N'Giảm giá thủ công và điểm sử dụng phải lớn hơn hoặc bằng 0.', 16, 1);
        END;

        IF @MaKH IS NULL AND @DiemSuDung > 0
        BEGIN
            RAISERROR(N'Khách vãng lai không được sử dụng điểm.', 16, 1);
        END;

        DECLARE @DiemHienCo INT = NULL;

        IF @MaKH IS NOT NULL
        BEGIN
            SELECT @DiemHienCo = DiemTichLuy
            FROM dbo.KhachHang
            WHERE MaKH = @MaKH;

            IF @DiemHienCo IS NULL
            BEGIN
                RAISERROR(N'Khách hàng không tồn tại.', 16, 1);
            END;

            IF @DiemSuDung > @DiemHienCo
            BEGIN
                RAISERROR(N'Số điểm sử dụng không được vượt quá điểm hiện có.', 16, 1);
            END;
        END;

        IF EXISTS (
            SELECT 1
            FROM (
                SELECT MaBienThe, SUM(SoLuong) AS SoLuong
                FROM @ChiTiet
                GROUP BY MaBienThe
            ) ct
            WHERE NOT EXISTS (
                SELECT 1
                FROM dbo.BienTheSanPham bt
                JOIN dbo.SanPham sp ON bt.MaSanPham = sp.MaSanPham
                JOIN dbo.SanPham_ChiNhanh spcn ON spcn.MaSanPham = sp.MaSanPham
                WHERE bt.MaBienThe = ct.MaBienThe
                  AND spcn.MaChiNhanh = @MaChiNhanh
                  AND bt.TrangThai = 1
                  AND sp.TrangThai = 1
                  AND spcn.TrangThai = 1
                  AND spcn.GiaBan + bt.GiaCongThem > 0
            )
        )
        BEGIN
            RAISERROR(N'Sản phẩm không tồn tại, ngừng bán hoặc không bán tại chi nhánh này.', 16, 1);
        END;

        INSERT INTO dbo.DonHang
        (
            MaDH, MaChiNhanh, MaNV, MaKH,
            TongTien, GiamGiaThuCong, DiemSuDung, TienGiamTuDiem, GiamGia, DiemCong,
            PhuongThucThanhToan, TrangThai, NgayTao
        )
        VALUES
        (
            @MaDH, @MaChiNhanh, @MaNV, @MaKH,
            0, 0, 0, 0, 0, 0,
            @PhuongThucThanhToan, N'Khởi tạo', SYSDATETIME()
        );

        INSERT INTO dbo.HanhTrinhDonHang(MaDH, HanhDong, NguoiThucHien)
        VALUES (@MaDH, N'Khởi tạo đơn hàng mới', @NguoiThucHien);

        DECLARE @NextCTNumber INT;
        SELECT @NextCTNumber = ISNULL(MAX(TRY_CONVERT(INT, SUBSTRING(MaCTDH, 3, 8))), 0) + 1
        FROM dbo.ChiTietDonHang
        WHERE MaCTDH LIKE 'CT%';

        ;WITH ChiTietGom AS
        (
            SELECT MaBienThe, SUM(SoLuong) AS SoLuong
            FROM @ChiTiet
            GROUP BY MaBienThe
        ),
        ChiTietTinhGia AS
        (
            SELECT
                ct.MaBienThe,
                ct.SoLuong,
                sp.TenSanPham,
                bt.Size,
                spcn.GiaBan + bt.GiaCongThem AS DonGia,
                ROW_NUMBER() OVER (ORDER BY ct.MaBienThe) AS RowIndex
            FROM ChiTietGom ct
            JOIN dbo.BienTheSanPham bt ON bt.MaBienThe = ct.MaBienThe
            JOIN dbo.SanPham sp ON sp.MaSanPham = bt.MaSanPham
            JOIN dbo.SanPham_ChiNhanh spcn ON spcn.MaSanPham = sp.MaSanPham
            WHERE spcn.MaChiNhanh = @MaChiNhanh
              AND bt.TrangThai = 1
              AND sp.TrangThai = 1
              AND spcn.TrangThai = 1
        )
        INSERT INTO dbo.ChiTietDonHang(MaCTDH, MaDH, MaBienThe, SoLuong, DonGia)
        SELECT
            'CT' + RIGHT('00000000' + CAST(@NextCTNumber + RowIndex - 1 AS VARCHAR(8)), 8),
            @MaDH,
            MaBienThe,
            SoLuong,
            DonGia
        FROM ChiTietTinhGia;

        ;WITH ChiTietGom AS
        (
            SELECT MaBienThe, SUM(SoLuong) AS SoLuong
            FROM @ChiTiet
            GROUP BY MaBienThe
        )
        INSERT INTO dbo.HanhTrinhDonHang(MaDH, HanhDong, NguoiThucHien)
        SELECT
            @MaDH,
            N'Thêm món: ' + sp.TenSanPham + N' (Size ' + bt.Size + N'), Số lượng: '
                + CAST(ct.SoLuong AS NVARCHAR(20)) + N', Đơn giá: '
                + CAST(CAST(spcn.GiaBan + bt.GiaCongThem AS DECIMAL(18,0)) AS NVARCHAR(30)) + N' đ',
            @NguoiThucHien
        FROM ChiTietGom ct
        JOIN dbo.BienTheSanPham bt ON bt.MaBienThe = ct.MaBienThe
        JOIN dbo.SanPham sp ON sp.MaSanPham = bt.MaSanPham
        JOIN dbo.SanPham_ChiNhanh spcn ON spcn.MaSanPham = sp.MaSanPham
        WHERE spcn.MaChiNhanh = @MaChiNhanh;

        DECLARE @TongTien DECIMAL(18,2) = dbo.fn_TinhTongTienDonHang(@MaDH);

        IF @TongTien <= 0
        BEGIN
            RAISERROR(N'Không thể xác định đơn giá sản phẩm.', 16, 1);
        END;

        DECLARE @TienGiamTuDiem DECIMAL(18,2) = @DiemSuDung * 100;
        DECLARE @TongGiamGia DECIMAL(18,2) = @GiamGiaThuCong + @TienGiamTuDiem;

        IF @TienGiamTuDiem > 10000
        BEGIN
            RAISERROR(N'Tiền giảm từ điểm tối đa là 10.000đ cho mỗi đơn hàng.', 16, 1);
        END;

        IF @TongGiamGia > @TongTien
        BEGIN
            RAISERROR(N'Tổng giảm giá không được vượt quá tổng tiền đơn hàng.', 16, 1);
        END;

        DECLARE @ThanhTien DECIMAL(18,2) = @TongTien - @TongGiamGia;
        DECLARE @DiemCong INT = CASE
            WHEN @MaKH IS NULL THEN 0
            ELSE dbo.fn_TinhDiemTichLuyDonHang(@ThanhTien)
        END;

        UPDATE dbo.DonHang
        SET TongTien = @TongTien,
            GiamGiaThuCong = @GiamGiaThuCong,
            DiemSuDung = @DiemSuDung,
            TienGiamTuDiem = @TienGiamTuDiem,
            GiamGia = @TongGiamGia,
            DiemCong = @DiemCong,
            TrangThai = N'Hoàn tất'
        WHERE MaDH = @MaDH;

        INSERT INTO dbo.HanhTrinhDonHang(MaDH, HanhDong, NguoiThucHien)
        VALUES
        (
            @MaDH,
            N'Thanh toán hoàn tất. Dùng ' + CAST(@DiemSuDung AS NVARCHAR(20))
                + N' điểm, giảm ' + CAST(CAST(@TienGiamTuDiem AS DECIMAL(18,0)) AS NVARCHAR(30))
                + N' đ từ điểm, cộng ' + CAST(@DiemCong AS NVARCHAR(20)) + N' điểm.',
            @NguoiThucHien
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT, @ErrState INT; SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY(), @ErrState = ERROR_STATE(); RAISERROR(@ErrMsg, @ErrSeverity, @ErrState);
    END CATCH
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI LÊ QUANG BẢO --

/* =============================================================================================================== */
CREATE PROCEDURE dbo.sp_CanhBaoTonKho
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaChiNhanh CHAR(10),
            @MaNguyenLieu CHAR(10),
            @SoLuongTon DECIMAL(18,2),
            @MucCanhBao DECIMAL(18,2);

    DECLARE cur_canhbao CURSOR FOR
        SELECT MaChiNhanh, MaNguyenLieu, SoLuongTon, MucCanhBao
        FROM dbo.TonKhoNguyenLieu
        WHERE SoLuongTon <= MucCanhBao;

    OPEN cur_canhbao;
    FETCH NEXT FROM cur_canhbao INTO @MaChiNhanh, @MaNguyenLieu, @SoLuongTon, @MucCanhBao;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.DuLieuHeThong
            WHERE HanhDong = N'Cảnh báo tồn kho'
              AND TenBang = N'TonKhoNguyenLieu'
              AND NoiDung LIKE N'Chi nhánh ' + @MaChiNhanh + N' - nguyên liệu ' + @MaNguyenLieu + N'%'
              AND CONVERT(DATE, ThoiGian) = CONVERT(DATE, SYSDATETIME())
        )
        BEGIN
            INSERT INTO dbo.DuLieuHeThong(MaDuLieu, MaTK, HanhDong, TenBang, SoLuongTacDong, NoiDung)
            VALUES
            (
                'DL' + RIGHT(CONVERT(CHAR(8), GETDATE(), 112), 6) + RIGHT('000' + CAST((SELECT COUNT(*) + 1 FROM dbo.DuLieuHeThong) AS VARCHAR(3)), 3),
                NULL,
                N'Cảnh báo tồn kho',
                N'TonKhoNguyenLieu',
                1,
                N'Chi nhánh ' + @MaChiNhanh + N' - nguyên liệu ' + @MaNguyenLieu + N' có tồn kho ' + CAST(@SoLuongTon AS NVARCHAR(30)) + N' thấp hơn hoặc bằng mức cảnh báo ' + CAST(@MucCanhBao AS NVARCHAR(30))
            );
        END;

        FETCH NEXT FROM cur_canhbao INTO @MaChiNhanh, @MaNguyenLieu, @SoLuongTon, @MucCanhBao;
    END;

    CLOSE cur_canhbao;
    DEALLOCATE cur_canhbao;
END;
GO

/* =============================================================================================================== */
/*CODE BỞI NGUYỄN NGỌC CHÂU*/
CREATE PROCEDURE dbo.sp_DongBoSanPhamVaoChiNhanh
    @MaSanPham CHAR(10),
    @GiaBanMacDinh DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.SanPham WHERE MaSanPham = @MaSanPham)
    BEGIN
        RAISERROR(N'Sản phẩm không tồn tại.', 16, 1);
    END;

    SELECT @GiaBanMacDinh = ISNULL(@GiaBanMacDinh, GiaCoBan)
    FROM dbo.SanPham
    WHERE MaSanPham = @MaSanPham;

    IF @GiaBanMacDinh IS NULL OR @GiaBanMacDinh <= 0
    BEGIN
        RAISERROR(N'Giá bán mặc định không hợp lệ.', 16, 1);
    END;

    INSERT INTO dbo.SanPham_ChiNhanh (MaChiNhanh, MaSanPham, GiaBan, TrangThai)
    SELECT
        cn.MaChiNhanh,
        sp.MaSanPham,
        @GiaBanMacDinh,
        sp.TrangThai
    FROM dbo.SanPham sp
    CROSS JOIN dbo.ChiNhanh cn
    WHERE sp.MaSanPham = @MaSanPham
      AND sp.TrangThai = 1
      AND cn.TrangThai = 1
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.SanPham_ChiNhanh spcn
          WHERE spcn.MaChiNhanh = cn.MaChiNhanh
            AND spcn.MaSanPham = sp.MaSanPham
      );
END;
GO


/*CODE BỞI NGUYỄN NGỌC CHÂU*/
CREATE PROCEDURE dbo.sp_DongBoTatCaSanPham
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SanPham_ChiNhanh (MaChiNhanh, MaSanPham, GiaBan, TrangThai)
    SELECT
        cn.MaChiNhanh,
        sp.MaSanPham,
        sp.GiaCoBan,
        1
    FROM dbo.ChiNhanh cn
    CROSS JOIN dbo.SanPham sp
    WHERE cn.TrangThai = 1
      AND sp.TrangThai = 1
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.SanPham_ChiNhanh spcn
          WHERE spcn.MaChiNhanh = cn.MaChiNhanh
            AND spcn.MaSanPham = sp.MaSanPham
      );
END;
GO
/* =============================================================================================================== */

/* ========================= 12. VIEW BÁO CÁO ========================= */
/* =============================================================================================================== */

                                            -- CODE BỞI NGUYỄN THẾ ANH --

/* =============================================================================================================== */
CREATE VIEW dbo.vw_MenuChiNhanh
AS
SELECT
    cn.MaChiNhanh,
    cn.TenChiNhanh,
    dm.TenDanhMuc,
    sp.MaSanPham,
    sp.TenSanPham,
    bt.MaBienThe,
    bt.Size,
    spcn.GiaBan + bt.GiaCongThem AS GiaBanThucTe,
    spcn.TrangThai AS TrangThaiMenu
FROM dbo.SanPham_ChiNhanh spcn
JOIN dbo.ChiNhanh cn ON spcn.MaChiNhanh = cn.MaChiNhanh
JOIN dbo.SanPham sp ON spcn.MaSanPham = sp.MaSanPham
JOIN dbo.DanhMuc dm ON sp.MaDanhMuc = dm.MaDanhMuc
JOIN dbo.BienTheSanPham bt ON sp.MaSanPham = bt.MaSanPham
WHERE cn.TrangThai = 1
  AND sp.TrangThai = 1
  AND bt.TrangThai = 1
  AND spcn.TrangThai = 1;
GO


/* =============================================================================================================== */

                                            -- CODE BỞI LÊ QUANG BẢO --

/* =============================================================================================================== */
CREATE VIEW dbo.vw_CanhBaoTonKho
AS
SELECT
    tk.MaChiNhanh,
    cn.TenChiNhanh,
    tk.MaNguyenLieu,
    nl.TenNguyenLieu,
    nl.DonViTinh,
    tk.SoLuongTon,
    tk.MucCanhBao,
    CASE WHEN tk.SoLuongTon <= tk.MucCanhBao THEN N'Cần nhập thêm' ELSE N'Bình thường' END AS MucDo
FROM dbo.TonKhoNguyenLieu tk
JOIN dbo.ChiNhanh cn ON tk.MaChiNhanh = cn.MaChiNhanh
JOIN dbo.NguyenLieu nl ON tk.MaNguyenLieu = nl.MaNguyenLieu;
GO

CREATE VIEW dbo.vw_BangLuongTongHop
AS
SELECT
    bl.MaNV,
    nv.HoTenNV,
    nv.MaChiNhanh,
    cn.TenChiNhanh,
    bl.Thang,
    bl.Nam,
    bl.TongGioThucTe,
    bl.TongLuongCa,
    bl.TongThuong,
    bl.TongKhauTru,
    bl.ThucLanh,
    bl.TrangThai
FROM dbo.BangLuong bl
JOIN dbo.ThongTinNhanVien nv ON bl.MaNV = nv.MaNV
JOIN dbo.ChiNhanh cn ON nv.MaChiNhanh = cn.MaChiNhanh;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */
/* ========================= 13. DỮ LIỆU MẪU ========================= */
SET NOCOUNT ON;
GO
SET DATEFORMAT ymd;
GO

INSERT INTO dbo.HeThongTaiKhoan (MaTK, TenDangNhap, MatKhauHash, VaiTro, TrangThai, NgayTao) VALUES
    ('TK00000051', 'trangiabao', 'sha256$96cae35ce8a9b0244178bf28e4966c2ce1b8385723a96a6b838858cdd6ca0a1e', 'ADMIN', 1, '2025-02-03T09:16:00'),
    ('TK00000052', 'lequangbao', 'sha256$96cae35ce8a9b0244178bf28e4966c2ce1b8385723a96a6b838858cdd6ca0a1e', 'QUAN_LY', 1, '2025-02-03T09:16:00'),
    ('TK00000053', 'tranduonggiabao', 'sha256$96cae35ce8a9b0244178bf28e4966c2ce1b8385723a96a6b838858cdd6ca0a1e', 'NHAN_VIEN', 1, '2025-02-03T09:16:00'),
    ('TK00000054', 'nguyenngocchau', 'sha256$96cae35ce8a9b0244178bf28e4966c2ce1b8385723a96a6b838858cdd6ca0a1e', 'KE_TOAN', 1, '2025-02-03T09:16:00'),
    ('TK00000055', 'nguyentheanh', 'sha256$96cae35ce8a9b0244178bf28e4966c2ce1b8385723a96a6b838858cdd6ca0a1e', 'KHO', 1, '2025-02-03T09:16:00')
GO

INSERT INTO dbo.HeThongTaiKhoan (MaTK, TenDangNhap, MatKhauHash, VaiTro, TrangThai, NgayTao) VALUES
    ('TK00000001', 'tranvankhang01', 'sha256$448176ba3443a00748d965d5438aabc6fc74bea1d9cecbc68e09a581a0b06ce2', 'NHAN_VIEN', 1, '2025-02-03T09:16:00'),
    ('TK00000002', 'tranphuonghien02', 'sha256$19c3af858673072b03988adef7c98fd42bd9b3582a25493aaf0d2f023b3a32d6', 'NHAN_VIEN', 1, '2025-03-05T10:17:00'),
    ('TK00000003', 'hoanganhduc03', 'sha256$654bf56f477c9b408587c1bba620efa84f6b763820c0ef631e02c5c7a0c86f42', 'NHAN_VIEN', 1, '2025-04-07T11:18:00'),
    ('TK00000004', 'dangthanhthao04', 'sha256$312ab9e47e689925b5ffb8100a07adbde7437ad1f8192ac009da84db59d49484', 'NHAN_VIEN', 1, '2025-05-09T12:19:00'),
    ('TK00000005', 'buianhhieu05', 'sha256$27ea0ee1c09c6993dfe5da9f1db5c1a7dd1fae85ca27913965d161111d481218', 'NHAN_VIEN', 1, '2025-06-11T13:20:00'),
    ('TK00000006', 'ngokhanhngan06', 'sha256$539c508cffdc342ed52d688a5a19594e93ed2d6da3dfadec20edc586c83afe68', 'NHAN_VIEN', 1, '2025-07-13T14:21:00'),
    ('TK00000007', 'phamhuucuong07', 'sha256$10ea54756ed4e43006ea7758dc6831c430180c7fdbc91c3992d51da872207849', 'NHAN_VIEN', 1, '2025-08-15T15:22:00'),
    ('TK00000008', 'domaimai08', 'sha256$ed775e3146a91e8b0039d04b183f6cfadd5473eece7f6dbeff7b087489f6079f', 'NHAN_VIEN', 1, '2025-09-17T16:23:00'),
    ('TK00000009', 'phanthanhnam09', 'sha256$00cbc1c63663b1946632e52bd437f34f68a86eb800a5f5503821f80059639855', 'NHAN_VIEN', 1, '2025-10-19T08:24:00'),
    ('TK00000010', 'duongthivy10', 'sha256$edbaa900abbac2c29210630aade248e4f6b348c7fc751c742ea79ed3cb3cd267', 'NHAN_VIEN', 1, '2025-01-21T09:25:00');

GO
INSERT INTO dbo.HeThongTaiKhoan (MaTK, TenDangNhap, MatKhauHash, VaiTro, TrangThai, NgayTao) VALUES
    ('TK00000011', 'dohuubao11', 'sha256$34d66bf6ec60ee478dd296a0a8451b93db2f373f510d1e71adc2414aa312a725', 'NHAN_VIEN', 1, '2025-02-23T10:26:00'),
    ('TK00000012', 'phanbaodiem12', 'sha256$f8e14a405ea76347a4508936c3689c6590b3f075b613118fef6d6b8ec0535a54', 'NHAN_VIEN', 1, '2025-03-25T11:27:00'),
    ('TK00000013', 'phamquocduc13', 'sha256$9b31a8f2886e30b6f11a4beb1b18b2aed7a17ddeb685b8d133c1c10954adc9e3', 'NHAN_VIEN', 1, '2025-04-27T12:28:00'),
    ('TK00000014', 'dangkhanhgiang14', 'sha256$36387be27682f4f65f8ce6a7635af2a43d88796265caeb7eeb50e79b178b8863', 'NHAN_VIEN', 0, '2025-05-02T13:29:00'),
    ('TK00000015', 'phanminhhung15', 'sha256$eeb63e867e3071a7ff73a495ae3f4ea0ee51468a3559cd7a306aa91248352d10', 'NHAN_VIEN', 1, '2025-06-04T14:30:00'),
    ('TK00000016', 'vothuchi16', 'sha256$0c5186c0ce917b1fffe2775c9b45bb3cb02cf92c31fc49b1079564ce9207ad0d', 'QUAN_LY', 1, '2025-07-06T15:31:00'),
    ('TK00000017', 'vocongcuong17', 'sha256$a85d4f513d0ed46983390dae3a8257259874c47927e9ed6e3ed2f7b0181ffa57', 'QUAN_LY', 1, '2025-08-08T16:32:00'),
    ('TK00000018', 'nguyenphuongan18', 'sha256$4b745ab9eaa02d23e03339b64d677efaec58cc103b54e79a2818805f57d22586', 'QUAN_LY', 1, '2025-09-10T08:33:00'),
    ('TK00000019', 'tranquocdat19', 'sha256$c0587cd1a8cfac2da154c0d37cb8a3dbf4f379d8f89dbd08c22638b86ace6a90', 'QUAN_LY', 1, '2025-10-12T09:34:00'),
    ('TK00000020', 'phankhanhnhung20', 'sha256$280a194e8c1718d1041975509dd213f7740196155f01e76db2b06f890ffe38da', 'QUAN_LY', 1, '2025-01-14T10:35:00');
GO
INSERT INTO dbo.HeThongTaiKhoan (MaTK, TenDangNhap, MatKhauHash, VaiTro, TrangThai, NgayTao) VALUES
    ('TK00000021', 'phamthanhbao21', 'sha256$dd6986d601889594653ed6094c7dd1baf9e38ed9e35f4cdb29ee3f0f762398dd', 'KHO', 1, '2025-02-16T11:36:00'),
    ('TK00000022', 'lemaian22', 'sha256$39fd169c135c5a6f53f3ac158d1e611dfdfda394d944402120d46f3301e29f9a', 'KHO', 1, '2025-03-18T12:37:00'),
    ('TK00000023', 'phanducnam23', 'sha256$8de0b1858f169894b1ccdfeea5f417acbc4b3408584857d131c99f49034c7dc3', 'KHO', 1, '2025-04-20T13:38:00'),
    ('TK00000024', 'hoangmaiyen24', 'sha256$d3b6607c924655faefb90c9a50aff8badda2d8a91d737409835a7a07553100f0', 'KHO', 1, '2025-05-22T14:39:00'),
    ('TK00000025', 'hocongvinh25', 'sha256$ff1181eb98b20c3e927ed890e186c1fe46e2a82ec27fc1aa7480bfc7bfe607e7', 'KHO', 1, '2025-06-24T15:40:00'),
    ('TK00000026', 'hokhanhgiang26', 'sha256$51ccca742aa13dffbeba14d38a29d85e10c179a0f82fd198659fef9c2428e1e0', 'NHAN_VIEN', 1, '2025-07-26T16:41:00'),
    ('TK00000027', 'phamducduc27', 'sha256$b590934c7829acd12fd75e3208a6593d10dd736caf6fb485e769109c3cb65371', 'NHAN_VIEN', 1, '2025-08-01T08:42:00'),
    ('TK00000028', 'nguyenquynhquynh28', 'sha256$8fc8f33cc43e85358ce549cc490129c1cd0631f6c45714c398a2019a259a7a45', 'NHAN_VIEN', 1, '2025-09-03T09:43:00'),
    ('TK00000029', 'nguyengiabao29', 'sha256$4fd851434e81d787493594cb36bba9adefed0203abe0fb7203174fca6997ebf4', 'NHAN_VIEN', 0, '2025-10-05T10:44:00'),
    ('TK00000030', 'nguyenquynhnhung30', 'sha256$1e1ef47b03ba51f58e7bbc96ef48e65136c9a752deb10c485d7b2a0df1afef21', 'NHAN_VIEN', 1, '2025-01-07T11:45:00');
GO
INSERT INTO dbo.HeThongTaiKhoan (MaTK, TenDangNhap, MatKhauHash, VaiTro, TrangThai, NgayTao) VALUES
    ('TK00000031', 'dangcongdat31', 'sha256$e0c817e6532f4f4928b5effd7243325a3ef1d67ea7ae78caea47e48132612f5b', 'NHAN_VIEN', 1, '2025-02-09T12:46:00'),
    ('TK00000032', 'nguyenphuongchi32', 'sha256$5163191a83e42fec001b4d8497621e8befe7f3cd02d5f073344993318f3aaa08', 'NHAN_VIEN', 1, '2025-03-11T13:47:00'),
    ('TK00000033', 'duongminhbinh33', 'sha256$85c095aca1e1404f79288e839917fdd473299fbc36b599fb99e82b87eb83bb83', 'NHAN_VIEN', 1, '2025-04-13T14:48:00'),
    ('TK00000034', 'buingocvy34', 'sha256$f8cfed76a5db7800859acc8906fd18fb27a43f75e40e4eb8e376c5027cb5e0a2', 'NHAN_VIEN', 1, '2025-05-15T15:49:00'),
    ('TK00000035', 'duongquoclong35', 'sha256$77e1cb7a5c1cfcae0839b7a5ab1dbaa18f00c31ae8a1941bbdb4721432042fbe', 'NHAN_VIEN', 1, '2025-06-17T16:50:00'),
    ('TK00000036', 'tranquynhhien36', 'sha256$30389252d76df83d011b9f82c16d35d87c18685e175e2cf76d44cc5287bd2778', 'NHAN_VIEN', 1, '2025-07-19T08:51:00'),
    ('TK00000037', 'buixuanbao37', 'sha256$2c93bc338e3a8736b7736de64d326f2117589c268b457c7583b8e9f013a13674', 'NHAN_VIEN', 1, '2025-08-21T09:52:00'),
    ('TK00000038', 'buingocngan38', 'sha256$34c23c0e87bbb4402d6a83bd9b81693ba997e4d0bb3ee77f94506abee32315d7', 'NHAN_VIEN', 1, '2025-09-23T10:53:00'),
    ('TK00000039', 'doxuanthanh39', 'sha256$d762a36fba0c7fac299cde8948d06badbfa50654e3097a850547b619bd51b883', 'NHAN_VIEN', 1, '2025-10-25T11:54:00'),
    ('TK00000040', 'dangbaohuong40', 'sha256$4e9faa8256659e80430163c97a24562223a0803bcb4bc860bffe7c534abd55a7', 'NHAN_VIEN', 1, '2025-01-27T12:15:00');
GO
INSERT INTO dbo.HeThongTaiKhoan (MaTK, TenDangNhap, MatKhauHash, VaiTro, TrangThai, NgayTao) VALUES
    ('TK00000041', 'phamgiahieu41', 'sha256$253c28509534b0fc4dcebfb836bf0d46788c702e715fff781363eff338dc5b7c', 'NHAN_VIEN', 1, '2025-02-02T13:16:00'),
    ('TK00000042', 'hoangmaigiang42', 'sha256$5d7f8f5875609abf5a43f0d9b83332c705876eaf951eeb9f3a80c53937874bf6', 'NHAN_VIEN', 1, '2025-03-04T14:17:00'),
    ('TK00000043', 'doducnam43', 'sha256$03b720ccab8c04fec303fbf3b30f1badbba229c37abdc68cc3a5c356940db48c', 'NHAN_VIEN', 1, '2025-04-06T15:18:00'),
    ('TK00000044', 'huynhngocan44', 'sha256$69cadea416f3f7b111f7ccb9bab22a6bf89ff49e8cd14f99055161bda3948274', 'NHAN_VIEN', 1, '2025-05-08T16:19:00'),
    ('TK00000045', 'voxuanthanh45', 'sha256$ef9a35829bd432c53ba00a7714a8398205fac2907f2d1a0da9299e58f6bac61f', 'NHAN_VIEN', 1, '2025-06-10T08:20:00'),
    ('TK00000046', 'tranngocquynh46', 'sha256$b7f24c894963e8e13583573391142607d7dca495df374b0ccc3e6aa4847d2613', 'KE_TOAN', 1, '2025-07-12T09:21:00'),
    ('TK00000047', 'phamconghung47', 'sha256$89ed7511d5f1e113f601861bf71377a13aef8b6eae3b973843b55769588470ed', 'KE_TOAN', 0, '2025-08-14T10:22:00'),
    ('TK00000048', 'lebaochi48', 'sha256$84d1f6d91a05dc6d6470482bd73bc5c72f5c724fc1f0dc44bd8269082a42c4dd', 'KE_TOAN', 1, '2025-09-16T11:23:00'),
    ('TK00000049', 'phamgiakhanh49', 'sha256$208b9e61b827630d3a4147b28e29b07d90479863e666114f11e3e95791067a05', 'KE_TOAN', 1, '2025-10-18T12:24:00'),
    ('TK00000050', 'lekhanhquynh50', 'sha256$045f3c6bb41123f8dcab2dadd870b282ce18a728774c96775eb032f563ca9cf8', 'KE_TOAN', 1, '2025-01-20T13:25:00');
GO

INSERT INTO dbo.DuLieuHeThong (MaDuLieu, MaTK, HanhDong, TenBang, SoLuongTacDong, NoiDung, ThoiGian) VALUES
    ('DL0000000000001', 'TK00000001', N'Thêm mới', 'ThongTinNhanVien', 2, N'Tạo hồ sơ nhân viên mới: bản ghi #001', '2026-03-03T08:05:00'),
    ('DL0000000000002', 'TK00000002', N'Cập nhật', 'LichPhanCong', 5, N'Điều chỉnh lịch phân công theo nhu cầu bán hàng: bản ghi #002', '2026-03-05T09:10:00'),
    ('DL0000000000003', 'TK00000003', N'Thêm mới', 'DonHang', 1, N'Khởi tạo đơn hàng tại quầy: bản ghi #003', '2026-03-07T10:15:00'),
    ('DL0000000000004', 'TK00000004', N'Cập nhật', 'TonKhoNguyenLieu', 3, N'Điều chỉnh số lượng tồn sau ca: bản ghi #004', '2026-03-09T11:20:00'),
    ('DL0000000000005', 'TK00000005', N'Thêm mới', 'BangLuong', 3, N'Sinh bảng lương tháng: bản ghi #005', '2026-03-11T12:25:00'),
    ('DL0000000000006', 'TK00000006', N'Cập nhật', 'SanPham_ChiNhanh', 4, N'Điều chỉnh giá bán theo chi nhánh: bản ghi #006', '2026-03-13T13:30:00'),
    ('DL0000000000007', 'TK00000007', N'Xóa', 'SanPham_TuyChon', 2, N'Ngưng áp dụng tùy chọn cũ: bản ghi #007', '2026-03-15T14:35:00'),
    ('DL0000000000008', 'TK00000008', N'Cập nhật trạng thái', 'HeThongTaiKhoan', 3, N'Khóa tài khoản sau 5 lần đăng nhập sai: bản ghi #008', '2026-03-17T15:40:00'),
    ('DL0000000000009', 'TK00000009', N'Thêm mới', 'ThongTinNhanVien', 1, N'Tạo hồ sơ nhân viên mới: bản ghi #009', '2026-03-19T16:45:00'),
    ('DL0000000000010', 'TK00000010', N'Cập nhật', 'LichPhanCong', 4, N'Điều chỉnh lịch phân công theo nhu cầu bán hàng: bản ghi #010', '2026-03-21T17:50:00');
GO
INSERT INTO dbo.DuLieuHeThong (MaDuLieu, MaTK, HanhDong, TenBang, SoLuongTacDong, NoiDung, ThoiGian) VALUES
    ('DL0000000000011', 'TK00000011', N'Thêm mới', 'DonHang', 3, N'Khởi tạo đơn hàng tại quầy: bản ghi #011', '2026-03-23T07:55:00'),
    ('DL0000000000012', 'TK00000012', N'Cập nhật', 'TonKhoNguyenLieu', 2, N'Điều chỉnh số lượng tồn sau ca: bản ghi #012', '2026-03-25T08:00:00'),
    ('DL0000000000013', 'TK00000013', N'Thêm mới', 'BangLuong', 2, N'Sinh bảng lương tháng: bản ghi #013', '2026-03-27T09:05:00'),
    ('DL0000000000014', 'TK00000014', N'Cập nhật', 'SanPham_ChiNhanh', 6, N'Điều chỉnh giá bán theo chi nhánh: bản ghi #014', '2026-03-02T10:10:00'),
    ('DL0000000000015', 'TK00000015', N'Xóa', 'SanPham_TuyChon', 1, N'Ngưng áp dụng tùy chọn cũ: bản ghi #015', '2026-03-04T11:15:00'),
    ('DL0000000000016', 'TK00000016', N'Cập nhật trạng thái', 'HeThongTaiKhoan', 2, N'Khóa tài khoản sau 5 lần đăng nhập sai: bản ghi #016', '2026-03-06T12:20:00'),
    ('DL0000000000017', 'TK00000017', N'Thêm mới', 'ThongTinNhanVien', 3, N'Tạo hồ sơ nhân viên mới: bản ghi #017', '2026-03-08T13:25:00'),
    ('DL0000000000018', 'TK00000018', N'Cập nhật', 'LichPhanCong', 3, N'Điều chỉnh lịch phân công theo nhu cầu bán hàng: bản ghi #018', '2026-03-10T14:30:00'),
    ('DL0000000000019', 'TK00000019', N'Thêm mới', 'DonHang', 2, N'Khởi tạo đơn hàng tại quầy: bản ghi #019', '2026-03-12T15:35:00'),
    ('DL0000000000020', 'TK00000020', N'Cập nhật', 'TonKhoNguyenLieu', 4, N'Điều chỉnh số lượng tồn sau ca: bản ghi #020', '2026-03-14T16:40:00');
GO
INSERT INTO dbo.DuLieuHeThong (MaDuLieu, MaTK, HanhDong, TenBang, SoLuongTacDong, NoiDung, ThoiGian) VALUES
    ('DL0000000000021', 'TK00000021', N'Thêm mới', 'BangLuong', 1, N'Sinh bảng lương tháng: bản ghi #021', '2026-03-16T17:45:00'),
    ('DL0000000000022', 'TK00000022', N'Cập nhật', 'SanPham_ChiNhanh', 5, N'Điều chỉnh giá bán theo chi nhánh: bản ghi #022', '2026-03-18T07:50:00'),
    ('DL0000000000023', 'TK00000023', N'Xóa', 'SanPham_TuyChon', 3, N'Ngưng áp dụng tùy chọn cũ: bản ghi #023', '2026-03-20T08:55:00'),
    ('DL0000000000024', 'TK00000024', N'Cập nhật trạng thái', 'HeThongTaiKhoan', 1, N'Khóa tài khoản sau 5 lần đăng nhập sai: bản ghi #024', '2026-03-22T09:00:00'),
    ('DL0000000000025', 'TK00000025', N'Thêm mới', 'ThongTinNhanVien', 2, N'Tạo hồ sơ nhân viên mới: bản ghi #025', '2026-03-24T10:05:00'),
    ('DL0000000000026', 'TK00000026', N'Cập nhật', 'LichPhanCong', 5, N'Điều chỉnh lịch phân công theo nhu cầu bán hàng: bản ghi #026', '2026-03-26T11:10:00'),
    ('DL0000000000027', 'TK00000027', N'Thêm mới', 'DonHang', 1, N'Khởi tạo đơn hàng tại quầy: bản ghi #027', '2026-03-01T12:15:00'),
    ('DL0000000000028', 'TK00000028', N'Cập nhật', 'TonKhoNguyenLieu', 3, N'Điều chỉnh số lượng tồn sau ca: bản ghi #028', '2026-03-03T13:20:00'),
    ('DL0000000000029', 'TK00000029', N'Thêm mới', 'BangLuong', 3, N'Sinh bảng lương tháng: bản ghi #029', '2026-03-05T14:25:00'),
    ('DL0000000000030', 'TK00000030', N'Cập nhật', 'SanPham_ChiNhanh', 4, N'Điều chỉnh giá bán theo chi nhánh: bản ghi #030', '2026-03-07T15:30:00');
GO
INSERT INTO dbo.DuLieuHeThong (MaDuLieu, MaTK, HanhDong, TenBang, SoLuongTacDong, NoiDung, ThoiGian) VALUES
    ('DL0000000000031', 'TK00000031', N'Xóa', 'SanPham_TuyChon', 2, N'Ngưng áp dụng tùy chọn cũ: bản ghi #031', '2026-04-09T16:35:00'),
    ('DL0000000000032', 'TK00000032', N'Cập nhật trạng thái', 'HeThongTaiKhoan', 3, N'Khóa tài khoản sau 5 lần đăng nhập sai: bản ghi #032', '2026-04-11T17:40:00'),
    ('DL0000000000033', 'TK00000033', N'Thêm mới', 'ThongTinNhanVien', 1, N'Tạo hồ sơ nhân viên mới: bản ghi #033', '2026-04-13T07:45:00'),
    ('DL0000000000034', 'TK00000034', N'Cập nhật', 'LichPhanCong', 4, N'Điều chỉnh lịch phân công theo nhu cầu bán hàng: bản ghi #034', '2026-04-15T08:50:00'),
    ('DL0000000000035', 'TK00000035', N'Thêm mới', 'DonHang', 3, N'Khởi tạo đơn hàng tại quầy: bản ghi #035', '2026-04-17T09:55:00'),
    ('DL0000000000036', 'TK00000036', N'Cập nhật', 'TonKhoNguyenLieu', 2, N'Điều chỉnh số lượng tồn sau ca: bản ghi #036', '2026-04-19T10:00:00'),
    ('DL0000000000037', 'TK00000037', N'Thêm mới', 'BangLuong', 2, N'Sinh bảng lương tháng: bản ghi #037', '2026-04-21T11:05:00'),
    ('DL0000000000038', 'TK00000038', N'Cập nhật', 'SanPham_ChiNhanh', 6, N'Điều chỉnh giá bán theo chi nhánh: bản ghi #038', '2026-04-23T12:10:00'),
    ('DL0000000000039', 'TK00000039', N'Xóa', 'SanPham_TuyChon', 1, N'Ngưng áp dụng tùy chọn cũ: bản ghi #039', '2026-04-25T13:15:00'),
    ('DL0000000000040', 'TK00000040', N'Cập nhật trạng thái', 'HeThongTaiKhoan', 2, N'Khóa tài khoản sau 5 lần đăng nhập sai: bản ghi #040', '2026-04-27T14:20:00');
GO
INSERT INTO dbo.DuLieuHeThong (MaDuLieu, MaTK, HanhDong, TenBang, SoLuongTacDong, NoiDung, ThoiGian) VALUES
    ('DL0000000000041', 'TK00000041', N'Thêm mới', 'ThongTinNhanVien', 3, N'Tạo hồ sơ nhân viên mới: bản ghi #041', '2026-04-02T15:25:00'),
    ('DL0000000000042', 'TK00000042', N'Cập nhật', 'LichPhanCong', 3, N'Điều chỉnh lịch phân công theo nhu cầu bán hàng: bản ghi #042', '2026-04-04T16:30:00'),
    ('DL0000000000043', 'TK00000043', N'Thêm mới', 'DonHang', 2, N'Khởi tạo đơn hàng tại quầy: bản ghi #043', '2026-04-06T17:35:00'),
    ('DL0000000000044', 'TK00000044', N'Cập nhật', 'TonKhoNguyenLieu', 4, N'Điều chỉnh số lượng tồn sau ca: bản ghi #044', '2026-04-08T07:40:00'),
    ('DL0000000000045', 'TK00000045', N'Thêm mới', 'BangLuong', 1, N'Sinh bảng lương tháng: bản ghi #045', '2026-04-10T08:45:00'),
    ('DL0000000000046', 'TK00000046', N'Cập nhật', 'SanPham_ChiNhanh', 5, N'Điều chỉnh giá bán theo chi nhánh: bản ghi #046', '2026-04-12T09:50:00'),
    ('DL0000000000047', 'TK00000047', N'Xóa', 'SanPham_TuyChon', 3, N'Ngưng áp dụng tùy chọn cũ: bản ghi #047', '2026-04-14T10:55:00'),
    ('DL0000000000048', 'TK00000048', N'Cập nhật trạng thái', 'HeThongTaiKhoan', 1, N'Khóa tài khoản sau 5 lần đăng nhập sai: bản ghi #048', '2026-04-16T11:00:00'),
    ('DL0000000000049', 'TK00000049', N'Thêm mới', 'ThongTinNhanVien', 2, N'Tạo hồ sơ nhân viên mới: bản ghi #049', '2026-04-18T12:05:00'),
    ('DL0000000000050', 'TK00000050', N'Cập nhật', 'LichPhanCong', 5, N'Điều chỉnh lịch phân công theo nhu cầu bán hàng: bản ghi #050', '2026-04-20T13:10:00');
GO

INSERT INTO dbo.KhuVuc (MaKhuVuc, TenKhuVuc) VALUES
    ('KV00000001', N'Huế - Trung tâm'),
    ('KV00000002', N'Huế - An Cựu'),
    ('KV00000003', N'Huế - Vỹ Dạ'),
    ('KV00000004', N'Huế - Kim Long'),
    ('KV00000005', N'Huế - Phú Hội'),
    ('KV00000006', N'Đà Nẵng - Hải Châu'),
    ('KV00000007', N'Đà Nẵng - Thanh Khê'),
    ('KV00000008', N'Đà Nẵng - Sơn Trà'),
    ('KV00000009', N'Đà Nẵng - Ngũ Hành Sơn'),
    ('KV00000010', N'Đà Nẵng - Liên Chiểu');
GO
INSERT INTO dbo.KhuVuc (MaKhuVuc, TenKhuVuc) VALUES
    ('KV00000011', N'TP.HCM - Quận 1'),
    ('KV00000012', N'TP.HCM - Quận 3'),
    ('KV00000013', N'TP.HCM - Bình Thạnh'),
    ('KV00000014', N'TP.HCM - Phú Nhuận'),
    ('KV00000015', N'TP.HCM - Thủ Đức'),
    ('KV00000016', N'Hà Nội - Hoàn Kiếm'),
    ('KV00000017', N'Hà Nội - Ba Đình'),
    ('KV00000018', N'Hà Nội - Cầu Giấy'),
    ('KV00000019', N'Hà Nội - Đống Đa'),
    ('KV00000020', N'Hà Nội - Tây Hồ');
GO
INSERT INTO dbo.KhuVuc (MaKhuVuc, TenKhuVuc) VALUES
    ('KV00000021', N'Nha Trang - Lộc Thọ'),
    ('KV00000022', N'Nha Trang - Vĩnh Hải'),
    ('KV00000023', N'Quy Nhơn - Trung tâm'),
    ('KV00000024', N'Buôn Ma Thuột - Tân Lợi'),
    ('KV00000025', N'Pleiku - Hoa Lư'),
    ('KV00000026', N'Đà Lạt - Phường 1'),
    ('KV00000027', N'Đà Lạt - Phường 10'),
    ('KV00000028', N'Cần Thơ - Ninh Kiều'),
    ('KV00000029', N'Biên Hòa - Tân Phong'),
    ('KV00000030', N'Vũng Tàu - Thắng Tam');
GO
INSERT INTO dbo.KhuVuc (MaKhuVuc, TenKhuVuc) VALUES
    ('KV00000031', N'Hội An - Cẩm Phô'),
    ('KV00000032', N'Tam Kỳ - An Mỹ'),
    ('KV00000033', N'Quảng Ngãi - Trần Phú'),
    ('KV00000034', N'Đông Hà - Phường 1'),
    ('KV00000035', N'Quảng Trị - Đông Lương'),
    ('KV00000036', N'Phan Thiết - Phú Thủy'),
    ('KV00000037', N'Bảo Lộc - Lộc Sơn'),
    ('KV00000038', N'Long Xuyên - Mỹ Bình'),
    ('KV00000039', N'Rạch Giá - Vĩnh Lạc'),
    ('KV00000040', N'Sóc Trăng - Phường 2');
GO
INSERT INTO dbo.KhuVuc (MaKhuVuc, TenKhuVuc) VALUES
    ('KV00000041', N'Cà Mau - Phường 5'),
    ('KV00000042', N'Bến Tre - Phường 7'),
    ('KV00000043', N'Mỹ Tho - Phường 4'),
    ('KV00000044', N'Tây Ninh - Phường 3'),
    ('KV00000045', N'Bình Dương - Thủ Dầu Một'),
    ('KV00000046', N'Hạ Long - Bãi Cháy'),
    ('KV00000047', N'Hải Phòng - Lê Chân'),
    ('KV00000048', N'Nam Định - Trần Hưng Đạo'),
    ('KV00000049', N'Thanh Hóa - Điện Biên'),
    ('KV00000050', N'Nghệ An - Vinh');
GO

INSERT INTO dbo.ChiNhanh (MaChiNhanh, MaKhuVuc, TenChiNhanh, SoDienThoai, DiaChi, TrangThai, NgayThanhLap) VALUES
    ('CN00000001', 'KV00000001', N'GIBOR Coffee Huế Trung tâm', '0903356886', N'150 Hai Bà Trưng, Trung tâm, Huế', 1, '2019-02-08'),
    ('CN00000002', 'KV00000002', N'GIBOR Coffee Huế An Cựu', '0318728463', N'62 Bạch Đằng, An Cựu, Huế', 1, '2020-03-11'),
    ('CN00000003', 'KV00000003', N'GIBOR Coffee Huế Vỹ Dạ', '0979254563', N'226 Hùng Vương, Vỹ Dạ, Huế', 1, '2021-04-14'),
    ('CN00000004', 'KV00000004', N'GIBOR Coffee Huế Kim Long', '0912575562', N'121 Hai Bà Trưng, Kim Long, Huế', 1, '2022-05-17'),
    ('CN00000005', 'KV00000005', N'GIBOR Coffee Huế Phú Hội', '0975329037', N'111 Bạch Đằng, Phú Hội, Huế', 1, '2023-06-20'),
    ('CN00000006', 'KV00000006', N'GIBOR Coffee DN Hải Châu', '0829587039', N'239 Hoàng Hoa Thám, Hải Châu, Đà Nẵng', 1, '2024-07-23'),
    ('CN00000007', 'KV00000007', N'GIBOR Coffee DN Thanh Khê', '0700872248', N'91 Trường Chinh, Thanh Khê, Đà Nẵng', 1, '2018-08-26'),
    ('CN00000008', 'KV00000008', N'GIBOR Coffee DN Sơn Trà', '0737295260', N'89 Ngô Quyền, Sơn Trà, Đà Nẵng', 1, '2019-09-05'),
    ('CN00000009', 'KV00000009', N'GIBOR Coffee DN Ngũ Hành Sơn', '0713718431', N'57 Nguyễn Thị Minh Khai, Ngũ Hành Sơn, Đà Nẵng', 1, '2020-10-08'),
    ('CN00000010', 'KV00000010', N'GIBOR Coffee DN Liên Chiểu', '0948181396', N'186 Nguyễn Văn Linh, Liên Chiểu, Đà Nẵng', 1, '2021-11-11');
GO
INSERT INTO dbo.ChiNhanh (MaChiNhanh, MaKhuVuc, TenChiNhanh, SoDienThoai, DiaChi, TrangThai, NgayThanhLap) VALUES
    ('CN00000011', 'KV00000011', N'GIBOR Coffee HCM Quận 1', '0705831819', N'245 Bạch Đằng, Quận 1, TP.HCM', 1, '2022-12-14'),
    ('CN00000012', 'KV00000012', N'GIBOR Coffee HCM Quận 3', '0950806024', N'50 Bạch Đằng, Quận 3, TP.HCM', 1, '2023-01-17'),
    ('CN00000013', 'KV00000013', N'GIBOR Coffee HCM Bình Thạnh', '0784374605', N'195 Hoàng Hoa Thám, Bình Thạnh, TP.HCM', 1, '2024-02-20'),
    ('CN00000014', 'KV00000014', N'GIBOR Coffee HCM Phú Nhuận', '0394566031', N'45 Hùng Vương, Phú Nhuận, TP.HCM', 0, '2018-03-23'),
    ('CN00000015', 'KV00000015', N'GIBOR Coffee HCM Thủ Đức', '0338840994', N'50 Hai Bà Trưng, Thủ Đức, TP.HCM', 1, '2019-04-26'),
    ('CN00000016', 'KV00000016', N'GIBOR Coffee HN Hoàn Kiếm', '0951019678', N'152 Phạm Văn Đồng, Hoàn Kiếm, Hà Nội', 1, '2020-05-05'),
    ('CN00000017', 'KV00000017', N'GIBOR Coffee HN Ba Đình', '0721831063', N'199 Pasteur, Ba Đình, Hà Nội', 1, '2021-06-08'),
    ('CN00000018', 'KV00000018', N'GIBOR Coffee HN Cầu Giấy', '0389949389', N'146 Lê Lợi, Cầu Giấy, Hà Nội', 1, '2022-07-11'),
    ('CN00000019', 'KV00000019', N'GIBOR Coffee HN Đống Đa', '0371691040', N'135 Điện Biên Phủ, Đống Đa, Hà Nội', 1, '2023-08-14'),
    ('CN00000020', 'KV00000020', N'GIBOR Coffee HN Tây Hồ', '0850929647', N'148 Bạch Đằng, Tây Hồ, Hà Nội', 1, '2024-09-17');
GO
INSERT INTO dbo.ChiNhanh (MaChiNhanh, MaKhuVuc, TenChiNhanh, SoDienThoai, DiaChi, TrangThai, NgayThanhLap) VALUES
    ('CN00000021', 'KV00000021', N'GIBOR Coffee Nha Trang Lộc Thọ', '0391887369', N'176 Hùng Vương, Lộc Thọ, Nha Trang', 1, '2018-10-20'),
    ('CN00000022', 'KV00000022', N'GIBOR Coffee Nha Trang Vĩnh Hải', '0304308421', N'171 Nguyễn Thị Minh Khai, Vĩnh Hải, Nha Trang', 1, '2019-11-23'),
    ('CN00000023', 'KV00000023', N'GIBOR Coffee Quy Nhơn Trung tâm', '0708883684', N'118 Hoàng Hoa Thám, Trung tâm, Quy Nhơn', 1, '2020-12-26'),
    ('CN00000024', 'KV00000024', N'GIBOR Coffee Buôn Ma Thuột Tân Lợi', '0728538251', N'265 Nguyễn Thị Minh Khai, Tân Lợi, Buôn Ma Thuột', 1, '2021-01-05'),
    ('CN00000025', 'KV00000025', N'GIBOR Coffee Pleiku Hoa Lư', '0819175900', N'145 Phan Chu Trinh, Hoa Lư, Pleiku', 1, '2022-02-08'),
    ('CN00000026', 'KV00000026', N'GIBOR Coffee Đà Lạt Phường 1', '0399990728', N'285 Lý Thường Kiệt, Phường 1, Đà Lạt', 1, '2023-03-11'),
    ('CN00000027', 'KV00000027', N'GIBOR Coffee Đà Lạt Phường 10', '0878320463', N'214 Pasteur, Phường 10, Đà Lạt', 1, '2024-04-14'),
    ('CN00000028', 'KV00000028', N'GIBOR Coffee Cần Thơ Ninh Kiều', '0318566572', N'270 Hoàng Diệu, Ninh Kiều, Cần Thơ', 1, '2018-05-17'),
    ('CN00000029', 'KV00000029', N'GIBOR Coffee Biên Hòa Tân Phong', '0906323852', N'66 Phan Chu Trinh, Tân Phong, Biên Hòa', 0, '2019-06-20'),
    ('CN00000030', 'KV00000030', N'GIBOR Coffee Vũng Tàu Thắng Tam', '0391332642', N'226 Nguyễn Văn Linh, Thắng Tam, Vũng Tàu', 1, '2020-07-23');
GO
INSERT INTO dbo.ChiNhanh (MaChiNhanh, MaKhuVuc, TenChiNhanh, SoDienThoai, DiaChi, TrangThai, NgayThanhLap) VALUES
    ('CN00000031', 'KV00000031', N'GIBOR Coffee Hội An Cẩm Phô', '0951642594', N'205 Nguyễn Văn Linh, Cẩm Phô, Hội An', 1, '2021-08-26'),
    ('CN00000032', 'KV00000032', N'GIBOR Coffee Tam Kỳ An Mỹ', '0871016525', N'138 Bạch Đằng, An Mỹ, Tam Kỳ', 1, '2022-09-05'),
    ('CN00000033', 'KV00000033', N'GIBOR Coffee Quảng Ngãi Trần Phú', '0991306093', N'68 Bạch Đằng, Trần Phú, Quảng Ngãi', 1, '2023-10-08'),
    ('CN00000034', 'KV00000034', N'GIBOR Coffee Đông Hà Phường 1', '0786028436', N'184 Trần Hưng Đạo, Phường 1, Đông Hà', 1, '2024-11-11'),
    ('CN00000035', 'KV00000035', N'GIBOR Coffee Quảng Trị Đông Lương', '0758353204', N'90 Phạm Văn Đồng, Đông Lương, Quảng Trị', 1, '2018-12-14'),
    ('CN00000036', 'KV00000036', N'GIBOR Coffee Phan Thiết Phú Thủy', '0996917555', N'144 Nguyễn Tất Thành, Phú Thủy, Phan Thiết', 1, '2019-01-17'),
    ('CN00000037', 'KV00000037', N'GIBOR Coffee Bảo Lộc Lộc Sơn', '0368139880', N'64 Tố Hữu, Lộc Sơn, Bảo Lộc', 1, '2020-02-20'),
    ('CN00000038', 'KV00000038', N'GIBOR Coffee Long Xuyên Mỹ Bình', '0320513739', N'201 Điện Biên Phủ, Mỹ Bình, Long Xuyên', 1, '2021-03-23'),
    ('CN00000039', 'KV00000039', N'GIBOR Coffee Rạch Giá Vĩnh Lạc', '0980388981', N'175 Hoàng Diệu, Vĩnh Lạc, Rạch Giá', 1, '2022-04-26'),
    ('CN00000040', 'KV00000040', N'GIBOR Coffee Sóc Trăng Phường 2', '0915014631', N'195 Tố Hữu, Phường 2, Sóc Trăng', 1, '2023-05-05');
GO
INSERT INTO dbo.ChiNhanh (MaChiNhanh, MaKhuVuc, TenChiNhanh, SoDienThoai, DiaChi, TrangThai, NgayThanhLap) VALUES
    ('CN00000041', 'KV00000041', N'GIBOR Coffee Cà Mau Phường 5', '0307774584', N'133 Hoàng Hoa Thám, Phường 5, Cà Mau', 1, '2024-06-08'),
    ('CN00000042', 'KV00000042', N'GIBOR Coffee Bến Tre Phường 7', '0911496211', N'258 Lê Lợi, Phường 7, Bến Tre', 1, '2018-07-11'),
    ('CN00000043', 'KV00000043', N'GIBOR Coffee Mỹ Tho Phường 4', '0317232410', N'253 Bạch Đằng, Phường 4, Mỹ Tho', 1, '2019-08-14'),
    ('CN00000044', 'KV00000044', N'GIBOR Coffee Tây Ninh Phường 3', '0335575298', N'280 Nguyễn Văn Linh, Phường 3, Tây Ninh', 1, '2020-09-17'),
    ('CN00000045', 'KV00000045', N'GIBOR Coffee Bình Dương Thủ Dầu Một', '0828427073', N'286 Ngô Quyền, Thủ Dầu Một, Bình Dương', 1, '2021-10-20'),
    ('CN00000046', 'KV00000046', N'GIBOR Coffee Hạ Long Bãi Cháy', '0753551839', N'201 Phạm Văn Đồng, Bãi Cháy, Hạ Long', 1, '2022-11-23'),
    ('CN00000047', 'KV00000047', N'GIBOR Coffee Hải Phòng Lê Chân', '0816240908', N'136 Hai Bà Trưng, Lê Chân, Hải Phòng', 0, '2023-12-26'),
    ('CN00000048', 'KV00000048', N'GIBOR Coffee Nam Định Trần Hưng Đạo', '0945377076', N'20 Hoàng Hoa Thám, Trần Hưng Đạo, Nam Định', 1, '2024-01-05'),
    ('CN00000049', 'KV00000049', N'GIBOR Coffee Thanh Hóa Điện Biên', '0378979095', N'122 Nguyễn Huệ, Điện Biên, Thanh Hóa', 1, '2018-02-08'),
    ('CN00000050', 'KV00000050', N'GIBOR Coffee Nghệ An Vinh', '0995004803', N'40 Hai Bà Trưng, Vinh, Nghệ An', 1, '2019-03-11');
GO

-- =============================================
-- PHẦN 7: NHÀ CUNG CẤP VÀ NGUYÊN LIỆU
-- =============================================
PRINT '';
PRINT 'PHẦN 7: Thêm nhà cung cấp và nguyên liệu...';

-- Thêm 10 nhà cung cấp
INSERT INTO dbo.NhaCungCap (MaNCC, TenNCC, DienThoai, DiaChi, Email, TrangThai) VALUES
    ('NCC0000001', N'Công ty Cà phê Trung Nguyên', '0901234567', N'123 Lê Lợi, Quận 1, TP.HCM', 'trungnguyen@coffee.vn', N'Đang hợp tác'),
    ('NCC0000002', N'Công ty Sữa TH True Milk', '0902345678', N'456 Nguyễn Huệ, Quận 1, TP.HCM', 'contact@thmilk.vn', N'Đang hợp tác'),
    ('NCC0000003', N'Công ty Đường Biên Hòa', '0903456789', N'789 Trần Hưng Đạo, Biên Hòa, Đồng Nai', 'bienhoa@sugar.vn', N'Đang hợp tác'),
    ('NCC0000004', N'Công ty Trà Lipton Việt Nam', '0904567890', N'321 Hai Bà Trưng, Quận 3, TP.HCM', 'lipton@tea.vn', N'Đang hợp tác'),
    ('NCC0000005', N'Công ty Socola Pheva', '0905678901', N'654 Lý Thường Kiệt, Quận 10, TP.HCM', 'pheva@chocolate.vn', N'Đang hợp tác'),
    ('NCC0000006', N'Công ty Bánh Kinh Đô', '0906789012', N'987 Cách Mạng Tháng 8, Quận 3, TP.HCM', 'kinhdo@bakery.vn', N'Đang hợp tác'),
    ('NCC0000007', N'Công ty Trái cây Đà Lạt', '0907890123', N'147 Nguyễn Văn Linh, Đà Lạt, Lâm Đồng', 'dalat@fruits.vn', N'Đang hợp tác'),
    ('NCC0000008', N'Công ty Kem Vinamilk', '0908901234', N'258 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM', 'vinamilk@icecream.vn', N'Đang hợp tác'),
    ('NCC0000009', N'Công ty Hương liệu Việt Nam', '0909012345', N'369 Võ Văn Tần, Quận 3, TP.HCM', 'flavor@vietnam.vn', N'Đang hợp tác'),
    ('NCC0000010', N'Công ty Bao bì Tân Tiến', '0900123456', N'741 Lê Văn Việt, Quận 9, TP.HCM', 'tantien@packaging.vn', N'Đang hợp tác');
GO

-- Thêm 50 nguyên liệu
PRINT 'Thêm 50 nguyên liệu...';

INSERT INTO dbo.NguyenLieu (MaNguyenLieu, TenNguyenLieu, DonViTinh, GiaNhap, MaNCC, CoHanSuDung, TrangThai) VALUES
    -- Cà phê (5 loại)
    ('NL00000001', N'Cà phê hạt Arabica', N'kg', 250000, 'NCC0000001', 0, N'Đang sử dụng'),
    ('NL00000002', N'Cà phê hạt Robusta', N'kg', 180000, 'NCC0000001', 0, N'Đang sử dụng'),
    ('NL00000003', N'Cà phê bột Espresso', N'kg', 220000, 'NCC0000001', 0, N'Đang sử dụng'),
    ('NL00000004', N'Cà phê hòa tan', N'kg', 150000, 'NCC0000001', 0, N'Đang sử dụng'),
    ('NL00000005', N'Cà phê Cold Brew', N'lít', 200000, 'NCC0000001', 1, N'Đang sử dụng'),
    -- Sữa (8 loại)
    ('NL00000006', N'Sữa tươi nguyên chất', N'lít', 35000, 'NCC0000002', 1, N'Đang sử dụng'),
    ('NL00000007', N'Sữa đặc có đường', N'lon', 18000, 'NCC0000002', 0, N'Đang sử dụng'),
    ('NL00000008', N'Sữa đặc không đường', N'lon', 20000, 'NCC0000002', 0, N'Đang sử dụng'),
    ('NL00000009', N'Sữa dừa', N'lít', 45000, 'NCC0000002', 1, N'Đang sử dụng'),
    ('NL00000010', N'Sữa hạnh nhân', N'lít', 55000, 'NCC0000002', 1, N'Đang sử dụng'),
    ('NL00000011', N'Sữa yến mạch', N'lít', 50000, 'NCC0000002', 1, N'Đang sử dụng'),
    ('NL00000012', N'Kem sữa tươi', N'lít', 80000, 'NCC0000002', 1, N'Đang sử dụng'),
    ('NL00000013', N'Sữa chua', N'kg', 40000, 'NCC0000002', 1, N'Đang sử dụng'),
    -- Đường và chất ngọt (5 loại)
    ('NL00000014', N'Đường trắng', N'kg', 18000, 'NCC0000003', 0, N'Đang sử dụng'),
    ('NL00000015', N'Đường nâu', N'kg', 22000, 'NCC0000003', 0, N'Đang sử dụng'),
    ('NL00000016', N'Đường đen', N'kg', 25000, 'NCC0000003', 0, N'Đang sử dụng'),
    ('NL00000017', N'Mật ong', N'kg', 120000, 'NCC0000003', 0, N'Đang sử dụng'),
    ('NL00000018', N'Syrup caramel', N'lít', 85000, 'NCC0000003', 0, N'Đang sử dụng'),
    -- Trà (6 loại)
    ('NL00000019', N'Trà đen', N'kg', 180000, 'NCC0000004', 0, N'Đang sử dụng'),
    ('NL00000020', N'Trà xanh', N'kg', 200000, 'NCC0000004', 0, N'Đang sử dụng'),
    ('NL00000021', N'Trà ô long', N'kg', 250000, 'NCC0000004', 0, N'Đang sử dụng'),
    ('NL00000022', N'Trà sen', N'kg', 280000, 'NCC0000004', 0, N'Đang sử dụng'),
    ('NL00000023', N'Bột matcha', N'kg', 450000, 'NCC0000004', 0, N'Đang sử dụng'),
    ('NL00000024', N'Trà hoa cúc', N'kg', 150000, 'NCC0000004', 0, N'Đang sử dụng'),
    -- Socola và bột (4 loại)
    ('NL00000025', N'Bột socola đen', N'kg', 180000, 'NCC0000005', 0, N'Đang sử dụng'),
    ('NL00000026', N'Bột socola sữa', N'kg', 160000, 'NCC0000005', 0, N'Đang sử dụng'),
    ('NL00000027', N'Socola chip', N'kg', 200000, 'NCC0000005', 0, N'Đang sử dụng'),
    ('NL00000028', N'Bột ca cao', N'kg', 140000, 'NCC0000005', 0, N'Đang sử dụng'),
    -- Trái cây (8 loại)
    ('NL00000029', N'Dâu tây tươi', N'kg', 120000, 'NCC0000007', 1, N'Đang sử dụng'),
    ('NL00000030', N'Việt quất đông lạnh', N'kg', 180000, 'NCC0000007', 1, N'Đang sử dụng'),
    ('NL00000031', N'Xoài cắt lát', N'kg', 80000, 'NCC0000007', 1, N'Đang sử dụng'),
    ('NL00000032', N'Đào đóng hộp', N'hộp', 35000, 'NCC0000007', 0, N'Đang sử dụng'),
    ('NL00000033', N'Vải đóng hộp', N'hộp', 32000, 'NCC0000007', 0, N'Đang sử dụng'),
    ('NL00000034', N'Chanh tươi', N'kg', 25000, 'NCC0000007', 1, N'Đang sử dụng'),
    ('NL00000035', N'Cam tươi', N'kg', 30000, 'NCC0000007', 1, N'Đang sử dụng'),
    ('NL00000036', N'Dưa hấu', N'kg', 15000, 'NCC0000007', 1, N'Đang sử dụng'),
    -- Topping và phụ liệu (8 loại)
    ('NL00000037', N'Trân châu đen', N'kg', 45000, 'NCC0000006', 0, N'Đang sử dụng'),
    ('NL00000038', N'Trân châu trắng', N'kg', 42000, 'NCC0000006', 0, N'Đang sử dụng'),
    ('NL00000039', N'Thạch rau câu', N'kg', 35000, 'NCC0000006', 1, N'Đang sử dụng'),
    ('NL00000040', N'Pudding trứng', N'kg', 55000, 'NCC0000006', 1, N'Đang sử dụng'),
    ('NL00000041', N'Kem cheese', N'kg', 95000, 'NCC0000008', 1, N'Đang sử dụng'),
    ('NL00000042', N'Whipping cream', N'lít', 120000, 'NCC0000008', 1, N'Đang sử dụng'),
    ('NL00000043', N'Bột rắc cookies', N'kg', 75000, 'NCC0000006', 0, N'Đang sử dụng'),
    ('NL00000044', N'Hạt hạnh nhân rang', N'kg', 280000, 'NCC0000006', 0, N'Đang sử dụng'),
    -- Hương liệu và gia vị (6 loại)
    ('NL00000045', N'Vanilla extract', N'chai', 65000, 'NCC0000009', 0, N'Đang sử dụng'),
    ('NL00000046', N'Bột quế', N'kg', 180000, 'NCC0000009', 0, N'Đang sử dụng'),
    ('NL00000047', N'Muối biển', N'kg', 25000, 'NCC0000009', 0, N'Đang sử dụng'),
    ('NL00000048', N'Sả tươi', N'kg', 30000, 'NCC0000009', 1, N'Đang sử dụng'),
    ('NL00000049', N'Bạc hà tươi', N'kg', 40000, 'NCC0000009', 1, N'Đang sử dụng'),
    ('NL00000050', N'Gừng tươi', N'kg', 35000, 'NCC0000009', 1, N'Đang sử dụng');
GO

PRINT '  ✓ Đã thêm 10 nhà cung cấp và 50 nguyên liệu';
GO

/* =============================================================================================================== */
/*                                      THÊM DỮ LIỆU TỒN KHO NGUYÊN LIỆU                                         */
/* =============================================================================================================== */

PRINT 'Thêm 50 dữ liệu tồn kho nguyên liệu...';

INSERT INTO dbo.TonKhoNguyenLieu (MaChiNhanh, MaNguyenLieu, SoLuongTon, MucCanhBao, HanSuDung, SoLuongDaDat) VALUES
    -- Chi nhánh 1: Cà phê và sữa
    ('CN00000001', 'NL00000001', 50.00, 10.00, NULL, 0.00),
    ('CN00000001', 'NL00000002', 45.00, 10.00, NULL, 0.00),
    ('CN00000001', 'NL00000006', 80.00, 20.00, '2026-06-15', 0.00),
    ('CN00000001', 'NL00000007', 120.00, 30.00, NULL, 0.00),
    ('CN00000001', 'NL00000014', 100.00, 25.00, NULL, 0.00),
    
    -- Chi nhánh 2: Trà và topping
    ('CN00000002', 'NL00000019', 30.00, 8.00, NULL, 0.00),
    ('CN00000002', 'NL00000020', 35.00, 8.00, NULL, 0.00),
    ('CN00000002', 'NL00000037', 60.00, 15.00, NULL, 0.00),
    ('CN00000002', 'NL00000038', 55.00, 15.00, NULL, 0.00),
    ('CN00000002', 'NL00000006', 70.00, 20.00, '2026-06-20', 0.00),
    
    -- Chi nhánh 3: Socola và trái cây
    ('CN00000003', 'NL00000025', 40.00, 10.00, NULL, 0.00),
    ('CN00000003', 'NL00000026', 38.00, 10.00, NULL, 0.00),
    ('CN00000003', 'NL00000029', 25.00, 8.00, '2026-06-10', 0.00),
    ('CN00000003', 'NL00000030', 30.00, 8.00, '2026-07-01', 0.00),
    ('CN00000003', 'NL00000012', 45.00, 12.00, '2026-06-18', 0.00),
    
    -- Chi nhánh 4: Cà phê đặc biệt
    ('CN00000004', 'NL00000003', 55.00, 12.00, NULL, 0.00),
    ('CN00000004', 'NL00000005', 40.00, 10.00, '2026-06-25', 0.00),
    ('CN00000004', 'NL00000023', 20.00, 5.00, NULL, 0.00),
    ('CN00000004', 'NL00000042', 35.00, 10.00, '2026-06-22', 0.00),
    ('CN00000004', 'NL00000044', 15.00, 5.00, NULL, 0.00),
    
    -- Chi nhánh 5: Trà sữa
    ('CN00000005', 'NL00000019', 42.00, 10.00, NULL, 0.00),
    ('CN00000005', 'NL00000006', 90.00, 25.00, '2026-06-12', 0.00),
    ('CN00000005', 'NL00000037', 70.00, 18.00, NULL, 0.00),
    ('CN00000005', 'NL00000040', 50.00, 12.00, '2026-06-16', 0.00),
    ('CN00000005', 'NL00000041', 30.00, 8.00, '2026-06-14', 0.00),
    
    -- Chi nhánh 6: Đồ uống trái cây
    ('CN00000006', 'NL00000034', 60.00, 15.00, '2026-06-08', 0.00),
    ('CN00000006', 'NL00000035', 55.00, 15.00, '2026-06-09', 0.00),
    ('CN00000006', 'NL00000036', 80.00, 20.00, '2026-06-07', 0.00),
    ('CN00000006', 'NL00000014', 95.00, 25.00, NULL, 0.00),
    ('CN00000006', 'NL00000018', 40.00, 10.00, NULL, 0.00),
    
    -- Chi nhánh 7: Cà phê và bánh
    ('CN00000007', 'NL00000001', 48.00, 10.00, NULL, 0.00),
    ('CN00000007', 'NL00000002', 52.00, 10.00, NULL, 0.00),
    ('CN00000007', 'NL00000027', 35.00, 8.00, NULL, 0.00),
    ('CN00000007', 'NL00000043', 28.00, 7.00, NULL, 0.00),
    ('CN00000007', 'NL00000012', 50.00, 12.00, '2026-06-19', 0.00),
    
    -- Chi nhánh 8: Matcha và trà xanh
    ('CN00000008', 'NL00000020', 38.00, 10.00, NULL, 0.00),
    ('CN00000008', 'NL00000023', 25.00, 6.00, NULL, 0.00),
    ('CN00000008', 'NL00000006', 75.00, 20.00, '2026-06-17', 0.00),
    ('CN00000008', 'NL00000037', 65.00, 16.00, NULL, 0.00),
    ('CN00000008', 'NL00000042', 40.00, 10.00, '2026-06-21', 0.00),
    
    -- Chi nhánh 9: Đồ uống đặc biệt
    ('CN00000009', 'NL00000021', 32.00, 8.00, NULL, 0.00),
    ('CN00000009', 'NL00000022', 28.00, 7.00, NULL, 0.00),
    ('CN00000009', 'NL00000017', 45.00, 12.00, NULL, 0.00),
    ('CN00000009', 'NL00000045', 20.00, 5.00, NULL, 0.00),
    ('CN00000009', 'NL00000046', 18.00, 5.00, NULL, 0.00),
    
    -- Chi nhánh 10: Cà phê truyền thống
    ('CN00000010', 'NL00000001', 60.00, 15.00, NULL, 0.00),
    ('CN00000010', 'NL00000004', 55.00, 12.00, NULL, 0.00),
    ('CN00000010', 'NL00000007', 110.00, 28.00, NULL, 0.00),
    ('CN00000010', 'NL00000008', 105.00, 26.00, NULL, 0.00),
    ('CN00000010', 'NL00000014', 88.00, 22.00, NULL, 0.00);
GO

PRINT N'  Đã thêm dữ liệu tồn kho mẫu ban đầu';
GO

INSERT INTO dbo.TonKhoNguyenLieu
(
    MaChiNhanh,
    MaNguyenLieu,
    SoLuongTon,
    MucCanhBao,
    HanSuDung,
    SoLuongDaDat
)
SELECT
    cn.MaChiNhanh,
    nl.MaNguyenLieu,
    100.00,
    20.00,
    CASE WHEN nl.CoHanSuDung = 1 THEN DATEADD(MONTH, 6, CONVERT(date, GETDATE())) ELSE NULL END,
    0.00
FROM dbo.ChiNhanh cn
CROSS JOIN dbo.NguyenLieu nl
WHERE cn.TrangThai = 1
  AND nl.TrangThai = N'Đang sử dụng'
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.TonKhoNguyenLieu tk
      WHERE tk.MaChiNhanh = cn.MaChiNhanh
        AND tk.MaNguyenLieu = nl.MaNguyenLieu
  );
GO

PRINT N'  Đã đồng bộ tồn kho cho tất cả chi nhánh và nguyên liệu đang hoạt động';
GO

INSERT INTO dbo.ChucVuNhanVien (MaChucVu, TenChucVu, LuongCoBanGio) VALUES
('CV00000051', N'ADMIN', 500000)
GO

INSERT INTO dbo.ChucVuNhanVien (MaChucVu, TenChucVu, LuongCoBanGio) VALUES
    ('CV00000001', N'Barista bậc 1', 22000.00),
    ('CV00000002', N'Barista bậc 2', 25000.00),
    ('CV00000003', N'Barista bậc 3', 28000.00),
    ('CV00000004', N'Barista bậc 4', 31000.00),
    ('CV00000005', N'Barista bậc 5', 34000.00),
    ('CV00000006', N'Thu ngân bậc 1', 23000.00),
    ('CV00000007', N'Thu ngân bậc 2', 26000.00),
    ('CV00000008', N'Thu ngân bậc 3', 29000.00),
    ('CV00000009', N'Thu ngân bậc 4', 32000.00),
    ('CV00000010', N'Thu ngân bậc 5', 35000.00);
GO
INSERT INTO dbo.ChucVuNhanVien (MaChucVu, TenChucVu, LuongCoBanGio) VALUES
    ('CV00000011', N'Giám sát ca bậc 1', 30000.00),
    ('CV00000012', N'Giám sát ca bậc 2', 33500.00),
    ('CV00000013', N'Giám sát ca bậc 3', 37000.00),
    ('CV00000014', N'Giám sát ca bậc 4', 40500.00),
    ('CV00000015', N'Giám sát ca bậc 5', 44000.00),
    ('CV00000016', N'Quản lý cửa hàng hạng 1', 42000.00),
    ('CV00000017', N'Quản lý cửa hàng hạng 2', 46000.00),
    ('CV00000018', N'Quản lý cửa hàng hạng 3', 50000.00),
    ('CV00000019', N'Quản lý cửa hàng hạng 4', 54000.00),
    ('CV00000020', N'Quản lý cửa hàng hạng 5', 58000.00);
GO
INSERT INTO dbo.ChucVuNhanVien (MaChucVu, TenChucVu, LuongCoBanGio) VALUES
    ('CV00000021', N'Nhân viên kho bậc 1', 26000.00),
    ('CV00000022', N'Nhân viên kho bậc 2', 28500.00),
    ('CV00000023', N'Nhân viên kho bậc 3', 31000.00),
    ('CV00000024', N'Nhân viên kho bậc 4', 33500.00),
    ('CV00000025', N'Nhân viên kho bậc 5', 36000.00),
    ('CV00000026', N'Nhân viên bếp bánh bậc 1', 25000.00),
    ('CV00000027', N'Nhân viên bếp bánh bậc 2', 27500.00),
    ('CV00000028', N'Nhân viên bếp bánh bậc 3', 30000.00),
    ('CV00000029', N'Nhân viên bếp bánh bậc 4', 32500.00),
    ('CV00000030', N'Nhân viên bếp bánh bậc 5', 35000.00);
GO
INSERT INTO dbo.ChucVuNhanVien (MaChucVu, TenChucVu, LuongCoBanGio) VALUES
    ('CV00000031', N'Chuyên viên QC đồ uống bậc 1', 32000.00),
    ('CV00000032', N'Chuyên viên QC đồ uống bậc 2', 35000.00),
    ('CV00000033', N'Chuyên viên QC đồ uống bậc 3', 38000.00),
    ('CV00000034', N'Chuyên viên QC đồ uống bậc 4', 41000.00),
    ('CV00000035', N'Chuyên viên QC đồ uống bậc 5', 44000.00),
    ('CV00000036', N'Điều phối giao hàng bậc 1', 24000.00),
    ('CV00000037', N'Điều phối giao hàng bậc 2', 26500.00),
    ('CV00000038', N'Điều phối giao hàng bậc 3', 29000.00),
    ('CV00000039', N'Điều phối giao hàng bậc 4', 31500.00),
    ('CV00000040', N'Điều phối giao hàng bậc 5', 34000.00);
GO
INSERT INTO dbo.ChucVuNhanVien (MaChucVu, TenChucVu, LuongCoBanGio) VALUES
    ('CV00000041', N'Chăm sóc khách hàng bậc 1', 23500.00),
    ('CV00000042', N'Chăm sóc khách hàng bậc 2', 26000.00),
    ('CV00000043', N'Chăm sóc khách hàng bậc 3', 28500.00),
    ('CV00000044', N'Chăm sóc khách hàng bậc 4', 31000.00),
    ('CV00000045', N'Chăm sóc khách hàng bậc 5', 33500.00),
    ('CV00000046', N'Kế toán vận hành bậc 1', 31000.00),
    ('CV00000047', N'Kế toán vận hành bậc 2', 34000.00),
    ('CV00000048', N'Kế toán vận hành bậc 3', 37000.00),
    ('CV00000049', N'Kế toán vận hành bậc 4', 40000.00),
    ('CV00000050', N'Kế toán vận hành bậc 5', 43000.00);
GO

INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCCCD, Email, TrangThai) VALUES
    ('NV00000051', 1, N'Trần Gia Bảo', 'CV00000051', 'CN00000001', '2023-04-05', NULL, '0782097999', '966616964501', 'gibor06.dev@giborcoffee.vn', 1),
    ('NV00000052', 1, N'Lê Quang Bảo', 'CV00000020', 'CN00000001', '2024-05-07', NULL, '0989679081', '966616984501', 'lequangbao@giborcoffee.vn', 1),
    ('NV00000053', 1, N'Nguyễn Ngọc Châu', 'CV00000050', 'CN00000001', '2022-06-09', NULL, '0789738566', '966616284501', 'nguyenngocchau@giborcoffee.vn', 1),
    ('NV00000054', 1, N'Nguyễn Thế Anh', 'CV00000025', 'CN00000001', '2022-06-09', NULL, '0789039526', '211223158003', 'nguyentheanh@giborcoffee.vn', 1),
    ('NV00000055', 1, N'Trần Dương Gia Bảo', 'CV00000035', 'CN00000001', '2022-06-09', NULL, '0709038526', '214225158003', 'tranduonggiabao@giborcoffee.vn', 1)
GO

INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCCCD, Email, TrangThai) VALUES
    ('NV00000001', 2, N'Trần Văn Khang', 'CV00000001', 'CN00000001', '2023-04-05', NULL, '0782037999', '966616964001', 'tranvankhang.01@giborcoffee.vn', 1),
    ('NV00000002', 2, N'Trần Phương Hiền', 'CV00000002', 'CN00000002', '2024-05-07', NULL, '0989639081', '966616974501', 'tranphuonghien.02@giborcoffee.vn', 1),
    ('NV00000003', 2, N'Hoàng Anh Đức', 'CV00000003', 'CN00000003', '2022-06-09', NULL, '0789038526', '211225158003', 'hoanganhduc.03@giborcoffee.vn', 1),
    ('NV00000004', 1, N'Đặng Thanh Thảo', 'CV00000004', 'CN00000004', '2023-07-11', NULL, '0335496015', '223940587004', 'dangthanhthao.04@giborcoffee.vn', 1),
    ('NV00000005', 1, N'Bùi Anh Hiếu', 'CV00000005', 'CN00000005', '2024-08-13', NULL, '0999645480', '694019365005', 'buianhhieu.05@giborcoffee.vn', 1),
    ('NV00000006', 2, N'Ngô Khánh Ngân', 'CV00000006', 'CN00000006', '2022-09-15', NULL, '0336553958', '402533494006', 'ngokhanhngan.06@giborcoffee.vn', 1),
    ('NV00000007', 2, N'Phạm Hữu Cường', 'CV00000007', 'CN00000007', '2023-10-17', NULL, '0396316277', '468164906007', 'phamhuucuong.07@giborcoffee.vn', 1),
    ('NV00000008', 2, N'Đỗ Mai Mai', 'CV00000008', 'CN00000008', '2024-11-19', NULL, '0392274302', '781007818008', 'domaimai.08@giborcoffee.vn', 1),
    ('NV00000009', 2, 'Phan Thanh Nam', 'CV00000009', 'CN00000009', '2022-12-21', NULL, '0767834855', '624557080009', 'phanthanhnam.09@giborcoffee.vn', 1),
    ('NV00000010', 2, N'Dương Thị Vy', 'CV00000010', 'CN00000010', '2023-01-23', NULL, '0706818112', '199104722010', 'duongthivy.10@giborcoffee.vn', 1);
GO
INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCCCD, Email, TrangThai) VALUES
    ('NV00000011', 1, N'Đỗ Hữu Bảo', 'CV00000011', 'CN00000011', '2024-02-25', NULL, '0837135391', '147337803011', 'dohuubao.11@giborcoffee.vn', 1),
    ('NV00000012', 1, N'Phan Bảo Diễm', 'CV00000012', 'CN00000012', '2022-03-27', NULL, '0944769200', '927982963012', 'phanbaodiem.12@giborcoffee.vn', 1),
    ('NV00000013', 1, N'Phạm Quốc Đức', 'CV00000013', 'CN00000013', '2023-04-04', NULL, '0385511909', '381272327013', 'phamquocduc.13@giborcoffee.vn', 1),
    ('NV00000014', 1, N'Đặng Khánh Giang', 'CV00000014', 'CN00000014', '2024-05-06', NULL, '0399486328', '574417266014', 'dangkhanhgiang.14@giborcoffee.vn', 1),
    ('NV00000015', 1, N'Phan Minh Hùng', 'CV00000015', 'CN00000015', '2022-06-08', NULL, '0875283645', '110382761015', 'phanminhhung.15@giborcoffee.vn', 1),
    ('NV00000016', 1, N'Võ Thu Chi', 'CV00000016', 'CN00000016', '2023-07-10', NULL, '0910099059', '841976666016', 'vothuchi.16@giborcoffee.vn', 1),
    ('NV00000017', 1, N'Võ Công Cường', 'CV00000017', 'CN00000017', '2024-08-12', NULL, '0373227889', '138684919017', 'vocongcuong.17@giborcoffee.vn', 1),
    ('NV00000018', 1, N'Nguyễn Phương An', 'CV00000018', 'CN00000018', '2022-09-14', NULL, '0778183110', '693269304018', 'nguyenphuongan.18@giborcoffee.vn', 1),
    ('NV00000019', 1, N'Trần Quốc Đạt', 'CV00000019', 'CN00000019', '2023-10-16', NULL, '0357684996', '236843584019', 'tranquocdat.19@giborcoffee.vn', 1),
    ('NV00000020', 1, N'Phan Khánh Nhung', 'CV00000020', 'CN00000020', '2024-11-18', NULL, '0941373735', '491541578020', 'phankhanhnhung.20@giborcoffee.vn', 1);
GO
INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCCCD, Email, TrangThai) VALUES
    ('NV00000021', 1, N'Phạm Thanh Bảo', 'CV00000021', 'CN00000021', '2022-12-20', NULL, '0948024342', '325567963021', 'phamthanhbao.21@giborcoffee.vn', 1),
    ('NV00000022', 1, N'Lê Mai An', 'CV00000022', 'CN00000022', '2023-01-22', NULL, '0389514287', '210373808022', 'lemaian.22@giborcoffee.vn', 1),
    ('NV00000023', 1, N'Phan Đức Nam', 'CV00000023', 'CN00000023', '2024-02-24', NULL, '0775146293', '536344399023', 'phanducnam.23@giborcoffee.vn', 1),
    ('NV00000024', 1, N'Hoàng Mai Yến', 'CV00000024', 'CN00000024', '2022-03-26', NULL, '0331774346', '274484941024', 'hoangmaiyen.24@giborcoffee.vn', 1),
    ('NV00000025', 1, N'Hồ Công Vinh', 'CV00000025', 'CN00000025', '2023-04-03', NULL, '0355337219', '126614158025', 'hocongvinh.25@giborcoffee.vn', 1),
    ('NV00000026', 1, N'Hồ Khánh Giang', 'CV00000026', 'CN00000026', '2024-05-05', NULL, '0398860009', '456681425026', 'hokhanhgiang.26@giborcoffee.vn', 1),
    ('NV00000027', 1, N'Phạm Đức Đức', 'CV00000027', 'CN00000027', '2022-06-07', NULL, '0889913412', '889262019027', 'phamducduc.27@giborcoffee.vn', 1),
    ('NV00000028', 1, N'Nguyễn Quỳnh Quỳnh', 'CV00000028', 'CN00000028', '2023-07-09', NULL, '0335810056', '270937380028', 'nguyenquynhquynh.28@giborcoffee.vn', 1),
    ('NV00000029', 1, N'Nguyễn Gia Bảo', 'CV00000029', 'CN00000029', '2024-08-11', NULL, '0951343880', '141580226029', 'nguyengiabao.29@giborcoffee.vn', 1),
    ('NV00000030', 1, N'Nguyễn Quỳnh Nhung', 'CV00000030', 'CN00000030', '2022-09-13', NULL, '0829854548', '314289692030', 'nguyenquynhnhung.30@giborcoffee.vn', 1);
GO
INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCCCD, Email, TrangThai) VALUES
    ('NV00000031', 1, N'Đặng Công Đạt', 'CV00000031', 'CN00000031', '2023-10-15', NULL, '0846930359', '427696198031', 'dangcongdat.31@giborcoffee.vn', 1),
    ('NV00000032', 1, N'Nguyễn Phương Chi', 'CV00000032', 'CN00000032', '2024-11-17', NULL, '0329920292', '125409494032', 'nguyenphuongchi.32@giborcoffee.vn', 1),
    ('NV00000033', 1, N'Dương Minh Bình', 'CV00000033', 'CN00000033', '2022-12-19', NULL, '0353481198', '452468587033', 'duongminhbinh.33@giborcoffee.vn', 1),
    ('NV00000034', 1, N'Bùi Ngọc Vy', 'CV00000034', 'CN00000034', '2023-01-21', NULL, '0709317495', '930353157034', 'buingocvy.34@giborcoffee.vn', 1),
    ('NV00000035', 1, N'Dương Quốc Long', 'CV00000035', 'CN00000035', '2024-02-23', NULL, '0747130035', '788785773035', 'duongquoclong.35@giborcoffee.vn', 1),
    ('NV00000036', 1, N'Trần Quỳnh Hiền', 'CV00000036', 'CN00000036', '2022-03-25', NULL, '0891203377', '675757257036', 'tranquynhhien.36@giborcoffee.vn', 1),
    ('NV00000037', 1, N'Bùi Xuân Bảo', 'CV00000037', 'CN00000037', '2023-04-27', NULL, '0703704481', '223847257037', 'buixuanbao.37@giborcoffee.vn', 1),
    ('NV00000038', 1, N'Bùi Ngọc Ngân', 'CV00000038', 'CN00000038', '2024-05-04', NULL, '0723966966', '723403479038', 'buingocngan.38@giborcoffee.vn', 1),
    ('NV00000039', 1, N'Đỗ Xuân Thành', 'CV00000039', 'CN00000039', '2022-06-06', NULL, '0705134794', '216396351039', 'doxuanthanh.39@giborcoffee.vn', 1),
    ('NV00000040', 1, N'Đặng Bảo Hương', 'CV00000040', 'CN00000040', '2023-07-08', NULL, '0846397338', '882269302040', 'dangbaohuong.40@giborcoffee.vn', 1);
GO
INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCCCD, Email, TrangThai) VALUES
    ('NV00000041', 2, N'Phạm Gia Hiếu', 'CV00000041', 'CN00000041', '2024-08-10', NULL, '0758571795', '750911797041', 'phamgiahieu.41@giborcoffee.vn', 1),
    ('NV00000042', 2, N'Hoàng Mai Giang', 'CV00000042', 'CN00000042', '2022-09-12', NULL, '0951700055', '719106699042', 'hoangmaigiang.42@giborcoffee.vn', 1),
    ('NV00000043', 2, N'Đỗ Đức Nam', 'CV00000043', 'CN00000043', '2023-10-14', NULL, '0334188276', '147659674043', 'doducnam.43@giborcoffee.vn', 1),
    ('NV00000044', 2, N'Huỳnh Ngọc An', 'CV00000044', 'CN00000044', '2024-11-16', NULL, '0800226999', '658260221044', 'huynhngocan.44@giborcoffee.vn', 1),
    ('NV00000045', 2, N'Võ Xuân Thành', 'CV00000045', 'CN00000045', '2022-12-18', NULL, '0348884978', '563102056045', 'voxuanthanh.45@giborcoffee.vn', 1),
    ('NV00000046', 1, N'Trần Ngọc Quỳnh', 'CV00000046', 'CN00000046', '2023-01-20', NULL, '0989152472', '454549587046', 'tranngocquynh.46@giborcoffee.vn', 1),
    ('NV00000047', 1, N'Phạm Công Hùng', 'CV00000047', 'CN00000047', '2024-02-22', NULL, '0789038359', '233815413047', 'phamconghung.47@giborcoffee.vn', 1),
    ('NV00000048', 1, N'Lê Bảo Chi', 'CV00000048', 'CN00000048', '2022-03-24', NULL, '0768064830', '432091877048', 'lebaochi.48@giborcoffee.vn', 1),
    ('NV00000049', 1, N'Phạm Gia Khánh', 'CV00000049', 'CN00000049', '2023-04-26', NULL, '0843779528', '532074125049', 'phamgiakhanh.49@giborcoffee.vn', 1),
    ('NV00000050', 1, N'Lê Khánh Quỳnh', 'CV00000050', 'CN00000050', '2024-05-03', NULL, '0774411983', '236674237050', 'lekhanhquynh.50@giborcoffee.vn', 1);
GO

INSERT INTO dbo.TaiKhoanNhanVien (MaTK, MaNV) VALUES
    ('TK00000051', 'NV00000051'),
    ('TK00000052', 'NV00000052'),
    ('TK00000054', 'NV00000053'),
    ('TK00000055', 'NV00000054'),
    ('TK00000053', 'NV00000055')
GO

INSERT INTO dbo.TaiKhoanNhanVien (MaTK, MaNV) VALUES
    ('TK00000001', 'NV00000001'),
    ('TK00000002', 'NV00000002'),
    ('TK00000003', 'NV00000003'),
    ('TK00000004', 'NV00000004'),
    ('TK00000005', 'NV00000005'),
    ('TK00000006', 'NV00000006'),
    ('TK00000007', 'NV00000007'),
    ('TK00000008', 'NV00000008'),
    ('TK00000009', 'NV00000009'),
    ('TK00000010', 'NV00000010');
GO
INSERT INTO dbo.TaiKhoanNhanVien (MaTK, MaNV) VALUES
    ('TK00000011', 'NV00000011'),
    ('TK00000012', 'NV00000012'),
    ('TK00000013', 'NV00000013'),
    ('TK00000014', 'NV00000014'),
    ('TK00000015', 'NV00000015'),
    ('TK00000016', 'NV00000016'),
    ('TK00000017', 'NV00000017'),
    ('TK00000018', 'NV00000018'),
    ('TK00000019', 'NV00000019'),
    ('TK00000020', 'NV00000020');
GO
INSERT INTO dbo.TaiKhoanNhanVien (MaTK, MaNV) VALUES
    ('TK00000021', 'NV00000021'),
    ('TK00000022', 'NV00000022'),
    ('TK00000023', 'NV00000023'),
    ('TK00000024', 'NV00000024'),
    ('TK00000025', 'NV00000025'),
    ('TK00000026', 'NV00000026'),
    ('TK00000027', 'NV00000027'),
    ('TK00000028', 'NV00000028'),
    ('TK00000029', 'NV00000029'),
    ('TK00000030', 'NV00000030');
GO
INSERT INTO dbo.TaiKhoanNhanVien (MaTK, MaNV) VALUES
    ('TK00000031', 'NV00000031'),
    ('TK00000032', 'NV00000032'),
    ('TK00000033', 'NV00000033'),
    ('TK00000034', 'NV00000034'),
    ('TK00000035', 'NV00000035'),
    ('TK00000036', 'NV00000036'),
    ('TK00000037', 'NV00000037'),
    ('TK00000038', 'NV00000038'),
    ('TK00000039', 'NV00000039'),
    ('TK00000040', 'NV00000040');
GO
INSERT INTO dbo.TaiKhoanNhanVien (MaTK, MaNV) VALUES
    ('TK00000041', 'NV00000041'),
    ('TK00000042', 'NV00000042'),
    ('TK00000043', 'NV00000043'),
    ('TK00000044', 'NV00000044'),
    ('TK00000045', 'NV00000045'),
    ('TK00000046', 'NV00000046'),
    ('TK00000047', 'NV00000047'),
    ('TK00000048', 'NV00000048'),
    ('TK00000049', 'NV00000049'),
    ('TK00000050', 'NV00000050');
GO

INSERT INTO dbo.CaLamViec (MaCa, LoaiCa, TenCa, HeSoCa, GioBatDau, GioKetThuc) VALUES
    ('CA00000001', 1, N'Ca mở cửa 06:00-14:00', 1.00, '06:00:00', '14:00:00'),
    ('CA00000002', 1, N'Ca mở cửa 06:30-14:30', 1.00, '06:30:00', '14:30:00'),
    ('CA00000003', 1, N'Ca sáng 07:00-15:00', 1.00, '07:00:00', '15:00:00'),
    ('CA00000004', 1, N'Ca sáng 07:30-15:30', 1.00, '07:30:00', '15:30:00'),
    ('CA00000005', 1, N'Ca sáng 08:00-16:00', 1.00, '08:00:00', '16:00:00'),
    ('CA00000006', 1, N'Ca trưa 09:00-17:00', 1.05, '09:00:00', '17:00:00'),
    ('CA00000007', 1, N'Ca trưa 09:30-17:30', 1.05, '09:30:00', '17:30:00'),
    ('CA00000008', 1, N'Ca chiều 10:00-18:00', 1.05, '10:00:00', '18:00:00'),
    ('CA00000009', 1, N'Ca chiều 11:00-19:00', 1.08, '11:00:00', '19:00:00'),
    ('CA00000010', 1, N'Ca chiều 12:00-20:00', 1.08, '12:00:00', '20:00:00');
GO
INSERT INTO dbo.CaLamViec (MaCa, LoaiCa, TenCa, HeSoCa, GioBatDau, GioKetThuc) VALUES
    ('CA00000011', 1, N'Ca tối 13:00-21:00', 1.10, '13:00:00', '21:00:00'),
    ('CA00000012', 1, N'Ca tối 14:00-22:00', 1.10, '14:00:00', '22:00:00'),
    ('CA00000013', 1, N'Ca tối 15:00-23:00', 1.12, '15:00:00', '23:00:00'),
    ('CA00000014', 1, N'Ca cuối ngày 16:00-00:00', 1.15, '16:00:00', '00:00:00'),
    ('CA00000015', 1, N'Ca kiểm kê 22:00-06:00', 1.25, '22:00:00', '06:00:00'),
    ('CA00000016', 2, N'Ca part-time sáng 06:00-10:00', 1.00, '06:00:00', '10:00:00'),
    ('CA00000017', 2, N'Ca part-time sáng 07:00-11:00', 1.00, '07:00:00', '11:00:00'),
    ('CA00000018', 2, N'Ca part-time sáng 08:00-12:00', 1.00, '08:00:00', '12:00:00'),
    ('CA00000019', 2, N'Ca part-time trưa 09:00-13:00', 1.00, '09:00:00', '13:00:00'),
    ('CA00000020', 2, N'Ca part-time trưa 10:00-14:00', 1.00, '10:00:00', '14:00:00');
GO
INSERT INTO dbo.CaLamViec (MaCa, LoaiCa, TenCa, HeSoCa, GioBatDau, GioKetThuc) VALUES
    ('CA00000021', 2, N'Ca part-time trưa 11:00-15:00', 1.00, '11:00:00', '15:00:00'),
    ('CA00000022', 2, N'Ca part-time chiều 12:00-16:00', 1.03, '12:00:00', '16:00:00'),
    ('CA00000023', 2, N'Ca part-time chiều 13:00-17:00', 1.03, '13:00:00', '17:00:00'),
    ('CA00000024', 2, N'Ca part-time chiều 14:00-18:00', 1.05, '14:00:00', '18:00:00'),
    ('CA00000025', 2, N'Ca part-time chiều 15:00-19:00', 1.05, '15:00:00', '19:00:00'),
    ('CA00000026', 2, N'Ca part-time tối 16:00-20:00', 1.08, '16:00:00', '20:00:00'),
    ('CA00000027', 2, N'Ca part-time tối 17:00-21:00', 1.08, '17:00:00', '21:00:00'),
    ('CA00000028', 2, N'Ca part-time tối 18:00-22:00', 1.10, '18:00:00', '22:00:00'),
    ('CA00000029', 1, N'Ca cuối tuần sáng 06:00-14:00', 1.15, '06:00:00', '14:00:00'),
    ('CA00000030', 1, N'Ca cuối tuần sáng 07:00-15:00', 1.15, '07:00:00', '15:00:00');
GO
INSERT INTO dbo.CaLamViec (MaCa, LoaiCa, TenCa, HeSoCa, GioBatDau, GioKetThuc) VALUES
    ('CA00000031', 1, N'Ca cuối tuần trưa 09:00-17:00', 1.18, '09:00:00', '17:00:00'),
    ('CA00000032', 1, N'Ca cuối tuần tối 13:00-21:00', 1.20, '13:00:00', '21:00:00'),
    ('CA00000033', 1, N'Ca cuối tuần tối 14:00-22:00', 1.20, '14:00:00', '22:00:00'),
    ('CA00000034', 1, N'Ca lễ sáng 07:00-15:00', 1.35, '07:00:00', '15:00:00'),
    ('CA00000035', 1, N'Ca lễ chiều 12:00-20:00', 1.35, '12:00:00', '20:00:00'),
    ('CA00000036', 1, N'Ca lễ tối 14:00-22:00', 1.40, '14:00:00', '22:00:00'),
    ('CA00000037', 1, N'Ca event sáng 08:00-16:00', 1.20, '08:00:00', '16:00:00'),
    ('CA00000038', 1, N'Ca event chiều 12:00-20:00', 1.22, '12:00:00', '20:00:00'),
    ('CA00000039', 1, N'Ca giao hàng 07:00-15:00', 1.10, '07:00:00', '15:00:00'),
    ('CA00000040', 1, N'Ca giao hàng 10:00-18:00', 1.10, '10:00:00', '18:00:00');
GO
INSERT INTO dbo.CaLamViec (MaCa, LoaiCa, TenCa, HeSoCa, GioBatDau, GioKetThuc) VALUES
    ('CA00000041', 1, N'Ca giao hàng 14:00-22:00', 1.12, '14:00:00', '22:00:00'),
    ('CA00000042', 1, N'Ca bake sáng 05:00-13:00', 1.12, '05:00:00', '13:00:00'),
    ('CA00000043', 1, N'Ca bake trưa 10:00-18:00', 1.10, '10:00:00', '18:00:00'),
    ('CA00000044', 1, 'Ca QC 08:00-16:00', 1.18, '08:00:00', '16:00:00'),
    ('CA00000045', 1, 'Ca QC 13:00-21:00', 1.18, '13:00:00', '21:00:00'),
    ('CA00000046', 1, N'Ca kế toán 08:00-17:00', 1.00, '08:00:00', '17:00:00'),
    ('CA00000047', 1, N'Ca kế toán 09:00-18:00', 1.00, '09:00:00', '18:00:00'),
    ('CA00000048', 1, 'Ca CSKH 08:00-16:00', 1.02, '08:00:00', '16:00:00'),
    ('CA00000049', 1, 'Ca CSKH 12:00-20:00', 1.05, '12:00:00', '20:00:00'),
    ('CA00000050', 1, N'Ca trực kho đêm 21:00-05:00', 1.30, '21:00:00', '05:00:00');
GO

INSERT INTO dbo.NgayDacBiet (Ngay, TenNgay, HeSoLuong) VALUES
    ('2025-01-01', N'Tết Dương lịch 2025', 1.50),
    ('2025-01-28', N'Cận Tết âm lịch', 1.35),
    ('2025-01-29', N'Mùng 1 Tết âm lịch', 2.00),
    ('2025-01-30', N'Mùng 2 Tết âm lịch', 2.00),
    ('2025-01-31', N'Mùng 3 Tết âm lịch', 2.00),
    ('2025-04-30', N'Giải phóng miền Nam', 1.80),
    ('2025-05-01', N'Quốc tế Lao động', 1.80),
    ('2025-09-02', N'Quốc khánh', 1.80),
    ('2025-12-24', 'Noel Eve', 1.50),
    ('2025-12-25', N'Giáng Sinh', 1.60);
GO
INSERT INTO dbo.NgayDacBiet (Ngay, TenNgay, HeSoLuong) VALUES
    ('2025-12-31', N'Cuối năm 2025', 1.45),
    ('2026-01-01', N'Tết Dương lịch 2026', 1.50),
    ('2026-02-16', N'Mùng 1 Tết âm lịch 2026', 2.00),
    ('2026-02-17', N'Mùng 2 Tết âm lịch 2026', 2.00),
    ('2026-02-18', N'Mùng 3 Tết âm lịch 2026', 2.00),
    ('2026-04-30', N'Giải phóng miền Nam 2026', 1.80),
    ('2026-05-01', N'Quốc tế Lao động 2026', 1.80),
    ('2026-09-02', N'Quốc khánh 2026', 1.80),
    ('2026-12-24', 'Noel Eve 2026', 1.50),
    ('2026-12-25', N'Giáng Sinh 2026', 1.60);
GO
INSERT INTO dbo.NgayDacBiet (Ngay, TenNgay, HeSoLuong) VALUES
    ('2026-01-03', N'Cuối tuần cao điểm 01/2026', 1.25),
    ('2026-01-04', N'Cuối tuần cao điểm 01/2026', 1.30),
    ('2026-01-10', N'Cuối tuần cao điểm 01/2026', 1.25),
    ('2026-01-11', N'Cuối tuần cao điểm 01/2026', 1.30),
    ('2026-01-17', N'Cuối tuần cao điểm 01/2026', 1.25),
    ('2026-01-18', N'Cuối tuần cao điểm 01/2026', 1.30),
    ('2026-01-24', N'Cuối tuần cao điểm 01/2026', 1.25),
    ('2026-01-25', N'Cuối tuần cao điểm 01/2026', 1.30),
    ('2026-01-31', N'Cuối tuần cao điểm 01/2026', 1.25),
    ('2026-02-01', N'Cuối tuần cao điểm 02/2026', 1.30);
GO
INSERT INTO dbo.NgayDacBiet (Ngay, TenNgay, HeSoLuong) VALUES
    ('2026-02-07', N'Cuối tuần cao điểm 02/2026', 1.25),
    ('2026-02-08', N'Cuối tuần cao điểm 02/2026', 1.30),
    ('2026-02-14', N'Cuối tuần cao điểm 02/2026', 1.25),
    ('2026-02-15', N'Cuối tuần cao điểm 02/2026', 1.30),
    ('2026-02-21', N'Cuối tuần cao điểm 02/2026', 1.25),
    ('2026-02-22', N'Cuối tuần cao điểm 02/2026', 1.30),
    ('2026-02-28', N'Cuối tuần cao điểm 02/2026', 1.25),
    ('2026-03-01', N'Cuối tuần cao điểm 03/2026', 1.30),
    ('2026-03-07', N'Cuối tuần cao điểm 03/2026', 1.25),
    ('2026-03-08', N'Cuối tuần cao điểm 03/2026', 1.30);
GO
INSERT INTO dbo.NgayDacBiet (Ngay, TenNgay, HeSoLuong) VALUES
    ('2026-03-14', N'Cuối tuần cao điểm 03/2026', 1.25),
    ('2026-03-15', N'Cuối tuần cao điểm 03/2026', 1.30),
    ('2026-03-21', N'Cuối tuần cao điểm 03/2026', 1.25),
    ('2026-03-22', N'Cuối tuần cao điểm 03/2026', 1.30),
    ('2026-03-28', N'Cuối tuần cao điểm 03/2026', 1.25),
    ('2026-03-29', N'Cuối tuần cao điểm 03/2026', 1.30),
    ('2026-04-04', N'Cuối tuần cao điểm 04/2026', 1.25),
    ('2026-04-05', N'Cuối tuần cao điểm 04/2026', 1.30),
    ('2026-04-11', N'Cuối tuần cao điểm 04/2026', 1.25),
    ('2026-04-12', N'Cuối tuần cao điểm 04/2026', 1.30);
GO

INSERT INTO dbo.LichPhanCong (MaLich, MaNV, MaCa, NgayLamViec, TrangThai, GhiChu) VALUES
    ('LIC000000000001', 'NV00000001', 'CA00000016', '2026-01-03', N'Đã phân công', NULL),
    ('LIC000000000002', 'NV00000002', 'CA00000017', '2026-01-04', N'Đã phân công', NULL),
    ('LIC000000000003', 'NV00000003', 'CA00000018', '2026-01-10', N'Đã phân công', NULL),
    ('LIC000000000004', 'NV00000004', 'CA00000004', '2026-01-11', N'Đã phân công', NULL),
    ('LIC000000000005', 'NV00000005', 'CA00000005', '2026-01-17', N'Đã phân công', NULL),
    ('LIC000000000006', 'NV00000006', 'CA00000021', '2026-01-18', N'Đã phân công', NULL),
    ('LIC000000000007', 'NV00000007', 'CA00000022', '2026-01-24', N'Đã phân công', NULL),
    ('LIC000000000008', 'NV00000008', 'CA00000023', '2026-01-25', N'Đã phân công', NULL),
    ('LIC000000000009', 'NV00000009', 'CA00000024', '2026-01-31', N'Đã phân công', NULL),
    ('LIC000000000010', 'NV00000010', 'CA00000025', '2026-02-01', N'Đã phân công', NULL);
GO
INSERT INTO dbo.LichPhanCong (MaLich, MaNV, MaCa, NgayLamViec, TrangThai, GhiChu) VALUES
    ('LIC000000000011', 'NV00000011', 'CA00000011', '2026-02-07', N'Đã phân công', NULL),
    ('LIC000000000012', 'NV00000012', 'CA00000012', '2026-02-08', N'Đã phân công', NULL),
    ('LIC000000000013', 'NV00000013', 'CA00000013', '2026-02-14', N'Đã phân công', NULL),
    ('LIC000000000014', 'NV00000014', 'CA00000014', '2026-02-15', N'Đã phân công', NULL),
    ('LIC000000000015', 'NV00000015', 'CA00000015', '2026-02-21', N'Đã phân công', NULL),
    ('LIC000000000016', 'NV00000016', 'CA00000029', '2026-02-04', N'Đã phân công', NULL),
    ('LIC000000000017', 'NV00000017', 'CA00000030', '2026-02-06', N'Đã phân công', NULL),
    ('LIC000000000018', 'NV00000018', 'CA00000031', '2026-02-08', N'Đã phân công', NULL),
    ('LIC000000000019', 'NV00000019', 'CA00000032', '2026-02-10', N'Đã phân công', NULL),
    ('LIC000000000020', 'NV00000020', 'CA00000033', '2026-02-12', N'Đã phân công', NULL);
GO
INSERT INTO dbo.LichPhanCong (MaLich, MaNV, MaCa, NgayLamViec, TrangThai, GhiChu) VALUES
    ('LIC000000000021', 'NV00000021', 'CA00000034', '2026-02-14', N'Đã phân công', NULL),
    ('LIC000000000022', 'NV00000022', 'CA00000035', '2026-02-16', N'Đã phân công', NULL),
    ('LIC000000000023', 'NV00000023', 'CA00000036', '2026-02-18', N'Đã phân công', NULL),
    ('LIC000000000024', 'NV00000024', 'CA00000037', '2026-02-20', N'Đã phân công', NULL),
    ('LIC000000000025', 'NV00000025', 'CA00000038', '2026-02-22', N'Đã phân công', NULL),
    ('LIC000000000026', 'NV00000026', 'CA00000039', '2026-02-24', N'Đã phân công', NULL),
    ('LIC000000000027', 'NV00000027', 'CA00000040', '2026-02-26', N'Đã phân công', NULL),
    ('LIC000000000028', 'NV00000028', 'CA00000041', '2026-02-28', N'Đã phân công', NULL),
    ('LIC000000000029', 'NV00000029', 'CA00000042', '2026-03-02', N'Đã phân công', NULL),
    ('LIC000000000030', 'NV00000030', 'CA00000043', '2026-03-04', N'Đã phân công', NULL);
GO
INSERT INTO dbo.LichPhanCong (MaLich, MaNV, MaCa, NgayLamViec, TrangThai, GhiChu) VALUES
    ('LIC000000000031', 'NV00000031', 'CA00000044', '2026-03-06', N'Đã phân công', NULL),
    ('LIC000000000032', 'NV00000032', 'CA00000045', '2026-03-08', N'Đã phân công', NULL),
    ('LIC000000000033', 'NV00000033', 'CA00000046', '2026-03-10', N'Đã phân công', NULL),
    ('LIC000000000034', 'NV00000034', 'CA00000047', '2026-03-12', N'Đã phân công', NULL),
    ('LIC000000000035', 'NV00000035', 'CA00000048', '2026-03-14', N'Đã phân công', NULL),
    ('LIC000000000036', 'NV00000036', 'CA00000049', '2026-03-16', N'Đã phân công', NULL),
    ('LIC000000000037', 'NV00000037', 'CA00000050', '2026-03-18', N'Đã phân công', NULL),
    ('LIC000000000038', 'NV00000038', 'CA00000001', '2026-03-20', N'Đã phân công', NULL),
    ('LIC000000000039', 'NV00000039', 'CA00000002', '2026-03-22', N'Đã phân công', NULL),
    ('LIC000000000040', 'NV00000040', 'CA00000003', '2026-03-24', N'Đã phân công', NULL);
GO
INSERT INTO dbo.LichPhanCong (MaLich, MaNV, MaCa, NgayLamViec, TrangThai, GhiChu) VALUES
    ('LIC000000000041', 'NV00000041', 'CA00000017', '2026-01-05', N'Đã phân công', NULL),
    ('LIC000000000042', 'NV00000042', 'CA00000018', '2026-01-07', N'Đã phân công', NULL),
    ('LIC000000000043', 'NV00000043', 'CA00000019', '2026-01-09', N'Đã phân công', NULL),
    ('LIC000000000044', 'NV00000044', 'CA00000020', '2026-01-11', N'Đã phân công', NULL),
    ('LIC000000000045', 'NV00000045', 'CA00000021', '2026-01-13', N'Đã phân công', NULL),
    ('LIC000000000046', 'NV00000046', 'CA00000009', '2026-01-15', N'Đã phân công', NULL),
    ('LIC000000000047', 'NV00000047', 'CA00000010', '2026-01-17', N'Đã phân công', NULL),
    ('LIC000000000048', 'NV00000048', 'CA00000011', '2026-01-19', N'Đã phân công', NULL),
    ('LIC000000000049', 'NV00000049', 'CA00000012', '2026-01-21', N'Đã phân công', NULL),
    ('LIC000000000050', 'NV00000050', 'CA00000013', '2026-01-23', N'Đã phân công', NULL);
GO

IF OBJECT_ID(N'dbo.TRG_ChamCong_XuLy', N'TR') IS NOT NULL
    DISABLE TRIGGER dbo.TRG_ChamCong_XuLy ON dbo.ChamCong;
GO

INSERT INTO dbo.ChamCong (MaChamCong, MaNV, MaLich, GioVao, GioRa, TrangThai, HeSoNgay, HeSoCa, LuongThucTe) VALUES
    ('CC00000001', 'NV00000001', 'LIC000000000001', '2026-01-03T06:12:00', '2026-01-03T10:03:00', N'Đi muộn', 1.25, 1.00, 105875.00),
    ('CC00000002', 'NV00000002', 'LIC000000000002', '2026-01-04T07:13:00', '2026-01-04T11:06:00', N'Đi muộn', 1.30, 1.00, 126100.00),
    ('CC00000003', 'NV00000003', 'LIC000000000003', '2026-01-10T08:14:00', '2026-01-10T12:09:00', N'Đi muộn', 1.25, 1.00, 137200.00),
    ('CC00000004', 'NV00000004', 'LIC000000000004', '2026-01-11T07:45:00', '2026-01-11T15:42:00', N'Đi muộn', 1.30, 1.00, 320385.00),
    ('CC00000005', 'NV00000005', 'LIC000000000005', '2026-01-17T08:16:00', '2026-01-17T16:15:00', N'Đi muộn', 1.25, 1.00, 339150.00),
    ('CC00000006', 'NV00000006', 'LIC000000000006', '2026-01-18T11:17:00', '2026-01-18T15:02:00', N'Đi muộn', 1.30, 1.00, 112125.00),
    ('CC00000007', 'NV00000007', 'LIC000000000007', '2026-01-24T12:18:00', '2026-01-24T16:05:00', N'Đi muộn', 1.25, 1.03, 126535.50),
    ('CC00000008', 'NV00000008', 'LIC000000000008', '2026-01-25T13:19:00', '2026-01-25T17:08:00', N'Đi muộn', 1.30, 1.03, 148334.42),
    ('CC00000009', 'NV00000009', 'LIC000000000009', '2026-01-31T14:20:00', '2026-01-31T18:11:00', N'Đi muộn', 1.25, 1.05, 161700.00),
    ('CC00000010', 'NV00000010', 'LIC000000000010', '2026-02-01T15:11:00', '2026-02-01T19:14:00', N'Đi muộn', 1.30, 1.05, 193488.75);
GO
INSERT INTO dbo.ChamCong (MaChamCong, MaNV, MaLich, GioVao, GioRa, TrangThai, HeSoNgay, HeSoCa, LuongThucTe) VALUES
    ('CC00000011', 'NV00000011', 'LIC000000000011', '2026-02-07T13:12:00', '2026-02-07T21:01:00', N'Đi muộn', 1.25, 1.10, 322575.00),
    ('CC00000012', 'NV00000012', 'LIC000000000012', '2026-02-08T14:13:00', '2026-02-08T22:04:00', N'Đi muộn', 1.30, 1.10, 376054.25),
    ('CC00000013', 'NV00000013', 'LIC000000000013', '2026-02-14T15:14:00', '2026-02-14T23:07:00', N'Đi muộn', 1.25, 1.12, 408184.00),
    ('CC00000014', 'NV00000014', 'LIC000000000014', '2026-02-15T16:15:00', '2026-02-16T00:10:00', N'Đi muộn', 1.30, 1.15, 479536.20),
    ('CC00000015', 'NV00000015', 'LIC000000000015', '2026-02-21T22:16:00', '2026-02-22T06:13:00', N'Đi muộn', 1.25, 1.25, 546562.50),
    ('CC00000016', 'NV00000016', 'LIC000000000016', '2026-02-04T06:17:00', '2026-02-04T14:00:00', N'Đi muộn', 1.00, 1.15, 372876.00),
    ('CC00000017', 'NV00000017', 'LIC000000000017', '2026-02-06T07:18:00', '2026-02-06T15:03:00', N'Đi muộn', 1.00, 1.15, 409975.00),
    ('CC00000018', 'NV00000018', 'LIC000000000018', '2026-02-08T09:19:00', '2026-02-08T17:06:00', N'Đi muộn', 1.30, 1.18, 596726.00),
    ('CC00000019', 'NV00000019', 'LIC000000000019', '2026-02-10T13:20:00', '2026-02-10T21:09:00', N'Đi muộn', 1.00, 1.20, 506736.00),
    ('CC00000020', 'NV00000020', 'LIC000000000020', '2026-02-12T14:11:00', '2026-02-12T22:12:00', N'Đi muộn', 1.00, 1.20, 558192.00);
GO
INSERT INTO dbo.ChamCong (MaChamCong, MaNV, MaLich, GioVao, GioRa, TrangThai, HeSoNgay, HeSoCa, LuongThucTe) VALUES
    ('CC00000021', 'NV00000021', 'LIC000000000021', '2026-02-14T07:12:00', '2026-02-14T15:15:00', N'Đi muộn', 1.25, 1.35, 353193.75),
    ('CC00000022', 'NV00000022', 'LIC000000000022', '2026-02-16T12:13:00', '2026-02-16T20:02:00', N'Đi muộn', 2.00, 1.35, 601749.00),
    ('CC00000023', 'NV00000023', 'LIC000000000023', '2026-02-18T14:14:00', '2026-02-18T22:05:00', N'Đi muộn', 2.00, 1.40, 681380.00),
    ('CC00000024', 'NV00000024', 'LIC000000000024', '2026-02-20T08:15:00', '2026-02-20T16:08:00', N'Đi muộn', 1.00, 1.20, 316776.00),
    ('CC00000025', 'NV00000025', 'LIC000000000025', '2026-02-22T12:16:00', '2026-02-22T20:11:00', N'Đi muộn', 1.30, 1.22, 452200.32),
    ('CC00000026', 'NV00000026', 'LIC000000000026', '2026-02-24T07:17:00', '2026-02-24T15:14:00', N'Đi muộn', 1.00, 1.10, 218625.00),
    ('CC00000027', 'NV00000027', 'LIC000000000027', '2026-02-26T10:18:00', '2026-02-26T18:01:00', N'Đi muộn', 1.00, 1.10, 233530.00),
    ('CC00000028', 'NV00000028', 'LIC000000000028', '2026-02-28T14:19:00', '2026-02-28T22:04:00', N'Đi muộn', 1.25, 1.12, 325500.00),
    ('CC00000029', 'NV00000029', 'LIC000000000029', '2026-03-02T05:20:00', '2026-03-02T13:07:00', N'Đi muộn', 1.00, 1.12, 283192.00),
    ('CC00000030', 'NV00000030', 'LIC000000000030', '2026-03-04T10:11:00', '2026-03-04T18:10:00', N'Đi muộn', 1.00, 1.10, 307230.00);
GO
INSERT INTO dbo.ChamCong (MaChamCong, MaNV, MaLich, GioVao, GioRa, TrangThai, HeSoNgay, HeSoCa, LuongThucTe) VALUES
    ('CC00000031', 'NV00000031', 'LIC000000000031', '2026-03-06T08:12:00', '2026-03-06T16:13:00', N'Đi muộn', 1.00, 1.18, 302835.20),
    ('CC00000032', 'NV00000032', 'LIC000000000032', '2026-03-08T13:13:00', '2026-03-08T21:00:00', N'Đi muộn', 1.30, 1.18, 417708.20),
    ('CC00000033', 'NV00000033', 'LIC000000000033', '2026-03-10T08:14:00', '2026-03-10T17:03:00', N'Đi muộn', 1.00, 1.00, 335160.00),
    ('CC00000034', 'NV00000034', 'LIC000000000034', '2026-03-12T09:15:00', '2026-03-12T18:06:00', N'Đi muộn', 1.00, 1.00, 362850.00),
    ('CC00000035', 'NV00000035', 'LIC000000000035', '2026-03-14T08:16:00', '2026-03-14T16:09:00', N'Đi muộn', 1.25, 1.02, 442068.00),
    ('CC00000036', 'NV00000036', 'LIC000000000036', '2026-03-16T12:17:00', '2026-03-16T20:12:00', N'Đi muộn', 1.00, 1.05, 199584.00),
    ('CC00000037', 'NV00000037', 'LIC000000000037', '2026-03-18T21:18:00', '2026-03-19T05:15:00', N'Đi muộn', 1.00, 1.30, 273877.50),
    ('CC00000038', 'NV00000038', 'LIC000000000038', '2026-03-20T06:19:00', '2026-03-20T14:02:00', N'Đi muộn', 1.00, 1.00, 223880.00),
    ('CC00000039', 'NV00000039', 'LIC000000000039', '2026-03-22T06:50:00', '2026-03-22T14:35:00', N'Đi muộn', 1.30, 1.00, 317362.50),
    ('CC00000040', 'NV00000040', 'LIC000000000040', '2026-03-24T07:11:00', '2026-03-24T15:08:00', N'Đi muộn', 1.00, 1.00, 270300.00);
GO
INSERT INTO dbo.ChamCong (MaChamCong, MaNV, MaLich, GioVao, GioRa, TrangThai, HeSoNgay, HeSoCa, LuongThucTe) VALUES
    ('CC00000041', 'NV00000041', 'LIC000000000041', '2026-01-05T07:12:00', '2026-01-05T11:11:00', N'Đi muộn', 1.00, 1.00, 93530.00),
    ('CC00000042', 'NV00000042', 'LIC000000000042', '2026-01-07T08:13:00', '2026-01-07T12:14:00', N'Đi muộn', 1.00, 1.00, 104520.00),
    ('CC00000043', 'NV00000043', 'LIC000000000043', '2026-01-09T09:14:00', '2026-01-09T13:01:00', N'Đi muộn', 1.00, 1.00, 107730.00),
    ('CC00000044', 'NV00000044', 'LIC000000000044', '2026-01-11T10:15:00', '2026-01-11T14:04:00', N'Đi muộn', 1.30, 1.00, 153946.00),
    ('CC00000045', 'NV00000045', 'LIC000000000045', '2026-01-13T11:16:00', '2026-01-13T15:07:00', N'Đi muộn', 1.00, 1.00, 128975.00),
    ('CC00000046', 'NV00000046', 'LIC000000000046', '2026-01-15T11:17:00', '2026-01-15T19:10:00', N'Đi muộn', 1.00, 1.08, 263822.40),
    ('CC00000047', 'NV00000047', 'LIC000000000047', '2026-01-17T12:18:00', '2026-01-17T20:13:00', N'Đi muộn', 1.25, 1.08, 363528.00),
    ('CC00000048', 'NV00000048', 'LIC000000000048', '2026-01-19T13:19:00', '2026-01-19T21:00:00', N'Đi muộn', 1.00, 1.10, 312576.00),
    ('CC00000049', 'NV00000049', 'LIC000000000049', '2026-01-21T14:20:00', '2026-01-21T22:03:00', N'Đi muộn', 1.00, 1.10, 339680.00),
    ('CC00000050', 'NV00000050', 'LIC000000000050', '2026-01-23T15:11:00', '2026-01-23T23:06:00', N'Đi muộn', 1.00, 1.12, 381427.20);
GO

INSERT INTO dbo.PhatDiMuon (MaChamCong, MaNV, SoTien, NgayPhat) VALUES
    ('CC00000001', 'NV00000001', 30000.00, '2026-01-03'),
    ('CC00000002', 'NV00000002', 30000.00, '2026-01-04'),
    ('CC00000003', 'NV00000003', 30000.00, '2026-01-10'),
    ('CC00000004', 'NV00000004', 30000.00, '2026-01-11'),
    ('CC00000005', 'NV00000005', 30000.00, '2026-01-17'),
    ('CC00000006', 'NV00000006', 30000.00, '2026-01-18'),
    ('CC00000007', 'NV00000007', 30000.00, '2026-01-24'),
    ('CC00000008', 'NV00000008', 30000.00, '2026-01-25'),
    ('CC00000009', 'NV00000009', 30000.00, '2026-01-31'),
    ('CC00000010', 'NV00000010', 30000.00, '2026-02-01');
GO
INSERT INTO dbo.PhatDiMuon (MaChamCong, MaNV, SoTien, NgayPhat) VALUES
    ('CC00000011', 'NV00000011', 30000.00, '2026-02-07'),
    ('CC00000012', 'NV00000012', 30000.00, '2026-02-08'),
    ('CC00000013', 'NV00000013', 30000.00, '2026-02-14'),
    ('CC00000014', 'NV00000014', 30000.00, '2026-02-15'),
    ('CC00000015', 'NV00000015', 30000.00, '2026-02-21'),
    ('CC00000016', 'NV00000016', 30000.00, '2026-02-04'),
    ('CC00000017', 'NV00000017', 30000.00, '2026-02-06'),
    ('CC00000018', 'NV00000018', 30000.00, '2026-02-08'),
    ('CC00000019', 'NV00000019', 30000.00, '2026-02-10'),
    ('CC00000020', 'NV00000020', 30000.00, '2026-02-12');
GO
INSERT INTO dbo.PhatDiMuon (MaChamCong, MaNV, SoTien, NgayPhat) VALUES
    ('CC00000021', 'NV00000021', 30000.00, '2026-02-14'),
    ('CC00000022', 'NV00000022', 30000.00, '2026-02-16'),
    ('CC00000023', 'NV00000023', 30000.00, '2026-02-18'),
    ('CC00000024', 'NV00000024', 30000.00, '2026-02-20'),
    ('CC00000025', 'NV00000025', 30000.00, '2026-02-22'),
    ('CC00000026', 'NV00000026', 30000.00, '2026-02-24'),
    ('CC00000027', 'NV00000027', 30000.00, '2026-02-26'),
    ('CC00000028', 'NV00000028', 30000.00, '2026-02-28'),
    ('CC00000029', 'NV00000029', 30000.00, '2026-03-02'),
    ('CC00000030', 'NV00000030', 30000.00, '2026-03-04');
GO
INSERT INTO dbo.PhatDiMuon (MaChamCong, MaNV, SoTien, NgayPhat) VALUES
    ('CC00000031', 'NV00000031', 30000.00, '2026-03-06'),
    ('CC00000032', 'NV00000032', 30000.00, '2026-03-08'),
    ('CC00000033', 'NV00000033', 30000.00, '2026-03-10'),
    ('CC00000034', 'NV00000034', 30000.00, '2026-03-12'),
    ('CC00000035', 'NV00000035', 30000.00, '2026-03-14'),
    ('CC00000036', 'NV00000036', 30000.00, '2026-03-16'),
    ('CC00000037', 'NV00000037', 30000.00, '2026-03-18'),
    ('CC00000038', 'NV00000038', 30000.00, '2026-03-20'),
    ('CC00000039', 'NV00000039', 30000.00, '2026-03-22'),
    ('CC00000040', 'NV00000040', 30000.00, '2026-03-24');
GO
INSERT INTO dbo.PhatDiMuon (MaChamCong, MaNV, SoTien, NgayPhat) VALUES
    ('CC00000041', 'NV00000041', 30000.00, '2026-01-05'),
    ('CC00000042', 'NV00000042', 30000.00, '2026-01-07'),
    ('CC00000043', 'NV00000043', 30000.00, '2026-01-09'),
    ('CC00000044', 'NV00000044', 30000.00, '2026-01-11'),
    ('CC00000045', 'NV00000045', 30000.00, '2026-01-13'),
    ('CC00000046', 'NV00000046', 30000.00, '2026-01-15'),
    ('CC00000047', 'NV00000047', 30000.00, '2026-01-17'),
    ('CC00000048', 'NV00000048', 30000.00, '2026-01-19'),
    ('CC00000049', 'NV00000049', 30000.00, '2026-01-21'),
    ('CC00000050', 'NV00000050', 30000.00, '2026-01-23');
GO

IF OBJECT_ID(N'dbo.TRG_ChamCong_XuLy', N'TR') IS NOT NULL
    ENABLE TRIGGER dbo.TRG_ChamCong_XuLy ON dbo.ChamCong;
GO

INSERT INTO dbo.BangLuong (MaNV, Thang, Nam, TongGioThucTe, TongLuongCa, TongThuong, TongKhauTru, TrangThai) VALUES
    ('NV00000001', 3, 2026, 92.50, 2116400.00, 150000.00, 60000.00, N'Tạm tính'),
    ('NV00000002', 3, 2026, 99.00, 2623500.00, 200000.00, 90000.00, N'Tạm tính'),
    ('NV00000003', 3, 2026, 105.50, 3190320.00, 250000.00, 30000.00, N'Đã thanh toán'),
    ('NV00000004', 3, 2026, 190.00, 7068000.00, 1400000.00, 30000.00, N'Tạm tính'),
    ('NV00000005', 3, 2026, 195.50, 7178760.00, 900000.00, 60000.00, N'Tạm tính'),
    ('NV00000006', 3, 2026, 125.00, 3047500.00, 150000.00, 30000.00, N'Đã thanh toán'),
    ('NV00000007', 3, 2026, 86.00, 2414880.00, 200000.00, 60000.00, N'Tạm tính'),
    ('NV00000008', 3, 2026, 92.50, 2736150.00, 250000.00, 90000.00, N'Tạm tính'),
    ('NV00000009', 3, 2026, 99.00, 3294720.00, 300000.00, 30000.00, N'Đã thanh toán'),
    ('NV00000010', 3, 2026, 105.50, 3914050.00, 100000.00, 60000.00, N'Tạm tính');
GO
INSERT INTO dbo.BangLuong (MaNV, Thang, Nam, TongGioThucTe, TongLuongCa, TongThuong, TongKhauTru, TrangThai) VALUES
    ('NV00000011', 3, 2026, 184.50, 6143850.00, 900000.00, 120000.00, N'Tạm tính'),
    ('NV00000012', 3, 2026, 190.00, 7256100.00, 1100000.00, 30000.00, N'Đã thanh toán'),
    ('NV00000013', 3, 2026, 195.50, 8463195.00, 420000.00, 60000.00, N'Tạm tính'),
    ('NV00000014', 3, 2026, 201.00, 9768600.00, 540000.00, 90000.00, N'Tạm tính'),
    ('NV00000015', 3, 2026, 206.50, 9812880.00, 660000.00, 120000.00, N'Đã thanh toán'),
    ('NV00000016', 3, 2026, 168.00, 7832160.00, 950000.00, 30000.00, N'Tạm tính'),
    ('NV00000017', 3, 2026, 173.50, 9098340.00, 900000.00, 60000.00, N'Tạm tính'),
    ('NV00000018', 3, 2026, 179.00, 10471500.00, 300000.00, 90000.00, N'Đã thanh toán'),
    ('NV00000019', 3, 2026, 184.50, 11955600.00, 420000.00, 120000.00, N'Tạm tính'),
    ('NV00000020', 3, 2026, 190.00, 11901600.00, 800000.00, 30000.00, N'Tạm tính');
GO
INSERT INTO dbo.BangLuong (MaNV, Thang, Nam, TongGioThucTe, TongLuongCa, TongThuong, TongKhauTru, TrangThai) VALUES
    ('NV00000021', 3, 2026, 195.50, 5642130.00, 660000.00, 60000.00, N'Đã thanh toán'),
    ('NV00000022', 3, 2026, 201.00, 6530490.00, 780000.00, 90000.00, N'Tạm tính'),
    ('NV00000023', 3, 2026, 206.50, 7489755.00, 900000.00, 120000.00, N'Tạm tính'),
    ('NV00000024', 3, 2026, 168.00, 6753600.00, 1400000.00, 30000.00, N'Đã thanh toán'),
    ('NV00000025', 3, 2026, 173.50, 6745680.00, 420000.00, 60000.00, N'Tạm tính'),
    ('NV00000026', 2, 2026, 179.00, 4967250.00, 540000.00, 90000.00, N'Tạm tính'),
    ('NV00000027', 2, 2026, 184.50, 5784075.00, 660000.00, 120000.00, N'Đã thanh toán'),
    ('NV00000028', 2, 2026, 190.00, 6669000.00, 1250000.00, 30000.00, N'Tạm tính'),
    ('NV00000029', 2, 2026, 195.50, 7624500.00, 900000.00, 60000.00, N'Tạm tính'),
    ('NV00000030', 2, 2026, 201.00, 7597800.00, 300000.00, 90000.00, N'Đã thanh toán');
GO
INSERT INTO dbo.BangLuong (MaNV, Thang, Nam, TongGioThucTe, TongLuongCa, TongThuong, TongKhauTru, TrangThai) VALUES
    ('NV00000031', 2, 2026, 206.50, 7334880.00, 420000.00, 120000.00, N'Tạm tính'),
    ('NV00000032', 2, 2026, 168.00, 6703200.00, 1100000.00, 30000.00, N'Tạm tính'),
    ('NV00000033', 2, 2026, 173.50, 7713810.00, 660000.00, 60000.00, N'Đã thanh toán'),
    ('NV00000034', 2, 2026, 179.00, 8806800.00, 780000.00, 90000.00, N'Tạm tính'),
    ('NV00000035', 2, 2026, 184.50, 8767440.00, 900000.00, 120000.00, N'Tạm tính'),
    ('NV00000036', 2, 2026, 190.00, 5061600.00, 950000.00, 30000.00, N'Đã thanh toán'),
    ('NV00000037', 2, 2026, 195.50, 5906055.00, 420000.00, 60000.00, N'Tạm tính'),
    ('NV00000038', 2, 2026, 201.00, 6819930.00, 540000.00, 90000.00, N'Tạm tính'),
    ('NV00000039', 2, 2026, 206.50, 7805700.00, 660000.00, 120000.00, N'Đã thanh toán'),
    ('NV00000040', 2, 2026, 168.00, 6168960.00, 800000.00, 30000.00, N'Tạm tính');
GO
INSERT INTO dbo.BangLuong (MaNV, Thang, Nam, TongGioThucTe, TongLuongCa, TongThuong, TongKhauTru, TrangThai) VALUES
    ('NV00000041', 2, 2026, 125.00, 3055000.00, 150000.00, 90000.00, N'Tạm tính'),
    ('NV00000042', 2, 2026, 86.00, 2370160.00, 200000.00, 30000.00, N'Đã thanh toán'),
    ('NV00000043', 2, 2026, 92.50, 2847150.00, 250000.00, 60000.00, N'Tạm tính'),
    ('NV00000044', 2, 2026, 99.00, 3130380.00, 300000.00, 90000.00, N'Tạm tính'),
    ('NV00000045', 2, 2026, 105.50, 3675620.00, 100000.00, 30000.00, N'Đã thanh toán'),
    ('NV00000046', 2, 2026, 201.00, 6916410.00, 780000.00, 210000.00, N'Tạm tính'),
    ('NV00000047', 2, 2026, 206.50, 8003940.00, 900000.00, 240000.00, N'Tạm tính'),
    ('NV00000048', 2, 2026, 168.00, 7272720.00, 1250000.00, 150000.00, N'Đã thanh toán'),
    ('NV00000049', 2, 2026, 173.50, 8328000.00, 420000.00, 180000.00, N'Tạm tính'),
    ('NV00000050', 2, 2026, 179.00, 8312760.00, 540000.00, 210000.00, N'Tạm tính');
GO

-- =============================================
-- PHẦN 8: DANH MỤC VÀ SẢN PHẨM
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'PHẦN 8: THÊM DANH MỤC VÀ SẢN PHẨM';
PRINT '========================================';
GO

-- =============================================
-- BƯỚC 1: Thêm 5 danh mục
-- =============================================
PRINT '';
PRINT 'BƯỚC 1: Thêm 5 danh mục...';

INSERT INTO dbo.DanhMuc (MaDanhMuc, TenDanhMuc, MoTa) VALUES
('DM00000001', N'Cà phê', N'Các loại cà phê truyền thống và hiện đại'),
('DM00000002', N'Trà & Trà sữa', N'Trà các loại và trà sữa'),
('DM00000003', N'Đá xay', N'Các món đá xay, smoothie'),
('DM00000004', N'Bánh & Snack', N'Bánh ngọt, bánh mặn, snack'),
('DM00000005', N'Nước ép & Soda', N'Nước ép trái cây và soda');

PRINT '  ✓ Đã thêm 5 danh mục';
GO

-- =============================================
-- BƯỚC 2: Thêm 50 sản phẩm
-- =============================================
PRINT '';
PRINT 'BƯỚC 2: Thêm 50 sản phẩm...';

-- Cà phê (15 món)
INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
('SP00000001', 'DM00000001', N'Cà phê đen đá', 25000, 1, N'Cà phê đen truyền thống'),
('SP00000002', 'DM00000001', N'Cà phê sữa đá', 28000, 1, N'Cà phê sữa đá'),
('SP00000003', 'DM00000001', N'Bạc xỉu', 30000, 1, N'Cà phê sữa nhiều sữa'),
('SP00000004', 'DM00000001', N'Cà phê đen nóng', 25000, 1, N'Cà phê đen nóng'),
('SP00000005', 'DM00000001', N'Cà phê sữa nóng', 28000, 1, N'Cà phê sữa nóng'),
('SP00000006', 'DM00000001', N'Espresso', 30000, 1, N'Cà phê Espresso đậm đà'),
('SP00000007', 'DM00000001', N'Americano', 32000, 1, N'Cà phê Americano'),
('SP00000008', 'DM00000001', N'Cappuccino', 38000, 1, N'Cappuccino với bọt sữa'),
('SP00000009', 'DM00000001', N'Latte', 40000, 1, N'Cà phê Latte'),
('SP00000010', 'DM00000001', N'Mocha', 42000, 1, N'Cà phê Mocha socola'),
('SP00000011', 'DM00000001', N'Caramel Macchiato', 45000, 1, N'Macchiato caramel'),
('SP00000012', 'DM00000001', N'Cà phê dừa', 38000, 1, N'Cà phê dừa mát lạnh'),
('SP00000013', 'DM00000001', N'Cà phê trứng', 40000, 1, N'Cà phê trứng Hà Nội'),
('SP00000014', 'DM00000001', N'Cà phê muối', 38000, 1, N'Cà phê muối độc đáo'),
('SP00000015', 'DM00000001', N'Cold Brew', 42000, 1, N'Cà phê ủ lạnh');

-- Trà & Trà sữa (12 món)
INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
('SP00000016', 'DM00000002', N'Trà đào cam sả', 35000, 1, N'Trà đào cam sả'),
('SP00000017', 'DM00000002', N'Trà vải', 32000, 1, N'Trà vải thanh mát'),
('SP00000018', 'DM00000002', N'Trà chanh', 30000, 1, N'Trà chanh tươi'),
('SP00000019', 'DM00000002', N'Trà sữa truyền thống', 35000, 1, N'Trà sữa truyền thống'),
('SP00000020', 'DM00000002', N'Trà sữa trân châu đường đen', 40000, 1, N'Trà sữa trân châu'),
('SP00000021', 'DM00000002', N'Trà sữa matcha', 42000, 1, N'Trà sữa matcha Nhật'),
('SP00000022', 'DM00000002', N'Trà sữa socola', 40000, 1, N'Trà sữa socola'),
('SP00000023', 'DM00000002', N'Trà sữa dâu tây', 42000, 1, N'Trà sữa dâu tây'),
('SP00000024', 'DM00000002', N'Hồng trà sữa', 38000, 1, N'Hồng trà sữa'),
('SP00000025', 'DM00000002', N'Ô long sữa', 38000, 1, N'Trà ô long sữa'),
('SP00000026', 'DM00000002', N'Trà xanh latte', 40000, 1, N'Trà xanh latte'),
('SP00000027', 'DM00000002', N'Trà sen vàng', 35000, 1, N'Trà sen vàng');

-- Đá xay (10 món)
INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
('SP00000028', 'DM00000003', N'Đá xay cà phê', 45000, 1, N'Đá xay cà phê'),
('SP00000029', 'DM00000003', N'Đá xay matcha', 48000, 1, N'Đá xay matcha'),
('SP00000030', 'DM00000003', N'Đá xay socola', 45000, 1, N'Đá xay socola'),
('SP00000031', 'DM00000003', N'Đá xay dâu tây', 48000, 1, N'Đá xay dâu tây'),
('SP00000032', 'DM00000003', N'Đá xay xoài', 48000, 1, N'Đá xay xoài'),
('SP00000033', 'DM00000003', N'Đá xay việt quất', 50000, 1, N'Đá xay việt quất'),
('SP00000034', 'DM00000003', N'Đá xay cookies & cream', 50000, 1, N'Đá xay cookies'),
('SP00000035', 'DM00000003', N'Đá xay caramel', 48000, 1, N'Đá xay caramel'),
('SP00000036', 'DM00000003', N'Smoothie bơ', 50000, 1, N'Smoothie bơ'),
('SP00000037', 'DM00000003', N'Smoothie dưa hấu', 45000, 1, N'Smoothie dưa hấu');

-- Bánh & Snack (8 món - chỉ 1 size)
INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
('SP00000038', 'DM00000004', N'Bánh croissant bơ', 25000, 1, N'Bánh croissant'),
('SP00000039', 'DM00000004', N'Bánh mì que', 15000, 1, N'Bánh mì que giòn'),
('SP00000040', 'DM00000004', N'Tiramisu', 35000, 1, N'Bánh Tiramisu Ý'),
('SP00000041', 'DM00000004', N'Cheesecake dâu', 40000, 1, N'Cheesecake dâu'),
('SP00000042', 'DM00000004', N'Brownie socola', 30000, 1, N'Brownie socola'),
('SP00000043', 'DM00000004', N'Bánh flan', 20000, 1, N'Bánh flan'),
('SP00000044', 'DM00000004', N'Mousse chanh dây', 35000, 1, N'Mousse chanh dây'),
('SP00000045', 'DM00000004', N'Bánh bông lan trứng muối', 28000, 1, N'Bông lan trứng muối');

-- Nước ép & Soda (5 món)
INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
('SP00000046', 'DM00000005', N'Nước ép cam', 35000, 1, N'Nước ép cam tươi'),
('SP00000047', 'DM00000005', N'Nước ép dưa hấu', 32000, 1, N'Nước ép dưa hấu'),
('SP00000048', 'DM00000005', N'Nước ép táo', 35000, 1, N'Nước ép táo'),
('SP00000049', 'DM00000005', N'Soda chanh', 28000, 1, N'Soda chanh'),
('SP00000050', 'DM00000005', N'Soda việt quất', 30000, 1, N'Soda việt quất');

PRINT '  ✓ Đã thêm 50 sản phẩm';
GO

-- =============================================
-- BƯỚC 3: Thêm biến thể (size)
-- =============================================
PRINT '';
PRINT 'BƯỚC 3: Thêm biến thể size...';

-- Biến thể cho đồ uống (SP00000001-SP00000037, SP00000046-SP00000050) - 3 size
DECLARE @MaSP CHAR(10);
DECLARE @Counter INT = 1;
DECLARE @BienTheCounter INT = 1;

WHILE @Counter <= 50
BEGIN
    SET @MaSP = 'SP' + RIGHT('00000000' + CAST(@Counter AS VARCHAR(8)), 8);
    
    -- Bỏ qua bánh (SP00000038-SP00000045)
    IF @Counter NOT BETWEEN 38 AND 45
    BEGIN
        -- Size Nhỏ
        INSERT INTO dbo.BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai)
        VALUES ('BT' + RIGHT('00000000' + CAST(@BienTheCounter AS VARCHAR(8)), 8), @MaSP, N'Nhỏ', 0, 1);
        SET @BienTheCounter = @BienTheCounter + 1;
        
        -- Size Vừa
        INSERT INTO dbo.BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai)
        VALUES ('BT' + RIGHT('00000000' + CAST(@BienTheCounter AS VARCHAR(8)), 8), @MaSP, N'Vừa', 5000, 1);
        SET @BienTheCounter = @BienTheCounter + 1;
        
        -- Size Lớn
        INSERT INTO dbo.BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai)
        VALUES ('BT' + RIGHT('00000000' + CAST(@BienTheCounter AS VARCHAR(8)), 8), @MaSP, N'Lớn', 10000, 1);
        SET @BienTheCounter = @BienTheCounter + 1;
    END
    ELSE
    BEGIN
        -- Bánh chỉ có 1 size
        INSERT INTO dbo.BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai)
        VALUES ('BT' + RIGHT('00000000' + CAST(@BienTheCounter AS VARCHAR(8)), 8), @MaSP, N'Vừa', 0, 1);
        SET @BienTheCounter = @BienTheCounter + 1;
    END
    
    SET @Counter = @Counter + 1;
END

PRINT '  ✓ Đã thêm biến thể (42 món × 3 size + 8 món × 1 size = 134 biến thể)';
GO

-- =============================================
-- BƯỚC 4: Đồng bộ sản phẩm vào chi nhánh
-- =============================================
PRINT '';
PRINT 'BƯỚC 4: Đồng bộ sản phẩm vào tất cả chi nhánh...';

EXEC dbo.sp_DongBoTatCaSanPham;
GO

-- =============================================
-- BƯỚC 5: Kiểm tra kết quả
-- =============================================
PRINT '';
PRINT 'BƯỚC 5: Kiểm tra kết quả...';

DECLARE @TongDanhMuc INT, @TongSanPham INT, @TongBienThe INT, @TongMenuChiNhanh INT, @TongChiNhanh INT;

SELECT @TongDanhMuc = COUNT(*) FROM dbo.DanhMuc;
SELECT @TongSanPham = COUNT(*) FROM dbo.SanPham;
SELECT @TongBienThe = COUNT(*) FROM dbo.BienTheSanPham;
SELECT @TongChiNhanh = COUNT(*) FROM dbo.ChiNhanh WHERE TrangThai = 1;
SELECT @TongMenuChiNhanh = COUNT(*) FROM dbo.SanPham_ChiNhanh;

PRINT '';
PRINT '   Thống kê:';
PRINT '     - Tổng danh mục: ' + CAST(@TongDanhMuc AS NVARCHAR(10)) + ' (mong đợi: 5)';
PRINT '     - Tổng sản phẩm: ' + CAST(@TongSanPham AS NVARCHAR(10)) + ' (mong đợi: 50)';
PRINT '     - Tổng biến thể: ' + CAST(@TongBienThe AS NVARCHAR(10)) + ' (mong đợi: 134)';
PRINT '     - Tổng chi nhánh: ' + CAST(@TongChiNhanh AS NVARCHAR(10));
PRINT '     - Tổng menu chi nhánh: ' + CAST(@TongMenuChiNhanh AS NVARCHAR(10)) + ' (mong đợi: ' + CAST(@TongSanPham * @TongChiNhanh AS NVARCHAR(10)) + ')';

PRINT '';
IF @TongDanhMuc = 5 AND @TongSanPham = 50 AND @TongBienThe = 134
BEGIN
    PRINT '   HOÀN HẢO! Dữ liệu đã được cập nhật thành công!';
END
ELSE
BEGIN
    PRINT '    Cảnh báo: Số lượng không khớp với mong đợi.';
END

-- Hiển thị thống kê theo danh mục
PRINT '';
PRINT '   Thống kê theo danh mục:';
SELECT 
    dm.TenDanhMuc,
    COUNT(sp.MaSanPham) AS SoLuongSanPham
FROM dbo.DanhMuc dm
LEFT JOIN dbo.SanPham sp ON dm.MaDanhMuc = sp.MaDanhMuc
GROUP BY dm.MaDanhMuc, dm.TenDanhMuc
ORDER BY dm.MaDanhMuc;

PRINT '';
PRINT '========================================';
PRINT ' HOÀN THÀNH THÊM DANH MỤC VÀ SẢN PHẨM';
PRINT '========================================';
GO

-- =============================================
-- PHẦN 9: DỮ LIỆU BỔ SUNG
-- =============================================

-- =============================================
-- BƯỚC 1: Thêm 50 khách hàng
-- =============================================
PRINT '';
PRINT 'PHẦN 9: Thêm dữ liệu bổ sung...';
PRINT 'Thêm 50 khách hàng...';

INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0001', N'Nguyễn Văn An', '0901234567', 150),
    ('KH0002', N'Trần Thị Bình', '0902345678', 280),
    ('KH0003', N'Lê Hoàng Cường', '0903456789', 420),
    ('KH0004', N'Phạm Thị Dung', '0904567890', 95),
    ('KH0005', N'Hoàng Văn Em', '0905678901', 310),
    ('KH0006', N'Đặng Thị Phương', '0906789012', 560),
    ('KH0007', N'Vũ Văn Giang', '0907890123', 180),
    ('KH0008', N'Bùi Thị Hà', '0908901234', 720),
    ('KH0009', N'Đỗ Văn Hùng', '0909012345', 240),
    ('KH0010', N'Ngô Thị Lan', '0910123456', 890);
GO

INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0011', N'Phan Văn Khoa', '0911234567', 125),
    ('KH0012', N'Lý Thị Linh', '0912345678', 340),
    ('KH0013', N'Trương Văn Minh', '0913456789', 470),
    ('KH0014', N'Võ Thị Nga', '0914567890', 210),
    ('KH0015', N'Đinh Văn Phúc', '0915678901', 580),
    ('KH0016', N'Mai Thị Quỳnh', '0916789012', 390),
    ('KH0017', N'Dương Văn Sơn', '0917890123', 650),
    ('KH0018', N'Tô Thị Tâm', '0918901234', 170),
    ('KH0019', N'Lâm Văn Tùng', '0919012345', 820),
    ('KH0020', N'Hồ Thị Uyên', '0920123456', 290);
GO

INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0021', N'Cao Văn Vinh', '0921234567', 440),
    ('KH0022', N'Huỳnh Thị Xuân', '0922345678', 510),
    ('KH0023', N'Tạ Văn Yên', '0923456789', 195),
    ('KH0024', N'Lưu Thị Ánh', '0924567890', 670),
    ('KH0025', N'Hà Văn Bảo', '0925678901', 320),
    ('KH0026', N'Đoàn Thị Chi', '0926789012', 750),
    ('KH0027', N'Trịnh Văn Đức', '0927890123', 230),
    ('KH0028', N'Ông Thị Hoa', '0928901234', 880),
    ('KH0029', N'Tăng Văn Khang', '0929012345', 360),
    ('KH0030', N'Quách Thị Loan', '0930123456', 490);
GO

INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0031', N'Nghiêm Văn Nam', '0931234567', 610),
    ('KH0032', N'Ứng Thị Oanh', '0932345678', 140),
    ('KH0033', N'Từ Văn Phong', '0933456789', 790),
    ('KH0034', N'Lục Thị Quế', '0934567890', 270),
    ('KH0035', N'Bạch Văn Sáng', '0935678901', 530),
    ('KH0036', N'Thái Thị Thảo', '0936789012', 410),
    ('KH0037', N'Khương Văn Tuấn', '0937890123', 690),
    ('KH0038', N'Ân Thị Vân', '0938901234', 200),
    ('KH0039', N'Lạc Văn Xuân', '0939012345', 840),
    ('KH0040', N'Mạc Thị Yến', '0940123456', 310);
GO

INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0041', N'Gia Văn An', '0941234567', 460),
    ('KH0042', N'Kiều Thị Bích', '0942345678', 570),
    ('KH0043', N'Lương Văn Cường', '0943456789', 220),
    ('KH0044', N'Mã Thị Diệu', '0944567890', 710),
    ('KH0045', N'Nhữ Văn Hải', '0945678901', 350),
    ('KH0046', N'Ô Thị Khánh', '0946789012', 620),
    ('KH0047', N'Phùng Văn Long', '0947890123', 180),
    ('KH0048', N'Quang Thị Mai', '0948901234', 770),
    ('KH0049', N'Sử Văn Nhân', '0949012345', 390),
    ('KH0050', N'Thi Thị Phương', '0950123456', 540);
GO

PRINT '  ✓ Đã thêm 50 khách hàng';
GO

-- =============================================
-- BƯỚC 2: Thêm 50 ngày đặc biệt
-- =============================================
PRINT 'Thêm 50 ngày đặc biệt...';

-- Đã có 50 ngày đặc biệt từ dòng 2581-2640
-- Không cần thêm nữa

PRINT '  ✓ Đã có 50 ngày đặc biệt';
GO

PRINT '';
PRINT '========================================';
PRINT ' HOÀN THÀNH THÊM DỮ LIỆU BỔ SUNG';
PRINT '========================================';
GO

-- =============================================
-- PHẦN 10: THÊM DỮ LIỆU ĐƠN HÀNG
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'PHẦN 10: THÊM DỮ LIỆU ĐƠN HÀNG';
PRINT '========================================';
GO

-- Tắt trigger để tránh tính toán tự động
IF OBJECT_ID(N'dbo.TRG_ChiTietDonHang_CapNhatTongTien', N'TR') IS NOT NULL
    DISABLE TRIGGER dbo.TRG_ChiTietDonHang_CapNhatTongTien ON dbo.ChiTietDonHang;
GO

IF OBJECT_ID(N'dbo.TRG_DonHang_CapNhatDiem', N'TR') IS NOT NULL
    DISABLE TRIGGER dbo.TRG_DonHang_CapNhatDiem ON dbo.DonHang;
GO

-- Dữ liệu đơn hàng mẫu được gắn với NV00000055/CN00000001 để tài khoản demo
-- NHÂN VIÊN tranduonggiabao / 123123 nhìn thấy dữ liệu cũ ngay sau khi chạy script.
-- Đơn hàng 1-10
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGiaThuCong, DiemSuDung, TienGiamTuDiem, GiamGia, DiemCong, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH00000001', 'CN00000001', 'NV00000055', 'KH0001', 125000, 0, 0, 0, 0, dbo.fn_TinhDiemTichLuyDonHang(125000 - 0), N'Tiền mặt', N'Hoàn tất', '2026-05-01T08:30:00'),
    ('DH00000002', 'CN00000001', 'NV00000055', 'KH0002', 280000, 20000, 0, 0, 20000, dbo.fn_TinhDiemTichLuyDonHang(280000 - 20000), N'Thẻ', N'Hoàn tất', '2026-05-01T09:15:00'),
    ('DH00000003', 'CN00000001', 'NV00000055', 'KH0003', 450000, 50000, 0, 0, 50000, dbo.fn_TinhDiemTichLuyDonHang(450000 - 50000), N'QR', N'Hoàn tất', '2026-05-01T10:20:00'),
    ('DH00000004', 'CN00000001', 'NV00000055', 'KH0004', 95000, 0, 0, 0, 0, dbo.fn_TinhDiemTichLuyDonHang(95000 - 0), N'QR', N'Hoàn tất', '2026-05-01T11:45:00'),
    ('DH00000005', 'CN00000001', 'NV00000055', 'KH0005', 320000, 30000, 0, 0, 30000, dbo.fn_TinhDiemTichLuyDonHang(320000 - 30000), N'QR', N'Hoàn tất', '2026-05-01T13:10:00'),
    ('DH00000006', 'CN00000001', 'NV00000055', 'KH0006', 580000, 80000, 0, 0, 80000, dbo.fn_TinhDiemTichLuyDonHang(580000 - 80000), N'Tiền mặt', N'Hoàn tất', '2026-05-01T14:25:00'),
    ('DH00000007', 'CN00000001', 'NV00000055', 'KH0007', 180000, 0, 0, 0, 0, dbo.fn_TinhDiemTichLuyDonHang(180000 - 0), N'Thẻ', N'Hoàn tất', '2026-05-01T15:40:00'),
    ('DH00000008', 'CN00000001', 'NV00000055', 'KH0008', 750000, 100000, 0, 0, 100000, dbo.fn_TinhDiemTichLuyDonHang(750000 - 100000), N'QR', N'Hoàn tất', '2026-05-01T16:55:00'),
    ('DH00000009', 'CN00000001', 'NV00000055', 'KH0009', 240000, 0, 0, 0, 0, dbo.fn_TinhDiemTichLuyDonHang(240000 - 0), N'QR', N'Hoàn tất', '2026-05-02T08:10:00'),
    ('DH00000010', 'CN00000001', 'NV00000055', 'KH0010', 920000, 120000, 0, 0, 120000, dbo.fn_TinhDiemTichLuyDonHang(920000 - 120000), N'QR', N'Hoàn tất', '2026-05-02T09:25:00');
GO

-- Đơn hàng 11-20
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGiaThuCong, DiemSuDung, TienGiamTuDiem, GiamGia, DiemCong, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH00000011', 'CN00000001', 'NV00000055', 'KH0011', 135000, 10000, 0, 0, 10000, dbo.fn_TinhDiemTichLuyDonHang(135000 - 10000), N'Tiền mặt', N'Hoàn tất', '2026-05-02T10:40:00'),
    ('DH00000012', 'CN00000001', 'NV00000055', 'KH0012', 360000, 40000, 0, 0, 40000, dbo.fn_TinhDiemTichLuyDonHang(360000 - 40000), N'Thẻ', N'Hoàn tất', '2026-05-02T11:55:00'),
    ('DH00000013', 'CN00000001', 'NV00000055', 'KH0013', 490000, 60000, 0, 0, 60000, dbo.fn_TinhDiemTichLuyDonHang(490000 - 60000), N'QR', N'Hoàn tất', '2026-05-02T13:10:00'),
    ('DH00000014', 'CN00000001', 'NV00000055', 'KH0014', 210000, 0, 0, 0, 0, dbo.fn_TinhDiemTichLuyDonHang(210000 - 0), N'QR', N'Hoàn tất', '2026-05-02T14:25:00'),
    ('DH00000015', 'CN00000001', 'NV00000055', 'KH0015', 600000, 70000, 0, 0, 70000, dbo.fn_TinhDiemTichLuyDonHang(600000 - 70000), N'QR', N'Hoàn tất', '2026-05-02T15:40:00'),
    ('DH00000016', 'CN00000001', 'NV00000055', 'KH0016', 410000, 50000, 0, 0, 50000, dbo.fn_TinhDiemTichLuyDonHang(410000 - 50000), N'Tiền mặt', N'Hoàn tất', '2026-05-02T16:55:00'),
    ('DH00000017', 'CN00000001', 'NV00000055', 'KH0017', 680000, 90000, 0, 0, 90000, dbo.fn_TinhDiemTichLuyDonHang(680000 - 90000), N'Thẻ', N'Hoàn tất', '2026-05-03T08:10:00'),
    ('DH00000018', 'CN00000001', 'NV00000055', 'KH0018', 170000, 0, 0, 0, 0, dbo.fn_TinhDiemTichLuyDonHang(170000 - 0), N'QR', N'Hoàn tất', '2026-05-03T09:25:00'),
    ('DH00000019', 'CN00000001', 'NV00000055', 'KH0019', 850000, 110000, 0, 0, 110000, dbo.fn_TinhDiemTichLuyDonHang(850000 - 110000), N'QR', N'Hoàn tất', '2026-05-03T10:40:00'),
    ('DH00000020', 'CN00000001', 'NV00000055', 'KH0020', 300000, 30000, 0, 0, 30000, dbo.fn_TinhDiemTichLuyDonHang(300000 - 30000), N'QR', N'Hoàn tất', '2026-05-03T11:55:00');
GO

-- Đơn hàng 21-30
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGiaThuCong, DiemSuDung, TienGiamTuDiem, GiamGia, DiemCong, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH00000021', 'CN00000001', 'NV00000055', 'KH0021', 540000, 60000, 0, 0, 60000, dbo.fn_TinhDiemTichLuyDonHang(540000 - 60000), N'Tiền mặt', N'Hoàn tất', '2026-05-03T13:10:00'),
    ('DH00000022', 'CN00000001', 'NV00000055', 'KH0022', 220000, 20000, 0, 0, 20000, dbo.fn_TinhDiemTichLuyDonHang(220000 - 20000), N'Thẻ', N'Hoàn tất', '2026-05-03T14:25:00'),
    ('DH00000023', 'CN00000001', 'NV00000055', 'KH0023', 780000, 100000, 0, 0, 100000, dbo.fn_TinhDiemTichLuyDonHang(780000 - 100000), N'QR', N'Hoàn tất', '2026-05-03T15:40:00'),
    ('DH00000024', 'CN00000001', 'NV00000055', 'KH0024', 390000, 40000, 0, 0, 40000, dbo.fn_TinhDiemTichLuyDonHang(390000 - 40000), N'QR', N'Hoàn tất', '2026-05-03T16:55:00'),
    ('DH00000025', 'CN00000001', 'NV00000055', 'KH0025', 650000, 80000, 0, 0, 80000, dbo.fn_TinhDiemTichLuyDonHang(650000 - 80000), N'QR', N'Hoàn tất', '2026-05-04T08:10:00'),
    ('DH00000026', 'CN00000001', 'NV00000055', 'KH0026', 270000, 30000, 0, 0, 30000, dbo.fn_TinhDiemTichLuyDonHang(270000 - 30000), N'Tiền mặt', N'Hoàn tất', '2026-05-04T09:25:00'),
    ('DH00000027', 'CN00000001', 'NV00000055', 'KH0027', 890000, 110000, 0, 0, 110000, dbo.fn_TinhDiemTichLuyDonHang(890000 - 110000), N'Thẻ', N'Hoàn tất', '2026-05-04T10:40:00'),
    ('DH00000028', 'CN00000001', 'NV00000055', 'KH0028', 430000, 50000, 0, 0, 50000, dbo.fn_TinhDiemTichLuyDonHang(430000 - 50000), N'QR', N'Hoàn tất', '2026-05-04T11:55:00'),
    ('DH00000029', 'CN00000001', 'NV00000055', 'KH0029', 720000, 90000, 0, 0, 90000, dbo.fn_TinhDiemTichLuyDonHang(720000 - 90000), N'QR', N'Hoàn tất', '2026-05-04T13:10:00'),
    ('DH00000030', 'CN00000001', 'NV00000055', 'KH0030', 340000, 40000, 0, 0, 40000, dbo.fn_TinhDiemTichLuyDonHang(340000 - 40000), N'QR', N'Hoàn tất', '2026-05-04T14:25:00');
GO

-- Đơn hàng 31-40
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGiaThuCong, DiemSuDung, TienGiamTuDiem, GiamGia, DiemCong, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH00000031', 'CN00000001', 'NV00000055', 'KH0031', 610000, 70000, 0, 0, 70000, dbo.fn_TinhDiemTichLuyDonHang(610000 - 70000), N'Tiền mặt', N'Hoàn tất', '2026-05-04T15:40:00'),
    ('DH00000032', 'CN00000001', 'NV00000055', 'KH0032', 250000, 20000, 0, 0, 20000, dbo.fn_TinhDiemTichLuyDonHang(250000 - 20000), N'Thẻ', N'Hoàn tất', '2026-05-04T16:55:00'),
    ('DH00000033', 'CN00000001', 'NV00000055', 'KH0033', 820000, 100000, 0, 0, 100000, dbo.fn_TinhDiemTichLuyDonHang(820000 - 100000), N'QR', N'Hoàn tất', '2026-05-05T08:10:00'),
    ('DH00000034', 'CN00000001', 'NV00000055', 'KH0034', 380000, 40000, 0, 0, 40000, dbo.fn_TinhDiemTichLuyDonHang(380000 - 40000), N'QR', N'Hoàn tất', '2026-05-05T09:25:00'),
    ('DH00000035', 'CN00000001', 'NV00000055', 'KH0035', 690000, 80000, 0, 0, 80000, dbo.fn_TinhDiemTichLuyDonHang(690000 - 80000), N'QR', N'Hoàn tất', '2026-05-05T10:40:00'),
    ('DH00000036', 'CN00000001', 'NV00000055', 'KH0036', 310000, 30000, 0, 0, 30000, dbo.fn_TinhDiemTichLuyDonHang(310000 - 30000), N'Tiền mặt', N'Hoàn tất', '2026-05-05T11:55:00'),
    ('DH00000037', 'CN00000001', 'NV00000055', 'KH0037', 930000, 120000, 0, 0, 120000, dbo.fn_TinhDiemTichLuyDonHang(930000 - 120000), N'Thẻ', N'Hoàn tất', '2026-05-05T13:10:00'),
    ('DH00000038', 'CN00000001', 'NV00000055', 'KH0038', 460000, 50000, 0, 0, 50000, dbo.fn_TinhDiemTichLuyDonHang(460000 - 50000), N'QR', N'Hoàn tất', '2026-05-05T14:25:00'),
    ('DH00000039', 'CN00000001', 'NV00000055', 'KH0039', 760000, 90000, 0, 0, 90000, dbo.fn_TinhDiemTichLuyDonHang(760000 - 90000), N'QR', N'Hoàn tất', '2026-05-05T15:40:00'),
    ('DH00000040', 'CN00000001', 'NV00000055', 'KH0040', 370000, 40000, 0, 0, 40000, dbo.fn_TinhDiemTichLuyDonHang(370000 - 40000), N'QR', N'Hoàn tất', '2026-05-05T16:55:00');
GO


-- Đơn hàng 41-50
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGiaThuCong, DiemSuDung, TienGiamTuDiem, GiamGia, DiemCong, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH00000041', 'CN00000001', 'NV00000055', 'KH0041', 640000, 70000, 0, 0, 70000, dbo.fn_TinhDiemTichLuyDonHang(640000 - 70000), N'Tiền mặt', N'Hoàn tất', '2026-05-06T08:10:00'),
    ('DH00000042', 'CN00000001', 'NV00000055', 'KH0042', 280000, 30000, 0, 0, 30000, dbo.fn_TinhDiemTichLuyDonHang(280000 - 30000), N'Thẻ', N'Hoàn tất', '2026-05-06T09:25:00'),
    ('DH00000043', 'CN00000001', 'NV00000055', 'KH0043', 860000, 110000, 0, 0, 110000, dbo.fn_TinhDiemTichLuyDonHang(860000 - 110000), N'QR', N'Hoàn tất', '2026-05-06T10:40:00'),
    ('DH00000044', 'CN00000001', 'NV00000055', 'KH0044', 410000, 50000, 0, 0, 50000, dbo.fn_TinhDiemTichLuyDonHang(410000 - 50000), N'QR', N'Hoàn tất', '2026-05-06T11:55:00'),
    ('DH00000045', 'CN00000001', 'NV00000055', 'KH0045', 730000, 90000, 0, 0, 90000, dbo.fn_TinhDiemTichLuyDonHang(730000 - 90000), N'QR', N'Hoàn tất', '2026-05-06T13:10:00'),
    ('DH00000046', 'CN00000001', 'NV00000055', 'KH0046', 350000, 40000, 0, 0, 40000, dbo.fn_TinhDiemTichLuyDonHang(350000 - 40000), N'Tiền mặt', N'Hoàn tất', '2026-05-06T14:25:00'),
    ('DH00000047', 'CN00000001', 'NV00000055', 'KH0047', 970000, 120000, 0, 0, 120000, dbo.fn_TinhDiemTichLuyDonHang(970000 - 120000), N'Thẻ', N'Hoàn tất', '2026-05-06T15:40:00'),
    ('DH00000048', 'CN00000001', 'NV00000055', 'KH0048', 490000, 60000, 0, 0, 60000, dbo.fn_TinhDiemTichLuyDonHang(490000 - 60000), N'QR', N'Hoàn tất', '2026-05-06T16:55:00'),
    ('DH00000049', 'CN00000001', 'NV00000055', 'KH0049', 800000, 100000, 0, 0, 100000, dbo.fn_TinhDiemTichLuyDonHang(800000 - 100000), N'QR', N'Hoàn tất', '2026-05-07T08:10:00'),
    ('DH00000050', 'CN00000001', 'NV00000055', 'KH0050', 420000, 50000, 0, 0, 50000, dbo.fn_TinhDiemTichLuyDonHang(420000 - 50000), N'QR', N'Hoàn tất', '2026-05-07T09:25:00');
GO

PRINT '   Đã thêm 50 đơn hàng';
GO

-- =============================================
-- BƯỚC 2: Thêm 148 chi tiết đơn hàng
-- =============================================
PRINT 'Thêm 148 chi tiết đơn hàng...';
GO

-- Chi tiết đơn hàng 1-3 (DH00000001: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000001', 'DH00000001', 'BT00000001', 2, 45000, N'Ít đường'),
    ('CT00000002', 'DH00000001', 'BT00000004', 1, 35000, N'Nhiều đá'),
    ('CT00000003', 'DH00000001', 'BT00000007', 1, 45000, NULL);
GO

-- Chi tiết đơn hàng 4-7 (DH00000002: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000004', 'DH00000002', 'BT00000010', 2, 55000, N'Nóng'),
    ('CT00000005', 'DH00000002', 'BT00000013', 2, 50000, N'Ít đá'),
    ('CT00000006', 'DH00000002', 'BT00000016', 1, 60000, NULL),
    ('CT00000007', 'DH00000002', 'BT00000019', 1, 60000, N'Nhiều đường');
GO

-- Chi tiết đơn hàng 8-11 (DH00000003: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000008', 'DH00000003', 'BT00000022', 3, 65000, NULL),
    ('CT00000009', 'DH00000003', 'BT00000025', 2, 55000, N'Ít đường'),
    ('CT00000010', 'DH00000003', 'BT00000028', 2, 50000, N'Nhiều đá'),
    ('CT00000011', 'DH00000003', 'BT00000031', 1, 65000, NULL);
GO

-- Chi tiết đơn hàng 12-14 (DH00000004: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000012', 'DH00000004', 'BT00000034', 1, 40000, N'Nóng'),
    ('CT00000013', 'DH00000004', 'BT00000037', 1, 35000, N'Ít đá'),
    ('CT00000014', 'DH00000004', 'BT00000040', 1, 20000, NULL);
GO

-- Chi tiết đơn hàng 15-18 (DH00000005: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000015', 'DH00000005', 'BT00000043', 2, 60000, NULL),
    ('CT00000016', 'DH00000005', 'BT00000046', 2, 55000, N'Ít đường'),
    ('CT00000017', 'DH00000005', 'BT00000049', 1, 50000, N'Nhiều đá'),
    ('CT00000018', 'DH00000005', 'BT00000052', 1, 55000, NULL);
GO

-- Chi tiết đơn hàng 19-23 (DH00000006: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000019', 'DH00000006', 'BT00000055', 3, 70000, N'Nóng'),
    ('CT00000020', 'DH00000006', 'BT00000058', 2, 65000, NULL),
    ('CT00000021', 'DH00000006', 'BT00000061', 2, 60000, N'Ít đường'),
    ('CT00000022', 'DH00000006', 'BT00000064', 1, 55000, N'Nhiều đá'),
    ('CT00000023', 'DH00000006', 'BT00000067', 1, 50000, NULL);
GO

-- Chi tiết đơn hàng 24-26 (DH00000007: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000024', 'DH00000007', 'BT00000070', 2, 55000, NULL),
    ('CT00000025', 'DH00000007', 'BT00000073', 1, 50000, N'Ít đá'),
    ('CT00000026', 'DH00000007', 'BT00000076', 1, 20000, N'Nóng');
GO

-- Chi tiết đơn hàng 27-31 (DH00000008: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000027', 'DH00000008', 'BT00000079', 3, 75000, NULL),
    ('CT00000028', 'DH00000008', 'BT00000082', 2, 70000, N'Ít đường'),
    ('CT00000029', 'DH00000008', 'BT00000085', 2, 65000, N'Nhiều đá'),
    ('CT00000030', 'DH00000008', 'BT00000088', 2, 60000, NULL),
    ('CT00000031', 'DH00000008', 'BT00000091', 1, 55000, N'Nóng');
GO

-- Chi tiết đơn hàng 32-35 (DH00000009: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000032', 'DH00000009', 'BT00000094', 2, 50000, N'Ít đá'),
    ('CT00000033', 'DH00000009', 'BT00000097', 1, 45000, NULL),
    ('CT00000034', 'DH00000009', 'BT00000100', 2, 40000, N'Nhiều đường'),
    ('CT00000035', 'DH00000009', 'BT00000103', 1, 65000, NULL);
GO

-- Chi tiết đơn hàng 36-41 (DH00000010: 6 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000036', 'DH00000010', 'BT00000106', 3, 80000, N'Nóng'),
    ('CT00000037', 'DH00000010', 'BT00000109', 2, 75000, NULL),
    ('CT00000038', 'DH00000010', 'BT00000112', 2, 70000, N'Ít đường'),
    ('CT00000039', 'DH00000010', 'BT00000115', 2, 65000, N'Nhiều đá'),
    ('CT00000040', 'DH00000010', 'BT00000118', 1, 60000, NULL),
    ('CT00000041', 'DH00000010', 'BT00000121', 1, 55000, N'Ít đá');
GO

-- Chi tiết đơn hàng 42-44 (DH00000011: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000042', 'DH00000011', 'BT00000001', 2, 45000, NULL),
    ('CT00000043', 'DH00000011', 'BT00000004', 1, 35000, N'Nóng'),
    ('CT00000044', 'DH00000011', 'BT00000007', 1, 45000, N'Ít đường');
GO

-- Chi tiết đơn hàng 45-48 (DH00000012: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000045', 'DH00000012', 'BT00000010', 2, 55000, N'Nhiều đá'),
    ('CT00000046', 'DH00000012', 'BT00000013', 2, 50000, NULL),
    ('CT00000047', 'DH00000012', 'BT00000016', 2, 60000, N'Ít đá'),
    ('CT00000048', 'DH00000012', 'BT00000019', 1, 60000, N'Nóng');
GO

-- Chi tiết đơn hàng 49-53 (DH00000013: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000049', 'DH00000013', 'BT00000022', 3, 65000, NULL),
    ('CT00000050', 'DH00000013', 'BT00000025', 2, 55000, N'Ít đường'),
    ('CT00000051', 'DH00000013', 'BT00000028', 2, 50000, N'Nhiều đá'),
    ('CT00000052', 'DH00000013', 'BT00000031', 1, 65000, N'Nóng'),
    ('CT00000053', 'DH00000013', 'BT00000034', 1, 40000, NULL);
GO

-- Chi tiết đơn hàng 54-56 (DH00000014: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000054', 'DH00000014', 'BT00000037', 2, 35000, N'Ít đá'),
    ('CT00000055', 'DH00000014', 'BT00000040', 2, 20000, NULL),
    ('CT00000056', 'DH00000014', 'BT00000043', 2, 60000, N'Nhiều đường');
GO

-- Chi tiết đơn hàng 57-61 (DH00000015: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000057', 'DH00000015', 'BT00000046', 3, 55000, N'Nóng'),
    ('CT00000058', 'DH00000015', 'BT00000049', 2, 50000, NULL),
    ('CT00000059', 'DH00000015', 'BT00000052', 2, 55000, N'Ít đường'),
    ('CT00000060', 'DH00000015', 'BT00000055', 2, 70000, N'Nhiều đá'),
    ('CT00000061', 'DH00000015', 'BT00000058', 1, 65000, NULL);
GO

-- Chi tiết đơn hàng 62-65 (DH00000016: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000062', 'DH00000016', 'BT00000061', 2, 60000, N'Ít đá'),
    ('CT00000063', 'DH00000016', 'BT00000064', 2, 55000, NULL),
    ('CT00000064', 'DH00000016', 'BT00000067', 2, 50000, N'Nóng'),
    ('CT00000065', 'DH00000016', 'BT00000070', 1, 55000, N'Nhiều đường');
GO

-- Chi tiết đơn hàng 66-71 (DH00000017: 6 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000066', 'DH00000017', 'BT00000073', 3, 50000, NULL),
    ('CT00000067', 'DH00000017', 'BT00000076', 2, 20000, N'Ít đá'),
    ('CT00000068', 'DH00000017', 'BT00000079', 2, 75000, N'Nhiều đá'),
    ('CT00000069', 'DH00000017', 'BT00000082', 2, 70000, N'Nóng'),
    ('CT00000070', 'DH00000017', 'BT00000085', 1, 65000, NULL),
    ('CT00000071', 'DH00000017', 'BT00000088', 1, 60000, N'Ít đường');
GO

-- Chi tiết đơn hàng 72-74 (DH00000018: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000072', 'DH00000018', 'BT00000091', 1, 55000, N'Nhiều đá'),
    ('CT00000073', 'DH00000018', 'BT00000094', 2, 50000, NULL),
    ('CT00000074', 'DH00000018', 'BT00000097', 1, 45000, N'Nóng');
GO

-- Chi tiết đơn hàng 75-80 (DH00000019: 6 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000075', 'DH00000019', 'BT00000100', 3, 40000, N'Ít đường'),
    ('CT00000076', 'DH00000019', 'BT00000103', 2, 65000, NULL),
    ('CT00000077', 'DH00000019', 'BT00000106', 2, 80000, N'Nhiều đá'),
    ('CT00000078', 'DH00000019', 'BT00000109', 2, 75000, N'Nóng'),
    ('CT00000079', 'DH00000019', 'BT00000112', 1, 70000, NULL),
    ('CT00000080', 'DH00000019', 'BT00000115', 1, 65000, N'Ít đá');
GO

-- Chi tiết đơn hàng 81-84 (DH00000020: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000081', 'DH00000020', 'BT00000118', 2, 60000, N'Nhiều đường'),
    ('CT00000082', 'DH00000020', 'BT00000121', 1, 55000, NULL),
    ('CT00000083', 'DH00000020', 'BT00000001', 2, 45000, N'Nóng'),
    ('CT00000084', 'DH00000020', 'BT00000004', 1, 35000, N'Ít đá');
GO

-- Chi tiết đơn hàng 85-89 (DH00000021: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000085', 'DH00000021', 'BT00000007', 3, 45000, N'Nhiều đá'),
    ('CT00000086', 'DH00000021', 'BT00000010', 2, 55000, NULL),
    ('CT00000087', 'DH00000021', 'BT00000013', 2, 50000, N'Ít đường'),
    ('CT00000088', 'DH00000021', 'BT00000016', 2, 60000, N'Nóng'),
    ('CT00000089', 'DH00000021', 'BT00000019', 1, 60000, NULL);
GO

-- Chi tiết đơn hàng 90-92 (DH00000022: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000090', 'DH00000022', 'BT00000022', 2, 65000, N'Ít đá'),
    ('CT00000091', 'DH00000022', 'BT00000025', 1, 55000, N'Nhiều đá'),
    ('CT00000092', 'DH00000022', 'BT00000028', 1, 50000, NULL);
GO

-- Chi tiết đơn hàng 93-98 (DH00000023: 6 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000093', 'DH00000023', 'BT00000031', 3, 65000, N'Nóng'),
    ('CT00000094', 'DH00000023', 'BT00000034', 2, 40000, NULL),
    ('CT00000095', 'DH00000023', 'BT00000037', 2, 35000, N'Ít đường'),
    ('CT00000096', 'DH00000023', 'BT00000040', 2, 20000, N'Nhiều đá'),
    ('CT00000097', 'DH00000023', 'BT00000043', 2, 60000, NULL),
    ('CT00000098', 'DH00000023', 'BT00000046', 1, 55000, N'Nóng');
GO

-- Chi tiết đơn hàng 99-102 (DH00000024: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000099', 'DH00000024', 'BT00000049', 2, 50000, N'Ít đá'),
    ('CT00000100', 'DH00000024', 'BT00000052', 2, 55000, NULL),
    ('CT00000101', 'DH00000024', 'BT00000055', 2, 70000, N'Nhiều đường'),
    ('CT00000102', 'DH00000024', 'BT00000058', 1, 65000, N'Nóng');
GO

-- Chi tiết đơn hàng 103-107 (DH00000025: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000103', 'DH00000025', 'BT00000061', 3, 60000, NULL),
    ('CT00000104', 'DH00000025', 'BT00000064', 2, 55000, N'Ít đá'),
    ('CT00000105', 'DH00000025', 'BT00000067', 2, 50000, N'Nhiều đá'),
    ('CT00000106', 'DH00000025', 'BT00000070', 2, 55000, N'Nóng'),
    ('CT00000107', 'DH00000025', 'BT00000073', 1, 50000, NULL);
GO

-- Chi tiết đơn hàng 108-110 (DH00000026: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000108', 'DH00000026', 'BT00000076', 2, 20000, N'Ít đường'),
    ('CT00000109', 'DH00000026', 'BT00000079', 2, 75000, NULL),
    ('CT00000110', 'DH00000026', 'BT00000082', 1, 70000, N'Nhiều đá');
GO

-- Chi tiết đơn hàng 111-116 (DH00000027: 6 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000111', 'DH00000027', 'BT00000085', 3, 65000, N'Nóng'),
    ('CT00000112', 'DH00000027', 'BT00000088', 2, 60000, NULL),
    ('CT00000113', 'DH00000027', 'BT00000091', 2, 55000, N'Ít đường'),
    ('CT00000114', 'DH00000027', 'BT00000094', 2, 50000, N'Nhiều đá'),
    ('CT00000115', 'DH00000027', 'BT00000097', 2, 45000, NULL),
    ('CT00000116', 'DH00000027', 'BT00000100', 1, 40000, N'Nóng');
GO

-- Chi tiết đơn hàng 117-120 (DH00000028: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000117', 'DH00000028', 'BT00000103', 2, 65000, N'Ít đá'),
    ('CT00000118', 'DH00000028', 'BT00000106', 2, 80000, NULL),
    ('CT00000119', 'DH00000028', 'BT00000109', 1, 75000, N'Nhiều đường'),
    ('CT00000120', 'DH00000028', 'BT00000112', 1, 70000, N'Nóng');
GO

-- Chi tiết đơn hàng 121-125 (DH00000029: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000121', 'DH00000029', 'BT00000115', 3, 65000, NULL),
    ('CT00000122', 'DH00000029', 'BT00000118', 2, 60000, N'Ít đá'),
    ('CT00000123', 'DH00000029', 'BT00000121', 2, 55000, N'Nhiều đá'),
    ('CT00000124', 'DH00000029', 'BT00000001', 1, 45000, N'Nóng'),
    ('CT00000125', 'DH00000029', 'BT00000004', 1, 35000, NULL);
GO

-- Chi tiết đơn hàng 126-129 (DH00000030: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000126', 'DH00000030', 'BT00000007', 2, 45000, N'Ít đường'),
    ('CT00000127', 'DH00000030', 'BT00000010', 2, 55000, NULL),
    ('CT00000128', 'DH00000030', 'BT00000013', 1, 50000, N'Nhiều đá'),
    ('CT00000129', 'DH00000030', 'BT00000016', 1, 60000, N'Nóng');
GO

-- Chi tiết đơn hàng 130-134 (DH00000031: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000130', 'DH00000031', 'BT00000019', 3, 60000, NULL),
    ('CT00000131', 'DH00000031', 'BT00000022', 2, 65000, N'Ít đá'),
    ('CT00000132', 'DH00000031', 'BT00000025', 2, 55000, N'Nhiều đá'),
    ('CT00000133', 'DH00000031', 'BT00000028', 1, 50000, N'Nóng'),
    ('CT00000134', 'DH00000031', 'BT00000031', 1, 65000, NULL);
GO

-- Chi tiết đơn hàng 135-137 (DH00000032: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000135', 'DH00000032', 'BT00000034', 2, 40000, N'Ít đường'),
    ('CT00000136', 'DH00000032', 'BT00000037', 1, 35000, NULL),
    ('CT00000137', 'DH00000032', 'BT00000040', 2, 20000, N'Nhiều đá');
GO

-- Chi tiết đơn hàng 138-143 (DH00000033: 6 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000138', 'DH00000033', 'BT00000043', 3, 60000, N'Nóng'),
    ('CT00000139', 'DH00000033', 'BT00000046', 2, 55000, NULL),
    ('CT00000140', 'DH00000033', 'BT00000049', 2, 50000, N'Ít đường'),
    ('CT00000141', 'DH00000033', 'BT00000052', 2, 55000, N'Nhiều đá'),
    ('CT00000142', 'DH00000033', 'BT00000055', 2, 70000, NULL),
    ('CT00000143', 'DH00000033', 'BT00000058', 1, 65000, N'Nóng');
GO

-- Chi tiết đơn hàng 144-147 (DH00000034: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000144', 'DH00000034', 'BT00000061', 2, 60000, N'Ít đá'),
    ('CT00000145', 'DH00000034', 'BT00000064', 2, 55000, NULL),
    ('CT00000146', 'DH00000034', 'BT00000067', 1, 50000, N'Nhiều đường'),
    ('CT00000147', 'DH00000034', 'BT00000070', 1, 55000, N'Nóng');
GO

-- Chi tiết đơn hàng 148-152 (DH00000035: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000148', 'DH00000035', 'BT00000073', 3, 50000, NULL),
    ('CT00000149', 'DH00000035', 'BT00000076', 2, 20000, N'Ít đá'),
    ('CT00000150', 'DH00000035', 'BT00000079', 2, 75000, N'Nhiều đá'),
    ('CT00000151', 'DH00000035', 'BT00000082', 2, 70000, N'Nóng'),
    ('CT00000152', 'DH00000035', 'BT00000085', 1, 65000, NULL);
GO

-- Chi tiết đơn hàng 153-155 (DH00000036: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000153', 'DH00000036', 'BT00000088', 2, 60000, N'Ít đường'),
    ('CT00000154', 'DH00000036', 'BT00000091', 1, 55000, NULL),
    ('CT00000155', 'DH00000036', 'BT00000094', 2, 50000, N'Nhiều đá');
GO

-- Chi tiết đơn hàng 156-161 (DH00000037: 6 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000156', 'DH00000037', 'BT00000097', 3, 45000, N'Nóng'),
    ('CT00000157', 'DH00000037', 'BT00000100', 2, 40000, NULL),
    ('CT00000158', 'DH00000037', 'BT00000103', 2, 65000, N'Ít đường'),
    ('CT00000159', 'DH00000037', 'BT00000106', 2, 80000, N'Nhiều đá'),
    ('CT00000160', 'DH00000037', 'BT00000109', 2, 75000, NULL),
    ('CT00000161', 'DH00000037', 'BT00000112', 1, 70000, N'Nóng');
GO

-- Chi tiết đơn hàng 162-165 (DH00000038: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000162', 'DH00000038', 'BT00000115', 2, 65000, N'Ít đá'),
    ('CT00000163', 'DH00000038', 'BT00000118', 2, 60000, NULL),
    ('CT00000164', 'DH00000038', 'BT00000121', 1, 55000, N'Nhiều đường'),
    ('CT00000165', 'DH00000038', 'BT00000001', 1, 45000, N'Nóng');
GO

-- Chi tiết đơn hàng 166-170 (DH00000039: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000166', 'DH00000039', 'BT00000004', 3, 35000, NULL),
    ('CT00000167', 'DH00000039', 'BT00000007', 2, 45000, N'Ít đá'),
    ('CT00000168', 'DH00000039', 'BT00000010', 2, 55000, N'Nhiều đá'),
    ('CT00000169', 'DH00000039', 'BT00000013', 2, 50000, N'Nóng'),
    ('CT00000170', 'DH00000039', 'BT00000016', 1, 60000, NULL);
GO

-- Chi tiết đơn hàng 171-174 (DH00000040: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000171', 'DH00000040', 'BT00000019', 2, 60000, N'Ít đường'),
    ('CT00000172', 'DH00000040', 'BT00000022', 1, 65000, NULL),
    ('CT00000173', 'DH00000040', 'BT00000025', 1, 55000, N'Nhiều đá'),
    ('CT00000174', 'DH00000040', 'BT00000028', 1, 50000, N'Nóng');
GO

-- Chi tiết đơn hàng 175-179 (DH00000041: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000175', 'DH00000041', 'BT00000031', 3, 65000, NULL),
    ('CT00000176', 'DH00000041', 'BT00000034', 2, 40000, N'Ít đá'),
    ('CT00000177', 'DH00000041', 'BT00000037', 2, 35000, N'Nhiều đá'),
    ('CT00000178', 'DH00000041', 'BT00000040', 1, 20000, N'Nóng'),
    ('CT00000179', 'DH00000041', 'BT00000043', 1, 60000, NULL);
GO

-- Chi tiết đơn hàng 180-182 (DH00000042: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000180', 'DH00000042', 'BT00000046', 2, 55000, N'Ít đường'),
    ('CT00000181', 'DH00000042', 'BT00000049', 1, 50000, NULL),
    ('CT00000182', 'DH00000042', 'BT00000052', 2, 55000, N'Nhiều đá');
GO

-- Chi tiết đơn hàng 183-188 (DH00000043: 6 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000183', 'DH00000043', 'BT00000055', 3, 70000, N'Nóng'),
    ('CT00000184', 'DH00000043', 'BT00000058', 2, 65000, NULL),
    ('CT00000185', 'DH00000043', 'BT00000061', 2, 60000, N'Ít đường'),
    ('CT00000186', 'DH00000043', 'BT00000064', 2, 55000, N'Nhiều đá'),
    ('CT00000187', 'DH00000043', 'BT00000067', 1, 50000, NULL),
    ('CT00000188', 'DH00000043', 'BT00000070', 1, 55000, N'Nóng');
GO

-- Chi tiết đơn hàng 189-192 (DH00000044: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000189', 'DH00000044', 'BT00000073', 2, 50000, N'Ít đá'),
    ('CT00000190', 'DH00000044', 'BT00000076', 2, 20000, NULL),
    ('CT00000191', 'DH00000044', 'BT00000079', 2, 75000, N'Nhiều đường'),
    ('CT00000192', 'DH00000044', 'BT00000082', 1, 70000, N'Nóng');
GO

-- Chi tiết đơn hàng 193-197 (DH00000045: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000193', 'DH00000045', 'BT00000085', 3, 65000, NULL),
    ('CT00000194', 'DH00000045', 'BT00000088', 2, 60000, N'Ít đá'),
    ('CT00000195', 'DH00000045', 'BT00000091', 2, 55000, N'Nhiều đá'),
    ('CT00000196', 'DH00000045', 'BT00000094', 1, 50000, N'Nóng'),
    ('CT00000197', 'DH00000045', 'BT00000097', 1, 45000, NULL);
GO

-- Chi tiết đơn hàng 198-200 (DH00000046: 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000198', 'DH00000046', 'BT00000100', 2, 40000, N'Ít đường'),
    ('CT00000199', 'DH00000046', 'BT00000103', 2, 65000, NULL),
    ('CT00000200', 'DH00000046', 'BT00000106', 1, 80000, N'Nhiều đá');
GO

-- Chi tiết đơn hàng 201-206 (DH00000047: 6 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000201', 'DH00000047', 'BT00000109', 3, 75000, N'Nóng'),
    ('CT00000202', 'DH00000047', 'BT00000112', 2, 70000, NULL),
    ('CT00000203', 'DH00000047', 'BT00000115', 2, 65000, N'Ít đường'),
    ('CT00000204', 'DH00000047', 'BT00000118', 2, 60000, N'Nhiều đá'),
    ('CT00000205', 'DH00000047', 'BT00000121', 2, 55000, NULL),
    ('CT00000206', 'DH00000047', 'BT00000001', 1, 45000, N'Nóng');
GO

-- Chi tiết đơn hàng 207-210 (DH00000048: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000207', 'DH00000048', 'BT00000004', 2, 35000, N'Ít đá'),
    ('CT00000208', 'DH00000048', 'BT00000007', 2, 45000, NULL),
    ('CT00000209', 'DH00000048', 'BT00000010', 2, 55000, N'Nhiều đường'),
    ('CT00000210', 'DH00000048', 'BT00000013', 1, 50000, N'Nóng');
GO

-- Chi tiết đơn hàng 211-215 (DH00000049: 5 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000211', 'DH00000049', 'BT00000016', 3, 60000, NULL),
    ('CT00000212', 'DH00000049', 'BT00000019', 2, 60000, N'Ít đá'),
    ('CT00000213', 'DH00000049', 'BT00000022', 2, 65000, N'Nhiều đá'),
    ('CT00000214', 'DH00000049', 'BT00000025', 2, 55000, N'Nóng'),
    ('CT00000215', 'DH00000049', 'BT00000028', 1, 50000, NULL);
GO

-- Chi tiết đơn hàng 216-219 (DH00000050: 4 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CT00000216', 'DH00000050', 'BT00000031', 2, 65000, N'Ít đường'),
    ('CT00000217', 'DH00000050', 'BT00000034', 2, 40000, NULL),
    ('CT00000218', 'DH00000050', 'BT00000037', 1, 35000, N'Nhiều đá'),
    ('CT00000219', 'DH00000050', 'BT00000040', 1, 20000, N'Nóng');
GO

PRINT '  ✓ Đã thêm 219 chi tiết đơn hàng (đầy đủ cho 50 đơn hàng)';
GO

-- =============================================
-- BƯỚC 3: Bật lại trigger
-- =============================================
PRINT 'Bật lại trigger...';
GO

IF OBJECT_ID(N'dbo.TRG_ChiTietDonHang_CapNhatTongTien', N'TR') IS NOT NULL
    ENABLE TRIGGER dbo.TRG_ChiTietDonHang_CapNhatTongTien ON dbo.ChiTietDonHang;
GO

IF OBJECT_ID(N'dbo.TRG_DonHang_CapNhatDiem', N'TR') IS NOT NULL
    ENABLE TRIGGER dbo.TRG_DonHang_CapNhatDiem ON dbo.DonHang;
GO

PRINT '  ✓ Đã bật lại trigger';
GO

PRINT '';
PRINT '========================================';
PRINT ' HOÀN THÀNH THÊM ĐƠN HÀNG';
PRINT '========================================';
GO

/* ========================= 14. ĐỒNG BỘ VÀ KIỂM TRA DỮ LIỆU SAU SEED ========================= */
PRINT N'Rà soát và đồng bộ dữ liệu sau seed...';
GO

EXEC dbo.sp_DongBoTatCaSanPham;
GO

INSERT INTO dbo.TonKhoNguyenLieu
(
    MaChiNhanh,
    MaNguyenLieu,
    SoLuongTon,
    MucCanhBao,
    HanSuDung,
    SoLuongDaDat
)
SELECT
    cn.MaChiNhanh,
    nl.MaNguyenLieu,
    100.00,
    20.00,
    CASE WHEN nl.CoHanSuDung = 1 THEN DATEADD(MONTH, 6, CONVERT(date, GETDATE())) ELSE NULL END,
    0.00
FROM dbo.ChiNhanh cn
CROSS JOIN dbo.NguyenLieu nl
WHERE cn.TrangThai = 1
  AND nl.TrangThai = N'Đang sử dụng'
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.TonKhoNguyenLieu tk
      WHERE tk.MaChiNhanh = cn.MaChiNhanh
        AND tk.MaNguyenLieu = nl.MaNguyenLieu
  );
GO

IF EXISTS (
    SELECT 1
    FROM dbo.ChiTietDonHang ct
    JOIN dbo.DonHang dh ON dh.MaDH = ct.MaDH
    JOIN dbo.BienTheSanPham bt ON bt.MaBienThe = ct.MaBienThe
    JOIN dbo.SanPham sp ON sp.MaSanPham = bt.MaSanPham
    LEFT JOIN dbo.SanPham_ChiNhanh spcn
      ON spcn.MaSanPham = sp.MaSanPham
     AND spcn.MaChiNhanh = dh.MaChiNhanh
    WHERE spcn.MaSanPham IS NULL
       OR sp.TrangThai = 0
       OR bt.TrangThai = 0
       OR spcn.TrangThai = 0
)
BEGIN
    RAISERROR(N'Có chi tiết đơn hàng không tìm được giá hợp lệ từ sản phẩm/biến thể/menu chi nhánh.', 16, 1);
END;
GO

UPDATE ct
SET DonGia = spcn.GiaBan + bt.GiaCongThem
FROM dbo.ChiTietDonHang ct
JOIN dbo.DonHang dh ON dh.MaDH = ct.MaDH
JOIN dbo.BienTheSanPham bt ON bt.MaBienThe = ct.MaBienThe
JOIN dbo.SanPham sp ON sp.MaSanPham = bt.MaSanPham
JOIN dbo.SanPham_ChiNhanh spcn
  ON spcn.MaSanPham = sp.MaSanPham
 AND spcn.MaChiNhanh = dh.MaChiNhanh
WHERE sp.TrangThai = 1
  AND bt.TrangThai = 1
  AND spcn.TrangThai = 1;
GO

UPDATE dh
SET TongTien = x.TongTienTinhLai
FROM dbo.DonHang dh
OUTER APPLY (
    SELECT TongTienTinhLai = ISNULL(SUM(ct.SoLuong * ct.DonGia), 0)
    FROM dbo.ChiTietDonHang ct
    WHERE ct.MaDH = dh.MaDH
) x;
GO

UPDATE dbo.DonHang
SET GiamGiaThuCong = TongTien - TienGiamTuDiem
WHERE TrangThai = N'Hoàn tất'
  AND GiamGiaThuCong + TienGiamTuDiem > TongTien;
GO

UPDATE dbo.DonHang
SET GiamGia = GiamGiaThuCong + TienGiamTuDiem,
    DiemCong = CASE
        WHEN MaKH IS NULL OR TrangThai <> N'Hoàn tất' THEN 0
        ELSE dbo.fn_TinhDiemTichLuyDonHang(TongTien - (GiamGiaThuCong + TienGiamTuDiem))
    END;
GO

UPDATE kh
SET DiemTichLuy = ISNULL(x.DiemSauDon, 0)
FROM dbo.KhachHang kh
OUTER APPLY (
    SELECT DiemSauDon = SUM(dh.DiemCong - dh.DiemSuDung)
    FROM dbo.DonHang dh
    WHERE dh.MaKH = kh.MaKH
      AND dh.TrangThai = N'Hoàn tất'
) x;
GO

PRINT N'  Đã đồng bộ DonGia, TongTien, giảm giá và điểm theo dữ liệu menu hiện tại';
GO

/* ========================= 15. VALIDATION BẮT BUỘC ========================= */
PRINT N'Kiểm tra toàn vẹn dữ liệu seed...';
GO

IF EXISTS (SELECT MaTK FROM dbo.HeThongTaiKhoan GROUP BY MaTK HAVING COUNT(*) > 1)
BEGIN
    RAISERROR(N'Trùng khóa HeThongTaiKhoan.MaTK.', 16, 1);
END;
IF EXISTS (SELECT TenDangNhap FROM dbo.HeThongTaiKhoan GROUP BY TenDangNhap HAVING COUNT(*) > 1)
BEGIN
    RAISERROR(N'Trùng HeThongTaiKhoan.TenDangNhap.', 16, 1);
END;
IF EXISTS (SELECT MaNV FROM dbo.ThongTinNhanVien GROUP BY MaNV HAVING COUNT(*) > 1)
BEGIN
    RAISERROR(N'Trùng khóa ThongTinNhanVien.MaNV.', 16, 1);
END;
IF EXISTS (SELECT MaChiNhanh FROM dbo.ChiNhanh GROUP BY MaChiNhanh HAVING COUNT(*) > 1)
BEGIN
    RAISERROR(N'Trùng khóa ChiNhanh.MaChiNhanh.', 16, 1);
END;
IF EXISTS (SELECT MaSanPham FROM dbo.SanPham GROUP BY MaSanPham HAVING COUNT(*) > 1)
BEGIN
    RAISERROR(N'Trùng khóa SanPham.MaSanPham.', 16, 1);
END;
IF EXISTS (SELECT MaBienThe FROM dbo.BienTheSanPham GROUP BY MaBienThe HAVING COUNT(*) > 1)
BEGIN
    RAISERROR(N'Trùng khóa BienTheSanPham.MaBienThe.', 16, 1);
END;
IF EXISTS (SELECT MaDH FROM dbo.DonHang GROUP BY MaDH HAVING COUNT(*) > 1)
BEGIN
    RAISERROR(N'Trùng khóa DonHang.MaDH.', 16, 1);
END;
IF EXISTS (SELECT MaCTDH FROM dbo.ChiTietDonHang GROUP BY MaCTDH HAVING COUNT(*) > 1)
BEGIN
    RAISERROR(N'Trùng khóa ChiTietDonHang.MaCTDH.', 16, 1);
END;
GO

IF EXISTS (
    SELECT 1 FROM dbo.HeThongTaiKhoan
    WHERE LEN(RTRIM(MaTK)) <> 10 OR LEFT(MaTK, 2) <> 'TK' OR TRY_CONVERT(INT, SUBSTRING(MaTK, 3, 8)) IS NULL
)
BEGIN
    RAISERROR(N'Có MaTK không đúng chuẩn TK + 8 số.', 16, 1);
END;

IF EXISTS (
    SELECT 1 FROM dbo.ThongTinNhanVien
    WHERE LEN(RTRIM(MaNV)) <> 10 OR LEFT(MaNV, 2) <> 'NV' OR TRY_CONVERT(INT, SUBSTRING(MaNV, 3, 8)) IS NULL
)
BEGIN
    RAISERROR(N'Có MaNV không đúng chuẩn NV + 8 số.', 16, 1);
END;

IF EXISTS (
    SELECT 1 FROM dbo.ChiNhanh
    WHERE LEN(RTRIM(MaChiNhanh)) <> 10 OR LEFT(MaChiNhanh, 2) <> 'CN' OR TRY_CONVERT(INT, SUBSTRING(MaChiNhanh, 3, 8)) IS NULL
)
BEGIN
    RAISERROR(N'Có MaChiNhanh không đúng chuẩn CN + 8 số.', 16, 1);
END;

IF EXISTS (
    SELECT 1 FROM dbo.SanPham
    WHERE LEN(RTRIM(MaSanPham)) <> 10 OR LEFT(MaSanPham, 2) <> 'SP' OR TRY_CONVERT(INT, SUBSTRING(MaSanPham, 3, 8)) IS NULL
)
BEGIN
    RAISERROR(N'Có MaSanPham không đúng chuẩn SP + 8 số.', 16, 1);
END;

IF EXISTS (
    SELECT 1 FROM dbo.BienTheSanPham
    WHERE LEN(RTRIM(MaBienThe)) <> 10 OR LEFT(MaBienThe, 2) <> 'BT' OR TRY_CONVERT(INT, SUBSTRING(MaBienThe, 3, 8)) IS NULL
)
BEGIN
    RAISERROR(N'Có MaBienThe không đúng chuẩn BT + 8 số.', 16, 1);
END;

IF EXISTS (
    SELECT 1 FROM dbo.DonHang
    WHERE LEN(RTRIM(MaDH)) <> 10 OR LEFT(MaDH, 2) <> 'DH' OR TRY_CONVERT(INT, SUBSTRING(MaDH, 3, 8)) IS NULL
)
BEGIN
    RAISERROR(N'Có MaDH không đúng chuẩn DH + 8 số.', 16, 1);
END;

IF EXISTS (
    SELECT 1 FROM dbo.ChiTietDonHang
    WHERE LEN(RTRIM(MaCTDH)) <> 10 OR LEFT(MaCTDH, 2) <> 'CT' OR TRY_CONVERT(INT, SUBSTRING(MaCTDH, 3, 8)) IS NULL
)
BEGIN
    RAISERROR(N'Có MaCTDH không đúng chuẩn CT + 8 số.', 16, 1);
END;

IF EXISTS (
    SELECT 1 FROM dbo.LichSuKho
    WHERE LEN(RTRIM(LogID)) <> 10 OR LEFT(LogID, 1) <> 'L' OR TRY_CONVERT(INT, SUBSTRING(LogID, 2, 9)) IS NULL
)
BEGIN
    RAISERROR(N'Có LichSuKho.LogID không đúng chuẩn L + 9 số.', 16, 1);
END;
GO

IF EXISTS (
    SELECT 1
    FROM dbo.HeThongTaiKhoan tk
    WHERE tk.VaiTro NOT IN (N'ADMIN', N'QUAN_LY', N'NHAN_VIEN', N'KHO', N'KE_TOAN')
)
BEGIN
    RAISERROR(N'Có tài khoản có vai trò không hợp lệ.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.HeThongTaiKhoan tk
    LEFT JOIN dbo.TaiKhoanNhanVien tknv ON tknv.MaTK = tk.MaTK
    WHERE tk.VaiTro <> N'ADMIN'
    GROUP BY tk.MaTK
    HAVING COUNT(tknv.MaNV) <> 1
)
BEGIN
    RAISERROR(N'Có tài khoản non-admin chưa liên kết đúng một nhân viên.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.HeThongTaiKhoan tk
    JOIN dbo.TaiKhoanNhanVien tknv ON tknv.MaTK = tk.MaTK
    JOIN dbo.ThongTinNhanVien nv ON nv.MaNV = tknv.MaNV
    LEFT JOIN dbo.ChiNhanh cn ON cn.MaChiNhanh = nv.MaChiNhanh
    WHERE tk.TrangThai = 1
      AND tk.VaiTro <> N'ADMIN'
      AND (nv.TrangThai = 0 OR nv.NgayNghiViec IS NOT NULL OR cn.MaChiNhanh IS NULL OR cn.TrangThai = 0)
)
BEGIN
    RAISERROR(N'Có tài khoản đang hoạt động liên kết với nhân viên/chi nhánh không hợp lệ.', 16, 1);
END;
GO

IF EXISTS (
    SELECT 1
    FROM dbo.SanPham sp
    WHERE sp.TrangThai = 1
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.BienTheSanPham bt
          WHERE bt.MaSanPham = sp.MaSanPham
            AND bt.TrangThai = 1
      )
)
BEGIN
    RAISERROR(N'Có sản phẩm đang hoạt động nhưng không có biến thể hoạt động.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.ChiNhanh cn
    CROSS JOIN dbo.SanPham sp
    WHERE cn.TrangThai = 1
      AND sp.TrangThai = 1
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.SanPham_ChiNhanh spcn
          WHERE spcn.MaChiNhanh = cn.MaChiNhanh
            AND spcn.MaSanPham = sp.MaSanPham
      )
)
BEGIN
    RAISERROR(N'Có sản phẩm đang hoạt động chưa được đồng bộ vào chi nhánh đang hoạt động.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.ChiTietDonHang ct
    JOIN dbo.DonHang dh ON dh.MaDH = ct.MaDH
    JOIN dbo.BienTheSanPham bt ON bt.MaBienThe = ct.MaBienThe
    JOIN dbo.SanPham sp ON sp.MaSanPham = bt.MaSanPham
    JOIN dbo.SanPham_ChiNhanh spcn
      ON spcn.MaSanPham = sp.MaSanPham
     AND spcn.MaChiNhanh = dh.MaChiNhanh
    WHERE ct.DonGia <> spcn.GiaBan + bt.GiaCongThem
)
BEGIN
    RAISERROR(N'Có chi tiết đơn hàng có đơn giá lệch với dữ liệu sản phẩm/menu chi nhánh.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.DonHang dh
    OUTER APPLY (
        SELECT TongTienTinhLai = ISNULL(SUM(ct.SoLuong * ct.DonGia), 0)
        FROM dbo.ChiTietDonHang ct
        WHERE ct.MaDH = dh.MaDH
    ) x
    WHERE dh.TongTien <> x.TongTienTinhLai
)
BEGIN
    RAISERROR(N'Có đơn hàng có tổng tiền lệch với chi tiết đơn hàng.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.DonHang
    WHERE TrangThai = N'Hoàn tất'
      AND (TongTien <= 0 OR GiamGia < 0 OR GiamGia > TongTien)
)
BEGIN
    RAISERROR(N'Có đơn hoàn tất có tổng tiền/giảm giá không hợp lệ.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.DonHang
    WHERE DiemCong <> CASE
        WHEN MaKH IS NULL OR TrangThai <> N'Hoàn tất' THEN 0
        ELSE dbo.fn_TinhDiemTichLuyDonHang(TongTien - GiamGia)
    END
)
BEGIN
    RAISERROR(N'Có đơn hàng có điểm cộng không khớp với thành tiền sau giảm.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.KhachHang kh
    OUTER APPLY (
        SELECT DiemDungSauDon = ISNULL(SUM(dh.DiemCong - dh.DiemSuDung), 0)
        FROM dbo.DonHang dh
        WHERE dh.MaKH = kh.MaKH
          AND dh.TrangThai = N'Hoàn tất'
    ) x
    WHERE kh.DiemTichLuy <> x.DiemDungSauDon
)
BEGIN
    RAISERROR(N'Có khách hàng có điểm tích lũy không khớp với lịch sử đơn hàng.', 16, 1);
END;
GO

IF EXISTS (
    SELECT 1
    FROM dbo.ChiNhanh cn
    CROSS JOIN dbo.NguyenLieu nl
    WHERE cn.TrangThai = 1
      AND nl.TrangThai = N'Đang sử dụng'
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.TonKhoNguyenLieu tk
          WHERE tk.MaChiNhanh = cn.MaChiNhanh
            AND tk.MaNguyenLieu = nl.MaNguyenLieu
      )
)
BEGIN
    RAISERROR(N'Có chi nhánh/nguyên liệu đang hoạt động chưa được khởi tạo tồn kho.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.LichSuKho lsk
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.TonKhoNguyenLieu tk
        WHERE tk.MaChiNhanh = lsk.MaChiNhanh
          AND tk.MaNguyenLieu = lsk.MaNguyenLieu
    )
)
BEGIN
    RAISERROR(N'Có lịch sử kho tham chiếu cặp chi nhánh/nguyên liệu chưa tồn tại trong tồn kho.', 16, 1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.vw_MenuChiNhanh)
BEGIN
    RAISERROR(N'vw_MenuChiNhanh không có dữ liệu. POS/menu sẽ không hiển thị sản phẩm.', 16, 1);
END;
GO

IF EXISTS (
    SELECT 1
    FROM dbo.DonHang dh
    LEFT JOIN dbo.ChiNhanh cn ON cn.MaChiNhanh = dh.MaChiNhanh
    LEFT JOIN dbo.ThongTinNhanVien nv ON nv.MaNV = dh.MaNV
    LEFT JOIN dbo.KhachHang kh ON kh.MaKH = dh.MaKH
    WHERE cn.MaChiNhanh IS NULL
       OR nv.MaNV IS NULL
       OR (dh.MaKH IS NOT NULL AND kh.MaKH IS NULL)
)
BEGIN
    RAISERROR(N'Có đơn hàng thiếu khóa ngoại chi nhánh/nhân viên/khách hàng.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.ChiTietDonHang ct
    LEFT JOIN dbo.DonHang dh ON dh.MaDH = ct.MaDH
    LEFT JOIN dbo.BienTheSanPham bt ON bt.MaBienThe = ct.MaBienThe
    WHERE dh.MaDH IS NULL OR bt.MaBienThe IS NULL
)
BEGIN
    RAISERROR(N'Có chi tiết đơn hàng thiếu khóa ngoại đơn hàng/biến thể.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.BangLuong bl
    LEFT JOIN dbo.ThongTinNhanVien nv ON nv.MaNV = bl.MaNV
    WHERE nv.MaNV IS NULL
)
BEGIN
    RAISERROR(N'Có bảng lương tham chiếu nhân viên không tồn tại.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.LichPhanCong lpc
    LEFT JOIN dbo.ThongTinNhanVien nv ON nv.MaNV = lpc.MaNV
    LEFT JOIN dbo.CaLamViec ca ON ca.MaCa = lpc.MaCa
    WHERE nv.MaNV IS NULL OR ca.MaCa IS NULL
)
BEGIN
    RAISERROR(N'Có lịch phân công tham chiếu nhân viên/ca làm không tồn tại.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.ChamCong cc
    LEFT JOIN dbo.ThongTinNhanVien nv ON nv.MaNV = cc.MaNV
    LEFT JOIN dbo.LichPhanCong lpc ON lpc.MaLich = cc.MaLich
    WHERE nv.MaNV IS NULL OR lpc.MaLich IS NULL
)
BEGIN
    RAISERROR(N'Có chấm công tham chiếu nhân viên/lịch phân công không tồn tại.', 16, 1);
END;

IF EXISTS (
    SELECT 1
    FROM dbo.PhatDiMuon pdm
    LEFT JOIN dbo.ChamCong cc ON cc.MaChamCong = pdm.MaChamCong
    LEFT JOIN dbo.ThongTinNhanVien nv ON nv.MaNV = pdm.MaNV
    WHERE cc.MaChamCong IS NULL OR nv.MaNV IS NULL
)
BEGIN
    RAISERROR(N'Có phạt đi muộn tham chiếu chấm công/nhân viên không tồn tại.', 16, 1);
END;
GO

PRINT N'  Tất cả validation seed data đã đạt.';
GO

/* ========================= 16. THỐNG KÊ CUỐI FILE ========================= */
DECLARE @SoTaiKhoan INT = (SELECT COUNT(*) FROM dbo.HeThongTaiKhoan);
DECLARE @SoNhanVien INT = (SELECT COUNT(*) FROM dbo.ThongTinNhanVien);
DECLARE @SoChiNhanh INT = (SELECT COUNT(*) FROM dbo.ChiNhanh);
DECLARE @SoChiNhanhHoatDong INT = (SELECT COUNT(*) FROM dbo.ChiNhanh WHERE TrangThai = 1);
DECLARE @SoDanhMuc INT = (SELECT COUNT(*) FROM dbo.DanhMuc);
DECLARE @SoSanPham INT = (SELECT COUNT(*) FROM dbo.SanPham);
DECLARE @SoBienThe INT = (SELECT COUNT(*) FROM dbo.BienTheSanPham);
DECLARE @SoMenu INT = (SELECT COUNT(*) FROM dbo.SanPham_ChiNhanh);
DECLARE @SoNguyenLieu INT = (SELECT COUNT(*) FROM dbo.NguyenLieu);
DECLARE @SoTonKho INT = (SELECT COUNT(*) FROM dbo.TonKhoNguyenLieu);
DECLARE @SoDonHang INT = (SELECT COUNT(*) FROM dbo.DonHang);
DECLARE @SoChiTietDonHang INT = (SELECT COUNT(*) FROM dbo.ChiTietDonHang);
DECLARE @TongDoanhThu DECIMAL(18,2) = (
    SELECT ISNULL(SUM(TongTien - GiamGia), 0)
    FROM dbo.DonHang
    WHERE TrangThai = N'Hoàn tất'
);

PRINT N'';
PRINT N'========================================';
PRINT N'HOÀN THÀNH TẠO DATABASE GIBOR COFFEE';
PRINT N'========================================';
PRINT N'';
PRINT N'Tài khoản demo:';
PRINT N'- ADMIN: trangiabao / 123123';
PRINT N'- QUẢN LÝ: lequangbao / 123123';
PRINT N'- NHÂN VIÊN: tranduonggiabao / 123123';
PRINT N'- KẾ TOÁN: nguyenngocchau / 123123';
PRINT N'- KHO: nguyentheanh / 123123';
PRINT N'';
PRINT N'Thống kê dữ liệu đã tạo:';
PRINT N'- Tài khoản: ' + CAST(@SoTaiKhoan AS NVARCHAR(20));
PRINT N'- Nhân viên: ' + CAST(@SoNhanVien AS NVARCHAR(20));
PRINT N'- Chi nhánh: ' + CAST(@SoChiNhanh AS NVARCHAR(20)) + N' (hoạt động: ' + CAST(@SoChiNhanhHoatDong AS NVARCHAR(20)) + N')';
PRINT N'- Danh mục: ' + CAST(@SoDanhMuc AS NVARCHAR(20));
PRINT N'- Sản phẩm: ' + CAST(@SoSanPham AS NVARCHAR(20));
PRINT N'- Biến thể: ' + CAST(@SoBienThe AS NVARCHAR(20));
PRINT N'- Menu chi nhánh: ' + CAST(@SoMenu AS NVARCHAR(20));
PRINT N'- Nguyên liệu: ' + CAST(@SoNguyenLieu AS NVARCHAR(20));
PRINT N'- Tồn kho: ' + CAST(@SoTonKho AS NVARCHAR(20));
PRINT N'- Đơn hàng: ' + CAST(@SoDonHang AS NVARCHAR(20));
PRINT N'- Chi tiết đơn hàng: ' + CAST(@SoChiTietDonHang AS NVARCHAR(20));
PRINT N'- Tổng doanh thu mẫu: ' + FORMAT(@TongDoanhThu, 'N0') + N' VNĐ';
PRINT N'========================================';

SELECT N'HeThongTaiKhoan' AS Bang, COUNT(*) AS SoLuong FROM dbo.HeThongTaiKhoan
UNION ALL SELECT N'ThongTinNhanVien', COUNT(*) FROM dbo.ThongTinNhanVien
UNION ALL SELECT N'ChiNhanh', COUNT(*) FROM dbo.ChiNhanh
UNION ALL SELECT N'DanhMuc', COUNT(*) FROM dbo.DanhMuc
UNION ALL SELECT N'SanPham', COUNT(*) FROM dbo.SanPham
UNION ALL SELECT N'BienTheSanPham', COUNT(*) FROM dbo.BienTheSanPham
UNION ALL SELECT N'SanPham_ChiNhanh', COUNT(*) FROM dbo.SanPham_ChiNhanh
UNION ALL SELECT N'NguyenLieu', COUNT(*) FROM dbo.NguyenLieu
UNION ALL SELECT N'TonKhoNguyenLieu', COUNT(*) FROM dbo.TonKhoNguyenLieu
UNION ALL SELECT N'DonHang', COUNT(*) FROM dbo.DonHang
UNION ALL SELECT N'ChiTietDonHang', COUNT(*) FROM dbo.ChiTietDonHang;

SELECT
    dm.MaDanhMuc,
    dm.TenDanhMuc,
    COUNT(sp.MaSanPham) AS SoLuongSanPham
FROM dbo.DanhMuc dm
LEFT JOIN dbo.SanPham sp ON dm.MaDanhMuc = sp.MaDanhMuc
GROUP BY dm.MaDanhMuc, dm.TenDanhMuc
ORDER BY dm.MaDanhMuc;
GO


/* ========================= 17. SAO LƯU - PHỤC HỒI ========================= */
/*

-- Nửa đêm (ví dụ 23h00 hoặc 00h00) Chủ Nhật:
-- A. FULL BACKUP
BACKUP DATABASE QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_FULL.bak'
WITH INIT

-- 17h hằng ngày: Chạy Differential Backup
-- B. DIFFERENTIAL BACKUP
BACKUP DATABASE QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_DIFF.bak'
WITH DIFFERENTIAL, INIT

-- C. LOG BACKUP
BACKUP LOG QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_LOG.trn'
WITH INIT


-- D. PHỤC HỒI CSDL
BACKUP LOG QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_Tail.trn'
WITH INIT

RESTORE DATABASE QuanLyChuoiCaPhe
FROM DISK = 'C:\Backup\QuanLyChuoiCaPhe_FULL.bak'
WITH NORECOVERY;

RESTORE DATABASE QuanLyChuoiCaPhe
FROM DISK = 'C:\Backup\QuanLyChuoiCaPhe_DIFF.bak'
WITH NORECOVERY;

RESTORE LOG QuanLyChuoiCaPhe
FROM DISK = 'C:\Backup\QuanLyChuoiCaPhe_Tail.trn'
WITH RECOVERY
*/
GO

/* ========================= 18. QUẢN TRỊ NGƯỜI DÙNG - PHÂN QUYỀN ========================= */
/*

USE QuanLyChuoiCaPhe;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'qlcf_admin')
    CREATE USER qlcf_admin FOR LOGIN qlcf_admin;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'qlcf_staff')
    CREATE USER qlcf_staff FOR LOGIN qlcf_staff;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_quanly')
    CREATE ROLE role_quanly;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_nhanvien')
    CREATE ROLE role_nhanvien;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.DonHang TO role_quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ChiTietDonHang TO role_quanly;
GRANT SELECT, INSERT, UPDATE ON dbo.KhachHang TO role_quanly;
GRANT SELECT ON dbo.vw_BangLuongTongHop TO role_quanly;
GRANT EXECUTE ON dbo.sp_TaoDonHang TO role_quanly;
GRANT EXECUTE ON dbo.sp_GhiNhanGiaoDichKho TO role_quanly;

GRANT SELECT, INSERT ON dbo.DonHang TO role_nhanvien;
GRANT SELECT, INSERT ON dbo.ChiTietDonHang TO role_nhanvien;
GRANT SELECT, INSERT, UPDATE ON dbo.KhachHang TO role_nhanvien;
GRANT EXECUTE ON dbo.sp_TaoDonHang TO role_nhanvien;

ALTER ROLE role_quanly ADD MEMBER qlcf_admin;
ALTER ROLE role_nhanvien ADD MEMBER qlcf_staff;
*/
GO


/* ========================= 17. SAO LƯU - PHỤC HỒI ========================= */
/*
-- A. FULL BACKUP
BACKUP DATABASE QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_FULL.bak'
WITH INIT

-- B. DIFFERENTIAL BACKUP
BACKUP DATABASE QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_DIFF.bak'
WITH DIFFERENTIAL, INIT

-- C. LOG BACKUP
BACKUP LOG QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_LOG.trn'
WITH INIT


-- D. PHỤC HỒI CSDL
BACKUP LOG QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_Tail.trn'
WITH INIT

RESTORE DATABASE QuanLyChuoiCaPhe
FROM DISK = 'C:\Backup\QuanLyChuoiCaPhe_FULL.bak'
WITH NORECOVERY;

RESTORE DATABASE QuanLyChuoiCaPhe
FROM DISK = 'C:\Backup\QuanLyChuoiCaPhe_DIFF.bak'
WITH NORECOVERY;

RESTORE LOG QuanLyChuoiCaPhe
FROM DISK = 'C:\Backup\QuanLyChuoiCaPhe_Tail.trn'
WITH RECOVERY
*/
GO

/*
--    1 lần/tuần vào đêm Chủ Nhật
DECLARE @FileName VARCHAR(256)
-- Tự động tạo tên file dạng: QuanLyChuoiCaPhe_FULL_20260611_235959.bak
SET @FileName = 'C:\Backup\QuanLyChuoiCaPhe_FULL_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + '.bak'

BACKUP DATABASE QuanLyChuoiCaPhe
TO DISK = @FileName
WITH FORMAT, COMPRESSION, STATS = 10;
GO

--     1 lần/ngày vào cuối ngày
DECLARE @FileName VARCHAR(256)
-- Tự động tạo tên file dạng: QuanLyChuoiCaPhe_DIFF_20260611_230000.bak
SET @FileName = 'C:\Backup\QuanLyChuoiCaPhe_DIFF_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + '.bak'

BACKUP DATABASE QuanLyChuoiCaPhe
TO DISK = @FileName
WITH DIFFERENTIAL, FORMAT, COMPRESSION, STATS = 10;
GO

-- Định kỳ 1 tiếng một lần trong ngày
DECLARE @FileName VARCHAR(256)
-- Tự động tạo tên file dạng: QuanLyChuoiCaPhe_LOG_20260611_140000.trn
SET @FileName = 'C:\Backup\QuanLyChuoiCaPhe_LOG_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss') + '.trn'

BACKUP LOG QuanLyChuoiCaPhe
TO DISK = @FileName
WITH FORMAT, COMPRESSION, STATS = 10;
GO

-- Xóa file FULL và DIFF (.bak) đã quá 14 ngày (336 giờ)
EXECUTE <sys>.<xp_delete_file> 
    0, -- 0 là xóa file backup, 1 là xóa file log của SQL
    N'C:\Backup\', -- Đường dẫn thư mục chứa file
    N'bak', -- Đuôi file cần xóa
    N'2026-06-11T23:00:00', -- SQL sẽ tự tính thời gian dựa trên tham số tiếp theo
    1; -- 1 là xóa cả trong thư mục con

-- Xóa file LOG (.trn) đã quá 14 ngày
EXECUTE <sys>.<xp_delete_file> 
    0, 
    N'C:\Backup\', 
    N'trn', 
    N'2026-06-11T23:00:00', 
    1;

*/

/* ========================= 18. QUẢN TRỊ NGƯỜI DÙNG - PHÂN QUYỀN ========================= */
/*

USE QuanLyChuoiCaPhe;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'qlcf_admin')
    CREATE USER qlcf_admin FOR LOGIN qlcf_admin;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'qlcf_staff')
    CREATE USER qlcf_staff FOR LOGIN qlcf_staff;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_quanly')
    CREATE ROLE role_quanly;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_nhanvien')
    CREATE ROLE role_nhanvien;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.DonHang TO role_quanly;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ChiTietDonHang TO role_quanly;
GRANT SELECT, INSERT, UPDATE ON dbo.KhachHang TO role_quanly;
GRANT SELECT ON dbo.vw_BangLuongTongHop TO role_quanly;
GRANT EXECUTE ON dbo.sp_TaoDonHang TO role_quanly;
GRANT EXECUTE ON dbo.sp_GhiNhanGiaoDichKho TO role_quanly;

GRANT SELECT, INSERT ON dbo.DonHang TO role_nhanvien;
GRANT SELECT, INSERT ON dbo.ChiTietDonHang TO role_nhanvien;
GRANT SELECT, INSERT, UPDATE ON dbo.KhachHang TO role_nhanvien;
GRANT EXECUTE ON dbo.sp_TaoDonHang TO role_nhanvien;

ALTER ROLE role_quanly ADD MEMBER qlcf_admin;
ALTER ROLE role_nhanvien ADD MEMBER qlcf_staff;
*/
GO

