-- ----------------------------------------------------------
--   1.	Verifica disponibilità delle unità per un ordine   --
-- ----------------------------------------------------------
SET GLOBAL log_bin_trust_function_creators = 1; -- Senza questo comando, Workbench non mi permette di creare function non deterministic :C
DROP FUNCTION IF EXISTS VerificaDisponibilitaOrdine;
DELIMITER $$
CREATE FUNCTION VerificaDisponibilitaOrdine(_CodiceOrdine INT)
RETURNS BOOLEAN NOT DETERMINISTIC
BEGIN
    -- Verifica della presenza dell'ordine
	DECLARE flag INT DEFAULT 0;

	SELECT COUNT(*) INTO flag
    FROM Ordine O
    WHERE O.CodiceOrdine = _CodiceOrdine;
    
    IF flag = 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "CodiceOrdine inserito non valido";
    END IF;

    WITH DaVerificare AS(
		SELECT UA.CodiceSeriale, COUNT(*) AS Quante -- sono le unità acquistate di cui dobbiamo verificare la disponibilità
        FROM UnitaAcquistata UA
        WHERE UA.CodiceOrdine = _CodiceOrdine
        GROUP BY UA.CodiceSeriale
    ), DisponibilitaLotti AS( -- Sono i lotti che potrebbero fornire le unità: quelle relative 
                              -- a quella specifica variante, che non sono già conclusi e che non sono ancora da produrre
		SELECT L.CodiceSeriale, SUM(L.Rimanente) AS Disponibilita
        FROM Lotto L
        WHERE L.CodiceSeriale IN (
                SELECT DV.CodiceSeriale
                FROM DaVerificare DV
            )
			AND (L.Rimanente IS NOT NULL AND L.Rimanente <> 0)
		GROUP BY L.CodiceSeriale
    )
    SELECT SUM(IF(DL.Disponibilita IS NULL OR DL.Disponibilita < DV.Quante, 1, 0)) INTO flag -- Sommo qualcosa a flag solo se non sono disponibili
                                                                                         -- dei lotti o se non vi è abbastanza materiale. Se flag
                                                                                         -- è diverso da 0, allora c'è almeno un prodotto per cui
                                                                                         -- non posso fornire delle unità.
    FROM DaVerificare DV
		 LEFT OUTER JOIN
         DisponibilitaLotti DL USING(CodiceSeriale);
    
	RETURN IF(flag = 0, TRUE, FALSE);
END $$
DELIMITER ;

-- Dopo aver verificato che un ordine sia realizzabile, devo anche aggiornare le quantità rimanente del lotto da cui ho preso il materiale.
DROP TRIGGER IF EXISTS AggiornaQuantitaLotto;
DELIMITER $$
CREATE TRIGGER AggiornaQuantitaLotto
AFTER UPDATE ON Ordine
FOR EACH ROW
BEGIN
	DECLARE finito INT DEFAULT 0;
    DECLARE VarianteCur INT DEFAULT 0;
    DECLARE QuanteCur INT DEFAULT 0;
	DECLARE daModificare CURSOR FOR
		SELECT UA.CodiceSeriale, COUNT(*) AS Quante
		FROM UnitaAcquistata UA
		WHERE UA.CodiceOrdine=NEW.CodiceOrdine
		GROUP BY UA.CodiceSeriale;
	DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito =1;
    
	IF (OLD.Stato="Processazione" OR OLD.Stato="Pendente") AND NEW.Stato="Preparazione" THEN
		
        OPEN daModificare;
        Scorri : LOOP
			FETCH daModificare INTO VarianteCur,QuanteCur;
            IF finito=1 THEN
				LEAVE Scorri;
			END IF;
            WHILE QuanteCur <> 0 DO
				UPDATE Lotto L
                SET L.Rimanente=L.Rimanente-1
                WHERE L.CodiceSeriale = VarianteCur
					  AND (L.Rimanente<>0 AND L.Rimanente IS NOT NULL)
                      AND NOT EXISTS(
										SELECT 1
                                        FROM (
												SELECT *
                                                FROM Lotto
											 ) AS L2
										WHERE L2.CodiceSeriale=VarianteCur
											  AND (L.Quantita<>0 OR L.Quantita IS NOT NULL)
                                              AND L2.DataEffettiva<L.DataEffettiva
									);
				SET QuanteCur = QuanteCur-1;
            END WHILE;
        END LOOP;
		CLOSE daModificare;
    END IF;
END $$
DELIMITER ;
-- -------------------------
--   Fine Operazione 1   --
-- -------------------------

-- ---------------------------------------------------------------------
--   2.	Incasso complessivo dell’azienda in un intervallo temporale  --
-- ---------------------------------------------------------------------
DROP PROCEDURE IF EXISTS IncassoAzienda;
DELIMITER $$
CREATE PROCEDURE IncassoAzienda(IN Data1 DATE, IN Data2 DATE, OUT Incasso FLOAT)
BEGIN
	DECLARE IncassoOrdini FLOAT DEFAULT 0;
    DECLARE IncassoAssistenza FLOAT DEFAULT 0; 

    IF Data1>Data2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Periodo inserito non valido";
    END IF;
		
    -- Somma del guadagno dovuto all'ordine 
	SELECT SUM(O.Costo) INTO IncassoOrdini
    FROM Ordine O
    WHERE 	O.DataIncasso IS NOT NULL AND
			O.DataIncasso BETWEEN Data1 AND Data2;
    
    -- Somma del guardagno dovuto agli interventi di assistenza fisica
    SELECT SUM(RF.CostoTotale) INTO IncassoAssistenza
    FROM Intervento I
		 NATURAL JOIN
         RicevutaFiscale RF
	WHERE I.Data BETWEEN Data1 AND Data2
		  AND NOT EXISTS (
							SELECT 1
                            FROM Intervento I2
                            WHERE I2.CodiceAssistenza=I.CodiceAssistenza
								  AND I2.Data>I.Data
						 );
                         
	SET Incasso = IFNULL(IncassoAssistenza,0) + IFNULL(IncassoOrdini,0);
    SELECT Data1, Data2, Incasso;

