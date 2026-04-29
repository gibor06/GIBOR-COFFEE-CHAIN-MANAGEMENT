/*
    ======================================================================
                        ĐỒ ÁN QUẢN LÝ CHUỖI CỬA HÀNG CÀ PHÊ
    ======================================================================
*/

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN GIA BẢO --

/* =============================================================================================================== */

/* ========================= 0. TẠO CSDL ========================= */
IF DB_ID(N'QuanLyChuoiCaPhe') IS NULL
BEGIN
    CREATE DATABASE QuanLyChuoiCaPhe;
END
GO

USE QuanLyChuoiCaPhe;
GO

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
IF OBJECT_ID(N'dbo.TRG_SanPham_CapNhatTrangThaiBienThe', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_SanPham_CapNhatTrangThaiBienThe;
IF OBJECT_ID(N'dbo.TRG_LichSuKho_CapNhatTon', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_LichSuKho_CapNhatTon;
IF OBJECT_ID(N'dbo.TRG_ChiTietDonHang_CapNhatTongTien', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_ChiTietDonHang_CapNhatTongTien;
IF OBJECT_ID(N'dbo.TRG_DonHang_CapNhatDiem', N'TR') IS NOT NULL DROP TRIGGER dbo.TRG_DonHang_CapNhatDiem;
GO

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
IF OBJECT_ID(N'dbo.BangLuong', N'U') IS NOT NULL DROP TABLE dbo.BangLuong;
IF OBJECT_ID(N'dbo.PhatDiMuon', N'U') IS NOT NULL DROP TABLE dbo.PhatDiMuon;
IF OBJECT_ID(N'dbo.ChamCong', N'U') IS NOT NULL DROP TABLE dbo.ChamCong;
IF OBJECT_ID(N'dbo.LichPhanCong', N'U') IS NOT NULL DROP TABLE dbo.LichPhanCong;
IF OBJECT_ID(N'dbo.NgayDacBiet', N'U') IS NOT NULL DROP TABLE dbo.NgayDacBiet;
IF OBJECT_ID(N'dbo.CaLamViec', N'U') IS NOT NULL DROP TABLE dbo.CaLamViec;
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
    SoCanCuoc       VARCHAR(12)     NOT NULL,
    Email           VARCHAR(100)    NULL,
    TrangThai       BIT             NOT NULL CONSTRAINT DF_ThongTinNhanVien_TrangThai DEFAULT 1,
    CONSTRAINT PK_ThongTinNhanVien PRIMARY KEY (MaNV),
    CONSTRAINT FK_ThongTinNhanVien_ChucVu FOREIGN KEY (MaChucVu) REFERENCES dbo.ChucVuNhanVien(MaChucVu),
    CONSTRAINT FK_ThongTinNhanVien_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT UQ_ThongTinNhanVien_CCCD UNIQUE (SoCanCuoc),
    CONSTRAINT UQ_ThongTinNhanVien_SDT UNIQUE (SoDienThoai),
    CONSTRAINT CHK_ThongTinNhanVien_Loai CHECK (LoaiNV IN (1,2)),
    CONSTRAINT CHK_ThongTinNhanVien_SDT CHECK (SoDienThoai NOT LIKE '%[^0-9]%' AND LEN(SoDienThoai)=10),
    CONSTRAINT CHK_ThongTinNhanVien_CCCD CHECK (SoCanCuoc NOT LIKE '%[^0-9]%' AND LEN(SoCanCuoc)=12),
    CONSTRAINT CHK_ThongTinNhanVien_Ngay CHECK (NgayNghiViec IS NULL OR NgayNghiViec >= NgayVaoLam)
);
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
    CONSTRAINT PK_TonKhoNguyenLieu PRIMARY KEY (MaChiNhanh, MaNguyenLieu),
    CONSTRAINT FK_TonKhoNguyenLieu_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_TonKhoNguyenLieu_NguyenLieu FOREIGN KEY (MaNguyenLieu) REFERENCES dbo.NguyenLieu(MaNguyenLieu),
    CONSTRAINT CHK_TonKhoNguyenLieu_SoLuong CHECK (SoLuongTon >= 0 AND MucCanhBao >= 0)
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
    CONSTRAINT CHK_LichSuKho_Loai CHECK (LoaiGiaoDich IN (N'Nhập', N'Xuất', N'Hao hụt', N'Hết hạn')),
    CONSTRAINT CHK_LichSuKho_SoLuong CHECK (SoLuong > 0)
);
GO
/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN DƯƠNG GIA BẢO --

/* =============================================================================================================== */
/* ========================= 7. KHÁCH HÀNG - ĐƠN HÀNG ========================= */
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

CREATE TABLE dbo.DonHang
(
    MaDH                CHAR(6)         NOT NULL,
    MaChiNhanh          CHAR(10)        NOT NULL,
    MaNV                CHAR(10)        NOT NULL,
    MaKH                CHAR(6)         NULL,
    TongTien            DECIMAL(18,2)   NOT NULL CONSTRAINT DF_DonHang_TongTien DEFAULT 0,
    GiamGia             DECIMAL(18,2)   NOT NULL CONSTRAINT DF_DonHang_GiamGia DEFAULT 0,
    PhuongThucThanhToan NVARCHAR(30)    NOT NULL CONSTRAINT DF_DonHang_PTTT DEFAULT N'Tiền mặt',
    TrangThai           NVARCHAR(20)    NOT NULL CONSTRAINT DF_DonHang_TrangThai DEFAULT N'Khởi tạo',
    NgayTao             DATETIME2(0)    NOT NULL CONSTRAINT DF_DonHang_NgayTao DEFAULT SYSDATETIME(),
    CONSTRAINT PK_DonHang PRIMARY KEY (MaDH),
    CONSTRAINT FK_DonHang_ChiNhanh FOREIGN KEY (MaChiNhanh) REFERENCES dbo.ChiNhanh(MaChiNhanh),
    CONSTRAINT FK_DonHang_NV FOREIGN KEY (MaNV) REFERENCES dbo.ThongTinNhanVien(MaNV),
    CONSTRAINT FK_DonHang_KH FOREIGN KEY (MaKH) REFERENCES dbo.KhachHang(MaKH),
    CONSTRAINT CHK_DonHang_Tien CHECK (TongTien >= 0 AND GiamGia >= 0 AND GiamGia <= TongTien),
    CONSTRAINT CHK_DonHang_TrangThai CHECK (TrangThai IN (N'Khởi tạo', N'Hoàn tất', N'Hủy')),
    CONSTRAINT CHK_DonHang_PTTT CHECK (PhuongThucThanhToan IN (N'Tiền mặt', N'Thẻ', N'Chuyển khoản', N'QR', N'Ví điện tử'))
);
GO

CREATE TABLE dbo.ChiTietDonHang
(
    MaCTDH          CHAR(10)        NOT NULL,
    MaDH            CHAR(6)         NOT NULL,
    MaBienThe       CHAR(10)        NOT NULL,
    SoLuong         INT             NOT NULL,
    DonGia          DECIMAL(18,2)   NOT NULL,
    GhiChu          NVARCHAR(200)   NULL,
    CONSTRAINT PK_ChiTietDonHang PRIMARY KEY (MaCTDH),
    CONSTRAINT FK_ChiTietDonHang_DonHang FOREIGN KEY (MaDH) REFERENCES dbo.DonHang(MaDH),
    CONSTRAINT FK_ChiTietDonHang_BienThe FOREIGN KEY (MaBienThe) REFERENCES dbo.BienTheSanPham(MaBienThe),
    CONSTRAINT UQ_ChiTietDonHang UNIQUE (MaDH, MaBienThe),
    CONSTRAINT CHK_ChiTietDonHang_SoLuong CHECK (SoLuong > 0),
    CONSTRAINT CHK_ChiTietDonHang_DonGia CHECK (DonGia >= 0)
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

CREATE FUNCTION dbo.fn_TinhTongTienDonHang
(
    @MaDH CHAR(6)
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

CREATE FUNCTION dbo.fn_TinhDiemTichLuyDonHang
(
    @TongSauGiam DECIMAL(18,2)
)
RETURNS INT
AS
BEGIN
    RETURN CASE WHEN @TongSauGiam <= 0 THEN 0 ELSE FLOOR(@TongSauGiam / 10000.0) END;
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
        THROW 50001, N'Không thể phân ca cho nhân viên đã nghỉ việc.', 1;
    END;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.ThongTinNhanVien nv ON i.MaNV = nv.MaNV
        WHERE i.NgayLamViec < nv.NgayVaoLam
    )
    BEGIN
        THROW 50002, N'Ngày làm việc phải lớn hơn hoặc bằng ngày vào làm.', 1;
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
            THROW 50003, N'Không thể chấm công cho ca hủy hoặc nghỉ phép.', 1;
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
        THROW 50004, N'Bảng lương đã thanh toán thì không được phép chỉnh sửa.', 1;
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
CREATE TRIGGER dbo.TRG_SanPham_CapNhatTrangThaiBienThe
ON dbo.SanPham
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(TrangThai)
    BEGIN
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
        WHERE i.LoaiGiaoDich IN (N'Xuất', N'Hao hụt', N'Hết hạn')
          AND tk.SoLuongTon < i.SoLuong
    )
    BEGIN
        THROW 50005, N'Số lượng tồn kho không đủ để thực hiện giao dịch xuất/trừ.', 1;
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
CREATE TRIGGER dbo.TRG_DonHang_CapNhatDiem
ON dbo.DonHang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Cu AS
    (
        SELECT MaKH,
               SUM(dbo.fn_TinhDiemTichLuyDonHang(TongTien - GiamGia)) AS DiemCong,
               SUM(CAST(GiamGia / 1000.0 AS INT)) AS DiemDung
        FROM deleted
        WHERE MaKH IS NOT NULL AND TrangThai = N'Hoàn tất'
        GROUP BY MaKH
    ),
    Moi AS
    (
        SELECT MaKH,
               SUM(dbo.fn_TinhDiemTichLuyDonHang(TongTien - GiamGia)) AS DiemCong,
               SUM(CAST(GiamGia / 1000.0 AS INT)) AS DiemDung
        FROM inserted
        WHERE MaKH IS NOT NULL AND TrangThai = N'Hoàn tất'
        GROUP BY MaKH
    ),
    BienDong AS
    (
        SELECT MaKH, -DiemCong + DiemDung AS Delta FROM Cu
        UNION ALL
        SELECT MaKH, DiemCong - DiemDung AS Delta FROM Moi
    ),
    TongHop AS
    (
        SELECT MaKH, SUM(Delta) AS Delta
        FROM BienDong
        GROUP BY MaKH
    )
    UPDATE kh
    SET kh.DiemTichLuy = kh.DiemTichLuy + th.Delta
    FROM dbo.KhachHang kh
    JOIN TongHop th ON kh.MaKH = th.MaKH;

    IF EXISTS (SELECT 1 FROM dbo.KhachHang WHERE DiemTichLuy < 0)
    BEGIN
        THROW 50006, N'Điểm tích lũy của khách hàng không được âm.', 1;
    END;
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
            THROW 50010, N'Chưa khởi tạo tồn kho cho chi nhánh và nguyên liệu này.', 1;
        END;

        INSERT INTO dbo.LichSuKho(LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong, GhiChu)
        VALUES (@LogID, @MaChiNhanh, @MaNguyenLieu, @LoaiGiaoDich, @SoLuong, @GhiChu);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/* =============================================================================================================== */

                                            -- CODE BỞI TRẦN DƯƠNG GIA BẢO --

/* =============================================================================================================== */
CREATE PROCEDURE dbo.sp_TaoDonHang
    @MaDH CHAR(6),
    @MaChiNhanh CHAR(10),
    @MaNV CHAR(10),
    @MaKH CHAR(6) = NULL,
    @PhuongThucThanhToan NVARCHAR(30) = N'Tiền mặt',
    @GiamGia DECIMAL(18,2) = 0,
    @MaBienThe1 CHAR(10) = NULL,
    @SoLuong1 INT = NULL,
    @MaBienThe2 CHAR(10) = NULL,
    @SoLuong2 INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO dbo.DonHang(MaDH, MaChiNhanh, MaNV, MaKH, GiamGia, PhuongThucThanhToan, TrangThai)
        VALUES (@MaDH, @MaChiNhanh, @MaNV, @MaKH, @GiamGia, @PhuongThucThanhToan, N'Khởi tạo');

        IF @MaBienThe1 IS NOT NULL AND @SoLuong1 IS NOT NULL
        BEGIN
            INSERT INTO dbo.ChiTietDonHang(MaCTDH, MaDH, MaBienThe, SoLuong, DonGia)
            SELECT 'CT' + RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS VARCHAR(8)), 8),
                   @MaDH,
                   bt.MaBienThe,
                   @SoLuong1,
                   sp.GiaCoBan + bt.GiaCongThem
            FROM dbo.BienTheSanPham bt
            JOIN dbo.SanPham sp ON bt.MaSanPham = sp.MaSanPham
            WHERE bt.MaBienThe = @MaBienThe1;
        END;

        IF @MaBienThe2 IS NOT NULL AND @SoLuong2 IS NOT NULL
        BEGIN
            INSERT INTO dbo.ChiTietDonHang(MaCTDH, MaDH, MaBienThe, SoLuong, DonGia)
            SELECT 'CT' + RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS VARCHAR(8)), 8),
                   @MaDH,
                   bt.MaBienThe,
                   @SoLuong2,
                   sp.GiaCoBan + bt.GiaCongThem
            FROM dbo.BienTheSanPham bt
            JOIN dbo.SanPham sp ON bt.MaSanPham = sp.MaSanPham
            WHERE bt.MaBienThe = @MaBienThe2;
        END;

        UPDATE dbo.DonHang
        SET TongTien = dbo.fn_TinhTongTienDonHang(@MaDH)
        WHERE MaDH = @MaDH;

        IF EXISTS (SELECT 1 FROM dbo.DonHang WHERE MaDH = @MaDH AND GiamGia > TongTien)
        BEGIN
            THROW 50011, N'Giảm giá không được lớn hơn tổng tiền đơn hàng.', 1;
        END;

        UPDATE dbo.DonHang
        SET TrangThai = N'Hoàn tất'
        WHERE MaDH = @MaDH;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
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
            @MucCanhBao DECIMAL(18,2),
            @MaLog CHAR(10);

    DECLARE cur_canhbao CURSOR FOR
        SELECT MaChiNhanh, MaNguyenLieu, SoLuongTon, MucCanhBao
        FROM dbo.TonKhoNguyenLieu
        WHERE SoLuongTon <= MucCanhBao;

    OPEN cur_canhbao;
    FETCH NEXT FROM cur_canhbao INTO @MaChiNhanh, @MaNguyenLieu, @SoLuongTon, @MucCanhBao;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @MaLog = 'CB' + RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS VARCHAR(8)), 8);

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

        FETCH NEXT FROM cur_canhbao INTO @MaChiNhanh, @MaNguyenLieu, @SoLuongTon, @MucCanhBao;
    END;

    CLOSE cur_canhbao;
    DEALLOCATE cur_canhbao;
