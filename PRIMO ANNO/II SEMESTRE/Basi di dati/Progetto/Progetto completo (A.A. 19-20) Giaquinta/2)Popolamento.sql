USE Azienda;

INSERT INTO Documento (NumDocumento, Tipologia, DataScadenza, EnteRilascio)
VALUES  (123456, 'Carta di identità' , '2022-08-08', 'Comune di Roma' ),
        (654321, 'Carta di identità' , '2022-08-08', 'Comune di Lignano' ),
        (585786, 'Patente di guida' , '2022-08-08','Scuola di guida Moderna' ),
        (258147, 'Patente di guida', '2023-03-15', 'Scuola di guida Torrione');
        
INSERT INTO Utente (CodFiscale, Nome, Cognome, Telefono, Numero, Via, Cap, Documento)
VALUES	('SCTLCA02H64H501V', 'Alice', 'Scotti', 3381234567, 16, 'Via Anna Marida', 65877, 123456),
		('MCCRLD06T25A662H', 'Eronaldo', 'Macchi', 3981116720, 8, 'Via America', 67021, 654321),
		('MRNRLA06S17F839F', 'Aurelio', 'Marongiu', 3925556677, 1, 'Via De Gregorio', 42025, 585786),
        ('CLCRSN10B12A662R', 'Arsenio', 'Colucci', 3389856230, 4, 'Via De Angelis', 59260, 258147);
        
        
INSERT INTO Account (NomeUtente, Password, DomandaSicurezza, Risposta, Timestamp, CodFiscale)
VALUES  ('AlixSco', 'superpassword' , 'Quale è il nome del tuo primo animale?', 'Sumo', current_timestamp(), 'SCTLCA02H64H501V'),
        ('EroMacchi', 'greenmessanger' , 'In che città sei nato/a?', 'Monteriggioni', current_timestamp(), 'MCCRLD06T25A662H'),
		('Aureliomarongiu', 'passwordsicura' , 'Quale è il nome della tua dolce metà?', 'Ilaria', current_timestamp(), 'MRNRLA06S17F839F'),
        ('Arsucci', 'canegattobau', 'Quale è il nome della tua prima scuola?', 'Perticale', current_timestamp(), 'CLCRSN10B12A662R');

INSERT INTO Ordine (Timestamp, Stato, Spesa, Numero, Via, CAP, Cliente)
VALUES	(current_timestamp(), 'Evaso', 1528.98, 16, 'Via Anna Marida', 65877, 1),
		(current_timestamp(), 'Evaso', 6499.90, 8, 'Via America', 67021, 2),
        (current_timestamp(), 'Evaso', 999.99, 1, 'Via De Gregorio', 42025, 3),
        (current_timestamp(), 'Evaso', 9699.89, 4, 'Via De Angelis', 59260, 4);
        
INSERT INTO Garanzia (Costo, Periodo)
VALUES	(29, '2 anni'),
        (59, '2 anni'),
        (89, '10 anni'),
        (79, 'Lifetime');
        
INSERT INTO Test (Nome, Politica, Padre)
VALUES	('Verifica Accensione', NULL, NULL),
		('Check Schermo', NULL, 1),
        ('Verifica Batteria', NULL, 2),
        ('Passa la Corrente?', 'Se non passa va cambiato tutto il PSU', NULL),
        ('Verifica Accensione', NULL, NULL),
        ('Verifica Accensione', NULL, NULL),
        ('Verifica Accensione', NULL, NULL),
        ('Verifica Accensione', NULL, NULL),
        ('Verifica Accensione', NULL, NULL),
        ('Verifica Accensione', NULL, NULL),
        ('Verifica Accensione', NULL, NULL),
        ('Verifica Accensione', NULL, NULL),
        ('Verifica Accensione', NULL, NULL),
        ('Verifica Accensione', NULL, NULL); -- 14
        
INSERT INTO Prodotto (Modello, Marca, Nome, DataProduzione, NumFacce, SogliaRic, PrimoTest)
VALUES	('S8', 'Damsung', 'Galaxy', '2015-01-01', 2, 100, 1),
		('A1', 'Boschi', 'Idro', '2016-02-02', 6, 10, 5),														
        ('Aria', 'Mela', 'Mècbuk', '2018-03-03', 2, 40, 6),
        ('Terminator', 'Delll', 'Alienuèr', '2018-03-03', 6, 20, 4),
        ('Optimus Prime', 'TechBot', 'Transformerz', '2018-03-03', 92, 1, 7),
        ('Millenium Falcon', 'LucasNavy', 'Starship', '2018-03-03', 4, 1, 8),
        ('9', 'Mela', 'IoTelefono', '2018-03-03', 2, 100, 9),
        ('Professional', 'Mela', 'IoPaddo', '2018-03-03', 2, 50, 10),
        ('2018edition', 'Finestres', 'Superficiex', '2018-03-03', 2, 50, 11),
        ('C17', 'RedRibbon', 'Android', '2018-03-03', 1, 1, 12),
        ('C18', 'RedRibbon', 'Android', '2018-03-03', 1, 1, 13),
		('Ultrabook', 'Damsung', 'PC', '2018-03-03', 2, 40, 14);

