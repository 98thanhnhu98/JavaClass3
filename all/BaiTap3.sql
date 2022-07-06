CREATE DATABASE BAITAP3
GO

USE BAITAP3
GO

create table GiayTo(
ID_GiayTo char(20) primary key,
NgayCap date,
NgayHetHan date
)
insert into GiayTo values('CCCD2139912','2015/03/06','2025/03/06')
insert into GiayTo values('HC21421914','2013/03/06','2028/06/06')
insert into GiayTo values('CMT21412122','2018/03/06','2028/09/06')
insert into GiayTo values('CCCD2163212','2012/03/06','2022/01/06')

create table InNguoiXNC(
ID_NXNC int primary key,
Name char(15),
NgaySinh date,
QuocTich char(15),
GioiTinh char(5),
DiaChi char(20),
ID_GiayTo char(20)
constraint fk_InNguoiXNC_GiayTo foreign key (ID_GiayTo) REFERENCES GiayTo (ID_GiayTo)
)
insert into InNguoiXNC values(123,'Quan','2003/08/21','Viet Nam','Nam','Ha Long,Quang Ninh','CCCD2139912')
insert into InNguoiXNC values(124,'July','1996/05/20','American','Nam','New Mexico','HC21421914')
insert into InNguoiXNC values(125,'Tuan Anh','1998/07/22','Viet Nam','Nam','Quang Binh','CMT21412122')
insert into InNguoiXNC values(126,'Linh','2000/06/23','Viet Nam','Nu','Quang Tri','CCCD2163212')

Create table GiayMoi(
ID_GiayMoi int primary key,
NgayCap date,
NgayHetHan date
)
insert into GiayMoi values(312412,'2020/03/20','2022/03/20')

Create table Visa(
ID_Visa int primary key,
NgayCap date,
NgayHetHan date
)

insert into GiayMoi values(81238,'2019/03/20','2022/03/20')
insert into GiayMoi values(12422,'2019/06/20','2022/06/20')
insert into GiayMoi values(92748,'2019/09/20','2022/09/20')

Create table ThuTuc(
ID_ThuTuc int primary key,
Time_XNC date,
Reason char(30),
NoiDen Char(20),
ID_Visa int,
ID_GiayMoi int,
NgayCap date,
NgayHetHan date,
ID_NXNC int,
Filter char(20)
constraint fk_ThuTuc_InNguoiXNC foreign key (ID_NXNC) REFERENCES InNguoiXNC (ID_NXNC),
constraint fk_ThuTuc_ID_Visa foreign key (ID_Visa) REFERENCES Visa (ID_Visa),
constraint fk_ThuTuc_ID_GiayMoi foreign key (ID_GiayMoi) REFERENCES GiayMoi (ID_GiayMoi)
)
drop table ThuTuc


insert into ThuTuc values(1,'2020/10/08','Du Lich','TP HoChiMinh',null,81238,'2020/10/07','2020/10/09',123,'XuatCanh')
insert into ThuTuc values(2,'2020/10/08','Ve Que','TP HoChiMinh',null,12422,'2020/10/07','2020/10/09',124,'NhapCanh')
insert into ThuTuc values(3,'2020/10/08','Du Lich','Thanh Hoa',null,92748,'2020/10/07','2020/10/09',125,'Xuatanh')
insert into ThuTuc values(4,'2020/10/08','Du Lich','Ha Noi',312412,null,'2020/10/07','2020/10/09',126,'XuatCanh')

--cau 1 Tính số người nhập cảnh trong ngày
select Count(Reason),GETDATE() From ThuTuc
where ThuTuc.Filter = 'Xuat Canh'

--cau 2 Tính số người xuất cảnh trong ngày
select Count(Reason),GETDATE() From ThuTuc
where ThuTuc.Filter = 'Nhap Canh'

--cau 3 Liệt kê số người xuất cảnh dùng hộ chiếu
select * from InNguoiXNC
where InNguoiXNC.ID_GiayTo like 'HC%'

--cau 4 Liệt kê số người nhập cảnh dùng visa
select InNguoiXNC.ID_NXNC,Name,NgaySinh,QuocTich,GioiTinh,DiaChi,ID_GiayTo from InNguoiXNC
join ThuTuc on InNguoiXNC.ID_NXNC = ThuTuc.ID_NXNC
where ThuTuc.ID_Visa is not null

--cau 5 Đếm số người sử dụng XNC theo các loại giấy tờ
select count(ID_NXNC) as "so luong" from InNguoiXNC
where InNguoiXNC.ID_GiayTo is not null

--cau 6 Đếm số người sử dụng XNC theo các loại thông tin giấy tờ cho phép xuất cảnh hoặc nhập cảnh
select count(InNguoiXNC.ID_NXNC) as "so luong" from InNguoiXNC
join ThuTuc on InNguoiXNC.ID_NXNC = ThuTuc.ID_NXNC
where ThuTuc.ID_Visa is not null or ThuTuc.ID_GiayMoi is not null

--cau 7 Liệt kê những người nhập cảnh và quốc tịch VN
select InNguoiXNC.ID_NXNC,Name,NgaySinh,QuocTich,GioiTinh,DiaChi,ID_GiayTo from InNguoiXNC
join ThuTuc on InNguoiXNC.ID_NXNC = ThuTuc.ID_NXNC
where InNguoiXNC.QuocTich = 'Viet Nam' and ThuTuc.Filter = 'Nhap Canh'

--cau 8 Liệt kê những người là nam, xuất cảnh với mục đích du lịch 
select InNguoiXNC.ID_NXNC,Name,NgaySinh,QuocTich,GioiTinh,DiaChi,ID_GiayTo from InNguoiXNC
join ThuTuc on InNguoiXNC.ID_NXNC = ThuTuc.ID_NXNC
where ThuTuc.Reason like 'Du Lich' and InNguoiXNC.GioiTinh like 'Nam'