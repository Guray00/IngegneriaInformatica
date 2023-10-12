USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `FilmPiuVistiRecentemente`;

DELIMITER //

CREATE PROCEDURE `FilmPiuVistiRecentemente`(IN numero_film INT)
BEGIN
    IF numero_film <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Numero di Film non valido';
    END IF;

    WITH `VisualizzazioniFilm` AS (
        SELECT V.Film, SUM(V.`NumeroVisualizzazioni`) AS "Vis"
        FROM `VisualizzazioniGiornaliere` V
        GROUP BY V.`Film`
        HAVING SUM(V.`NumeroVisualizzazioni`) > 0
        LIMIT numero_film
    )
    SELECT F.`ID`, F.`Titolo`, V.`Vis`
    FROM `Film` F
        INNER JOIN `VisualizzazioniFilm` V ON V.`Film` = F.`ID`
    ORDER BY V.`Vis` DESC;

END // 
DELIMITER ;