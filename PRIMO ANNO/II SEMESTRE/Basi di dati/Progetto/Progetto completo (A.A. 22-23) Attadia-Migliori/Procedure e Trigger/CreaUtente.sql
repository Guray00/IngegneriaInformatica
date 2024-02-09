USE filmsphere;

DROP PROCEDURE IF EXISTS creaUtente;
DELIMITER $$
CREATE PROCEDURE creaUtente(IN Paese VARCHAR(45), IN Nickname_ VARCHAR(45), IN Nome_ VARCHAR(45), IN Cognome_ VARCHAR(45), IN Email_ VARCHAR(45), IN Password__ VARCHAR(200), IN Abbonamento varchar(45),
IN CVC_ VARCHAR(3), IN NomeCarta VARCHAR(45), IN CognomeCarta VARCHAR(45), IN Numero_ VARCHAR(45), IN AnnoScadenza_ INT, IN MeseScadenza_ INT)

BEGIN
	DECLARE UtenteID INT;
    
	IF EXISTS (SELECT 1 FROM Utenti U WHERE Nickname_ = U.Nickname) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nickname già esistente, scegliere un altro nickname.';
	END IF;
    
    IF EXISTS (SELECT 1 FROM Utenti U WHERE Email_ = U.Email) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Indirizzo già esistente.';
        END IF;
        
	-- nota, non si fa alcun check sulla password perché si suppone che venga inserito l'hash e non la password in chiaro
        
	IF NOT EXISTS (
		SELECT 1 
		FROM (
			SELECT A.Nome
			FROM Abbonamenti A 
			RIGHT OUTER JOIN RestAbbonamenti R ON A.Nome = R.Abbonamento
			WHERE A.Nome IS NOT NULL
		) AS AbbDisp
		WHERE AbbDisp.Nome = Abbonamento
	) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Abbonamento non disponibile in questo Paese.';
    END IF;
    
    IF EXISTS (
		SELECT 1 
        FROM CarteDiCredito C
        WHERE C.Numero = Numero_
	) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Carta già registrata.';
    END IF;
    
	IF YEAR(current_date()) >= CONCAT(20, AnnoScadenza_) AND MONTH(current_date()) >= MeseScadenza_ THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Carta Scaduta.';
	END IF;
    
    IF Length(Numero_) <> 16 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Numero di carta non valido.';
    END IF;
    
     IF Length(CVC_) <> 3 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CVC non valido.';
    END IF;
        
	IF Abbonamento <> 'Basic' THEN
		INSERT INTO Utenti (Nickname, Nome, Cognome, Email, Password_, Verificato, Abbonamento, DataFine)
		VALUES	(Nickname_, Nome_, Cognome_, Email_, Password__, FALSE, Abbonamento_, DATE_ADD(Current_date, INTERVAL 30 DAY));
        
        SELECT LAST_INSERT_ID() INTO UtenteID;
	ELSE
		INSERT INTO Utenti (Nickname, Nome, Cognome, Email, Password_, Verificato, Abbonamento, DataFine)
		VALUES	(Nickname_, Nome_, Cognome_, Email_, Password__, FALSE, 'Basic', NULL);
        
        SELECT LAST_INSERT_ID() INTO UtenteID;
	END IF;
    
    INSERT INTO CarteDiCredito (Numero, Nome, Cognome, CVC, Utente, AnnoScadenza, MeseScadenza)
	VALUES	(Numero_, NomeCarta, CognomeCarta, CVC_, UtenteID, AnnoScadenza_, MeseScadenza_);
    
END $$

DELIMITER ;