END;
GO

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
JOIN dbo.BienTheSanPham bt ON sp.MaSanPham = bt.MaSanPham;
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
    ('TK00', 'trangiabao', '123123', 'ADMIN', 1, '2025-02-03T09:16:00'),
    ('TK01', 'tranduonggiabao', '123123', 'ADMIN', 1, '2025-02-03T09:16:00'),
    ('TK02', 'lequangbao', '123123', 'ADMIN', 1, '2025-02-03T09:16:00'),
    ('TK03', 'nguyenngocchau', '123123', 'ADMIN', 1, '2025-02-03T09:16:00')

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
    ('TK00000016', 'vothuchi16', 'sha256$0c5186c0ce917b1fffe2775c9b45bb3cb02cf92c31fc49b1079564ce9207ad0d', 'ADMIN', 1, '2025-07-06T15:31:00'),
    ('TK00000017', 'vocongcuong17', 'sha256$a85d4f513d0ed46983390dae3a8257259874c47927e9ed6e3ed2f7b0181ffa57', 'ADMIN', 1, '2025-08-08T16:32:00'),
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

INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCanCuoc, Email, TrangThai) VALUES
    ('NV00000001', 2, N'Trần Văn Khang', 'CV00000001', 'CN00000001', '2023-04-05', NULL, '0782097999', '966616964001', 'tranvankhang.01@maycoffee.vn', 1),
    ('NV00000002', 2, N'Trần Phương Hiền', 'CV00000002', 'CN00000002', '2024-05-07', NULL, '0989639081', '977358886002', 'tranphuonghien.02@maycoffee.vn', 1),
    ('NV00000003', 2, N'Hoàng Anh Đức', 'CV00000003', 'CN00000003', '2022-06-09', NULL, '0789038526', '211225158003', 'hoanganhduc.03@maycoffee.vn', 1),
    ('NV00000004', 1, N'Đặng Thanh Thảo', 'CV00000004', 'CN00000004', '2023-07-11', NULL, '0335496015', '223940587004', 'dangthanhthao.04@maycoffee.vn', 1),
    ('NV00000005', 1, N'Bùi Anh Hiếu', 'CV00000005', 'CN00000005', '2024-08-13', NULL, '0999645480', '694019365005', 'buianhhieu.05@maycoffee.vn', 1),
    ('NV00000006', 2, N'Ngô Khánh Ngân', 'CV00000006', 'CN00000006', '2022-09-15', NULL, '0336553958', '402533494006', 'ngokhanhngan.06@maycoffee.vn', 1),
    ('NV00000007', 2, N'Phạm Hữu Cường', 'CV00000007', 'CN00000007', '2023-10-17', NULL, '0396316277', '468164906007', 'phamhuucuong.07@maycoffee.vn', 1),
    ('NV00000008', 2, N'Đỗ Mai Mai', 'CV00000008', 'CN00000008', '2024-11-19', NULL, '0392274302', '781007818008', 'domaimai.08@maycoffee.vn', 1),
    ('NV00000009', 2, 'Phan Thanh Nam', 'CV00000009', 'CN00000009', '2022-12-21', NULL, '0767834855', '624557080009', 'phanthanhnam.09@maycoffee.vn', 1),
    ('NV00000010', 2, N'Dương Thị Vy', 'CV00000010', 'CN00000010', '2023-01-23', NULL, '0706818112', '199104722010', 'duongthivy.10@maycoffee.vn', 1);
GO
INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCanCuoc, Email, TrangThai) VALUES
    ('NV00000011', 1, N'Đỗ Hữu Bảo', 'CV00000011', 'CN00000011', '2024-02-25', NULL, '0837135391', '147337803011', 'dohuubao.11@maycoffee.vn', 1),
    ('NV00000012', 1, N'Phan Bảo Diễm', 'CV00000012', 'CN00000012', '2022-03-27', NULL, '0944769200', '927982963012', 'phanbaodiem.12@maycoffee.vn', 1),
    ('NV00000013', 1, N'Phạm Quốc Đức', 'CV00000013', 'CN00000013', '2023-04-04', NULL, '0385511909', '381272327013', 'phamquocduc.13@maycoffee.vn', 1),
    ('NV00000014', 1, N'Đặng Khánh Giang', 'CV00000014', 'CN00000014', '2024-05-06', NULL, '0399486328', '574417266014', 'dangkhanhgiang.14@maycoffee.vn', 1),
    ('NV00000015', 1, N'Phan Minh Hùng', 'CV00000015', 'CN00000015', '2022-06-08', NULL, '0875283645', '110382761015', 'phanminhhung.15@maycoffee.vn', 1),
    ('NV00000016', 1, N'Võ Thu Chi', 'CV00000016', 'CN00000016', '2023-07-10', NULL, '0910099059', '841976666016', 'vothuchi.16@maycoffee.vn', 1),
    ('NV00000017', 1, N'Võ Công Cường', 'CV00000017', 'CN00000017', '2024-08-12', NULL, '0373227889', '138684919017', 'vocongcuong.17@maycoffee.vn', 1),
    ('NV00000018', 1, N'Nguyễn Phương An', 'CV00000018', 'CN00000018', '2022-09-14', NULL, '0778183110', '693269304018', 'nguyenphuongan.18@maycoffee.vn', 1),
    ('NV00000019', 1, N'Trần Quốc Đạt', 'CV00000019', 'CN00000019', '2023-10-16', NULL, '0357684996', '236843584019', 'tranquocdat.19@maycoffee.vn', 1),
    ('NV00000020', 1, N'Phan Khánh Nhung', 'CV00000020', 'CN00000020', '2024-11-18', NULL, '0941373735', '491541578020', 'phankhanhnhung.20@maycoffee.vn', 1);
GO
INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCanCuoc, Email, TrangThai) VALUES
    ('NV00000021', 1, N'Phạm Thanh Bảo', 'CV00000021', 'CN00000021', '2022-12-20', NULL, '0948024342', '325567963021', 'phamthanhbao.21@maycoffee.vn', 1),
    ('NV00000022', 1, N'Lê Mai An', 'CV00000022', 'CN00000022', '2023-01-22', NULL, '0389514287', '210373808022', 'lemaian.22@maycoffee.vn', 1),
    ('NV00000023', 1, N'Phan Đức Nam', 'CV00000023', 'CN00000023', '2024-02-24', NULL, '0775146293', '536344399023', 'phanducnam.23@maycoffee.vn', 1),
    ('NV00000024', 1, N'Hoàng Mai Yến', 'CV00000024', 'CN00000024', '2022-03-26', NULL, '0331774346', '274484941024', 'hoangmaiyen.24@maycoffee.vn', 1),
    ('NV00000025', 1, N'Hồ Công Vinh', 'CV00000025', 'CN00000025', '2023-04-03', NULL, '0355337219', '126614158025', 'hocongvinh.25@maycoffee.vn', 1),
    ('NV00000026', 1, N'Hồ Khánh Giang', 'CV00000026', 'CN00000026', '2024-05-05', NULL, '0398860009', '456681425026', 'hokhanhgiang.26@maycoffee.vn', 1),
    ('NV00000027', 1, N'Phạm Đức Đức', 'CV00000027', 'CN00000027', '2022-06-07', NULL, '0889913412', '889262019027', 'phamducduc.27@maycoffee.vn', 1),
    ('NV00000028', 1, N'Nguyễn Quỳnh Quỳnh', 'CV00000028', 'CN00000028', '2023-07-09', NULL, '0335810056', '270937380028', 'nguyenquynhquynh.28@maycoffee.vn', 1),
    ('NV00000029', 1, N'Nguyễn Gia Bảo', 'CV00000029', 'CN00000029', '2024-08-11', NULL, '0951343880', '141580226029', 'nguyengiabao.29@maycoffee.vn', 1),
    ('NV00000030', 1, N'Nguyễn Quỳnh Nhung', 'CV00000030', 'CN00000030', '2022-09-13', NULL, '0829854548', '314289692030', 'nguyenquynhnhung.30@maycoffee.vn', 1);
GO
INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCanCuoc, Email, TrangThai) VALUES
    ('NV00000031', 1, N'Đặng Công Đạt', 'CV00000031', 'CN00000031', '2023-10-15', NULL, '0846930359', '427696198031', 'dangcongdat.31@maycoffee.vn', 1),
    ('NV00000032', 1, N'Nguyễn Phương Chi', 'CV00000032', 'CN00000032', '2024-11-17', NULL, '0329920292', '125409494032', 'nguyenphuongchi.32@maycoffee.vn', 1),
    ('NV00000033', 1, N'Dương Minh Bình', 'CV00000033', 'CN00000033', '2022-12-19', NULL, '0353481198', '452468587033', 'duongminhbinh.33@maycoffee.vn', 1),
    ('NV00000034', 1, N'Bùi Ngọc Vy', 'CV00000034', 'CN00000034', '2023-01-21', NULL, '0709317495', '930353157034', 'buingocvy.34@maycoffee.vn', 1),
    ('NV00000035', 1, N'Dương Quốc Long', 'CV00000035', 'CN00000035', '2024-02-23', NULL, '0747130035', '788785773035', 'duongquoclong.35@maycoffee.vn', 1),
    ('NV00000036', 1, N'Trần Quỳnh Hiền', 'CV00000036', 'CN00000036', '2022-03-25', NULL, '0891203377', '675757257036', 'tranquynhhien.36@maycoffee.vn', 1),
    ('NV00000037', 1, N'Bùi Xuân Bảo', 'CV00000037', 'CN00000037', '2023-04-27', NULL, '0703704481', '223847257037', 'buixuanbao.37@maycoffee.vn', 1),
    ('NV00000038', 1, N'Bùi Ngọc Ngân', 'CV00000038', 'CN00000038', '2024-05-04', NULL, '0723966966', '723403479038', 'buingocngan.38@maycoffee.vn', 1),
    ('NV00000039', 1, N'Đỗ Xuân Thành', 'CV00000039', 'CN00000039', '2022-06-06', NULL, '0705134794', '216396351039', 'doxuanthanh.39@maycoffee.vn', 1),
    ('NV00000040', 1, N'Đặng Bảo Hương', 'CV00000040', 'CN00000040', '2023-07-08', NULL, '0846397338', '882269302040', 'dangbaohuong.40@maycoffee.vn', 1);
GO
INSERT INTO dbo.ThongTinNhanVien (MaNV, LoaiNV, HoTenNV, MaChucVu, MaChiNhanh, NgayVaoLam, NgayNghiViec, SoDienThoai, SoCanCuoc, Email, TrangThai) VALUES
    ('NV00000041', 2, N'Phạm Gia Hiếu', 'CV00000041', 'CN00000041', '2024-08-10', NULL, '0758571795', '750911797041', 'phamgiahieu.41@maycoffee.vn', 1),
    ('NV00000042', 2, N'Hoàng Mai Giang', 'CV00000042', 'CN00000042', '2022-09-12', NULL, '0951700055', '719106699042', 'hoangmaigiang.42@maycoffee.vn', 1),
    ('NV00000043', 2, N'Đỗ Đức Nam', 'CV00000043', 'CN00000043', '2023-10-14', NULL, '0334188276', '147659674043', 'doducnam.43@maycoffee.vn', 1),
    ('NV00000044', 2, N'Huỳnh Ngọc An', 'CV00000044', 'CN00000044', '2024-11-16', NULL, '0800226999', '658260221044', 'huynhngocan.44@maycoffee.vn', 1),
    ('NV00000045', 2, N'Võ Xuân Thành', 'CV00000045', 'CN00000045', '2022-12-18', NULL, '0348884978', '563102056045', 'voxuanthanh.45@maycoffee.vn', 1),
    ('NV00000046', 1, N'Trần Ngọc Quỳnh', 'CV00000046', 'CN00000046', '2023-01-20', NULL, '0989152472', '454549587046', 'tranngocquynh.46@maycoffee.vn', 1),
    ('NV00000047', 1, N'Phạm Công Hùng', 'CV00000047', 'CN00000047', '2024-02-22', NULL, '0789038359', '233815413047', 'phamconghung.47@maycoffee.vn', 1),
    ('NV00000048', 1, N'Lê Bảo Chi', 'CV00000048', 'CN00000048', '2022-03-24', NULL, '0768064830', '432091877048', 'lebaochi.48@maycoffee.vn', 1),
    ('NV00000049', 1, N'Phạm Gia Khánh', 'CV00000049', 'CN00000049', '2023-04-26', NULL, '0843779528', '532074125049', 'phamgiakhanh.49@maycoffee.vn', 1),
    ('NV00000050', 1, N'Lê Khánh Quỳnh', 'CV00000050', 'CN00000050', '2024-05-03', NULL, '0774411983', '236674237050', 'lekhanhquynh.50@maycoffee.vn', 1);
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

INSERT INTO dbo.DanhMuc (MaDanhMuc, TenDanhMuc, MoTa) VALUES
    ('DM00000001', N'Cà phê pha máy', N'Nhóm sản phẩm cà phê pha máy dành cho vận hành chuỗi.'),
    ('DM00000002', N'Cà phê truyền thống', N'Nhóm sản phẩm cà phê truyền thống dành cho vận hành chuỗi.'),
    ('DM00000003', 'Cold Brew', N'Nhóm sản phẩm cold brew dành cho vận hành chuỗi.'),
    ('DM00000004', N'Cà phê đá xay', N'Nhóm sản phẩm cà phê đá xay dành cho vận hành chuỗi.'),
    ('DM00000005', N'Cà phê đặc sản', N'Nhóm sản phẩm cà phê đặc sản dành cho vận hành chuỗi.'),
    ('DM00000006', N'Trà trái cây', N'Nhóm sản phẩm trà trái cây dành cho vận hành chuỗi.'),
    ('DM00000007', N'Trà sữa', N'Nhóm sản phẩm trà sữa dành cho vận hành chuỗi.'),
    ('DM00000008', N'Trà macchiato', N'Nhóm sản phẩm trà macchiato dành cho vận hành chuỗi.'),
    ('DM00000009', N'Trà nóng', N'Nhóm sản phẩm trà nóng dành cho vận hành chuỗi.'),
    ('DM00000010', 'Matcha', N'Nhóm sản phẩm matcha dành cho vận hành chuỗi.');
