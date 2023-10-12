USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `RaccomandazioneContenuti`;
DELIMITER //
CREATE PROCEDURE `RaccomandazioneContenuti`(
    IN codice_utente VARCHAR(100),
    IN numero_film INT
)
BEGIN

    WITH
        FilmRatingUtente AS (
            SELECT
                ID,
                RatingUtente(ID, codice_utente) AS Rating
            FROM Film
        )
    SELECT ID
    FROM FilmRatingUtente
    ORDER BY Rating DESC, ID
    LIMIT numero_film;


END
//
DELIMITER ;