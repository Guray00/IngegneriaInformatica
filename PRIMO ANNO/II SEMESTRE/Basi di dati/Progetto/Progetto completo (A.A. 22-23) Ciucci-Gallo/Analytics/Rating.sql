USE `FilmSphere`;

DROP FUNCTION IF EXISTS `RatingFilm`;
DELIMITER //
CREATE FUNCTION IF NOT EXISTS `RatingFilm`(
    `id_film` INT
)
RETURNS FLOAT NOT DETERMINISTIC
    READS SQL DATA
BEGIN

    DECLARE RU FLOAT;
    DECLARE RC FLOAT;
    DECLARE PA FLOAT;
    DECLARE PR FLOAT;
    DECLARE PV FLOAT;
    DECLARE RMU FLOAT;

    SET RU := (
        SELECT
            IFNULL(MediaRecensioni, 0)
        FROM Film
        WHERE ID = id_film
    );

    SET RC := (
        SELECT
            IFNULL(AVG(Voto), 0)
        FROM Critica
        WHERE Film = id_film
    );

    SET PA := (
        SELECT
            IFNULL(AVG(Popolarita), 0)
        FROM Artista A
        INNER JOIN Recitazione R
        ON A.Nome = R.NomeAttore AND A.Cognome = R.CognomeAttore
        WHERE Film = id_film
    );

    SET PR := (
        SELECT
            IFNULL(Popolarita, 0)
        FROM Artista A
        INNER JOIN Film F
        ON F.NomeRegista = A.Nome AND F.CognomeRegista = A.Cognome
        WHERE ID = id_film
    );

    SET PV := (
        SELECT
            COUNT(*)
        FROM VincitaPremio
        WHERE Film = id_film
    );

    SET RMU := (
        SELECT
            IFNULL(MAX(F2.MediaRecensioni), 100000)
        FROM Film F1
        INNER JOIN GenereFilm GF1
        ON GF1.Film = F1.ID
        INNER JOIN GenereFilm GF2
        ON GF2.Genere = GF1.Genere
        INNER JOIN Film F2
        ON GF2.Film = F2.ID
        WHERE F1.ID = id_film
    );

    RETURN FLOOR(0.5 * (RU + RC) + 0.1 * (PA + PR) + 0.1 * PV + (RU/RMU)) / 2;

END
//
DELIMITER ;