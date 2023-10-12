
DROP TRIGGER IF EXISTS blocca_costo_materialegenerico;
DROP TRIGGER IF EXISTS blocca_attributi_pietra;
DROP TRIGGER IF EXISTS blocca_turni_turnolavoratore;
DROP TRIGGER IF EXISTS blocca_turni_capocantiere;
DROP TRIGGER IF EXISTS blocca_turniorario_turnolavoratore;
DROP TRIGGER IF EXISTS blocca_turniorario_capocantiere;
DROP TRIGGER IF EXISTS blocca_orario_stadiodiavanzamento;
DROP TRIGGER IF EXISTS blocca_orario_progettoedilizio;
DROP TRIGGER IF EXISTS controlla_alert1;
DROP TRIGGER IF EXISTS controlla_alert3;
DROP TRIGGER IF EXISTS dominio_puntodiaccesso;
DROP TRIGGER IF EXISTS puntocardinale_finestra;
DROP TRIGGER IF EXISTS puntocardinale_puntodiaccesso;
DROP TRIGGER IF EXISTS blocca_maxnumerolavoratori;
DROP TRIGGER IF EXISTS blocca_strati_intonaco;
DROP TRIGGER IF EXISTS blocca_3puntodiaccesso;
DROP TRIGGER IF EXISTS calcola_pesomedio_superficiemedia;
DROP PROCEDURE IF EXISTS calcola_livellogravità;
DROP PROCEDURE IF EXISTS calcola_gravita_km;
DROP TRIGGER IF EXISTS calcola_livello_evento;
DROP PROCEDURE IF EXISTS StatoEdificio;


-- Il costo di un materiale può essere in mq o quintali, mai entrambi

DELIMITER $$

CREATE TRIGGER blocca_costo_materialegenerico
BEFORE INSERT ON  materialegenerico
FOR EACH ROW 
BEGIN
	
	IF NEW.Costomq IS NOT NULL AND NEW.Costoquintale IS NOT NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inserimento di due tipologie di costo errato';
	END IF;
END $$
DELIMITER ;

-- L'attributo SuperficieMedia e PesoMedio non possono essere inserite dall'utente

DELIMITER $$

CREATE TRIGGER blocca_attributi_pietra
BEFORE INSERT ON  pietraedificio
FOR EACH ROW 
BEGIN
	
	IF NEW.SuperficieMediamq IS NOT NULL OR NEW.PesoMedioKg IS NOT NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Supercie e Peso non inseribili';
	END IF;
END $$
DELIMITER ;

-- L'OraInizio e l'OraFine di un turno di lavoro di un lavoratore devono essere coerenti


DELIMITER $$

CREATE TRIGGER blocca_turni_turnolavoratore
BEFORE INSERT ON  turnolavoratore
FOR EACH ROW 
BEGIN
	
	IF NEW.OraFine < NEW.OraInizio THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Orari non compatibili';
	END IF;
END $$
DELIMITER ;

-- L'OraInizio e l'OraFine di un turno di lavoro di un capocantiere devono essere coerenti

DELIMITER $$

CREATE TRIGGER blocca_turni_capocantiere
BEFORE INSERT ON  turnocapocantiere
FOR EACH ROW 
BEGIN
	
	IF NEW.OraFine < NEW.OraInizio THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Orari non compatibili';
	END IF;
END $$
DELIMITER ;

-- Un lavoratore non può avere turni che si sovrappongono sullo stesso orario

DELIMITER $$

CREATE TRIGGER blocca_turniorario_turnolavoratore
BEFORE INSERT ON  turnolavoratore
FOR EACH ROW 
BEGIN
	
	IF EXISTS (
				SELECT*
                FROM turnolavoratore T
                WHERE T.giorno = NEW.giorno AND ((NEW.OraInizio BETWEEN t.OraInizio AND t.OraFine)
												 OR (NEW.OraFine BETWEEN t.OraInizio AND t.OraFine))
					  AND T.Lavoratore = NEW.Lavoratore)
				THEN
                
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Orari non compatibili';
	END IF;
END $$
DELIMITER $$

-- Un capocantiere non può avere turni che si sovrappongono sullo stesso orario

DELIMITER $$

