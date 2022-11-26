-- Mostrare le ultime 24h di registrazioni di ogni sensore di un edificio 
DROP PROCEDURE IF EXISTS Op1_stampa_registrazione;
DELIMITER $$
CREATE PROCEDURE Op1_stampa_registrazione(IN CodEdificio VARCHAR(50))
BEGIN

	WITH RegistrazioniScelte AS(
		SELECT X.Sensore, X.Valore, NULL AS ValoreX, NULL AS ValoreY, NULL AS ValoreZ
		FROM Sensore S LEFT OUTER JOIN Misurazione X ON S.Codice=X.Sensore 
        WHERE Edificio=CodEdificio
			AND timestamp >= current_timestamp - interval 1 day
	),
    RegistrazioniTrScelte AS(
		SELECT Sensore, Valore, ValoreX, ValoreY, ValoreZ
        FROM RegistrazioniScelte
		UNION ALL
        (SELECT Sensore, NULL AS Valore, ValoreX, ValoreY, ValoreZ FROM MisurazioneTriassiale WHERE Edificio=CodEdificio AND timestamp >= current_timestamp - interval 1 day)
    )
    
	SELECT *
	FROM RegistrazioniTrScelte
    ORDER BY Sensore;

END $$
DELIMITER ;

-- Mostrare la topologia di un edificio
DROP PROCEDURE IF EXISTS Op2_topologia;
DELIMITER $$
CREATE PROCEDURE Op2_topologia( IN CodEdificio VARCHAR(50))
BEGIN
	
    WITH EdificioScelto AS(
		SELECT p.id, p.pianta
        FROM piano p
        WHERE p.edificio=CodEdificio
    ),
    VaniScelti AS(
		SELECT e.id AS IdPiano, v.id AS IdVano, v.Perimetro, v.Area, v.AltezzaMax, v.LarghezzaMax, v.LunghezzaMax, e.Pianta
        FROM vano v INNER JOIN Edificioscelto e ON e.id=v.piano
    ),
    VaniConFunzione AS(
		SELECT v.IdPiano, p.Perimetro AS PerimetroPiano, p.Area AS AreaPiano, v.IdVano, v.Perimetro AS PerimVano, v.Area AS AreaVano, v.AltezzaMax AS AltezzaMaxVano, v.LarghezzaMax AS LarghezzaMaxVano,
        v.LunghezzaMax AS LunghezzaMaxVano, f.Funzione
        FROM vaniscelti v INNER JOIN funzionevano f ON v.idvano=f.vano
			INNER JOIN Pianta p ON v.Pianta=p.Nome
    )
SELECT *
FROM VaniConFunzione;
    
END $$
DELIMITER ;

-- Mostrare la descrizione dettagliata di un vano
DROP PROCEDURE IF EXISTS Op3_descrizione_vano;
DELIMITER $$
CREATE PROCEDURE Op3_descrizione_vano( IN CodEdificio VARCHAR(50), CodPiano INTEGER, CodVano INTEGER )
BEGIN
	
	WITH EdificioScelto AS(
		SELECT p.id
		FROM piano p
		WHERE p.edificio=CodEdificio
			AND p.id=CodPiano
	),
	VanoScelto AS(
		SELECT v.id as Vano
		FROM vano v INNER JOIN Edificioscelto e ON e.id=v.piano
		WHERE v.id=CodVano
	),
	PtiAccessoPerNaturalJoin as(
		SELECT id as puntodiaccesso, PuntoCardinale as PuntoCardinalePtoAccesso, Perimetro as PerimetroPtoAccesso,
			Area as AreaPtoAccesso, TipologiaPuntoDiAccesso as TipoPtoAccesso, Collegamento
		FROM puntodiaccesso
	),
	FinestraPerNaturalJoin as(
		SELECT id as IdFinestra, PuntoCardinale as PuntoCardinaleFinestra, Perimetro as PerimetroFinestra,
			Area as AreaFinestra
		FROM finestra
	),
	VanoConInfo AS(
		SELECT Vano, Funzione, IdFinestra, PuntoCardinaleFinestra, PerimetroFinestra, AreaFinestra,
			Puntodiaccesso, PuntoCardinalePtoAccesso, PerimetroPtoAccesso, AreaPtoAccesso, TipoPtoAccesso, Collegamento
		FROM VanoScelto v NATURAL JOIN Accessovano a 
			NATURAL JOIN PtiAccessoPerNaturalJoin NATURAL JOIN funzionevano NATURAL JOIN finestrapernaturaljoin
	)
	SELECT *
	FROM vanoconinfo;
    
