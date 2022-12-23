create database QuanLyNhaHang

CREATE TABLE CuaHang
(
	MaCuaHang CHAR(6) NOT NULL,
	MaQuanLy CHAR(8) NOT NULL,
    MoTa NVARCHAR(MAX),
    TenCuaHang NVARCHAR(30),
    NgayThanhLap DATETIME,
    ImgUrl nvarchar(max),
	CONSTRAINT PK_CuaHang PRIMARY KEY (MaCuaHang),
)

-- Ma quan ly = QL + ma cua hang
create TABLE NguoiQuanLy
(
	MaQuanLy Char(8) not null constraint PK_NguoiQuanLy primary key,
	MaCuaHang char(6) not null,
	constraint FK_CuaHang FOREIGN key (MaCuaHang) REFERENCES CuaHang(MaCuaHang),
	TenQuanLy nvarchar(30),
	SoDienThoai varchar(12),
	TenNguoiDung varchar(20) UNIQUE,
	MatKhau varchar(30),
    DiaChi nvarchar(max),
    NgayThamGia DATETIME,
    ImgUrl nvarchar(max),
    GioiTinh nvarchar(4),
    NgaySinh datetime,
)

CREATE TABLE NhanVien
(
	MaNV CHAR(10) NOT NULL,
	MaCuaHang CHAR(6) NOT NULL,
	HoTen NVARCHAR(40),
	GioiTinh nVARCHAR(4),
	NgaySinh DATETIME,
	DiaChi nVARCHAR(max),
	Luong MONEY,
	SoDienThoai VARCHAR(12),
	NgayVaoLam DATETIME,
    TenNguoiDung VARCHAR(20) UNIQUE,
    MatKhau VARCHAR(30),
    ImgUrl nvarchar(max),
    MaQuanLy char(8) not null constraint FK_MaNhanVien_NguoiQuanLy FOREIGN key (MaQuanLy) REFERENCES NguoiQuanLy(MaQuanLy),
	CONSTRAINT PK_NHANVIEN PRIMARY KEY (MANV),
)

CREATE TABLE MonAn
(
	MaMonAn CHAR(10) NOT NULL,
	TenMonAn NVARCHAR(60),
	Gia MONEY,
	ImgUrl NVARCHAR(MAX),
	CONSTRAINT PK_MAMONAN PRIMARY KEY (MAMONAN),
    MaCuaHang char(6) not null CONSTRAINT FK_MaMonAn_CuaHang FOREIGN KEY (MaCuaHang) REFERENCES CuaHang(MaCuaHang),
)

CREATE TABLE BanAn
(
	MaBanAn CHAR(10) NOT NULL,
	Loai NVARCHAR(6),
    TrangThai NVARCHAR(10) DEFAULT N'Trống',
	CONSTRAINT PK_MABANAN PRIMARY KEY (MABANAN),
    TenBanAn NVARCHAR(20),
    MaCuaHang char(6) not null constraint FK_MaBanAn_CuaHang FOREIGN key (MaCuaHang) REFERENCES CuaHang(MaCuaHang),
)

CREATE TABLE NguoiDung
(
	HoTen NVARCHAR(40),
	SoDienThoai VARCHAR(12),
	CONSTRAINT PK_MANGUOIDUNG PRIMARY KEY (TenNguoiDung),
	TenNguoiDung VARCHAR(20) UNIQUE,
    MatKhau VARCHAR(30),
)

create table DonHang
(
	MaDonHang varchar(12) NOT NULL ,
	NgayLapDonHang DATETIME,
	TenNguoiDung VARCHAR(20) UNIQUE,
	TriGia MONEY,
	TieuDe NVARCHAR(50),
	GhiChu NVARCHAR(50),
	MaNV CHAR(10),
	CONSTRAINT PK_SoDonHang PRIMARY KEY (MaDonHang),
	CONSTRAINT FK_TenNguoiDung FOREIGN KEY (TenNguoiDung) REFERENCES NGUOIDUNG (TenNguoiDung),
	CONSTRAINT FK_MANV_DONHANG FOREIGN KEY (MaNV) REFERENCES NHANVIEN (MaNV),
)

CREATE TABLE ChiTietDonHang
(
	MaDonHang varchar(12) NOT NULL,
	MaMonAn CHAR(10) NOT NULL,
	SoLuong INT,
	CONSTRAINT PK_SoDonHang_MAMONAN PRIMARY KEY (MaDonHang,MaMonAn),
	CONSTRAINT FK_SoDonHang FOREIGN KEY (MaDonHang) REFERENCES DonHang (MaDonHang),
	CONSTRAINT FK_MAMONAN_ChiTietDonHang FOREIGN KEY (MaMonAn) REFERENCES MONAN (MaMonAn),
)

create table HoaDon
(
	MaHoaDon varchar(12) NOT NULL ,
	NgayLapHoaDon SMALLDATETIME,
	MaBanAn CHAR(10),
	TriGia MONEY ,
    TrangThai TINYINT,
    ThoiGianThanhToan datetime,
	CONSTRAINT PK_maHoaDon PRIMARY KEY (MaHoaDon),
	CONSTRAINT FK_MABANAN FOREIGN KEY (MaBanAn) REFERENCES BANAN (MaBanAn),
)

CREATE TABLE ChiTietHoaDon
(
	MaHoaDon varchar(12) NOT NULL,
	MaMonAn CHAR(10) NOT NULL,
	SoLuong INT,
	CONSTRAINT PK_maHoaDon_MAMONAN PRIMARY KEY (MaHoaDon,MaMonAn),
	CONSTRAINT FK_maHoaDon FOREIGN KEY (MaHoaDon) REFERENCES HOADON (MaHoaDon),
	CONSTRAINT FK_MAMONAN FOREIGN KEY (MaMonAn) REFERENCES MONAN (MaMonAn),
)

CREATE TABLE ChiTietDatBan (
	MaDatBan char(10) not null constraint PK_ChiTietDatBan PRIMARY KEY,
	MaBanAn char(10),
	NguoiDat nvarchar(30),
	SoDienThoai varchar(12),
	GhiChu nvarchar(200),
	TrangThai tinyint,
	NgayDat datetime,
	constraint FK_ChiTietDatBan_MaBan FOREIGN KEY (MaBanAn) REFERENCES BanAn(MaBanAn)
)

SELECT * from CuaHang
SELECT * from NguoiQuanLy
SELECT * from NhanVien
SELECT * from BanAn
SELECT * from MonAn
SELECT * from HoaDon
SELECT * from ChiTietHoaDon
SELECT * from ChiTietDatBan
