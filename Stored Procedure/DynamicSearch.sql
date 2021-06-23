/*
    Sp ini akan menerima sebuah parameter yang dapat diisi dengan multivalue dengan setiap keyword
    dipisahkan dengan ";" (titik koma) contohnya:
        EXEC DynamicSearch 'ne;di;'
    pertama-tama Sp ini akan mensplit semua keyword kedalam table dengan dibuka sebuah cursor, setelah itu
    akan dijoin table member, kategori, dan artikel. Lalu akan dibuka cursor untuk mencari keyword dari hasil join
    table sebelumnya. Setelah itu akan dibuka sebuah cursor untuk concat kategori pada article yang berulang, dan pada akhirnya
    dan akan direturn data article.

*/
DROP PROCEDURE IF EXISTS [DynamicSearch]

CREATE PROCEDURE DynamicSearch
	@keyword varchar(255)
AS
DECLARE @keywordTable TABLE (
	keyword varchar(100)
)
INSERT INTO @keywordTable
SELECT *
FROM MultiValueSearch(@keyword)
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
	nama varchar(255),
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
	kategori varchar(255),
	nama varchar(255)
)
DECLARE curDynamic CURSOR
    FOR
        SELECT *
        FROM @keywordTable
    OPEN curDynamic
        DECLARE
            @judul varchar(100)
    FETCH NEXT FROM curDynamic INTO @judul
    WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO @tempResult
            SELECT himp2.*, kategori.kategori
            FROM Kategori INNER JOIN (
                SELECT himp.*, Berkategori.idKategori
                FROM Berkategori INNER JOIN (
                    SELECT Artikel.idArtikel, Artikel.berbayar, Artikel.status, Artikel.judul, Artikel.tanggalUnggah, Artikel.tanggalValidasi, Artikel.tanggalHapus, Artikel.idAdmin, Artikel.idMember, Member.nama
                    FROM Artikel INNER JOIN Member on Artikel.idMember =  Member.idMember) as [himp] 
                    on Berkategori.idArtikel = himp.idArtikel) as [himp2] 
                on kategori.idKategori = himp2.idKategori
            WHERE Kategori.kategori LIKE '%'+@judul+'%' OR himp2.judul LIKE '%'+@judul+'%' OR himp2.nama LIKE '%'+@judul+'%'
                    FETCH NEXT FROM curDynamic INTO @judul
        END
    CLOSE curDynamic
DEALLOCATE curDynamic
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
    FETCH NEXT FROM curMerge INTO @prevIdArtikel, @prevBerbayar, @prevStatus, @prevJudul, @prevTanggalUnggah, @prevTanggalValidasi, @prevTanggalHapus, @prevIdAdmin, @prevIdMember, @prevNama, @prevIdKategori, @prevKategori
    WHILE @@FETCH_STATUS = 0
        BEGIN
            FETCH NEXT FROM curMerge INTO @idArtikel, @berbayar, @status, @judulArtikel, @tanggalUnggah, @tanggalValidasi, @tanggalHapus, @idAdmin, @idMember, @nama, @idKategori, @kategori
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

EXEC DynamicSearch 'ka;di;'
EXEC DynamicSearch 'ne;'
EXEC DynamicSearch 'ne;di;'
EXEC DynamicSearch 'di;'