USE `FilmSphere`;

DROP PROCEDURE IF EXISTS `FilmEsclusiAbbonamento`;

DELIMITER //

CREATE PROCEDURE `FilmEsclusiAbbonamento`(
    IN TipoAbbonamento VARCHAR(50),
    OUT NumeroFilm INT)
BEGIN

    -- Film esclusi perche' il genere e' escluso
    WITH `FilmEsclusiGenere` AS (
        SELECT DISTINCT GF.`Film`
        FROM `Esclusione` E
            INNER JOIN `GenereFilm` GF USING(`Genere`)
        WHERE E.`Abbonamento` = TipoAbbonamento
    ), 
    
    -- La minor qualita' fruibile di un Film
    `FilmMinimaRisoluzione` AS (
        SELECT `Film`.`ID`, MIN(F.Risoluzione) AS "Risoluzione"
        FROM `File` F
            INNER JOIN `Edizione` E ON F.`Edizione` = E.`ID`
            INNER JOIN `Film` ON E.`Film` = `Film`.`ID`
        GROUP BY `Film`.`ID`
    ), 
    
    -- Film esclusi perche' presenti solo in qualita' maggiore dalla massima disponibile con l'abbonamento
    `FilmEsclusiRisoluzione` AS (
        SELECT F.`ID` AS "Film"
        FROM `FilmMinimaRisoluzione` F
            INNER JOIN `Abbonamento` A ON A.`Definizione` < F.`Risoluzione`
        WHERE A.`Definizione` > 0 AND A.`Tipo` = TipoAbbonamento
    )
    -- UNION senza ALL rimuovera' in automatico gli ID duplicati
    SELECT COUNT(*) INTO NumeroFilm
    FROM (
        SELECT * FROM `FilmEsclusiGenere`

        UNION

        SELECT * FROM `FilmEsclusiRisoluzione`
    ) AS T;
END ; //

DELIMITER ;