CREATE TRIGGER blocca_turniorario_capocantiere
BEFORE INSERT ON  turnocapocantiere
FOR EACH ROW 
BEGIN
	
	IF EXISTS (
				SELECT*
                FROM turnocapocantiere T
                WHERE T.giorno = NEW.giorno AND ((NEW.OraInizio BETWEEN t.OraInizio AND t.OraFine)
												 OR (NEW.OraFine BETWEEN t.OraInizio AND t.OraFine))
					  AND T.Capocantiere = NEW.Capocantiere)
				THEN
                
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Orari non compatibili';
	END IF;
END $$
DELIMITER ;

-- StadioDiAvanzamento deve avere DataInizio precedente a StimaDataFine e DataFine

DELIMITER $$

CREATE TRIGGER blocca_orario_stadiodiavanzamento
BEFORE INSERT ON  stadiodiavanzamento
FOR EACH ROW 
BEGIN
	
	IF NEW.DataInizio > NEW.StimaDataFine OR NEW.DataInizio > NEW.DataFine THEN
                
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Date non compatibili';
	END IF;
END $$
DELIMITER ;

-- In ProgettoEdilizio le date devono essere in questo ordine DataPresentazione 
-- > DataApprovazione > DataInizio > StimaDataFine <=> DataFine dal più vecchio al più nuovo

DELIMITER $$

CREATE TRIGGER blocca_orario_progettoedilizio
BEFORE INSERT ON  progettoedilizio
FOR EACH ROW 
BEGIN
	
	IF NEW.DataApprovazione > NEW.DataInizio OR NEW.DataInizio > NEW.StimaDataFine 
	   OR NEW.DataApprovazione > NEW.StimaDataFine OR NEW.DataApprovazione > NEW.DataFine
       OR NEW.DataInizio > NEW.DataFine 
       THEN
       
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Date non compatibili';
	END IF;
END $$
DELIMITER ;

-- Quando inserisco un alert devo controllare che il valore misurato da un sensore superi il valori di soglia (VERSIONE SENSORI A 1 COMPONENTE)

DELIMITER $$

CREATE TRIGGER controlla_alert1
BEFORE INSERT ON  alert
FOR EACH ROW 
BEGIN
	
	IF NOT EXISTS (
					SELECT 1
                    FROM sensore S
                         INNER JOIN 
                         misurazione R ON S.codice = R.sensore
					WHERE R.codice = NEW.misurazione AND S.SogliaDiRischio < R.Valore AND ( (second(NEW.Timestamp) <= second(R.Timestamp)+5) OR 
						  (second(NEW.Timestamp) = 1 AND second(R.Timestamp) = 56) OR (second(NEW.Timestamp) = 2 AND second(R.Timestamp) = 57) OR
                          (second(NEW.Timestamp) = 0 AND second(R.Timestamp) = 55) OR (second(NEW.Timestamp) = 3 AND second(R.Timestamp) = 58) OR
						  (second(NEW.Timestamp) = 4 AND second(R.Timestamp) = 59) )
                  )  
       THEN
       
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Alert non inseribile';
	END IF;
END $$
DELIMITER ;

-- Quando inserisco un alert devo controllare che il valore misurato da un sensore superi il valori di soglia (VERSIONE SENSORI A 3 COMPONENT1)

DELIMITER $$

CREATE TRIGGER controlla_alert3
BEFORE INSERT ON  alerttriassiale
FOR EACH ROW 
BEGIN
	
	IF NOT EXISTS (
					SELECT 1
                    FROM sensore S
                         INNER JOIN 
                         misurazionetriassiale M ON S.codice = M.sensore
					WHERE M.codice = NEW.misurazionetriassiale AND S.SogliaDiRischio*S.SogliaDiRischio < (M.ValoreX*M.ValoreY*M.ValoreZ) AND ( (second(NEW.Timestamp) <= second(M.Timestamp)+5) OR 
						  (second(NEW.Timestamp) = 1 AND second(M.Timestamp) = 56) OR (second(NEW.Timestamp) = 2 AND second(M.Timestamp) = 57) OR
                          (second(NEW.Timestamp) = 0 AND second(M.Timestamp) = 55) OR (second(NEW.Timestamp) = 3 AND second(M.Timestamp) = 58) OR
						  (second(NEW.Timestamp) = 4 AND second(M.Timestamp) = 59) )
                    )
       THEN
       
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Alert non inseribile';
	END IF;
