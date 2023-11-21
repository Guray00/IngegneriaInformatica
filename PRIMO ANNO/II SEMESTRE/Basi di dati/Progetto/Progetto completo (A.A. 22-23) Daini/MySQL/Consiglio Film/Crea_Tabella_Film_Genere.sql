DROP PROCEDURE IF EXISTS Crea_Lista_Caratterizzazioni;
DELIMITER $$
CREATE PROCEDURE Crea_Lista_Caratterizzazioni (IN Id_Cliente INT)
BEGIN

        DECLARE Durata_Abbonamento INT DEFAULT 0;
        DECLARE Data_Pagamento DATE DEFAULT NULL;
        DECLARE Caratterizzazione TEXT DEFAULT '';
        DECLARE Tipo VARCHAR(100) DEFAULT '';
        DECLARE i INT DEFAULT 0;
        DECLARE Quante_Virgole INT DEFAULT 0;
        DECLARE Contenuto TEXT DEFAULT '';
        DECLARE Elimina TEXT DEFAULT '';
        DECLARE Inizio INT DEFAULT 0;
        DECLARE Fine INT DEFAULT 0;
        DECLARE Quanti_Divisori INT DEFAULT 0;
        DECLARE Id_Prestito INT DEFAULT 0;
        DECLARE Genere_Albero_Appoggio VARCHAR(100) DEFAULT '';
        DECLARE Genere VARCHAR(100) DEFAULT '';
        DECLARE Genere_Prestito VARCHAR(100) DEFAULT '';
        -- variabile per l'handler
        DECLARE Finito_Ciclo INT DEFAULT 0;
        -- cursore per inserire in una nuova tabella l'identificatore del film e il Genere
        DECLARE Cursore_Trovato CURSOR FOR  (
                                                SELECT  DISTINCT F.Id_Film,F.Genere  
                                                FROM    Film F
                                            ); 
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito_Ciclo = 1; -- handler per il cursore, quando esce dalla tabella


        WITH Abbonamento_Giusto AS  (
                                        SELECT      A.Durata_Abbonamento,A.Caratterizzazione,F.Data_Pagamento,A.Tipo
                                        FROM        Utente U NATURAL JOIN Abbonamento A NATURAL JOIN Fattura F
                                        WHERE       U.Id_Cliente = Id_Cliente AND F.Data_Pagamento IS NOT NULL
                                        ORDER BY    F.Data_Pagamento DESC  
                                    )
        SELECT  AG.Durata_Abbonamento,AG.Data_Pagamento,AG.Caratterizzazione,AG.Tipo INTO Durata_Abbonamento,Data_Pagamento,Caratterizzazione,Tipo
        FROM    Abbonamento_Giusto AG
        LIMIT   1;   

        -- messaggio d'errore se l'abbonamento è Basic
        IF(Tipo = 'Basic')THEN

             SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo di abbonamento errato: il tipo Basic non permette contenuti consigliati';

        END IF;


        -- messaggio d'errore se l'abbonamento è scaduto

        IF (Data_Pagamento <> CURRENT_DATE) AND (Data_Pagamento + INTERVAL Durata_Abbonamento MONTH < CURRENT_DATE) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abbonamento Scaduto: pagare il nuovo abbonamento per accedere al contenuto';

        END IF;

        -- troviamo i film con la stessa caratterizzazione;

        DROP TABLE IF EXISTS Lista_Caratterizzazioni;
        CREATE TABLE Lista_Caratterizzazioni(Contenuto VARCHAR(255) PRIMARY KEY);

        SET Quante_Virgole = (SELECT LENGTH(Caratterizzazione) - LENGTH(REPLACE(Caratterizzazione, ',', '')));
        SET Contenuto = Caratterizzazione;

    WHILE(i <= Quante_Virgole) DO

        SET Fine = POSITION(',' IN Contenuto); -- Trova la posizione della virgola

        IF Fine = 0 THEN -- Se non trova più virgole, prendi l'intera stringa
            SET Fine = LENGTH(Contenuto) + 1;
        END IF;

        SET Elimina = TRIM(SUBSTRING(Contenuto, 1, Fine - 1)); -- Prendi il genere tra le virgole
        INSERT INTO Lista_Caratterizzazioni VALUES (Elimina); -- Inserisci il genere nella tabella

        SET Contenuto = TRIM(SUBSTRING(Contenuto, Fine + 1)); -- Aggiorna la stringa rimuovendo il genere che hai già processato

        SET i = i + 1;

    END WHILE;

        -- dalla lista possiamo trovare tutti i film consigliati
        -- creaiamo una tabella in cui inserire 

        DROP TABLE IF EXISTS Lista_Id_Genere_Appoggio;
        CREATE TABLE Lista_Id_Genere_Appoggio(
                                        Id INT,
                                        Genere VARCHAR(100),
                                        PRIMARY KEY(Id,Genere)
                                    );
        
        OPEN Cursore_Trovato;

    scan: LOOP

        IF Finito_Ciclo = 1 THEN
            LEAVE scan;
        END IF;

        FETCH Cursore_Trovato INTO Id_Prestito,Genere_Prestito;

        -- devo contare i '/'

        SET Quanti_Divisori = (SELECT LENGTH(Genere_Prestito) - LENGTH(REPLACE(Genere_Prestito, '/', '')));

        SET Genere_Albero_Appoggio = Genere_Prestito;

        SET i = 0;

            WHILE(i <= Quanti_Divisori) DO

                SET Fine = POSITION('/' IN Genere_Albero_Appoggio); -- Trova la posizione della virgola

                IF Fine = 0 THEN -- Se non trova più virgole, prendi l'intera stringa
                    SET Fine = LENGTH(Genere_Albero_Appoggio) + 1;
                END IF;

                SET Elimina = TRIM(SUBSTRING(Genere_Albero_Appoggio, 1, Fine - 1)); -- Prendi il genere tra le virgole
                
                INSERT IGNORE INTO Lista_Id_Genere_Appoggio VALUES (Id_Prestito,Elimina); -- Inserisci il genere nella tabella

                SET Genere_Albero_Appoggio = TRIM(SUBSTRING(Genere_Albero_Appoggio, Fine + 1)); -- Aggiorna la stringa rimuovendo il genere che hai già processato

                SET i = i + 1;

            END WHILE;

        END LOOP scan;

        CLOSE Cursore_Trovato;

        -- a questo punto, dobbiamo creare una tabella che combini le 2

        DROP TABLE IF EXISTS Lista_Id_Genere;
        CREATE TABLE Lista_Id_Genere(   Id INT,
                                        Genere VARCHAR(100),
                                        PRIMARY KEY(Id,Genere)
                                    );

        INSERT INTO Lista_Id_Genere(Id,Genere)
        SELECT  LIGA.Id,LIGA.Genere 
        FROM    Lista_Id_Genere_Appoggio LIGA
        WHERE LIGA.Genere IN(
                                SELECT  LC.Contenuto
                                FROM    Lista_Caratterizzazioni LC
                            );

END $$

DELIMITER ;
