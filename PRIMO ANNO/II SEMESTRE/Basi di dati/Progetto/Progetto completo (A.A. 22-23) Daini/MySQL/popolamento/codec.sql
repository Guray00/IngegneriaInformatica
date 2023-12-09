INSERT INTO Codec VALUES
-- video
('H.264 (MPEG-4 Part 10 AVC)','Uno dei codec video più diffusi e offre una buona qualità video con dimensioni di file più piccole.'),
('H.265 (High Efficiency Video Coding)','Un codec video più recente e avanzato rispetto al H.264, che offre una migliore qualità video con dimensioni di file più ridotte.'),
('VP9','Un codec video open source sviluppato da Google per la compressione dei video su Internet.'),
('MPEG-2','Un codec comunemente usato per la trasmissione televisiva via cavo, satellitare e DVD.'),
('AV1','Un codec video open source sviluppato dalla Alliance for Open Media (AOMedia), progettato per fornire una migliore compressione e qualità video.'),
-- audio
('MP3 (MPEG-1 Audio Layer III)','Uno dei codec audio più comuni e ampiamente usati per la compressione dei file audio.'),
('AAC (Advanced Audio Coding)','Un codec audio ad alta efficienza utilizzato per la compressione dei file audio.'),
('Opus','Un codec audio open source sviluppato per la trasmissione vocale su Internet, con una buona qualità e flessibilità'),
('FLAC (Free Lossless Audio Codec)','Un codec audio senza perdita di qualità, che comprime lo audio mantenendo la integrità dei dati audio.'),
('Vbis','Un codec audio open source utilizzato spesso nel formato contenitore OGG.');

INSERT INTO Formato VALUES -- Id_Formato, Data_Aggiornamento, Bitrate, Tipo_Formato, Durata
-- video
(1,'2009-09-10 16:09:10',100000,'MP4',238), -- 100Mbps = 100000 kbps 
(2,'2023-07-12 18:20:12',100000,'AVI',102),
(3,'1991-12-18 07:53:18',100000,'MKV',116),
(4,'2013-05-11 05:43:11',100000,'MOV',174),
(5,'2010-04-28 02:02:28',100000,'WMV',175),
(6,'2004-10-28 22:34:28',100000,'MP4',121),
(7,'2011-09-22 23:33:22',100000,'AVI',142),
(8,'2014-06-05 06:43:05',100000,'MKV',195),
(9,'2002-07-03 23:07:03',100000,'MOV',107),
(10,'2001-09-03 00:39:03',100000,'WMV',201),
-- audio
(11,'2017-03-23 20:18:23',100000,'MP3',238),
(12,'1998-05-14 18:52:14',100000,'WAV',102),
(13,'2010-10-23 19:55:23',100000,'AAC',116),
(14,'2015-10-30 08:44:30',100000,'FLAC',174),
(15,'2001-01-25 09:05:25',100000,'OGG',175),
(16,'2020-03-13 03:58:13',100000,'M4A',121),
(17,'2018-02-13 17:27:13',100000,'MP3',142),
(18,'2003-08-11 16:26:11',100000,'WAV',195),
(19,'2018-12-21 20:00:21',100000,'AAC',107),
(20,'2021-06-17 15:26:17',100000,'FLAC',201);