END $$
DELIMITER ;

-- Il dominio di collegamento di PuntoDiAccesso può essere 'Interno' o 'Esterno'

DELIMITER $$

CREATE TRIGGER dominio_puntodiaccesso
BEFORE INSERT ON  puntodiaccesso
FOR EACH ROW 
BEGIN
	
	IF NEW.Collegamento <> 'Interno' AND NEW.Collegamento <> 'Esterno' THEN
       
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dominio di collegamento errato';
	END IF;
END $$
DELIMITER ;

-- Il dominio PuntoCardinale in Finestra e PuntoDiAccesso può assumere solo valori N, S, E, W, NE, NW, SE; SO

DELIMITER $$

CREATE TRIGGER puntocardinale_puntodiaccesso
BEFORE INSERT ON  puntodiaccesso
FOR EACH ROW 
BEGIN
	
	IF NEW.puntocardinale <> 'N' AND NEW.puntocardinale <> 'S' AND
       NEW.puntocardinale <> 'E' AND NEW.puntocardinale <> 'W' AND
       NEW.puntocardinale <> 'NE' AND NEW.puntocardinale <> 'NW' AND
       NEW.puntocardinale <> 'SE' AND NEW.puntocardinale <> 'SW' 
    
    THEN
       
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dominio di PuntoCardinale non compatibile';
	END IF;
END $$
DELIMITER ;

DELIMITER $$

CREATE TRIGGER puntocardinale_finestra
BEFORE INSERT ON  finestra
FOR EACH ROW 
BEGIN
	
	IF NEW.puntocardinale <> 'N' AND NEW.puntocardinale <> 'S' AND
       NEW.puntocardinale <> 'E' AND NEW.puntocardinale <> 'W' AND
       NEW.puntocardinale <> 'NE' AND NEW.puntocardinale <> 'NW' AND
       NEW.puntocardinale <> 'SE' AND NEW.puntocardinale <> 'SW' 
    
    THEN
       
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dominio di PuntoCardinale non compatibile';
	END IF;
END $$
DELIMITER ;

-- Non è possibile superare il numero massimo di persone che possono essere dirette da un capocantiere

DELIMITER $$

CREATE TRIGGER blocca_maxnumerolavoratori
BEFORE INSERT ON  Lavoratore
FOR EACH ROW 
BEGIN
	
	DECLARE numerolavoratori INTEGER DEFAULT 1;
    DECLARE NumeroMassimoPersone INTEGER DEFAULT 0;
    DECLARE differenza INTEGER DEFAULT 0;
    
    SET numerolavoratori =
		(
         SELECT count(*) as NumeroLavoratiDiretti
         FROM capocantiere C 
			  INNER JOIN 
              lavoratore L ON C.codicefiscale = L.capocantiere
		WHERE C.codicefiscale = NEW.Capocantiere
        );
        
	SET NumeroMassimoPersone =
        (
         SELECT NumeroMaxPersone
         FROM capocantiere C
         where C.codicefiscale = NEW.capocantiere
         );
         
	SET differenza = numerolavoratori - numeromassimopersone;
        
        IF differenza = 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lavoratore non inseribile';
	END IF;
END $$
DELIMITER ;

-- Una parete non può avere più di 3 strati di intonaco

DELIMITER $$

CREATE TRIGGER blocca_strati_intonaco
BEFORE INSERT ON intonacoedificio
FOR EACH ROW 
BEGIN
	
	DECLARE Nstrati INTEGER DEFAULT 0;
    
    SET Nstrati =
		(
         SELECT count(*) as NumeroStrati
         FROM intonacoedificio
		 WHERE muratura=NEW.muratura
        );
        
        IF Nstrati = 3 THEN
       
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Intonaco su parete non inseribile';
	END IF;
END $$
DELIMITER ;

-- Al massimo 2 vani possono condividere lo stesso punto di accesso

DELIMITER $$

CREATE TRIGGER blocca_3puntodiaccesso
BEFORE INSERT ON accessovano
FOR EACH ROW 
BEGIN
	
	    IF 2 = (    
					SELECT count(*)
                    FROM accessovano A
                    WHERE A.puntodiaccesso = NEW.puntodiaccesso
				) THEN
       
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Punto di accesso già presente in 2 vani';
	END IF;
END $$
DELIMITER ;

