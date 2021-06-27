/*
    SP ini akan menerima sebuah parameter kategori baru contohnya:
        EXEC AddCategory 'Sains'
    SP akan memasukkan @kategoriBaru pada tabel Kategori.
*/
DROP PROCEDURE IF EXISTS [AddCategory]

CREATE PROCEDURE AddCategory
	@kategoriBaru varchar(255)
AS
    INSERT INTO Kategori (kategori)
    VALUES (@kategoriBaru)
GO

EXEC AddCategory (kategori)