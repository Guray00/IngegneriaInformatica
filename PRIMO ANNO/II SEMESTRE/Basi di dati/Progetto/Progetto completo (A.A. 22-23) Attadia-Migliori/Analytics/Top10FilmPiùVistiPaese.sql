USE filmsphere;

DELIMITER $$

DROP PROCEDURE IF EXISTS Top10FilmPaese;
CREATE PROCEDURE Top10FilmPaese(IN Paese_ VARCHAR(45))
BEGIN    
    WITH ProiezioniPaese AS (
        SELECT C.Paese, P.ID, P.MarcaTemporale, P.Film
        FROM Proiezioni P
        LEFT OUTER JOIN Connessioni C ON C.ID = P.Connessione
        WHERE C.Paese = Paese_
    )
    
    SELECT Titolo, COUNT(*) AS VisualTotali, RANK() OVER (ORDER BY COUNT(*) DESC) AS Posizione
    FROM ProiezioniPaese PP
    LEFT OUTER JOIN Film F ON F.ID = PP.Film
    GROUP BY PP.Film
    ORDER BY VisualTotali DESC
    LIMIT 10;

END $$


DELIMITER ;