GO
INSERT INTO dbo.DanhMuc (MaDanhMuc, TenDanhMuc, MoTa) VALUES
    ('DM00000011', 'Chocolate', N'Nhóm sản phẩm chocolate dành cho vận hành chuỗi.'),
    ('DM00000012', 'Yogurt', N'Nhóm sản phẩm yogurt dành cho vận hành chuỗi.'),
    ('DM00000013', N'Nước ép', N'Nhóm sản phẩm nước ép dành cho vận hành chuỗi.'),
    ('DM00000014', N'Soda Ý', N'Nhóm sản phẩm soda ý dành cho vận hành chuỗi.'),
    ('DM00000015', N'Đá xay không cà phê', N'Nhóm sản phẩm đá xay không cà phê dành cho vận hành chuỗi.'),
    ('DM00000016', N'Bánh ngọt', N'Nhóm sản phẩm bánh ngọt dành cho vận hành chuỗi.'),
    ('DM00000017', N'Bánh mặn', N'Nhóm sản phẩm bánh mặn dành cho vận hành chuỗi.'),
    ('DM00000018', N'Bữa sáng', N'Nhóm sản phẩm bữa sáng dành cho vận hành chuỗi.'),
    ('DM00000019', N'Topping đóng gói', N'Nhóm sản phẩm topping đóng gói dành cho vận hành chuỗi.'),
    ('DM00000020', N'Hạt rang', N'Nhóm sản phẩm hạt rang dành cho vận hành chuỗi.');
GO
INSERT INTO dbo.DanhMuc (MaDanhMuc, TenDanhMuc, MoTa) VALUES
    ('DM00000021', N'Cà phê đóng chai', N'Nhóm sản phẩm cà phê đóng chai dành cho vận hành chuỗi.'),
    ('DM00000022', N'Trà đóng chai', N'Nhóm sản phẩm trà đóng chai dành cho vận hành chuỗi.'),
    ('DM00000023', N'Combo văn phòng', N'Nhóm sản phẩm combo văn phòng dành cho vận hành chuỗi.'),
    ('DM00000024', N'Combo học sinh', N'Nhóm sản phẩm combo học sinh dành cho vận hành chuỗi.'),
    ('DM00000025', N'Combo cặp đôi', N'Nhóm sản phẩm combo cặp đôi dành cho vận hành chuỗi.'),
    ('DM00000026', N'Combo gia đình', N'Nhóm sản phẩm combo gia đình dành cho vận hành chuỗi.'),
    ('DM00000027', N'Món theo mùa xuân', N'Nhóm sản phẩm món theo mùa xuân dành cho vận hành chuỗi.'),
    ('DM00000028', N'Món theo mùa hè', N'Nhóm sản phẩm món theo mùa hè dành cho vận hành chuỗi.'),
    ('DM00000029', N'Món theo mùa thu', N'Nhóm sản phẩm món theo mùa thu dành cho vận hành chuỗi.'),
    ('DM00000030', N'Món theo mùa đông', N'Nhóm sản phẩm món theo mùa đông dành cho vận hành chuỗi.');
GO
INSERT INTO dbo.DanhMuc (MaDanhMuc, TenDanhMuc, MoTa) VALUES
    ('DM00000031', 'Signature House Blend', N'Nhóm sản phẩm signature house blend dành cho vận hành chuỗi.'),
    ('DM00000032', 'Espresso Bar', N'Nhóm sản phẩm espresso bar dành cho vận hành chuỗi.'),
    ('DM00000033', N'Brew thủ công', N'Nhóm sản phẩm brew thủ công dành cho vận hành chuỗi.'),
    ('DM00000034', N'Phin Việt Nam', N'Nhóm sản phẩm phin việt nam dành cho vận hành chuỗi.'),
    ('DM00000035', 'Latte Art', N'Nhóm sản phẩm latte art dành cho vận hành chuỗi.'),
    ('DM00000036', N'Menu ít đường', N'Nhóm sản phẩm menu ít đường dành cho vận hành chuỗi.'),
    ('DM00000037', 'Menu healthy', N'Nhóm sản phẩm menu healthy dành cho vận hành chuỗi.'),
    ('DM00000038', 'Menu vegan', N'Nhóm sản phẩm menu vegan dành cho vận hành chuỗi.'),
    ('DM00000039', N'Menu ít caffeine', N'Nhóm sản phẩm menu ít caffeine dành cho vận hành chuỗi.'),
    ('DM00000040', 'Menu premium', N'Nhóm sản phẩm menu premium dành cho vận hành chuỗi.');
GO
INSERT INTO dbo.DanhMuc (MaDanhMuc, TenDanhMuc, MoTa) VALUES
    ('DM00000041', N'Menu giá tốt', N'Nhóm sản phẩm menu giá tốt dành cho vận hành chuỗi.'),
    ('DM00000042', 'Menu take-away', N'Nhóm sản phẩm menu take-away dành cho vận hành chuỗi.'),
    ('DM00000043', N'Menu giao hàng', N'Nhóm sản phẩm menu giao hàng dành cho vận hành chuỗi.'),
    ('DM00000044', N'Menu hội viên', N'Nhóm sản phẩm menu hội viên dành cho vận hành chuỗi.'),
    ('DM00000045', N'Menu sự kiện', N'Nhóm sản phẩm menu sự kiện dành cho vận hành chuỗi.'),
    ('DM00000046', N'Menu lễ hội', N'Nhóm sản phẩm menu lễ hội dành cho vận hành chuỗi.'),
    ('DM00000047', N'Món giới hạn', N'Nhóm sản phẩm món giới hạn dành cho vận hành chuỗi.'),
    ('DM00000048', N'Tủ bánh lạnh', N'Nhóm sản phẩm tủ bánh lạnh dành cho vận hành chuỗi.'),
    ('DM00000049', N'Phụ kiện quầy bar', N'Nhóm sản phẩm phụ kiện quầy bar dành cho vận hành chuỗi.'),
    ('DM00000050', N'Quà tặng doanh nghiệp', N'Nhóm sản phẩm quà tặng doanh nghiệp dành cho vận hành chuỗi.');
GO

INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
    ('SP00000001', 'DM00000001', 'Espresso House Blend', 39000.00, 1, N'Espresso blend đậm vị dùng cho quầy pha máy'),
    ('SP00000002', 'DM00000002', N'Cà phê sữa phin truyền thống', 35000.00, 1, N'Cà phê phin Robusta pha cùng sữa đặc'),
    ('SP00000003', 'DM00000003', N'Cold Brew Cam Vàng', 49000.00, 1, N'Cold brew ngâm 18 giờ kết hợp nước cam vàng'),
    ('SP00000004', 'DM00000004', N'Mocha Đá Xay', 55000.00, 1, N'Đá xay cà phê phủ sốt chocolate'),
    ('SP00000005', 'DM00000005', N'Single Origin Arabica Cầu Đất', 59000.00, 1, N'Cà phê đặc sản rang vừa từ Cầu Đất'),
    ('SP00000006', 'DM00000006', N'Trà Đào Cam Sả', 45000.00, 1, N'Trà đen đào ngâm, cam vàng và sả cây'),
    ('SP00000007', 'DM00000007', N'Trà sữa trân châu đường đen', 49000.00, 1, N'Trà sữa nền Assam kèm trân châu nâu'),
    ('SP00000008', 'DM00000008', N'Trà Ô Long Macchiato', 47000.00, 1, N'Ô long rang nhẹ phủ kem mặn'),
    ('SP00000009', 'DM00000009', N'Hồng trà mật ong nóng', 39000.00, 1, N'Hồng trà pha mật ong và lát chanh tươi'),
    ('SP00000010', 'DM00000010', 'Matcha Latte', 49000.00, 1, N'Matcha Nhật phối sữa tươi thanh vị');
GO
INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
    ('SP00000011', 'DM00000011', N'Chocolate Nóng', 45000.00, 1, N'Chocolate đen nóng cho buổi tối'),
    ('SP00000012', 'DM00000012', N'Yogurt Việt Quất', 47000.00, 1, N'Sữa chua đánh đá cùng sốt việt quất'),
    ('SP00000013', 'DM00000013', N'Nước ép Cam Cà Rốt', 43000.00, 1, N'Nước ép tươi trong ngày'),
    ('SP00000014', 'DM00000014', N'Soda Dâu Kiwi', 44000.00, 1, N'Soda Ý vị dâu và kiwi'),
    ('SP00000015', 'DM00000015', N'Cookies & Cream Đá Xay', 52000.00, 1, N'Đá xay bánh quy sữa'),
    ('SP00000016', 'DM00000016', N'Croissant Bơ', 32000.00, 1, N'Bánh sừng bò nướng bơ thơm'),
    ('SP00000017', 'DM00000017', N'Bánh mì chà bông phô mai', 38000.00, 1, N'Bánh mặn dùng buổi sáng'),
    ('SP00000018', 'DM00000018', N'Breakfast Sandwich Gà Xé', 48000.00, 1, N'Sandwich gà xé và xà lách'),
    ('SP00000019', 'DM00000019', N'Combo topping trân châu', 15000.00, 1, N'Topping dùng kèm đồ uống'),
    ('SP00000020', 'DM00000020', 'House Blend 250g', 145000.00, 1, N'Hạt rang house blend đóng gói 250g');
GO
INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
    ('SP00000021', 'DM00000021', 'Cold Brew Bottle 500ml', 68000.00, 1, N'Cold brew đóng chai dùng mang đi'),
    ('SP00000022', 'DM00000022', N'Trà Đào Chai 500ml', 62000.00, 1, N'Trà đào đóng chai bán kèm'),
    ('SP00000023', 'DM00000023', N'Combo văn phòng 2 cà phê 2 bánh', 159000.00, 1, N'Combo đặt họp nhóm nhỏ'),
    ('SP00000024', 'DM00000024', N'Combo học nhóm 2 trà 2 bánh', 149000.00, 1, N'Combo tiết kiệm cho nhóm 2 người'),
    ('SP00000025', 'DM00000025', N'Combo cặp đôi Latte & Cake', 129000.00, 1, N'Combo đồ uống và bánh cho 2 người'),
    ('SP00000026', 'DM00000026', N'Combo gia đình 4 nước 2 bánh', 289000.00, 1, N'Combo giao hàng cuối tuần'),
    ('SP00000027', 'DM00000027', 'Spring Blossom Tea', 52000.00, 1, N'Trà hoa quả theo mùa xuân'),
    ('SP00000028', 'DM00000028', 'Summer Passion Cooler', 54000.00, 1, N'Thức uống mát lạnh mùa hè'),
    ('SP00000029', 'DM00000029', 'Autumn Cinnamon Latte', 56000.00, 1, N'Latte quế theo mùa thu'),
    ('SP00000030', 'DM00000030', 'Winter Dark Cocoa', 57000.00, 1, N'Chocolate đậm vị cho mùa đông');
GO
INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
    ('SP00000031', 'DM00000031', N'Signature Phin Muối', 46000.00, 1, N'Cà phê muối phong cách Huế'),
    ('SP00000032', 'DM00000032', N'Americano Đá', 40000.00, 1, N'Americano đá nhẹ vị dễ uống'),
    ('SP00000033', 'DM00000033', 'V60 Ethiopia', 65000.00, 1, N'Pour-over Ethiopia hương hoa quả'),
    ('SP00000034', 'DM00000034', N'Bạc xỉu đá', 38000.00, 1, N'Sữa nhiều cà phê ít theo kiểu Sài Gòn'),
    ('SP00000035', 'DM00000035', 'Caramel Latte Art', 56000.00, 1, N'Latte caramel chú trọng tạo hình'),
    ('SP00000036', 'DM00000036', N'Latte Ít Đường', 47000.00, 1, N'Phiên bản giảm ngọt cho khách ăn kiêng'),
    ('SP00000037', 'DM00000037', 'Granola Yogurt Cup', 52000.00, 1, N'Cốc granola sữa chua và trái cây'),
    ('SP00000038', 'DM00000038', 'Oat Milk Matcha', 56000.00, 1, N'Matcha kết hợp sữa yến mạch'),
    ('SP00000039', 'DM00000039', 'Decaf Cappuccino', 52000.00, 1, N'Cappuccino dùng hạt decaf'),
    ('SP00000040', 'DM00000040', 'Premium Geisha Handbrew', 119000.00, 1, N'Món premium số lượng giới hạn');
GO
INSERT INTO dbo.SanPham (MaSanPham, MaDanhMuc, TenSanPham, GiaCoBan, TrangThai, MoTa) VALUES
    ('SP00000041', 'DM00000041', N'Cà phê đen đá tiết kiệm', 29000.00, 1, N'Món giá tốt bán buổi sáng'),
    ('SP00000042', 'DM00000042', 'Take-away Americano', 37000.00, 1, N'Americano ưu tiên mang đi'),
    ('SP00000043', 'DM00000043', N'Bộ 4 Cold Brew giao hàng', 235000.00, 1, N'Combo cold brew cho đơn giao'),
    ('SP00000044', 'DM00000044', N'Thẻ hội viên quà tặng', 99000.00, 1, N'Sản phẩm bán tại quầy cho hội viên'),
    ('SP00000045', 'DM00000045', N'Set sự kiện 10 ly trà đào', 430000.00, 1, N'Set phục vụ workshop nhỏ'),
    ('SP00000046', 'DM00000046', N'Latte Gừng Giáng Sinh', 59000.00, 1, N'Món theo mùa lễ hội'),
    ('SP00000047', 'DM00000047', N'Tiramisu giới hạn cuối tuần', 55000.00, 1, N'Bánh tiramisu số lượng giới hạn'),
    ('SP00000048', 'DM00000048', N'Cheesecake Việt Quất', 52000.00, 1, N'Bánh lạnh bán cả ngày'),
    ('SP00000049', 'DM00000049', N'Bình giữ nhiệt logo GIBOR', 189000.00, 1, N'Phụ kiện quầy bar và quà tặng'),
    ('SP00000050', 'DM00000050', 'Gift Box Premium Coffee', 329000.00, 1, N'Hộp quà doanh nghiệp gồm hạt và voucher');
GO

INSERT INTO dbo.SanPham_ChiNhanh (MaChiNhanh, MaSanPham, GiaBan, TrangThai) VALUES
    ('CN00000001', 'SP00000001', 41000.00, 1),
    ('CN00000001', 'SP00000002', 35000.00, 1),
    ('CN00000001', 'SP00000006', 46000.00, 1),
    ('CN00000001', 'SP00000010', 51000.00, 1),
    ('CN00000001', 'SP00000031', 48000.00, 1),
    ('CN00000002', 'SP00000001', 39000.00, 1),
    ('CN00000002', 'SP00000002', 36000.00, 1),
    ('CN00000002', 'SP00000006', 47000.00, 1),
    ('CN00000002', 'SP00000010', 49000.00, 1),
    ('CN00000002', 'SP00000031', 46000.00, 1);