-- Procedura che calcola e aggiorna il PesoMedio e la SuperficieMedia

DROP PROCEDURE IF EXISTS calcola_attributi_pietra;
DELIMITER $$
CREATE PROCEDURE calcola_attributi_pietra(IN Pietra1 int, OUT Superficie float, OUT Peso float)
BEGIN 
		
	    SET Superficie = (
							SELECT P.larghezza*P.lunghezza*6/P.NumeroPietreLotto
                            FROM pietra P
							WHERE P.codicelotto= pietra1
								);
		
		SET Peso = (SELECT P.quantita*100/P.NumeroPietreLotto
					FROM pietra P
					WHERE P.codicelotto = pietra1);

END $$
DELIMITER ;

-- Una volta inserita una pietra in una muratura si assegna il PesoMedio e la SuperficieMedia

DELIMITER $$

CREATE TRIGGER calcola_pesomedio_superficiemedia
BEFORE INSERT ON pietraedificio 
FOR EACH ROW 
BEGIN
	  CALL calcola_attributi_pietra(NEW.Pietra, @calcola1, @calcola2);
      SET NEW.PesoMedioKg = @calcola2;
      SET NEW.SuperficieMediamq = @calcola1;
	
END $$
DELIMITER ;

-- Calcola il livello di gravità associato a un evento calamitoso

DELIMITER $$
CREATE PROCEDURE Calcola_livellogravità (IN rischio1 VARCHAR(45), IN data1 DATE, IN areageografica1 INTEGER, OUT livelloout FLOAT)
BEGIN

DECLARE livello_gravita FLOAT DEFAULT 1;
DECLARE numero_edifici INT DEFAULT 0;

SET numero_edifici = (SELECT count(*)
					  FROM Edificio E
                      WHERE E.areageografica = areageografica1
                      );

IF numero_edifici > 0 THEN

IF rischio1 = 'Terremoto' THEN
	SET livello_gravita = (SELECT MAX(sqrt(M.ValoreX*M.ValoreX+M.ValoreY*M.ValoreY+M.ValoreZ+M.ValoreZ)-S.SogliaDiRischio) as Valore
						   FROM misurazionetriassiale M 
								INNER JOIN
                                sensore S on S.codice = M.sensore
                                INNER JOIN
                                edificio E on E.codice = M.Edificio
						   WHERE date(M.Timestamp) = data1 AND E.AreaGeografica = areageografica1 
                           );
ELSE
	SET livello_gravita = (SELECT MAX(M.Valore-S.SogliaDiRischio) as Valore
						   FROM misurazione M 
								INNER JOIN
                                sensore S on S.codice = M.sensore
                                INNER JOIN
                                edificio E on E.codice = M.edificio
						   WHERE date(M.Timestamp) = data1 AND E.AreaGeografica = areageografica1
                           );
END IF;

END IF;

SET livelloout = sqrt(livello_gravita*livello_gravita);
IF livelloout IS NULL OR livelloout < 1 THEN SET livelloout = 1; END IF;

END $$
DELIMITER ;

-- Procedura per il calcolo del livello di gravità a una determinata distanza dall'epicentro

DELIMITER $$
CREATE PROCEDURE calcola_gravita_km(IN rischio1 varchar(45), IN data1 date, IN areageografica1 INT, IN KM INT, OUT LIVELLO INT)
BEGIN 

	 IF KM > (SELECT E.raggio
			  FROM eventocalamitoso E
              WHERE E.areageografica = areageografica1 AND E.NomeEventoCalamitoso=rischio1 AND E.data=data1) THEN
		SET LIVELLO = 0;
	ELSE
		SET livello = 1000 - KM* (SELECT E.livelloDIgravita
								  FROM eventocalamitoso E
              WHERE E.areageografica = areageografica1 AND E.NomeEventoCalamitoso=rischio1 AND E.data=data1);
END IF;
END $$
DELIMITER ;

-- Dopo ogni inserimento di evento calamitoso calcola in maniera automatica il valore di livello di gravità e lo assegna

DELIMITER $$
CREATE TRIGGER calcola_livello_evento
BEFORE INSERT ON eventocalamitoso
FOR EACH ROW 
BEGIN

	
    CALL Calcola_LivelloGravità(NEW.NomeEventoCalamitoso, NEW.data, NEW.areageografica, @calcola);
    SET NEW.livellodigravita = @calcola;
    
