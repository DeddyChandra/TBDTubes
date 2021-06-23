/*
    Sp ini berfungsi untuk mengupdate status pada article, terdapat 3 parameter yaitu idArtikel, status, dan idAdmin
    untuk status diberikan code sebagai berikut:
        status artikel : 0 ditolak, 1 : diterima, 2 : dihapus, 3 : pending
*/
DROP PROCEDURE IF EXISTS [UpdateArticleStatus]

CREATE PROCEDURE UpdateArticleStatus
	@idArtikel int,
	@status bit,
	@idAdmin int
AS
UPDATE Artikel
SET [status] = @status, idAdmin = @idAdmin
WHERE idArtikel = @idArtikel
GO

EXEC UpdateArticleStatus 1, 0, 3