GO
INSERT INTO dbo.SanPham_ChiNhanh (MaChiNhanh, MaSanPham, GiaBan, TrangThai) VALUES
    ('CN00000003', 'SP00000001', 40000.00, 1),
    ('CN00000003', 'SP00000002', 37000.00, 1),
    ('CN00000003', 'SP00000006', 45000.00, 1),
    ('CN00000003', 'SP00000010', 50000.00, 1),
    ('CN00000003', 'SP00000031', 47000.00, 1),
    ('CN00000004', 'SP00000001', 41000.00, 1),
    ('CN00000004', 'SP00000002', 35000.00, 1),
    ('CN00000004', 'SP00000006', 46000.00, 1),
    ('CN00000004', 'SP00000010', 51000.00, 1),
    ('CN00000004', 'SP00000031', 48000.00, 1);
GO
INSERT INTO dbo.SanPham_ChiNhanh (MaChiNhanh, MaSanPham, GiaBan, TrangThai) VALUES
    ('CN00000005', 'SP00000001', 39000.00, 1),
    ('CN00000005', 'SP00000002', 36000.00, 1),
    ('CN00000005', 'SP00000006', 47000.00, 1),
    ('CN00000005', 'SP00000010', 49000.00, 1),
    ('CN00000005', 'SP00000031', 46000.00, 1),
    ('CN00000006', 'SP00000001', 40000.00, 1),
    ('CN00000006', 'SP00000002', 37000.00, 1),
    ('CN00000006', 'SP00000006', 45000.00, 1),
    ('CN00000006', 'SP00000010', 50000.00, 1),
    ('CN00000006', 'SP00000031', 47000.00, 1);
GO
INSERT INTO dbo.SanPham_ChiNhanh (MaChiNhanh, MaSanPham, GiaBan, TrangThai) VALUES
    ('CN00000007', 'SP00000001', 41000.00, 1),
    ('CN00000007', 'SP00000002', 35000.00, 1),
    ('CN00000007', 'SP00000006', 46000.00, 1),
    ('CN00000007', 'SP00000010', 51000.00, 1),
    ('CN00000007', 'SP00000031', 48000.00, 1),
    ('CN00000008', 'SP00000001', 39000.00, 1),
    ('CN00000008', 'SP00000002', 36000.00, 1),
    ('CN00000008', 'SP00000006', 47000.00, 1),
    ('CN00000008', 'SP00000010', 49000.00, 1),
    ('CN00000008', 'SP00000031', 46000.00, 1);
GO
INSERT INTO dbo.SanPham_ChiNhanh (MaChiNhanh, MaSanPham, GiaBan, TrangThai) VALUES
    ('CN00000009', 'SP00000001', 40000.00, 1),
    ('CN00000009', 'SP00000002', 37000.00, 1),
    ('CN00000009', 'SP00000006', 45000.00, 1),
    ('CN00000009', 'SP00000010', 50000.00, 1),
    ('CN00000009', 'SP00000031', 47000.00, 1),
    ('CN00000010', 'SP00000001', 41000.00, 1),
    ('CN00000010', 'SP00000002', 35000.00, 1),
    ('CN00000010', 'SP00000006', 46000.00, 1),
    ('CN00000010', 'SP00000010', 51000.00, 1),
    ('CN00000010', 'SP00000031', 48000.00, 1);
GO

INSERT INTO dbo.BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai) VALUES
    ('BT00000001', 'SP00000001', N'Nhỏ', 0.00, 1),
    ('BT00000002', 'SP00000001', N'Vừa', 6000.00, 1),
    ('BT00000003', 'SP00000001', N'Lớn', 12000.00, 1),
    ('BT00000004', 'SP00000002', N'Nhỏ', 0.00, 1),
    ('BT00000005', 'SP00000002', N'Vừa', 6000.00, 1),
    ('BT00000006', 'SP00000002', N'Lớn', 12000.00, 1),
    ('BT00000007', 'SP00000003', N'Nhỏ', 0.00, 1),
    ('BT00000008', 'SP00000003', N'Vừa', 6000.00, 1),
    ('BT00000009', 'SP00000003', N'Lớn', 12000.00, 1),
    ('BT00000010', 'SP00000004', N'Nhỏ', 0.00, 1);
GO
INSERT INTO dbo.BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai) VALUES
    ('BT00000011', 'SP00000004', N'Vừa', 6000.00, 1),
    ('BT00000012', 'SP00000004', N'Lớn', 12000.00, 1),
    ('BT00000013', 'SP00000005', N'Nhỏ', 0.00, 1),
    ('BT00000014', 'SP00000005', N'Vừa', 6000.00, 1),
    ('BT00000015', 'SP00000005', N'Lớn', 12000.00, 1),
    ('BT00000016', 'SP00000006', N'Nhỏ', 0.00, 1),
    ('BT00000017', 'SP00000006', N'Vừa', 6000.00, 1),
    ('BT00000018', 'SP00000006', N'Lớn', 12000.00, 1),
    ('BT00000019', 'SP00000007', N'Nhỏ', 0.00, 1),
    ('BT00000020', 'SP00000007', N'Vừa', 6000.00, 1);
GO
INSERT INTO dbo.BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai) VALUES
    ('BT00000021', 'SP00000007', N'Lớn', 12000.00, 1),
    ('BT00000022', 'SP00000008', N'Nhỏ', 0.00, 1),
    ('BT00000023', 'SP00000008', N'Vừa', 6000.00, 1),
    ('BT00000024', 'SP00000008', N'Lớn', 12000.00, 1),
    ('BT00000025', 'SP00000009', N'Nhỏ', 0.00, 1),
    ('BT00000026', 'SP00000009', N'Vừa', 6000.00, 1),
    ('BT00000027', 'SP00000009', N'Lớn', 12000.00, 1),
    ('BT00000028', 'SP00000010', N'Nhỏ', 0.00, 1),
    ('BT00000029', 'SP00000010', N'Vừa', 6000.00, 1),
    ('BT00000030', 'SP00000010', N'Lớn', 12000.00, 1);
GO
INSERT INTO dbo.BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai) VALUES
    ('BT00000031', 'SP00000011', N'Nhỏ', 0.00, 1),
    ('BT00000032', 'SP00000011', N'Vừa', 6000.00, 1),
    ('BT00000033', 'SP00000011', N'Lớn', 12000.00, 1),
    ('BT00000034', 'SP00000012', N'Nhỏ', 0.00, 1),
    ('BT00000035', 'SP00000012', N'Vừa', 6000.00, 1),
    ('BT00000036', 'SP00000012', N'Lớn', 12000.00, 1),
    ('BT00000037', 'SP00000013', N'Nhỏ', 0.00, 1),
    ('BT00000038', 'SP00000013', N'Vừa', 6000.00, 1),
    ('BT00000039', 'SP00000013', N'Lớn', 12000.00, 1),
    ('BT00000040', 'SP00000014', N'Nhỏ', 0.00, 1);
GO
INSERT INTO dbo.BienTheSanPham (MaBienThe, MaSanPham, Size, GiaCongThem, TrangThai) VALUES
    ('BT00000041', 'SP00000014', N'Vừa', 6000.00, 1),
    ('BT00000042', 'SP00000014', N'Lớn', 12000.00, 1),
    ('BT00000043', 'SP00000015', N'Nhỏ', 0.00, 1),
    ('BT00000044', 'SP00000015', N'Vừa', 6000.00, 1),
    ('BT00000045', 'SP00000015', N'Lớn', 12000.00, 1),
    ('BT00000046', 'SP00000016', N'Nhỏ', 0.00, 1),
    ('BT00000047', 'SP00000016', N'Vừa', 6000.00, 1),
    ('BT00000048', 'SP00000016', N'Lớn', 12000.00, 1),
    ('BT00000049', 'SP00000017', N'Vừa', 6000.00, 1),
    ('BT00000050', 'SP00000017', N'Lớn', 12000.00, 1);
GO

INSERT INTO dbo.TuyChonThem (MaTuyChon, TenTuyChon, GiaCongThem, TrangThai) VALUES
    ('TC00000001', N'Không đá', 0.00, 1),
    ('TC00000002', N'Ít đá', 0.00, 1),
    ('TC00000003', N'Đá vừa', 0.00, 1),
    ('TC00000004', N'Nhiều đá', 0.00, 1),
    ('TC00000005', N'0% đường', 0.00, 1),
    ('TC00000006', N'30% đường', 0.00, 1),
    ('TC00000007', N'50% đường', 0.00, 1),
    ('TC00000008', N'70% đường', 0.00, 1),
    ('TC00000009', N'100% đường', 0.00, 1),
    ('TC00000010', N'Thêm shot espresso', 12000.00, 1);
GO
INSERT INTO dbo.TuyChonThem (MaTuyChon, TenTuyChon, GiaCongThem, TrangThai) VALUES
    ('TC00000011', 'Double shot espresso', 20000.00, 1),
    ('TC00000012', N'Sữa yến mạch', 10000.00, 1),
    ('TC00000013', N'Sữa hạnh nhân', 10000.00, 1),
    ('TC00000014', N'Sữa dừa', 9000.00, 1),
    ('TC00000015', N'Foam phô mai', 12000.00, 1),
    ('TC00000016', 'Kem whipping', 10000.00, 1),
    ('TC00000017', N'Sốt caramel', 8000.00, 1),
    ('TC00000018', N'Sốt chocolate', 8000.00, 1),
    ('TC00000019', 'Siro vanilla', 7000.00, 1),
    ('TC00000020', 'Siro hazelnut', 7000.00, 1);
GO
INSERT INTO dbo.TuyChonThem (MaTuyChon, TenTuyChon, GiaCongThem, TrangThai) VALUES
    ('TC00000021', N'Trân châu đen', 10000.00, 1),
    ('TC00000022', N'Trân châu trắng', 10000.00, 1),
    ('TC00000023', N'Thạch cà phê', 9000.00, 1),
    ('TC00000024', N'Thạch đào', 9000.00, 1),
    ('TC00000025', N'Nha đam', 9000.00, 1),
    ('TC00000026', N'Đào ngâm', 10000.00, 1),
    ('TC00000027', N'Vải ngâm', 10000.00, 1),
    ('TC00000028', N'Cam lát tươi', 8000.00, 1),
    ('TC00000029', N'Chanh lát tươi', 5000.00, 1),
    ('TC00000030', N'Sả cây', 5000.00, 1);
GO
INSERT INTO dbo.TuyChonThem (MaTuyChon, TenTuyChon, GiaCongThem, TrangThai) VALUES
    ('TC00000031', N'Quế bột', 4000.00, 1),
    ('TC00000032', N'Bột matcha extra', 12000.00, 1),
    ('TC00000033', N'Bột cacao extra', 10000.00, 1),
    ('TC00000034', N'Kem mặn', 12000.00, 1),
    ('TC00000035', N'Muối kem', 10000.00, 1),
    ('TC00000036', N'Ít caffeine', 5000.00, 1),
    ('TC00000037', 'Decaf', 12000.00, 1),
    ('TC00000038', N'Xay mịn', 0.00, 1),
    ('TC00000039', N'Mang đi', 0.00, 1),
    ('TC00000040', N'Dùng tại quán', 0.00, 1);
GO
INSERT INTO dbo.TuyChonThem (MaTuyChon, TenTuyChon, GiaCongThem, TrangThai) VALUES
    ('TC00000041', N'Ly giấy lớn', 3000.00, 1),
    ('TC00000042', N'Ống hút giấy', 1000.00, 1),
    ('TC00000043', N'Không ống hút', 0.00, 1),
    ('TC00000044', N'Tách nóng', 2000.00, 1),
    ('TC00000045', N'Đá riêng', 3000.00, 1),
    ('TC00000046', N'Thêm syrup gừng', 8000.00, 1),
    ('TC00000047', 'Topping granola', 12000.00, 1),
    ('TC00000048', N'Phô mai lát', 10000.00, 1),
    ('TC00000049', N'Chà bông extra', 10000.00, 1),
    ('TC00000050', N'Thêm mật ong', 8000.00, 1);
GO

INSERT INTO dbo.SanPham_TuyChon (MaSanPham, MaTuyChon) VALUES
    ('SP00000001', 'TC00000010'),
    ('SP00000001', 'TC00000011'),
    ('SP00000001', 'TC00000017'),
    ('SP00000001', 'TC00000018'),
    ('SP00000001', 'TC00000044'),
    ('SP00000002', 'TC00000017'),
    ('SP00000002', 'TC00000018'),
    ('SP00000002', 'TC00000044'),
    ('SP00000002', 'TC00000045'),
    ('SP00000002', 'TC00000050');
GO
INSERT INTO dbo.SanPham_TuyChon (MaSanPham, MaTuyChon) VALUES
    ('SP00000003', 'TC00000001'),
    ('SP00000003', 'TC00000002'),
    ('SP00000003', 'TC00000026'),
    ('SP00000003', 'TC00000028'),
    ('SP00000003', 'TC00000039'),
    ('SP00000004', 'TC00000016'),
    ('SP00000004', 'TC00000017'),
    ('SP00000004', 'TC00000018'),
    ('SP00000004', 'TC00000033'),
    ('SP00000004', 'TC00000039');
GO
INSERT INTO dbo.SanPham_TuyChon (MaSanPham, MaTuyChon) VALUES
    ('SP00000005', 'TC00000010'),
    ('SP00000005', 'TC00000011'),
    ('SP00000005', 'TC00000017'),
    ('SP00000005', 'TC00000018'),
    ('SP00000005', 'TC00000044'),
    ('SP00000006', 'TC00000001'),
    ('SP00000006', 'TC00000002'),
    ('SP00000006', 'TC00000024'),
    ('SP00000006', 'TC00000026'),
    ('SP00000006', 'TC00000030');
GO
INSERT INTO dbo.SanPham_TuyChon (MaSanPham, MaTuyChon) VALUES
    ('SP00000007', 'TC00000005'),
    ('SP00000007', 'TC00000006'),
    ('SP00000007', 'TC00000007'),
    ('SP00000007', 'TC00000021'),
    ('SP00000007', 'TC00000022'),
    ('SP00000008', 'TC00000015'),
    ('SP00000008', 'TC00000034'),
    ('SP00000008', 'TC00000017'),
    ('SP00000008', 'TC00000018'),
    ('SP00000008', 'TC00000039');
