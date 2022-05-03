/* Autori: Alex Moriconi & Lorenzo Valtriani
   Versione: 1.0	
   Descrizione: Implementazione operazioni 1-8
   Data: 11/2021
*/
# ----------------------------------------------------- INIZIO 1° OPERAZIONE -----------------------------------------------------
DROP FUNCTION IF EXISTS CalcoloConsumoDispositivoVariabileInterrompibile;
DELIMITER $$
CREATE FUNCTION CalcoloConsumoDispositivoVariabileInterrompibile(IstanteInizio_ TIMESTAMP, ID_Dispositivo_ INT)
RETURNS DOUBLE DETERMINISTIC
BEGIN
	/* Dichiarazione Variabili di impiego */
    DECLARE TipologiaDispositivo_ INTEGER DEFAULT 0;
    DECLARE ConsumoDispositivo_ DOUBLE DEFAULT 0;
    DECLARE Check_Dispositivo INTEGER DEFAULT 0;
    DECLARE Check_IstanteInizio INTEGER DEFAULT 0;
    
    /* Controllo Esistenza Dispositivo */
    SELECT D.ID_Dispositivo INTO Check_Dispositivo
    FROM Dispositivo D
    WHERE D.ID_Dispositivo=ID_Dispositivo_;
    
    IF Check_Dispositivo = 0 THEN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "ERROR (CalcoloConsumoDispositivoVariabileInterrompibile): Dispositivo Inesistente!";
	END IF;

    /* Controllo Esistenza Istante Inizio e ID_Dispositivo */
    SELECT COUNT(*) INTO Check_IstanteInizio
    FROM RegistroDispositivo RD
    WHERE RD.IstanteInizio=IstanteInizio_ AND RD.ID_Dispositivo=ID_Dispositivo_;
    
	IF Check_IstanteInizio = 0 THEN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "ERROR (CalcoloConsumoDispositivoVariabileInterrompibile): Non esiste alcun record con tale chiave nella tabella";
	END IF;
    
    /* Verifica Dispositivo Variabile Interrompibile */
	SELECT D.ID_TipologiaDispositivo INTO TipologiaDispositivo_
    FROM Dispositivo D
		 INNER JOIN
         TipologiaDispositivo TD ON D.ID_TipologiaDispositivo=TD.ID_TipologiaDispositivo
	WHERE D.ID_Dispositivo=ID_Dispositivo_;
    
    IF TipologiaDispositivo_<> 2 THEN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "ERROR (CalcoloConsumoDispositivoVariabileInterrompibile): Il dispositivo immesso non è variabile interrompibile!";
	END IF;
    
    /* Esecuzione calcolo per produrre il consumo */
    SELECT IF(RD.IstanteFine IS NOT NULL, (TIMESTAMPDIFF(second, RD.IstanteInizio, RD.IstanteFine) / 3600) * P.PotenzaMedia, -1) INTO ConsumoDispositivo_
    FROM RegistroDispositivo RD
		 INNER JOIN
		 Programma P ON P.ID_Programma = RD.ID_Programma
    WHERE RD.ID_Dispositivo=ID_Dispositivo_ AND RD.IstanteInizio=IstanteInizio_;
    
    /* Verifica che il record di esecuzione abbia avuto la fine */
	IF ConsumoDispositivo_ = -1 THEN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "ERROR (CalcoloConsumoDispositivoVariabileInterrompibile): Il dispositivo non è ancora stato spento!";
	END IF;
    RETURN ConsumoDispositivo_;
END $$
DELIMITER ;

#SELECT CalcoloConsumoDispositivoVariabileInterrompibile("2021-11-22 10:07:00", 4); #Corretto
#SELECT CalcoloConsumoDispositivoVariabileInterrompibile("2021-11-01 00:00:00", 1); # Errore, istante fine non inserita
#SELECT CalcoloConsumoDispositivoVariabileInterrompibile("2021-11-01 2:04:04", 1); # Errore, chiave non vera
#SELECT CalcoloConsumoDispositivoVariabileInterrompibile("2021-11-01 11:15:00", 3); # Errore, dispositivo non è variabile non interrompibile

