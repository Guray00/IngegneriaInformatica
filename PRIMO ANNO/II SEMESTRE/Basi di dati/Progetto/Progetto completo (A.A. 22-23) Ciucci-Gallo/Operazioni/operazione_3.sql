USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `FileMiglioreQualita`;

DELIMITER $$

CREATE PROCEDURE `FileMiglioreQualita`(IN film_id INT, IN codice_utente VARCHAR(100))
BEGIN

    DECLARE massima_risoluzione INT;
    SET massima_risoluzione := (
        SELECT
            A.Definizione
        FROM Abbonamento A
        INNER JOIN Utente U
        ON U.Abbonamento = A.Tipo
        WHERE U.Codice = codice_utente
    );

    WITH
        `FileRisoluzione` AS (
            SELECT `File`.`ID`, `Risoluzione`
            FROM `Edizione`
                INNER JOIN `File`
                ON `Edizione`.`ID` = `File`.`Edizione`
            WHERE `Film` = film_id
            AND `Risoluzione` <= massima_risoluzione
        )
    SELECT
        `ID`, `Risoluzione`
    FROM `FileRisoluzione`
    WHERE `Risoluzione` = (
        SELECT
            MAX(`Risoluzione`)
        FROM `FileRisoluzione`
    );

END ; $$

DELIMITER ;