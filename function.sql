DROP FUNCTION IF EXISTS MultiValueSearch
CREATE FUNCTION MultiValueSearch(
	@input varchar(100)	
)
RETURNS @result TABLE(
	keyword varchar(100)
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