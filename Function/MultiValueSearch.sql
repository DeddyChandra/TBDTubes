/*
    Function ini berfungsi untuk memisahkan string yang dipisahkan dalam ";" (titik koma) ke dalam table contohnya:
        MultiValueSearch('abc;de;fggh;')
    dan pada akhirnya akan dikembalikan sebuah table dengan 1 buah attribut input yang sudah dipisahkan
*/
DROP FUNCTION IF EXISTS MultiValueSearch

CREATE FUNCTION MultiValueSearch(
	@input varchar(255)	
)
RETURNS @result TABLE(
	keyword varchar(255)
)
BEGIN
	DECLARE 
		@i int,
		@start int,
		@length int
	SET @i = 1
	SET @start = 1
	SET @length = 0
	WHILE @i <= LEN(@input)
		BEGIN
			SET @length += 1
			IF (CHARINDEX(';',@input,@i) = @i)
				BEGIN
					INSERT INTO @result
					SELECT SUBSTRING(@input,@start,@length-1)
					SET @start = @i+1
					SET @length = 0
				END
			SET @i += 1
		END
	RETURN
END
GO

SELECT *
FROM MultiValueSearch('abc;de;fggh;')