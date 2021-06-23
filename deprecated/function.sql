DROP FUNCTION IF EXISTS MultiValueSearch
CREATE FUNCTION MultiValueSearch(
	@input varchar(255)	
)
RETURNS @result TABLE(
	keyword varchar(255)
)
BEGIN
	DECLARE 
		@i int,
		@start int,
		@length int
	SET @i = 1
	SET @start = 1
	SET @length = 0
	WHILE @i <= LEN(@input)
		BEGIN
			SET @length += 1
			IF (CHARINDEX(';',@input,@i) = @i)
				BEGIN
					INSERT INTO @result
					SELECT SUBSTRING(@input,@start,@length-1)
					SET @start = @i+1
					SET @length = 0
				END
			SET @i += 1
		END
	RETURN
END
GO
SELECT *
FROM MultiValueSearch('abc;de;fggh;')


CREATE TYPE dbo.tempResult AS TABLE(
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

/*
DROP FUNCTION IF EXISTS MergeCategory
CREATE FUNCTION MergeCategory(@tempResult tempResult readonly)
RETURNS @resultMergeCategory TABLE (
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
BEGIN
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
	RETURN
END
GO
*/