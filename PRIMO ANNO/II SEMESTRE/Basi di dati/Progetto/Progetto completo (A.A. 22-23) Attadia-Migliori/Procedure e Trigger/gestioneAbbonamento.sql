USE filmsphere;

-- check data degli abbonamenti

DROP EVENT IF EXISTS checkData;
DELIMITER $$
CREATE EVENT checkData -- controlla gli abbonamenti ed emette una fattura se la data di scadenza coincide con la data corrente
ON SCHEDULE EVERY 1 DAY
STARTS '2023-11-16 01:00' -- l'operazione avverrà ogni giorno all'1:00 di notte
DO
BEGIN
    DECLARE Data_Abbonamento DATE;
    DECLARE UtenteID INT;
    DECLARE finito INT DEFAULT 0;

    DECLARE cursoreDataUtente CURSOR FOR -- il cursore si "muove" su tutti gli utenti
        SELECT ID, DataFine /*, Abbonamento*/
        FROM Utenti;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito = 1;

    OPEN cursoreDataUtente;
    prelevadata: LOOP
        FETCH cursoreDataUtente INTO UtenteID, Data_Abbonamento; -- il cursore preleva l'ID dell'utente e la data di fine dell'abbonamento

        IF finito = 1 THEN
            LEAVE prelevadata; -- a fine ciclo esci dal loop
        END IF;

        IF Data_Abbonamento <= CURRENT_DATE() THEN -- se la data di fine è antecedente alla current date
        
            UPDATE Utenti 
            SET DataFine = NULL AND Abbonamento = NULL -- nessun abbonamento attivo, selezionarne un altro
            WHERE ID = UtenteID;

        END IF;
    END LOOP;
    CLOSE cursoreDataUtente;    
END $$

DELIMITER ;

-- emissione fattura

DROP PROCEDURE IF EXISTS gestioneAbbonamento;
DELIMITER $$
CREATE PROCEDURE gestioneAbbonamento (IN Utente_ INT, IN Abbonamento_ VARCHAR(45), IN Carta_ varchar(16))
BEGIN
	DECLARE Prezzo FLOAT;
    
    IF NOT EXISTS (
		SELECT 1 
		FROM (
			SELECT A.Nome
			FROM Abbonamenti A 
			RIGHT OUTER JOIN RestAbbonamenti R ON A.Nome = R.Abbonamento
			WHERE A.Nome IS NOT NULL
		) AS AbbDisp
		WHERE AbbDisp.Nome = newAbb
	) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Abbonamento non disponibile in questo Paese.';
    END IF;
    
	SELECT Totale INTO Prezzo
	FROM Abbonamenti
	WHERE Nome = Abbonamento_;
    
	INSERT INTO Fatture (Utente, PagamentoCarta, Totale, DataFine)
	VALUES (Utente_, Carta_, Prezzo, current_date());
    
    UPDATE Utente
	SET Abbonamento = Abbonamento_ AND DataFine = adddate(current_date, INTERVAL 30 DAY);
END $$