Use Azienda;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creazione tabelle

DROP TABLE IF EXISTS Caso;
CREATE TABLE Caso (
	IDcaso INT AUTO_INCREMENT PRIMARY KEY,
    Guasto INT NOT NULL,
    FOREIGN KEY (Guasto) REFERENCES Guasto(CodGuasto)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Sintomo;
CREATE TABLE Sintomo (
	IDsintomo INT AUTO_INCREMENT PRIMARY KEY,
    Descrizione VARCHAR(300)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Sintomatologia;
CREATE TABLE Sintomatologia (
	IDcaso INT,
    IDsintomo INT,
    PRIMARY KEY (IDcaso, IDsintomo),
    FOREIGN KEY (IDcaso) REFERENCES Caso(IDcaso),
    FOREIGN KEY (IDsintomo) REFERENCES Sintomo(IDsintomo)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;


DROP TABLE IF EXISTS Risoluzione;
CREATE TABLE Risoluzione (
	IDcaso INT,
    CodRimedio INT,
    PRIMARY KEY (IDcaso, CodRimedio),
    FOREIGN KEY (IDcaso) REFERENCES Caso(IDcaso),
    FOREIGN KEY (CodRimedio) REFERENCES Rimedio(CodRimedio)
)ENGINE = InnoDB DEFAULT CHARSET = latin1;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Popolamento delle nuove tabelle

INSERT INTO Caso (Guasto)
VALUES	(1),
		(1),
        (4),
        (4),
        (5);
        
INSERT INTO Sintomo (Descrizione)
VALUES	('Lo smartphone si comporta in modo irregolare bloccandosi senza un criterio'),
		('Lo smartphone ci mette più del solito ad accendersi'),
        ('Lo smartphone ha un consumo di batteria più veloce del normale'),
        ('Lo smartphone presenta casualmente pop-up pubblicitari'),   -- 4
        ('Lo smartphone si spegne irregolarmente senza preavviso'),
        ('Il touchscreen non riceve input e non è reattivo'),
        ('I colori dello schermo sono soggetti ad artefatti'),
        ('Lo smartphone è più lento del normale nell''apertura delle applicazioni'),
        ('Lo smartphone presenta applicazioni non installate dall''utente'),
        ('Alcune porte dello smartphone non funzionano correttamente'),
        ('La cassa audio dello smartphone non emette suono');
        
INSERT INTO Sintomatologia (IDcaso, IDsintomo)
VALUES	(1,1),
		(1,2),
        (1,3),
        (3,4),
        (3,5),
        (5,6),
        (5,7),
        (2,8),
        (2,9),
        (4,10),
        (4,11);
        
INSERT INTO Risoluzione (IDcaso, CodRimedio)
VALUES	(1, 2),
		(1, 3),
        (2, 1),
        (2, 13),
        (3, 1),
        (3, 14),
        (4, 15),
        (4, 16),
        (5, 4),
        (5, 17);
        
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Funzioni per la Data Analytics

-- Fase di RETRIEVE

DROP PROCEDURE IF EXISTS Retrieve;
DELIMITER $$
CREATE PROCEDURE Retrieve (IN _IDsintomo INT)
BEGIN
	DECLARE _max INT;
    
-- raccolta dei sintomi dell'utente
	CREATE TEMPORARY TABLE IF NOT EXISTS Sintomi(
		IDsintomo INT
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;
    
    INSERT INTO Sintomi (IDsintomo)
    VALUES	(_IDsintomo);
    
-- costruzione di 2 temporary table, una per contenere i sintomi in comune coi vari casi esistenti, una per i casi affini che verranno individuati
	CREATE TEMPORARY TABLE IF NOT EXISTS SintomiInComune(
		IDcaso INT,
        Numero INT
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS CasiProbabili(
		IDcaso INT,
        Numero INT
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;
    
-- individuazione dei sintomi in comune coi vari casi
	INSERT INTO SintomiInComune (IDcaso, Numero)
		(SELECT SA.IDcaso, COUNT(SI.IDsintomo) AS Numero
		FROM Sintomatologia SA INNER JOIN Sintomi SI ON SA.IDsintomo=SI.IDsintomo
		GROUP BY SA.IDcaso); 
	
-- salvo in una variabile il numero massimo di sintomi in comune individuato tra i vari casi
    SET _max = (SELECT MAX(Numero) FROM SintomiInComune);
    
-- individuazione del caso/i più probabile e inserzione nella temporary table    
    TRUNCATE CasiProbabili;
	INSERT INTO CasiProbabili (IDcaso, Numero)	
		(SELECT IDcaso, Numero
		FROM SintomiInComune 
		WHERE Numero = _max);
	
    TRUNCATE SintomiInComune;

END $$
DELIMITER ;

/* TRUNCATE Sintomi; 
   CALL Retrieve (1); CALL Retrieve (2); CALL Retrieve (4); CALL Retrieve (5); SELECT * FROM CasiProbabili; */





-- Fase di REUSE

DROP PROCEDURE IF EXISTS `Reuse`;
DELIMITER $$
CREATE PROCEDURE `Reuse` ()
BEGIN
-- costruzione di alcuni dati utili a calcolare il punteggio (i sintomi che si hanno in piu rispetto a quello dei casi trovati, e i sintomi mancanti rispetto ai casi trovati)
	DECLARE _sintomiextra INT;
    DECLARE _sintomiincomune INT;
    DECLARE _sintomiposseduti INT;
    
    SET _sintomiposseduti =
		(SELECT COUNT(*)
        FROM Sintomi);
    
    SET _sintomiincomune =
		(SELECT MAX(Numero)
        FROM CasiProbabili);
        
	SET _sintomiextra = _sintomiposseduti - _sintomiincomune;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS SintomiMancanti(
		IDcaso INT,
		Numero INT
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;
    
    TRUNCATE SintomiMancanti;    
	INSERT INTO SintomiMancanti
		(SELECT C.IDcaso, (COUNT(*) - _sintomiincomune)
        FROM CasiProbabili C INNER JOIN Sintomatologia S ON C.IDcaso=S.IDcaso
        GROUP BY C.IDcaso);
        
-- costruzione e popolamento della temporary table target, cioè quella che contiene i rimedi e i giusti punteggi	
    CREATE TEMPORARY TABLE IF NOT EXISTS RimediSuggeriti(
		CodRimedio INT,
		Rimedio VARCHAR(300),
        Punteggio INT
        )ENGINE = InnoDB DEFAULT CHARSET = latin1;
        
    TRUNCATE RimediSuggeriti;    
	INSERT INTO RimediSuggeriti (CodRimedio, Rimedio, Punteggio)
		(SELECT R.CodRimedio, R.Descrizione, (10 - S.Numero - _sintomiextra)
        FROM SintomiMancanti S INNER JOIN Risoluzione Re ON S.IDcaso=Re.IDcaso
        INNER JOIN Rimedio R ON Re.CodRimedio=R.CodRimedio);
        
	SELECT Rimedio, Punteggio 
    FROM RimediSuggeriti
    ORDER BY Punteggio DESC;
    
END $$
DELIMITER ;

-- CALL Reuse;





-- Fase di REVISE

DROP PROCEDURE IF EXISTS Revise;
DELIMITER $$
CREATE PROCEDURE Revise (IN _IDrimedio INT, IN _checkretain BOOL)
BEGIN
	DECLARE _rimediutilizzati INT;
    DECLARE _gradodifferenza INT;
    

	CREATE TEMPORARY TABLE IF NOT EXISTS Soluzioni(
		IDrimedio INT
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;
    
    INSERT INTO Soluzioni (IDrimedio)
    VALUES	(_IDrimedio);
    
	SET _rimediutilizzati =
		(SELECT COUNT(*)
        FROM Soluzioni);
        
        
    CREATE TEMPORARY TABLE IF NOT EXISTS RimediCaso(
		IDcaso INT,
        CodRimedio INT
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;
    
    TRUNCATE RimediCaso;
    INSERT INTO RimediCaso (IDcaso, CodRimedio)
		(SELECT C.IDcaso, R.CodRimedio
		FROM CasiProbabili C INNER JOIN Risoluzione R ON C.IDcaso=R.IDcaso);
        

	CREATE TEMPORARY TABLE IF NOT EXISTS ResocontoCaso(
		IDcaso INT,
        RimediExtra INT,
        RimediInutilizzati INT
	)ENGINE = InnoDB DEFAULT CHARSET = latin1;
    
    TRUNCATE ResocontoCaso;
    INSERT INTO ResocontoCaso
		(SELECT 
			R.IDcaso, 
			(_rimediutilizzati - COUNT(*)), 
			((SELECT COUNT(*) FROM CasiProbabili C INNER JOIN Risoluzione R1 ON C.IDcaso=R1.IDcaso WHERE R1.IDcaso=R.IDcaso GROUP BY C.IDcaso) - COUNT(*)) AS RimediInutilizzati
        FROM Soluzioni S INNER JOIN RimediCaso R ON S.IDrimedio=R.CodRimedio
        GROUP BY R.IDcaso);
	

	SET _gradodifferenza =
		(SELECT MIN(RimediExtra + RimediInutilizzati)
        FROM ResocontoCaso);
	
    IF _gradodifferenza > 2 AND _checkretain = TRUE
    THEN
		CALL `Retain`;
	END IF;

END $$
DELIMITER ;

/* TRUNCATE Soluzioni; CALL Revise(1); CALL Revise(2); CALL Revise(15); SELECT * FROM ResocontoCaso; */





-- Fase di RETAIN

DROP PROCEDURE IF EXISTS `Retain`;
DELIMITER $$
CREATE PROCEDURE `Retain` ()
BEGIN
	DECLARE _lastid INT;
    
	INSERT INTO Caso (Guasto)
	(SELECT C2.Guasto
	FROM CasiProbabili C1 INNER JOIN Caso C2 ON C1.IDcaso=C2.IDcaso
	LIMIT 1);
	
    SET _lastid = LAST_INSERT_ID();
    
    INSERT INTO Sintomatologia (IDcaso, IDsintomo)
    SELECT _lastid, IDsintomo
    FROM Sintomi;
    
    INSERT INTO Risoluzione (IDcaso, CodRimedio)
    SELECT _lastid, IDrimedio
    FROM Soluzioni;
    
END $$
DELIMITER ;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TRUNCATE Soluzioni; TRUNCATE Sintomi; 
-- SELECT * FROM CasiProbabili;			SELECT * FROM ResocontoCaso;		SELECT * FROM Caso;
/*	CALL Retrieve (1); CALL Retrieve (2); CALL Retrieve (4); CALL Retrieve (5); 
	CALL Reuse;
	CALL Revise(1, FALSE); CALL Revise(2, FALSE); CALL Revise(15, TRUE);	*/

