USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `Classifica`;
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `Classifica`(
    N INT,
    codice_paese CHAR(2),
    tipo_abbonamento VARCHAR(50),
    P INT -- 1 -> Film   2 -> Edizioni
)
BEGIN

    IF p = 1 THEN

        WITH `FilmVisualizzazioni` AS (
            SELECT
                E.`Film`,
                COUNT(*) AS "Visualizzazioni"
            FROM `Visualizzazione` V
            INNER JOIN `Utente` U ON V.`Utente` = U.`Codice`
            INNER JOIN `Edizione` E ON E.`ID` = V.`Edizione`
            LEFT OUTER JOIN `IPRange` R ON 
                (V.`IP` BETWEEN R.`Inizio` AND R.`Fine`) AND 
                (V.`InizioConnessione` BETWEEN R.`DataInizio` AND IFNULL(R.`DataFine`, CURRENT_TIMESTAMP))
            WHERE U.`Abbonamento` = tipo_abbonamento AND IFNULL (R.`Paese`, '??') = codice_paese
            GROUP BY E.`Film`
        )
        SELECT `Film`
        FROM `FilmVisualizzazioni`
        ORDER BY `Visualizzazioni` DESC
        LIMIT N;

    ELSEIF p = 2 THEN

        WITH `EdizioneVisualizzazioni` AS (
            SELECT
                V.`Edizione`,
                COUNT(*) AS "Visualizzazioni"
            FROM `Visualizzazione` V
            INNER JOIN `Utente` U ON V.`Utente` = U.`Codice`
            LEFT OUTER JOIN `IPRange` R ON 
                (V.`IP` BETWEEN R.`Inizio` AND R.`Fine`) AND 
                (V.`InizioConnessione` BETWEEN R.`DataInizio` AND IFNULL(R.`DataFine`, CURRENT_TIMESTAMP))
            WHERE U.Abbonamento = tipo_abbonamento AND IFNULL (R.`Paese`, '??') = codice_paese
            GROUP BY V.`Edizione`
        )
        SELECT `Edizione`
        FROM `EdizioneVisualizzazioni`
        ORDER BY `Visualizzazioni` DESC
        LIMIT N;

    ELSE

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Parametro P non Valido';

    END IF;

END //

DELIMITER ;