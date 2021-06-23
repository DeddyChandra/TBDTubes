/*
    Sp ini berfungsi untuk menandai record member yang emailnya telah diverifikasi
*/
DROP PROCEDURE IF EXISTS [EmailVerification]

CREATE PROCEDURE EmailVerification
	@idMember int
AS
UPDATE master.dbo.Member 
SET terverifikasi = 1
WHERE idMember =  @idMember
GO

EXEC EmailVerification 1