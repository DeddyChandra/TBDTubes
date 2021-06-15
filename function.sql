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


--2
DROP FUNCTION IF EXISTS SearchKategoriByID
CREATE FUNCTION SearchKategoriByName
(
	@kategori varchar(255)
)
RETURNS INT
BEGIN
	DECLARE @hasil INT
	SELECT @hasil=idKategori FROM
	Kategori
	WHERE kategori = @kategori

	return @hasil
END


--TC
--SELECT dbo.SearchKategoriByName('Matematika')
