-- ----------------------------------- INIZIO DEL POPOLAMENTO DELLE TABELLE --------------------------------------------

#TRUNCATE TABLE Documento;
INSERT INTO Documento (Tipologia, EnteRilascio, CodiceDocumento, DataScadenza)
VALUES
		("Carta di identità", "Comune di Milano", "CA00000AA", "2023-01-27"),
		("Passaporto", "Repubblica Italiana", "AA0584919", "2022-09-24"),
		("Patente", "Motorizzazione Pisa", "CN0102530Z", "2025-12-13"),
		("Carta di identità", "Comune di Pisa", "AY93492BK", "2023-04-20");

#TRUNCATE TABLE Domanda;
INSERT INTO Domanda (Quesito)
VALUES
		("Cognome di tua madre da nubile?"),
		("Nome del tuo primo animale domestico?"),
		("Luogo di nascita di tuo padre?"),
		("Sogno da bambino?"),
		("Squadra del cuore?"),
		("Colore preferito di tuo padre?"),
		("Età del tuo primo rapporto?"),
		("Gioco preferito da bambino?"),
		("Soprannome da ragazzo?"),
		("Serie tv preferita?");

#TRUNCATE TABLE Utente;
INSERT INTO Utente (Nome, Cognome, DataNascita, Telefono, CodiceFiscale, DataIscrizione, Username, Password, Risposta, ID_Domanda, ID_Documento)
VALUES
		("Alex", "Moriconi", "2002-02-24", "3492604219", "MRCLXA02B24G628C", "2021-10-28", "DigitAlex", "4a0a19218e082a343a1b17e5333409af9d98f0f5", "Ingegnere", 4, 1),
		("Lorenzo", "Valtriani", "1965-07-27", "3806985281", "VLTLNZ01L27G702O", "2021-10-28", "bobo", "f75c4b591b538aae90784cc6e3a0f4f800aacab0", "Breaking Bad", 10, 4),
		("Matilde", "Luperi", "1962-11-24", "3396753410", "MTDLPR24NG703Y", "2021-10-28", "tildelupee", "3732b1d34ecd516a55720685f5e3c11b7d25d777", "14 anni", 7, 3),
		("Guglielmo", "Marconi", "2005-05-21", "3246745309", "MRCGLM21MG702O", "2021-10-28", "marcon", "9eac7234f04886c88c66e1b03e69c0af26a46fcc", "Jameson", 1, 2);

#TRUNCATE TABLE PuntoCardinale;
INSERT INTO PuntoCardinale (Nome)
VALUES
		("N"), ("NE"), ("NW"), ("S"), ("SE"), ("SW"), ("E"), ("W");

#TRUNCATE TABLE Stanza;
INSERT INTO Stanza (Nome, Lunghezza, Larghezza, Altezza, NumeroPiano, TemperaturaAttuale, UmiditaAttuale, SpessoreParete, ConducibilitaTermica)
VALUES
		("Cucina", 4, 4, 2.50, 2, 22, 25, 0.25, 0.18),
		("Corridoio ingresso", 8, 1, 2.50, 2, 22, 25, 0.25, 0.18),
		("Sala", 4, 6, 2.50, 2, 22, 25, 0.25, 0.18),
		("Stanzino", 4, 1, 2.50, 2, 22, 25, 0.25, 0.18),
		("Corridoio interno", 8, 1, 2.50, 2, 22, 25, 0.25, 0.18),
		("Camera Alex", 4, 5, 2.50, 2, 22, 25, 0.25, 0.18),
		("Bagno", 4, 3, 2.50, 2, 22, 25, 0.25, 0.18),
		("Camera Guglielmo", 4, 5, 2.50, 2, 22, 25, 0.25, 0.18),
		("Camera Lorenzo e Matilde", 5, 6, 2.50, 2, 24, 30, 0.24, 0.18),
		("Soffitta", 10, 10, 1.70, 2, 18, 20, 0.50, 0.10);

#TRUNCATE TABLE PuntoDiAccesso;
INSERT INTO PuntoDiAccesso (Nome, Aperto, ID_Stanza1, ID_Stanza2, ID_PuntoCardinale)
VALUES
		("Porta d'ingresso", 0, 2, NULL, 8),
		("Porta di cucina", 0, 2, 1, NULL),
		("Porta di sala", 1, 2, 3, NULL),
		("Finestra cucina 1", 1, 1, NULL, 4),
		("Finestra cucina 2", 1, 1, NULL, 4),
		("Finestra sala 1", 0, 2, NULL, 1),
		("Finestra sala 2", 1, 2, NULL, 1),
		("Porta stanzino", 0, 2, 4, NULL),
		("Finestra stanzino", 0, 4, NULL, 5),
		("Porta corridoio", 1, 2, 5, NULL),
		("Porta camera Alex", 0, 5, 6, NULL),
		("Finestra camera Alex", 1, 6, NULL, 1),
		("Porta bagno", 0, 5, 7, NULL),
		("Finestra bagno", 1, 7, NULL, 4),
		("Porta camera Guglielmo", 1, 5, 8, NULL),
		("Finestra camera Gugliemo", 1, 8, NULL, 4),
		("Porta camera Lorenzo e Matilde", 0, 5, 9, NULL),
		("Finestra camera Lorenzo e Matilde", 0, 9, NULL, 8),
		("Porta soffitta", 0, 5, 10, NULL),
		("Lucernario", 0, 10, NULL, 1);

#TRUNCATE TABLE SmartPlug;
INSERT INTO SmartPlug (Nome, StatoConnessione, StatoUscita, ID_Stanza)
VALUES 			("Frigorifero",1,1,1),
				("Forno",1,1,1),
				("Lavastoviglie",1,1,1),
				("Microonde",1,1,1),
				("Macchina Caffè",1,1,1),
				("Ventilatore Sala",1,1,3),
				("Ventilatore Camera Matrimoniale",1,1,9),
				("Pompa Fognatura",1,0,4),
				("Pompa Irrigazione",1,0,4),
				("Televisore Sala",1,1,3),
				("Impianto Audio Sala",1,1,3),
				("Spazzolino Elettrico Bagno",1,1,7),
				("Televisore Camera Matrimoniale",1,1,9),
				("Televisore Camera Guglielmo",1,1,8),
				("Televisore Camera Alex",1,1,6),
				("Lavatrice",1,1,4),
				("Congelatore",1,1,1);

