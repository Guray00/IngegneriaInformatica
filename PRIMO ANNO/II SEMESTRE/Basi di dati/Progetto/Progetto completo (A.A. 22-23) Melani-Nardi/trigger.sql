-- ----------------------------------------------------
-- TRIGGER
-- ----------------------------------------------------
-- Trigger 1: Controllo password tabella utenti, minimo 6 caratteri max 20
-- ----------------------------------------------------
DROP TRIGGER IF EXISTS Controllo_password;
DELIMITER $$
	CREATE TRIGGER Controllo_password
    BEFORE INSERT ON Utente 
	FOR EACH ROW
	BEGIN
    IF CHAR_LENGTH(NEW.Password) < 6 OR CHAR_LENGTH(NEW.Password) > 20 
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La lunghezza della password deve essere compresa tra 6 e 20 caratteri';
		END IF;
	END $$
DELIMITER ;

-- ----------------------------------------------------
-- Trigger 2: Controlli ed aggiornamento su Stelle Critici+VotoTotale, Stelle Utenti+VotoTotale e BitrateTotale+Banda Disponibile  
 -- ----------------------------------------------------
-- Trigger 2a: Stelle Critici
-- ----------------------------------------------------
    DROP TRIGGER IF EXISTS Stelle_Critici;
	DELIMITER $$
	CREATE TRIGGER Stelle_Critici 
	AFTER insert on Critica 
	FOR EACH ROW 
  	BEGIN 
		DECLARE c1 int;
        DECLARE c2 int;
        SELECT COUNT(*) INTO c1
        FROM RecensioneUtente 
        WHERE Film = NEW.Film;
        SELECT COUNT(*) INTO c2
        FROM Critica 
        WHERE Film = NEW.Film;
		UPDATE Film f
		SET f.StelleCritici = f.StelleCritici+ NEW.ValutazioneC
        WHERE f.ID = NEW.Film;
        UPDATE Film
        SET VotoTotale = ((3*(StelleCritici))+ (2*StelleUtenti)) / (5*(c1+c2)) 
        WHERE ID = NEW.Film;
        END $$
      DELIMITER ;
-- ----------------------------------------------------
-- Trigger 2b: Stelle Utenti
-- ----------------------------------------------------
DROP TRIGGER IF EXISTS Stelle_Utenti;
  DELIMITER $$
        
CREATE TRIGGER Stelle_Utenti 
        AFTER insert on RecensioneUtente 
        FOR EACH ROW 
        BEGIN 
        DECLARE c1 int;
        DECLARE c2 int;
        SELECT COUNT(*) INTO c1
        FROM RecensioneUtente 
        WHERE Film= NEW.Film;
        SELECT COUNT(*) INTO c2
        FROM Critica 
        WHERE Film= NEW.Film;
        UPDATE Film f
        SET f.StelleUtenti= f.StelleUtenti+ NEW.ValutazioneU
        WHERE f.ID = NEW.Film;
        UPDATE Film
        SET VotoTotale = ((3*StelleCritici)+ (2*(StelleUtenti))) / (5*(c1+c2)) 
        WHERE ID = NEW.Film;
        END $$
	DELIMITER ;
-- ----------------------------------------------------
-- Trigger 2c: BitrateTotale e BandaDisponibile
-- ----------------------------------------------------
DROP TRIGGER IF EXISTS Bit_totale;
        DELIMITER $$
CREATE TRIGGER Bit_totale
        BEFORE insert on File 
        FOR EACH ROW 
        BEGIN 
        DECLARE audio int;
        DECLARE video int;
        DECLARE aux int;
        SELECT Bitrate into audio
        FROM FormatoAudio 
        WHERE Codice = NEW.FormatoAudio;
        SELECT Bitrate into video
        FROM FormatoVideo
        WHERE Codice = NEW.FormatoVideo;
        SET aux = audio+video;
        SET NEW.BitrateTotale = aux;
        END $$
	DELIMITER ;
    
    
DROP TRIGGER IF EXISTS Banda_Disponibile;
	DELIMITER $$
		CREATE TRIGGER Banda_Disponibile
        AFTER insert on Erogazione 
        FOR EACH ROW 
        BEGIN 
        DECLARE totbit int;
	SELECT BitrateTotale INTO totbit 
        FROM File f 
        WHERE f.IDFile = NEW.File;
        IF NEW.OraFine IS NULL THEN
        UPDATE Server s
        SET s.BandaDisponibile = s.BandaDisponibile - totbit
        WHERE s.IDServer = NEW.Server;
        END IF;
        END $$
	DELIMITER ;


-- ----------------------------------------------------
-- Trigger 3: Controllo numero di cifre della carta di credito per la sua validità (devono essere 16)
-- ----------------------------------------------------


DROP TRIGGER IF EXISTS Controllo_carta;
DELIMITER $$
	CREATE TRIGGER Controllo_carta
    BEFORE INSERT ON CartadiCredito
	FOR EACH ROW
	BEGIN
    IF CHAR_LENGTH(cast(NEW.NumeroCarta as char)) != 16 
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La lunghezza del numero della carta deve essere di 16 cifre';
		END IF;
	END $$
DELIMITER ;
-- ----------------------------------------------------
-- Trigger 4: Controllo numero di dispositivi connessi dallo stesso utente e impedisce la nuova connessione se sono maggiori di 2 
-- ----------------------------------------------------

DROP TRIGGER IF EXISTS Connessionedispositivi;
DELIMITER $$
	CREATE TRIGGER Connessionedispositivi
	BEFORE INSERT ON Connessione
	FOR EACH ROW
	BEGIN
    DECLARE q int;
	SELECT COUNT(*) into q
    FROM Connessione c INNER JOIN Dispositivo d ON c.Dispositivo= d.IDDispositivo
	WHERE d.Utente = (SELECT Utente 
			 FROM Dispositivo s
                         WHERE s.IDDispositivo = NEW.Dispositivo ) AND c.OraFine IS NULL;
	IF q >=2 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il numero dei dispositivi connessi deve essere minore di 2';
	END IF;
	END $$;
DELIMITER ;