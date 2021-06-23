/*
    Sp ini akan mencari kategori yang diminati oleh seorang member, parameter untuk Sp ini adalah idMember,
    dan akan buka cursor untuk mencari total waktu member membaca sebuah artikel, setelah itu dari table variable
    resultArticle akan dijoin dengan kategori, pada akhirnya akan ditotalin jumlah waktu membaca berdasarkan kategori,
    dan return sebuah table dengan 3 buah attribute yaitu idKategori, kategori (nama), duration (total waktu) yang
    telah disortir dari waktu terbesar hingga waktu terkecil
*/
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
	SELECT idArtikel, waktu, status
	FROM Membaca
	WHERE idMember =  @idMember
	ORDER BY idArtikel, waktu
OPEN curInterest
	DECLARE
		@idArtikel int,
		@waktu datetime,
		@judul varchar(255),
		@status varchar(255),
		@duration datetime,
		@prevWaktu datetime,
		@prevIdArtikel datetime,
		@prevStatus varchar(255)
FETCH NEXT FROM curInterest INTO  @previdArtikel, @prevWaktu, @prevStatus
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @prevStatus =  'mulai'
			BEGIN
				FETCH NEXT FROM curInterest INTO @idArtikel, @waktu, @status
				IF @status = 'selesai' AND @idArtikel = @prevIdArtikel
					BEGIN
						INSERT INTO @resultArticle
						SELECT @idArtikel, DATEDIFF(MINUTE, @prevWaktu, @waktu)
						FETCH NEXT FROM curInterest INTO @previdArtikel, @prevWaktu, @prevStatus
					END
				ELSE
					/* ini kalau dia dapatnya mulai ga dpt selesai */
					BEGIN
						SET @prevIdArtikel = @idArtikel
						SET @prevWaktu =  @waktu
						SET @prevStatus = @status
					END
			END
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

EXEC CategoryOfInterest 1
EXEC CategoryOfInterest 2
EXEC CategoryOfInterest 5
