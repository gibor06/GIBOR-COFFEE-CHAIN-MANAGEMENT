-- =============================================
-- THÊM 50 ĐơN HÀNG VÀ CHI TIẾT ĐƠN HÀNG
-- =============================================
USE QuanLyChuoiCaPhe;
GO

PRINT '';
PRINT '========================================';
PRINT 'BẮT ĐẦU THÊM 50 ĐƠN HÀNG';
PRINT '========================================';
GO

-- Tắt trigger để tránh tính toán tự động
IF OBJECT_ID(N'dbo.TRG_ChiTietDonHang_CapNhatTongTien', N'TR') IS NOT NULL
    DISABLE TRIGGER dbo.TRG_ChiTietDonHang_CapNhatTongTien ON dbo.ChiTietDonHang;
GO

IF OBJECT_ID(N'dbo.TRG_DonHang_CapNhatDiem', N'TR') IS NOT NULL
    DISABLE TRIGGER dbo.TRG_DonHang_CapNhatDiem ON dbo.DonHang;
GO

-- =============================================
-- BƯỚC 1: Thêm 50 đơn hàng
-- =============================================
PRINT 'Thêm 50 đơn hàng...';

-- Đơn hàng 1-10
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0001', 'CN00000001', 'NV00000001', 'KH0001', 125000, 0, N'Tiền mặt', N'Hoàn tất', '2026-05-01T08:30:00'),
    ('DH0002', 'CN00000001', 'NV00000002', 'KH0002', 280000, 20000, N'Thẻ', N'Hoàn tất', '2026-05-01T09:15:00'),
    ('DH0003', 'CN00000002', 'NV00000003', 'KH0003', 450000, 50000, N'Chuyển khoản', N'Hoàn tất', '2026-05-01T10:20:00'),
    ('DH0004', 'CN00000002', 'NV00000004', 'KH0004', 95000, 0, N'QR', N'Hoàn tất', '2026-05-01T11:45:00'),
    ('DH0005', 'CN00000003', 'NV00000005', 'KH0005', 320000, 30000, N'Ví điện tử', N'Hoàn tất', '2026-05-01T13:10:00'),
    ('DH0006', 'CN00000003', 'NV00000006', 'KH0006', 580000, 80000, N'Tiền mặt', N'Hoàn tất', '2026-05-01T14:25:00'),
    ('DH0007', 'CN00000004', 'NV00000007', 'KH0007', 180000, 0, N'Thẻ', N'Hoàn tất', '2026-05-01T15:40:00'),
    ('DH0008', 'CN00000004', 'NV00000008', 'KH0008', 750000, 100000, N'Chuyển khoản', N'Hoàn tất', '2026-05-01T16:55:00'),
    ('DH0009', 'CN00000005', 'NV00000009', 'KH0009', 240000, 0, N'QR', N'Hoàn tất', '2026-05-02T08:10:00'),
    ('DH0010', 'CN00000005', 'NV00000010', 'KH0010', 920000, 120000, N'Ví điện tử', N'Hoàn tất', '2026-05-02T09:25:00');
GO

-- Đơn hàng 11-20
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0011', 'CN00000006', 'NV00000011', 'KH0011', 135000, 10000, N'Tiền mặt', N'Hoàn tất', '2026-05-02T10:40:00'),
    ('DH0012', 'CN00000006', 'NV00000012', 'KH0012', 360000, 40000, N'Thẻ', N'Hoàn tất', '2026-05-02T11:55:00'),
    ('DH0013', 'CN00000007', 'NV00000013', 'KH0013', 490000, 60000, N'Chuyển khoản', N'Hoàn tất', '2026-05-02T13:10:00'),
    ('DH0014', 'CN00000007', 'NV00000014', 'KH0014', 210000, 0, N'QR', N'Hoàn tất', '2026-05-02T14:25:00'),
    ('DH0015', 'CN00000008', 'NV00000015', 'KH0015', 600000, 70000, N'Ví điện tử', N'Hoàn tất', '2026-05-02T15:40:00'),
    ('DH0016', 'CN00000008', 'NV00000016', 'KH0016', 410000, 50000, N'Tiền mặt', N'Hoàn tất', '2026-05-02T16:55:00'),
    ('DH0017', 'CN00000009', 'NV00000017', 'KH0017', 680000, 90000, N'Thẻ', N'Hoàn tất', '2026-05-03T08:10:00'),
    ('DH0018', 'CN00000009', 'NV00000018', 'KH0018', 170000, 0, N'Chuyển khoản', N'Hoàn tất', '2026-05-03T09:25:00'),
    ('DH0019', 'CN00000010', 'NV00000019', 'KH0019', 850000, 110000, N'QR', N'Hoàn tất', '2026-05-03T10:40:00'),
    ('DH0020', 'CN00000010', 'NV00000020', 'KH0020', 300000, 30000, N'Ví điện tử', N'Hoàn tất', '2026-05-03T11:55:00');