END $$
DELIMITER ;

-- Calcola lo stato di un edificio a partire da un codice in input, lo aggiorna nell'apposita tabella e mostra a schermo alcuni lavori da dover fare

DROP PROCEDURE IF EXISTS StatoEdificio;
DELIMITER $$
CREATE PROCEDURE StatoEdificio(CodEdificio VARCHAR(16))
BEGIN
	
	WITH MisurazioniScelte AS(
		SELECT Sensore, Codice as Misurazione, Timestamp
        FROM Misurazione
        WHERE Edificio=CodEdificio
	),
    MisurazioniTrScelte AS(
		SELECT Sensore, Codice as MisurazioneTriassiale, Timestamp
        FROM MisurazioneTriassiale
        WHERE Edificio=CodEdificio
    ),
    NumeroDiAlert AS(
		SELECT Sensore, Year(Timestamp) AS Anno, 0+COUNT(*) AS NumAlert
        FROM MisurazioniScelte NATURAL JOIN Alert
        GROUP BY Sensore, Year(Timestamp)
    ),
    NumeroDiAlertTr AS(
		SELECT Sensore, Year(Timestamp) AS Anno, 0+COUNT(*) AS NumAlert
        FROM MisurazioniTrScelte NATURAL JOIN AlertTriassiale
        GROUP BY Sensore, Year(Timestamp)
    ),
    UnisciAlert AS(
		SELECT *
        FROM (SELECT * FROM NumeroDiAlert) as X
			 UNION ALL
			 (SELECT * FROM NumeroDiAlertTr)
    ),
    NumeroAlertTotali AS(
		SELECT Anno, SUM(NumAlert) as NumAlert
        FROM UnisciAlert
        GROUP BY Anno
    ),
    CalcoloStato AS(
		SELECT IF(A1.NumAlert > ALL(SELECT A2.NumAlert
								    FROM NumeroAlertTotali A2
                                    WHERE A1.Anno<>A2.Anno), 3, IF(A1.NumAlert=0, 1, 2)) as Stato
        FROM NumeroAlertTotali A1
		WHERE A1.Anno=2022
    )
    UPDATE Edificio
    SET Stato = IFNULL((SELECT Stato FROM CalcoloStato), 1)
    WHERE Codice=CodEdificio;
    
    
    SELECT IF(Stato=3, 'MessaInSicurezza', IF(Stato=2, 'InstallazioneSensori', 'Buona salute')) As Stato
    FROM edificio
    WHERE Codice=CodEdificio;
    
END $$
DELIMITER ;

-- TriggerOperazione8

DROP TRIGGER IF EXISTS calcola_ore_lavoratore;
DELIMITER $$
CREATE TRIGGER calcola_ore_lavoratore
BEFORE INSERT ON TurnoLavoratore
FOR EACH ROW 
BEGIN

	DECLARE QuanteOre integer default 0;
    IF year(NEW.Giorno) = year(current_date()) THEN
    SET QuanteOre = hour(NEW.OraFine) - hour(NEW.OraInizio);
    END IF;
    
    UPDATE Lavoratore
    SET TotaleOre = if(TotaleOre IS NULL, 0, TotaleOre) + QuanteOre
    WHERE CodiceFiscale = NEW.Lavoratore;
    
END $$
DELIMITER ;

-- Event Operazione4

