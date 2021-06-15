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
WHERE idMember =  @idMember
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
/* Ini harus perhatiin apakah recordnya udah benar mencakup pada EXECnya , jika belum dibikin sendiri saja ya :D*/


--6
DROP PROCEDURE IF EXISTS [FindArticleByTitle]
CREATE PROCEDURE FindArticleByTitle
	@keyword varchar(255)
AS
DECLARE @resultArticle TABLE(
	idArtikel int,
	berbayar bit,
	[status] tinyint,
	judul varchar(255),
	tanggalUnggah datetime,
	tanggalValidasi datetime,
	tanggalHapus datetime,
	idAdmin int
)
DECLARE @keywordTable TABLE (
	keyword varchar(100)
)
INSERT INTO @keywordTable
SELECT *
FROM MultiValueSearch(@keyword)

DECLARE 
	@i int
SET @i = 0

DECLARE curArtikel CURSOR
FOR
	SELECT *
	FROM @keywordTable
OPEN curArtikel
	DECLARE
		@judul varchar(100)
FETCH NEXT FROM curArtikel INTO @judul
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @resultArticle (idArtikel, berbayar, [status], judul, tanggalUnggah, tanggalValidasi, tanggalHapus, idAdmin)
		SELECT DISTINCT(idArtikel), berbayar, [status], judul, tanggalUnggah, tanggalValidasi, tanggalHapus, idAdmin
		FROM master.dbo.Artikel
		WHERE judul LIKE '%'+@judul+'%'
		FETCH NEXT FROM curArtikel INTO @judul
	END
CLOSE curArtikel
DEALLOCATE curArtikel

SELECT *
FROM Kategori INNER JOIN (SELECT article.idArtikel, article.berbayar, article.status, article.judul, article.tanggalUnggah, article.tanggalValidasi, article.tanggalHapus, article.idAdmin, Berkategori.idKategori
FROM @resultArticle AS [article] INNER JOIN Berkategori on article.idArtikel = Berkategori.idArtikel) AS [himp] on kategori.idKategori =  himp.idKategori
WHERE himp.tanggalHapus IS NULL
ORDER BY idArtikel
GO
EXEC FindArticleByTitle 'at;heme;'


--7
DROP PROCEDURE IF EXISTS [FindArticleByCategory]
CREATE PROCEDURE FindArticleByCategory
	@keyword varchar(255)
AS
DECLARE @resultCategory TABLE(
	idKategori int,
	kategori varchar(255)
)
DECLARE @keywordTable TABLE (
	keyword varchar(100)
)
INSERT INTO @keywordTable
SELECT *
FROM MultiValueSearch(@keyword)

DECLARE 
	@i int
SET @i = 0

DECLARE curKategori CURSOR
FOR
	SELECT *
	FROM @keywordTable
OPEN curKategori
	DECLARE
		@judul varchar(100)
FETCH NEXT FROM curKategori INTO @judul
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @resultCategory (idKategori, kategori)
		SELECT DISTINCT(idKategori), kategori
		FROM master.dbo.Kategori
		WHERE kategori LIKE '%'+@judul+'%'
		FETCH NEXT FROM curKategori INTO @judul
	END
CLOSE curKategori
DEALLOCATE curKategori

SELECT himp.idArtikel, himp.berbayar, himp.status, himp.judul, himp.tanggalUnggah, himp.tanggalValidasi, himp.tanggalHapus, himp.idAdmin, category.idKategori, category.kategori
FROM @resultCategory AS [category] INNER JOIN (SELECT article.idArtikel, article.berbayar, article.status, article.judul, article.tanggalUnggah, article.tanggalValidasi, article.tanggalHapus, article.idAdmin, Berkategori.idKategori
FROM Artikel AS [article] INNER JOIN Berkategori on article.idArtikel = Berkategori.idArtikel) AS [himp] on category.idKategori =  himp.idKategori
WHERE himp.tanggalHapus IS NULL
ORDER BY idArtikel
GO
EXEC FindArticleByCategory'akuntansi;fisika;'


--8
DROP PROCEDURE IF EXISTS [FindArticleByAuthor]
/* password ga akan di select */
CREATE PROCEDURE FindArticleByAuthor
	@keyword varchar(255)
