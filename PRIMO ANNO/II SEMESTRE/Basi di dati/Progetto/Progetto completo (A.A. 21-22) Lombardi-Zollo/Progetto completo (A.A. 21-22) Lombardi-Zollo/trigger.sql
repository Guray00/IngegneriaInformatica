/* calcolo di Gravita */
DROP FUNCTION IF EXISTS calcolaGravita;

DELIMITER $$

CREATE FUNCTION calcolaGravita(_lat1 FLOAT, _lat2 FLOAT, _long1 FLOAT, _long2 FLOAT)
RETURNS FLOAT DETERMINISTIC
BEGIN
	DECLARE distanza float;
    /* distanza (A,B) = R * arccos(sin(latA) * sin(latB) + cos(latA) * cos(latB) * cos(lonA-lonB)) (Km) */
	SET distanza = 6372.8 * ACOS( SIN(RADIANS(_lat1)) * SIN(RADIANS(_lat2)) +  COS(RADIANS(_lat1)) * COS(RADIANS(_lat2)) * COS(RADIANS(_long1) - RADIANS(_long2)) );
    IF ( distanza < 1000 ) THEN
		RETURN 10 - distanza/100;
	ELSE 
		RETURN 0;
	END IF;
END $$

DELIMITER ;
/* trigger di inserimento in Eventualita */
DROP TRIGGER IF EXISTS aggungiEventualita;
DELIMITER $$
CREATE TRIGGER aggungiEventualita
AFTER INSERT ON  Calamita
FOR EACH ROW 
BEGIN
	DECLARE finito INTEGER DEFAULT 0;
    DECLARE codEdificio CHAR(5) DEFAULT NULL;
    DECLARE lat FLOAT;
    DECLARE longi FLOAT;
    
    DECLARE cursore CURSOR FOR
		SELECT 	E.CodEdificio, E.Latitudine, E.Longitudine
        FROM 	Edificio E
        WHERE  	E.AreaGeografica = NEW.AreaGeografica;
	
    DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1;
        
	OPEN cursore;
    
    preleva: LOOP
				FETCH cursore INTO codEdificio, lat, longi;
                IF finito = 1 THEN
					LEAVE preleva;
				END IF;
				INSERT INTO Eventualita VALUES(codEdificio, NEW.AreaGeografica, NEW.Data, NEW.Tipo, calcolaGravita(lat, NEW.LatEpicentro, longi, NEW.LongEpicentro));
			END LOOP preleva;
	CLOSE cursore;
END $$
DELIMITER ;

/* trigger di inserimento in Alert */

DROP TRIGGER IF EXISTS inerisciAlert1;
DELIMITER $$
CREATE TRIGGER inerisciAlert1
AFTER INSERT ON  Posizione
FOR EACH ROW 
BEGIN
	DECLARE soglia FLOAT;
    SET soglia = (
				  SELECT S.Soglia
                  FROM Sensore S 
                  WHERE S.IDSensore = NEW.IDSensore
				 );
    
	IF (New.Larghezza > soglia) THEN
		INSERT INTO Alert VALUES (NEW.Timestamp, NEW.Larghezza, NEW.IDSensore);
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS inerisciAlert2;
DELIMITER $$
CREATE TRIGGER inerisciAlert2
AFTER INSERT ON  Temperatura
FOR EACH ROW 
BEGIN
	DECLARE soglia FLOAT;
    SET soglia = (
				  SELECT S.Soglia
                  FROM Sensore S 
                  WHERE S.IDSensore = NEW.IDSensore
				 );
                 
	IF (soglia >= 0 AND NEW.TemperaturaRilevata > soglia) THEN
		INSERT INTO Alert VALUES (NEW.Timestamp, NEW.TemperaturaRilevata, NEW.IDSensore);
	ELSEIF (soglia < 0 AND NEW.TemperaturaRilevata < soglia) THEN
		INSERT INTO Alert VALUES (NEW.Timestamp, NEW.TemperaturaRilevata, NEW.IDSensore);
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS inerisciAlert3;
DELIMITER $$
CREATE TRIGGER inerisciAlert3
AFTER INSERT ON  Pluviometro
FOR EACH ROW 
BEGIN
	DECLARE soglia FLOAT;
    SET soglia = (
				  SELECT S.Soglia
                  FROM Sensore S 
                  WHERE S.IDSensore = NEW.IDSensore
				 );
    
	IF (New.Precipitazione > soglia) THEN
		INSERT INTO Alert VALUES (NEW.Timestamp, NEW.Precipitazione, NEW.IDSensore);
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS inerisciAlert4;
DELIMITER $$
CREATE TRIGGER inerisciAlert4
AFTER INSERT ON  Giroscopio
FOR EACH ROW 
BEGIN
	DECLARE soglia FLOAT;
    DECLARE valore FLOAT;
    
    SET soglia = (
				  SELECT S.Soglia
                  FROM Sensore S 
                  WHERE S.IDSensore = NEW.IDSensore
				 );
                 
	SET valore = SQRT(POWER(NEW.Wx,2) + POWER(NEW.Wy,2) + POWER(NEW.Wz,2));
    
	IF (valore > soglia) THEN
		INSERT INTO Alert VALUES (NEW.Timestamp, valore, NEW.IDSensore);
	END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS inerisciAlert5;
