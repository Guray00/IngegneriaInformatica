USE filmsphere;

DROP TRIGGER IF EXISTS verificaAttivitàCritici;
DELIMITER $$
CREATE TRIGGER verificaAttivitàCritici
BEFORE INSERT ON Fatture
FOR EACH ROW
BEGIN
	  DECLARE numeroRecensioni INT;
	  DECLARE Spunta boolean;
	  
	  SELECT Verificato INTO Spunta
	  FROM Utenti 
	  WHERE ID = NEW.Utente;

	  IF Spunta = True THEN
			SELECT COUNT(*) INTO numeroRecensioni
			FROM Recensioni R
			WHERE R.Utente = NEW.Utente AND R.Data_ >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);

			-- Se l'utente ha almeno 3 recensioni recenti, applica lo sconto
			IF numeroRecensioni >= 3 THEN
				SET NEW.Totale = NEW.Totale * 0.5;
			END IF;
	  END IF;
END;