DROP EVENT IF EXISTS AggiornamentoCosto;
DELIMITER $$
CREATE EVENT AggiornamentoCosto
ON SCHEDULE EVERY 1 DAY
DO
BEGIN

	WITH ProgettoScelto AS(
		SELECT Codice as ProgettoEdilizio
        FROM progettoedilizio
        WHERE datafine IS NULL
	),
    StadioAssociato AS(
		SELECT codice as StadioDiAvanzamento
        FROM ProgettoScelto p NATURAL JOIN stadiodiavanzamento s
        WHERE datafine IS NULL
    ),
    TurniLavoratoriAssociati AS(
		SELECT StadioDiAvanzamento, Lavoratore as CodiceFiscale, HOUR(TIMEDIFF(OraFine,Orainizio)) as OreDiLavoro
        FROM StadioAssociato s NATURAL JOIN turnolavoratore t
        WHERE t.giorno=current_date
        GROUP BY t.Lavoratore
    ),
    TurniCapocantieriAssociati AS(
		SELECT StadioDiAvanzamento, Capocantiere as CodiceFiscale, HOUR(TIMEDIFF(OraFine,Orainizio)) as OreDiLavoro
        FROM StadioAssociato s NATURAL JOIN turnocapocantiere t
        WHERE t.giorno=current_date
        GROUP BY t.CapoCantiere
    ),
    CostoDelPersonale AS(
		SELECT CostoPersonale
        FROM ( SELECT Pagaoraria*OreDiLavoro AS CostoPersonale FROM TurniLavoratoriAssociati NATURAL JOIN lavoratore ) as L
			 UNION ALL
			 ( SELECT Pagaoraria*OreDiLavoro AS CostoPersonale FROM TurniCapocantieriAssociati NATURAL JOIN capocantiere)
    ),
    CostoDaAggiornare AS(
		SELECT SUM(CostoPersonale) AS CostoPersonale
        FROM CostoDelPersonale
    )
	UPDATE progettoedilizio
    SET Costo=IFNULL(Costo,0)+( SELECT CostoPersonale FROM CostoDaAggiornare)
    WHERE Codice = (SELECT Codice FROM ProgettoScelto)
		AND Edificio = (SELECT Codice FROM edificio where DataAccatastamento IS NULL); -- DataAccatastamento
    
END $$
DELIMITER ;

DROP EVENT IF EXISTS AggiornamentoMateriale;
DELIMITER $$
CREATE EVENT AggiornamentoMateriale
ON SCHEDULE EVERY 2 DAY
DO
BEGIN

	WITH ProgettoScelto AS(
		SELECT Codice as ProgettoEdilizio
        FROM progettoedilizio
        WHERE datafine IS NULL
	),
    StadioDiOggi AS(
		SELECT codice as StadioDiAvanzamento
        FROM ProgettoScelto p NATURAL JOIN stadiodiavanzamento s
        WHERE datafine IS NULL
    ),
	LavoriDiOggi AS(
		SELECT Lavoro
		FROM StadioDiOggi S NATURAL JOIN DivisioneLavoro D
	),
	LottiDiOggi AS(
		SELECT CodiceLotto
		FROM (SELECT mattone as codicelotto FROM utilizzomattone NATURAL JOIN LavoriDiOggi) as M
			 UNION ALL
			 (SELECT materialegenerico as codicelotto FROM utilizzomaterialegenerico NATURAL JOIN LavoriDiOggi)
			 UNION ALL
			 (SELECT intonaco as codicelotto FROM utilizzointonaco NATURAL JOIN LavoriDiOggi)
			 UNION ALL
			 (SELECT piastrella as codicelotto FROM utilizzopiastrella NATURAL JOIN LavoriDiOggi)
			 UNION ALL
			 (SELECT pietra as codicelotto FROM utilizzopietra NATURAL JOIN LavoriDiOggi)
	),
	CostoMateriali AS(
		SELECT SUM(costomateriale) as CostoMateriale
		FROM (SELECT Costo*Quantita as CostoMateriale FROM intonaco NATURAL JOIN lottidioggi) as I
			 UNION ALL
			 (SELECT IFNULL(CostoQuintale,Costomq)*Quantita AS CostoMateriale FROM materialegenerico NATURAL JOIN lottidioggi)
			 UNION ALL
			 (SELECT CostoQuintale*Quantita as CostoMateriale FROM mattone NATURAL JOIN lottidioggi)
			 UNION ALL
			 (SELECT Costo*Quantita as CostoMateriale FROM piastrella NATURAL JOIN lottidioggi)
			 UNION ALL
			 (SELECT Costo*Quantita as CostoMateriale FROM pietra NATURAL JOIN lottidioggi)
	),
    CostoDaAggiornare AS(
		SELECT SUM(CostoMateriale) AS CostoMateriale
        FROM CostoMateriali
    )
    
    UPDATE progettoedilizio
    SET Costo=IFNULL(Costo,0)+(SELECT CostoMateriale FROM CostoDaAggiornare)
    WHERE Codice = (SELECT Codice FROM ProgettoScelto)
		AND Edificio = (SELECT Codice FROM Edificio where DataAccatastamento IS NULL);
		
END $$
DELIMITER ;