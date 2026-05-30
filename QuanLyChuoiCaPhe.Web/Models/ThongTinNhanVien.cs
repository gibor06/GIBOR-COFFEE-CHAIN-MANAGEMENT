using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc.ModelBinding.Validation;

namespace QuanLyChuoiCaPhe.Web.Models
{
    [Table("ThongTinNhanVien")]
    public class ThongTinNhanVien
    {
        [Key]
        [StringLength(10)]
        [ValidateNever]
        public string MaNV { get; set; } = string.Empty;
        
        public byte LoaiNV { get; set; }
        
        [Required]
        [StringLength(100)]
        public string HoTenNV { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaChucVu { get; set; } = null!;
        
        [Required]
        [StringLength(10)]
        public string MaChiNhanh { get; set; } = null!;
        
        public DateTime NgayVaoLam { get; set; }
        
        public DateTime? NgayNghiViec { get; set; }
        
        [Required]
        [StringLength(10)]
        [RegularExpression(@"^(03|05|07|08|09)[0-9]{8}$", ErrorMessage = "Số điện thoại không hợp lệ")]
        public string SoDienThoai { get; set; } = null!;
        
        [StringLength(12, ErrorMessage = "Số Căn cước công dân phải chính xác 12 chữ số")]
        [RegularExpression(@"^(\d{12})?$", ErrorMessage = "Số Căn cước công dân phải gồm đúng 12 chữ số từ 0-9 hoặc để trống.")]
        public string? SoCCCD { get; set; }
        
        [StringLength(100)]
        public string? Email { get; set; }
        
        public bool TrangThai { get; set; }
        
        [ForeignKey("MaChucVu")]
        [ValidateNever]
        public virtual ChucVuNhanVien? ChucVuNhanVien { get; set; }
        
        [ForeignKey("MaChiNhanh")]
        [ValidateNever]
        public virtual ChiNhanh? ChiNhanh { get; set; }
        
        [ValidateNever]
        public virtual ICollection<DonHang>? DonHangs { get; set; } = new List<DonHang>();
        
        [ValidateNever]
        public virtual ICollection<BangLuong>? BangLuongs { get; set; } = new List<BangLuong>();
        
        [ValidateNever]
        public virtual ICollection<TaiKhoanNhanVien>? TaiKhoanNhanViens { get; set; } = new List<TaiKhoanNhanVien>();
    }
}
