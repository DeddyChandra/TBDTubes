CREATE PROCEDURE RegisterMember
	@nama varchar(255),
	@kontak varchar(255),
	@alamat varchar(255),
	@email varchar(255),
	@password varchar(255)
AS
INSERT INTO Member (nama,email,)
SELECT 