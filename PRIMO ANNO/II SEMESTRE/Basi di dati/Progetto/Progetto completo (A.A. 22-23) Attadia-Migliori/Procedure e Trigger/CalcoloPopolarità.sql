USE filmsphere;

DROP TRIGGER IF EXISTS calcoloPopolaritàPremio;
DELIMITER $$
CREATE TRIGGER calcoloPopolaritàPremio
AFTER INSERT ON Premi
FOR EACH ROW
BEGIN
    DECLARE P INT;

    SELECT Popolarità INTO P
    FROM Persone
    WHERE NEW.Persona = ID;
    
    IF P IS NOT NULL THEN
        UPDATE Persone
        SET Popolarità = P + 40
        WHERE NEW.Persona = Persone.ID;
    END IF;
END $$

DELIMITER ;

-- ########################################

DROP TRIGGER IF EXISTS calcoloPopolaritàInterpretazione;
DELIMITER $$
CREATE TRIGGER calcoloPopolaritàInterpretazione
AFTER INSERT ON Interpretazioni
FOR EACH ROW

BEGIN
	DECLARE P INT;
    DECLARE I INT;
    
    SELECT 1 INTO I
    FROM Interpretazioni
    WHERE Attore = NEW.Attore
    GROUP BY Film HAVING Count(*) >= 8;

    SELECT Popolarità INTO P
    FROM Persone
    WHERE NEW.Attore = ID;
    
    IF P IS NOT NULL AND I IS NOT NULL THEN
        UPDATE Persone
        SET Popolarità = P + 20
        WHERE NEW.Attore = Persone.ID;
    END IF;
END $$

DELIMITER ;

-- ########################################

DROP TRIGGER IF EXISTS calcoloPopolaritàRegie;
DELIMITER $$
CREATE TRIGGER calcoloPopolaritàRegie
AFTER INSERT ON Regie
FOR EACH ROW

BEGIN
	DECLARE P INT;
	DECLARE R INT;
    
    SELECT 1 INTO R
    FROM Regie
    WHERE Regista = NEW.Regista
    GROUP BY Film HAVING Count(*) >= 4;

    SELECT Popolarità INTO P
    FROM Persone
    WHERE NEW.Regista = ID;
    
    IF P IS NOT NULL AND R IS NOT NULL THEN
        UPDATE Persone
        SET Popolarità = P + 20
        WHERE NEW.Regista = Persone.ID;
    END IF;
END $$

DELIMITER ;

-- ########################################

DROP TRIGGER IF EXISTS calcoloPopolaritàNazionalità;
DELIMITER $$
CREATE TRIGGER calcoloPopolaritàNazionalità
BEFORE INSERT ON Persone
FOR EACH ROW

BEGIN
	DECLARE P INT;
    DECLARE N varchar(45);
    
	-- se la nazionalità dell'attore combacia con un Paese della Top10, allora assegna un punto
	SELECT 1 INTO N
	FROM (
		SELECT PaeseProduzione AS Paese, COUNT(*) AS NumeroFilm, RANK() OVER (ORDER BY COUNT(*) DESC) AS Posizione
		FROM Film F
		GROUP BY PaeseProduzione
		LIMIT 10
	) AS TP 	-- TP -> TopPaesi
	WHERE TP.Paese = New.Nazionalità;
    
    SELECT Popolarità INTO P
    FROM Persone
    WHERE NEW.ID = ID;
    
    IF P IS NOT NULL AND N IS NOT NULL THEN
        UPDATE Persone
        SET Popolarità = P + 10
        WHERE NEW.ID = Persone.ID;
    END IF;
END $$

DELIMITER ;

-- ########################################