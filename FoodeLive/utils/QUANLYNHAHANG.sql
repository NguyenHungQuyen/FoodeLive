create DATABASE QuanLyNhaHang

CREATE TABLE NhanVien
(
	MaNV CHAR(4) NOT NULL,
	HoTen NVARCHAR(40),
	GioiTinh VARCHAR(10),
	NgaySinh SMALLDATETIME,
	DiaChi VARCHAR(50),
	Luong MONEY,
	SoDienThoai VARCHAR(20),
	NgayVaoLam SMALLDATETIME,
    TenNguoiDung VARCHAR(20) UNIQUE,
    MatKhau VARCHAR(30),
	CONSTRAINT PK_NHANVIEN PRIMARY KEY (MANV),
)


CREATE TABLE MonAn
(
	MaMonAn CHAR(4) NOT NULL,
	TenMonAn NVARCHAR(40),
	Gia MONEY,
	ImgExtension VARCHAR(5),
	CONSTRAINT PK_MAMONAN PRIMARY KEY (MAMONAN),
)

CREATE TABLE BanAn
(
	MaBanAn CHAR(4) NOT NULL,
	Loai NVARCHAR(6),
    TrangThai NVARCHAR(10) DEFAULT N'Trống',
	CONSTRAINT PK_MABANAN PRIMARY KEY (MABANAN),
)


create table HoaDon
(
	SoHoaDon int NOT NULL ,
	NgayLapHoaDon SMALLDATETIME,
	MaBanAn CHAR(4),
	MaNV CHAR(4),
	TriGia MONEY ,
	CONSTRAINT PK_SoHoaDon PRIMARY KEY (SoHoaDon),
	CONSTRAINT FK_MABANAN FOREIGN KEY (MaBanAn) REFERENCES BANAN (MaBanAn),
	CONSTRAINT FK_MANV FOREIGN KEY (MaNV) REFERENCES NHANVIEN (MaNV),
)

CREATE TABLE ChiTietHoaDon
(
	SoHoaDon INT NOT NULL,
	MaMonAn CHAR(4) NOT NULL,
	SoLuong INT,
	CONSTRAINT PK_SoHoaDon_MAMONAN PRIMARY KEY (SoHoaDon,MaMonAn),
	CONSTRAINT FK_SoHoaDon FOREIGN KEY (SoHoaDon) REFERENCES HOADON (SoHoaDon),
	CONSTRAINT FK_MAMONAN FOREIGN KEY (MaMonAn) REFERENCES MONAN (MaMonAn),
)

/*Giá bán của sản phẩm từ 0 đồng trở lên*/
ALTER TABLE MONAN
ADD CONSTRAINT GIA_CHECK CHECK(GIA>0)

ALTER TABLE NHANVIEN ADD CONSTRAINT ngayvaolam_CHECK CHECK(NgayVaoLam>NGaySINH)

ALTER TABLE ChiTietHoaDon ADD CONSTRAINT SoLuong_CHECK CHECK(SoLuong>=1)

CREATE TRIGGER ngaylaphoadon_ngayvaolam_hoad_insert
ON hoadon 
AFTER INSERT 
AS 
	DECLARE @ng_hoadon smalldatetime 
	DECLARE @ng_vaolam smalldatetime 
	SELECT @ng_hoadon=NgayLapHoaDon, @ng_vaolam=NgayVaoLam
	FROM NHANVIEN, inserted
	WHERE NHANVIEN.MANV=inserted.MANV
IF @ng_hoadon< @ng_vaolam
BEGIN
	rollback transaction
	print N'Ngày hóa đơn phải lớn hơn ngày vào làm'
END

CREATE TRIGGER ngaylaphoadon_ngayvaolam_hoad_update
ON hoadon 
AFTER UPDATE
AS 
IF (UPDATE (manv) OR UPDATE (ngaylaphoadon))
BEGIN
	DECLARE @ng_hoadon smalldatetime 
	DECLARE @ng_vaolam smalldatetime 
	SELECT @ng_hoadon=ngaylaphoadon, @ng_vaolam=ngayvaolam
	FROM NHANVIEN, inserted
	WHERE NHANVIEN.MANV=inserted.MANV
	IF @ng_hoadon< @ng_vaolam
	BEGIN
		rollback transaction
		print  N'Ngày hóa đơn phải lớn hơn ngày vào làm'
	END
END

CREATE TRIGGER ngaylaphoadon_ngayvaolam_nhanvien_update
ON nhanvien
AFTER UPDATE
AS 
	DECLARE @ng_vaolam smalldatetime, @manhvien char(4)
	SELECT @ng_vaolam=ngayvaolam, @manhvien=manv
	FROM inserted
IF (UPDATE (ngayvaolam))
BEGIN
	IF (EXISTS (SELECT * 
	FROM hoadon 
	WHERE manv=@manhvien AND @ng_vaolam>ngaylaphoadon))
	BEGIN
		rollback transaction
	print N' Thao tác sửa ngày vào làm phải nhỏ hơnn gày hóa đơn'
END
END


CREATE TRIGGER trg_del_ChiTietHoaDon ON ChiTietHoaDon
FOR Delete
AS
BEGIN
	IF ((SELECT COUNT(*) FROM deleted WHERE SoHoaDon = deleted.SoHoaDon)
		= (SELECT COUNT(*) FROM HoaDon, deleted WHERE deleted.SoHoaDon = HoaDon.SoHoaDon))
	BEGIN
		PRINT N'Error: Mỗi một hóa đơn phải có ít nhất một chi tiết hóa đơn'
		ROLLBACK TRANSACTION
	END
END



/*Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
*/

CREATE TRIGGER trigia_hoad_insert
ON hoadon 
AFTER INSERT 
AS 
	DECLARE @trigia_hoadon money 
	DECLARE @SoLuong_ChiTietHoaDon int
	DECLARE @gia_monan money
	SELECT @trigia_hoadon=TRIGIA, @SoLuong_ChiTietHoaDon=SoLuong,@gia_monan=GIA
	FROM ChiTietHoaDon, MONAN,inserted
	WHERE ChiTietHoaDon.MAMONAN=MONAN.MAMONAN AND ChiTietHoaDon.SoHoaDon=inserted.SoHoaDon
IF @trigia_hoadon!= SUM(@SoLuong_ChiTietHoaDon*@gia_monan)
BEGIN
	rollback transaction
	print N'Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.'
END;



INSERT INTO MONAN(MAMONAN,TENMONAN,GIA) VALUES ('M01',N'Súp cá hồi',50000)
INSERT INTO MONAN(MAMONAN,TENMONAN,GIA) VALUES ('M02',N'Rau bí xào',26000)
INSERT INTO MONAN(MAMONAN,TENMONAN,GIA) VALUES ('M03',N'Nộm rau má',26500)
INSERT INTO MONAN(MAMONAN,TENMONAN,GIA) VALUES ('M04',N'Khoai tây chiên',30000)
INSERT INTO MONAN(MAMONAN,TENMONAN,GIA) VALUES ('M05',N'Bánh bao chiên',30500)