DELIMITER $$
CREATE TRIGGER inerisciAlert5
AFTER INSERT ON  Accelerometro
FOR EACH ROW 
BEGIN
	DECLARE soglia FLOAT;
    DECLARE valore FLOAT;
    
    SET soglia = (
				  SELECT S.Soglia
                  FROM Sensore S 
                  WHERE S.IDSensore = NEW.IDSensore
				 );
                 
	SET valore = SQRT(POWER(NEW.X,2) + POWER(NEW.Y,2) + POWER(NEW.Z,2));
    
	IF (valore > soglia) THEN
		INSERT INTO Alert VALUES (NEW.Timestamp, valore, NEW.IDSensore);
	END IF;
END $$
DELIMITER ;

/* ======================================================================================================================== */
/* ============================================ VINCOLI DI INTEGRITA' REFERENZIALE ======================================== */
/* ======================================================================================================================== */

/* L'attributo Capo in LavoriTurno non può contenere valori non presenti in CFisc di Capo */
DROP TRIGGER IF EXISTS lavoriTurnoCapo;
DELIMITER $$
CREATE TRIGGER lavoriTurnoCapo
BEFORE INSERT ON  LavoriTurno
FOR EACH ROW 
BEGIN
	
	IF ( (NEW.Capo IS NOT NULL AND NEW.Capo NOT IN (
													SELECT CFisc
                                                    FROM CapoCantiere
												  )) OR
                                                  (NEW.Capo IS NULL AND NEW.Capo NOT IN (
																						  SELECT CFisc
																						  FROM CapoCantiere 
																						)) 
		) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Capo non esistente';
	END IF;
	
END $$
DELIMITER ;


/* L'attributo CodEdificio in Progetto non può contenere valori non presenti in CodEdidifio di Edificio */

DROP TRIGGER IF EXISTS verificaCodEdificioProgetto;
DELIMITER $$
CREATE TRIGGER verificaCodEdificioProgetto
BEFORE INSERT ON  Progetto
FOR EACH ROW 
BEGIN
	
	IF ( NEW.CodEdificio NOT IN ( 
								  SELECT CodEdificio
                                  FROM Edificio
								)) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CodEdificio non esistente';
	END IF;

END $$
DELIMITER ;

/* L'attributo CFisc in Turno non può contenere valori non presenti in CFisc di CapoCantiere e Operaio */