GO
INSERT INTO dbo.SanPham_TuyChon (MaSanPham, MaTuyChon) VALUES
    ('SP00000009', 'TC00000044'),
    ('SP00000009', 'TC00000050'),
    ('SP00000009', 'TC00000029'),
    ('SP00000009', 'TC00000031'),
    ('SP00000009', 'TC00000036'),
    ('SP00000010', 'TC00000012'),
    ('SP00000010', 'TC00000013'),
    ('SP00000010', 'TC00000032'),
    ('SP00000010', 'TC00000044'),
    ('SP00000010', 'TC00000039');
GO

INSERT INTO dbo.NhaCungCap (MaNCC, TenNCC, DienThoai, Email, DiaChi, TrangThai) VALUES
    ('NCC0000001', N'Huế Coffee Supply 1', '0890908075', 'contact01@supplier.vn', N'54 Trường Chinh, Huế', N'Đang hợp tác'),
    ('NCC0000002', N'Đà Nẵng Milk & Dairy 1', '0754502486', 'contact02@supplier.vn', N'196 Điện Biên Phủ, Đà Nẵng', N'Đang hợp tác'),
    ('NCC0000003', 'TP.HCM Fruit Hub 1', '0738508907', 'contact03@supplier.vn', N'145 Nguyễn Huệ, TP.HCM', N'Đang hợp tác'),
    ('NCC0000004', N'Hà Nội Bakery Source 1', '0762409658', 'contact04@supplier.vn', N'58 Trường Chinh, Hà Nội', N'Đang hợp tác'),
    ('NCC0000005', N'Đà Lạt Packaging 1', '0368608612', 'contact05@supplier.vn', N'118 Phạm Văn Đồng, Đà Lạt', N'Đang hợp tác'),
    ('NCC0000006', N'Buôn Ma Thuột Syrup House 1', '0938089166', 'contact06@supplier.vn', N'126 Điện Biên Phủ, Buôn Ma Thuột', N'Đang hợp tác'),
    ('NCC0000007', 'Nha Trang Tea Farm 1', '0712534217', 'contact07@supplier.vn', N'136 Nguyễn Văn Linh, Nha Trang', N'Đang hợp tác'),
    ('NCC0000008', N'Quy Nhơn Ice Factory 1', '0730150759', 'contact08@supplier.vn', N'197 Hai Bà Trưng, Quy Nhơn', N'Đang hợp tác'),
    ('NCC0000009', N'Cần Thơ Equipment Care 1', '0906202700', 'contact09@supplier.vn', N'55 Phan Chu Trinh, Cần Thơ', N'Đang hợp tác'),
    ('NCC0000010', N'Bình Dương Organic Farm 1', '0961124923', 'contact10@supplier.vn', N'67 Hoàng Diệu, Bình Dương', N'Đang hợp tác');
GO
INSERT INTO dbo.NhaCungCap (MaNCC, TenNCC, DienThoai, Email, DiaChi, TrangThai) VALUES
    ('NCC0000011', N'Huế Coffee Supply 2', '0396414756', 'contact11@supplier.vn', N'111 Hoàng Hoa Thám, Huế', N'Đang hợp tác'),
    ('NCC0000012', N'Đà Nẵng Milk & Dairy 2', '0853640499', 'contact12@supplier.vn', N'183 Nguyễn Thị Minh Khai, Đà Nẵng', N'Ngừng hợp tác'),
    ('NCC0000013', 'TP.HCM Fruit Hub 2', '0914305904', 'contact13@supplier.vn', '67 Phan Chu Trinh, TP.HCM', N'Đang hợp tác'),
    ('NCC0000014', N'Hà Nội Bakery Source 2', '0393403697', 'contact14@supplier.vn', N'113 Hai Bà Trưng, Hà Nội', N'Đang hợp tác'),
    ('NCC0000015', N'Đà Lạt Packaging 2', '0974813739', 'contact15@supplier.vn', N'137 Phạm Văn Đồng, Đà Lạt', N'Đang hợp tác'),
    ('NCC0000016', N'Buôn Ma Thuột Syrup House 2', '0817896471', 'contact16@supplier.vn', N'68 Trần Hưng Đạo, Buôn Ma Thuột', N'Đang hợp tác'),
    ('NCC0000017', 'Nha Trang Tea Farm 2', '0759401199', 'contact17@supplier.vn', N'123 Nguyễn Tất Thành, Nha Trang', N'Đang hợp tác'),
    ('NCC0000018', N'Quy Nhơn Ice Factory 2', '0873534128', 'contact18@supplier.vn', N'161 Nguyễn Tất Thành, Quy Nhơn', N'Đang hợp tác'),
    ('NCC0000019', N'Cần Thơ Equipment Care 2', '0860407340', 'contact19@supplier.vn', N'119 Điện Biên Phủ, Cần Thơ', N'Đang hợp tác'),
    ('NCC0000020', N'Bình Dương Organic Farm 2', '0769967676', 'contact20@supplier.vn', N'71 Hai Bà Trưng, Bình Dương', N'Đang hợp tác');
GO
INSERT INTO dbo.NhaCungCap (MaNCC, TenNCC, DienThoai, Email, DiaChi, TrangThai) VALUES
    ('NCC0000021', N'Huế Coffee Supply 3', '0759038700', 'contact21@supplier.vn', N'129 Hai Bà Trưng, Huế', N'Đang hợp tác'),
    ('NCC0000022', N'Đà Nẵng Milk & Dairy 3', '0336468984', 'contact22@supplier.vn', N'24 Tố Hữu, Đà Nẵng', N'Đang hợp tác'),
    ('NCC0000023', 'TP.HCM Fruit Hub 3', '0918572252', 'contact23@supplier.vn', N'90 Võ Văn Kiệt, TP.HCM', N'Đang hợp tác'),
    ('NCC0000024', N'Hà Nội Bakery Source 3', '0893140367', 'contact24@supplier.vn', N'43 Hai Bà Trưng, Hà Nội', N'Đang hợp tác'),
    ('NCC0000025', N'Đà Lạt Packaging 3', '0955682626', 'contact25@supplier.vn', N'44 Ngô Quyền, Đà Lạt', N'Đang hợp tác'),
    ('NCC0000026', N'Buôn Ma Thuột Syrup House 3', '0855804273', 'contact26@supplier.vn', N'109 Võ Văn Kiệt, Buôn Ma Thuột', N'Đang hợp tác'),
    ('NCC0000027', 'Nha Trang Tea Farm 3', '0852274692', 'contact27@supplier.vn', N'20 Ngô Quyền, Nha Trang', N'Ngừng hợp tác'),
    ('NCC0000028', N'Quy Nhơn Ice Factory 3', '0864019136', 'contact28@supplier.vn', N'154 Nguyễn Huệ, Quy Nhơn', N'Đang hợp tác'),
    ('NCC0000029', N'Cần Thơ Equipment Care 3', '0752343121', 'contact29@supplier.vn', N'6 Pasteur, Cần Thơ', N'Đang hợp tác'),
    ('NCC0000030', N'Bình Dương Organic Farm 3', '0365529051', 'contact30@supplier.vn', N'112 Bạch Đằng, Bình Dương', N'Đang hợp tác');
GO
INSERT INTO dbo.NhaCungCap (MaNCC, TenNCC, DienThoai, Email, DiaChi, TrangThai) VALUES
    ('NCC0000031', N'Huế Coffee Supply 4', '0865181765', 'contact31@supplier.vn', N'61 Lý Thường Kiệt, Huế', N'Đang hợp tác'),
    ('NCC0000032', N'Đà Nẵng Milk & Dairy 4', '0789774697', 'contact32@supplier.vn', N'12 Nguyễn Thị Minh Khai, Đà Nẵng', N'Đang hợp tác'),
    ('NCC0000033', 'TP.HCM Fruit Hub 4', '0362732043', 'contact33@supplier.vn', N'178 Nguyễn Thị Minh Khai, TP.HCM', N'Đang hợp tác'),
    ('NCC0000034', N'Hà Nội Bakery Source 4', '0952884503', 'contact34@supplier.vn', N'37 Nguyễn Văn Linh, Hà Nội', N'Đang hợp tác'),
    ('NCC0000035', N'Đà Lạt Packaging 4', '0911267237', 'contact35@supplier.vn', N'156 Hoàng Hoa Thám, Đà Lạt', N'Đang hợp tác'),
    ('NCC0000036', N'Buôn Ma Thuột Syrup House 4', '0361968116', 'contact36@supplier.vn', N'169 Trường Chinh, Buôn Ma Thuột', N'Đang hợp tác'),
    ('NCC0000037', 'Nha Trang Tea Farm 4', '0750882459', 'contact37@supplier.vn', N'51 Hùng Vương, Nha Trang', N'Đang hợp tác'),
    ('NCC0000038', N'Quy Nhơn Ice Factory 4', '0843868501', 'contact38@supplier.vn', N'88 Ngô Quyền, Quy Nhơn', N'Đang hợp tác'),
    ('NCC0000039', N'Cần Thơ Equipment Care 4', '0756581473', 'contact39@supplier.vn', N'91 Nguyễn Thị Minh Khai, Cần Thơ', N'Ngừng hợp tác'),
    ('NCC0000040', N'Bình Dương Organic Farm 4', '0802601580', 'contact40@supplier.vn', N'69 Lê Lợi, Bình Dương', N'Đang hợp tác');
GO
INSERT INTO dbo.NhaCungCap (MaNCC, TenNCC, DienThoai, Email, DiaChi, TrangThai) VALUES
    ('NCC0000041', N'Huế Coffee Supply 5', '0946970882', 'contact41@supplier.vn', N'196 Bạch Đằng, Huế', N'Đang hợp tác'),
    ('NCC0000042', N'Đà Nẵng Milk & Dairy 5', '0904164775', 'contact42@supplier.vn', N'62 Lê Lợi, Đà Nẵng', N'Đang hợp tác'),
    ('NCC0000043', 'TP.HCM Fruit Hub 5', '0983394260', 'contact43@supplier.vn', N'68 Ngô Quyền, TP.HCM', N'Đang hợp tác'),
    ('NCC0000044', N'Hà Nội Bakery Source 5', '0363560289', 'contact44@supplier.vn', N'44 Hai Bà Trưng, Hà Nội', N'Ngừng hợp tác'),
    ('NCC0000045', N'Đà Lạt Packaging 5', '0362415804', 'contact45@supplier.vn', N'176 Trần Hưng Đạo, Đà Lạt', N'Đang hợp tác'),
    ('NCC0000046', N'Buôn Ma Thuột Syrup House 5', '0722520277', 'contact46@supplier.vn', N'184 Lý Thường Kiệt, Buôn Ma Thuột', N'Đang hợp tác'),
    ('NCC0000047', 'Nha Trang Tea Farm 5', '0921980274', 'contact47@supplier.vn', N'160 Nguyễn Văn Linh, Nha Trang', N'Đang hợp tác'),
    ('NCC0000048', N'Quy Nhơn Ice Factory 5', '0941870192', 'contact48@supplier.vn', N'84 Trần Hưng Đạo, Quy Nhơn', N'Đang hợp tác'),
    ('NCC0000049', N'Cần Thơ Equipment Care 5', '0895967649', 'contact49@supplier.vn', N'152 Nguyễn Thị Minh Khai, Cần Thơ', N'Đang hợp tác'),
    ('NCC0000050', N'Bình Dương Organic Farm 5', '0313676961', 'contact50@supplier.vn', N'55 Lê Lợi, Bình Dương', N'Đang hợp tác');
GO

INSERT INTO dbo.NguyenLieu (MaNguyenLieu, TenNguyenLieu, DonViTinh, GiaNhap, MaNCC, CoHanSuDung, TrangThai) VALUES
    ('NL00000001', N'Hạt Arabica Cầu Đất', 'kg', 285000.00, 'NCC0000001', 1, N'Đang sử dụng'),
    ('NL00000002', N'Hạt Robusta Buôn Ma Thuột', 'kg', 210000.00, 'NCC0000002', 1, N'Đang sử dụng'),
    ('NL00000003', N'Sữa tươi không đường', N'lít', 38000.00, 'NCC0000003', 1, N'Đang sử dụng'),
    ('NL00000004', N'Sữa đặc', 'lon', 29000.00, 'NCC0000004', 1, N'Đang sử dụng'),
    ('NL00000005', 'Whipping cream', N'lít', 92000.00, 'NCC0000005', 1, N'Đang sử dụng'),
    ('NL00000006', N'Bột matcha Nhật', 'kg', 520000.00, 'NCC0000006', 1, N'Đang sử dụng'),
    ('NL00000007', N'Bột cacao đen', 'kg', 260000.00, 'NCC0000007', 1, N'Đang sử dụng'),
    ('NL00000008', 'Siro vanilla', 'chai', 145000.00, 'NCC0000008', 1, N'Đang sử dụng'),
    ('NL00000009', 'Siro caramel', 'chai', 145000.00, 'NCC0000009', 1, N'Đang sử dụng'),
    ('NL00000010', 'Siro hazelnut', 'chai', 155000.00, 'NCC0000010', 1, N'Đang sử dụng');
GO
INSERT INTO dbo.NguyenLieu (MaNguyenLieu, TenNguyenLieu, DonViTinh, GiaNhap, MaNCC, CoHanSuDung, TrangThai) VALUES
    ('NL00000011', N'Trà ô long', 'kg', 310000.00, 'NCC0000011', 1, N'Đang sử dụng'),
    ('NL00000012', N'Trà Assam', 'kg', 260000.00, 'NCC0000012', 1, N'Đang sử dụng'),
    ('NL00000013', N'Hồng trà', 'kg', 230000.00, 'NCC0000013', 1, N'Đang sử dụng'),
    ('NL00000014', N'Mật ong', 'chai', 165000.00, 'NCC0000014', 1, N'Đang sử dụng'),
    ('NL00000015', N'Cam vàng', 'kg', 58000.00, 'NCC0000015', 1, N'Đang sử dụng'),
    ('NL00000016', N'Đào ngâm', N'hộp', 96000.00, 'NCC0000016', 1, N'Đang sử dụng'),
    ('NL00000017', N'Vải ngâm', N'hộp', 99000.00, 'NCC0000017', 1, N'Đang sử dụng'),
    ('NL00000018', N'Sả cây', 'kg', 32000.00, 'NCC0000018', 1, N'Đang sử dụng'),
    ('NL00000019', N'Chanh vàng', 'kg', 67000.00, 'NCC0000019', 1, N'Đang sử dụng'),
    ('NL00000020', N'Dâu tây đông lạnh', 'kg', 118000.00, 'NCC0000020', 1, N'Đang sử dụng');