GO

-- Đơn hàng 21-30
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0021', 'CN00000011', 'NV00000021', 'KH0021', 460000, 60000, N'Tiền mặt', N'Hoàn tất', '2026-05-03T13:10:00'),
    ('DH0022', 'CN00000011', 'NV00000022', 'KH0022', 530000, 70000, N'Thẻ', N'Hoàn tất', '2026-05-03T14:25:00'),
    ('DH0023', 'CN00000012', 'NV00000023', 'KH0023', 195000, 0, N'Chuyển khoản', N'Hoàn tất', '2026-05-03T15:40:00'),
    ('DH0024', 'CN00000012', 'NV00000024', 'KH0024', 690000, 90000, N'QR', N'Hoàn tất', '2026-05-03T16:55:00'),
    ('DH0025', 'CN00000013', 'NV00000025', 'KH0025', 330000, 40000, N'Ví điện tử', N'Hoàn tất', '2026-05-04T08:10:00'),
    ('DH0026', 'CN00000013', 'NV00000026', 'KH0026', 780000, 100000, N'Tiền mặt', N'Hoàn tất', '2026-05-04T09:25:00'),
    ('DH0027', 'CN00000014', 'NV00000027', 'KH0027', 230000, 0, N'Thẻ', N'Hoàn tất', '2026-05-04T10:40:00'),
    ('DH0028', 'CN00000014', 'NV00000028', 'KH0028', 910000, 130000, N'Chuyển khoản', N'Hoàn tất', '2026-05-04T11:55:00'),
    ('DH0029', 'CN00000015', 'NV00000029', 'KH0029', 370000, 50000, N'QR', N'Hoàn tất', '2026-05-04T13:10:00'),
    ('DH0030', 'CN00000015', 'NV00000030', 'KH0030', 510000, 60000, N'Ví điện tử', N'Hoàn tất', '2026-05-04T14:25:00');
GO

-- Đơn hàng 31-40
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0031', 'CN00000016', 'NV00000031', 'KH0031', 630000, 80000, N'Tiền mặt', N'Hoàn tất', '2026-05-04T15:40:00'),
    ('DH0032', 'CN00000016', 'NV00000032', 'KH0032', 140000, 0, N'Thẻ', N'Hoàn tất', '2026-05-04T16:55:00'),
    ('DH0033', 'CN00000017', 'NV00000033', 'KH0033', 820000, 110000, N'Chuyển khoản', N'Hoàn tất', '2026-05-05T08:10:00'),
    ('DH0034', 'CN00000017', 'NV00000034', 'KH0034', 270000, 30000, N'QR', N'Hoàn tất', '2026-05-05T09:25:00'),
    ('DH0035', 'CN00000018', 'NV00000035', 'KH0035', 550000, 70000, N'Ví điện tử', N'Hoàn tất', '2026-05-05T10:40:00'),
    ('DH0036', 'CN00000018', 'NV00000036', 'KH0036', 420000, 50000, N'Tiền mặt', N'Hoàn tất', '2026-05-05T11:55:00'),
    ('DH0037', 'CN00000019', 'NV00000037', 'KH0037', 710000, 90000, N'Thẻ', N'Hoàn tất', '2026-05-05T13:10:00'),
    ('DH0038', 'CN00000019', 'NV00000038', 'KH0038', 200000, 0, N'Chuyển khoản', N'Hoàn tất', '2026-05-05T14:25:00'),
    ('DH0039', 'CN00000020', 'NV00000039', 'KH0039', 870000, 120000, N'QR', N'Hoàn tất', '2026-05-05T15:40:00'),
    ('DH0040', 'CN00000020', 'NV00000040', 'KH0040', 310000, 40000, N'Ví điện tử', N'Hoàn tất', '2026-05-05T16:55:00');
GO

