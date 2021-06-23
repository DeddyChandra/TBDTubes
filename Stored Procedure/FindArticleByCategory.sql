/*
    Sp ini berfungsi untuk mencari article pada database dengan parameter kategori, pencarian article 
    ini dapat dimasukan arguments lebih dari satu dengan cara memberi ";" (titik koma) pada setiap keyword 
        misalnya : EXEC FindArticleByCategory 'akuntansi;fisika;matematika;'
    Sp ini pertama-tama akan memisahkan semua keyword kedalam table, dan akan membuka cursor untuk looping
    keyword tersebut dan diselect, setelah semua kategori terkumpul maka akan dilakukan join terhadap artikel
    setelah itu akan dibuka sebuah cursor untuk concat kategori pada article yang berulang, dan pada akhirnya
    akan direturn data article
*/
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
	kategori varchar(255)
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
	kategori varchar(255)
)
INSERT INTO @keywordTable
SELECT *
FROM MultiValueSearch(@keyword)
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
INSERT INTO @tempResult
SELECT himp.idArtikel, himp.berbayar, himp.status, himp.judul, himp.tanggalUnggah, himp.tanggalValidasi, himp.tanggalHapus, himp.idAdmin, himp.idMember, category.idKategori, category.kategori
FROM @resultCategory AS [category] INNER JOIN (SELECT article.idArtikel, article.berbayar, article.status, article.judul, article.tanggalUnggah, article.tanggalValidasi, article.tanggalHapus, article.idAdmin, article.idMember, Berkategori.idKategori
FROM Artikel AS [article] INNER JOIN Berkategori on article.idArtikel = Berkategori.idArtikel) AS [himp] on category.idKategori =  himp.idKategori
WHERE himp.tanggalHapus IS NULL
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
		@kategori varchar(255)
FETCH NEXT FROM curMerge INTO @prevIdArtikel, @prevBerbayar, @prevStatus, @prevJudul, @prevTanggalUnggah, @prevTanggalValidasi, @prevTanggalHapus, @prevIdAdmin, @prevIdMember, @prevIdKategori, @prevKategori
WHILE @@FETCH_STATUS = 0
	BEGIN
		FETCH NEXT FROM curMerge INTO @idArtikel, @berbayar, @status, @judulArtikel, @tanggalUnggah, @tanggalValidasi, @tanggalHapus, @idAdmin, @idMember, @idKategori, @kategori
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
				SELECT @prevIdArtikel, @prevBerbayar, @prevStatus, @prevJudul, @prevTanggalUnggah, @prevTanggalValidasi, @prevTanggalHapus, @prevIdAdmin, @prevIdMember, @prevIdKategori, @prevKategori
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
			END
	END
INSERT INTO @resultMergeCategory
SELECT @prevIdArtikel, @prevBerbayar, @prevStatus, @prevJudul, @prevTanggalUnggah, @prevTanggalValidasi, @prevTanggalHapus, @prevIdAdmin, @prevIdMember, @prevIdKategori, @prevKategori
CLOSE curMerge
DEALLOCATE curMerge
SELECT *
FROM @resultMergeCategory
GO

EXEC FindArticleByCategory'akuntansi;fisika;matematika;'