GO
INSERT INTO dbo.NguyenLieu (MaNguyenLieu, TenNguyenLieu, DonViTinh, GiaNhap, MaNCC, CoHanSuDung, TrangThai) VALUES
    ('NL00000021', 'Kiwi xanh', 'kg', 86000.00, 'NCC0000021', 1, N'Đang sử dụng'),
    ('NL00000022', N'Việt quất đông lạnh', 'kg', 194000.00, 'NCC0000022', 1, N'Đang sử dụng'),
    ('NL00000023', N'Sữa chua không đường', N'hộp', 18000.00, 'NCC0000023', 1, N'Đang sử dụng'),
    ('NL00000024', 'Granola', 'kg', 175000.00, 'NCC0000024', 1, N'Đang sử dụng'),
    ('NL00000025', N'Bánh quy Oreo', N'gói', 42000.00, 'NCC0000025', 1, N'Đang sử dụng'),
    ('NL00000026', N'Bột frappe', 'kg', 150000.00, 'NCC0000026', 1, N'Đang sử dụng'),
    ('NL00000027', N'Trân châu đen', 'kg', 125000.00, 'NCC0000027', 1, N'Đang sử dụng'),
    ('NL00000028', N'Trân châu trắng', 'kg', 132000.00, 'NCC0000028', 1, N'Đang sử dụng'),
    ('NL00000029', N'Thạch cà phê', 'kg', 118000.00, 'NCC0000029', 1, N'Đang sử dụng'),
    ('NL00000030', N'Nha đam sơ chế', 'kg', 92000.00, 'NCC0000030', 1, N'Đang sử dụng');
GO
INSERT INTO dbo.NguyenLieu (MaNguyenLieu, TenNguyenLieu, DonViTinh, GiaNhap, MaNCC, CoHanSuDung, TrangThai) VALUES
    ('NL00000031', N'Phô mai kem', 'kg', 210000.00, 'NCC0000031', 1, N'Đang sử dụng'),
    ('NL00000032', N'Muối biển mịn', 'kg', 24000.00, 'NCC0000032', 1, N'Đang sử dụng'),
    ('NL00000033', N'Bơ lạt', 'kg', 185000.00, 'NCC0000033', 1, N'Đang sử dụng'),
    ('NL00000034', N'Bột mì số 11', 'kg', 22500.00, 'NCC0000034', 1, N'Đang sử dụng'),
    ('NL00000035', N'Men nở', N'gói', 28000.00, 'NCC0000035', 1, N'Ngưng sử dụng'),
    ('NL00000036', N'Trứng gà', N'vỉ', 38000.00, 'NCC0000036', 1, N'Đang sử dụng'),
    ('NL00000037', N'Chà bông gà', 'kg', 210000.00, 'NCC0000037', 1, N'Đang sử dụng'),
    ('NL00000038', N'Phô mai lát', N'gói', 86000.00, 'NCC0000038', 1, N'Đang sử dụng'),
    ('NL00000039', N'Ức gà sơ chế', 'kg', 132000.00, 'NCC0000039', 1, N'Đang sử dụng'),
    ('NL00000040', N'Xà lách romaine', 'kg', 76000.00, 'NCC0000040', 1, N'Đang sử dụng');
GO
INSERT INTO dbo.NguyenLieu (MaNguyenLieu, TenNguyenLieu, DonViTinh, GiaNhap, MaNCC, CoHanSuDung, TrangThai) VALUES
    ('NL00000041', N'Cà rốt', 'kg', 24000.00, 'NCC0000041', 1, N'Đang sử dụng'),
    ('NL00000042', N'Nước soda', N'thùng', 168000.00, 'NCC0000042', 1, N'Đang sử dụng'),
    ('NL00000043', N'Ly giấy 500ml', N'cây', 92000.00, 'NCC0000043', 0, N'Đang sử dụng'),
    ('NL00000044', N'Nắp ly 500ml', N'cây', 54000.00, 'NCC0000044', 0, N'Đang sử dụng'),
    ('NL00000045', N'Ống hút giấy', N'hộp', 46000.00, 'NCC0000045', 1, N'Đang sử dụng'),
    ('NL00000046', N'Túi giao hàng', N'xấp', 68000.00, 'NCC0000046', 1, N'Đang sử dụng'),
    ('NL00000047', N'Tem nhãn thương hiệu', N'cuộn', 35000.00, 'NCC0000047', 0, N'Ngưng sử dụng'),
    ('NL00000048', N'Hộp quà carton', N'thùng', 128000.00, 'NCC0000048', 1, N'Đang sử dụng'),
    ('NL00000049', N'Bình cold brew 500ml', N'thùng', 245000.00, 'NCC0000049', 1, N'Đang sử dụng'),
    ('NL00000050', 'Decaf blend', 'kg', 315000.00, 'NCC0000050', 1, N'Đang sử dụng');
GO

INSERT INTO dbo.TonKhoNguyenLieu (MaChiNhanh, MaNguyenLieu, SoLuongTon, MucCanhBao) VALUES
    ('CN00000001', 'NL00000001', 131.55, 19.73),
    ('CN00000001', 'NL00000002', 68.25, 10.24),
    ('CN00000001', 'NL00000003', 129.48, 19.42),
    ('CN00000001', 'NL00000011', 148.88, 22.33),
    ('CN00000001', 'NL00000043', 147.40, 22.11),
    ('CN00000002', 'NL00000001', 110.55, 16.58),
    ('CN00000002', 'NL00000002', 26.57, 5),
    ('CN00000002', 'NL00000003', 105.24, 15.79),
    ('CN00000002', 'NL00000011', 125.84, 18.88),
    ('CN00000002', 'NL00000043', 31.03, 5);
GO
INSERT INTO dbo.TonKhoNguyenLieu (MaChiNhanh, MaNguyenLieu, SoLuongTon, MucCanhBao) VALUES
    ('CN00000003', 'NL00000001', 123.61, 18.54),
    ('CN00000003', 'NL00000002', 22.02, 5),
    ('CN00000003', 'NL00000003', 87.21, 13.08),
    ('CN00000003', 'NL00000011', 98.43, 14.76),
    ('CN00000003', 'NL00000043', 89.36, 13.40),
    ('CN00000004', 'NL00000001', 77.95, 11.69),
    ('CN00000004', 'NL00000002', 162.65, 24.40),
    ('CN00000004', 'NL00000003', 93.56, 14.03),
    ('CN00000004', 'NL00000011', 44.48, 6.67),
    ('CN00000004', 'NL00000043', 48.18, 7.23);
GO
INSERT INTO dbo.TonKhoNguyenLieu (MaChiNhanh, MaNguyenLieu, SoLuongTon, MucCanhBao) VALUES
    ('CN00000005', 'NL00000001', 103.48, 15.52),
    ('CN00000005', 'NL00000002', 124.07, 18.61),
    ('CN00000005', 'NL00000003', 118.55, 17.78),
    ('CN00000005', 'NL00000011', 167.14, 25.07),
    ('CN00000005', 'NL00000043', 143.94, 21.59),
    ('CN00000006', 'NL00000001', 94.38, 14.16),
    ('CN00000006', 'NL00000002', 152.12, 22.82),
    ('CN00000006', 'NL00000003', 114.80, 17.22),
    ('CN00000006', 'NL00000011', 71.57, 10.74),
    ('CN00000006', 'NL00000043', 59.28, 8.89);
GO
INSERT INTO dbo.TonKhoNguyenLieu (MaChiNhanh, MaNguyenLieu, SoLuongTon, MucCanhBao) VALUES
    ('CN00000007', 'NL00000001', 169.54, 25.43),
    ('CN00000007', 'NL00000002', 64.63, 9.69),
    ('CN00000007', 'NL00000003', 92.13, 13.82),
    ('CN00000007', 'NL00000011', 140.08, 21.01),
    ('CN00000007', 'NL00000043', 111.18, 16.68),
    ('CN00000008', 'NL00000001', 126.91, 19.04),
    ('CN00000008', 'NL00000002', 73.82, 11.07),
    ('CN00000008', 'NL00000003', 99.09, 14.86),
    ('CN00000008', 'NL00000011', 72.00, 10.80),
    ('CN00000008', 'NL00000043', 98.01, 14.70);
GO
INSERT INTO dbo.TonKhoNguyenLieu (MaChiNhanh, MaNguyenLieu, SoLuongTon, MucCanhBao) VALUES
    ('CN00000009', 'NL00000001', 76.77, 11.52),
    ('CN00000009', 'NL00000002', 61.34, 9.20),
    ('CN00000009', 'NL00000003', 64.75, 9.71),
    ('CN00000009', 'NL00000011', 115.38, 17.31),
    ('CN00000009', 'NL00000043', 160.82, 24.12),
    ('CN00000010', 'NL00000001', 108.93, 16.34),
    ('CN00000010', 'NL00000002', 102.66, 15.40),
    ('CN00000010', 'NL00000003', 50.57, 7.59),
    ('CN00000010', 'NL00000011', 58.62, 8.79),
    ('CN00000010', 'NL00000043', 85.03, 12.75);
GO

INSERT INTO dbo.CongThucPhaChe (MaCongThuc, MaBienThe, MaNguyenLieu, SoLuongSuDung) VALUES
    ('CT00000001', 'BT00000001', 'NL00000001', 0.01),
    ('CT00000001', 'BT00000001', 'NL00000002', 0.01),
    ('CT00000001', 'BT00000001', 'NL00000043', 1.00),
    ('CT00000001', 'BT00000001', 'NL00000044', 1.00),
    ('CT00000001', 'BT00000001', 'NL00000047', 1.00),
    ('CT00000002', 'BT00000002', 'NL00000002', 0.02),
    ('CT00000002', 'BT00000002', 'NL00000004', 0.04),
    ('CT00000002', 'BT00000002', 'NL00000043', 1.00),
    ('CT00000002', 'BT00000002', 'NL00000044', 1.00),
    ('CT00000002', 'BT00000002', 'NL00000047', 1.00);
GO
INSERT INTO dbo.CongThucPhaChe (MaCongThuc, MaBienThe, MaNguyenLieu, SoLuongSuDung) VALUES
    ('CT00000003', 'BT00000003', 'NL00000001', 0.02),
    ('CT00000003', 'BT00000003', 'NL00000015', 0.08),
    ('CT00000003', 'BT00000003', 'NL00000019', 0.01),
    ('CT00000003', 'BT00000003', 'NL00000043', 1.00),
    ('CT00000003', 'BT00000003', 'NL00000044', 1.00),
    ('CT00000004', 'BT00000004', 'NL00000001', 0.02),
    ('CT00000004', 'BT00000004', 'NL00000007', 0.02),
    ('CT00000004', 'BT00000004', 'NL00000009', 0.01),
    ('CT00000004', 'BT00000004', 'NL00000026', 0.02),
    ('CT00000004', 'BT00000004', 'NL00000043', 1.00);
GO
INSERT INTO dbo.CongThucPhaChe (MaCongThuc, MaBienThe, MaNguyenLieu, SoLuongSuDung) VALUES
    ('CT00000005', 'BT00000005', 'NL00000001', 0.02),
    ('CT00000005', 'BT00000005', 'NL00000043', 1.00),
    ('CT00000005', 'BT00000005', 'NL00000044', 1.00),
    ('CT00000005', 'BT00000005', 'NL00000045', 1.00),
    ('CT00000005', 'BT00000005', 'NL00000047', 1.00),
    ('CT00000006', 'BT00000006', 'NL00000013', 0.01),
    ('CT00000006', 'BT00000006', 'NL00000016', 0.05),
    ('CT00000006', 'BT00000006', 'NL00000015', 0.03),
    ('CT00000006', 'BT00000006', 'NL00000018', 0.01),
    ('CT00000006', 'BT00000006', 'NL00000043', 1.00);
GO
INSERT INTO dbo.CongThucPhaChe (MaCongThuc, MaBienThe, MaNguyenLieu, SoLuongSuDung) VALUES
    ('CT00000007', 'BT00000007', 'NL00000012', 0.01),
    ('CT00000007', 'BT00000007', 'NL00000003', 0.18),
    ('CT00000007', 'BT00000007', 'NL00000027', 0.04),
    ('CT00000007', 'BT00000007', 'NL00000043', 1.00),
    ('CT00000007', 'BT00000007', 'NL00000044', 1.00),
    ('CT00000008', 'BT00000008', 'NL00000011', 0.01),
    ('CT00000008', 'BT00000008', 'NL00000005', 0.04),
    ('CT00000008', 'BT00000008', 'NL00000031', 0.01),
    ('CT00000008', 'BT00000008', 'NL00000043', 1.00),
    ('CT00000008', 'BT00000008', 'NL00000044', 1.00);
GO
INSERT INTO dbo.CongThucPhaChe (MaCongThuc, MaBienThe, MaNguyenLieu, SoLuongSuDung) VALUES
    ('CT00000009', 'BT00000009', 'NL00000013', 0.01),
    ('CT00000009', 'BT00000009', 'NL00000014', 0.02),
    ('CT00000009', 'BT00000009', 'NL00000019', 0.01),
    ('CT00000009', 'BT00000009', 'NL00000043', 1.00),
    ('CT00000009', 'BT00000009', 'NL00000044', 1.00),
    ('CT00000010', 'BT00000010', 'NL00000006', 0.01),
    ('CT00000010', 'BT00000010', 'NL00000003', 0.20),
    ('CT00000010', 'BT00000010', 'NL00000008', 0.01),
    ('CT00000010', 'BT00000010', 'NL00000043', 1.00),
    ('CT00000010', 'BT00000010', 'NL00000044', 1.00);
GO

INSERT INTO dbo.LichSuKho (LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong, ThoiGian, GhiChu) VALUES
    ('LK00000001', 'CN00000001', 'NL00000001', N'Nhập', 8.89, '2026-03-04T07:09:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000002', 'CN00000001', 'NL00000002', N'Xuất', 2.67, '2026-03-07T08:18:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000003', 'CN00000001', 'NL00000003', N'Hao hụt', 9.46, '2026-03-10T09:27:00', N'Điều chỉnh hao hụt do bảo quản'),
    ('LK00000004', 'CN00000001', 'NL00000011', N'Nhập', 3.29, '2026-03-13T10:36:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000005', 'CN00000001', 'NL00000043', N'Xuất', 10.24, '2026-03-16T11:45:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000006', 'CN00000002', 'NL00000001', N'Nhập', 11.91, '2026-03-19T12:54:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000007', 'CN00000002', 'NL00000002', N'Xuất', 7.62, '2026-03-22T13:03:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000008', 'CN00000002', 'NL00000003', N'Nhập', 11.48, '2026-03-25T14:12:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000009', 'CN00000002', 'NL00000011', N'Hết hạn', 17.68, '2026-03-01T15:21:00', N'Thu hồi lô nguyên liệu quá hạn'),
    ('LK00000010', 'CN00000002', 'NL00000043', N'Xuất', 6.14, '2026-03-04T16:30:00', N'Xuất dùng cho quầy pha chế trong ngày');