#TRUNCATE TABLE TipologiaDispositivo;
INSERT INTO TipologiaDispositivo (Nome)
VALUES  		("Consumo Fisso"),
				("Consumo Variabile Interrompibile"),
				("Consumo Variabile non Interrompibile");

#TRUNCATE TABLE Dispositivo;
INSERT INTO Dispositivo (Nome, Potenza, ID_SmartPlug, ID_TipologiaDispositivo)
VALUES 			("Frigorifero",NULL,1,2),
				("Forno",NULL,2,2),
				("Lavastoviglie",NULL,3,3),
				("Microonde",NULL,4,2),
				("Macchina Ceffè",NULL,5,3),
				("Ventilatore Sala",NULL,6,2),
				("Ventilatore Camera Matrimoniale",NULL,7,2),
				("Pompa Fognatura",1.5,8,1),
				("Pompa Irrigazione",1.7,9,1),
				("Televisore Sala",0.300,10,1),
				("Impianto Audio Sala",0.400,11,1),
				("Spazzolino Elettrico Bagno",0.10,12,1),
				("Televisore Camera Matrimoniale",0.250,13,1),
				("Televisore Camera Guglielmo",0.600,14,1),
				("Televisore Camera Alex",0.150,15,1),
				("Lavatrice",NULL,16,3),
				("Congelatore",NULL,17,2),
				("Aspirapolvere",NULL,NULL,2);

#TRUNCATE TABLE Programma;
INSERT INTO Programma (Nome, PotenzaMedia, DurataTemporale, ID_Dispositivo)
VALUES 			("Frigorifero 4°C",0.250,NULL,1),
				("Frigorifero 7°C",0.100,NULL,1),
				("Forno 250°C",2.2,NULL,2),
				("Forno 180°C",1.8,NULL,2),
				("Lavastoviglie P1",2.0,2.3,3),
				("Lavastoviglie P2",1.8,0.5,3),
				("Microonde P1",0.7,NULL,4),
				("Microonde P2",1.5,NULL,4),
				("Macchina Caffè Cappuccino",0.150,0.05,5),
				("Macchina Caffè Espresso",0.130,0.01,5),
				("Ventilatore Sala Min",0.50,NULL,6),
				("Ventilatore Sala Max",0.100,NULL,6),
				("Ventilatore Camera Matrimoniale Min",0.50,NULL,7),
				("Ventilatore Camera Matrimoniale Min",0.100,NULL,7),
				("Lavatrice Panni Chiari",1.85,0.75,16),
				("Lavatrice Panni Scuri",2.0,1,16),
				("Aspirapolvere Min",0.7,NULL,18),
				("Aspirapolvere Max",1.4,NULL,18),
				("Congelatore -4°C",0.5,NULL,17);

#TRUNCATE TABLE Suggerimento;
DROP PROCEDURE IF EXISTS InizializzaTimestamp;
DELIMITER $$
CREATE PROCEDURE InizializzaTimestamp()
BEGIN
	DECLARE istante TIMESTAMP DEFAULT "2021-11-10 00:00:00";
    
    SET @QuerySQL = 'INSERT INTO Timestamp (Istante, TemperaturaEsterna)
					 VALUES (?, ?)';
	PREPARE InserisciTimestamp
	FROM @QuerySQL;
    
	ciclo: LOOP
		IF (HOUR(istante) > 19 AND HOUR(istante) < 9) THEN
			-- INSERT INTO Timestamp (Istante, TemperaturaEsterna)
			-- VALUES (istante, floor(rand()*(30-20)+13));
            SET @temp_esterna = floor(rand()*(30-20)+13);
		ELSE
			-- INSERT INTO Timestamp (Istante, TemperaturaEsterna)
			-- VALUES (istante, floor(rand()*(30-20)+20));
            SET @temp_esterna = floor(rand()*(30-20)+20);
        END IF;
        SET @istante = istante;
        
        EXECUTE InserisciTimestamp
        USING @istante, @temp_esterna;
        
        SET istante = istante + INTERVAL 1 MINUTE;
        IF (DATEDIFF(istante, "2021-11-27 00:00:06") > 0) THEN
			LEAVE ciclo;
		END IF;
    END LOOP;
END $$
DELIMITER ;

CALL InizializzaTimestamp();

INSERT INTO RegistroDispositivo (IstanteInizio, ID_Dispositivo, ID_Programma, ID_Utente, IstanteFine)
VALUES 	("2021-11-21 00:00:00",1,1,1,NULL),
		("2021-11-21 00:00:00",12,NULL,1,NULL),
		("2021-11-21 09:00:00",17,19,1,NULL),
		("2021-11-22 07:32:00",5,9,2,"2021-11-22 07:35:00"),
		("2021-11-22 07:45:00",10,NULL,2,"2021-11-22 08:05:00"),
		("2021-11-22 08:02:00",5,10,1,"2021-11-22 08:03:00"),
		("2021-11-22 08:04:00",5,10,3,"2021-11-22 08:05:00"),
		("2021-11-22 10:07:00",4,7,4,"2021-11-22 10:09:00"),
		("2021-11-22 11:15:00",3,6,2,"2021-11-22 11:45:00"),
		("2021-11-22 11:25:00",14,NULL,4,"2021-11-22 15:02:00"),
		("2021-11-22 11:27:00",6,11,3,"2021-11-22 18:09:00"),
		("2021-11-22 12:00:00",3,3,4,"2021-11-22 13:04:00"),
		("2021-11-22 12:05:00",10,NULL,3,"2021-11-22 13:25:00"),
		("2021-11-22 12:04:00",5,10,1,"2021-11-22 12:05:00"),
		("2021-11-22 12:07:00",5,10,2,"2021-11-22 12:08:00"),
		("2021-11-22 12:10:00",5,10,4,"2021-11-22 12:11:00"),
		("2021-11-22 15:11:00",15,NULL,1,"2021-11-22 20:34:00"),
		("2021-11-22 19:04:00",16,16,3,"2021:11-22 20:04:00"),
		("2021-11-22 19:30:00",4,8,1,"2021-11-22 19:40:00"),
		("2021-11-22 20:04:00",10,NULL,1,"2021-11-22 22:08:00"),
		("2021-11-22 22:31:00",13,NULL,3,"2021-11-22 23:45:00"),
		("2021-11-22 22:34:00",15,NULL,1,"2021-11-22 23:09:00"),
		("2021-11-22 22:39:00",14,NULL,4,"2021-11-22 23:01:00");

