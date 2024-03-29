INSERT INTO Member(nama,email,kontak,terverifikasi,alamat,password,statusLangganan)
VALUES('Joni','Joni@gmail.com','08123435862',1,'Jalan Mawar no 3','joni134',1)
INSERT INTO Member(nama,email,kontak,terverifikasi,alamat,password,statusLangganan) 
VALUES('Ana','Ana@gmail.com','08127425563',1,'Jalan Kencana no 1','ana123',0)
INSERT INTO Member(nama,email,kontak,terverifikasi,alamat,password,statusLangganan) 
VALUES('Budi','Budi@gmail.com','08736928172',0,'Jalan Kopo no 198','Budidi23',1)
INSERT INTO Member(nama,email,kontak,terverifikasi,alamat,password,statusLangganan) 
VALUES('Marie','Marie@gmail.com','08793458291',0,'Jalan Merdeka no 30','Marie1',0)
INSERT INTO Member(nama,email,kontak,terverifikasi,alamat,password,statusLangganan) 
VALUES('Evelyne','Evelyne@gmail.com','08729182931',1,'Jalan Cempaka no 88','Eve87',0)
INSERT INTO Member(nama,email,kontak,terverifikasi,alamat,password,statusLangganan) 
VALUES('Jane','Jane@gmail.com','08921345829',1,'Jalan Taman Sari no 101','Jane123',1)
INSERT INTO Member(nama,email,kontak,terverifikasi,alamat,password,statusLangganan)
VALUES('Tomi','Tomi@gmail.com','08779238192',1,'Jalan Merdeka no 10','Tomi98',1)

INSERT INTO Admin(email,password,nama)
VALUES('Bob@gmail.com','bobi23','Bobby')
INSERT INTO Admin(email,password,nama)
VALUES('Lukas@gmail.com','Luk98','Lukas')
INSERT INTO Admin(email,password,nama)
VALUES('Chelsea@gmail.com','Chel976','Chelsea')
INSERT INTO Admin(email,password,nama)
VALUES('Kath23@gmail.com','Kath99','Kathleen')
INSERT INTO Admin(email,password,nama)
VALUES('Evan@gmail.com','Evan77','Evander')

INSERT INTO Artikel (berbayar,[status],judul,tanggalUnggah,tanggalValidasi,tanggalHapus,idAdmin,idMember)
VALUES(1,1,'Rahasia Mengatur Keuangan','2019-09-01 21:00:00','2019-09-12 21:19:01',null,1,5)
INSERT INTO Artikel (berbayar,[status],judul,tanggalUnggah,tanggalValidasi,tanggalHapus,idAdmin,idMember)
VALUES(0,0,'Rahasia Hidup Sehat','2019-09-28 10:00:00','2019-10-03 10:18:29',null,2,6)
INSERT INTO Artikel (berbayar,[status],judul,tanggalUnggah,tanggalValidasi,tanggalHapus,idAdmin,idMember)
VALUES(1,3,'Rahasia Hidup Sukses','2019-10-10 10:00:00',null,null,3,1)
INSERT INTO Artikel (berbayar,[status],judul,tanggalUnggah,tanggalValidasi,tanggalHapus,idAdmin,idMember)
VALUES(0,2,'Peluang Usaha Online Tanpa Modal','2019-10-30 06:00:00','2019-11-05 23:21:40','2020-02-17 20:09:08',4,3)
INSERT INTO Artikel (berbayar,[status],judul,tanggalUnggah,tanggalValidasi,tanggalHapus,idAdmin,idMember)
VALUES(1,3,'Makanan Hemat Untuk Anak Kosan','2019-11-01 05:00:00',null,null,5,2)