INSERT INTO Variante (CodVariante, Prezzo, Prodotto)
VALUES	('S8 8Gb ram', 699.99, 1),
		('S8 12Gb ram', 799.99, 1),
        ('A1 3kg', 649.99, 2),
		('A1 5kg', 649.99, 2),
        ('Aria intel', 999.99, 3),
        ('Aria ryzen', 999.99, 3),
        ('Term ryzen 7', 1999.99, 4),
		('Term ryzen 9', 2299.99, 4),
        ('Optimus', 500000, 5),
        ('Falcon', 1000000, 6),
        ('IoTel9 64gb', 599.99, 7),
		('IoTel9 128gb', 699.99, 7),			
        ('IoTel9 256gb', 799.99, 7),
        ('IoPad', 299.99, 8),
        ('Superficiex', 699, 9),
        ('C17', 5999, 10),
        ('C18', 5999, 11),
        ('DamBook', 999, 12);
	
INSERT INTO Magazzino (Capienza, Predisposizione)
VALUES	(10, 'Di tutto'),
		(20, 'Qualsiasi cosa');
        
INSERT INTO Sequenza (TempoT)
VALUES	(20),
		(40),
        (15);

INSERT INTO Lotto (Tipo, SedeProduzione, DataProduzione, DurataPreventiva, DurataEffettiva, Categoria, Sequenza, Magazzino, Settore, DataStock, DataRilascio, Prodotto, Quantita)
VALUES	('Prodotto', 'Viterbo', '2009-09-09', 4, 4, NULL, 1, 1, 'A4', '2009-10-09', '2010-01-01', 1, 7),
		('Prodotto', 'Pisa', '2009-09-09', 4, 4, NULL, 2, 1, 'A5', '2009-10-09', '2010-01-01', 2, 16),
		('Prodotto', 'Pisa', '2012-09-09', 5, 6, NULL, 3, 2, 'B2', '2009-10-09', '2010-01-01', 3, 9);

-- spazio

INSERT INTO Unita (Variante, Garanzia, Lotto, Acquisto)
VALUES	('S8 8Gb ram', NULL, 1, 1),
		('S8 12Gb ram', 1, 1, 1),
        ('S8 8Gb ram', NULL, 1, 4),
        ('S8 8Gb ram', NULL, 1, 4),
        ('S8 8Gb ram', NULL, 1, NULL),
        ('S8 8Gb ram', NULL, 1, NULL),
        ('S8 8Gb ram', NULL, 1, NULL),
        ('A1 5kg', NULL, 2, 2),
		('A1 5kg', NULL, 2, 2),
        ('A1 5kg', NULL, 2, 2),
        ('A1 5kg', NULL, 2, 2),
        ('A1 5kg', NULL, 2, 2),
        ('A1 5kg', NULL, 2, 2),
        ('A1 5kg', NULL, 2, 2),
        ('A1 5kg', NULL, 2, 2),
        ('A1 5kg', NULL, 2, 2),
        ('A1 5kg', NULL, 2, 2),
		('A1 3kg', NULL, 2, 4),
		('A1 3kg', NULL, 2, 4),
		('A1 3kg', NULL, 2, 4),
		('A1 3kg', NULL, 2, NULL),
		('A1 3kg', NULL, 2, NULL),
		('A1 3kg', NULL, 2, NULL),
        ('Aria ryzen', NULL, 3, 3),
		('Aria ryzen', NULL, 3, 4),
		('Aria ryzen', NULL, 3, 4),
        ('Aria ryzen', NULL, 3, NULL),
        ('Aria intel', NULL, 3, 4),
        ('Aria intel', NULL, 3, 4),
        ('Aria intel', NULL, 3, 4),
        ('Aria intel', NULL, 3, 4),
        ('Aria intel', NULL, 3, 4);
        
INSERT INTO AssistenzaFisica (Preventivo, Accettato, Unita)
VALUES	(99.99, NULL, 8),
		(99.99, NULL, 9),
        (99.99, NULL, 10),
        (99.99, NULL, 11),
        (99.99, NULL, 12),
        (99.99, NULL, 13),
        (49.99, NULL, 18),
        (39.99, NULL, 31),
        (29.99, NULL, 24),
        (79.99, NULL, 4);

