USE `FilmSphere`;


DROP FUNCTION IF EXISTS `RatingUtente`;

DELIMITER //

CREATE FUNCTION `RatingUtente`(
    id_film INT,
    id_utente VARCHAR(100)
)
RETURNS FLOAT 
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE out_value FLOAT DEFAULT 0.0;

    WITH `VisualizzazioniUtente` AS (
        SELECT E.`Film`, V.`Edizione`, V.`Utente`, E.`RapportoAspetto`, F.`NomeRegista`, F.`CognomeRegista`
        FROM `Visualizzazione` V
            INNER JOIN `Edizione` E ON E.ID = V.`Edizione`
            INNER JOIN `Film` F ON F.`ID` = E.`Film`
        WHERE V.`Utente` = id_utente
    ), 
    
    `GenereVisualizzazioni` AS (
        SELECT
            GF.`Genere`,
            COUNT(*),
            RANK() OVER (
                ORDER BY COUNT(*) DESC, GF.`Genere`
            ) AS rk
        FROM `VisualizzazioniUtente` V
            INNER JOIN `GenereFilm` GF USING(`Film`)
        GROUP BY GF.`Genere`
    ), `PunteggiGeneri` AS (
        SELECT (3 - G.`rk`) AS Punteggio
        FROM `GenereVisualizzazioni` G
            INNER JOIN `GenereFilm` GF USING(`Genere`)
        WHERE GF.`Film` = id_film AND G.`rk` <= 2
        LIMIT 2
    ), 
    
    `AttoriVisualizzazioni` AS (
        SELECT
            R.`NomeAttore`,
            R.`CognomeAttore`,
            COUNT(*),
            RANK() OVER (
                ORDER BY COUNT(*) DESC, R.`NomeAttore`, R.`CognomeAttore`
            ) AS rk
        FROM `VisualizzazioniUtente` V
            INNER JOIN `Recitazione` R USING(`Film`)
        GROUP BY R.`NomeAttore`, R.`CognomeAttore`
    ), `PunteggiAttori` AS (
        SELECT (CASE
            WHEN A.`rk` = 1 THEN 1.5
            WHEN A.`rk` = 2 THEN 1.0
            WHEN A.`rk` = 3 THEN 0.5
            END) AS Punteggio
        FROM `AttoriVisualizzazioni` A
            INNER JOIN `Recitazione` R USING(`NomeAttore`, `CognomeAttore`)
        WHERE R.`Film` = id_film AND A.`rk` <= 3
        LIMIT 3
    ),
    
    `LinguaVisualizzazioni` AS (
        SELECT
            D.`Lingua`,
            COUNT(*),
            RANK() OVER(
                ORDER BY COUNT(*) DESC
            ) AS rk
        FROM `VisualizzazioniUtente` V
            INNER JOIN `File` F USING (`Edizione`)
            INNER JOIN `Doppiaggio` D ON D.`File` = F.`ID`
        GROUP BY D.`Lingua`
    ), `PunteggiLingue` AS (
        SELECT 1 AS Punteggio
        FROM `LinguaVisualizzazioni` L
            INNER JOIN `Doppiaggio` D USING(`Lingua`)
            INNER JOIN `File` F ON F.`ID` = D.`File`
            INNER JOIN `Edizione` E ON E.`ID` = F.`Edizione`
        WHERE E.`Film` = id_film AND L.`rk` <= 2
        LIMIT 2
    ),
    
    `RegistaVisualizzazioni` AS (
        SELECT
            V.`NomeRegista`,
            V.`CognomeRegista`,
            COUNT(*)
        FROM `VisualizzazioniUtente` V
        GROUP BY V.`NomeRegista`, V.`CognomeRegista`
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ), `PunteggioRegista` AS (
        SELECT 1 AS Punteggio
        FROM `RegistaVisualizzazioni` R
            INNER JOIN `Film` F USING(`NomeRegista`, `CognomeRegista`)
        WHERE F.`ID` = id_film
    ),


    `RapportoAspettoVisualizzazioni` AS (
        SELECT
            V.`RapportoAspetto`,
            COUNT(*)
        FROM `VisualizzazioniUtente` V
        GROUP BY V.`RapportoAspetto`
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ), `PunteggioRapportoAspetto` AS (
        SELECT 1 AS Punteggio
        FROM `RapportoAspettoVisualizzazioni` R
            INNER JOIN `Edizione` E USING(`RapportoAspetto`)
        WHERE E.`Film` = id_film
        LIMIT 1
    ),

    `Punteggi` AS (
        SELECT *
        FROM `PunteggiGeneri`

        UNION ALL

        SELECT *
        FROM `PunteggiAttori`

        UNION ALL

        SELECT *
        FROM `PunteggiLingue`

        UNION ALL

        SELECT *
        FROM `PunteggioRegista`

        UNION ALL

        SELECT *
        FROM `PunteggioRapportoAspetto`
    )
    SELECT (FLOOR(SUM(`Punteggio`)) / 2.0) INTO out_value 
    FROM `Punteggi`;

    RETURN IFNULL(out_value, 0.0);

END //

DELIMITER ;