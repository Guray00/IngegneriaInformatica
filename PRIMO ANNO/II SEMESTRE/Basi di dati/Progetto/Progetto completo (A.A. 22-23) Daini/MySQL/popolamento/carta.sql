-- Active: 1647365195286@@127.0.0.1@3306@mydb

INSERT INTO Carta VALUES
('573', '9058599163577205','Luigi','De Falco','Visa'),
('335', '2019906743030489','Mario','Nigiotti','Mastercard'),
('269', '5805287072432984','Paolo','Cervi','Cirrus'),
('798', '7376164067688150','Paola','Costa','Maestro'),
('343', '0465667543797593','Alessio','Daini','American Express'),
('144', '1865331704158761','Viola','Bianchi','Visa Electron'),
('811', '7842208334889374','Marco','Bruschi','Diners Club International'),
('324', '1134752847339975','Paola','Costa','Postamat');


INSERT INTO Fattura VALUES -- `Numero_Fattura`,Importo,Scadenza,Data_Pagamento,CVV,PAN
('000902-22',10.9,'2022-09-10','2022-09-08','573','9058599163577205'), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
('000903-22',10.9,'2022-09-10','2022-09-08','573','9058599163577205'),-- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
('000702-18',3.27,'2018-07-23','2018-07-30','335','2019906743030489'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('000701-14',3.27,'2014-07-22','2014-07-20','269','5805287072432984'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('000401-05',3.27,'2005-04-11','2005-04-11','269','5805287072432984'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('001201-07',21.72,'2007-12-30','2007-12-23','798','7376164067688150'),-- pagamento king per 9 mesi: 12 + 12 * 81/100 = 21,71
('000501-22',12.2,'2022-05-03','2022-05-03','343','0465667543797593'), -- pagamento premium per 1 anno: 5 + 5 * 144/100 = 
('001101-21',8,'2021-11-09','2021-11-04','144','1865331704158761'), -- pagamento special per un mese: 8
('000101-17',10.88,'2017-01-04','2017-01-04','811','7842208334889374'), -- pagamento special per 9 6 mesi: 8 + 8 *36/100
('001102-21',10.88,'2021-11-15','2021-11-15','324','1134752847339975'),-- pagamento special per 9 6 mesi: 8 + 8 *36/100
('000501-13',10.9,'2013-05-19','2013-05-22','573','9058599163577205'), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
('000101-10',10.9,'2010-01-08','2010-01-08','573','9058599163577205'),-- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
('000202-17',3.27,'2017-02-15','2017-02-15','335','2019906743030489'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('000202-10',3.27,'2010-02-12','2010-02-10','269','5805287072432984'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('001003-10',3.27,'2010-10-18','2010-10-09','269','5805287072432984'),-- pagamento base per 3 mesi: 3 + 3 * 9/100
('001001-23',21.72,'2023-10-19','2023-10-16','798','7376164067688150'),-- pagamento king per 9 mesi: 12 + 12 * 81/100 = 21,71
('000601-18',12.2,'2018-06-01','2018-06-05','343','0465667543797593'), -- pagamento premium per 1 anno: 5 + 5 * 144/100 = 
('000502-05',8,'2010-05-05','2010-05-05','144','1865331704158761'), -- pagamento special per un mese: 8
('000701-06',10.88,'2006-07-22','2006-07-26','811','7842208334889374'); -- pagamento special per 9 6 mesi: 8 + 8 *36/100


INSERT INTO Abbonamento VALUES -- Durata_Abbonamento,Tipo,Caratterizzazione,Stato,Eta,Ore_Massime,Numero_Fattura,Id_Cliente
(3,'Incredible','Cartone Animato',0,0,3,'000902-22',1),-- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
(3,'Incredible','Azione',0,0,4,'000903-22',2), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
(3,'Basic','Avventura',1,0,3,'000702-18',3), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(3,'Basic','Romantico',1,0,4,'000701-14',4), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(3,'Basic','Film Di Avventura Non Animato',1,0,NULL,'000401-05',5), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(9,'King','Comico',0,0,5,'001201-07',6), -- pagamento king per 9 mesi: 12 + 12 * 81/100 = 21,71
(12,'Premium','Umorismo Nero',1,3,NULL,'000501-22',7),-- pagamento premium per 1 anno: 5 + 5 * 144/100 = 
(1,'Special','Umorismo Bianco',0,0,5,'001101-21',8), -- pagamento special per un mese: 8
(6,'Special','Amatoriale',0,0,3,'000101-17',9), -- pagamento special per 6 mesi: 8 + 8 *36/100
(6,'Special','Film Fantasy Non Animato',0,0,4,'001102-21',10), -- pagamento special per 6 mesi: 8 + 8 *36/100
(3,'Incredible','Film Fantasy Animato',0,0,5,'000501-13',1), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
(3,'Incredible','Serie Fantasy Non Animata',0,0,4,'000101-10',2), -- pagamento incredibile per 3 mesi: 10 + 10 * 9/100
(3,'Basic','Serie Fantasy Animata',1,0,4,'000202-17',3), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(3,'Basic','Live Action',1,0,3,'000202-10',4), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(3,'Basic','Serie Medica',1,0,3,'001003-10',5), -- pagamento base per 3 mesi: 3 + 3 * 9/100
(9,'King','Serie Da Amore',0,0,6,'001001-23',6), -- pagamento king per 9 mesi: 12 + 12 * 81/100 = 21,71
(12,'Premium','Film Anime',1,0,3,'000601-18',7), -- pagamento premium per 1 anno: 5 + 5 * 144/100 = 
(1,'Special','Serie Anime',0,0,4,'000502-05',8), -- pagamento special per un mese: 8
(6,'Special','Intrattenimento',0,0,4,'000701-06',9); -- pagamento special per 6 mesi: 8 + 8 *36/100



