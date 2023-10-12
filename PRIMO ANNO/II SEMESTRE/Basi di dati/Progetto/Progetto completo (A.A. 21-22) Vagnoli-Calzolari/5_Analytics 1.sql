DROP PROCEDURE IF EXISTS Analytics1;
DELIMITER $$
CREATE PROCEDURE Analytics1(CodEdificio VARCHAR(16))
BEGIN
	
	WITH EdificioScelto AS(
		SELECT Codice AS Edificio
		FROM Edificio
		WHERE Codice=CodEdificio
	),
	-- Scelgo Edificio in input e Sensori associati a quell'edificio
	SensoriScelti AS(
		SELECT Codice AS Sensore, SogliaDiRischio, muratura
		FROM Sensore
	),
	-- Scelgo le misurazioni associate a quel sensore e calcolo il coeff. parziale positivo
	MisurazioniAssociate AS(
		SELECT Sensore, Muratura, SogliaDiRischio/(SogliaDiRischio-Valore) AS CoeffPos
		FROM misurazione NATURAL JOIN EdificioScelto NATURAL JOIN  SensoriScelti
		WHERE Valore<SogliaDiRischio
	),
	MisurazioniTrAssociate AS(
		SELECT Sensore, Muratura, SogliaDiRischio/NULLIF(SogliaDiRischio-Sqrt(ValoreX*ValoreX+ValoreY*ValoreY+ValoreZ*ValoreZ), 0) AS CoeffTrPos
		FROM misurazionetriassiale NATURAL JOIN EdificioScelto NATURAL JOIN  SensoriScelti
		WHERE Sqrt(ValoreX*ValoreX+ValoreY*ValoreY+ValoreZ*ValoreZ)<SogliaDiRischio
	),
	MisurazioniAssociateNeg AS(
		SELECT Sensore, Muratura, SogliaDiRischio*log(exp(1)+Valore-SogliaDiRischio) AS CoeffNeg, Codice AS Misurazione -- Serve per la parte dopo
		FROM misurazione NATURAL JOIN EdificioScelto NATURAL JOIN  SensoriScelti
		WHERE Valore>=SogliaDiRischio
	),
	MisurazioniTrAssociateNeg AS(
		SELECT Sensore, Muratura, SogliaDiRischio*log(exp(1)+Sqrt(ValoreX*ValoreX+ValoreY*ValoreY+ValoreZ*ValoreZ)-SogliaDiRischio) AS CoeffTrNeg, Codice AS MisurazioneTriassiale -- Serve per la parte dopo
		FROM misurazionetriassiale NATURAL JOIN EdificioScelto NATURAL JOIN  SensoriScelti
		WHERE Sqrt(ValoreX*ValoreX+ValoreY*ValoreY+ValoreZ*ValoreZ)>=SogliaDiRischio
	),
	-- Calcolo il coeff. totale
	CoeffDiStatoPos AS(
		SELECT Sensore, Muratura, NumMisur1, CoeffPos
		FROM (SELECT Sensore, Muratura, COUNT(*) as NumMisur1, AVG(CoeffPos) AS CoeffPos FROM MisurazioniAssociate GROUP BY Sensore) AS M
			 UNION ALL
			 (SELECT Sensore, Muratura, COUNT(*) as NumMisur1, AVG(CoeffTrPos) AS CoeffPos FROM MisurazioniTrAssociate GROUP BY Sensore)
	),
    CoeffDiStatoNeg AS(
		SELECT Sensore, Muratura, NumMisur2, CoeffNeg
		FROM (SELECT Sensore, Muratura, COUNT(*) as NumMisur2, AVG(CoeffNeg) AS CoeffNeg FROM MisurazioniAssociateNeg GROUP BY Sensore) AS M1
			 UNION ALL
			 (SELECT Sensore, Muratura, COUNT(*) as NumMisur2, AVG(CoeffTrNeg) AS CoeffNeg FROM MisurazioniTrAssociateNeg GROUP BY Sensore)
    ),
    CoeffDiStato AS(
		SELECT Sensore, Muratura, NumMisur1+NumMisur2 AS NumMisur, SUM(CoeffPos)+SUM(CoeffNeg) AS CoeffStato
        FROM SensoriScelti NATURAL JOIN CoeffDiStatoPos NATURAL JOIN CoeffDiStatoNeg
        GROUP BY Sensore
    ),
    -- Prendo tutti gli alert
    NumeroAlert AS (
		SELECT Sensore, Misurazione
        FROM (SELECT Sensore, Misurazione FROM MisurazioniAssociateNeg NATURAL JOIN Alert ) as X
             UNION ALL
             (SELECT Sensore, MisurazioneTriassiale as Misurazione FROM MisurazioniTrAssociateNeg NATURAL JOIN AlertTriassiale)
    ),
    -- Conto gli alert
    ContaAlert AS (
		SELECT Sensore, COUNT(*) AS NumAlert
        FROM NumeroAlert
        GROUP BY Sensore
    ),
	-- Controllo se l'alert 
	ControllaAlert AS(
		SELECT Sensore, Muratura, CoeffStato, 100*NumAlert/NumMisur AS CoeffTempo
		FROM CoeffDiStato NATURAL JOIN ContaAlert
	),
	-- Si assegna un numero di mesi in relazione a quanto è critica la situazione guardando gli alert
	QuandoIntervenire AS(
		SELECT Sensore, Muratura, CoeffStato, IF(CoeffTempo=0, NULL, IF(CoeffTempo<=25, 8, IF(CoeffTempo, 4, IF(CoeffTempo, 2, IF(CoeffTempo, 0, 'ERRORE'))))) AS MesiPerIntervenire
		FROM ControllaAlert
	)
		
	SELECT *
	FROM QuandoIntervenire
	ORDER BY CoeffStato DESC;
		
END $$
DELIMITER ;