# ------------------------------------------------------ FINE 1° OPERAZIONE ------------------------------------------------------
# ----------------------------------------------------- INIZIO 2° OPERAZIONE -----------------------------------------------------
DROP PROCEDURE IF EXISTS CalcoloRiepilogoParziale;
DELIMITER $$
CREATE PROCEDURE CalcoloRiepilogoParziale(OUT TotaleVendita_ DOUBLE, OUT TotaleAcquisto_ DOUBLE, OUT ConsumoTotaleAbitazione_ DOUBLE, OUT ImportoTotaleAcquisto_ DOUBLE, OUT ImportoTotaleVendita_ DOUBLE)
BEGIN
    DECLARE PrezzoVendita_ DOUBLE DEFAULT 0.10; # Prezzo di vendita dell'energia Elettrica
    
	SELECT SUM(S4.Vendita), SUM(S4.Acqusito), SUM(S4.Consumo), SUM(S4.ImportoAcquisto), SUM(S4.ImportoVendita)
	INTO TotaleVendita_, TotaleAcquisto_, ConsumoTotaleAbitazione_, ImportoTotaleAcquisto_, ImportoTotaleVendita_
	FROM
	(
		SELECT S3.Istante, S3.AcquistoReteElettrica*S3.Durata AS Acqusito, S3.VenditaReteElettrica*S3.Durata AS Vendita, S3.PotenzaTotaleAbitazione*S3.Durata AS Consumo, S3.AcquistoReteElettrica*S3.Durata*S3.Prezzo AS ImportoAcquisto, S3.VenditaReteElettrica*S3.Durata*PrezzoVendita_ AS ImportoVendita
		FROM
		(
			SELECT S2.Istante, TIMESTAMPDIFF(second,TIME(S2.Istante),TIME(S2.IstanteFine))/3600 AS Durata, S2.AcquistoReteElettrica, S2.VenditaReteElettrica, S2.PotenzaTotaleAbitazione, S2.Prezzo
			FROM
			(	SELECT CB.Istante,IF(LEAD(CB.Istante) OVER (ORDER BY CB.Istante) IS NULL, CURRENT_TIMESTAMP, LEAD(CB.Istante) OVER (ORDER BY CB.Istante)) AS IstanteFine, CB.AcquistoReteElettrica, CB.VenditaReteElettrica, CB.PotenzaTotaleAbitazione, FO.Prezzo
				FROM ContatoreBidirezionale CB
					INNER JOIN FasciaOraria FO
					ON CB.ID_FasciaOraria=FO.ID_FasciaOraria
				WHERE DATE(CB.Istante)=CURRENT_DATE) AS S2
		)AS S3
	)AS S4;

END $$
DELIMITER ;

#CALL CalcoloRiepilogoParziale(@TotaleVendita, @TotaleAcquisto, @ConsumoTotaleAbitazione, @ImportoTotaleAcquisto, @ImportoTotaleVendita);
#SELECT @TotaleVendita, @TotaleAcquisto, @ConsumoTotaleAbitazione, @ImportoTotaleAcquisto, @ImportoTotaleVendita;
# ------------------------------------------------------ FINE 2° OPERAZIONE ------------------------------------------------------
# ----------------------------------------------------- INIZIO 3° OPERAZIONE -----------------------------------------------------
DROP PROCEDURE IF EXISTS InserisciUtente;
DELIMITER $$
CREATE PROCEDURE InserisciUtente(IN Nome_ VARCHAR(30), IN Cognome_ VARCHAR(30), IN DataNascita_ DATE, IN Telefono_ VARCHAR(15), IN CodFiscale_ VARCHAR(16),
								 IN Username_ VARCHAR(30), IN Password_ VARCHAR(40), IN Risposta_ VARCHAR(100), IN ID_Domanda_ INT, IN Tipologia_ VARCHAR(60),
                                 IN EnteRilascio_ VARCHAR(60), IN CodiceDocumento_ VARCHAR(60), IN DataScadenza_ DATE)
