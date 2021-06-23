/*
    Sp ini akan menerima 4 buah parameter, pertama tama akan diinsert data kedalam artikel, setelah itu akan
    dibuka sebuah cursor untuk looping memasukan idArtikel dan idKategori pada berkategori
*/
DROP PROCEDURE IF EXISTS [UploadArticle]

CREATE PROCEDURE UploadArticle
	@judul varchar(100),
	@idMember int,
	@kategori varchar(255),--kategori number
	@berbayar bit
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
close cursorKategori
DEALLOCATE cursorKategori
GO

EXEC UploadArticle 'Cara Menambah Tinggi Badan',1,'1;2;',1