END $$
DELIMITER ;

-- Calcolare il costo di un progetto edilizio
DROP PROCEDURE IF EXISTS Op4_costo_progetto;
DELIMITER $$
CREATE PROCEDURE Op4_costo_progetto( IN CodProgetto VARCHAR(50))
BEGIN

	SELECT Costo
    FROM ProgettoEdilizio
    WHERE Codice=CodProgetto;

END $$
DELIMITER ;

-- Visualizzare lavori in corso e gli operai che lavorano a tale lavoro
DROP PROCEDURE IF EXISTS Op5_lavori_in_corso;
DELIMITER $$
CREATE PROCEDURE Op5_lavori_in_corso(IN codice1 int)
BEGIN
		SELECT DISTINCT M.Lavoratore, M.lavoro
        FROM ProgettoEdilizio P
			 INNER JOIN
             StadioDiAvanzamento S ON P.Codice = S.ProgettoEdilizio
             INNER JOIN 
             DivisioneLavoro L on S.Codice = L.StadioDiAvanzamento
             INNER JOIN
             Mansione M on M.Lavoro = L.lavoro
        WHERE S.DataFine IS NULL AND P.Codice = codice1
        ORDER BY M.Lavoratore;
		
END $$
DELIMITER ;

-- Inserimento di un nuovo materiale generico nel database, collegato a una muratura e a un lavoro

DROP PROCEDURE IF EXISTS Op6_inserimento_materiale;
DELIMITER $$
CREATE PROCEDURE Op6_inserimento_materiale(IN Codice integer, IN Nome varchar(45), IN Data1 Date, 
													IN Costo1 float, IN Costo2 float, IN Fornitore varchar(45), 
                                                    IN Quantita float, IN Costituzione varchar(45), IN larghezza float, 
                                                    IN Lunghezza float, IN Spessore float, IN muratura varchar(45), IN lavoro varchar(45))
BEGIN
	INSERT INTO materialegenerico
	VALUES (Codice, Nome, Data1, Costo1, Costo2, Fornitore, Quantita, Costituzione, Larghezza, Lunghezza, Spessore);
    
    INSERT INTO utilizzomaterialegenerico
    VALUES (Codice, lavoro);
    
    INSERT INTO materialegenericoedificio
    VALUES (muratura, Codice);

END $$
DELIMITER ;

-- Aggiornamento di SogliaDiSicurezza e visualizza le registrazione di tale sensore che hanno generato alert

DROP PROCEDURE IF EXISTS Op7_aggiorna_soglia_stampa;
DELIMITER $$
CREATE PROCEDURE Op7_aggiorna_soglia_stampa(IN Codice1 varchar(45), IN Soglia float)
BEGIN
		UPDATE Sensore S
        SET sogliadirischio = Soglia
        WHERE S.Codice = Codice1;
        
        IF EXISTS (SELECT 1
				   FROM Sensore S1
                        INNER JOIN 
                        Misurazione M1 on S1.codice = M1.sensore
				   WHERE S1.codice = Codice1) THEN
        SELECT A.Codice, A.Misurazione, A.Timestamp
        FROM Sensore S
			 INNER JOIN
             Misurazione M on S.codice = M.sensore
             INNER JOIN
             Alert A on A.misurazione = M.codice
		WHERE S.codice = Codice1;
        
        ELSE
        
        SELECT A.Codice, A.Misurazione, A.Timestamp
        FROM Sensore S
			 INNER JOIN
             MisurazioneTriassiale M on S.codice = M.sensore
             INNER JOIN
             AlertTriassiale A on A.misurazione = M.codice
		WHERE S.codice = Codice1;
        
        END IF;

END $$
DELIMITER ;

-- Calcolare le ore settimanali di un lavoratore
DROP PROCEDURE IF EXISTS Op8_ore_settimanali;
DELIMITER $$
CREATE PROCEDURE Op8_ore_settimanali(codice VARCHAR(45))
BEGIN
		SELECT if(L.TotaleOre is null, 0, L.TotaleOre) as TotaleOre
        FROM Lavoratore L
        WHERE L.CodiceFiscale = codice;
END $$
DELIMITER ;
		