/*
    Sp ini berfungsi untuk mengembalikan tabel dengan attribut idLangganan, waktuMulai, waktuSelesai, idMember,
    dan idHarga
*/
DROP PROCEDURE IF EXISTS [ScanTransaction]

CREATE PROCEDURE ScanTransaction
AS
SELECT idLangganan, DATEADD(day,-durasi,waktuSelesai) AS [waktuMulai], waktuSelesai, idMember, idHarga
FROM Langganan
GO

EXEC ScanTransaction