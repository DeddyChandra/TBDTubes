/*
    Sp ini berfungsi untuk memasukan record ke dalam database, dengan menerima 5 buah parameter
*/
DROP PROCEDURE IF EXISTS [RegisterMember]

CREATE PROCEDURE RegisterMember
	@nama varchar(255),
	@email varchar(255),
	@kontak varchar(255),
	@alamat varchar(255),
	@password varchar(255)
AS
INSERT INTO master.dbo.Member (nama,email,kontak,terverifikasi,alamat,password,statusLangganan)
VALUES(@nama, @email, @kontak, 0, @alamat, @password, 0)
GO

EXEC RegisterMember 'Deddy Chandra', '6181801007@student.unpar.ac.id', '08123456789', 'jalan blablabla', 'asdqwe123'