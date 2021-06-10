CREATE TABLE Member(
	idMember int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	nama varchar(255),
	email varchar(255) UNIQUE,
	kontak varchar(12),
	terverifikasi bit,
	alamat varchar(255),
	[password] varchar(255),
	statusLangganan bit
)

CREATE TABLE [Admin] (
	idAdmin int PRIMARY KEY IDENTITY(1,1),
	email varchar(255) UNIQUE,
	password varchar(255),
	nama varchar(255)
)

CREATE TABLE Artikel(
	idArtikel INT NOT NULL PRIMARY KEY,
	berbayar BIT,
	[status] TINYINT,
	judul varchar(255),
	tanggalValidasi DATETIME,
	tanggalHapus DATETIME,
	idAdmin INT NOT NULL,
	FOREIGN KEY (idAdmin) REFERENCES [Admin](idAdmin)
)

CREATE TABLE Membaca(
	idMember int,
	idArtikel int,
	[status] varchar(255),
	waktu datetime,
	FOREIGN KEY (idMember) REFERENCES Member(idMember),
	FOREIGN KEY (idArtikel) REFERENCES Artikel(idArtikel)
)

CREATE TABLE Kategori(
	idKategori int NOT NULL PRIMARY KEY IDENTITY(1,1),
	kategori varchar(255)
)

CREATE TABLE Berkategori(
	idArtikel int,
	idKategori int,
	FOREIGN KEY (idArtikel) REFERENCES Artikel(idArtikel),
	FOREIGN KEY (idKategori) REFERENCES Kategori(idKategori)
)

CREATE TABLE Langganan(
	idLangganan int NOT NULL PRIMARY KEY,
	durasi time,
	idMember int,
	waktuSelesai datetime,
	FOREIGN KEY (idMember) REFERENCES Member(idMember)
)

CREATE TABLE harga(
	idHarga int NOT NULL PRIMARY KEY,
	harga money,
	waktuBerlaku datetime
)