/*
    Sp ini berfungsi untuk mengecek apakah artikel yang ingin dibuka bersifat berbayar atau free,
    jika tipe artikel tersebut berbayar dan idMember tersebut berlangganan (subscribe) maka akan
    return 1 (true) dapat dibuka, jika artikel tersebut bebayar dan idMember tidak berlangganan 
    maka sp akan return 0 dan article tersebut tidak dapat dibuka. Jika  idArtikel bersifat free
    maka sp akan secara otomatis return nilai 1
*/
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