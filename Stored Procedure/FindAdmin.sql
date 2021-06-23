/*
    Sp ini berfungsi untuk mencari apakah admin dengan email dan password yang dimasukan berada pada
    record, jika data ditemukan maka akan return nilai 1 dan sebaliknya nilai 0
*/
DROP PROCEDURE IF EXISTS [FindAdmin]

CREATE PROCEDURE FindAdmin
	@email varchar(255),
	@password varchar(255)
AS
DECLARE
	@result bit
SET @result = 0
IF((SELECT COUNT(idAdmin) FROM master.dbo.Admin WHERE email = @email AND password = @password) = 1)
	BEGIN
		SET @result = 1
	END
SELECT @result
GO

EXEC FindAdmin 'Bob@gmail.com', 'bobi23'
EXEC FindAdmin 'Bob@gmail.coma', 'bobi23' -- case salah email
EXEC FindAdmin 'Bob@gmail.com', 'bobi23a' -- case salah password
EXEC FindAdmin 'Bob@gmail.coma', 'bobi23a' -- case salah email & salah password