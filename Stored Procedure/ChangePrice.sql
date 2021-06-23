/*
    Sp ini berfungsi untuk mencatat harga berlanggan (subscribe), Sp ini menerima 2 buah parameter yaitu harga
    dan idAdmin
*/
DROP PROCEDURE IF EXISTS [ChangePrice]

CREATE PROCEDURE ChangePrice
	@harga int,
	@idAdmin int
AS
INSERT INTO Harga (harga, waktuBerlaku, idAdmin)
SELECT @harga, GETDATE(), @idAdmin
GO

EXEC ChangePrice 10000, 1