GO
INSERT INTO dbo.LichSuKho (LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong, ThoiGian, GhiChu) VALUES
    ('LK00000011', 'CN00000003', 'NL00000001', N'Nhập', 6.03, '2026-03-07T17:39:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000012', 'CN00000003', 'NL00000002', N'Xuất', 16.02, '2026-03-10T06:48:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000013', 'CN00000003', 'NL00000003', N'Hao hụt', 10.80, '2026-03-13T07:57:00', N'Điều chỉnh hao hụt do bảo quản'),
    ('LK00000014', 'CN00000003', 'NL00000011', N'Nhập', 17.71, '2026-03-16T08:06:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000015', 'CN00000003', 'NL00000043', N'Xuất', 13.45, '2026-03-19T09:15:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000016', 'CN00000004', 'NL00000001', N'Nhập', 15.41, '2026-03-22T10:24:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000017', 'CN00000004', 'NL00000002', N'Xuất', 7.34, '2026-03-25T11:33:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000018', 'CN00000004', 'NL00000003', N'Nhập', 16.67, '2026-03-01T12:42:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000019', 'CN00000004', 'NL00000011', N'Hết hạn', 12.57, '2026-03-04T13:51:00', N'Thu hồi lô nguyên liệu quá hạn'),
    ('LK00000020', 'CN00000004', 'NL00000043', N'Xuất', 17.34, '2026-03-07T14:00:00', N'Xuất dùng cho quầy pha chế trong ngày');
GO
INSERT INTO dbo.LichSuKho (LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong, ThoiGian, GhiChu) VALUES
    ('LK00000021', 'CN00000005', 'NL00000001', N'Nhập', 22.67, '2026-03-10T15:09:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000022', 'CN00000005', 'NL00000002', N'Xuất', 12.70, '2026-03-13T16:18:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000023', 'CN00000005', 'NL00000003', N'Hao hụt', 8.62, '2026-03-16T17:27:00', N'Điều chỉnh hao hụt do bảo quản'),
    ('LK00000024', 'CN00000005', 'NL00000011', N'Nhập', 14.57, '2026-03-19T06:36:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000025', 'CN00000005', 'NL00000043', N'Xuất', 3.70, '2026-03-22T07:45:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000026', 'CN00000006', 'NL00000001', N'Nhập', 23.74, '2026-04-25T08:54:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000027', 'CN00000006', 'NL00000002', N'Xuất', 24.72, '2026-04-01T09:03:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000028', 'CN00000006', 'NL00000003', N'Nhập', 8.88, '2026-04-04T10:12:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000029', 'CN00000006', 'NL00000011', N'Hết hạn', 24.13, '2026-04-07T11:21:00', N'Thu hồi lô nguyên liệu quá hạn'),
    ('LK00000030', 'CN00000006', 'NL00000043', N'Xuất', 17.88, '2026-04-10T12:30:00', N'Xuất dùng cho quầy pha chế trong ngày');
GO
INSERT INTO dbo.LichSuKho (LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong, ThoiGian, GhiChu) VALUES
    ('LK00000031', 'CN00000007', 'NL00000001', N'Nhập', 12.51, '2026-04-13T13:39:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000032', 'CN00000007', 'NL00000002', N'Xuất', 8.95, '2026-04-16T14:48:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000033', 'CN00000007', 'NL00000003', N'Hao hụt', 24.99, '2026-04-19T15:57:00', N'Điều chỉnh hao hụt do bảo quản'),
    ('LK00000034', 'CN00000007', 'NL00000011', N'Nhập', 21.63, '2026-04-22T16:06:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000035', 'CN00000007', 'NL00000043', N'Xuất', 4.45, '2026-04-25T17:15:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000036', 'CN00000008', 'NL00000001', N'Nhập', 10.77, '2026-04-01T06:24:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000037', 'CN00000008', 'NL00000002', N'Xuất', 10.26, '2026-04-04T07:33:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000038', 'CN00000008', 'NL00000003', N'Nhập', 8.81, '2026-04-07T08:42:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000039', 'CN00000008', 'NL00000011', N'Hết hạn', 18.08, '2026-04-10T09:51:00', N'Thu hồi lô nguyên liệu quá hạn'),
    ('LK00000040', 'CN00000008', 'NL00000043', N'Xuất', 2.50, '2026-04-13T10:00:00', N'Xuất dùng cho quầy pha chế trong ngày');
GO
INSERT INTO dbo.LichSuKho (LogID, MaChiNhanh, MaNguyenLieu, LoaiGiaoDich, SoLuong, ThoiGian, GhiChu) VALUES
    ('LK00000041', 'CN00000009', 'NL00000001', N'Nhập', 21.09, '2026-04-16T11:09:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000042', 'CN00000009', 'NL00000002', N'Xuất', 11.10, '2026-04-19T12:18:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000043', 'CN00000009', 'NL00000003', N'Hao hụt', 2.19, '2026-04-22T13:27:00', N'Điều chỉnh hao hụt do bảo quản'),
    ('LK00000044', 'CN00000009', 'NL00000011', N'Nhập', 21.90, '2026-04-25T14:36:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000045', 'CN00000009', 'NL00000043', N'Xuất', 19.90, '2026-04-01T15:45:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000046', 'CN00000010', 'NL00000001', N'Nhập', 24.39, '2026-04-04T16:54:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000047', 'CN00000010', 'NL00000002', N'Xuất', 22.94, '2026-04-07T17:03:00', N'Xuất dùng cho quầy pha chế trong ngày'),
    ('LK00000048', 'CN00000010', 'NL00000003', N'Nhập', 19.14, '2026-04-10T06:12:00', N'Nhập hàng theo phiếu NCC định kỳ'),
    ('LK00000049', 'CN00000010', 'NL00000011', N'Hết hạn', 21.16, '2026-04-13T07:21:00', N'Thu hồi lô nguyên liệu quá hạn'),
    ('LK00000050', 'CN00000010', 'NL00000043', N'Xuất', 22.77, '2026-04-16T08:30:00', N'Xuất dùng cho quầy pha chế trong ngày');
GO

INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0001', N'Đặng Quốc Phong', '0973089925', 120),
    ('KH0002', N'Đỗ Khánh Nhi', '0335652586', 50),
    ('KH0003', N'Ngô Văn Bình', '0908004482', 50),
    ('KH0004', N'Hoàng Thu My', '0779865458', 820),
    ('KH0005', N'Hồ Quốc Khánh', '0758942178', 20),
    ('KH0006', N'Đỗ Quỳnh Mai', '0892432795', 180),
    ('KH0007', N'Võ Công Quân', '0836540265', 600),
    ('KH0008', N'Huỳnh Mai Quỳnh', '0858755000', 20),
    ('KH0009', N'Huỳnh Gia Nam', '0957985905', 250),
    ('KH0010', N'Hoàng Diễm Hương', '0703471527', 20);
GO
INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0011', N'Phạm Hữu Đức', '0390502794', 820),
    ('KH0012', N'Huỳnh Ngọc Quỳnh', '0990232106', 180),
    ('KH0013', N'Ngô Minh Đức', '0923513701', 450),
    ('KH0014', N'Phạm Khánh Hương', '0837333543', 50),
    ('KH0015', N'Hồ Xuân Quân', '0885199362', 450),
    ('KH0016', N'Bùi Diễm Diễm', '0963083727', 250),
    ('KH0017', N'Dương Quốc Khánh', '0844735895', 250),
    ('KH0018', N'Phạm Bảo Hà', '0921585546', 250),
    ('KH0019', N'Hoàng Văn Sơn', '0893103304', 450),
    ('KH0020', N'Lê Diễm Anh', '0788930456', 320);
GO
INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0021', N'Nguyễn Công Khánh', '0961045700', 20),
    ('KH0022', N'Hồ Thanh Trâm', '0733876400', 250),
    ('KH0023', N'Dương Anh Cường', '0954247457', 600),
    ('KH0024', N'Dương Thị Thảo', '0988269682', 600),
    ('KH0025', N'Hoàng Anh Phong', '0855465150', 0),
    ('KH0026', N'Võ Bảo Hà', '0369583757', 250),
    ('KH0027', N'Nguyễn Đức Phong', '0883940940', 450),
    ('KH0028', N'Trần Ngọc My', '0927321124', 180),
    ('KH0029', N'Võ Hữu Thành', '0338658617', 450),
    ('KH0030', N'Đỗ Thị Giang', '0816297533', 0);
GO
INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0031', N'Lê Xuân Khánh', '0395265438', 50),
    ('KH0032', N'Trần Thu Diễm', '0773932360', 0),
    ('KH0033', N'Đặng Thanh Trung', '0812510327', 120),
    ('KH0034', N'Bùi Quỳnh Hiền', '0961934487', 20),
    ('KH0035', N'Ngô Công Long', '0366890827', 180),
    ('KH0036', N'Võ Khánh Lan', '0755766169', 450),
    ('KH0037', N'Dương Xuân Minh', '0832713008', 450),
    ('KH0038', N'Hoàng Quỳnh Trang', '0351484043', 120),
    ('KH0039', N'Nguyễn Xuân Cường', '0309369750', 180),
    ('KH0040', N'Ngô Thu Trâm', '0845617282', 600);
GO
INSERT INTO dbo.KhachHang (MaKH, TenKH, SoDienThoai, DiemTichLuy) VALUES
    ('KH0041', N'Phạm Đức Vinh', '0700344303', 180),
    ('KH0042', N'Trần Thanh Hiền', '0778777447', 820),
    ('KH0043', N'Lê Công Bình', '0819944139', 450),
    ('KH0044', N'Lê Thị Ngân', '0846321751', 250),
    ('KH0045', N'Võ Xuân Phong', '0861115319', 250),
    ('KH0046', N'Hoàng Thị Hiền', '0393616654', 120),
    ('KH0047', N'Hoàng Đức Nam', '0831348220', 320),
    ('KH0048', N'Trần Thu Hương', '0942704903', 450),
    ('KH0049', N'Ngô Xuân Vinh', '0851818612', 50),
    ('KH0050', N'Ngô Thu Ngân', '0804968688', 50);
GO

-- Tạm thời disable trigger để INSERT dữ liệu test
DISABLE TRIGGER dbo.TRG_DonHang_CapNhatDiem ON dbo.DonHang;
GO

INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0001', 'CN00000001', 'NV00000001', 'KH0001', 78000.00, 0.00, N'Tiền mặt', N'Hoàn tất', '2026-03-03T08:07:00'),
    ('DH0002', 'CN00000002', 'NV00000002', 'KH0002', 135000.00, 0.00, N'Thẻ', N'Hoàn tất', '2026-03-05T09:14:00'),
    ('DH0003', 'CN00000003', 'NV00000003', 'KH0003', 204000.00, 0.00, N'Chuyển khoản', N'Hoàn tất', '2026-03-07T10:21:00'),
    ('DH0004', 'CN00000004', 'NV00000004', 'KH0004', 35000.00, 0.00, 'QR', N'Hoàn tất', '2026-03-09T11:28:00'),
    ('DH0005', 'CN00000005', 'NV00000005', 'KH0005', 82000.00, 10000.00, N'Ví điện tử', N'Hoàn tất', '2026-03-11T12:35:00'),
    ('DH0006', 'CN00000006', 'NV00000006', NULL, 141000.00, 0.00, N'Tiền mặt', N'Hoàn tất', '2026-03-13T13:42:00'),
    ('DH0007', 'CN00000007', 'NV00000007', 'KH0007', 196000.00, 15000.00, N'Thẻ', N'Hoàn tất', '2026-03-15T14:49:00'),
    ('DH0008', 'CN00000008', 'NV00000008', 'KH0008', 55000.00, 0.00, N'Chuyển khoản', N'Hoàn tất', '2026-03-17T15:56:00'),
    ('DH0009', 'CN00000009', 'NV00000009', 'KH0009', 122000.00, 0.00, 'QR', N'Hủy', '2026-03-19T16:03:00'),
    ('DH0010', 'CN00000010', 'NV00000010', 'KH0010', 165000.00, 20000.00, N'Ví điện tử', N'Hoàn tất', '2026-03-21T17:10:00');
GO
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0011', 'CN00000011', 'NV00000011', 'KH0011', 244000.00, 0.00, N'Tiền mặt', N'Hoàn tất', '2026-03-23T18:17:00'),
    ('DH0012', 'CN00000012', 'NV00000012', NULL, 67000.00, 0.00, N'Thẻ', N'Hoàn tất', '2026-03-25T19:24:00'),
    ('DH0013', 'CN00000013', 'NV00000013', 'KH0013', 118000.00, 0.00, N'Chuyển khoản', N'Hoàn tất', '2026-03-27T07:31:00'),
    ('DH0014', 'CN00000014', 'NV00000014', 'KH0014', 195000.00, 15000.00, 'QR', N'Hoàn tất', '2026-03-02T08:38:00'),
    ('DH0015', 'CN00000015', 'NV00000015', 'KH0015', 284000.00, 20000.00, N'Ví điện tử', N'Hoàn tất', '2026-03-04T09:45:00'),
    ('DH0016', 'CN00000016', 'NV00000016', 'KH0016', 45000.00, 0.00, N'Tiền mặt', N'Hoàn tất', '2026-03-06T10:52:00'),
    ('DH0017', 'CN00000017', 'NV00000017', 'KH0017', 102000.00, 0.00, N'Thẻ', N'Hoàn tất', '2026-03-08T11:59:00'),
    ('DH0018', 'CN00000018', 'NV00000018', NULL, 171000.00, 0.00, N'Chuyển khoản', N'Hủy', '2026-03-10T12:06:00'),
    ('DH0019', 'CN00000019', 'NV00000019', 'KH0019', 196000.00, 0.00, 'QR', N'Hoàn tất', '2026-03-12T13:13:00'),
    ('DH0020', 'CN00000020', 'NV00000020', 'KH0020', 55000.00, 10000.00, N'Ví điện tử', N'Hoàn tất', '2026-03-14T14:20:00');