BEGIN
	DECLARE ID_Documento_ INT DEFAULT 0;
    
    # inseriamo prima i dati relativi al documento
	INSERT INTO Documento (Tipologia, EnteRilascio, CodiceDocumento, DataScadenza)
	VALUES (Tipologia_, EnteRilascio_, CodiceDocumento_, DataScadenza_);
    
    # Ultimo valore di identità creato nella sessione corrente, per ottenere quindi l'id del documento appena creato
    SET ID_Documento_ = @@IDENTITY;
    
    # Inseriamo infine i dati relativi all'utente
	INSERT INTO Utente (Nome, Cognome, DataNascita, Telefono, CodiceFiscale, Username, Password, Risposta, ID_Domanda, ID_Documento)
	VALUES (Nome_, Cognome_, DataNascita_, Telefono_, CodFiscale_, Username_, Password_, Risposta_, ID_Domanda_, ID_Documento_);
END $$
DELIMITER ;

#CALL InserisciUtente("Filippo", "Pigiami", "2001-11-05", 3452398762, "PGMFLPN05G702D", "Pirachimico", "4a0a19218e082a343a1b17e65a3409af9d98f0f5", "Piruu", 1,
#					 "Carta di identità", "Comune di Pisa", "ED93495BK", "2022-06-23");

# ------------------------------------------------------ FINE 3° OPERAZIONE ------------------------------------------------------
# ----------------------------------------------------- INIZIO 4° OPERAZIONE -----------------------------------------------------
DROP PROCEDURE IF EXISTS InserimentoImpostazioneCondizionamentoProgrammataRipetitiva;
# Funzione che permetterà di effettuare lo split di una stringa di inserimento
DROP FUNCTION IF EXISTS SPLIT_STRING;
DELIMITER $$
CREATE FUNCTION SPLIT_STRING (s VARCHAR(1024),del CHAR(1),i INT)
RETURNS VARCHAR(1024)
DETERMINISTIC
BEGIN
	DECLARE n INT ;
	SET n = LENGTH(s) - LENGTH(REPLACE(s, del, '')) + 1;
	IF i > n THEN
		RETURN NULL ;
	ELSE
		RETURN SUBSTRING_INDEX(SUBSTRING_INDEX(s, del, i) , del , -1 ) ;        
	END IF;
END $$
DELIMITER;
       
DELIMITER $$
CREATE PROCEDURE InserimentoImpostazioneCondizionamentoProgrammataRipetitiva(IN TemperaturaDesiderata_ DOUBLE, IN UmiditaDesiderata_ DOUBLE, IN OraInizio_ TIME, IN OraFine_ TIME, IN Mesi_ VARCHAR(100), IN Giorni_ VARCHAR(100), IN ID_Utente_ INTEGER, IN ID_Climatizzatore_ INT)
BEGIN
	DECLARE ID_Record_ INTEGER DEFAULT 0;
    DECLARE Contatore_ INTEGER DEFAULT 0;
	INSERT INTO ImpostazioneClimatizzatore (TemperaturaDesiderata,UmiditaDesiderata,OraInizio,OraFine,DataInizio,DataFine,Ripetitiva,ID_Utente)
    VALUES ( TemperaturaDesiderata_, UmiditaDesiderata_, OraInizio_, OraFine_, NULL, NULL, 1,ID_Utente_);
    SET ID_Record_ = LAST_INSERT_ID(); #Permette di ottenere la chiave primaria del record appena inserito
    
	#Inserimento condizionamento di riferimento
    INSERT INTO Riferito(ID_Climatizzatore, ID_ImpostazioneClimatizzatore)
    VALUES (ID_Climatizzatore_, ID_Record_);
    
    #Inserimento mesi di ripetizione
	SET Contatore_=1;
    mesi: WHILE SPLIT_STRING(Mesi_,",",Contatore_) IS NOT NULL DO
		INSERT INTO MesiAttivi (ID_ImpostazioneClimatizzatore, NumeroMese)
        VALUES (ID_Record_, SPLIT_STRING(Mesi_,",",Contatore_));
        SET Contatore_=Contatore_+1;
	END WHILE mesi;
    
    #Inserimento giorni di ripetizione
    SET Contatore_=1;
    giorni: WHILE SPLIT_STRING(Giorni_,",",Contatore_) IS NOT NULL DO
		INSERT INTO GiorniAttivi (ID_ImpostazioneClimatizzatore, NumeroGiorno)
        VALUES (ID_Record_, SPLIT_STRING(Giorni_,",",Contatore_));
        SET Contatore_=Contatore_+1;
	END WHILE giorni;