INSERT INTO Membaca (idMember,idArtikel,[status],waktu)
VALUES(1,2,'mulai','2020-01-02 23:00:00'),
(1,5,'mulai','2020-01-02 23:09:01'),
(1,2,'selesai','2020-01-04 00:00:00'),
(1,5,'selesai','2020-01-3 20:00:00'),
(2,1,'mulai','2020-02-29 19:00:00'),
(2,1,'selesai','2020-03-01 18:00:00'),
(3,3,'mulai','2020-04-01 08:00:09'),
(3,3,'selesai','2020-04-01 19:00:00'),
(4,5,'mulai','2020-04-19 21:00:10'),
(4,5,'selesai','2020-04-19 23:00:10'),
(5,4,'mulai','2020-04-28 23:00:11'),
(5,4,'selesai','2020-04-30 23:00:20'),
(1,3,'mulai','2020-05-01 22:10:01'),
(1,3,'selesai','2020-05-02 19:00:01'),
(1,4,'mulai','2020-05-05 20:00:00'),
(2,2,'mulai','2020-05-08 16:00:20'),
(3,2,'mulai','2020-05-30 17:00:10'),
(4,2,'mulai','2020-06-01 20:00:00'),
(4,2,'selesai','2020-06-02 17:05:00'),
(5,2,'mulai','2020-06-05 18:10:09'),
(1,3,'mulai','2020-06-09 15:00:00'),
(1,3,'selesai','2020-06-10 23:00:00')

INSERT INTO Kategori (kategori) VALUES ('Fisika')
INSERT INTO Kategori (kategori) VALUES ('Matematika')
INSERT INTO Kategori (kategori) VALUES ('Ekonomi')
INSERT INTO Kategori (kategori) VALUES ('Kimia')
INSERT INTO Kategori (kategori) VALUES ('Akuntansi')
INSERT INTO Kategori (kategori) VALUES ('Biologi')
INSERT INTO Kategori (kategori) VALUES ('Astronomi')

INSERT INTO Berkategori VALUES (1,2)
INSERT INTO Berkategori VALUES (2,2)
INSERT INTO Berkategori VALUES (3,2)
INSERT INTO Berkategori VALUES (5,3)
INSERT INTO Berkategori VALUES (3,7)
INSERT INTO Berkategori VALUES (2,4)
INSERT INTO Berkategori VALUES (2,1)
INSERT INTO Berkategori VALUES (2,3)
INSERT INTO Berkategori VALUES (2,5)
INSERT INTO Berkategori VALUES (2,6)
INSERT INTO Berkategori VALUES (2,7)
INSERT INTO Berkategori VALUES (4,1)
INSERT INTO Berkategori VALUES (5,1)
INSERT INTO Berkategori VALUES (1,5)

INSERT INTO Harga (harga,waktuBerlaku,idAdmin) VALUES (10000,'2020-12-31 23:59:59',1)
INSERT INTO Harga (harga,waktuBerlaku,idAdmin) VALUES (9800,'2021-01-01 13:32:12',2)
INSERT INTO Harga (harga,waktuBerlaku,idAdmin) VALUES (13200,'2021-01-28 23:41:11',3)
INSERT INTO Harga (harga,waktuBerlaku,idAdmin) VALUES (11200,'2021-03-12 07:12:00',2)
INSERT INTO Harga (harga,waktuBerlaku,idAdmin) VALUES (12000,'2021-04-02 00:01:48',1)

INSERT INTO Langganan (durasi,idMember,waktuSelesai,idHarga) VALUES (30,1,'2021-01-01 09:00:21',1)
INSERT INTO Langganan (durasi,idMember,waktuSelesai,idHarga) VALUES (30,1,'2021-02-03 15:21:33',3)
INSERT INTO Langganan (durasi,idMember,waktuSelesai,idHarga) VALUES (30,2,'2021-02-04 13:00:21',3)
INSERT INTO Langganan (durasi,idMember,waktuSelesai,idHarga) VALUES (30,1,'2021-03-04 15:30:11',3)
INSERT INTO Langganan (durasi,idMember,waktuSelesai,idHarga) VALUES (30,1,'2021-04-04 15:40:33',4)