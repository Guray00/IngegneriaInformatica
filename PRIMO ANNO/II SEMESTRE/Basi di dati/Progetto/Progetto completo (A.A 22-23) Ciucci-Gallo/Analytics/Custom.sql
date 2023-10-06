DROP FUNCTION IF EXISTS `ValutazioneAttore`;
DELIMITER //
CREATE FUNCTION `ValutazioneAttore`(
    Nome VARCHAR(50),
    Cognome VARCHAR(50)
    )
RETURNS FLOAT 
NOT DETERMINISTIC
READS SQL DATA
BEGIN

    DECLARE sum_v FLOAT;
    DECLARE sum_p FLOAT;
    DECLARE n INT;

    SET sum_v := (
        SELECT
            SUM(IFNULL(F.MediaRecensioni, 0))
        FROM Artista A
        INNER JOIN Recitazione R
            ON R.NomeAttore = A.Nome AND R.CognomeAttore = A.Cognome
        INNER JOIN Film F
            ON F.ID = R.Film
        WHERE A.Nome = Nome AND A.Cognome = Cognome
    );

    SET sum_p := (
        SELECT
            COUNT(DISTINCT VP.Film)
        FROM Artista A
        INNER JOIN Recitazione R
            ON R.NomeAttore = A.Nome AND R.CognomeAttore = A.Cognome
        INNER JOIN VincitaPremio VP
            ON VP.Film = R.Film
        WHERE A.Nome = Nome AND A.Cognome = Cognome
    );

    SET n := (
        SELECT
            COUNT(*)
        FROM VincitaPremio
        WHERE NomeArtista = Nome AND CognomeArtista = CognomeArtista
    );

    RETURN sum_v + sum_p * 5 + n * 50.0;

END //
DELIMITER ;


DROP PROCEDURE IF EXISTS `MiglioreAttore`;
DELIMITER //
CREATE PROCEDURE `MiglioreAttore`()
BEGIN

    WITH
        AttoreValutazione AS (
            SELECT
                Nome, Cognome,
                ValutazioneAttore(Nome, Cognome) AS Valutazione
            FROM Artista
            WHERE Popolarita <= 2.5
        )
    SELECT
        Nome, Cognome
    FROM AttoreValutazione
    WHERE Valutazione = (
        SELECT MAX(Valutazione)
        FROM AttoreValutazione
    );

END //
DELIMITER ;







DROP FUNCTION IF EXISTS `ValutazioneRegista`;
DELIMITER //
CREATE FUNCTION `ValutazioneRegista`(
    Nome VARCHAR(50),
    Cognome VARCHAR(50)
    )
RETURNS FLOAT 
NOT DETERMINISTIC
READS SQL DATA
BEGIN

    DECLARE sum_v FLOAT;
    DECLARE sum_p FLOAT;
    DECLARE n INT;

    SET sum_v := (
        SELECT
            SUM(IFNULL(MediaRecensioni, 0))
        FROM Film
        WHERE NomeRegista = Nome AND CognomeRegista = Cognome
    );

    SET sum_p := (
        SELECT
            COUNT(DISTINCT VP.Film)
        FROM Film F
        INNER JOIN VincitaPremio VP
            ON VP.Film = F.ID
        WHERE F.NomeRegista = Nome AND F.CognomeRegista = Cognome
    );

    SET n := (
        SELECT
            COUNT(*)
        FROM VincitaPremio
        WHERE NomeArtista = Nome AND CognomeArtista = CognomeArtista
    );

    RETURN sum_v + sum_p * 5 + n * 50.0;

END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS `MiglioreRegista`;
DELIMITER //
CREATE PROCEDURE `MiglioreRegista`()
BEGIN

    WITH
        RegistaValutazione AS (
            SELECT
                Nome, Cognome,
                ValutazioneRegista(Nome, Cognome) AS Valutazione
            FROM Artista
            WHERE Popolarita <= 2.5
        )
    SELECT
        Nome, Cognome
    FROM RegistaValutazione
    WHERE Valutazione = (
        SELECT MAX(Valutazione)
        FROM RegistaValutazione
    );

END //
DELIMITER ;