INSERT INTO Domanda (Richiesta, DomandaPrecedente, RispostaPrecedente, Rimedio)
VALUES	('Lo smartphone si accende?', NULL, NULL, NULL),
		('Nel dispositivo passa corrente?', NULL, NULL, NULL),
        ('Il laptop si accende?', NULL, NULL, NULL),
        ('Il touchscreen funziona?', 'Lo smartphone si accende?', 'Sì', NULL),
        ('Il dispositivo si spegne da solo?', 'Il touchscreen funziona?', 'Sì', NULL),
        ('Si verifica questo comportamento anche senza batteria, attaccato alla corrente?', NULL, NULL, NULL),
        ('Dopo un riavvio tramite la pulsantiera laterale il problema persiste?', NULL, NULL, NULL),
        ('La lavatrice perde acqua dal lato anteriore?', NULL, NULL, NULL),
        ('Si accende se effettua un tentativo mentre è attaccato alla corrente?', NULL, NULL, NULL);

INSERT INTO Guasto (Nome, Descrizione, Prodotto, PrimaDomanda)
VALUES	('Impuntamenti', 'Lo smartphone si blocca', 1, 'Lo smartphone si accende?'),
		('Lavatrice morta', 'La lavatrice non si accende', 2, 'Nel dispositivo passa corrente?'),
        ('Virus', 'Il laptop si comporta in modo strano', 3, 'Il laptop si accende?'),
        ('Spegnimenti improvvisi', 'Lo smartphone si spegne da solo casualmente', 1, 'Si verifica questo comportamento anche senza batteria, attaccato alla corrente?'),
        ('Touchscreen morto', 'Il touchscreen non è reattivo e non risponde ai tocchi', 1, 'Dopo un riavvio tramite la pulsantiera laterale il problema persiste?'),
        ('La lavatrice perde', 'La lavatrice perde acqua durante il lavaggio', 2, 'La lavatrice perde acqua dal lato anteriore?'),
        ('Laptop morto', 'Il laptop non si accende', 3, 'Si accende se effettua un tentativo mentre è attaccato alla corrente?');

INSERT INTO Errore (Guasto)
VALUES	(1),
		(1),
        (1),
        (1),   -- 4
        (2),
        (2),   -- 6
        (3),
        (3),
        (3),
        (3),
        (3),   -- 11
		(1),
        (1),
        (1),
        (1),   -- 15
        (1);

INSERT INTO Rimedio (Descrizione, Errore)
VALUES	('Ripristina lo Smartphone', 1),
		('Sostituisci la batteria', 2),
        ('Svuotare la RAM chiudendo le Applicazioni in background', 2),
        ('Sostituire lo schermo', 3),
        ('Sostituire il circuito', 4),
        ('Sostituire il cestello', 5),
        ('Sostituire il motore', 6),
        ('Formatta il pc', 7),
        ('Disinstalla il programma identificato', 8),
        ('Disattiva l''impostazione dannosa', 9),
        ('Cambia hard disk esterno', 10),
        ('Ripristina il Backup', 11),
        ('Disinstalla ogni app non utilizzata', 12), -- 13
        ('Installa un antivirus sullo smartphone', 13),
        ('Immergi il telefono nel riso', 14),
        ('Lascia il telefono al sole per un giorno', 15),
        ('Sostituire il circuito Touchscreen', 16);
        
INSERT INTO Recensione (Servizio, Qualita, Prezzo, Commento, Cliente, Unita)
VALUES	(5,4,5,'Ottimo prodotto e spedizione velocissima', 1, 1),
		(5,5,5, 'Prodotto supera le aspettative',1,2),
        (4,1,3, 'Il Prodotto sembra ottimo per il prezzo, ma ne ho ordinati tanti e molti si sono rotti subito', 2,8),
        (5,5,5,'Il prodotto si è rotto durante la spedizione ma mi è stato subito sostituito, è fantastico',3,24),
        (5,4,5, 'La lavatrice fa il suo dovere, non c''è molto altro da dire', 4,18);

INSERT INTO Motivazione (Motivo, Descrizione)
VALUES	('Diritto di Recesso', NULL),
		('Malfunzionamento', 'Il Prodotto non funzionava correttamente già quando è stato estratto dalla scatola'),
        ('Danno pre-esistente', 'Il Prodotto è stato consegnato con evidenti segni di usura o di urti');
        
INSERT INTO Reso (Motivo, DataRichiesta, Unita)
VALUES	(1, '2021-03-30', 8),
		(1, '2021-03-30', 9),
		(1, '2021-03-30', 10),
		(1, '2021-03-30', 11),
        (1, '2021-04-04', 12),
        (1, '2021-03-30', 31),
        (1, '2021-03-30', 30),
        (1, '2021-03-30', 4);

