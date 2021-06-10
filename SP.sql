-- 1
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


-- 2
DROP PROCEDURE IF EXISTS [EmailVerification]
CREATE PROCEDURE EmailVerification
	@idMember int
AS
UPDATE master.dbo.Member 
SET terverifikasi = 1
GO
EXEC EmailVerification 1


--3
DROP PROCEDURE IF EXISTS [FindMember]
CREATE PROCEDURE FindMember
	@email varchar(255),
	@password varchar(255)
AS
DECLARE
	@result bit
SET @result = 0
IF((SELECT COUNT(idMember) FROM master.dbo.Member WHERE email = @email AND password = @password) = 1)
	BEGIN
		SET @result = 1
	END
SELECT @result
GO
EXEC FindMember 'Joni@gmail.com', 'joni134'
EXEC FindMember 'Joni@gmail.coma', 'joni134' -- case salah email
EXEC FindMember 'Joni@gmail.com', 'joni134a' -- case salah password
EXEC FindMember 'Joni@gmail.coma', 'joni134a' -- case salah email & salah password


--4
DROP PROCEDURE IF EXISTS [Admin]
CREATE PROCEDURE FindAdmin
	@email varchar(255),
	@password varchar(255)
AS
DECLARE
	@result bit
SET @result = 0
IF((SELECT COUNT(idAdmin) FROM master.dbo.Admin WHERE email = @email AND password = @password) = 1)
	BEGIN
		SET @result = 1
	END
SELECT @result
GO
EXEC FindAdmin 'Bob@gmail.com', 'bobi23'
EXEC FindAdmin 'Bob@gmail.coma', 'bobi23' -- case salah email
EXEC FindAdmin 'Bob@gmail.com', 'bobi23a' -- case salah password
EXEC FindAdmin 'Bob@gmail.coma', 'bobi23a' -- case salah email & salah password


--5
DROP PROCEDURE IF EXISTS [OpenArticle]
CREATE PROCEDURE OpenArticle
	@idArtikel int,
	@idMember int
AS
DECLARE
	@artikelBerbayar bit,
	@memberLangganan bit,
	@result bit
SET @result = 1
SET @artikelBerbayar = 1
SET @memberLangganan = 1
IF((SELECT berbayar FROM master.dbo.Artikel WHERE idArtikel = @idArtikel) = 0)
	BEGIN
		SET @artikelBerbayar = 0
	END
IF((SELECT statusLangganan FROM master.dbo.Member WHERE idMember = @idMember) = 0)
	BEGIN
		SET @memberLangganan = 0
	END
IF(@artikelBerbayar = 1)
	BEGIN
		IF(@memberLangganan = 0)
			BEGIN
				SET @result = 0
			END
	END
SELECT @result AS [result]
GO
EXEC OpenArticle 1, 1
EXEC OpenArticle 1, 2
EXEC OpenArticle 2, 1
EXEC OpenArticle 2, 2