END $$
DELIMITER ;

#CALL InserimentoImpostazioneCondizionamentoProgrammataRipetitiva(24.5,50,"15:00:00","18:00:00","1,2,3,4,5,6,7,8,9,10,11,12","1,2,3,4,5,6,7",1,1);

# ------------------------------------------------------ FINE 4° OPERAZIONE ------------------------------------------------------
# ----------------------------------------------------- INIZIO 5° OPERAZIONE -----------------------------------------------------
DROP PROCEDURE IF EXISTS CalcoloRiepilogoEnergetico;
DELIMITER $$
CREATE PROCEDURE CalcoloRiepilogoEnergetico(IN GiornoRiepilogo DATE)
BEGIN
	DECLARE CheckRiepilogoGiornaliero_ INTEGER DEFAULT 1;
	DECLARE TotaleVendita_ DOUBLE DEFAULT 0;
	DECLARE TotaleAcquisto_ DOUBLE DEFAULT 0;
	DECLARE TotaleConsumi_ DOUBLE DEFAULT 0;
	DECLARE ImportoTotaleVendita_ DOUBLE DEFAULT 0;
	DECLARE ImportoTotaleAcquisto_ DOUBLE DEFAULT 0;
    DECLARE PrezzoVendita_ DOUBLE DEFAULT 0.10; # Prezzo di vendita dell'energia Elettrica
	/* verifica terminazione giorno */
	IF GiornoRiepilogo=DATE(CURRENT_DATE) THEN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "ERROR (OttenimentoRiepilogoEnergetico): Il giorno non è ancora terminato!";
	END IF;
	/* Calcolo valori somma di riepilogo */

	SELECT SUM(S4.Vendita), SUM(S4.Acqusito), SUM(S4.Consumo), SUM(S4.ImportoAcquisto), SUM(S4.ImportoVendita)
	INTO TotaleVendita_, TotaleAcquisto_, TotaleConsumi_, ImportoTotaleAcquisto_, ImportoTotaleVendita_
	FROM
	(
		SELECT S3.Istante, S3.AcquistoReteElettrica*S3.Durata AS Acqusito, S3.VenditaReteElettrica*S3.Durata AS Vendita, S3.PotenzaTotaleAbitazione*S3.Durata AS Consumo, S3.AcquistoReteElettrica*S3.Durata*S3.Prezzo AS ImportoAcquisto, S3.VenditaReteElettrica*S3.Durata*PrezzoVendita_ AS ImportoVendita
		FROM
		(
			SELECT S2.Istante, TIMESTAMPDIFF(second,TIME(S2.Istante),TIME(S2.IstanteFine))/3600 AS Durata, S2.AcquistoReteElettrica, S2.VenditaReteElettrica, S2.PotenzaTotaleAbitazione, S2.Prezzo
			FROM
			(	SELECT CB.Istante, IF(LEAD(CB.Istante) OVER (ORDER BY CB.Istante) IS NULL, CONCAT(GiornoRiepilogo,' 23:59:59'), LEAD(CB.Istante) OVER (ORDER BY CB.Istante)) AS IstanteFine, CB.AcquistoReteElettrica, CB.VenditaReteElettrica, CB.PotenzaTotaleAbitazione, FO.Prezzo
				FROM ContatoreBidirezionale CB
					INNER JOIN FasciaOraria FO
					ON CB.ID_FasciaOraria=FO.ID_FasciaOraria
				WHERE DATE(CB.Istante)=GiornoRiepilogo) AS S2
		)AS S3
	)AS S4;

	/* Verifica unicità del calcolo */
	SELECT COUNT(*) INTO CheckRiepilogoGiornaliero_
	FROM RiepilogoEnergeticoGiornaliero REG
	WHERE REG.Data=GiornoRiepilogo;

	IF CheckRiepilogoGiornaliero_ <> 0 THEN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "ERROR (RiepilogoEnergeticoGiornoPrecedente): Il riepilogoGiornaliero di Ieri è già stato calcolato!";
	END IF;

	/* Inserimento dei dati estrapolati nella tabella RiepilogoEnergeticoGiornaliero */
	INSERT INTO RiepilogoEnergeticoGiornaliero (Data, TotaleAcquisto, TotaleVendita, TotaleConsumi, ImportoTotaleAcquisto, ImportoTotaleVendita)
	VALUES (GiornoRiepilogo, TotaleAcquisto_, TotaleVendita_, TotaleConsumi_, ImportoTotaleAcquisto_, ImportoTotaleVendita_);
	
	/* Aggiornamento dei Record di ContatoreBidirezionale Con il valore effettivo del riepilogo giornaliero corrispondente */
    SET SQL_SAFE_UPDATES=0;
	UPDATE ContatoreBidirezionale
	SET DataRiepilogo=GiornoRiepilogo
	WHERE DATE(Istante)=GiornoRiepilogo;
    SET SQL_SAFE_UPDATES=1;
    
