using Microsoft.EntityFrameworkCore;
using QuanLyChuoiCaPhe.Web.Models;

namespace QuanLyChuoiCaPhe.Web.Data
{
    public partial class QuanLyChuoiCaPheContext : DbContext
    {
        public QuanLyChuoiCaPheContext(DbContextOptions<QuanLyChuoiCaPheContext> options)
            : base(options)
        {
        }

        public virtual DbSet<HeThongTaiKhoan> HeThongTaiKhoans { get; set; }
        public virtual DbSet<DuLieuHeThong> DuLieuHeThongs { get; set; }
        public virtual DbSet<KhuVuc> KhuVucs { get; set; }
        public virtual DbSet<ChiNhanh> ChiNhanhs { get; set; }
        public virtual DbSet<ChucVuNhanVien> ChucVuNhanViens { get; set; }
        public virtual DbSet<ThongTinNhanVien> ThongTinNhanViens { get; set; }
        public virtual DbSet<TaiKhoanNhanVien> TaiKhoanNhanViens { get; set; }
        public virtual DbSet<CaLamViec> CaLamViecs { get; set; }
        public virtual DbSet<NgayDacBiet> NgayDacBiets { get; set; }
        public virtual DbSet<LichPhanCong> LichPhanCongs { get; set; }
        public virtual DbSet<ChamCong> ChamCongs { get; set; }
        public virtual DbSet<PhatDiMuon> PhatDiMuons { get; set; }
        public virtual DbSet<BangLuong> BangLuongs { get; set; }
        public virtual DbSet<DanhMuc> DanhMucs { get; set; }
        public virtual DbSet<SanPham> SanPhams { get; set; }
        public virtual DbSet<SanPhamChiNhanh> SanPhamChiNhanhs { get; set; }
        public virtual DbSet<BienTheSanPham> BienTheSanPhams { get; set; }
        public virtual DbSet<TuyChonThem> TuyChonThems { get; set; }
        public virtual DbSet<SanPhamTuyChon> SanPhamTuyChons { get; set; }
        public virtual DbSet<NhaCungCap> NhaCungCaps { get; set; }
        public virtual DbSet<NguyenLieu> NguyenLieus { get; set; }
        public virtual DbSet<TonKhoNguyenLieu> TonKhoNguyenLieus { get; set; }
        public virtual DbSet<CongThucPhaChe> CongThucPhaChe { get; set; }
        public virtual DbSet<LichSuKho> LichSuKhos { get; set; }
        public virtual DbSet<KhachHang> KhachHangs { get; set; }
        public virtual DbSet<DonHang> DonHangs { get; set; }
        public virtual DbSet<ChiTietDonHang> ChiTietDonHangs { get; set; }
        
        // Views
        public virtual DbSet<VwMenuChiNhanh> VwMenuChiNhanhs { get; set; }
        public virtual DbSet<VwCanhBaoTonKho> VwCanhBaoTonKhos { get; set; }
        public virtual DbSet<VwBangLuongTongHop> VwBangLuongTongHops { get; set; }
        public virtual DbSet<HanhTrinhDonHang> HanhTrinhDonHangs { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Composite Keys Configuration
            modelBuilder.Entity<BangLuong>()
                .HasKey(b => new { b.MaNV, b.Thang, b.Nam });

            modelBuilder.Entity<TaiKhoanNhanVien>()
                .HasKey(t => new { t.MaTK, t.MaNV });

            modelBuilder.Entity<SanPhamChiNhanh>()
                .HasKey(s => new { s.MaChiNhanh, s.MaSanPham });

            modelBuilder.Entity<SanPhamTuyChon>()
                .HasKey(s => new { s.MaSanPham, s.MaTuyChon });

            modelBuilder.Entity<TonKhoNguyenLieu>()
                .HasKey(t => new { t.MaChiNhanh, t.MaNguyenLieu });

            modelBuilder.Entity<CongThucPhaChe>()
                .HasKey(c => new { c.MaCongThuc, c.MaNguyenLieu });

            // Disable OUTPUT clause for tables with triggers
            // This fixes: "The target table of the DML statement cannot have any enabled triggers 
            // if the statement contains an OUTPUT clause without INTO clause"
            
            // HeThongTaiKhoan
            modelBuilder.Entity<HeThongTaiKhoan>()
                .ToTable(tb => tb.HasTrigger("TR_HeThongTaiKhoan_NhatKy"));
            
            // ChiNhanh
            modelBuilder.Entity<ChiNhanh>()
                .ToTable(tb => tb.HasTrigger("TRG_ChiNhanh_NhatKy"));
            
            // ThongTinNhanVien
            modelBuilder.Entity<ThongTinNhanVien>()
                .ToTable(tb => tb.HasTrigger("TRG_ThongTinNhanVien_SetTrangThai"));
            
            // LichPhanCong
            modelBuilder.Entity<LichPhanCong>()
                .ToTable(tb => tb.HasTrigger("TRG_LichPhanCong_Validate"));
            
            // BangLuong
            modelBuilder.Entity<BangLuong>()
                .ToTable(tb => tb.HasTrigger("TRG_BangLuong_KhoaDuLieu"));
            
            // SanPham (2 triggers)
            modelBuilder.Entity<SanPham>()
                .ToTable(tb => tb.HasTrigger("TRG_SanPham_DongBoTrangThaiChiNhanh"))
                .ToTable(tb => tb.HasTrigger("TRG_SanPham_TuDongDongBoChiNhanh"));
            
            // LichSuKho
            modelBuilder.Entity<LichSuKho>()
                .ToTable(tb => tb.HasTrigger("TRG_LichSuKho_CapNhatTon"));
            
            // ChiTietDonHang
            modelBuilder.Entity<ChiTietDonHang>()
                .ToTable(tb => tb.HasTrigger("TRG_ChiTietDonHang_CapNhatTongTien"));
            
            // DonHang
            modelBuilder.Entity<DonHang>()
                .ToTable(tb => tb.HasTrigger("TRG_DonHang_CapNhatDiem"));

            // Views configuration
            modelBuilder.Entity<VwMenuChiNhanh>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vw_MenuChiNhanh");
            });

            modelBuilder.Entity<VwCanhBaoTonKho>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vw_CanhBaoTonKho");
            });

            modelBuilder.Entity<VwBangLuongTongHop>(entity =>
            {
                entity.HasNoKey();
                entity.ToView("vw_BangLuongTongHop");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