INSERT INTO Climatizzatore (Nome, Acceso, ID_Stanza) 
VALUES ("Radiatore Sala", 0, 3),
	   ("Condizionatore Sala", 0, 3),
       ("Radiatore Cucuna", 1, 1),
       ("Radiatore Camera Alex", 0, 6),
       ("Radiatore Camera Guglielmo", 0, 8),
       ("Radiatore Camera Lorezo e Matilde", 0, 9);

INSERT INTO Mese (Numero, Nome)
VALUES (1, "Gennaio"), (2, "Febbraio"), (3, "Marzo"), (4, "Aprile"),
	   (5, "Maggio"), (6, "Giugno"), (7, "Luglio"), (8, "Agosto"),
       (9, "Settembre"), (10, "Ottobre"), (11, "Novembre"), (12, "Dicembre");

#TRUNCATE TABLE Giorno;
INSERT INTO Giorno (Numero, Nome)
VALUES (1, "Lunedi"), (2, "Martedi"), (3, "Mercoledi"),
	   (4, "Giovedi"), (5, "Venerdi"), (6, "Sabato"), (7, "Domenica");
	
INSERT INTO ImpostazioneClimatizzatore (TemperaturaDesiderata, UmiditaDesiderata, OraInizio, OraFine, DataInizio, DataFine, Ripetitiva, ID_Utente)
VALUES (26, 50, "06:30:00", "10:00:00", NULL, NULL, 1, 1),
	   (27, 50, "19:00:00", "06:30:00", NULL, NULL, 1, 3),
       (22, 40, "06:30:00", "10:00:00", NULL, NULL, 1, 1);
       
INSERT INTO MesiAttivi (ID_ImpostazioneClimatizzatore, NumeroMese)
VALUES (1, 11), (1, 12), (1, 1), 
	   (2, 11), (2, 12), (2, 1), 
       (3, 6), (3, 7), (3, 8);

INSERT INTO GiorniAttivi (ID_ImpostazioneClimatizzatore, NumeroGiorno)
VALUES (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7),
	   (2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7),
       (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6);
       