AS
DECLARE @resultAuthor TABLE(
	idMember int,
	nama varchar(255),
	email varchar(255),
	kontak varchar(12),
	terverifikasi bit,
	alamat varchar(255),
	[password] varchar(255),
	statusLangganan bit
)
DECLARE @keywordTable TABLE (
	keyword varchar(100)
)
INSERT INTO @keywordTable
SELECT *
FROM MultiValueSearch(@keyword)

DECLARE 
	@i int
SET @i = 0

DECLARE curAuthor CURSOR
FOR
	SELECT *
	FROM @keywordTable
OPEN curAuthor
	DECLARE
		@judul varchar(100)
FETCH NEXT FROM curAuthor INTO @judul
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @resultAuthor (idMember, nama, email, kontak, terverifikasi, alamat, statusLangganan)
		SELECT DISTINCT(idMember), nama, email, kontak, terverifikasi, alamat, statusLangganan
		FROM master.dbo.Member
		WHERE nama LIKE '%'+@judul+'%'
		FETCH NEXT FROM curAuthor INTO @judul
	END
CLOSE curAuthor
DEALLOCATE curAuthor

SELECT *
FROM Member INNER JOIN (
	SELECT himp.idArtikel, himp.berbayar, himp.status, himp.judul, himp.tanggalUnggah, himp.tanggalValidasi, himp.tanggalHapus, himp.idAdmin, himp.idMember, kategori.idKategori, kategori.kategori
	FROM Kategori INNER JOIN (
		SELECT article.idArtikel, article.berbayar, article.status, article.judul, article.tanggalUnggah, article.tanggalValidasi, article.tanggalHapus, article.idAdmin, article.idMember, Berkategori.idKategori
		FROM Artikel AS [article] INNER JOIN Berkategori on article.idArtikel = Berkategori.idArtikel) AS [himp]
		on kategori.idKategori =  himp.idKategori) AS [himp2]
	on Member.idMember =  himp2.idMember
WHERE himp2.tanggalHapus IS NULL
ORDER BY idArtikel
GO
EXEC FindArticleByAuthor'i;'


--9
DROP PROCEDURE IF EXISTS [CategoryOfInterest]
CREATE PROCEDURE CategoryOfInterest
	@idMember int
AS 
DECLARE @resultArticle TABLE(
	idArtikel int,
	duration int
)
DECLARE curInterest CURSOR
FOR
	SELECT idArtikel, waktu
	FROM Membaca
	WHERE idMember =  @idMember
	ORDER BY idArtikel, waktu
OPEN curInterest
	DECLARE
		@idArtikel int,
		@waktu datetime,
		@duration datetime,
		@prevTime datetime,
		@prevIdArtikel datetime,
		@count bit
	SET @count = 0
FETCH NEXT FROM curInterest INTO @idArtikel, @waktu
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @count = 0
			BEGIN
				SET @prevTime =  @waktu
				SET @prevIdArtikel =  @idArtikel
				SET @count = 1
			END
		ELSE IF @count = 1
			BEGIN
				IF @prevIdArtikel =  @idArtikel
					INSERT INTO @resultArticle
					SELECT @idArtikel, DATEDIFF(minute, @prevTime, @waktu)
					SET @count = 0
			END
		FETCH NEXT FROM curInterest INTO @idArtikel, @waktu
	END
CLOSE curInterest
DEALLOCATE curInterest

SELECT himp.idKategori, kategori, SUM(duration) AS duration
FROM Kategori INNER JOIN (
	SELECT article.idArtikel, article.duration, Berkategori.idKategori
	FROM @resultArticle AS [article] INNER JOIN Berkategori on article.idArtikel = Berkategori.idArtikel) AS [himp]
	on himp.idKategori =  kategori.idKategori
	GROUP BY himp.idKategori, kategori
	ORDER BY duration
GO
EXEC CategoryOfInterest 3


--10
DROP PROCEDURE IF EXISTS [TopArticle]
CREATE PROCEDURE TopArticle
AS
DECLARE @resultArticle TABLE(
	idArtikel int,
	duration int
)
DECLARE curInterest CURSOR
FOR
	SELECT idMember, idArtikel, waktu, status
	FROM Membaca
	ORDER BY idMember, idArtikel, waktu
OPEN curInterest
	DECLARE
		@idMember int,
		@idArtikel int,
		@waktu datetime,
		@judul varchar(255),
		@status varchar(255),
		@duration datetime,
		@prevIdMember int,
		@prevWaktu datetime,
		@prevIdArtikel datetime,
		@prevStatus varchar(255),
		@belumSelesai bit
	SET @belumSelesai = 0
	/*kalao tablenya ada pasangan selesai maka = 0 kalao tablenya ga ada pasangan selesai maka 1*/