DROP TRIGGER IF EXISTS verificaCFiscTurno;
DELIMITER $$
CREATE TRIGGER verificaCFiscTurno
BEFORE INSERT ON  Turno
FOR EACH ROW 
BEGIN
	
	IF ( NEW.CFisc NOT IN ( 
							SELECT CFisc
                            FROM CapoCantiere
						   ) 
                           AND
		 NEW.CFisc NOT IN ( 
							SELECT CFisc
                            FROM Operaio
						   )
        ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CFisc non esistente';
	END IF;

END $$
DELIMITER ;

/* ======================================================================================================================== */
/* ============================================ VINCOLI DI INTEGRITA' GENERICI ============================================ */
/* ======================================================================================================================== */

/* Un Operaio non può avere un Capo diverso dal suo */
DROP TRIGGER IF EXISTS controllaCapoeOperaio;
DELIMITER $$
CREATE TRIGGER controllaCapoeOperaio
BEFORE INSERT ON  LavoriTurno
FOR EACH ROW 
BEGIN
    IF ( NEW.Capo IS NOT NULL AND NEW.CFiscLavoratore NOT IN (
															  SELECT CFisc
                                                              FROM Operaio
                                                              WHERE CapoCantiere = NEW.Capo
															  )  ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Coppia Lavorare Capo non corretta';
	END IF;

END $$
DELIMITER ;

/* Un Punto d'Accesso Interno collega 2 vani */

DROP TRIGGER IF EXISTS verificaPAInterno;
DELIMITER $$
CREATE TRIGGER verificaPAInterno
BEFORE INSERT ON  AccessoI
FOR EACH ROW 
BEGIN
	DECLARE nVaniCollegati INT;
    SET nVaniCollegati = (
						   SELECT COUNT(*)
                           FROM AccessoI
                           WHERE NEW.IDPuntoAccesso = IDPuntoAccesso
						 );
	IF ( nVaniCollegati = 2 ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il punto di accesso collega già 2 vani';
	END IF;

END $$
DELIMITER ;

/* L'Edificio in Materiale deve corrispondere all'Edificio del Lavoro */

DROP TRIGGER IF EXISTS verificaEdificioInMateriale;
DELIMITER $$
CREATE TRIGGER verificaEdificioInMateriale
BEFORE INSERT ON  Materiale
FOR EACH ROW 
BEGIN
	DECLARE edificioProgetto CHAR(5);
    SET edificioProgetto = (
							SELECT P.CodEdificio
                            FROM Progetto P 
								 INNER JOIN
                                 Lavoro L ON P.CodProgetto = L.CodProgetto
							WHERE L.CodLavoro = NEW.CodLavoro
                           );
	IF ( NEW.Edificio <> edificioProgetto ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Edificio non corrispondente a quello del Progetto';
	END IF;

END $$
DELIMITER ;

/* Un lavoratore non può svolgere contemporaneamente più lavori */

DROP TRIGGER IF EXISTS verificaLavoriTurnoLavoratore;
DELIMITER $$
CREATE TRIGGER verificaLavoriTurnoLavoratore
BEFORE INSERT ON  LavoriTurno
FOR EACH ROW 
BEGIN
	IF ( 0 <> ( 
				SELECT Count(*)
                FROM LavoriTurno L
                WHERE L.CFiscLavoratore = NEW.CFiscLavoratore
					  AND
                      L.Data = NEW.Data
                      AND
                      NEW.OraInizio BETWEEN L.OraInizio AND L.OraInizio + L.NumeroOre
		      ) )THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Edificio non corrispondente a quello del Progetto';
	END IF;
END $$
DELIMITER ;

/* ========================================================================================================== */
/* ============================================ VINCOLI DI TUPLA ============================================ */
/* ========================================================================================================== */

/* L'attributo Tipo in Calamita deve essere una stringa "Sismico" o "Idrogeologico" */

DROP TRIGGER IF EXISTS tipoCalamita;
DELIMITER $$
CREATE TRIGGER tipoCalamita
BEFORE INSERT ON  Calamita
FOR EACH ROW 
BEGIN
	
	IF ( NEW.Tipo NOT IN ("Sismico","Calamita") ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo Tipo errato';
	END IF;

END $$
DELIMITER ;

/* L'attributo Gravita in Eventualita deve essere un intero compreso fra 0 e 100 */

DROP TRIGGER IF EXISTS gravitaEventualita;
DELIMITER $$
CREATE TRIGGER gravitaEventualita
BEFORE INSERT ON  Eventualita
FOR EACH ROW 
BEGIN
	
	IF ( NOT NEW.Gravita BETWEEN 0 AND 100 ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo Gravita errato';
	END IF;

END $$
DELIMITER ;


/* L'attributo Orientamento in Finestra deve essere una stringa fra le seguenti: "Nord","Sud","Est","Ovest","NordEst","NordOvest","SudEst","SudOvest" */

DROP TRIGGER IF EXISTS orientamentoFinestra;
DELIMITER $$
CREATE TRIGGER orientamentoFinestra
BEFORE INSERT ON  Finestra
FOR EACH ROW 
BEGIN
	
	IF ( NEW.Orientamento NOT IN ("Nord","Sud","Est","Ovest","NordEst","NordOvest","SudEst","SudOvest") ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo Orientamento errato';
	END IF;

END $$
DELIMITER ;

/* L'attributo Orientamento in PA\_Esterno deve essere una stringa fra le seguenti: "Nord","Sud","Est","Ovest","NordEst","NordOvest","SudEst","SudOvest" */

DROP TRIGGER IF EXISTS orientamentoPA_Esterno;
DELIMITER $$
CREATE TRIGGER orientamentoPA_Esterno
BEFORE INSERT ON  PuntoAccessoEsterno
FOR EACH ROW 
BEGIN
	
	IF ( NEW.Orientamento NOT IN ("Nord","Sud","Est","Ovest","NordEst","NordOvest","SudEst","SudOvest") ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo Orientamento errato';
	END IF;

END $$
DELIMITER ;

/* L'attributo Tipologia in Sensore deve essere una stringa fra le seguenti: "Giroscopio","Temperatura","Posizione","Pluviometro","Accelerometro" */

DROP TRIGGER IF EXISTS tipologiaSensore;
DELIMITER $$
CREATE TRIGGER tipologiaSensore
BEFORE INSERT ON  Sensore
FOR EACH ROW 
BEGIN
	
	IF ( NEW.Tipologia NOT IN ("Giroscopio","Temperatura","Posizione","Pluviometro","Accelerometro") ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo Tipologia errato';
	END IF;

END $$
DELIMITER ;

/* L'attributo Tipo in Materiale deve essere una stringa fra le seguenti: "Pietra","Intonaco","Altro","Piastrella","Mattone" */

DROP TRIGGER IF EXISTS tipoMateriale;
DELIMITER $$
CREATE TRIGGER tipoMateriale
BEFORE INSERT ON  Materiale
FOR EACH ROW 
BEGIN
	
	IF ( NEW.Tipo NOT IN ("Pietra","Intonaco","Altro","Piastrella","Mattone") ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo Tipo errato';
	END IF;

END $$
DELIMITER ;

/* L'attributo Orario in Turno deve essere una stringa fra le seguenti: "Mattutino","Pomeridiano" */

DROP TRIGGER IF EXISTS orarioTurno;
DELIMITER $$
CREATE TRIGGER orarioTurno
BEFORE INSERT ON  Turno
FOR EACH ROW 
BEGIN
	
	IF ( NEW.Orario NOT IN ("Mattutino","Pomeridiano") ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo Orario errato';
	END IF;

END $$
DELIMITER ;

/* L'attributo OraInizio in LavoriTurno deve essere compreso tra 7 e 18 */

DROP TRIGGER IF EXISTS orarioInizioTurno;
DELIMITER $$
CREATE TRIGGER orarioInizioTurno
BEFORE INSERT ON  LavoriTurno
FOR EACH ROW 
BEGIN
	
	IF ( NOT NEW.OraInizio BETWEEN 7 AND 18 ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo OraInizio errato';
	END IF;

	IF ( NEW.Orario = "Mattutino" AND NOT NEW.OraInizio BETWEEN 7 AND 11 ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo OraInizio errato';
	END IF;

	IF ( NEW.Orario = "Pomeridiano" AND NOT NEW.OraInizio BETWEEN 12 AND 18 ) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attributo OraInizio errato';
	END IF;

END $$
DELIMITER ;


/* Le Date in Progetto devono essere coerenti temporalmente */
DROP TRIGGER IF EXISTS dateProgetto;
DELIMITER $$
CREATE TRIGGER dateProgetto
BEFORE INSERT ON  Progetto
FOR EACH ROW 
BEGIN
	IF	(
			NEW.DataPresentazione > NEW.DataApprovazione
			OR
			NEW.DataApprovazione > NEW.DataInizio
			OR
			NEW.DataInizio > NEW.StimaDataFine
		)	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Date inesatte.';
	END IF;

END $$
DELIMITER ;

/* In Edificio, l'attributo Latitudine è compreso fra -90 e 90, e l'attributo Longitudine tra -180 e 180 */
DROP TRIGGER IF EXISTS controlloLatLong;
DELIMITER $$
CREATE TRIGGER controlloLatLong
BEFORE INSERT ON  Edificio
FOR EACH ROW 
BEGIN
	IF	(
			NOT NEW.Latitudine BETWEEN -90 AND 90
			OR
			NOT NEW.Longitudine BETWEEN -180 AND 180
		)	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Valore di Latitudine o Longitudine errato';
	END IF;

END $$
DELIMITER ;

/* In Calamita, l'attributo LatEpicentro è compreso fra -90 e 90, e l'attributo LongEpicentro tra -180 e 180 */
DROP TRIGGER IF EXISTS controlloLatEpicentroLongEpicentro;
DELIMITER $$
CREATE TRIGGER controlloLatEpicentroLongEpicentro
BEFORE INSERT ON  Calamita
FOR EACH ROW 
BEGIN
	IF	(
			NOT NEW.LatEpicentro BETWEEN -90 AND 90
			OR
			NOT NEW.LongEpicentro BETWEEN -180 AND 180
		)	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Valore di LatEpicentro o LongEpicentro errato';
	END IF;

END $$
DELIMITER ;
