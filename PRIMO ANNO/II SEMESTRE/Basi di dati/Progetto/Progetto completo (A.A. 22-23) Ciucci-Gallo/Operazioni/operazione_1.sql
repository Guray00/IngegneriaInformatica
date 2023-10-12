USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `VinciteDiUnFilm`;
DELIMITER //
CREATE PROCEDURE `VinciteDiUnFilm`(IN film_id INT)
BEGIN

    SELECT
        GROUP_CONCAT(
            `Macrotipo`, ' ',
            `Microtipo`, ' ',
            `Data`
        ) AS ListaPremi,
        COUNT(*) AS NumeroPremiVinti
    FROM `VincitaPremio`
     WHERE `Film` = film_id
    GROUP BY `Film`;

END //

DELIMITER ;