FETCH NEXT FROM curInterest INTO @prevIdMember, @previdArtikel, @prevWaktu, @prevStatus
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @prevStatus =  'mulai'
			BEGIN
				FETCH NEXT FROM curInterest INTO @idMember, @idArtikel, @waktu, @status
				IF @status = 'selesai' AND @idMember = @prevIdMember AND @idArtikel = @prevIdArtikel
					BEGIN
						INSERT INTO @resultArticle
						SELECT @idArtikel, DATEDIFF(MINUTE, @prevWaktu, @waktu)
						FETCH NEXT FROM curInterest INTO @prevIdMember, @previdArtikel, @prevWaktu, @prevStatus
					END
				ELSE
					/* ini kalau dia dapatnya mulai ga dpt selesai */
					BEGIN
						SET @prevIdMember = @idMember
						SET @prevIdArtikel = @idArtikel
						SET @prevWaktu =  @waktu
						SET @prevStatus = @status
					END
			END
	END
CLOSE curInterest
DEALLOCATE curInterest

SELECT Artikel.idArtikel, judul, duration
FROM Artikel INNER JOIN
	(SELECT article.idArtikel, SUM(article.duration) AS [duration]
	FROM @resultArticle as [article]
	GROUP BY article.idArtikel) as [himp]
	on Artikel.idArtikel = himp.idArtikel
	ORDER BY duration DESC
GO
EXEC TopArticle 

SELECT idMember, idArtikel, waktu, status
	FROM Membaca
	ORDER BY waktu

--11
DROP PROCEDURE IF EXISTS [ChangePrice]
CREATE PROCEDURE ChangePrice
	@harga int,
	@idAdmin int
AS
INSERT INTO Harga (harga, waktuBerlaku, idAdmin)
SELECT @harga, GETDATE(), @idAdmin
GO
EXEC ChangePrice 10000, 1


--12
--status artikel : 0 ditolak, 1 : diterima, 2 : dihapus, 3 : pending
DROP PROCEDURE IF EXISTS [UpdateArtikelStatus]
CREATE PROCEDURE UpdateArtikelStatus
	@idArtikel int,
	@status bit,
	@idAdmin int
AS
UPDATE Artikel
SET [status] = @status, idAdmin = @idAdmin
WHERE idArtikel = @idArtikel
GO
EXEC ValidateArtikel 1, 0, 3


--13
DROP PROCEDURE IF EXISTS [ScanTransaction]
CREATE PROCEDURE ScanTransaction
AS
SELECT idLangganan, DATEADD(day,-durasi,waktuSelesai) AS [waktuMulai], waktuSelesai, idMember, idHarga
FROM Langganan
GO
EXEC ScanTransaction

--14
DROP PROCEDURE IF EXISTS [UploadArticle]

ALTER PROCEDURE UploadArticle
@judul varchar(100),
@idMember int,
@kategori varchar(255),--kategori number
@berbayar BIT
AS

INSERT INTO Artikel(judul,[status],tanggalUnggah,berbayar,idMember)
SELECT @judul,0,CURRENT_TIMESTAMP,@berbayar,@idMember


DECLARE @idcur int
SELECT @idcur =MAX(idArtikel) FROM Artikel

DECLARE cursorKategori CURSOR FOR
SELECT keyword FROM MultiValueSearch(@kategori)
	
OPEN cursorKategori

DECLARE @curnum varchar(255)


FETCH NEXT FROM cursorKategori INTO @curnum
WHILE @@FETCH_STATUS=0
BEGIN
	INSERT INTO Berkategori(idArtikel,idKategori)
	SELECT @idcur,CONVERT(INT,@curnum)
	FETCH NEXT FROM cursorKategori INTO @curnum
END


CLOSE cursorKategori
DEALLOCATE cursorKategori

--EXEC UploadArticle 'deddoy carry the game',1,'1;2;',1


--15
DROP PROCEDURE IF EXISTS [Subscribe]

CREATE PROCEDURE Subscribe
@idMember int
AS
DECLARE @maxi int;
SELECT @maxi = MAX(idHarga) FROM Harga
INSERT INTO LANGANAN(durasi,idMember,waktuSelesai,idHarga)
SELECT 30,@idMember,CURRENT_TIMESTAMP,@maxi
