USE filmsphere;

-- CALCOLO PUNTEGGIO MEDIO INSERT
DROP TRIGGER IF EXISTS calcoloPunteggioFilmIns;
DELIMITER $$
CREATE TRIGGER calcoloPunteggioFilmIns
AFTER INSERT ON Recensioni
FOR EACH ROW

BEGIN
	DECLARE newMedia FLOAT;
    DECLARE Spunta boolean;
    
    SELECT Verificato INTO Spunta -- controlla se l'utente è verificato
    FROM Utenti
    WHERE ID = NEW.Utente;
    
	SELECT AVG(Voto) INTO newMedia
    FROM Recensioni R
    INNER JOIN Utenti U ON R.Utente = U.ID
    WHERE R.Film = NEW.Film AND U.Verificato = Spunta
    GROUP BY R.Film;
    
    IF Spunta = True THEN
        UPDATE Film
        SET PunteggioCritica = newMedia
        WHERE ID = New.Film;
    ELSE
        UPDATE Film
        SET PunteggioPubblico = newMedia
        WHERE ID = New.Film;
    END IF;

	/*
	DECLARE FilmID INT;
    DECLARE Punteggio FLOAT;
    DECLARE UtenteVerificato Boolean;
    
    SELECT Film INTO FilmID -- trova il film
    FROM Recensioni 
    WHERE Film = NEW.Film;
    
    SELECT AVG(Punteggio) INTO Punteggio -- calcola il punteggio medio per quel film (con ID = FilmID)
    FROM Recensioni
    WHERE Film = FilmID;

    SELECT Verificato INTO UtenteVerificato -- controlla se l'utente è verificato
    FROM Utenti
    WHERE Nickname = NEW.Utente;
    
    -- Aggiorna il punteggio medio in base alla verifica dell'utente
    IF UtenteVerificato = TRUE THEN
        UPDATE Film
        SET PunteggioMedioCritica = Risultato
        WHERE ID = FilmID;
    ELSE
        UPDATE Film
        SET PunteggioMedioPubblico = Risultato
        WHERE ID = FilmID;
    END IF;
    */

END $$

DELIMITER ;

-- CALCOLO PUNTEGGIO MEDIO DELETE
DROP TRIGGER IF EXISTS calcoloPunteggioFilmDel;
DELIMITER $$
CREATE TRIGGER calcoloPunteggioFilmDel
AFTER DELETE ON Recensioni
FOR EACH ROW

BEGIN
	DECLARE newMedia FLOAT;
    DECLARE Spunta boolean;
    
    SELECT Verificato INTO Spunta -- controlla se l'utente è verificato
    FROM Utenti
    WHERE ID = OLD.Utente;
    
	SELECT R.Film, AVG(Voto) INTO newMedia
    FROM Recensioni R
    INNER JOIN Utenti U ON R.Utente = U.ID
    WHERE R.Film = OLD.Film AND U.Verificato = Spunta
    GROUP BY R.Film;
    
    IF Spunta = True THEN
        UPDATE Film
        SET PunteggioCritica = newMedia
        WHERE ID = OLD.Film;
    ELSE
        UPDATE Film
        SET PunteggioPubblico = newMedia
        WHERE ID = OLD.Film;
    END IF;
    
    /*
    SELECT COUNT(*) INTO UtenteVerificato -- controlla se l'utente è verificato
    FROM Utente
    WHERE Nickname = NEW.Utente AND Verificato = True;
    
    
    SELECT Verificato INTO UtenteVerificato -- controlla se l'utente è verificato
    FROM Utente
    WHERE Nickname = OLD.Utente;
    
    -- Aggiorna il punteggio medio in base alla verifica dell'utente
    IF UtenteVerificato = TRUE THEN
        UPDATE Film
        SET PunteggioMedioCritica = Risultato
        WHERE ID = FilmID;
    ELSE
        UPDATE Film
        SET PunteggioMedioPubblico = Risultato
        WHERE ID = FilmID;
    END IF;
    */

END $$

DELIMITER ;