END $$
DELIMITER ;

#CALL CalcoloRiepilogoEnergetico("2021-11-22");

/* Event che permette l'esecuzione automatica della procedura di calcolo ogni notte, allo scadere del giorno */
DROP EVENT IF EXISTS Event_CalcoloRiepilogoEnergetico;
CREATE EVENT Event_CalcoloRiepilogoEnergetico
	ON SCHEDULE
		#STARTS "2021-11-01 00:00:00"
		EVERY 1 DAY
	COMMENT 'Calcolo RiepilogoEnergeticoGiornaliero'
	DO 
		CALL RiepilogoEnergeticoGiornoPrecedente(DATE(CURRENT_DATE) - INTERVAL 1 DAY);

/* Procedura di lettura dei dati di un dato riepilogo energetico giornaliero */
DROP PROCEDURE IF EXISTS OttenimentoRiepilogoEnergetico;
DELIMITER $$
CREATE PROCEDURE OttenimentoRiepilogoEnergetico(IN GiornoRiepilogo DATE, OUT TotaleVendita_ DOUBLE, OUT TotaleAcquisto_ DOUBLE, OUT ConsumoTotaleAbitazione_ DOUBLE, OUT ImportoTotaleAcquisto_ DOUBLE, OUT ImportoTotaleVendita_ DOUBLE)
BEGIN
	DECLARE Check_RiepilogoGiornaliero INTEGER DEFAULT 0;
	/* Verifica giorno ed presenza riepilogo giornaliero */
	IF GiornoRiepilogo=DATE(CURRENT_DATE) THEN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "ERROR (OttenimentoRiepilogoEnergetico): Il giorno non è ancora terminato!";
	END IF;
	
	SELECT COUNT(*) INTO Check_RiepilogoGiornaliero
	FROM RiepilogoEnergeticoGiornaliero
	WHERE Data=GiornoRiepilogo;

	IF Check_RiepilogoGiornaliero = 0 THEN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "ERROR (OttenimentoRiepilogoEnergetico): Riepilogo ancora non calcolato, attendere esecuzione Event!";
	END IF;
	
	SELECT TotaleVendita, TotaleAcquisto, TotaleConsumi, ImportoTotaleAcquisto, ImportoTotaleVendita
	INTO TotaleVendita_, TotaleAcquisto_, ConsumoTotaleAbitazione_, ImportoTotaleAcquisto_, ImportoTotaleVendita_
	FROM RiepilogoEnergeticoGiornaliero
	WHERE Data=GiornoRiepilogo;
END $$
DELIMITER ;

#CALL OttenimentoRiepilogoEnergetico("2021-11-22", @TotaleVendita, @TotaleAcquisto, @ConsumoTotaleAbitazione, @ImportoTotaleAcquisto, @ImportoTotaleVendita);
#SELECT @TotaleVendita, @TotaleAcquisto, @ConsumoTotaleAbitazione, @ImportoTotaleAcquisto, @ImportoTotaleVendita;