INSERT INTO Riferito (ID_ImpostazioneClimatizzatore, ID_Climatizzatore)
VALUES (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
	   (2, 4), (2, 5), (2, 6),
       (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6);
       
INSERT INTO RegistroClimatizzatore (ID_Climatizzatore, IstanteInizio, TemperaturaIniziale, UmiditaIniziale, TemperaturaObiettivo, 
                                    UmiditaObiettivo, ID_Utente, ID_ImpostazioneClimatizzatore, IstanteFine)
VALUES (1, "2021-11-22 06:30:00", 20.2, 60, 26, 50, 1, 1, "2021-11-22 10:00:00"),
       (2, "2021-11-22 06:30:00", 20.1, 60, 26, 50, 1, 1, "2021-11-22 10:00:00"),
       (3, "2021-11-22 06:30:00", 20.0, 60, 26, 50, 1, 1, "2021-11-22 10:00:00"),
       (4, "2021-11-22 06:30:00", 20.1, 60, 26, 50, 1, 1, "2021-11-22 10:00:00"),
       (5, "2021-11-22 06:30:00", 20.2, 60, 26, 50, 1, 1, "2021-11-22 10:00:00"),
       (6, "2021-11-22 06:30:00", 20.3, 60, 26, 50, 1, 1, "2021-11-22 10:00:00"),
       (1, "2021-11-22 19:00:00", 19.3, 60, 27, 50, 1, 1, "2021-11-22 06:30:00"),
       (2, "2021-11-22 19:00:00", 19.3, 60, 27, 50, 1, 1, "2021-11-22 06:30:00"),
       (3, "2021-11-22 19:00:00", 19.3, 60, 27, 50, 1, 1, "2021-11-22 06:30:00"),
       (4, "2021-11-22 19:00:00", 19.3, 60, 27, 50, 1, 1, "2021-11-22 06:30:00"),
       (5, "2021-11-22 19:00:00", 19.3, 60, 27, 50, 1, 1, "2021-11-22 06:30:00"),
       (6, "2021-11-22 19:00:00", 19.3, 60, 27, 50, 1, 1, "2021-11-22 06:30:00");
       
INSERT INTO Luce (Nome, IntensitaMinima, IntensitaMassima, TemperaturaMinima, TemperaturaMassima, ID_Stanza)
VALUES ("Luce Cucina 1", 10, 80, 1000, 8000, 1),
	   ("Luce Cucina 2", 10, 80, 1000, 8000, 1),
       ("Luce Corridoio Ingresso", 10, 80, 4000, 4000, 2),
       ("Luce Sala 1", 10, 80, 1900, 8000, 3),
       ("Luce Sala 2", 10, 80, 1900, 8000, 3),
       ("Luce Stanzino", 10, 80, 4000, 4000, 4),
       ("Luce Corridoio Interno", 10, 80, 4000, 4000, 5),
       ("Luce Camera Alex 1", 10, 80, 1000, 10000, 6),
	   ("Luce Camera Alex 2", 10, 80, 1000, 10000, 6),
       ("Luce Camera Alex 3", 10, 80, 3000, 3000, 6),
       ("Luce Bagno", 10, 80, 7000, 12000, 7),
	   ("Luce Camera Guglielmo 1", 10, 80, 1000, 10000, 8),
	   ("Luce Camera Guglielmo 2", 10, 80, 1000, 10000, 8),
       ("Luce Camera Lorenzo e Matilde 1", 10, 80, 1000, 10000, 9),
	   ("Luce Camera Lorenzo e Matilde 2", 10, 80, 1000, 10000, 9),
       ("Luce Soffitta", 10, 80, 4000, 4000, 10);

INSERT INTO ImpostazioneLuce (Nome, Temperatura, Intensita, ID_Utente, ID_Luce)
VALUES ("Luce Calda Camera Lorenzo 1", 1000, 80, 2, 14),
	   ("Luce Calda Camera Lorenzo 2", 3000, 80, 2, 15),
       ("Luce Camera Alex", 3000, 80, 1, 10);

INSERT INTO RegistroIlluminazione (ID_Utente, ID_Luce, IstanteInizio, Temperatura, Intensita, IstanteFine)
VALUES (1, 10, "2021-11-16 06:46:00", 3000, 80, "2021-11-16 07:00:00"),
	   (3, 14, "2021-11-16 06:40:00", 1000, 80, "2021-11-16 07:10:00"),
       (3, 15, "2021-11-16 06:40:00", 3000, 80, "2021-11-16 07:10:00"),
       (4, 13, "2021-11-16 07:46:00", 5000, 80, "2021-11-16 08:00:00"),
	   (4, 12, "2021-11-16 07:46:00", 4000, 80, "2021-11-16 08:00:00"),
       (1, 11, "2021-11-16 07:30:00", 9000, 80, "2021-11-16 07:45:00"),
       (3, 2, "2021-11-16 07:01:00", 8000, 80, "2021-11-16 08:00:00"),
	   (3, 1, "2021-11-16 07:12:00", 7000, 80, "2021-11-16 08:00:00"),
       (2, 11, "2021-11-16 08:50:00", 10000, 80, "2021-11-16 09:10:00"),
       (3, 4, "2021-11-16 08:50:00", 3000, 80, "2021-11-16 09:10:00"),
       (3, 5, "2021-11-16 08:50:00", 4000, 80, "2021-11-16 09:10:00"),
       (1, 3, "2021-11-16 09:00:00", 4000, 80, "2021-11-16 09:01:00"),
       (1, 10, "2021-11-16 10:00:00", 3000, 80, "2021-11-16 12:00:00"),
       (3, 14, "2021-11-16 12:00:00", 1000, 80, "2021-11-16 12:30:00"),
       (3, 15, "2021-11-16 12:00:00", 3000, 80, "2021-11-16 12:30:00"),
       (3, 14, "2021-11-16 12:31:00", 5000, 80, "2021-11-16 12:36:00"),
       (3, 15, "2021-11-16 12:31:00", 4000, 80, "2021-11-16 12:36:00"),
       (3, 14, "2021-11-16 12:40:00", 1000, 80, "2021-11-16 12:45:00"),
       (3, 15, "2021-11-16 12:40:00", 3000, 80, "2021-11-16 12:46:00"),
       (3, 1, "2021-11-16 13:40:00", 8000, 80, "2021-11-16 14:20:00"),
       (3, 2, "2021-11-16 13:40:00", 7000, 80, "2021-11-16 13:20:00"),
       (4, 12, "2021-11-16 15:40:00", 4000, 80, "2021-11-16 16:20:00"),
       (4, 13, "2021-11-16 15:40:00", 5000, 80, "2021-11-16 16:20:00"),
       (4, 12, "2021-11-16 16:40:00", 3000, 80, "2021-11-16 17:00:00"),
       (4, 13, "2021-11-16 16:40:00", 2000, 80, "2021-11-16 17:00:00"),
       (2, 14, "2021-11-16 16:50:00", 1000, 80, "2021-11-16 17:20:00"),
       (2, 15, "2021-11-16 16:50:00", 3000, 80, "2021-11-16 17:20:00"),
       
       (1, 10, "2021-11-17 06:44:00", 3000, 80, "2021-11-17 07:01:00"),
	   (3, 14, "2021-11-17 06:42:00", 1000, 80, "2021-11-17 07:16:00"),
       (3, 15, "2021-11-17 06:42:00", 3000, 80, "2021-11-17 07:16:00"),
       (4, 13, "2021-11-17 07:43:00", 6000, 80, "2021-11-17 08:01:00"),
	   (4, 12, "2021-11-17 07:43:00", 7000, 80, "2021-11-17 08:01:00"),
       (1, 11, "2021-11-17 07:37:00", 11000, 80, "2021-11-17 07:42:00"),
       (3, 2, "2021-11-17 07:01:00", 8000, 80, "2021-11-17 08:00:00"),
	   (3, 1, "2021-11-17 07:12:00", 7000, 80, "2021-11-17 08:00:00"),
       (2, 11, "2021-11-17 08:50:00", 10000, 80, "2021-11-17 09:10:00"),
       (3, 4, "2021-11-17 08:50:00", 3000, 80, "2021-11-17 09:10:00"),
       (3, 5, "2021-11-17 08:50:00", 4000, 80, "2021-11-17 09:10:00"),
       (1, 3, "2021-11-17 09:00:00", 4000, 80, "2021-11-17 09:01:00"),
       (1, 10, "2021-11-17 10:00:00", 3000, 80, "2021-11-17 12:00:00"),
       (3, 14, "2021-11-17 12:01:00", 1000, 80, "2021-11-17 12:30:00"),
       (3, 15, "2021-11-17 12:01:00", 3000, 80, "2021-11-17 12:30:00"),
       (3, 14, "2021-11-17 12:31:00", 5000, 80, "2021-11-17 12:36:00"),
       (3, 15, "2021-11-17 12:31:00", 4000, 80, "2021-11-17 12:36:00"),
       (3, 14, "2021-11-17 12:40:00", 1500, 80, "2021-11-17 12:45:00"),
       (3, 15, "2021-11-17 12:40:00", 3000, 80, "2021-11-17 12:46:00"),
       (3, 1, "2021-11-17 13:40:00", 8000, 80, "2021-11-17 14:20:00"),
       (3, 2, "2021-11-17 13:40:00", 7000, 80, "2021-11-17 13:20:00"),
       (4, 12, "2021-11-17 15:40:00", 4000, 80, "2021-11-17 16:20:00"),
       (4, 13, "2021-11-17 15:40:00", 5000, 80, "2021-11-17 16:20:00"),
       (4, 12, "2021-11-17 16:40:00", 6000, 80, "2021-11-17 17:00:00"),
       (4, 13, "2021-11-17 16:40:00", 4000, 80, "2021-11-17 17:00:00"),
       (2, 14, "2021-11-17 16:56:00", 1000, 80, "2021-11-17 17:23:00"),
       (2, 15, "2021-11-17 16:56:00", 3000, 80, "2021-11-17 17:23:00"),
       
       (1, 10, "2021-11-18 06:46:00", 3000, 80, "2021-11-18 07:00:00"),
	   (3, 14, "2021-11-18 06:40:00", 1000, 80, "2021-11-18 07:10:00"),
       (3, 15, "2021-11-18 06:40:00", 3000, 80, "2021-11-18 07:10:00"),
       (4, 13, "2021-11-18 07:46:00", 7000, 80, "2021-11-18 08:00:00"),
	   (4, 12, "2021-11-18 07:46:00", 8000, 80, "2021-11-18 08:00:00"),
       (1, 11, "2021-11-18 07:30:00", 10000, 80, "2021-11-18 07:45:00"),
       (3, 2, "2021-11-18 07:01:00", 7000, 80, "2021-11-18 08:00:00"),
	   (3, 1, "2021-11-18 07:12:00", 7000, 80, "2021-11-18 08:00:00"),
       (2, 11, "2021-11-18 08:50:00", 10000, 80, "2021-11-18 09:10:00"),
       (3, 4, "2021-11-18 08:50:00", 1900, 80, "2021-11-18 09:10:00"),
       (3, 5, "2021-11-18 08:50:00", 3000, 80, "2021-11-18 09:10:00"),
       (1, 3, "2021-11-18 09:00:00", 4000, 80, "2021-11-18 09:01:00"),
       (1, 10, "2021-11-18 10:00:00", 3000, 80, "2021-11-18 12:00:00"),
       (3, 14, "2021-11-18 12:00:00", 1500, 80, "2021-11-18 12:30:00"),
       (3, 15, "2021-11-18 12:00:00", 3000, 80, "2021-11-18 12:30:00"),
       (3, 14, "2021-11-18 12:31:00", 5000, 80, "2021-11-18 12:36:00"),
       (3, 15, "2021-11-18 12:31:00", 4000, 80, "2021-11-18 12:36:00"),
       (3, 14, "2021-11-18 12:40:00", 1000, 80, "2021-11-18 12:45:00"),
       (3, 15, "2021-11-18 12:40:00", 4000, 80, "2021-11-18 12:46:00"),
       (3, 1, "2021-11-18 13:40:00", 8000, 80, "2021-11-18 14:20:00"),
       (3, 2, "2021-11-18 13:40:00", 7000, 80, "2021-11-18 13:20:00"),
       (4, 12, "2021-11-18 15:40:00", 4000, 80, "2021-11-18 16:20:00"),
       (4, 13, "2021-11-18 15:40:00", 5000, 80, "2021-11-18 16:20:00"),
       (4, 12, "2021-11-18 16:40:00", 5000, 80, "2021-11-18 17:00:00"),
       (4, 13, "2021-11-18 16:40:00", 6000, 80, "2021-11-18 17:00:00"),
       (2, 14, "2021-11-18 16:50:00", 1000, 80, "2021-11-18 17:20:00"),
       (2, 15, "2021-11-18 16:50:00", 3000, 80, "2021-11-18 17:20:00"),
       
       (1, 10, "2021-11-19 06:46:00", 3000, 80, "2021-11-19 07:00:00"),
	   (3, 14, "2021-11-19 06:40:00", 1000, 80, "2021-11-19 07:10:00"),
       (3, 15, "2021-11-19 06:40:00", 3000, 80, "2021-11-19 07:10:00"),
       (4, 13, "2021-11-19 07:46:00", 5000, 80, "2021-11-19 08:00:00"),
	   (4, 12, "2021-11-19 07:46:00", 4000, 80, "2021-11-19 08:00:00"),
       (1, 11, "2021-11-19 07:30:00", 9000, 80, "2021-11-19 07:45:00"),
       (3, 2, "2021-11-19 07:01:00", 8000, 80, "2021-11-19 08:00:00"),
	   (3, 1, "2021-11-19 07:12:00", 7000, 80, "2021-11-19 08:00:00"),
       (2, 11, "2021-11-19 08:50:00", 10000, 80, "2021-11-19 09:10:00"),
       (3, 4, "2021-11-19 08:50:00", 7000, 80, "2021-11-19 09:10:00"),
       (3, 5, "2021-11-19 08:50:00", 6000, 80, "2021-11-19 09:10:00"),
       (1, 3, "2021-11-19 09:00:00", 4000, 80, "2021-11-19 09:01:00"),
       (1, 10, "2021-11-19 10:00:00", 3000, 80, "2021-11-19 12:00:00"),
       (3, 14, "2021-11-19 12:00:00", 1000, 80, "2021-11-19 12:30:00"),
       (3, 15, "2021-11-19 12:00:00", 3000, 80, "2021-11-19 12:30:00"),
       (3, 14, "2021-11-19 12:31:00", 5000, 80, "2021-11-19 12:36:00"),
       (3, 15, "2021-11-19 12:31:00", 4000, 80, "2021-11-19 12:36:00"),
       (3, 14, "2021-11-19 12:40:00", 1000, 80, "2021-11-19 12:45:00"),
       (3, 15, "2021-11-19 12:40:00", 3000, 80, "2021-11-19 12:46:00"),
       (4, 16, "2021-11-19 12:36:00", 4000, 45, "2021-11-19 12:37:00"),
       (3, 1, "2021-11-19 13:40:00", 8000, 80, "2021-11-19 14:20:00"),
       (3, 2, "2021-11-19 13:40:00", 8000, 80, "2021-11-19 13:20:00"),
       (4, 12, "2021-11-19 15:40:00", 7000, 80, "2021-11-19 16:20:00"),
       (4, 13, "2021-11-19 15:40:00", 5000, 80, "2021-11-19 16:20:00"),
       (4, 12, "2021-11-19 16:40:00", 3000, 80, "2021-11-19 17:00:00"),
       (4, 13, "2021-11-19 16:40:00", 2000, 80, "2021-11-19 17:00:00"),
       (2, 14, "2021-11-19 16:50:00", 1000, 80, "2021-11-19 17:20:00"),
       (2, 15, "2021-11-19 16:50:00", 3000, 80, "2021-11-19 17:20:00"),
       
       (1, 10, "2021-11-20 06:46:00", 3000, 80, "2021-11-20 07:00:00"),
	   (3, 14, "2021-11-20 06:40:00", 1000, 80, "2021-11-20 07:10:00"),
       (3, 15, "2021-11-20 06:40:00", 3000, 80, "2021-11-20 07:10:00"),
       (4, 13, "2021-11-20 07:46:00", 5000, 80, "2021-11-20 08:00:00"),
	   (4, 12, "2021-11-20 07:46:00", 4000, 80, "2021-11-20 08:00:00"),
       (1, 11, "2021-11-20 07:30:00", 9000, 80, "2021-11-20 07:45:00"),
       (3, 2, "2021-11-20 07:01:00", 8000, 80, "2021-11-20 08:00:00"),
	   (3, 1, "2021-11-20 07:12:00", 7000, 80, "2021-11-20 08:00:00"),
       (2, 11, "2021-11-20 08:50:00", 10000, 80, "2021-11-20 09:10:00"),
       (3, 4, "2021-11-20 08:50:00", 3000, 80, "2021-11-20 09:10:00"),
       (3, 5, "2021-11-20 08:50:00", 4000, 80, "2021-11-20 09:10:00"),
       (1, 3, "2021-11-20 09:00:00", 4000, 80, "2021-11-20 09:01:00"),
       (1, 10, "2021-11-20 10:00:00", 3000, 80, "2021-11-20 12:00:00"),
       (3, 14, "2021-11-20 12:00:00", 1000, 80, "2021-11-20 12:30:00"),
       (3, 15, "2021-11-20 12:00:00", 3000, 80, "2021-11-20 12:30:00"),
       (3, 14, "2021-11-20 12:31:00", 5500, 80, "2021-11-20 12:36:00"),
       (3, 15, "2021-11-20 12:31:00", 5000, 80, "2021-11-20 12:36:00"),
       (3, 14, "2021-11-20 12:40:00", 1000, 80, "2021-11-20 12:45:00"),
       (3, 15, "2021-11-20 12:40:00", 3000, 80, "2021-11-20 12:46:00"),
       (3, 1, "2021-11-20 13:40:00", 8000, 80, "2021-11-20 14:20:00"),
       (3, 2, "2021-11-20 13:40:00", 7000, 80, "2021-11-20 13:20:00"),
       (4, 12, "2021-11-20 15:40:00", 7000, 80, "2021-11-20 16:20:00"),
       (4, 13, "2021-11-20 15:40:00", 8000, 80, "2021-11-20 16:20:00"),
       (4, 12, "2021-11-20 16:40:00", 4000, 80, "2021-11-20 17:00:00"),
       (4, 13, "2021-11-20 16:40:00", 3000, 80, "2021-11-20 17:00:00"),
       (2, 14, "2021-11-20 16:50:00", 1000, 80, "2021-11-20 17:20:00"),
       (2, 15, "2021-11-20 16:50:00", 3000, 80, "2021-11-20 17:20:00"),
       
       (1, 10, "2021-11-21 06:46:00", 3000, 80, "2021-11-21 07:00:00"),
	   (3, 14, "2021-11-21 06:40:00", 1000, 80, "2021-11-21 07:10:00"),
       (3, 15, "2021-11-21 06:40:00", 3000, 80, "2021-11-21 07:10:00"),
       (4, 13, "2021-11-21 07:46:00", 5000, 80, "2021-11-21 08:00:00"),
	   (4, 12, "2021-11-21 07:46:00", 4000, 80, "2021-11-21 08:00:00"),
       (1, 11, "2021-11-21 07:30:00", 9000, 80, "2021-11-21 07:45:00"),
       (3, 2, "2021-11-21 07:01:00", 8000, 80, "2021-11-21 08:00:00"),
	   (3, 1, "2021-11-21 07:12:00", 7000, 80, "2021-11-21 08:00:00"),
       (2, 11, "2021-11-21 08:50:00", 10000, 80, "2021-11-21 09:10:00"),
       (3, 4, "2021-11-21 08:50:00", 3000, 80, "2021-11-21 09:10:00"),
       (3, 5, "2021-11-21 08:50:00", 4000, 80, "2021-11-21 09:10:00"),
       (1, 3, "2021-11-21 09:00:00", 4000, 80, "2021-11-21 09:01:00"),
       (1, 10, "2021-11-21 10:00:00", 3000, 80, "2021-11-21 12:00:00"),
       (3, 14, "2021-11-21 12:00:00", 1000, 80, "2021-11-21 12:30:00"),
       (3, 15, "2021-11-21 12:00:00", 3000, 80, "2021-11-21 12:30:00"),
       (3, 14, "2021-11-21 12:31:00", 5000, 80, "2021-11-21 12:36:00"),
       (3, 15, "2021-11-21 12:31:00", 4000, 80, "2021-11-21 12:36:00"),
       (3, 14, "2021-11-21 12:40:00", 1000, 80, "2021-11-21 12:45:00"),
       (3, 15, "2021-11-21 12:40:00", 3000, 80, "2021-11-21 12:46:00"),
       (3, 1, "2021-11-21 13:40:00", 8000, 80, "2021-11-21 14:20:00"),
       (3, 2, "2021-11-21 13:40:00", 7000, 80, "2021-11-21 13:20:00"),
       (4, 12, "2021-11-21 15:40:00", 4000, 80, "2021-11-21 16:20:00"),
       (4, 13, "2021-11-21 15:40:00", 5000, 80, "2021-11-21 16:20:00"),
       (4, 12, "2021-11-21 16:40:00", 3000, 80, "2021-11-21 17:00:00"),
       (4, 13, "2021-11-21 16:40:00", 2000, 80, "2021-11-21 17:00:00"),
       (2, 14, "2021-11-21 16:50:00", 1000, 80, "2021-11-21 17:20:00"),
       (2, 15, "2021-11-21 16:50:00", 3000, 80, "2021-11-21 17:20:00"),
       
       (1, 10, "2021-11-22 06:46:00", 3000, 80, "2021-11-22 07:00:00"),
	   (3, 14, "2021-11-22 06:40:00", 1000, 80, "2021-11-22 07:10:00"),
       (3, 15, "2021-11-22 06:40:00", 3000, 80, "2021-11-22 07:10:00"),
       (4, 13, "2021-11-22 07:46:00", 5000, 80, "2021-11-22 08:00:00"),
	   (4, 12, "2021-11-22 07:46:00", 4000, 80, "2021-11-22 08:00:00"),
       (1, 11, "2021-11-22 07:30:00", 9000, 80, "2021-11-22 07:45:00"),
       (3, 2, "2021-11-22 07:01:00", 8000, 80, "2021-11-22 08:00:00"),
	   (3, 1, "2021-11-22 07:12:00", 7000, 80, "2021-11-22 08:00:00"),
       (2, 11, "2021-11-22 08:50:00", 10000, 80, "2021-11-22 09:10:00"),
       (3, 4, "2021-11-22 08:50:00", 3000, 80, "2021-11-22 09:10:00"),
       (3, 5, "2021-11-22 08:50:00", 4000, 80, "2021-11-22 09:10:00"),
       (1, 3, "2021-11-22 09:00:00", 4000, 80, "2021-11-22 09:01:00"),
       (1, 10, "2021-11-22 10:00:00", 3000, 80, "2021-11-22 12:00:00"),
       (3, 14, "2021-11-22 12:00:00", 1000, 80, "2021-11-22 12:30:00"),
       (3, 15, "2021-11-22 12:00:00", 3000, 80, "2021-11-22 12:30:00"),
       (3, 14, "2021-11-22 12:31:00", 5000, 80, "2021-11-22 12:36:00"),
       (3, 15, "2021-11-22 12:31:00", 4000, 80, "2021-11-22 12:36:00"),
       (3, 14, "2021-11-22 12:40:00", 1000, 80, "2021-11-22 12:45:00"),
       (3, 15, "2021-11-22 12:40:00", 3000, 80, "2021-11-22 12:46:00"),
       (3, 1, "2021-11-22 13:40:00", 8000, 80, "2021-11-22 14:20:00"),
       (3, 2, "2021-11-22 13:40:00", 7000, 80, "2021-11-22 13:20:00"),
       (4, 12, "2021-11-22 15:40:00", 4000, 80, "2021-11-22 16:20:00"),
       (4, 13, "2021-11-22 15:40:00", 5000, 80, "2021-11-22 16:20:00"),
       (4, 12, "2021-11-22 16:40:00", 3000, 80, "2021-11-22 17:00:00"),
       (4, 13, "2021-11-22 16:40:00", 2000, 80, "2021-11-22 17:00:00"),
       (2, 14, "2021-11-22 16:50:00", 1000, 80, "2021-11-22 17:20:00"),
       (2, 15, "2021-11-22 16:50:00", 3000, 80, "2021-11-22 17:20:00");
       

INSERT INTO RegistroAccessi (ID_Utente, IstanteInizio, IstanteFine, Entrata, Uscita) 
VALUES (1, "2021-11-22 06:50:00", "2021-11-22 06:51:00", 11, 13),
	   (1, "2021-11-22 06:51:00", "2021-11-22 06:55:00", 13, 13),
       (1, "2021-11-22 06:55:00", "2021-11-22 06:56:00", 13, 10),
       (1, "2021-11-22 06:56:00", "2021-11-22 07:30:00", 10, 2),
       (1, "2021-11-22 07:30:00", "2021-11-22 07:31:00", 2, 3),
       (1, "2021-11-22 07:31:00", "2021-11-22 07:50:00", 3, 3),
       (1, "2021-11-22 07:50:00", "2021-11-22 07:51:00", 3, 1),
       (1, "2021-11-22 19:51:00", "2021-11-22 19:52:00", 1, 10),
       (1, "2021-11-22 19:52:00", "2021-11-22 19:53:00", 10, 13),
       (1, "2021-11-22 19:53:00", "2021-11-22 20:00:00", 10, 13),
       (1, "2021-11-22 20:00:00", "2021-11-22 20:01:00", 13, 11),
	   (1, "2021-11-22 20:01:00", "2021-11-22 23:59:00", 11, 11);
       
INSERT INTO RegistroIntrusioni (PercorsoFotografia, Permanenza, IstanteInizio, IstanteFine, Infiltrazione, Fuga)
VALUES ("/foto/intrusioni/fhcbnjfndcmdb.png", 120, "2021-11-22 16:30:00", "2021-11-22 16:32:00", 1, 3),
	   ("/foto/intrusioni/fhcbnjfndfeef1.png", 7200, "2021-11-22 16:32:00", "2021-11-22 18:32:00", 3, 3),
       ("/foto/intrusioni/fhcbnjfndffdSVCD.png", 60, "2021-11-22 18:32:00", "2021-11-22 18:33:00", 3, 1),
       ("/foto/intrusioni/fhcbnjfddhrdhdbjhreh.png", 300, "2021-11-22 04:00:00", "2021-11-22 04:05:00", 18, 18);

INSERT INTO Serramento (Nome, Aperto, ID_PuntoDiAccesso)
VALUES ("Serramento Porta Ingresso", 1, 1),
	   ("Serramento Finestra Cucina 1", 1, 4),
       ("Serramento Finestra Cucina 2", 1, 5),
       ("Serramento Finestra Sala 1", 1, 6),
       ("Serramento Finestra Sala 2", 1, 7),
       ("Serramento Finestra Stanzino", 1, 9),
       ("Serramento Finestra Camera Alex", 1, 12),
       ("Serramento Finestra Bagno", 1, 14),
       ("Serramento Finestra Camera Guglielmo", 1, 16),
       ("Serramento Finestra Camera Lorenzo e Matilde", 1, 18),
       ("Serramento Lucernario", 1, 20);

INSERT INTO RegistroSerramenti (ID_Serramento, Istante, StatoIstantaneo, ID_Utente)
VALUES (1, "2021-11-22 07:00:00", 1, 1),
	   (2, "2021-11-22 07:00:00", 1, 1),
	   (3, "2021-11-22 07:00:00", 1, 1),
       (4, "2021-11-22 07:00:00", 1, 1),
       (5, "2021-11-22 07:00:00", 1, 1),
       (6, "2021-11-22 07:00:00", 1, 1),
       (7, "2021-11-22 07:00:00", 1, 1),
       (8, "2021-11-22 07:00:00", 1, 1),
       (9, "2021-11-22 07:00:00", 1, 1),
       (10, "2021-11-22 07:00:00", 1, 1),
       (11, "2021-11-22 07:00:00", 1, 1),
       (1, "2021-11-22 22:00:00", 1, 4),
	   (2, "2021-11-22 22:00:00", 1, 4),
	   (3, "2021-11-22 22:00:00", 1, 4),
       (4, "2021-11-22 22:00:00", 1, 4),
       (5, "2021-11-22 22:00:00", 1, 4),
       (6, "2021-11-22 22:00:00", 1, 4),
       (7, "2021-11-22 22:00:00", 1, 4),
       (8, "2021-11-22 22:00:00", 1, 4),
       (9, "2021-11-22 22:00:00", 1, 4),
       (10, "2021-11-22 22:00:00", 1, 4),
       (11, "2021-11-22 22:00:00", 1, 4);

#TRUNCATE TABLE FasciaOraria;
INSERT INTO FasciaOraria (OraInizio, OraFine, Prezzo)
VALUES  ("08:00:00","18:59:59",0.096),
        ("19:00:00","23:59:59",0.087),
        ("00:00:00","07:59:59",0.071);

DROP PROCEDURE IF EXISTS InizializzaContatore;
DELIMITER $$
CREATE PROCEDURE InizializzaContatore()
BEGIN
	DECLARE istante TIMESTAMP DEFAULT "2021-11-12 00:00:00";
	DECLARE fascia_oraria INT DEFAULT 0;
    DECLARE randm INT DEFAULT NULL;
    DECLARE acquisto_elettrica FLOAT DEFAULT 0;
    DECLARE vendita_elettrica FLOAT DEFAULT 0;
    DECLARE potenza_totale FLOAT DEFAULT 0;
    
    SET @QuerySQL = 'INSERT INTO ContatoreBidirezionale (Istante, AcquistoReteElettrica, VenditaReteElettrica, PotenzaTotaleAbitazione, ID_FasciaOraria)
					 VALUES (?, ?, ?, ?, ?);';
	PREPARE InserisciInContatore
	FROM @QuerySQL;
    
	ciclo: LOOP
		IF (HOUR(istante) >= 8 AND HOUR(istante) < 19) THEN
			SET fascia_oraria = 1;
		ELSEIF (HOUR(istante) >= 19 AND HOUR(istante) < 24) THEN
			SET fascia_oraria = 2;
		ELSEIF (HOUR(istante) >= 0 AND HOUR(istante) < 8) THEN 
			SET fascia_oraria = 3;
        END IF;
        SET randm = FLOOR(RAND()*(1-0)+0.5);		# vale 0 se acquisto, 1 se vendita
        IF randm = 0 THEN
			# ACQUISTO
            IF fascia_oraria = 3 THEN				# la notte
				SET acquisto_elettrica = RAND()*(1-0)+0.5;
            ELSE 
				SET acquisto_elettrica = RAND()*(5-1)+0.5;
			END IF;
            SET potenza_totale = acquisto_elettrica + (acquisto_elettrica/100)*30;
            SET vendita_elettrica = 0;
		ELSEIF randm = 1 THEN
			# VENDITA
            SET acquisto_elettrica = 0;
            IF fascia_oraria = 3 AND TIME(istante) > '00:05:00' THEN				# la notte
				SET vendita_elettrica = 0;
                SET istante = istante + INTERVAL 8 HOUR;
            ELSE 
				SET vendita_elettrica = RAND()*(5-1)+0.5;
			END IF;
            SET potenza_totale = vendita_elettrica - (vendita_elettrica/100)*20;
		END IF;
        
        SET @istante_ = istante;
        SET @acq_elettrica_ = acquisto_elettrica;
        SET @vend_elettrica_ = vendita_elettrica;
        SET @pot_tot_ = potenza_totale;
        SET @fascia_ = fascia_oraria;
        
		EXECUTE InserisciInContatore
        USING @istante_, @acq_elettrica_, @vend_elettrica_, @pot_tot_, @fascia_;
        
        -- INSERT INTO ContatoreBidirezionale (Istante, AcquistoReteElettrica, VenditaReteElettrica, PotenzaTotaleAbitazione, ID_FasciaOraria)
        -- VALUES (istante, acquisto_elettrica, vendita_elettrica, potenza_totale, fascia_oraria);
        SET istante = istante + INTERVAL 5 MINUTE;
        IF (DATEDIFF(istante, "2021-11-26 23:50:01") > 0) THEN
			LEAVE ciclo;
        END IF;
    END LOOP;
END $$
DELIMITER ;

CALL InizializzaContatore();

-- Questo è un popolamento riferito alla prima Analytics
INSERT INTO RangeTemperatura (ID_Colore, TemperaturaMinima, TemperaturaMassima, ColoreEsadecimale)
VALUES ('c1', 1000, 2000, "e80e25"), 
	   ('c2', 2000, 2700, "e8960e"),
	   ('c3', 2700, 3900, "e8de0e"),
	   ('c4', 3900, 5500, "ffffff"),
	   ('c5', 5500, 6500, "0ee7f1"),
	   ('c6', 6500, 7300, "0f88f2"),
	   ('c7', 7300, NULL, "130ff2");