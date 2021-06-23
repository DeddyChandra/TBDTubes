/*
    Sp ini akan menerima sebuah parameter dan menginsert kedalam table langganan idMember yang telah subscribe
    (asumsi subscribe langganan perbulan(30 hari))
*/
DROP PROCEDURE IF EXISTS [Subscribe]

CREATE PROCEDURE Subscribe
	@idMember int
AS
DECLARE @maxi int
SELECT @maxi = MAX(idHarga) FROM Harga
INSERT INTO LANGANAN(durasi,idMember,waktuSelesai,idHarga)
SELECT 30,@idMember,CURRENT_TIMESTAMP,@maxi
GO

EXEC Subscribe 1