-- Đơn hàng 41-50
INSERT INTO dbo.DonHang (MaDH, MaChiNhanh, MaNV, MaKH, TongTien, GiamGia, PhuongThucThanhToan, TrangThai, NgayTao) VALUES
    ('DH0041', 'CN00000001', 'NV00000001', 'KH0041', 480000, 60000, N'Tiền mặt', N'Hoàn tất', '2026-05-06T08:10:00'),
    ('DH0042', 'CN00000002', 'NV00000002', 'KH0042', 590000, 80000, N'Thẻ', N'Hoàn tất', '2026-05-06T09:25:00'),
    ('DH0043', 'CN00000003', 'NV00000003', 'KH0043', 220000, 0, N'Chuyển khoản', N'Hoàn tất', '2026-05-06T10:40:00'),
    ('DH0044', 'CN00000004', 'NV00000004', 'KH0044', 730000, 100000, N'QR', N'Hoàn tất', '2026-05-06T11:55:00'),
    ('DH0045', 'CN00000005', 'NV00000005', 'KH0045', 360000, 50000, N'Ví điện tử', N'Hoàn tất', '2026-05-06T13:10:00'),
    ('DH0046', 'CN00000006', 'NV00000006', 'KH0046', 640000, 80000, N'Tiền mặt', N'Hoàn tất', '2026-05-06T14:25:00'),
    ('DH0047', 'CN00000007', 'NV00000007', 'KH0047', 180000, 0, N'Thẻ', N'Hoàn tất', '2026-05-06T15:40:00'),
    ('DH0048', 'CN00000008', 'NV00000008', 'KH0048', 790000, 110000, N'Chuyển khoản', N'Hoàn tất', '2026-05-06T16:55:00'),
    ('DH0049', 'CN00000009', 'NV00000009', 'KH0049', 400000, 50000, N'QR', N'Hoàn tất', '2026-05-07T08:10:00'),
    ('DH0050', 'CN00000010', 'NV00000010', 'KH0050', 560000, 70000, N'Ví điện tử', N'Hoàn tất', '2026-05-07T09:25:00');
GO

PRINT '  ✓ Đã thêm 50 đơn hàng';
GO

-- =============================================
-- BƯỚC 2: Thêm chi tiết đơn hàng (150 chi tiết)
-- =============================================
PRINT 'Thêm chi tiết đơn hàng...';

