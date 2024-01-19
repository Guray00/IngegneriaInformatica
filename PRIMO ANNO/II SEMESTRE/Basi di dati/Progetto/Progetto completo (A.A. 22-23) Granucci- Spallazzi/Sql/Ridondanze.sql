-- numeroRecensioni e mediaRecensioni

DROP TRIGGER if exists Numero_Media_Recensioni;
DELIMITER //
CREATE TRIGGER Numero_Media_Recensioni
AFTER INSERT ON `RecensioneUtente`
FOR EACH ROW
BEGIN
    UPDATE film
    SET film.MediaRecensioni = (film.MediaRecensioni *  film.NumeroRecensioni + new.Valore) / (film.NumeroRecensioni + 1),
		film.NumeroRecensioni = film.NumeroRecensioni + 1
    WHERE film.Codice = NEW.film;
END //
DELIMITER ;

-- Banda Attuale e Capacità attuale

DROP TRIGGER if exists Banda_Capacita_Attuale_Insert;
DELIMITER //
CREATE TRIGGER Banda_Capacita_Attuale_Insert
AFTER INSERT ON `Visualizzazione`
FOR EACH ROW
BEGIN
    UPDATE `server`
    SET `server`.BandaAttuale = `server`.BandaAttuale + (select FV.Bitrate + FA.BitRate
														from FilmCodificato FC inner join FormatoVideo FV on FC.FormatoVideo = FV.Codice
															inner join formatoaudio FA on FC.formatoaudio = FA.Codice
														Where FC.Codice = NEW.FilmCodificato),
										
		`server`.CapacitaAttuale = `server`.CapacitaAttuale + 1
    WHERE `server`.Codice = NEW.`Server`;
END //
DELIMITER ;

DROP TRIGGER if exists Banda_Capacita_Attuale_Fine;
DELIMITER //
CREATE TRIGGER Banda_Capacita_Attuale_Fine
AFTER UPDATE ON `Visualizzazione`
FOR EACH ROW
BEGIN
	IF (new.`Fine` IS NOT NULL and old.Fine is null) THEN
		UPDATE `server`
		SET `server`.BandaAttuale = `server`.BandaAttuale - (select FV.Bitrate + FA.BitRate
														from FilmCodificato FC join FormatoVideo FV on FC.FormatoVideo = FV.Codice
															join formatoaudio FA on FC.formatoaudio = FA.Codice
														Where FC.Codice = NEW.FilmCodificato),
										
		`server`.CapacitaAttuale = `server`.CapacitaAttuale - 1
		WHERE `server`.Codice = NEW.`Server`;
	END IF;
END //
DELIMITER ;


-- Connessioni Attali
DROP TRIGGER IF EXISTS Connessioni_Attuali_Insert;
DELIMITER //
CREATE TRIGGER Connessioni_Attuali_Insert
AFTER INSERT ON Connessione 
FOR EACH ROW 
BEGIN 
	UPDATE Utente
    SET Utente.ConnessioniAttive = Utente.ConnessioniAttive + 1
    WHERE Connessione.Utente = Utente.Codice;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS Connessioni_Attuali_Fine;
DELIMITER //
CREATE TRIGGER Connessioni_Attuali_Fine
AFTER Update ON Connessione 
FOR EACH ROW 
BEGIN 
	if(new.Fine is not null and old.Fine is null) THEN
		UPDATE Utente
		SET Utente.ConnessioniAttive = Utente.ConnessioniAttive - 1
		WHERE Connessione.Utente = Utente.Codice;
	END IF;
END //
DELIMITER ;


