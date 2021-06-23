/*
    Sp ini berfungsi untuk mencari article pada database dengan parameter nama penulis, pencarian article 
    ini dapat dimasukan arguments lebih dari satu dengan cara memberi ";" (titik koma) pada setiap keyword 
        misalnya : EXEC FindArticleByAuthor 'a;i;'
    Sp ini pertama-tama akan memisahkan semua keyword kedalam table, dan akan membuka cursor untuk looping
    keyword tersebut dan diselect, setelah semua nama penulis terkumpul maka akan dilakukan join terhadap artikel
    dan kategori setelah itu akan dibuka sebuah cursor untuk concat kategori pada article yang berulang, dan
    pada akhirnya akan direturn data article
*/
DROP PROCEDURE IF EXISTS [FindArticleByAuthor]

ALTER PROCEDURE FindArticleByAuthor
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
DECLARE @tempResult TABLE(
	idArtikel int, 
	berbayar bit,
	[status] tinyint, 
	judul varchar(255),
	tanggalUnggah DATETIME,
	tanggalValidasi DATETIME,
	tanggalHapus DATETIME,
	idAdmin int, 
	idMember int,
	idKategori varchar(255), 
	kategori varchar(255),
	nama varchar(255)
)
DECLARE @resultMergeCategory TABLE(
	idArtikel int, 
	berbayar bit,
	[status] tinyint, 
	judul varchar(255),
	tanggalUnggah DATETIME,
	tanggalValidasi DATETIME,
	tanggalHapus DATETIME,
	idAdmin int, 
	idMember int,
	idKategori varchar(255), 
	kategori varchar(255),
	nama varchar(255)
)
DECLARE @keywordTable TABLE (
	keyword varchar(100)
)
INSERT INTO @keywordTable
SELECT *
FROM MultiValueSearch(@keyword)
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
INSERT INTO @tempResult
SELECT himp2.*, author.nama
FROM @resultAuthor AS [author] INNER JOIN (
	SELECT himp.idArtikel, himp.berbayar, himp.status, himp.judul, himp.tanggalUnggah, himp.tanggalValidasi, himp.tanggalHapus, himp.idAdmin, himp.idMember, kategori.idKategori, kategori.kategori
	FROM Kategori INNER JOIN (
		SELECT article.idArtikel, article.berbayar, article.status, article.judul, article.tanggalUnggah, article.tanggalValidasi, article.tanggalHapus, article.idAdmin, article.idMember, Berkategori.idKategori
		FROM Artikel AS [article] INNER JOIN Berkategori on article.idArtikel = Berkategori.idArtikel) AS [himp]
		on kategori.idKategori =  himp.idKategori) AS [himp2]
	on author.idMember =  himp2.idMember
WHERE himp2.tanggalHapus IS NULL
ORDER BY idArtikel
DECLARE curMerge CURSOR
FOR
	SELECT *
	FROM @tempResult
	ORDER BY idArtikel
OPEN curMerge
	DECLARE
		@prevIdArtikel int,
		@prevBerbayar bit,
		@prevStatus tinyint, 
		@prevJudul varchar(255),
		@prevTanggalUnggah DATETIME,
		@prevTanggalValidasi DATETIME,
		@prevTanggalHapus DATETIME,
		@prevIdAdmin int, 
		@prevIdMember int,
		@prevIdKategori varchar(255), 
		@prevKategori varchar(255),
		@prevNama varchar(255),
		@idArtikel int, 
		@berbayar bit,
		@status tinyint, 
		@judulArtikel varchar(255),
		@tanggalUnggah DATETIME,
		@tanggalValidasi DATETIME,
		@tanggalHapus DATETIME,
		@idAdmin int, 
		@idMember int,
		@idKategori varchar(255), 
		@kategori varchar(255),
		@nama varchar(255)
FETCH NEXT FROM curMerge INTO @prevIdArtikel, @prevBerbayar, @prevStatus, @prevJudul, @prevTanggalUnggah, @prevTanggalValidasi, @prevTanggalHapus, @prevIdAdmin, @prevIdMember, @prevIdKategori, @prevKategori, @prevNama
WHILE @@FETCH_STATUS = 0
	BEGIN
		FETCH NEXT FROM curMerge INTO @idArtikel, @berbayar, @status, @judulArtikel, @tanggalUnggah, @tanggalValidasi, @tanggalHapus, @idAdmin, @idMember, @idKategori, @kategori, @nama
		IF @@FETCH_STATUS <> 0
			BEGIN
				break
			END
		IF @prevIdArtikel = @idArtikel
			BEGIN
				SET @prevIdKategori =  CONCAT(@prevIdKategori, ', ', @idKategori)
				SET @prevKategori =  CONCAT(@prevKategori, ', ', @kategori)
			END
		ELSE
			BEGIN
				INSERT INTO @resultMergeCategory
				SELECT @prevIdArtikel, @prevBerbayar, @prevStatus, @prevJudul, @prevTanggalUnggah, @prevTanggalValidasi, @prevTanggalHapus, @prevIdAdmin, @prevIdMember, @prevIdKategori, @prevKategori, @prevNama
				SET @prevIdArtikel = @idArtikel
				SET @prevBerbayar =  @berbayar
				SET @prevStatus = @status
				SET @prevJudul =  @judulArtikel
				SET @prevTanggalUnggah = @tanggalUnggah
				SET @prevTanggalValidasi = @tanggalValidasi
				SET @prevTanggalHapus = @tanggalHapus
				SET @prevIdAdmin = @idAdmin
				SET @prevIdMember = @idMember
				SET @prevIdKategori =  @idKategori
				SET @prevKategori = @kategori
				SET @prevnama = @nama
			END
	END
INSERT INTO @resultMergeCategory
SELECT @prevIdArtikel, @prevBerbayar, @prevStatus, @prevJudul, @prevTanggalUnggah, @prevTanggalValidasi, @prevTanggalHapus, @prevIdAdmin, @prevIdMember, @prevIdKategori, @prevKategori, @prevNama
CLOSE curMerge
DEALLOCATE curMerge
SELECT *
FROM @resultMergeCategory
GO

EXEC FindArticleByAuthor 'a;i;'