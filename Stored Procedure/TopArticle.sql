/*
    Sp ini tidak menerima parameter, Sp ini akan membuka sebuah cursor dan mengkalulasi total waktu baca pada
    artikel tersebut, setelah mendapatkan total durasi pada masing-masing idArtikel akan dilakukan join dengan
    artikel untuk mengambil semua data yang lengkap, dan pada akhirnya akan di return table dengan attribut idArtikel,
    judul, durasi yang telah terutut dari durasi terbesar ke terkecil
*/
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
		@prevStatus varchar(255)
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