END $$
DELIMITER ;

-- Function che permette, dato un ordine, di calcolare quanto è l'importo
DROP FUNCTION IF EXISTS CalcoloCostoOrdine;
DELIMITER $$
CREATE FUNCTION CalcoloCostoOrdine(CodiceOrdine INT)
RETURNS FLOAT NOT DETERMINISTIC
BEGIN
    DECLARE CostoGaranzie FLOAT DEFAULT 0;
    DECLARE CostoVarianti FLOAT DEFAULT 0;
    DECLARE CostoProdotti FLOAT DEFAULT 0;

    -- Importo dovuto all'estesione della garanzia
    SELECT SUM(FG.Costo) INTO CostoGaranzie
    FROM UnitaAcquistata UA
		INNER JOIN
        Estensione E USING (IDUnita)
		INNER JOIN
		FormulaGaranzia FG USING (CodiceGaranzia)
    WHERE UA.CodiceOrdine=CodiceOrdine;

	-- Importo dovuto al solo prodotto privo di varianti
    SELECT SUM(IF(VDP.Ricondizionato IS FALSE,P.Prezzo,P.Prezzo*0.8)) INTO CostoProdotti
    FROM UnitaAcquistata UA
		INNER JOIN
        VarianteDiProdotto VDP USING(CodiceSeriale)
        INNER JOIN
        Prodotto P USING (IDProdotto)
    WHERE UA.CodiceOrdine=CodiceOrdine;

    -- Importo dovuto alle varianti
    SELECT SUM(IF(VDP.Ricondizionato IS TRUE, V.Prezzo*0.8, V.Prezzo)) INTO CostoVarianti
    FROM UnitaAcquistata UA
		INNER JOIN
        VarianteDiProdotto VDP USING(CodiceSeriale)
		INNER JOIN
        Modello M USING (CodiceSeriale)
        INNER JOIN
        Variante V USING (IDVariante)
    WHERE UA.CodiceOrdine = CodiceOrdine;

    RETURN IFNULL(CostoVarianti,0) + IFNULL(CostoProdotti,0) + IFNULL(CostoGaranzie,0);
END $$
DELIMITER ;

-- trigger per la gestione dello stato dell'ordine
DROP TRIGGER IF EXISTS GestioneStatoOrdine;
DELIMITER $$
CREATE TRIGGER GestioneStatoOrdine
BEFORE UPDATE ON ORDINE
FOR EACH ROW
BEGIN
	DECLARE Costo FLOAT DEFAULT 0;
    DECLARE CreditoUtente FLOAT DEFAULT 0;

	IF (OLD.Stato = "Processazione" AND NEW.Stato <> "Processazione") THEN
		IF NEW.Stato NOT IN ("Preparazione") THEN 
			SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = "L'ordine deve prima passare dallo stato Preparazione";
        END IF;

		SET Costo = CalcoloCostoOrdine(NEW.CodiceOrdine);

		SET CreditoUtente = (
							SELECT A.Credito
                            FROM Account A
                            WHERE A.Username = NEW.Username
						   );

		IF CreditoUtente < Costo THEN
			SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = "Credito residuo non sufficiente";
        END IF;

    	UPDATE Account A
        SET A.Credito = A.Credito - Costo
        WHERE A.Username=NEW.Username;

	    SET NEW.Costo = Costo;
        SET NEW.DataIncasso = CURRENT_DATE;

        IF VerificaDisponibilitaOrdine(NEW.CodiceOrdine) IS FALSE THEN
		    SET NEW.Stato = "Pendente";
		END IF;
    END IF;
END $$

DELIMITER ;
-- -------------------------
--   Fine Operazione 2   --
-- -------------------------

-- -------------------------------------------------------------------------
--   3.	Ricerca rimedi a partire da un codice di errore ed un prodotto   --
-- -------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS RicercaRimedi;
DELIMITER $$
CREATE PROCEDURE RicercaRimedi(_CodiceErrore INT, _IDProdotto INT)
BEGIN
    SELECT R.CodiceRimedio, R.Descrizione
    FROM Soluzione S
        NATURAL JOIN
        Rimedio R
    WHERE S.CodiceErrore = _CodiceErrore
        AND S.IDProdotto = _IDProdotto;
END $$
DELIMITER ;
-- -------------------------
--   Fine Operazione 3   --
-- -------------------------

-- --------------------------------------------------------------------
--   4.	Inserimento di un lotto di prodotti e gestione stoccaggio   --
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS AggiuntaLotto;
DELIMITER $$
CREATE PROCEDURE AggiuntaLotto(  _CodiceSeriale INT,
								 _Quantita INT,
                                 _DataPrevista DATE,
                                 _SedeProduzione VARCHAR(100),
                                 _SequenzaDaUtilizzare INT,
                                 _Magazzino INT)
