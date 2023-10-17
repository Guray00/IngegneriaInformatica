USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `CachingPrevisionale`;
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `CachingPrevisionale`(
    X INT,
    M INT,
    N INT
)
BEGIN

    -- 1) Per ogni Utente si considera il Paese dal quale si connette di piu' e dal Paese gli N Server piu' vicini
    -- 2) Per ogni coppia Utente, Paese si considerano gli M File con probabilità maggiore di essere guardati, ciascuno con la probabilità di essere guardato
    -- 3) Si raggruppa in base al Server e ad ogni File, sommando, per ogni Server-File la probabilit`a che sia guardato dall’Utente moltiplicata
    --    per un numero che scala in maniera decrescente in base al ValoreDistanza tra Paese e Server
    -- 4) Si restituiscono le prime X coppie Server-File con somma maggiore per le quali non esiste gi`a un P.o.P.
    WITH
        `UtentePaeseVolte` AS (
            SELECT
                V.`Utente`,
                IFNULL (R.`Paese`, '??') AS `Paese`,
                COUNT(*) AS `Volte`
            FROM `Visualizzazione` V
            
            LEFT OUTER JOIN `IPRange` R ON 
                (V.`IP` BETWEEN R.`Inizio` AND R.`Fine`) AND 
                (V.`InizioConnessione` BETWEEN R.`DataInizio` AND IFNULL(R.`DataFine`, CURRENT_TIMESTAMP))
            GROUP BY `Utente`, `Paese`
        ),
        `UtentePaesePiuFrequente` AS (
            SELECT UPV.*
            FROM `UtentePaeseVolte` UPV
            WHERE UPV.`Volte` >= ALL(
                SELECT UPV2.`Volte`
                FROM `UtentePaeseVolte` UPV2
                WHERE UPV2.`Utente` = UPV.`Utente`
            )
        ),
        `ServerTargetPerPaese` AS (
            SELECT `Server`, `Paese`, `ValoreDistanza`,
                RANK() OVER(
                    PARTITION BY `Paese` 
                    ORDER BY `ValoreDistanza`) AS rk
            FROM `DistanzaPrecalcolata`
            -- WHERE `Paese` <> '??'
        ),
        `UtentePaeseServer` AS (
            SELECT
                UP.`Utente`,
                UP.`Paese`,
                S.`Server`,
                S.`ValoreDistanza`
            FROM `UtentePaesePiuFrequente` UP
                INNER JOIN `ServerTargetPerPaese` S USING(`Paese`)
            WHERE rk <= N
        ),

        -- 2) Per ogni coppia Utente, Paese si considerano gli M File con probabilità maggiore di essere guardati, ciascuno con la probabilità di essere guardato
        `FilmRatingUtente` AS (
            SELECT
                F.`ID`,
                U.`Codice`,
                RatingUtente(F.`ID`, U.`Codice`) AS Rating,
                RANK() OVER(
                    PARTITION BY U.`Codice` 
                    ORDER BY Rating DESC
                ) AS rk
            FROM `Film` F
                CROSS JOIN `Utente` U
            HAVING Rating > 0
        ),
        `10FilmUtente` AS (
            SELECT
                `ID` AS Film,
                `Codice` AS Utente,
                (CASE
                    WHEN rk = 1 THEN 30.0
                    WHEN rk = 2 THEN 22.0
                    WHEN rk = 3 THEN 11.0
                    WHEN rk = 4 THEN 9.0
                    WHEN rk = 5 THEN 8.0
                    WHEN rk = 6 THEN 6.0
                    WHEN rk = 7 THEN 5.0
                    WHEN rk = 8 THEN 4.0
                    WHEN rk = 9 THEN 3.0
                    WHEN rk = 10 THEN 2.0
                END) AS Probabilita
            FROM `FilmRatingUtente`
            WHERE rk <= 10
        ),
        `FilmFileAssociati` AS (
            SELECT
                F.`ID` AS Film,
                FI.`ID` AS File
            FROM `Film` F
                INNER JOIN `Edizione` E ON E.`Film` = F.ID
                INNER JOIN `File` FI ON FI.`Edizione` = E.ID
        ),
        `FilmFile` AS (
            SELECT
                F.*,
                F1.`NumeroFile`
            FROM `FilmFileAssociati` F
                INNER JOIN (
                    -- Tabella avente Film e numero di File ad esso associati
                    SELECT
                        F2.`Film`,
                        COUNT(*) AS NumeroFile
                    FROM `FilmFileAssociati` F2
                    GROUP BY F2.`Film`
                ) AS F1 USING (`Film`)
            WHERE F1.`NumeroFile` > 0
        ),
        `FileUtente` AS (
            SELECT
                U.`Utente`,
                F.`File`,
                U.`Probabilita` / F.`NumeroFile` AS Probabilita,
                RANK() OVER(
                    PARTITION BY U.`Utente`
                    ORDER BY U.`Probabilita` / F.`NumeroFile` DESC) AS rk
            FROM `10FilmUtente` U
                NATURAL JOIN `FilmFile` F
        ),
        `ServerFile` AS (
            SELECT
                `File`,
                `Server`,
                SUM(`Probabilita` * (1 + 1 / `ValoreDistanza`)) AS Importanza   -- MODIFICA VALORI PER QUESTA ESPRESSIONE
            FROM `FileUtente` FU
                INNER JOIN `UtentePaeseServer` SU USING(`Utente`)
            WHERE rk <= M
            GROUP BY FU.`File`, SU.`Server`
        )
    SELECT
        `File`,
        `Server`
    FROM `ServerFile` SF
    WHERE NOT EXISTS (
        SELECT *
        FROM `PoP`
        WHERE `PoP`.`Server` = SF.`Server` AND PoP.`File` = SF.`File`
    )
    ORDER BY Importanza DESC
    LIMIT X;

END //

DELIMITER ;