DROP PROCEDURE IF EXISTS Suggerimenti;
DELIMITER $$
CREATE PROCEDURE Suggerimenti()
BEGIN
	# Inserimento all'interno della tabella suggerimento di consigli riferiti agli utenti della smart home per eseguire i propri 
    # dispositivi variabili non interrompibili in modo da risparmiare, andiamo a prevedere l'istante del giorno stesso OGNI SERA A MEZZANOTTE
    # condiserando i dati di una settimana fa del contatore bidirezionale, più nello specifico, andiamo a considerare i valori dell'energia venduta 
    # e quindi ipotizziamo in quale istante è maggiore la vendita di energia, e quindi consigliare all'utente di accendere quel programma a quell'istante.
    
    # Adesso seguono tutte le CTE usate per la creazione della query
	# Inserimento all'interno della tabella suggerimento di consigli riferiti agli utenti della smart home per eseguire i propri 
    # dispositivi variabili non interrompibili in modo da risparmiare, andiamo a prevedere l'istante del giorno stesso OGNI SERA A MEZZANOTTE
    # condiserando i dati di una settimana fa del contatore bidirezionale, più nello specifico, andiamo a considerare i valori dell'energia venduta 
    # e quindi ipotizziamo in quale istante è maggiore la vendita di energia, e quindi consigliare all'utente di accendere quel programma a quell'istante.
    
    INSERT INTO Suggerimento(ID_Programma, Istante, Convenienza)
    # Adesso seguono tutte le CTE usate per la creazione della query
	WITH ProgrammiTarget AS (
		# Otteniamo i seguenti programmi utili che considereremo secondo al seguente scelta:
		# 1) Consideriamo solo i dispositivi che sono stati usati il giorno prima
		# 2) Consideriamo solo i dispositivi variabili non interrompibili
		# 3) Consideriamo solo i primi 3 dispositivi con un consumo maggiore di energia
		SELECT D.ID_Programma, D.PotenzaMedia * D.DurataTemporale AS Consumo, D.DurataTemporale AS DurataInOre, D.ID_Dispositivo, D.PotenzaMedia
		FROM
		(
			SELECT DISTINCT P.*, RANK() OVER (ORDER BY PotenzaMedia * DurataTemporale DESC) AS RNK
			FROM RegistroDispositivo RD
				 INNER JOIN
				 Programma P ON RD.ID_Programma = P.ID_Programma
			WHERE DATE(RD.IstanteInizio) = CURRENT_DATE - INTERVAL 1 DAY
				  AND P.DurataTemporale IS NOT NULL
		 ) AS D
		 WHERE RNK <= 3 AND D.PotenzaMedia * D.DurataTemporale >= 0.50
	),
	# Otteniamo una fila di intervalli con stessa data inizio e con diversi sottoistanti inizio, ogni sotto intervallo ha una data di conclusione, che è 
	# il sotto intervallo successivo nel caso ci sia, altrimenti l'istante di fine del'esecuzione del programma
	# Abbiamo bisogno di suddividere prima in sotto intervalli perchè la potenza venduta in quel momento è diversa rispetto agli altri sotto intervalli dello stesso
	# intervallino che andremo a studiare come momento in cui il programma verrebbe eseguito.
	# Ricordiamo, dobbiamo cercare l'intervallo che ha più quntità di energia venduta. 
	SottoIntervalliTarget AS (
		SELECT *, 
			   IF(
				  LEAD(D00.IstanteSottoIntervalloInizio) OVER (PARTITION BY D00.IstanteInizio, D00.ID_Programma ORDER BY D00.IstanteSottoIntervalloInizio ASC) IS NOT NULL, 
				  LEAD(D00.IstanteSottoIntervalloInizio) OVER (PARTITION BY D00.IstanteInizio, D00.ID_Programma ORDER BY D00.IstanteSottoIntervalloInizio ASC), 
				  D00.IstanteFine
				 ) AS IstanteSottoIntervalloFine
		FROM
			(
			SELECT D0.Istante AS IstanteInizio, TIMESTAMP(D0.Istante + INTERVAL D0.DurataInOre * 3600 SECOND) AS IstanteFine,
				   D0.ID_Programma, D0.Consumo, CB1.Istante AS IstanteSottoIntervalloInizio, CB1.VenditaReteElettrica
			FROM
				(
				SELECT *
				FROM ProgrammiTarget PT
                     INNER JOIN		
                     ContatoreBidirezionale CB0 ON DATE(CB0.Istante) >= CURRENT_DATE - INTERVAL 1 WEEK
												AND DATE(CB0.Istante) < CURRENT_DATE
			
				) AS D0
				 INNER JOIN
				 ContatoreBidirezionale CB1 ON D0.Istante + INTERVAL D0.DurataInOre * 3600 SECOND >= CB1.Istante
											   AND CB1.Istante >= D0.Istante
			) AS D00
	),
	# Ottenimento di tutte le possibili combinazioni di istanti successivi per ogni programma analizzato
	# Gli intervalli hanno come durata temporale la durata del corrispettivo programma
	# Abbiamo selezionato anche la QuantitaEnergiaVendutaTotale in kWh nell'intervallo specifico, sommando quelle nei sotto intervalli,
	#  perchè la stima verrà fatta rispetto a questo dato.
	IntervalliTarget AS (
		SELECT D.IstanteInizio, D.ID_Programma, D.Consumo, D.IstanteFine, SUM(D.QuantitaEnergiaVenduta) AS QuantitaEnergiaVendutaTotale,
			   IF(
				   LEAD(D.IstanteInizio) OVER (PARTITION BY D.ID_Programma ORDER BY D.IstanteInizio ASC) IS NULL,
                   TIMESTAMP(CURRENT_DATE - INTERVAL 1 DAY, "23:59:59"), 
                   LEAD(D.IstanteInizio) OVER (PARTITION BY D.ID_Programma ORDER BY D.IstanteInizio ASC)
               ) AS IstanteProssimoIntervallo
		FROM 
			(
				SELECT *, 
					   (SIT.VenditaReteElettrica * (TIMESTAMPDIFF(second, SIT.IstanteSottoIntervalloInizio, SIT.IstanteSottoIntervalloFine)/3600)) AS QuantitaEnergiaVenduta
				FROM SottoIntervalliTarget SIT
			) AS D
		GROUP BY D.IstanteInizio, D.ID_Programma
	),
	# Effettuiamo la MediaPonderata per ogni istante del giorno di ieri
	# Joiniamo ogni intervallo di ieri per un intervallo per ogni giorno fino ad una settimana, trovando l'intervallo che comprende l'istante di inizio di ieri
	# Poi andiamo a calcolare per ogni istante di ieri una media ponderata della quantità di energia venduta rispetto ai giorni precedenti, 
	# dando più valore ai giorni più prossimi
	MediaPonderata AS (
		SELECT D.IstanteInizioCandidato, D.ID_Programma, SUM(D.QuantitaEnergiaVendutaTotale * D.ValorePonderato)/24 AS MediaMobilePonderataEnergiaVenduta, D.Consumo
		FROM
			(
			SELECT TIME(IDI.IstanteInizio) AS IstanteInizioCandidato, 
				   RANK() OVER (PARTITION BY TIME(IT.IstanteInizio), IT.ID_Programma ORDER BY IT.IstanteInizio ASC) AS ValorePonderato,
				   IT.*
			FROM
				(
					SELECT *
					FROM IntervalliTarget IT
					WHERE DATE(IT.IstanteInizio) = CURRENT_DATE - INTERVAL 1 DAY
				) AS IDI -- intervalli di ieri
				INNER JOIN
				IntervalliTarget IT ON TIME(IDI.IstanteInizio) >= TIME(IT.IstanteInizio) AND
									   TIME(IDI.IstanteInizio) < TIME(IT.IstanteProssimoIntervallo) AND
									   IDI.ID_Programma = IT.ID_Programma
			 ) AS D
		GROUP BY D.IstanteInizioCandidato, D.ID_Programma
	)
	-- Adesso ritorneremo inserendo i consigli di esecuzione (i tre maggiori per ogni programma), all'interno della tabella "Suggerimento"
	SELECT D.ID_Programma, TIMESTAMP(CURRENT_DATE, D.IstanteInizioCandidato) AS Istante, D.Convenienza
	FROM (
		  SELECT MP.IstanteInizioCandidato, MP.ID_Programma, MP.MediaMobilePonderataEnergiaVenduta, 
				 RANK() OVER (PARTITION BY MP.ID_Programma ORDER BY MP.MediaMobilePonderataEnergiaVenduta DESC) AS Convenienza,
				 MP.Consumo
		  FROM MediaPonderata MP
		 ) AS D
	WHERE D.Convenienza <= 3;

END $$
DELIMITER ;

# Ottimizzazione Consumi Energetici
DROP EVENT IF EXISTS OffertaSuggerimenti;
CREATE EVENT OffertaSuggerimenti
ON SCHEDULE EVERY 1 DAY
STARTS '2021-11-08 03:00:00'
DO
	CALL Suggerimenti();
    
    
CALL Suggerimenti();