GO
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0021', 'CN00000021', 'NV00000021', 'KH0021', 122000.00, 15000.00, N'Tiền mặt', N'Hoàn tất', '2026-03-16T15:27:00'),
    ('DH0022', 'CN00000022', 'NV00000022', 'KH0022', 141000.00, 0.00, N'Thẻ', N'Hoàn tất', '2026-03-18T16:34:00'),
    ('DH0023', 'CN00000023', 'NV00000023', 'KH0023', 212000.00, 0.00, N'Chuyển khoản', N'Hoàn tất', '2026-03-20T17:41:00'),
    ('DH0024', 'CN00000024', 'NV00000024', NULL, 59000.00, 0.00, 'QR', N'Hoàn tất', '2026-03-22T18:48:00'),
    ('DH0025', 'CN00000025', 'NV00000025', 'KH0025', 78000.00, 10000.00, N'Ví điện tử', N'Hoàn tất', '2026-03-24T19:55:00'),
    ('DH0026', 'CN00000026', 'NV00000026', 'KH0026', 135000.00, 0.00, N'Tiền mặt', N'Hoàn tất', '2026-04-26T07:02:00'),
    ('DH0027', 'CN00000027', 'NV00000027', 'KH0027', 204000.00, 0.00, N'Thẻ', N'Hủy', '2026-04-01T08:09:00'),
    ('DH0028', 'CN00000028', 'NV00000028', 'KH0028', 49000.00, 15000.00, N'Chuyển khoản', N'Hoàn tất', '2026-04-03T09:16:00'),
    ('DH0029', 'CN00000029', 'NV00000029', 'KH0029', 110000.00, 0.00, 'QR', N'Hoàn tất', '2026-04-05T10:23:00'),
    ('DH0030', 'CN00000030', 'NV00000030', NULL, 183000.00, 0.00, N'Ví điện tử', N'Hoàn tất', '2026-04-07T11:30:00');
GO
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0031', 'CN00000031', 'NV00000031', 'KH0031', 180000.00, 0.00, N'Tiền mặt', N'Hoàn tất', '2026-04-09T12:37:00'),
    ('DH0032', 'CN00000032', 'NV00000032', 'KH0032', 51000.00, 0.00, N'Thẻ', N'Hoàn tất', '2026-04-11T13:44:00'),
    ('DH0033', 'CN00000033', 'NV00000033', 'KH0033', 114000.00, 0.00, N'Chuyển khoản', N'Hoàn tất', '2026-04-13T14:51:00'),
    ('DH0034', 'CN00000034', 'NV00000034', 'KH0034', 141000.00, 0.00, 'QR', N'Hoàn tất', '2026-04-15T15:58:00'),
    ('DH0035', 'CN00000035', 'NV00000035', 'KH0035', 212000.00, 20000.00, N'Ví điện tử', N'Hoàn tất', '2026-04-17T16:05:00'),
    ('DH0036', 'CN00000036', 'NV00000036', NULL, 59000.00, 0.00, N'Tiền mặt', N'Hủy', '2026-04-19T17:12:00'),
    ('DH0037', 'CN00000037', 'NV00000037', 'KH0037', 86000.00, 0.00, N'Thẻ', N'Hoàn tất', '2026-04-21T18:19:00'),
    ('DH0038', 'CN00000038', 'NV00000038', 'KH0038', 147000.00, 0.00, N'Chuyển khoản', N'Hoàn tất', '2026-04-23T19:26:00'),
    ('DH0039', 'CN00000039', 'NV00000039', 'KH0039', 220000.00, 0.00, 'QR', N'Hoàn tất', '2026-04-25T07:33:00'),
    ('DH0040', 'CN00000040', 'NV00000040', 'KH0040', 44000.00, 10000.00, N'Ví điện tử', N'Hoàn tất', '2026-04-27T08:40:00');
GO
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0041', 'CN00000001', 'NV00000001', 'KH0041', 100000.00, 0.00, N'Tiền mặt', N'Hoàn tất', '2026-04-02T09:47:00'),
    ('DH0042', 'CN00000002', 'NV00000002', NULL, 168000.00, 0.00, N'Thẻ', N'Hoàn tất', '2026-04-04T10:54:00'),
    ('DH0043', 'CN00000003', 'NV00000003', 'KH0043', 208000.00, 0.00, N'Chuyển khoản', N'Hoàn tất', '2026-04-06T11:01:00'),
    ('DH0044', 'CN00000004', 'NV00000004', 'KH0044', 58000.00, 0.00, 'QR', N'Hoàn tất', '2026-04-08T12:08:00'),
    ('DH0045', 'CN00000005', 'NV00000005', 'KH0045', 128000.00, 20000.00, N'Ví điện tử', N'Hủy', '2026-04-10T13:15:00'),
    ('DH0046', 'CN00000006', 'NV00000006', 'KH0046', 96000.00, 0.00, N'Tiền mặt', N'Hoàn tất', '2026-04-12T14:22:00'),
    ('DH0047', 'CN00000007', 'NV00000007', 'KH0047', 152000.00, 0.00, N'Thẻ', N'Hoàn tất', '2026-04-14T15:29:00'),
    ('DH0048', 'CN00000008', 'NV00000008', NULL, 44000.00, 0.00, N'Chuyển khoản', N'Hoàn tất', '2026-04-16T16:36:00'),
    ('DH0049', 'CN00000009', 'NV00000009', 'KH0049', 88000.00, 15000.00, 'QR', N'Hoàn tất', '2026-04-18T17:43:00'),
    ('DH0050', 'CN00000010', 'NV00000010', 'KH0050', 150000.00, 20000.00, N'Ví điện tử', N'Hoàn tất', '2026-04-20T18:50:00');
GO

-- Enable lại trigger sau khi INSERT xong
ENABLE TRIGGER dbo.TRG_DonHang_CapNhatDiem ON dbo.DonHang;
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000001', 'DH0001', 'BT00000001', 2, 39000.00, N'Giao trước 10 phút'),
    ('CTDH000002', 'DH0002', 'BT00000002', 3, 45000.00, N'Giao trước 10 phút'),
    ('CTDH000003', 'DH0003', 'BT00000003', 4, 51000.00, N'50% đường'),
    ('CTDH000004', 'DH0004', 'BT00000004', 1, 35000.00, NULL),
    ('CTDH000005', 'DH0005', 'BT00000005', 2, 41000.00, N'Mang đi'),
    ('CTDH000006', 'DH0006', 'BT00000006', 3, 47000.00, NULL),
    ('CTDH000007', 'DH0007', 'BT00000007', 4, 49000.00, N'Giao trước 10 phút'),
    ('CTDH000008', 'DH0008', 'BT00000008', 1, 55000.00, N'Mang đi'),
    ('CTDH000009', 'DH0009', 'BT00000009', 2, 61000.00, NULL),
    ('CTDH000010', 'DH0010', 'BT00000010', 3, 55000.00, N'Không ống hút');
GO
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000011', 'DH0011', 'BT00000011', 4, 61000.00, N'Ít đá'),
    ('CTDH000012', 'DH0012', 'BT00000012', 1, 67000.00, N'Mang đi'),
    ('CTDH000013', 'DH0013', 'BT00000013', 2, 59000.00, N'Không ống hút'),
    ('CTDH000014', 'DH0014', 'BT00000014', 3, 65000.00, N'Ít đá'),
    ('CTDH000015', 'DH0015', 'BT00000015', 4, 71000.00, NULL),
    ('CTDH000016', 'DH0016', 'BT00000016', 1, 45000.00, N'Mang đi'),
    ('CTDH000017', 'DH0017', 'BT00000017', 2, 51000.00, N'50% đường'),
    ('CTDH000018', 'DH0018', 'BT00000018', 3, 57000.00, N'50% đường'),
    ('CTDH000019', 'DH0019', 'BT00000019', 4, 49000.00, N'Giao trước 10 phút'),
    ('CTDH000020', 'DH0020', 'BT00000020', 1, 55000.00, N'Không ống hút');
GO
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000021', 'DH0021', 'BT00000021', 2, 61000.00, N'Mang đi'),
    ('CTDH000022', 'DH0022', 'BT00000022', 3, 47000.00, N'Không ống hút'),
    ('CTDH000023', 'DH0023', 'BT00000023', 4, 53000.00, NULL),
    ('CTDH000024', 'DH0024', 'BT00000024', 1, 59000.00, N'50% đường'),
    ('CTDH000025', 'DH0025', 'BT00000025', 2, 39000.00, N'Không ống hút'),
    ('CTDH000026', 'DH0026', 'BT00000026', 3, 45000.00, N'Giao trước 10 phút'),
    ('CTDH000027', 'DH0027', 'BT00000027', 4, 51000.00, N'Mang đi'),
    ('CTDH000028', 'DH0028', 'BT00000028', 1, 49000.00, N'50% đường'),
    ('CTDH000029', 'DH0029', 'BT00000029', 2, 55000.00, N'Không ống hút'),
    ('CTDH000030', 'DH0030', 'BT00000030', 3, 61000.00, N'Không ống hút');
GO
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000031', 'DH0031', 'BT00000031', 4, 45000.00, N'Mang đi'),
    ('CTDH000032', 'DH0032', 'BT00000032', 1, 51000.00, N'Giao trước 10 phút'),
    ('CTDH000033', 'DH0033', 'BT00000033', 2, 57000.00, NULL),
    ('CTDH000034', 'DH0034', 'BT00000034', 3, 47000.00, N'Giao trước 10 phút'),
    ('CTDH000035', 'DH0035', 'BT00000035', 4, 53000.00, NULL),
    ('CTDH000036', 'DH0036', 'BT00000036', 1, 59000.00, N'Ít đá'),
    ('CTDH000037', 'DH0037', 'BT00000037', 2, 43000.00, N'Không ống hút'),
    ('CTDH000038', 'DH0038', 'BT00000038', 3, 49000.00, N'Không ống hút'),
    ('CTDH000039', 'DH0039', 'BT00000039', 4, 55000.00, N'50% đường'),
    ('CTDH000040', 'DH0040', 'BT00000040', 1, 44000.00, N'Ít đá');
GO
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000041', 'DH0041', 'BT00000041', 2, 50000.00, N'Không ống hút'),
    ('CTDH000042', 'DH0042', 'BT00000042', 3, 56000.00, NULL),
    ('CTDH000043', 'DH0043', 'BT00000043', 4, 52000.00, N'Mang đi'),
    ('CTDH000044', 'DH0044', 'BT00000044', 1, 58000.00, NULL),
    ('CTDH000045', 'DH0045', 'BT00000045', 2, 64000.00, N'Không ống hút'),
    ('CTDH000046', 'DH0046', 'BT00000046', 3, 32000.00, N'Không ống hút'),
    ('CTDH000047', 'DH0047', 'BT00000047', 4, 38000.00, NULL),
    ('CTDH000048', 'DH0048', 'BT00000048', 1, 44000.00, N'Mang đi'),
    ('CTDH000049', 'DH0049', 'BT00000049', 2, 44000.00, N'Ít đá'),
    ('CTDH000050', 'DH0050', 'BT00000050', 3, 50000.00, N'Không ống hút');
GO

ENABLE TRIGGER ALL ON DATABASE;
GO

/* ========================= 14. KIỂM THỬ NGHIỆP VỤ ========================= */
EXEC dbo.sp_GhiNhanGiaoDichKho
    @LogID = 'LOG0000001',
    @MaChiNhanh = 'CN00000001',
    @MaNguyenLieu = 'NL00000001',
    @LoaiGiaoDich = N'Nhập',
    @SoLuong = 5,
    @GhiChu = N'Nhập kho đầu ngày';
GO

EXEC dbo.sp_GhiNhanGiaoDichKho
    @LogID = 'LOG0000002',
    @MaChiNhanh = 'CN00000001',
    @MaNguyenLieu = 'NL00000003',
    @LoaiGiaoDich = N'Xuất',
    @SoLuong = 1,
    @GhiChu = N'Xuất pha chế';
GO

EXEC dbo.sp_KhoiTaoBangLuong @Thang = 6, @Nam = 2026;
GO

EXEC dbo.sp_TaoDonHang
    @MaDH = 'DH00001',
    @MaChiNhanh = 'CN00000001',
    @MaNV = 'NV00000002',
    @MaKH = 'KH0001',
    @PhuongThucThanhToan = N'QR',
    @GiamGia = 0,
    @MaBienThe1 = 'BT00000001',
    @SoLuong1 = 2,
    @MaBienThe2 = 'BT00000005',
    @SoLuong2 = 1;
GO

EXEC dbo.sp_CanhBaoTonKho;
GO

/* ========================= 15. TRUY VẤN BÁO CÁO MẪU ========================= */
SELECT * FROM dbo.vw_MenuChiNhanh WHERE MaChiNhanh = 'CN00000001';
SELECT * FROM dbo.vw_CanhBaoTonKho ORDER BY MaChiNhanh, MaNguyenLieu;
SELECT * FROM dbo.vw_BangLuongTongHop ORDER BY Nam, Thang, MaNV;
SELECT * FROM dbo.DuLieuHeThong ORDER BY ThoiGian DESC;
SELECT * FROM dbo.DonHang;
SELECT * FROM dbo.ChiTietDonHang;
SELECT * FROM dbo.PhatDiMuon;
GO

/* ========================= 16. SAO LƯU - PHỤC HỒI ========================= */
/*
-- A. FULL BACKUP
BACKUP DATABASE QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_FULL.bak'
WITH FORMAT, INIT, NAME = N'Full Backup QuanLyChuoiCaPhe';

-- B. DIFFERENTIAL BACKUP
BACKUP DATABASE QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_DIFF.bak'
WITH DIFFERENTIAL, INIT, NAME = N'Differential Backup QuanLyChuoiCaPhe';

-- C. LOG BACKUP
BACKUP LOG QuanLyChuoiCaPhe
TO DISK = 'C:\Backup\QuanLyChuoiCaPhe_LOG.trn'
WITH INIT, NAME = N'Log Backup QuanLyChuoiCaPhe';

-- D. PHỤC HỒI CSDL
USE master;
ALTER DATABASE QuanLyChuoiCaPhe SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE QuanLyChuoiCaPhe
FROM DISK = 'C:\Backup\QuanLyChuoiCaPhe_FULL.bak'
WITH REPLACE, RECOVERY;
ALTER DATABASE QuanLyChuoiCaPhe SET MULTI_USER;
*/
GO

/* ========================= 17. QUẢN TRỊ NGƯỜI DÙNG - PHÂN QUYỀN ========================= */
/*
USE master;
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'qlcf_admin')
    CREATE LOGIN qlcf_admin WITH PASSWORD = 'StrongAdmin@123';
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'qlcf_staff')
    CREATE LOGIN qlcf_staff WITH PASSWORD = 'StrongStaff@123';
GO

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