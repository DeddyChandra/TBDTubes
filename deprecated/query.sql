--- SP Bryan

DROP PROCEDURE IF EXISTS [Subscribe]

--procedure Subscribe
CREATE PROCEDURE Subscribe
@idMember int
AS
DECLARE @maxi int;
SELECT @maxi = MAX(idHarga) FROM Harga
INSERT INTO LANGANAN(durasi,idMember,waktuSelesai,idHarga)
SELECT 30,@idMember,CURRENT_TIMESTAMP,@maxi


DROP PROCEDURE IF EXISTS [UploadArticle]

CREATE PROCEDURE UploadArticle
@judul varchar(100),
@idMeber int,
@kategori varchar(255),--kategori number
@berbayar BIT
AS

INSERT INTO Artikel(judul,[status],tanggalUnggah,berbayar)
SELECT @judul,0,CURRENT_TIMESTAMP,@berbayar


DECLARE @idcur int
SELECT @idcur =MAX(idArtikel) FROM Article

DECLARE kategori CURSOR FOR
SELECT kata FROM Split(@kategori)
	
OPEN kategori

DECLARE @curnum varchar(255)


FETCH NEXT FROM curMhs INTO @curnum
WHILE @@FETCH_STATUS=0
BEGIN
	INSERT INTO Berkategori(idArtikel,idKategori)
	SELECT @idcur,CONVERT(INT,@curnum)
	FETCH NEXT FROM curMhs INTO @curnum
END


CLOSE kategori
DEALLOCATE kategori



DROP FUNCTION IF EXISTS [Split]




--split function using ;
CREATE FUNCTION Split(
	@kata varchar(MAX)
)
RETURNS @tblhasil  TABLE(
	kata varchar(255)
)
BEGIN
	DECLARE @bol BIT = 0
	DECLARE @idxawal int = 1
	DECLARE @hasil int
	WHILE @bol=0
	BEGIN
		SELECT @hasil= CHARINDEX(';',@kata,@idxawal)
		if(@hasil=0)
		begin
			INSERT INTO @tblhasil
			SELECT SUBSTRING(@kata,@idxawal,LEN(@kata)-@idxawal+2)
			SELECT @bol=1
		end
		else
		begin
			INSERT INTO @tblhasil
			SELECT SUBSTRING(@kata,@idxawal,@hasil-@idxawal)
			SELECT @idxawal=@hasil+1
		end
		

	END
	
	RETURN
END