# ------------------------------------------------------ FINE 5° OPERAZIONE ------------------------------------------------------
# ----------------------------------------------------- INIZIO 6° OPERAZIONE -----------------------------------------------------
DROP PROCEDURE IF EXISTS ElencoSerramentiAperti;
DELIMITER $$
CREATE PROCEDURE ElencoSerramentiAperti()
BEGIN
	DROP TABLE IF EXISTS ElencoSerramentiAperti;
	CREATE TEMPORARY TABLE ElencoSerramentiAperti
    SELECT S.ID_Serramento AS ID, S.Nome AS Nome
    FROM Serramento S
    WHERE S.Aperto=1;
END $$
DELIMITER ;

#CALL ElencoSerramentiAperti();
#SELECT * FROM ElencoSerramentiAperti;

# ------------------------------------------------------ FINE 6° OPERAZIONE ------------------------------------------------------
# ----------------------------------------------------- INIZIO 7° OPERAZIONE -----------------------------------------------------
DROP PROCEDURE IF EXISTS InserimentoInterazioneLuca;
DELIMITER $$
CREATE PROCEDURE InserimentoInterazioneLuca(IN Intensita_ DOUBLE, IN Temperatura_ DOUBLE, IN ID_Utente_ INTEGER, IN ID_Luce INTEGER, IN IstanteInizio_ TIMESTAMP, IN IstanteFine_ TIMESTAMP)
BEGIN
	# Inserimento valori nel Registro Illuminazione
	INSERT INTO RegistroIlluminazione (IstanteInizio, ID_Luce, Intensita, Temperatura, IstanteFine, ID_Utente)
    VALUES (IstanteInizio_, ID_Luce, Intensita_, Temperatura_, IstanteFine_, ID_Utente_);
    
END $$
DELIMITER ;

#CALL InserimentoInterazioneLuca(80,3000,1,1,"2021-11-19 08:00:00","2021-11-19 09:00:00");

# ------------------------------------------------------ FINE 7° OPERAZIONE ------------------------------------------------------
# ----------------------------------------------------- INIZIO 8° OPERAZIONE -----------------------------------------------------

DROP FUNCTION IF EXISTS ConsumoInterazioneClimatizzazione;
DELIMITER $$
CREATE FUNCTION ConsumoInterazioneClimatizzazione(ID_ElementoCondizionamento_ INTEGER, IstanteInizio_ TIMESTAMP)
RETURNS DOUBLE DETERMINISTIC
BEGIN
	DECLARE Potenza1Grado_ DOUBLE DEFAULT 0;
    DECLARE Consumo_ DOUBLE DEFAULT 0;
    
    # Calcolo della potenza necessaria a riscaldare / raffreddare un grado.
	SELECT S.SpessoreParete*S.ConducibilitaTermica*((S.Altezza*S.Larghezza)*2+(S.Altezza*S.Lunghezza)*2+(S.Larghezza*S.Lunghezza)*2)
    INTO Potenza1Grado_
    FROM Stanza S
    INNER JOIN
	(	SELECT *
		FROM Climatizzatore
		WHERE ID_Climatizzatore=ID_ElementoCondizionamento_
	) AS C
    ON C.ID_Stanza=S.ID_Stanza;
    
    # Calcolo del consumo, ottenuto dalla formula [ Potenza1Grado * * DifferenzaTemperatura * DurataTemporaleOre ]
    SELECT Potenza1Grado_*ABS(TemperaturaObiettivo-TemperaturaIniziale)*(TIMESTAMPDIFF(second, IstanteInizio, IstanteFine)/3600)
    INTO Consumo_
    FROM RegistroClimatizzatore RC
    WHERE RC.IstanteInizio=IstanteInizio_ AND RC.ID_Climatizzatore=ID_ElementoCondizionamento_;
    RETURN Consumo_;
END $$
DELIMITER ;

#SELECT ConsumoInterazioneClimatizzazione(1,"2021-11-22 06:30:00");
# ------------------------------------------------------ FINE 8° OPERAZIONE ------------------------------------------------------

