/*
    Sp ini berfungsi untuk mencari apakah member dengan email dan password yang dimasukan berada pada
    record, jika data ditemukan maka akan return nilai 1 dan sebaliknya nilai 0
*/
DROP PROCEDURE IF EXISTS [FindMember]

CREATE PROCEDURE FindMember
	@email varchar(255),
	@password varchar(255)
AS
DECLARE
	@result bit
SET @result = 0
IF((SELECT COUNT(idMember) FROM master.dbo.Member WHERE email = @email AND password = @password) = 1)
	BEGIN
		SET @result = 1
	END
SELECT @result
GO

EXEC FindMember 'Joni@gmail.com', 'joni134'
EXEC FindMember 'Joni@gmail.coma', 'joni134' -- case salah email
EXEC FindMember 'Joni@gmail.com', 'joni134a' -- case salah password
EXEC FindMember 'Joni@gmail.coma', 'joni134a' -- case salah email & salah password