INSERT INTO Aggiornamento VALUES -- Id_Formato, Data_Aggiornamento,File_Codec
-- video
(1,'2009-09-10 16:09:10','H.264 (MPEG-4 Part 10 AVC)'), -- 100Mbps = 100000 kbps 
(2,'2023-07-12 18:20:12','H.265 (High Efficiency Video Coding)'),
(3,'1991-12-18 07:53:18','VP9'),
(4,'2013-05-11 05:43:11','MPEG-2'),
(5,'2010-04-28 02:02:28','AV1'),
(6,'2004-10-28 22:34:28','H.264 (MPEG-4 Part 10 AVC)'),
(7,'2011-09-22 23:33:22','H.265 (High Efficiency Video Coding)'),
(8,'2014-06-05 06:43:05','VP9'),
(9,'2002-07-03 23:07:03','MPEG-2'),
(10,'2001-09-03 00:39:03','AV1'),
-- audio
(11,'2017-03-23 20:18:23','MP3 (MPEG-1 Audio Layer III)'),
(12,'1998-05-14 18:52:14','AAC (Advanced Audio Coding)'),
(13,'2010-10-23 19:55:23','Opus'),
(14,'2015-10-30 08:44:30','FLAC (Free Lossless Audio Codec)'),
(15,'2001-01-25 09:05:25','Vbis'),
(16,'2020-03-13 03:58:13','MP3 (MPEG-1 Audio Layer III)'),
(17,'2018-02-13 17:27:13','AAC (Advanced Audio Coding)'),
(18,'2003-08-11 16:26:11','Opus'),
(19,'2018-12-21 20:00:21','FLAC (Free Lossless Audio Codec)'),
(20,'2021-06-17 15:26:17','Vbis');

INSERT INTO Formato_Video VALUES -- `Qualita_Video`,Risoluzione, Larghezza(in pixel), Lunghezza(in pixel), Id_Formato,Data_Aggiornamento
(36,2160,1920,2160,1,'2009-09-10 16:09:10'), -- 100Mbps = 100000 kbps, che sono presenti in HD
(36,2160,1920,2160,2,'2023-07-12 18:20:12'), 
(36,2160,1920,2160,3,'1991-12-18 07:53:18'),
(36,2160,1920,2160,4,'2013-05-11 05:43:11'),
(36,2160,1920,2160,5,'2010-04-28 02:02:28'),
(36,2160,1920,2160,6,'2004-10-28 22:34:28'),
(36,2160,1920,2160,7,'2011-09-22 23:33:22'),
(36,2160,1920,2160,8,'2014-06-05 06:43:05'),
(36,2160,1920,2160,9,'2002-07-03 23:07:03'),
(36,2160,1920,2160,10,'2001-09-03 00:39:03');

INSERT INTO Formato_Audio VALUES
(96,11,'2017-03-23 20:18:23'),
(96,12,'1998-05-14 18:52:14'),
(96,13,'2010-10-23 19:55:23'),
(96,14,'2015-10-30 08:44:30'),
(96,15,'2001-01-25 09:05:25'),
(96,16,'2020-03-13 03:58:13'),
(96,17,'2018-02-13 17:27:13'),
(96,18,'2003-08-11 16:26:11'),
(96,19,'2018-12-21 20:00:21'),
(96,20,'2021-06-17 15:26:17');

INSERT INTO Film_Formato VALUES -- Id_Film, Id_Formato, Data_Aggiornamento, Data_Rilascio
(1,1,'2009-09-10 16:09:10','2010-10-28'), -- 100Mbps = 100000 kbps 
(2,2,'2023-07-12 18:20:12','2023-08-28'),
(3,3,'1991-12-18 07:53:18','1992-12-18'),
(4,4,'2013-05-11 05:43:11','2014-05-11'),
(5,5,'2010-04-28 02:02:28','2011-04-28'),
(6,6,'2004-10-28 22:34:28','2005-10-28'),
(7,7,'2011-09-22 23:33:22','2012-09-22'),
(8,8,'2014-06-05 06:43:05','2014-08-05'),
(9,9,'2002-07-03 23:07:03','2002-09-03'),
(10,10,'2001-09-03 00:39:03','2001-12-03'),
-- audio
(1,11,'2017-03-23 20:18:23','2017-04-23'),
(2,12,'1998-05-14 18:52:14','1998-06-14'),
(3,13,'2010-10-23 19:55:23','2010-12-23'),
(4,14,'2015-10-30 08:44:30','2016-01-30'),
(5,15,'2001-01-25 09:05:25','2001-08-25'),
(6,16,'2020-03-13 03:58:13','2020-06-13'),
(7,17,'2018-02-13 17:27:13','2018-08-13'),
(8,18,'2003-08-11 16:26:11','2003-10-11'),
(9,19,'2018-12-21 20:00:21','2018-02-21'),
(10,20,'2021-06-17 15:26:17','2021-08-17');
