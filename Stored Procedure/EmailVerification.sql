
DROP PROCEDURE IF EXISTS [EmailVerification]

CREATE PROCEDURE EmailVerification
	@idMember int
AS
UPDATE master.dbo.Member 
SET terverifikasi = 1
WHERE idMember =  @idMember
GO

EXEC EmailVerification 1