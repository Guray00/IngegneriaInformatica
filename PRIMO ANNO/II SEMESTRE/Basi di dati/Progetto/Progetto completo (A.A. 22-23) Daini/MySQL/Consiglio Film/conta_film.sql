-- varie fasi:
/*
1 andare nell'utente e vedere la caratterizzazione
2 andiamo a vedere i film con la stessa caratterizzazione
3 scelta di consiglio in base a:
a premi film
b premi regista
c premi attore
d a,b
e a,c
f b,c
*/

DROP PROCEDURE IF EXISTS Stampa_Film_Consigliati;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Consigliati(IN Id_Utente INT)
BEGIN

        DECLARE Quanti_Premi INT DEFAULT 0;
        DECLARE Durata_Abbonamento INT DEFAULT 0;
        DECLARE Data_Pagamento DATE DEFAULT NULL;
        DECLARE Caratterizzazione_Contenuti TEXT DEFAULT '';
        DECLARE i INT DEFAULT 0;
        DECLARE Contenuto TEXT DEFAULT '';
        DECLARE Elimina TEXT DEFAULT '';
        DECLARE Inizio INT DEFAULT 0;
        DECLARE Fine INT DEFAULT 0;
        DECLARE Id INT DEFAULT 0;
        DECLARE Genere VARCHAR(100) DEFAULT '';
        DECLARE Quanti_Divisori INT DEFAULT 0;
        DECLARE Finito_Ciclo INT DEFAULT 0;
        DECLARE Id_Prestito INT DEFAULT 0;
        DECLARE Genere_Prestito VARCHAR(100) DEFAULT 0;
        DECLARE Cursore_Trovato CURSOR FOR  (
                                                SELECT  Id_Film,Genere  
                                                FROM    Film
                                            ); -- query
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito_Ciclo = 1;


        WITH Abbonamento_Giusto AS  (
                                        SELECT      U.Id_Cliente,U.Quanti_Premi,A.Durata_Abbonamento,A.Caratterizzazione,F.Data_Pagamento,F.Scadenza
                                        FROM        Utente U NATURAL JOIN Abbonamento A NATURAL JOIN Fattura F
                                        WHERE       U.Id_Cliente = Id_Cliente AND f.Data_Pagamento IS NOT NULL
                                        ORDER BY    F.Data_Pagamento DESC  
                                    ),
        SELECT  UT.Quanti_Premi,UT.Durata_Abbonamento,UT.Data_Pagamento,UT.Caratterizzazione INTO(Quanti_Premi,Durata_Abbonamento,Data_Pagamento,Caratterizzazione_Contenuti)
        FROM    Abbonamento_Giusto
        LIMIT   1;   

        -- messaggio d'errore se l'abbonamento è scaduto

        IF (Data_Pagamento <> CURRENT_DATE) AND (Data_Pagamento + INTERVAL Durata_Abbonamento MONTH < CURRENT_DATE) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abbonamento Scaduto: pagare il nuovo abbonamento per accedere al contenuto';

        END IF;

        -- troviamo i film con la stessa caratterizzazione;

        DROP TABLE IF EXISTS Lista_Caratterizzazioni;
        CREATE TABLE Lista_Caratterizzazioni(Contenuto VARCHAR(255) PRIMARY KEY);

        DECLARE Quante_Virgole INT DEFAULT 0;

        SET Quante_Virgole = (SELECT LENGTH(Caratterizzazione) - LENGTH(REPLACE(Caratterizzazione, ',', '')));
        SET Contenuto = Caratterizzazione;

        WHILE( i <= Quante_Virgole)

            SET Fine = POSITION(',' IN Contenuto) - 1; -- trovo la prima virgola del carattere e prendo la stringa prima del carattere

            SET Elimina = SUBSTRING(Contenuto,Inizio,Fine); -- prendo la parola

            SET Elimina = SUBSTRING(Genere,Inizio,Fine+1);

            INSERT INTO Lista_Caratterizzazioni VALUES(Elimina); -- inserisco la sottostringa nella lista

            SET Contenuto = Elimina_Sottostringa(Contenuto,Elimina);

        SET i = i + 1;

        END WHILE;

        -- dalla lista possiamo trovare tutti i film consigliati
        -- creaiamo una tabella in cui inserire 

        DROP TABLE IF EXISTS TABLE Lista_Id_Genere;
        CREATE TABLE Lista_Id_Genere(
                                        Id INT PRIMARY KEY,
                                        Genere VARCHAR(100) PRIMARY KEY;
                                    );
        
        OPEN Cursore_Trovato;

        WHILE(Cursore_Trovato <> 1)

            FETCH Cursore_Trovato INTO (Id,Genere);

            -- devo contare i '/'

            SET Quanti_Divisori = (SELECT LENGTH(Caratterizzazione) - LENGTH(REPLACE(Caratterizzazione, ',', '')));

            SET i = 0;

            WHILE(i <= Quanti_Divisori)

                SET Fine = POSITION('/' IN Genere) - 1;

                SET Elimina = SUBSTRING(Genere,Inizio,Fine);

                INSERT INTO Lista_Id_Genere VALUES(Id,Elimina);

                SET Elimina = SUBSTRING(Genere,Inizio,Fine+1);

                SET Genere = Elimina_Sottostringa(Genere,Elimina);

                SET i = i + 1;

            END WHILE;

        END WHILE;

        CLOSE Cursore_Trovato;

        -- a questo punto, possiamo scremare i film

        -- lista film basato solo sulla caratterizzazione
        SELECT  LIG.Id, LIG.Genere INTO(Id_Prestito,Genere_Prestito)
        FROM    Lista_Id_Genere LIG
        WHERE   LIG.Genere IN   (
                                    SELECT  LC.Caratterizzazione
                                    FROM    Lista_Caratterizzazioni LC
                                );
        -- ora possiamo a seconda della scelta, classificare in base ai premi del film, in base all'attore e regista preferito

        


END $$