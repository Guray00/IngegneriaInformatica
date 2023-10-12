# Analitycs Function - Apriori
# Sarà un event che elaborerà ogni giorno, trovando le combinazioni di RANGE di TEMPERATURA delle luci che sono impostate dalla famiglia stessa nello stesso intervallo 
# di tempo la temperatura identifica il colore di questa, e quindi  riusciamo a trovare il colore o i colori preferiti dalla famiglia, 
# impostando uno sfondo nell'appliazione della smart home, che segue i gusti della famiglia.
USE smarthome;
DROP PROCEDURE IF EXISTS RelazioniColoreLuci;
DELIMITER $$
CREATE PROCEDURE RelazioniColoreLuci()
BEGIN
    -- variabili per contenere attributi di result-set
    DECLARE IstanteInizio_ TIMESTAMP;
    DECLARE IstanteFine_ TIMESTAMP;
    DECLARE ID_Stanza_ INT;
    DECLARE ColoreEsadecimale_ CHAR(6);
    DECLARE Colore_ VARCHAR(6) DEFAULT '';
    DECLARE Luce_ INT;
    -- per l'handler
    DECLARE finito INT DEFAULT 0;			
    -- variabili ausiliari
	DECLARE NumeroOre_ INT DEFAULT 0;
    DECLARE Indice_	INT DEFAULT 0;
    DECLARE Ausiliare_ INT DEFAULT 0;
    DECLARE IstanteInizioAux_ VARCHAR(20) DEFAULT '';
    -- variabili per l'algoritmo apriori
    DECLARE Support_ DOUBLE DEFAULT 0.2;
    DECLARE Confidence_ DOUBLE DEFAULT 0.2;
    DECLARE NumeroColori_ INT DEFAULT 0;
    DECLARE NumeroItemSetRimasti_ INT DEFAULT 0;
    
    DECLARE CursoreQuery CURSOR FOR
	-- Tabella che contiene i colori che vengono accesi, l'ora in cui vengono accesi e la stanza in cui sono le rispettive luci
	-- Infatti la corrispondenza verrà fatta per un intervallo limitato (un' ora di tempo) e rispetto ad una stanza.
	-- Se un colore sta acceso per 2 ore, dovrà comparire in due righe, e non in una.
	SELECT RI.IstanteInizio, RI.IstanteFine, L.ID_Stanza, RT.ID_Colore, RI.ID_Luce
	FROM RegistroIlluminazione RI
		 INNER JOIN
		 RangeTemperatura RT ON RI.Temperatura >= RT.TemperaturaMinima
								AND (RI.Temperatura < RT.TemperaturaMassima OR RT.TemperaturaMassima IS NULL)
		INNER JOIN
		Luce L ON RI.ID_Luce = L.ID_Luce
	-- Non consideriamo i colori accesi per meno di 6 secondi, le consideriamo accensioni fatte per sbaglio
	WHERE TIMESTAMPDIFF(SECOND, RI.IstanteInizio, RI.IstanteFine) > 5
		  -- consideriamo solo i dati di massimo 5 giorni fa, per avere un risultato visibile in modo più immediato
		  AND DATE(RI.IstanteInizio) >= CURRENT_DATE - INTERVAL 5 DAY AND
			  DATE(RI.IstanteInizio) < CURRENT_DATE;
	
    -- dichiarazione handler
    DECLARE CONTINUE HANDLER
	FOR NOT FOUND SET finito = 1;
    
    OPEN CursoreQuery;
    
    -- creazione di una temporary table che useremo a contenere la lista delle temperature suddivise anche per orario
    -- ogni luce che sta accesa più di un'ora adesso dovrà risultare su più righe, invece che in una solamente.
    DROP TABLE IF EXISTS ListaLuciAccese;
    CREATE TABLE IF NOT EXISTS ListaLuciAccese (
		ID_Lista INT AUTO_INCREMENT,
		OraTarget VARCHAR(20) NOT NULL,
        Stanza	INT NOT NULL,
        Luce INT NOT NULL,
        Colore VARCHAR(6) NOT NULL,
        PRIMARY KEY (ID_Lista)
    );
    
    -- effettua la preparate per una query che verrà usata più volte, con solo diversi dati in input
    SET @CodiceSQL_ = 'INSERT INTO ListaLuciAccese (OraTarget, Stanza, Colore, Luce)
					   VALUES (?, ?, ?, ?)';
    PREPARE IntoListaLuciAccese
    FROM @CodiceSQL_;
    
    -- ciclo l'inserimento nella tabella ListaLuciAccese di tutti i colori
    elabora: LOOP
		-- inserimento della rispettiva i-esima riga del risultato all'interno delle variabili
		FETCH CursoreQuery INTO IstanteInizio_, IstanteFine_, ID_Stanza_, Colore_, Luce_;
        IF finito = 1 THEN 
			LEAVE elabora;
		END IF;
        
        SET Indice_ = 0;
        SET NumeroOre_ = TIMESTAMPDIFF(HOUR, IstanteInizio_, IstanteFine_);
		-- Andiamo ad inserire il numero adeguato di righe all'interno di "ListaLuciAccese"
        WHILE Indice_ <= NumeroOre_ DO -- inserimento per NumeroOre_ volte all'interno della tabella
			SET IstanteInizioAux_ = DATE_FORMAT(IstanteInizio_ + INTERVAL Indice_ HOUR, "%Y-%m-%d %H");
            SET Indice_ = Indice_ + 1;
            
            -- numero di volte in cui la stessa luce ha assunto lo stesso colore dentro l'intervallo di un'ora
            -- se due luci diverse assumono lo stesso colore nello stesso intervallo di un'ora invece le righe da scrivere sono due
			SELECT COUNT(*) INTO Ausiliare_
            FROM ListaLuciAccese LA
            WHERE LA.OraTarget = IstanteInizioAux_ AND LA.Colore = Colore_;
			
            -- controllo della variabile impostata sopra, se è 0 allora inserisci
            IF Ausiliare_ = 0 THEN
                -- assegnazioni delle variabili all'interno di user variable
                SET @OraTarget =  IstanteInizioAux_;
                SET @Stanza = ID_Stanza_;
                SET @Colore = Colore_;
                SET @Luce = Luce_;
                -- execute dello statement preparato fuori dal LOOP
                -- lo usiamo per efficenza
				EXECUTE IntoListaLuciAccese
                USING @OraTarget, @Stanza, @Colore, @Luce;
            END IF;
        END WHILE;
    END LOOP;
    
    -- CREAZIONE DELLA TABELLA PIVOT
    -- Ottenimento della tabella pivot, su cui abbiamo bisogno di operare
    -- Prima creiamo la tabella, ovviamente le colonne non sono statiche, ma dinamiche
    SELECT GROUP_CONCAT(CONCAT(ID_Colore)) INTO @ListaColori # lista dei colori in questo modo: [e80e25, e8960e, ...]
	FROM RangeTemperatura;
	
    -- manipoliamo la stringa così da creare una query di creazione tabella
    SET @CreazioneTabellaPivot = REPLACE(@ListaColori, ',', ' INT NOT NULL, ');
	SET @CreazioneTabellaPivot = CONCAT(@CreazioneTabellaPivot, ' INT NOT NULL,');
    
    DROP TABLE IF EXISTS ColoriPivot;
    SET @CreazioneTabellaPivot = CONCAT(
										 'CREATE TABLE ColoriPivot (
											OraTarget VARCHAR(30) NOT NULL,
                                            Stanza INT NOT NULL, ',
											@CreazioneTabellaPivot,
										   'PRIMARY KEY(OraTarget, Stanza)
										  );'
									   );
    
    PREPARE CreazioneTabellaPivot
	FROM @CreazioneTabellaPivot;
    EXECUTE CreazioneTabellaPivot;
	
    SET GLOBAL group_concat_max_len = 2000;
    -- creazione stringa del tipo: [COUNT(IF(Colore = 'c1', 1, NULL)) AS 'c1', ...]
    -- serve per ottenere tutti i numeri all'interno della matrice.
    SELECT GROUP_CONCAT(CONCAT('COUNT(IF(Colore = ''', ID_Colore, ''', 1, NULL)) AS ''', ID_Colore, '''')) INTO @InsertIntoPivot
	FROM RangeTemperatura;
    
    -- manipolazione della query per riuscire ad inserire la tabella che otteniamo nella tabella create sopra 
    SET @InsertIntoPivot = CONCAT(
								' INSERT INTO ColoriPivot 
								  SELECT OraTarget, Stanza, ',
								  @InsertIntoPivot,
								' FROM ListaLuciAccese 
								  GROUP BY OraTarget, Stanza;'
					         );
	
    -- adesso possiamo manipolare finalmente la tabella!
    PREPARE InserimentoTabellaPivot
	FROM @InsertIntoPivot;
    EXECUTE InserimentoTabellaPivot;
    
    -- |-----------------------------------------------------------------------------------------------------------------------------|
    -- |------------------------------------ CREAZIONE E MANIPOLAZIONE DEL PRIMO ITEM-SET -------------------------------------------|
    -- |-----------------------------------------------------------------------------------------------------------------------------|
    
    -- CREAZIONE DELLA TABELLA DEGLI ELEMENTI CANDIDATI
    -- CREAZIONE DELLA TABELLA CONTENENTE TUTTI I COLORI, LE LORO OCCORRENZE SINGOLE E QUELLE TOTALI
    DROP TEMPORARY TABLE IF EXISTS CandidateTable1;
    CREATE TEMPORARY TABLE CandidateTable1 (
		Colore VARCHAR(3) NOT NULL PRIMARY KEY,
        Occorrenze INT NOT NULL,
        Totale INT NOT NULL
    );
    
    -- inseriamo i dati all'interno della tabella
    SET @QuerySQL = 'INSERT INTO CandidateTable1
						    SELECT Colore, Occorrenze, Totale 
                            FROM ( ';
		
	-- numero di colori
    SELECT COUNT(*) INTO NumeroColori_
    FROM RangeTemperatura;
    
    -- Per ogni colore abbiamo il suo id, il numero di volte in cui appare nelle transazioni e il numero di transazioni totali
    SET @i = 1;
    WHILE @i <= NumeroColori_ DO
		 SET @QuerySQL = CONCAT(@QuerySQL, ' SELECT ''c', @i,''' AS Colore, IF(SUM(IF(c',@i,' = 1, 1, 0)) IS NULL, 0,  SUM(IF(c',@i,' = 1, 1, 0))) AS Occorrenze, 
																COUNT(*) AS Totale
											 FROM ColoriPivot ');
		 IF @i <> NumeroColori_ THEN
			SET @QuerySQL = CONCAT(@QuerySQL, ' UNION ALL ');
         END IF;
         SET @i = @i + 1;
    END WHILE;
    SET @QuerySQL = CONCAT(@QuerySQL, ' ) AS D; ');
    
    PREPARE CandidateTable1
	FROM @QuerySQL;
    EXECUTE CandidateTable1;
	
	-- adesso abbiamo bisogno di trovare gli item che soddisfano i valori di supporto (la frequenza con cui vengono accese luci di quel colore)
    DROP TABLE IF EXISTS FrequentiColori1;
    CREATE TABLE FrequentiColori1 (
		Colore1 VARCHAR(3) NOT NULL PRIMARY KEY,
        Supporto DOUBLE NOT NULL,
        Occorrenze INT NOT NULL
    );

    -- inserimento solo dei colori che sono frequenti rispetto al valore impostato da noi di supporto
	INSERT INTO FrequentiColori1
    SELECT D.Colore, D.Supporto, D.Occorrenze
    FROM (
			SELECT Colore, Occorrenze / Totale AS Supporto, Occorrenze
			FROM CandidateTable1
	     ) AS D
	WHERE D.Supporto >= Support_; -- PRUNING 
    
	-- |-----------------------------------------------------------------------------------------------------------------------------|
    -- |------------------------------------ CREAZIONE DI UNA TABELLA USATA NELL'ALGORITMO APRIORI ----------------------------------|
    -- |-----------------------------------------------------------------------------------------------------------------------------|
    
	DROP TABLE IF EXISTS TabellaPivotVerticale;
    CREATE TABLE TabellaPivotVerticale (
		ID INT AUTO_INCREMENT,
		OraTarget VARCHAR(20) NOT NULL,
        Stanza INT NOT NULL,
        Colore VARCHAR(3) NOT NULL,
		PRIMARY KEY(ID)
    );
    
    -- adesso inseriamo in questa tabella tutte le interazioni alle luci e i rispettivi colori
    -- rispetto alla tabella ColoriPivot, questa ha per colonne ciò che vediamo dalla dichiarazione della tabella stessa
    -- viene usata per comodità, nota che fanno parte della tabella tutti i colori, anche quelli che sono stati eliminati al primo item-set
    SET @QuerySQL = ' INSERT INTO TabellaPivotVerticale (OraTarget, Stanza, Colore)
					  SELECT OraTarget, Stanza, Colore 
					  FROM ( ';
                            
    SET @i = 1;
    WHILE @i <= NumeroColori_ DO
		 SET @QuerySQL = CONCAT(@QuerySQL, ' SELECT OraTarget, Stanza, \'c', @i,'\' AS Colore
											 FROM ColoriPivot
                                             WHERE c', @i, ' <> 0 ');
		 IF @i <> NumeroColori_ THEN
			SET @QuerySQL = CONCAT(@QuerySQL, ' UNION ALL ');
         END IF;
         SET @i = @i + 1;
    END WHILE;
    SET @QuerySQL = CONCAT(@QuerySQL, ' ) AS D;');
    
    SET @PivotVerticale = @QuerySQL;
    PREPARE PivotVerticale
	FROM @QuerySQL;
    EXECUTE PivotVerticale;
	
    -- |-----------------------------------------------------------------------------------------------------------------------------|
    -- |------------------------------------ MODULAZIONE DELL'ALGORITMO APRIORI DA 2 ITEM-SET A >   ---------------------------------|
    -- |-----------------------------------------------------------------------------------------------------------------------------|

    SET @k = 2;
    SET @TabellaVuota = FALSE;
    # Il primo passo, dei singoli item set, è stato svolto, adesso partiamo dal 2-item-set
    WHILE @TabellaVuota = FALSE DO
		
        -- |-----------------------------------------------------------------------------------------------------------------------------|
		-- | Creazione della tabella "FrequentiColoriK", che contiene i gruppo che superano ogni volta i requisiti di supporto e conf    |
		-- |-----------------------------------------------------------------------------------------------------------------------------|
    
		# Eliminazione tabella FrequentiColori @k , una per ogni k-itemset
        SET @CreazioneFrequentiColoriK = CONCAT('DROP TABLE IF EXISTS FrequentiColori',@k,';'); 
        
        PREPARE FrequentiColorik
		FROM @CreazioneFrequentiColoriK;
		EXECUTE FrequentiColorik;
        # Creazione tabella FrequentiColori @k , una per ogni k-itemset
		SET @CreazioneFrequentiColoriK = CONCAT('CREATE TABLE FrequentiColori',@k,' (
													Colore1 VARCHAR(3) NOT NULL');
		SET @i = 2; 
        # Inserimento di un numero variabile di attributi Colore, che dipende da che item set stiamo cercando
        WHILE @i <= @k DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @CreazioneFrequentiColoriK = CONCAT(@CreazioneFrequentiColoriK, ', Colore',@i, ' VARCHAR(3) NOT NULL ');
            SET @i = @i + 1;
        END WHILE;
        
        SET @CreazioneFrequentiColoriK = CONCAT(@CreazioneFrequentiColoriK, 
												',Supporto DOUBLE NOT NULL ');
		
		SET @i = 1; 
        # Inserimento di un numero variabile di attributi Colore, che dipende da che item set stiamo cercando
        WHILE @i <= @k - 1 DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @CreazioneFrequentiColoriK = CONCAT(@CreazioneFrequentiColoriK, ', Confidenza',@i, ' DOUBLE NOT NULL');
            SET @i = @i + 1;
        END WHILE;
        
        SET @CreazioneFrequentiColoriK = CONCAT(@CreazioneFrequentiColoriK, 
												 ',Occorrenze INT NOT NULL,
												  PRIMARY KEY(Colore1, ');
        SET @i = 2; 
        # Inserimento di un numero variabile di attributi Colore nella CHIAVE, che dipende da che item set stiamo cercando
        WHILE @i <= @k DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @CreazioneFrequentiColoriK = CONCAT(@CreazioneFrequentiColoriK, ' Colore',@i);
            IF @i <> @k THEN
				SET @CreazioneFrequentiColoriK = CONCAT(@CreazioneFrequentiColoriK, ', ');
            END IF;
            SET @i = @i + 1;
        END WHILE;
        
        SET @CreazioneFrequentiColoriK = CONCAT(@CreazioneFrequentiColoriK, '));');
        
        PREPARE FrequentiColorik
		FROM @CreazioneFrequentiColoriK;
		EXECUTE FrequentiColorik;
        
        -- Addesso abbiamo creato la tabella in cui ci metteremo i dati alla fine del ciclo e conterrà i k-item-set che rispettano i valori di 
        -- supporto e confidenza pre-impostati.
        
        SET @InserimentoFrequentiColoriK = CONCAT('INSERT INTO FrequentiColori', @k, ' (Colore1, ');
        SET @i = 2; 
        WHILE @i <= @k DO 
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' Colore',@i, ', ');
            SET @i = @i + 1;
        END WHILE;
        
        -- |-----------------------------------------------------------------------------------------------------------------------|
        -- | Adesso scriviamo il codice modulare per la CTE 'GruppoColori', che contiene tutte le possibili combinazioni di colori |
        -- | ottenute a partire dagli scorsi gruppi in FrequentiColoriK-1.														   |
        -- |-----------------------------------------------------------------------------------------------------------------------|
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, 'Supporto, ');
        
        SET @i = 1; 
        # Inserimento di un numero variabile di attributi Colore nella CHIAVE, che dipende da che item set stiamo cercando
        WHILE @i <= @k - 1 DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' Confidenza',@i, ', ');
            SET @i = @i + 1;
        END WHILE;
        
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' Occorrenze )
												   WITH GruppoColori AS (
													SELECT ');
        
		SET @i = 1;
		WHILE @i <= @k - 1 DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, 'FC0.Colore', @i, ', ');
            SET @i = @i + 1;
        END WHILE;
        
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, 'FC1.Colore',@k-1, ' AS Colore',@k, ' 
														 FROM FrequentiColori', @k-1, ' FC0
														 INNER JOIN
                                                         FrequentiColori', @k-1, ' FC1 ON ');
		SET @i = 1;
        WHILE @i <= @k - 2 DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' FC0.Colore', @i, ' = FC1.Colore', @i, ' AND ');
            SET @i = @i + 1;
        END WHILE;
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' FC0.Colore', @k-1, ' < FC1.Colore', @k-1, '), ');
        
        -- |-----------------------------------------------------------------------------------------------------------------------|
        -- | Adesso scriviamo il codice modulare per la CTE 'CandidateTableK', che contiene tutti i dati utili come le occorrenze  |
        -- | di un gruoopo, quelle di tutti i gruppi, quelle degli elementi implicanti, così da calcolare supporto e confidenza    |													   
        -- |-----------------------------------------------------------------------------------------------------------------------|
        
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' CandidateTable', @k, ' AS ( 
												  SELECT ');
		SET @i = 1;
        WHILE @i <= @k DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' D2.Colore', @i, ', ');
            SET @i = @i + 1;
        END WHILE;
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' D2.OccorrenzeGruppo, D3.TotaliGruppi, D4.OccorrenzeColoriImplicanti
												  FROM (
														 SELECT ');
		SET @i = 1;
        WHILE @i <= @k DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' D0.Colore', @i, ', ');
            SET @i = @i + 1;
        END WHILE;
		SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' COUNT(DISTINCT D1.OraTarget, D1.Stanza) AS OccorrenzeGruppo
												  FROM (
														 SELECT ');
		SET @i = 1;
        WHILE @i <= @k DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, 'Colore', @i);
            IF @i <> @k THEN
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ', ');
            END IF;
            SET @i = @i + 1;
        END WHILE;
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' FROM GruppoColori
																			  ) AS D0
																				INNER JOIN
																			  (
																				SELECT ');
		
		SET @i = 1;
        WHILE @i <= @k DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' PV', @i, '.Colore AS Colore', @i, ', ');
            SET @i = @i + 1;
        END WHILE;
		SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, 'PV2.OraTarget, PV2.Stanza 
												  FROM ');
		
        SET @i = 1;
        WHILE @i <= @k DO -- dobbiamo inserire fino a k attributi Colore@k, elementi degli insiemi che andremo a studiare
			-- TabellaPivotVerticale PV1
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' TabellaPivotVerticale PV', @i);
            IF @i > 1 THEN  -- PV0.OraTarget = PV1.OraTarget AND PV0.Stanza = PV1.Stanza AND PV0.Colore < PV1.Colore
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' ON PV', @i-1, '.OraTarget = PV', @i, '.OraTarget AND 
																						PV', @i-1, '.Stanza = PV',@i, '.Stanza AND
                                                                                        PV', @i-1, '.Colore < PV', @i, '.Colore ');
            END IF;
            IF @i <> @k THEN -- INNER JOIN
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' INNER JOIN ');
            END IF;
            SET @i = @i + 1;
        END WHILE;
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' ) AS D1 ON ');
        
        SET @i = 1;
        WHILE @i <= @k DO -- inserimento della clausola ON che collega D0 con D1
			-- TabellaPivotVerticale PV1
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' D0.Colore',@i, ' = D1.Colore', @i);
            IF @i <> @k THEN -- INNER JOIN
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' AND ');
            END IF;
            SET @i = @i + 1;
        END WHILE;
        
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' GROUP BY ');
        SET @i = 1;
        WHILE @i <= @k DO -- gli attributi del gruppo su cui effettuare un group by, infatti noi cerchiamo le occorrenze di ogni gruppo
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' D0.Colore', @i);
            IF @i <> @k THEN 
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ', ');
            END IF;
            SET @i = @i + 1;
        END WHILE;
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' ) AS D2 
												  INNER JOIN
													(
														SELECT COUNT(*) AS TotaliGruppi
														FROM GruppoColori
													) AS D3
													INNER JOIN
													(
														SELECT ');
		
        SET @i = 1;
        WHILE @i <= @k - 1 DO -- qua stiamo creando una DT per calcolare le occorrenze degli implicanti per ogni gruppo, per calcolare la confidenza
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' GC.Colore', @i, ', ');
            SET @i = @i + 1;
        END WHILE;
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' COUNT(DISTINCT PV1.OraTarget, PV1.Stanza) AS OccorrenzeColoriImplicanti
												  FROM GruppoColori GC
                                                  INNER JOIN ');
		SET @i = 1;
        WHILE @i <= @k - 1 DO 
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' TabellaPivotVerticale PV', @i, ' ON GC.Colore', @i, ' = PV', @i, '.Colore ');
            IF @i > 1 THEN 
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' AND PV', @i-1, '.OraTarget = PV', @i, '.OraTarget AND
																						  PV', @i-1, '.Stanza = PV', @i, '.Stanza ');
            END IF;
            IF @i <> @k - 1 THEN 
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' INNER JOIN ');
            END IF;
            SET @i = @i + 1;
        END WHILE;
        
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' GROUP BY ');
        SET @i = 1;
        WHILE @i <= @k - 1 DO -- qua stiamo creando una DT per calcolare le occorrenze degli implicanti per ogni gruppo, per calcolare la confidenza
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' GC.Colore', @i);
            IF @i <> @k - 1 THEN
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ', ');
            END IF;
            SET @i = @i + 1;
        END WHILE;
        
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' ) AS D4 ON ');
        SET @i = 1;
        WHILE @i <= @k - 1 DO -- qua stiamo creando una DT per calcolare le occorrenze degli implicanti per ogni gruppo, per calcolare la confidenza
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' D2.Colore', @i, ' = D4.Colore', @i);
            IF @i <> @k - 1 THEN
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' AND ');
            END IF;
            SET @i = @i + 1;
        END WHILE;
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' ) ');
        
        
        -- |-----------------------------------------------------------------------------------------------------------------------|
        -- | Adesso scriviamo il codice modulare per il calcolo del supporto e , della confidenza per ogni gruppo, vediamo quali   |
        -- | soddisfano i requisiti minimi e poi, i gruppi che li rispettano verranno inseriti nella tabella "FrequentiColoriK"    |													   
        -- |-----------------------------------------------------------------------------------------------------------------------|
        
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' SELECT *
												  FROM (
														SELECT ');
		
        SET @i = 1;
        WHILE @i <= @k DO -- qua stiamo creando una DT per calcolare le occorrenze degli implicanti per ogni gruppo, per calcolare la confidenza
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' CT.Colore', @i, ', ');
            SET @i = @i + 1;
        END WHILE;
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' CT.OccorrenzeGruppo / CT.TotaliGruppi AS Supporto, ');
        
        -- inseriamno nel select i vari valori di Confidenza: per k = 4 avremo conf1 = A->BCD, conf2 = AB->CD, conf3 = ABC->D
        SET @i = 1;
        WHILE @i <= @k - 2 DO -- dal terzo passaggio in poi, abbiamo bisogno di ritrovare dalle precedenti tabelle i valori di supporto per gli item
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' CT.OccorrenzeGruppo / FC',@i, '.Supporto AS Confidenza',@i, ', ');
            SET @i = @i + 1;
        END WHILE;
        
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' CT.OccorrenzeGruppo / CT.OccorrenzeColoriImplicanti AS Confidenza',@k-1,', 
																				  OccorrenzeGruppo
																				  FROM CandidateTable', @k, ' CT');
                                                  
		-- ricordiamo che dobbiamo calcolare per esempio in un 3-item set oltre che AB->C anche A->BC, quindi serve il supporto di A
        -- lo troviamo nelle precedenti tabelle che abbiamo popolato negli scorsi passaggi per esempio per il supp(A) devo cercarlo in FrequentiColori1
        SET @i = @k - 2;
        WHILE @i >= 1 DO -- dal terzo passaggio in poi, abbiamo bisogno di ritrovare dalle precedenti tabelle i valori di supporto per gli item
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, 
													  ' INNER JOIN 
														FrequentiColori',@i, ' FC',@i, ' ON ');
			SET @j = @i;
			WHILE @j >= 1 DO
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, 
														  ' FC',@i, '.Colore',@j, ' = CT.Colore',@j);
				IF @j <> 1 THEN
					SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' AND ');
                END IF;
				SET @j = @j - 1;
            END WHILE;
            SET @i = @i - 1;
        END WHILE;
        
        -- qua adesso andiamo a togliere tra i record gli item-set che non rispettano la confidenza e il supporto necessario
        SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' ) AS D0
                                                  WHERE D0.Supporto >= ',Support_,'
                                                  AND ');
		
        SET @i = 1;
        WHILE @i <= @k - 1 DO -- dal terzo passaggio in poi, abbiamo bisogno di ritrovare dalle precedenti tabelle i valori di supporto per gli item
			SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' D0.Confidenza',@i, ' >= ', Confidence_);
            IF @i <> @k - 1 THEN
				SET @InserimentoFrequentiColoriK = CONCAT(@InserimentoFrequentiColoriK, ' AND ');
            END IF;
            SET @i = @i + 1;
        END WHILE;
        
        PREPARE InserimentoInFrequentiColoriK
		FROM @InserimentoFrequentiColoriK;
		EXECUTE InserimentoInFrequentiColoriK;
		
        -- Adesso dobbiamo sapere se all'interno della tabella abbiamo qualche row, potrebbero non esserci
        -- item set, e quindi l'algoritmo apriori si conclude.
        DROP TEMPORARY TABLE IF EXISTS NumeroItemSetRimasti;
        CREATE TEMPORARY TABLE NumeroItemSetRimasti (
			Numero INT NOT NULL PRIMARY KEY
		);
		SET @NumeroItemSetRimasti = CONCAT('INSERT INTO NumeroItemSetRimasti
											SELECT COUNT(*)
											FROM FrequentiColori', @k);
		
        PREPARE NumeroItemSetRimasti
		FROM @NumeroItemSetRimasti;
		EXECUTE NumeroItemSetRimasti;
        
        SELECT Numero INTO NumeroItemSetRimasti_
        FROM NumeroItemSetRimasti;
        
        IF NumeroItemSetRimasti_ = 0 THEN
			SET @TabellaVuota = TRUE;
            SET @k = @k - 1;
		ELSE
			SET @k = @k + 1;
        END IF;
        
    END WHILE;
    
    # ###################################################################################################################################### #
    # Adesso sappiamo quali sono gli item più frequenti, quindi andiamo a restituire questo valore in una tabella che conterrà, ogni giorno  #
    # i valori più frequenti, rispetto ai dati dei 5 giorni precedenti.                                                                      #
    # ###################################################################################################################################### #
    
    SET SQL_SAFE_UPDATES = 0;
    DELETE FROM ColoriFrequenti
    WHERE Data = CURRENT_DATE;
	SET SQL_SAFE_UPDATES = 1;
    
    SET @QuerySQL = CONCAT('INSERT INTO ColoriFrequenti (Colore, Combinazione)
							WITH NumRowNumber AS (
								SELECT ');
                            
	SET @i = 1;
	WHILE @i <= @k DO -- inseriamo tanti UNION quanti sono gli elementi dell'item-set
		SET @QuerySQL = CONCAT(@QuerySQL, ' Colore',@i, ', ');
		SET @i = @i + 1;
	END WHILE;
	
	SET @QuerySQL = CONCAT(@QuerySQL,' ROW_NUMBER() OVER () AS Combinazione
								FROM FrequentiColori',@k,'
							)
							SELECT Colore, Combinazione
							FROM ( ');
                            
    SET @i = 1;
	WHILE @i <= @k DO -- inseriamo tanti UNION quanti sono gli elementi dell'item-set
		SET @QuerySQL = CONCAT(@QuerySQL, '
												SELECT Colore',@i,' AS Colore, Combinazione
												FROM NumRowNumber RN',@i, ' 
											');
		
        
		
        IF @i <> @k THEN
			SET @QuerySQL = CONCAT(@QuerySQL,' UNION ALL ');
        END IF;
		SET @i = @i + 1;
	END WHILE;
    
    SET @QuerySQL = CONCAT(@QuerySQL, ' ) AS D0;');
                                            
    # Inserimento dentro la tabella del risultato dell'Analytics
    PREPARE InserimentoRisultato
	FROM @QuerySQL;
	EXECUTE InserimentoRisultato;
    
    # Droppiamo le tabelle che non sono temporary table e non ci interessano:
	DROP TABLE IF EXISTS ListaLuciAccese;
    DROP TABLE IF EXISTS ColoriPivot;
    DROP TABLE IF EXISTS TabellaPivotVerticali;
    
    -- Commenta qua per visualizzare le tabelle -- 
    /*SET @i = 1;
    WHILE @i <= @k + 1 DO -- inseriamo tanti UNION quanti sono gli elementi dell'item-set
		SET @QuerySQL = CONCAT('DROP TABLE IF EXISTS FrequentiColori',@i);
        PREPARE EliminazioneTabelleFrequenti
		FROM @QuerySQL;
		EXECUTE EliminazioneTabelleFrequenti;
        
		SET @i = @i + 1;
	END WHILE;*/
END $$
DELIMITER ;

DROP EVENT IF EXISTS RelazioniTraColori;
CREATE EVENT RelazioniTraColori
ON SCHEDULE EVERY 1 DAY
STARTS '2021-11-08 00:30:00'
DO
	CALL RelazioniColoreLuci();

CALL RelazioniColoreLuci();

/* ----- PER VISUALIZZARE LE TABELLE ------ */
SELECT *
FROM FrequentiColori1;
SELECT *	
FROM FrequentiColori2;
SELECT *	
/*FROM FrequentiColori3;
SELECT *	
FROM FrequentiColori4;*/