BEGIN
	DECLARE Verifica INT DEFAULT NULL;
    DECLARE Ricondiz INT DEFAULT NULL;
    DECLARE ubicazioneScelta INT DEFAULT NULL;
    DECLARE codiceLotto INT DEFAULT 0;

	SELECT VDP.Ricondizionato INTO Ricondiz
    FROM VarianteDiProdotto VDP
    WHERE VDP.CodiceSeriale=_CodiceSeriale;
    
    IF Ricondiz IS NULL OR (Ricondiz=1 AND _SequenzaDaUtilizzare IS NOT NULL) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Prodotto Inserito non corretto";
	END IF;
    
    SET Verifica = (
						SELECT COUNT(*)
                        FROM VarianteDiProdotto VDP
							 INNER JOIN
                             SequenzaDiOperazioni SDO USING (IDProdotto)
						WHERE VDP.CodiceSeriale=_CodiceSeriale
							  AND SDO.IDSequenza = _SequenzaDaUtilizzare
					);
	
    IF Ricondiz <> 1 AND Verifica=0  THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Sequenza inserita non valida";
	END IF;
    
    SET Verifica = (
						SELECT COUNT(*)
                        FROM Magazzino M
						WHERE M.CodiceMagazzino=_Magazzino
					);
    
	IF Verifica = 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Il magazzino inserito non è consistente";
	END IF;
    
    SELECT U.IDUbicazione INTO ubicazioneScelta
    FROM Ubicazione U
    WHERE U.CodiceMagazzino=_Magazzino
		  AND NOT EXISTS (
							SELECT 1
                            FROM StoccaggioAttuale SA
                            WHERE SA.IDUbicazione=U.IdUbicazione
						 )
	 LIMIT 1;
	
    IF ubicazioneScelta IS NULL THEN 
		    SELECT U.IDUbicazione INTO ubicazioneScelta
			FROM Ubicazione U
			WHERE NOT EXISTS (
								SELECT 1
								FROM StoccaggioAttuale SA
								WHERE SA.IDUbicazione=U.IdUbicazione
						     )
			LIMIT 1;
	 END IF;
     
     IF ubicazioneScelta IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Nessuna ubicazione disponibile!";
	 END IF;
    
    INSERT INTO Lotto (DataPrevista,DataEffettiva,SedeProduzione,Quantita,Rimanente,CodiceSeriale,IDSequenza)
	VALUES(_DataPrevista, NULL, _SedeProduzione, _Quantita, NULL, _CodiceSeriale, _SequenzaDaUtilizzare);
	
    INSERT INTO StoccaggioAttuale VALUES
		(LAST_INSERT_ID(),ubicazioneScelta,CURRENT_DATE);
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS GestioneStoccaggio;
DELIMITER $$
CREATE TRIGGER GestioneStoccaggio
AFTER UPDATE ON Lotto
FOR EACH ROW
BEGIN
	DECLARE Ubicazione INT DEFAULT 0;
    DECLARE DataInizioStoccaggio DATE;

	IF NEW.Rimanente = 0 AND OLD.Rimanente <> 0 THEN
		SELECT IDUbicazione, DataInizio INTO Ubicazione, DataInizioStoccaggio
        FROM StoccaggioAttuale
        WHERE CodiceLotto = NEW.CodiceLotto;

		DELETE FROM StoccaggioAttuale
        WHERE CodiceLotto = NEW.CodiceLotto;
        
        INSERT INTO StoccaggioStorico
        VALUES (NEW.CodiceLotto, Ubicazione, DataInizioStoccaggio, CURRENT_DATE);
    END IF;
END $$
DELIMITER ;

-- EXTRA: FINE PRODUZIONE LOTTO

DROP PROCEDURE IF EXISTS FineProduzioneLotto;
DELIMITER $$
CREATE PROCEDURE FineProduzioneLotto(CodiceLotto INT)
BEGIN
	DECLARE Verifica DATE;
    
    SELECT L.DataEffettiva INTO Verifica
    FROM Lotto L
    WHERE L.CodiceLotto=CodiceLotto;
    
    IF Verifica IS NOT NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "La produzione del lotto scelto è gia stata teminata";
    END IF;
    
    UPDATE Lotto L
    SET L.DataEffettiva=CURRENT_DATE, L.Rimanente = L.Quantita
    WHERE L.CodiceLotto=CodiceLotto;
    
	UPDATE Ordine
	SET Stato="Preparazione"
	WHERE Stato = "Pendente" AND
		VerificaDisponibilitaOrdine(CodiceOrdine) IS TRUE;
    
END $$
DELIMITER ;
-- -------------------------
--   Fine Operazione 4   --
-- -------------------------

-- ------------------------------------
--   5.	Tracking di una spedizione  --
-- ------------------------------------
DROP PROCEDURE IF EXISTS TrackSpedizione;
DELIMITER $$
CREATE PROCEDURE TrackSpedizione(Tracking INT)
BEGIN

    DECLARE flag INT DEFAULT 0;

    -- Verifica dell'input
    SELECT COUNT(*) INTO flag
    FROM Spedizione S
    WHERE S.tracking = Tracking;

    IF flag = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tracking code inesistente';
    END IF;

    SELECT H.IDHub, H.Citta, P.Data, P.Ora
    FROM Passaggio P
    NATURAL JOIN Hub H
    WHERE P.Tracking = Tracking
    ORDER BY P.Data, P.Ora;

END $$
DELIMITER ;
-- -------------------------
--   Fine Operazione 5   --
-- -------------------------