-- Chi tiết đơn hàng 1-5 (mỗi đơn 3 món)
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000001', 'DH0001', 'BT0001', 2, 25000, N'Ít đường'),
    ('CTDH000002', 'DH0001', 'BT0004', 1, 30000, N'Nhiều đá'),
    ('CTDH000003', 'DH0001', 'BT0007', 2, 35000, NULL),
    ('CTDH000004', 'DH0002', 'BT0010', 3, 35000, N'Nóng'),
    ('CTDH000005', 'DH0002', 'BT0013', 2, 40000, N'Ít đá'),
    ('CTDH000006', 'DH0002', 'BT0016', 2, 45000, NULL),
    ('CTDH000007', 'DH0003', 'BT0019', 4, 40000, N'Nhiều đường'),
    ('CTDH000008', 'DH0003', 'BT0022', 3, 45000, NULL),
    ('CTDH000009', 'DH0003', 'BT0025', 2, 50000, N'Ít đá'),
    ('CTDH000010', 'DH0004', 'BT0028', 2, 30000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000011', 'DH0004', 'BT0031', 1, 35000, N'Nóng'),
    ('CTDH000012', 'DH0005', 'BT0034', 3, 40000, NULL),
    ('CTDH000013', 'DH0005', 'BT0037', 2, 45000, N'Ít đường'),
    ('CTDH000014', 'DH0005', 'BT0040', 2, 50000, NULL),
    ('CTDH000015', 'DH0006', 'BT0043', 4, 50000, N'Nhiều đá'),
    ('CTDH000016', 'DH0006', 'BT0046', 3, 55000, NULL),
    ('CTDH000017', 'DH0006', 'BT0049', 2, 60000, N'Ít đá'),
    ('CTDH000018', 'DH0007', 'BT0052', 2, 35000, NULL),
    ('CTDH000019', 'DH0007', 'BT0055', 2, 40000, N'Nóng'),
    ('CTDH000020', 'DH0007', 'BT0058', 1, 45000, NULL);
GO

-- Chi tiết đơn hàng 8-15
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000021', 'DH0008', 'BT0061', 5, 50000, N'Nhiều đường'),
    ('CTDH000022', 'DH0008', 'BT0064', 3, 55000, NULL),
    ('CTDH000023', 'DH0008', 'BT0067', 2, 60000, N'Ít đá'),
    ('CTDH000024', 'DH0009', 'BT0070', 2, 40000, NULL),
    ('CTDH000025', 'DH0009', 'BT0073', 2, 45000, N'Nóng'),
    ('CTDH000026', 'DH0009', 'BT0076', 1, 50000, NULL),
    ('CTDH000027', 'DH0010', 'BT0079', 6, 55000, N'Nhiều đá'),
    ('CTDH000028', 'DH0010', 'BT0082', 4, 60000, NULL),
    ('CTDH000029', 'DH0010', 'BT0085', 3, 65000, N'Ít đường'),
    ('CTDH000030', 'DH0011', 'BT0088', 2, 35000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000031', 'DH0011', 'BT0091', 2, 40000, N'Nóng'),
    ('CTDH000032', 'DH0011', 'BT0094', 1, 45000, NULL),
    ('CTDH000033', 'DH0012', 'BT0097', 3, 50000, N'Nhiều đường'),
    ('CTDH000034', 'DH0012', 'BT0100', 2, 55000, NULL),
    ('CTDH000035', 'DH0012', 'BT0103', 2, 60000, N'Ít đá'),
    ('CTDH000036', 'DH0013', 'BT0106', 4, 55000, NULL),
    ('CTDH000037', 'DH0013', 'BT0109', 3, 60000, N'Nóng'),
    ('CTDH000038', 'DH0013', 'BT0112', 2, 65000, NULL),
    ('CTDH000039', 'DH0014', 'BT0001', 2, 25000, N'Ít đường'),
    ('CTDH000040', 'DH0014', 'BT0004', 2, 30000, NULL);
GO

-- Chi tiết đơn hàng 15-25
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000041', 'DH0014', 'BT0007', 2, 35000, N'Nhiều đá'),
    ('CTDH000042', 'DH0015', 'BT0010', 4, 35000, NULL),
    ('CTDH000043', 'DH0015', 'BT0013', 3, 40000, N'Nóng'),
    ('CTDH000044', 'DH0015', 'BT0016', 3, 45000, NULL),
    ('CTDH000045', 'DH0016', 'BT0019', 3, 40000, N'Ít đường'),
    ('CTDH000046', 'DH0016', 'BT0022', 2, 45000, NULL),
    ('CTDH000047', 'DH0016', 'BT0025', 2, 50000, N'Nhiều đá'),
    ('CTDH000048', 'DH0017', 'BT0028', 5, 30000, NULL),
    ('CTDH000049', 'DH0017', 'BT0031', 3, 35000, N'Nóng'),
    ('CTDH000050', 'DH0017', 'BT0034', 2, 40000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000051', 'DH0018', 'BT0037', 2, 45000, N'Ít đá'),
    ('CTDH000052', 'DH0018', 'BT0040', 1, 50000, NULL),
    ('CTDH000053', 'DH0018', 'BT0043', 1, 50000, N'Nhiều đường'),
    ('CTDH000054', 'DH0019', 'BT0046', 6, 55000, NULL),
    ('CTDH000055', 'DH0019', 'BT0049', 4, 60000, N'Nóng'),
    ('CTDH000056', 'DH0019', 'BT0052', 3, 35000, NULL),
    ('CTDH000057', 'DH0020', 'BT0055', 3, 40000, N'Ít đường'),
    ('CTDH000058', 'DH0020', 'BT0058', 2, 45000, NULL),
    ('CTDH000059', 'DH0020', 'BT0061', 2, 50000, N'Nhiều đá'),
    ('CTDH000060', 'DH0021', 'BT0064', 4, 55000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000061', 'DH0021', 'BT0067', 2, 60000, N'Nóng'),
    ('CTDH000062', 'DH0021', 'BT0070', 2, 40000, NULL),
    ('CTDH000063', 'DH0022', 'BT0073', 4, 45000, N'Ít đá'),
    ('CTDH000064', 'DH0022', 'BT0076', 3, 50000, NULL),
    ('CTDH000065', 'DH0022', 'BT0079', 2, 55000, N'Nhiều đường'),
    ('CTDH000066', 'DH0023', 'BT0082', 2, 60000, NULL),
    ('CTDH000067', 'DH0023', 'BT0085', 1, 65000, N'Nóng'),
    ('CTDH000068', 'DH0023', 'BT0088', 2, 35000, NULL),
    ('CTDH000069', 'DH0024', 'BT0091', 5, 40000, N'Ít đường'),
    ('CTDH000070', 'DH0024', 'BT0094', 3, 45000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000071', 'DH0024', 'BT0097', 2, 50000, N'Nhiều đá'),
    ('CTDH000072', 'DH0025', 'BT0100', 3, 55000, NULL),
    ('CTDH000073', 'DH0025', 'BT0103', 2, 60000, N'Nóng'),
    ('CTDH000074', 'DH0025', 'BT0106', 2, 55000, NULL),
    ('CTDH000075', 'DH0026', 'BT0109', 5, 60000, N'Ít đường'),
    ('CTDH000076', 'DH0026', 'BT0112', 4, 65000, NULL),
    ('CTDH000077', 'DH0026', 'BT0001', 3, 25000, N'Nhiều đá'),
    ('CTDH000078', 'DH0027', 'BT0004', 2, 30000, NULL),
    ('CTDH000079', 'DH0027', 'BT0007', 2, 35000, N'Nóng'),
    ('CTDH000080', 'DH0027', 'BT0010', 2, 35000, NULL);
GO

-- Chi tiết đơn hàng 28-40
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000081', 'DH0028', 'BT0013', 6, 40000, N'Ít đường'),
    ('CTDH000082', 'DH0028', 'BT0016', 5, 45000, NULL),
    ('CTDH000083', 'DH0028', 'BT0019', 4, 40000, N'Nhiều đá'),
    ('CTDH000084', 'DH0029', 'BT0022', 3, 45000, NULL),
    ('CTDH000085', 'DH0029', 'BT0025', 2, 50000, N'Nóng'),
    ('CTDH000086', 'DH0029', 'BT0028', 2, 30000, NULL),
    ('CTDH000087', 'DH0030', 'BT0031', 4, 35000, N'Ít đá'),
    ('CTDH000088', 'DH0030', 'BT0034', 3, 40000, NULL),
    ('CTDH000089', 'DH0030', 'BT0037', 2, 45000, N'Nhiều đường'),
    ('CTDH000090', 'DH0031', 'BT0040', 5, 50000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000091', 'DH0031', 'BT0043', 3, 50000, N'Nóng'),
    ('CTDH000092', 'DH0031', 'BT0046', 2, 55000, NULL),
    ('CTDH000093', 'DH0032', 'BT0049', 2, 60000, N'Ít đường'),
    ('CTDH000094', 'DH0032', 'BT0052', 1, 35000, NULL),
    ('CTDH000095', 'DH0032', 'BT0055', 1, 40000, N'Nhiều đá'),
    ('CTDH000096', 'DH0033', 'BT0058', 6, 45000, NULL),
    ('CTDH000097', 'DH0033', 'BT0061', 4, 50000, N'Nóng'),
    ('CTDH000098', 'DH0033', 'BT0064', 3, 55000, NULL),
    ('CTDH000099', 'DH0034', 'BT0067', 3, 60000, N'Ít đá'),
    ('CTDH000100', 'DH0034', 'BT0070', 2, 40000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000101', 'DH0035', 'BT0073', 4, 45000, N'Nhiều đường'),
    ('CTDH000102', 'DH0035', 'BT0076', 3, 50000, NULL),
    ('CTDH000103', 'DH0035', 'BT0079', 2, 55000, N'Nóng'),
    ('CTDH000104', 'DH0036', 'BT0082', 3, 60000, NULL),
    ('CTDH000105', 'DH0036', 'BT0085', 2, 65000, N'Ít đường'),
    ('CTDH000106', 'DH0036', 'BT0088', 2, 35000, NULL),
    ('CTDH000107', 'DH0037', 'BT0091', 5, 40000, N'Nhiều đá'),
    ('CTDH000108', 'DH0037', 'BT0094', 3, 45000, NULL),
    ('CTDH000109', 'DH0037', 'BT0097', 2, 50000, N'Nóng'),
    ('CTDH000110', 'DH0038', 'BT0100', 2, 55000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000111', 'DH0038', 'BT0103', 2, 60000, N'Ít đường'),
    ('CTDH000112', 'DH0038', 'BT0106', 1, 55000, NULL),
    ('CTDH000113', 'DH0039', 'BT0109', 6, 60000, N'Nhiều đường'),
    ('CTDH000114', 'DH0039', 'BT0112', 4, 65000, NULL),
    ('CTDH000115', 'DH0039', 'BT0001', 3, 25000, N'Nóng'),
    ('CTDH000116', 'DH0040', 'BT0004', 3, 30000, NULL),
    ('CTDH000117', 'DH0040', 'BT0007', 2, 35000, N'Ít đường'),
    ('CTDH000118', 'DH0040', 'BT0010', 2, 35000, NULL),
    ('CTDH000119', 'DH0041', 'BT0013', 4, 40000, N'Nhiều đá'),
    ('CTDH000120', 'DH0041', 'BT0016', 3, 45000, NULL);
GO

-- Chi tiết đơn hàng 41-50
INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000121', 'DH0041', 'BT0019', 2, 40000, N'Nóng'),
    ('CTDH000122', 'DH0042', 'BT0022', 4, 45000, NULL),
    ('CTDH000123', 'DH0042', 'BT0025', 3, 50000, N'Ít đường'),
    ('CTDH000124', 'DH0042', 'BT0028', 2, 30000, NULL),
    ('CTDH000125', 'DH0043', 'BT0031', 2, 35000, N'Nhiều đá'),
    ('CTDH000126', 'DH0043', 'BT0034', 2, 40000, NULL),
    ('CTDH000127', 'DH0043', 'BT0037', 2, 45000, N'Nóng'),
    ('CTDH000128', 'DH0044', 'BT0040', 5, 50000, NULL),
    ('CTDH000129', 'DH0044', 'BT0043', 4, 50000, N'Ít đường'),
    ('CTDH000130', 'DH0044', 'BT0046', 2, 55000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000131', 'DH0045', 'BT0049', 3, 60000, N'Nhiều đường'),
    ('CTDH000132', 'DH0045', 'BT0052', 2, 35000, NULL),
    ('CTDH000133', 'DH0045', 'BT0055', 2, 40000, N'Nóng'),
    ('CTDH000134', 'DH0046', 'BT0058', 5, 45000, NULL),
    ('CTDH000135', 'DH0046', 'BT0061', 3, 50000, N'Ít đường'),
    ('CTDH000136', 'DH0046', 'BT0064', 2, 55000, NULL),
    ('CTDH000137', 'DH0047', 'BT0067', 2, 60000, N'Nhiều đá'),
    ('CTDH000138', 'DH0047', 'BT0070', 1, 40000, NULL),
    ('CTDH000139', 'DH0047', 'BT0073', 1, 45000, N'Nóng'),
    ('CTDH000140', 'DH0048', 'BT0076', 6, 50000, NULL);
GO

INSERT INTO dbo.ChiTietDonHang (MaCTDH, MaDH, MaBienThe, SoLuong, DonGia, GhiChu) VALUES
    ('CTDH000141', 'DH0048', 'BT0079', 4, 55000, N'Ít đường'),
    ('CTDH000142', 'DH0048', 'BT0082', 2, 60000, NULL),
    ('CTDH000143', 'DH0049', 'BT0085', 3, 65000, N'Nhiều đường'),
    ('CTDH000144', 'DH0049', 'BT0088', 2, 35000, NULL),
    ('CTDH000145', 'DH0049', 'BT0091', 2, 40000, N'Nóng'),
    ('CTDH000146', 'DH0050', 'BT0094', 4, 45000, NULL),
    ('CTDH000147', 'DH0050', 'BT0097', 3, 50000, N'Ít đường'),
    ('CTDH000148', 'DH0050', 'BT0100', 2, 55000, NULL);
GO

PRINT '  ✓ Đã thêm 148 chi tiết đơn hàng';
GO

-- Bật lại trigger
IF OBJECT_ID(N'dbo.TRG_ChiTietDonHang_CapNhatTongTien', N'TR') IS NOT NULL
    ENABLE TRIGGER dbo.TRG_ChiTietDonHang_CapNhatTongTien ON dbo.ChiTietDonHang;
GO

IF OBJECT_ID(N'dbo.TRG_DonHang_CapNhatDiem', N'TR') IS NOT NULL
    ENABLE TRIGGER dbo.TRG_DonHang_CapNhatDiem ON dbo.DonHang;
GO

PRINT '';
PRINT '========================================';
PRINT '✅ HOÀN THÀNH THÊM 50 ĐƠN HÀNG';
PRINT '========================================';
PRINT '';
PRINT 'Tổng kết:';
PRINT '  - 50 đơn hàng';
PRINT '  - 148 chi tiết đơn hàng';
PRINT '  - Tổng doanh thu: ' + CAST((SELECT SUM(TongTien - GiamGia) FROM DonHang WHERE MaDH LIKE 'DH00%') AS NVARCHAR(20)) + ' VNĐ';
GO
