USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `BilanciamentoDelCarico`;
DELIMITER //
CREATE PROCEDURE `BilanciamentoDelCarico`(
    M INT,
    N INT
)
BEGIN

    -- 1) Ottieni Tabella Visualizzazione + Colonna Paese
    -- 2) Ottieni Tabella T(Edizione, Paese, Visualizzazioni)
    -- 3) Per ogni Paese prendi le N Edizioni piu' visualizzate
    --      3.1) Fai un Ranking ordinato per Visualizzazioni e partizionato per Paese
    --      3.2) Seleziona solo i primi N per ogni Partizione
    -- 4) Per ogni Paese si individuano gli M server piu' vicini
    --      4.1) Fai un ranking di Server, Paese ordinato per distanza e partizionato per Paese
    --      4.2) Selezioni i primi M per ogni Paese
    -- 5) Creare una Tabella, senza duplicati, T(Edizione, Server) facendo il JOIN tra la 3 e la 4
    -- 6) Si crea una Tabella, partendo dalla precedente, T(File, Server) contenente ogni File di Edizione ma tale per cui non vi sia un P.o.P tra File e Server
    --      6.1) Fai il JOIN con File e ottieni T(File, Server)
    --      6.2) Imponi che non debba esistere un occorrenza di P.o.P avente stesso File e Server


    WITH
        -- 1) Ottieni Tabella Visualizzazione + Colonna Paese
        `VisualizzazionePaese` AS (
            SELECT
                V.*,
                IFNULL (R.`Paese`, '??') AS "Paese"
            FROM Visualizzazione V
                LEFT OUTER JOIN `IPRange` R ON 
                    (V.`IP` BETWEEN R.`Inizio` AND R.`Fine`) AND 
                    (V.`InizioConnessione` BETWEEN R.`DataInizio` AND IFNULL(R.`DataFine`, CURRENT_TIMESTAMP))
        ),

        -- 2) Ottieni Tabella T(Edizione, Paese, Visualizzazioni)
        `EdizionePaeseVisualizzazioni` AS (
            SELECT
                V.`Edizione`,
                V.`Paese`,
                COUNT(*) AS "Visualizzazioni"
            FROM `VisualizzazionePaese` V
            GROUP BY V.`Edizione`, V.`Paese`
        ),

        -- 3) Per ogni Paese prendi le N Edizioni piu' visualizzate
        `RankingVisualizzazioniPerPaese` AS (
            SELECT
                `Edizione`,
                `Paese`,
                RANK() OVER (
                    PARTITION BY `Paese`
                    ORDER BY `Visualizzazioni` DESC, `Edizione`) AS rk
            FROM `EdizionePaeseVisualizzazioni` 
        ),
        `EdizioniTargetPerPaese` AS (
            SELECT
                `Edizione`,
                `Paese`
            FROM `RankingVisualizzazioniPerPaese`
            WHERE rk <= N
        ),

        -- 4) Per ogni Paese si individuano gli M server piu' vicini
        `RankingPaeseServer` AS (
            SELECT
                `Server`,
                `Paese`,
                RANK() OVER(
                    PARTITION BY `Paese` 
                    ORDER BY `ValoreDistanza`, `Paese`) AS rk
            FROM `DistanzaPrecalcolata`
        ),
        `ServerTargetPerPaese` AS (
            SELECT
                `Server`,
                `Paese`
            FROM `RankingPaeseServer`
            WHERE rk <= M
        ),

        -- 5) Creare una Tabella, senza duplicati, T(Edizione, Server) facendo il JOIN tra la 3 e la 4
        `EdizionePaese` AS (
            SELECT DISTINCT
                `Edizione`,
                `Server`
            FROM `ServerTargetPerPaese` SP
            INNER JOIN `EdizioniTargetPerPaese` EP
                USING(`Paese`)
        )

    -- 6)  Si crea una Tabella, partendo dalla precedente, T(File, Server) contenente ogni File di Edizione ma tale per cui non vi sia un P.o.P tra File e Server
    SELECT
        F.`ID` AS File,
        EP.`Server`
    FROM `EdizionePaese` EP
    INNER JOIN `File` F USING (`Edizione`)
    WHERE NOT EXISTS (
        SELECT *
        FROM `PoP`
        WHERE `PoP`.`File` = F.`ID`
        AND `PoP`.`Server` = EP.`Server`
    );


END
//
DELIMITER ;