-- -------------------------------------------------------------------------
--   6.	Calcolo dei periodi di guasto relativi ad una unità acquistata   --
-- -------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS GetGaranzie;
DELIMITER $$
CREATE PROCEDURE GetGaranzie(IDUnita INT)
BEGIN

    DECLARE flag INT DEFAULT 0;
    DECLARE errorString VARCHAR(50) DEFAULT 'Non esiste una unità acquistata con ID: ';
    DECLARE mesiGaranzia INT DEFAULT 24;
    DECLARE DataAcquisto DATE;

    -- Controllo che l'unità esista effettivamente
    SELECT COUNT(*) INTO flag
    FROM UnitaAcquistata UA
    WHERE UA.IDUnita = IDUnita;

    -- Se non esiste chiamo un errore
    IF flag = 0 THEN
        SET errorString = CONCAT(errorString, IDUnita);
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = errorString;
    END IF;

    -- Provvedo a prendere la data di acquisto per calcolare l'inizio della garanzia
    SELECT DataIncasso INTO DataAcquisto
    FROM UnitaAcquistata UA
    NATURAL JOIN Ordine
    WHERE UA.IDUnita = IDUnita;

    IF DataAcquisto IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Questa unità non è stata ancora pagata';
    END IF;

    DROP TEMPORARY TABLE IF EXISTS ScadenzaGaranzie;
    -- Creo una tabella di appoggio per calcolare le varie date
    CREATE TEMPORARY TABLE ScadenzaGaranzie(
        ID              INT     NOT NULL,
        TIPO            TINYINT(1) NOT NULL,   -- 0 per l'unità | 1 per Guasto | 2 per parte
        Descrizione     VARCHAR(100) NOT NULL,
        DataScadenza    DATE     DEFAULT NULL,

        PRIMARY KEY (ID, TIPO)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    -- Calcolo il totale dei mesi di garanzia per tutta l'unità
    SELECT IFNULL(SUM(Periodo), 0) + mesiGaranzia INTO mesiGaranzia
    FROM Estensione E
    NATURAL JOIN FormulaGaranzia FG
    WHERE FG.TIPO = 0
        AND E.IDUnita = IDUnita;

    -- Inserisco il totale dei mesi di garanzia per tutta l'unità
    INSERT INTO ScadenzaGaranzie
    VALUES (IDUnita, 0, 'Unità', DataAcquisto + INTERVAL mesiGaranzia MONTH);

    -- Calcolo il totale dei mesi di garanzia per ogni guasto ed inserisco la data di fine
    INSERT INTO ScadenzaGaranzie
    SELECT G.CodiceGuasto, 1, G.Nome, DataAcquisto + INTERVAL IFNULL(SUM(Periodo),0) MONTH
    FROM Estensione E
    NATURAL JOIN FormulaGaranzia FG
    NATURAL JOIN Specifica
    NATURAL JOIN Guasto G
    WHERE FG.TIPO = 1
        AND E.IDUnita = IDUnita
    GROUP BY G.CodiceGuasto;

    -- Aggiungo la garanzia di un anno sulle eventuali parti cambiate
    INSERT INTO ScadenzaGaranzie
    SELECT CodiceParte, 2, P.Nome, MAX(DataEffettiva) + INTERVAL 1 YEAR
    FROM AssistenzaFisica AF
		 INNER JOIN 
         OrdineParti OP USING(CodiceAssistenza)
         INNER JOIN
         Ricambio R USING(CodiceOrdineParti)
         INNER JOIN
         Parte P USING(CodiceParte)
    WHERE AF.IDUnita = IDUnita
          AND OP.DataEffettiva IS NOT NULL
    GROUP BY P.CodiceParte;

    -- Stampo il risultato
    SELECT *
    FROM ScadenzaGaranzie
    ORDER BY TIPO;

END $$
DELIMITER ;
-- -------------------------
--   Fine Operazione 6   --
-- -------------------------

-- -----------------------------------------------------
--   7.	Gestione del termine dell’assistenza fisica   --
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS AggiuntaDataArrivoOrdine;
DELIMITER $$
CREATE PROCEDURE AggiuntaDataArrivoOrdine(_CodiceOrdineParti INT)
BEGIN

    DECLARE flag INT DEFAULT 0;
    DECLARE errorMessage VARCHAR(100) DEFAULT 'Non esiste ordine parti con ID: ';
    DECLARE oldData DATE DEFAULT NULL;

    SELECT COUNT(*) INTO flag
    FROM OrdineParti
    WHERE CodiceOrdineParti = _CodiceOrdineParti;

    IF flag = 0 THEN
        SET errorMessage = CONCAT(errorMessage, _CodiceOrdineParti);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = errorMessage;
    END IF;

    SELECT DataEffettiva INTO oldData
    FROM OrdineParti
    WHERE CodiceOrdineParti = _CodiceOrdineParti;

    IF oldData IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Questo ordine parti ha già una data di arrivo';
    END IF;

    UPDATE OrdineParti
    SET DataEffettiva = CURRENT_DATE
    WHERE CodiceOrdineParti = _CodiceOrdineParti;

END $$
DELIMITER ;

/*
 * Creo la materialized view di appoggio per mantenere un reminder delle assistenze da sbloccare
 */
DROP TABLE IF EXISTS MemoProssimiInterventi;
CREATE TABLE MemoProssimiInterventi(
    CodiceAssistenza INT NOT NULL,

    PRIMARY KEY (CodiceAssistenza),
    FOREIGN KEY (CodiceAssistenza) REFERENCES AssistenzaFisica(CodiceAssistenza)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
 * Quando c'è un update nell'ordine delle parti inserisco una tupla nella MV reminder
 */
DROP TRIGGER IF EXISTS InsertMemo;
DELIMITER $$
CREATE TRIGGER InsertMemo
AFTER UPDATE ON OrdineParti
FOR EACH ROW
BEGIN

    IF OLD.DataEffettiva IS NULL AND NEW.DataEffettiva IS NOT NULL THEN
        INSERT INTO MemoProssimiInterventi
        VALUES (NEW.CodiceAssistenza);
    END IF;

END $$
DELIMITER ;

/*
 * Quando inserisco un nuovo intervento provo a cancellare dalla MV reminder l'eventuale tupla
 */
DROP TRIGGER IF EXISTS DeleteMemo;
DELIMITER $$
CREATE TRIGGER DeleteMemo
AFTER INSERT ON Intervento
FOR EACH ROW
BEGIN
    DELETE
    FROM MemoProssimiInterventi
    WHERE CodiceAssistenza = NEW.CodiceAssistenza;
END $$
DELIMITER ;

/*
 * Una volta finita la filiera di assistenza creo la RicevutaFiscale
 */
DROP PROCEDURE IF EXISTS ChiudiAssistenzaFisica;
DELIMITER $$
CREATE PROCEDURE ChiudiAssistenzaFisica(CodiceAssistenza INT, MetodoDiPagamento VARCHAR(100), inGaranzia BOOLEAN)
BEGIN

    DECLARE flag INT DEFAULT 0;
    DECLARE errorMessage VARCHAR(100) DEFAULT 'Non esiste nessuna assistenza fisica con codice: ';
    DECLARE duplicateErrorMessage VARCHAR(100) DEFAULT 'Esiste già una ricevuta per l\'assistenza: ';
    DECLARE costo INT DEFAULT 0;

    SELECT COUNT(*) INTO flag
    FROM AssistenzaFisica AF
    WHERE AF.CodiceAssistenza = CodiceAssistenza;

    IF flag = 0 THEN
        SET errorMessage = CONCAT(errorMessage, CodiceAssistenza);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = errorMessage;
    END IF;

    SET flag = 0;

    SELECT COUNT(*) INTO flag
    FROM RicevutaFiscale RF
    WHERE RF.CodiceAssistenza = CodiceAssistenza;

    IF flag <> 0 THEN
        SET duplicateErrorMessage = CONCAT(duplicateErrorMessage, CodiceAssistenza);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = duplicateErrorMessage;
    END IF;

    IF inGaranzia = TRUE THEN
        INSERT INTO RicevutaFiscale
        VALUES (DEFAULT, MetodoDiPagamento, 0, CodiceAssistenza);
    ELSE
        SELECT IFNULL(SUM(OreLavoro * CostoOrario), 0) INTO costo
        FROM Intervento I
        NATURAL JOIN Tecnico
        WHERE I.CodiceAssistenza = CodiceAssistenza;

        SELECT IFNULL(SUM(Prezzo), 0) + costo INTO costo
        FROM OrdineParti OP
        NATURAL JOIN Ricambio
        NATURAL JOIN Parte
        WHERE OP.CodiceAssistenza = CodiceAssistenza;

        INSERT INTO RicevutaFiscale
        VALUES (DEFAULT, MetodoDiPagamento, costo, CodiceAssistenza);
    END IF;

END $$
DELIMITER ;

/*
 * Mostro le assistenze fisiche per le quali è necessario programmare un intervento finale
 */
DROP PROCEDURE IF EXISTS GetMemoAssistenzeFisiche;
DELIMITER $$
CREATE PROCEDURE GetMemoAssistenzeFisiche()
BEGIN
    SELECT *
    FROM MemoProssimiInterventi;
END $$
DELIMITER ;
-- -------------------------
--   Fine Operazione 7   --
-- -------------------------

-- -----------------------------------------------------------------
--   8.	Visualizzazione del giudizio complessivo di un prodotto  --
-- -----------------------------------------------------------------
DROP TABLE IF EXISTS GiudiziMV;
CREATE TABLE GiudiziMV(
    CodiceSeriale   INT,
    IDGiudizio      INT,
    SommaVoti       INT DEFAULT 0,
    CountVoti       INT DEFAULT 0,

    FOREIGN KEY (CodiceSeriale) REFERENCES VarianteDiProdotto(CodiceSeriale),
    FOREIGN KEY (IDGiudizio)    REFERENCES Giudizio(IDGiudizio)
);

-- All'aggiunta di una variante, si aggiungono tanti record alla materialized view quanti sono i giudizi nel database
DROP TRIGGER IF EXISTS AggiungiVarianteAllaMaterializedView;
DELIMITER $$
CREATE TRIGGER AggiungiVarianteAllaMaterializedView
AFTER INSERT ON VarianteDiProdotto
FOR EACH ROW
BEGIN
    INSERT INTO GiudiziMV(CodiceSeriale, IDGiudizio)
        SELECT NEW.CodiceSeriale, IDGiudizio
        FROM giudizio;
END $$
DELIMITER ;

-- All'aggiunta di un giudizio, si aggiungono tanti record alla materialized view quanti sono le varianti di prodotto nel database
DROP TRIGGER IF EXISTS AggiungiGiudizioAllaMaterializedView;
DELIMITER $$
CREATE TRIGGER AggiungiGiudizioAllaMaterializedView
AFTER INSERT ON Giudizio
FOR EACH ROW
BEGIN
    INSERT INTO GiudiziMV(CodiceSeriale, IDGiudizio)
        SELECT CodiceSeriale, NEW.IDGiudizio
        FROM VarianteDiProdotto;
END $$
DELIMITER ;

-- Immediate refresh per MVGiudizio
DROP TRIGGER IF EXISTS AggiornaRecensioneNellaMaterializedView;
DELIMITER $$
CREATE TRIGGER AggiornaRecensioneNellaMaterializedView
AFTER INSERT ON Caratterizzata
FOR EACH ROW
BEGIN
    UPDATE GiudiziMV GMV
    SET CountVoti = CountVoti + 1,
        SommaVoti = SommaVoti + NEW.Voto
    WHERE GMV.IDGiudizio = NEW.IDGiudizio
        AND GMV.CodiceSeriale = (
            SELECT CodiceSeriale
            FROM Recensione
            NATURAL JOIN UnitaAcquistata
            WHERE CodiceRecensione = NEW.CodiceRecensione
        );
END $$
DELIMITER ;

-- Procedura per visualizzare la MV
DROP PROCEDURE IF EXISTS MostraGiudizi;
DELIMITER $$
CREATE PROCEDURE MostraGiudizi(CodiceSeriale INT)
BEGIN
    SELECT GMV.CodiceSeriale, GMV.IDGiudizio, G.Descrizione, GMV.SommaVoti/GMV.CountVoti AS MediaVoti
    FROM GiudiziMV GMV
         NATURAL JOIN
         Giudizio G
    WHERE GMV.CountVoti <> 0;
END $$
DELIMITER ;
-- ------------------------
--   Fine Operazione 8   --
-- ------------------------


-- -----------------------------
--   Funzionalità Richieste   --
-- -----------------------------

-- -----------------------------------------------------------------------------------------------------------
--   Ricavare le quantità di prodotti resi per ciascuna variante di prodotto, associati alle motivazioni   --
-- -----------------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS ResiPerVariante;
DELIMITER $$
CREATE PROCEDURE ResiPerVariante()
BEGIN
    /* Si prendono tutte le unità rese e si ricollegano alla rispettiva variante di prodotto.
     * Per mezzo di un raggruppamento, possiamo avere quante volte una certa variante di prodottto
     * è stata restituita a causa di una certa motivazione.
     */
    SELECT UA.CodiceSeriale, M.CodiceMotivazione, M.Nome, COUNT(*) AS Quantita
    FROM Reso R
    NATURAL JOIN RichiestaReso RR
    NATURAL JOIN Motivazione M
    NATURAL JOIN UnitaAcquistata UA
    GROUP BY UA.CodiceSeriale, M.CodiceMotivazione;
END $$
DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------
--   Controllo del numero di resi per segnalare la possibilità di iniziare una nuova procedura di ricondizionamento  --
-- ---------------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS CheckResi;
DELIMITER $$
CREATE FUNCTION CheckResi(CodiceSeriale INT)
RETURNS BOOLEAN NOT DETERMINISTIC
BEGIN

    DECLARE sdr INT;
    DECLARE amount INT DEFAULT 0;
    DECLARE flag INT DEFAULT 0;

    /*
     * Si effettua una preliminare verifica di consistenza del dato inserito (Se la variante di prodotto esiste nel DB)
     */

    SELECT COUNT(*) INTO flag
    FROM VarianteDiProdotto V
    WHERE V.CodiceSeriale = CodiceSeriale;

    IF flag = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non esiste questa variante di prodotto';
    END IF;

    /*
     * Si prende il valore di sdr (soglia di ricondizionamento) associato al prodotto
     * al quale si rifanno le singole varianti di prodotto
     */

    SELECT P.sdr INTO sdr
    FROM VarianteDiProdotto V
    NATURAL JOIN Prodotto P
    WHERE V.CodiceSeriale = CodiceSeriale;

    SELECT COUNT(*) INTO amount
    FROM Reso R
    NATURAL JOIN RichiestaReso RR
    NATURAL JOIN UnitaAcquistata UA
    WHERE UA.CodiceSeriale = CodiceSeriale
        AND R.Ricondizionato = FALSE;

    RETURN IF(amount >= sdr, TRUE, FALSE);
END $$
DELIMITER ;

/*
 * Questa procedure, usando la function precedentemente definita, ci permette di sapere quali varianti di prodotto
 * possono andare incontro ad un processo di ricondizionamento 
 */
DROP PROCEDURE IF EXISTS VerificaRicondizionamento;
DELIMITER $$
CREATE PROCEDURE VerificaRicondizionamento()
BEGIN

    SELECT V.CodiceSeriale, CheckResi(V.CodiceSeriale) AS Sufficienza
    FROM VarianteDiProdotto V;

END $$
DELIMITER ;

-- ------------------------------------------------------------
--   Mostrare le fasce orarie disponibili per una giornata  --
-- ------------------------------------------------------------
/*
 * In questa operazione abbiamo ricalcato quanto esposto nella documentazione del progetto in merito alla descrizione della fascia oraria
 * per gli interventi nell'assistenza fisica. Usando una TT, ci salviamo tutte le possibili fascie orarie (4) e, per ciascun giorno,
 * contiamo sia quanti sono i tecnici nel complesso, sia quanti interventi vi sono già prenotati per quella fascia oraria. Detti NT e 
 * P rispettivamente, una fascia oraria in un certo giorno è disponibile se e solo se NT>P
 */
DROP PROCEDURE IF EXISTS DisponibilitaFasceOrarie;
DELIMITER $$
CREATE PROCEDURE DisponibilitaFasceOrarie(GiornoTarget DATE)
BEGIN

    DECLARE numeroTecnici INT DEFAULT 0;

    IF GiornoTarget < CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data inserita non corretta';
    END IF;

	DROP TEMPORARY TABLE IF EXISTS FasceOrarie;
    CREATE TEMPORARY TABLE FasceOrarie(
        ID INT NOT NULL,
        Nome VARCHAR(13) NOT NULL,
        PRIMARY KEY(ID)
    );

    INSERT INTO FasceOrarie
        VALUES  (1, 'Mattina 1'),
                (2, 'Mattina 2'),
                (3, 'Pomeriggio 1'),
                (4, 'Pomeriggio 2');

    SELECT COUNT(*) INTO numeroTecnici
    FROM Tecnico;

    SELECT F.Nome
    FROM FasceOrarie F
        LEFT OUTER JOIN (
            SELECT *
            FROM Intervento I
            WHERE I.Data = GiornoTarget
        ) AS I ON I.FasciaOraria = F.ID
    GROUP BY F.ID
    HAVING SUM(IF(I.FasciaOraria IS NULL, 0, 1)) < numeroTecnici; -- Gestione dell'eventuale record vuoto dovuto al join esterno

END $$
DELIMITER ;



-- ---------------------------------------------------
--   FUNZIONALITA' DI REPORT PER ANALISI VENDITE   --
-- ---------------------------------------------------
-- REPORT SETTIMANALE SU ORDINI PENDENTI CON INCREMENTAL REFRESH

/*
 * Poiché si richiede che settimanalmente si possa accedere agli ordini pendenti, con tale MV si permette questa funzionalità.
 * L'incremental refresh adottato non solo permette un allggerimento del carico applicativo, ma rispecchia anche la traccia:
 * non ci interessa sapere istantaneamente gli ordini pendenti, basta che siano aggiornati ogni settimana. Abbiamo allora, oltre
 * che alla definzione di una MV e di una tabella di LOG, un trigger di push che si attiva quando un ordine passa allo stato 'Pendente'.
 * Il refresh si realizza all'interno dell'event, ed è di tipo complete.
 */
DROP TABLE IF EXISTS ReportPendenti;
CREATE TABLE ReportPendenti(
	CodiceSeriale INT NOT NULL,
    Quantita INT NOT NULL,

    PRIMARY KEY (CodiceSeriale),

    FOREIGN KEY (CodiceSeriale) REFERENCES VarianteDiProdotto(CodiceSeriale)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS LogPendenti;
CREATE TABLE LogPendenti(
	ID INT AUTO_INCREMENT,
	CodiceSeriale INT NOT NULL,

	PRIMARY KEY (ID),

    FOREIGN KEY (CodiceSeriale) REFERENCES VarianteDiProdotto(CodiceSeriale)
) ENGINE = InnoDB DEFAULT CHARSET=latin1;

DROP TRIGGER IF EXISTS PushPendenti;
DELIMITER $$
CREATE TRIGGER PushPendenti
AFTER UPDATE ON Ordine
FOR EACH ROW
BEGIN
	IF OLD.Stato="Processazione" AND NEW.Stato="Pendente" THEN
		INSERT INTO LogPendenti(CodiceSeriale)
			SELECT UA.CodiceSeriale
			FROM UnitaAcquistata UA
            WHERE UA.CodiceOrdine=NEW.CodiceOrdine;
    END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS OnDemandRefreshReportPendenti;

DELIMITER $$
CREATE PROCEDURE OnDemandRefreshReportPendenti()
BEGIN
	TRUNCATE ReportPendenti;

    INSERT INTO ReportPendenti
        WITH AggregatedLog AS(
            SELECT LP.CodiceSeriale, COUNT(*) AS Quantita
            FROM LogPendenti LP
            GROUP BY LP.CodiceSeriale
        ), Var AS(
            SELECT VDP.CodiceSeriale, 0 AS Quantita
            FROM VarianteDiProdotto VDP
        )
        SELECT D.CodiceSeriale, SUM(D.Quantita)
        FROM (
                SELECT *
                FROM AggregatedLog
                
                UNION ALL
                
                SELECT *
                FROM Var
            ) AS D
        GROUP BY D.CodiceSeriale;
	
    TRUNCATE LogPendenti;
END $$
DELIMITER ;

DROP EVENT IF EXISTS RefreshReportPendenti;
DELIMITER $$
CREATE EVENT RefreshReportPendenti
ON SCHEDULE EVERY 1 WEEK
STARTS '2020-06-15 00:00:00'
DO
BEGIN
    CALL OnDemandRefreshReportPendenti();
END $$
DELIMITER ;

-- PRODOTTI PIU VENDUTI NELL'ULTIMA SETTIMANA
DROP PROCEDURE IF EXISTS ReportMiglioriVendite;
DELIMITER $$
CREATE PROCEDURE ReportMiglioriVendite()
BEGIN
	SELECT UA.CodiceSeriale, COUNT(*) AS QuantiVenduti
    FROM Ordine O
	NATURAL JOIN
        UnitaAcquistata UA
	WHERE 	O.DataIncasso IS NOT NULL AND
			O.DataIncasso BETWEEN CURRENT_DATE - INTERVAL 1 WEEK AND CURRENT_DATE
    GROUP BY UA.CodiceSeriale
    ORDER BY QuantiVenduti DESC;
END $$
DELIMITER ;


-- --------------------------------------------
--     Generazione di sequenze valide        --
-- --------------------------------------------
DROP PROCEDURE IF EXISTS GenerazioneSequenzaValida;
DELIMITER $$
CREATE PROCEDURE GenerazioneSequenzaValida(IDProdotto INT)
BEGIN
	DECLARE flag INT DEFAULT 0;
    
    SELECT COUNT(*)INTO flag
    FROM Prodotto P
    WHERE P.IDProdotto=IDProdotto;
    
    IF flag=0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Prodotto inserito non valido";
    END IF;
    
    SELECT O.*
    FROM Operazione O
		 NATURAL JOIN
         Faccia F
	WHERE F.IDProdotto=IDProdotto
    ORDER BY O.Priorita;
         
END $$
DELIMITER ;

-- ---------------------------------------------------------------
--    Algoritmo di assegnamento degli interventi ai tecnici    --
-- ---------------------------------------------------------------
DROP FUNCTION IF EXISTS distance;
DELIMITER $$
CREATE FUNCTION distance(x1 FLOAT, y1 FLOAT, x2 FLOAT, y2 FLOAT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    RETURN SQRT(POW(x1-x2, 2) + POW(y1-y2, 2));
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS AssegnaInterventi;
DELIMITER $$
CREATE PROCEDURE AssegnaInterventi(IN giorno DATE)
BEGIN

    DECLARE interventoCorrente INT;
    DECLARE fasciaOrariaCorrente INT;
    DECLARE latitudineCorrente FLOAT;
    DECLARE longitudineCorrente FLOAT;
    DECLARE scelto INT;
    DECLARE nuovoTotalePercorso FLOAT;

    DECLARE cursorStop BOOLEAN DEFAULT FALSE;
    
    -- Prendo un cursore per gli interventi del giorno scelto che vanno eseguiti in presenza
    DECLARE cursoreIntervento CURSOR FOR
        SELECT Ticket, FasciaOraria, Latitudine, Longitudine
        FROM Intervento
        WHERE `DATA` = giorno
            AND TIPO = 1
        ORDER BY FasciaOraria;

    DECLARE CONTINUE HANDLER
    FOR NOT FOUND
        SET cursorStop = TRUE;

    -- Creo una tabella temporanea per mantenere i dati dei tecnici
    DROP TEMPORARY TABLE IF EXISTS interventiTemp;
    CREATE TEMPORARY TABLE interventiTemp(
        Badge               INT NOT NULL,
        ultimaFasciaOraria  INT NOT NULL DEFAULT 0,
        totPercorso         FLOAT NOT NULL DEFAULT 0,
        ultimaLatitudine    FLOAT NOT NULL DEFAULT 0,
        ultimaLongitudine   FLOAT NOT NULL DEFAULT 0,

        PRIMARY KEY (Badge)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    INSERT INTO interventiTemp(Badge)
        SELECT Badge
        FROM Tecnico;

    OPEN cursoreIntervento;
    main: LOOP
        -- Prendo le informazioni del prossimo intervento da assegnare
        FETCH cursoreIntervento INTO  interventoCorrente,
                            fasciaOrariaCorrente,
                            latitudineCorrente,
                            longitudineCorrente;

        -- Controllo che il cursore non sia arrivato alla fine
        IF cursorStop = 1 THEN
            LEAVE main;
        END IF;

        -- Cerco il tecnico che farebbe minore strada aggiungendogli questo intervento
        SELECT  Badge,
                totPercorso + distance(ultimaLatitudine, ultimaLongitudine,
                              latitudineCorrente, longitudineCorrente) as distance
                INTO scelto, nuovoTotalePercorso
        FROM interventiTemp
        WHERE ultimaFasciaOraria < fasciaOrariaCorrente
        ORDER BY distance
        LIMIT 1;
        
        -- Assegno l'intervento al tecnico
        UPDATE Intervento
        SET Badge = scelto
        WHERE Ticket = interventoCorrente;


        -- Aggiorno le meta-informazioni del tecnico
        UPDATE interventiTemp
        SET ultimaFasciaOraria = fasciaOrariaCorrente,
            totPercorso = nuovoTotalePercorso,
            ultimaLatitudine = latitudineCorrente,
            ultimaLongitudine = longitudineCorrente
        WHERE Badge = scelto;

    END LOOP main;
    CLOSE cursoreIntervento;

END $$
DELIMITER ;

DROP EVENT IF EXISTS AssegnaInterventiEvent;
DELIMITER $$
CREATE EVENT AssegnaInterventiEvent
ON SCHEDULE EVERY 1 WEEK
-- Ogni domenica a partire dalla prossima domenica
STARTS CURRENT_DATE + INTERVAL 6 - WEEKDAY(CURRENT_DATE) DAY
DO
BEGIN
    DECLARE i INT DEFAULT 1;

    -- Chiamo la procedura di assegnamento per i prossimi 5 giorni
    WHILE i < 6 DO
        CALL AssegnaInterventi(CURRENT_DATE + INTERVAL i DAY);
        SET i = i+1;
    END WHILE;

END $$
DELIMITER ;

-- ---------------------------------------------------
--    Implementazione di alcuni vincoli generici   --
-- ---------------------------------------------------
-- Verifica della consistenza del tipo di garanzia (non si possono creare delle garanzie di tipo temporale che si collegano anche a dei guasti)
DROP TRIGGER IF EXISTS CheckSpecifica;
DELIMITER $$
CREATE TRIGGER CheckSpecifica
BEFORE INSERT ON Specifica
FOR EACH ROW
BEGIN
    DECLARE tipo INT DEFAULT 0;

    SELECT FG.TIPO INTO tipo
    FROM FormulaGaranzia FG
    WHERE FG.CodiceGaranzia = NEW.CodiceGaranzia;

    IF tipo = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Questa garanzia non si applica a dei guasti!';
    END IF;

END $$
DELIMITER ;

-- Se ordine ha indirizzo NULL bisogna settare come indirizzo quello dell'utente
DROP TRIGGER IF EXISTS CheckIndirizzo;
DELIMITER $$
CREATE TRIGGER CheckIndirizzo
BEFORE INSERT ON ordine
FOR EACH ROW
BEGIN
    DECLARE userAddress VARCHAR(100);

    IF NEW.Indirizzo IS NULL THEN
        SELECT U.Indirizzo INTO userAddress
        FROM Utente U
        NATURAL JOIN Account A
        WHERE A.Username = NEW.Username;

        SET NEW.Indirizzo = userAddress;
    END IF;
END $$
DELIMITER ;

-- Un ordine parti può essere aggiunto solo se l'assistenza fisica ha il preventivo accettato
DROP TRIGGER IF EXISTS CheckOrdineParti;
DELIMITER $$
CREATE TRIGGER CheckOrdineParti
BEFORE INSERT ON OrdineParti
FOR EACH ROW
BEGIN
    DECLARE flag INT DEFAULT 0;

    SELECT Accettato INTO flag
    FROM AssistenzaFisica
    WHERE CodiceAssistenza = NEW.CodiceAssistenza;

    IF flag = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La corrispondente assistenza fisica non ha il preventivo accettato';
    END IF;

END $$
DELIMITER ;

-- Per ogni sequenza di operazioni, la precedenza di una stazione deve essere unica
DROP TRIGGER IF EXISTS checkPrecedenzaStazioni;
DELIMITER $$
CREATE TRIGGER checkPrecedenzaStazioni
BEFORE INSERT ON Stazione
FOR EACH ROW
BEGIN
    DECLARE conteggio INT DEFAULT 0;
    DECLARE errorMessage VARCHAR(100) DEFAULT 'Precedenza duplicata per la sequenza: ';

    SELECT COUNT(*) INTO conteggio
    FROM Stazione
    WHERE IDSequenza = NEW.IDSequenza
        AND Precedenza = NEW.Precedenza;

    IF conteggio <> 0 THEN
        SET errorMessage = CONCAT(errorMessage, NEW.IDSequenza);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = errorMessage;
    END IF;

END $$
DELIMITER ;


