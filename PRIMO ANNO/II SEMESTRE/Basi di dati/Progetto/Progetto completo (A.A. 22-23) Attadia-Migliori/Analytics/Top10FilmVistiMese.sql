USE filmsphere;

DROP PROCEDURE IF EXISTS TopFilmMese;
DELIMITER $$
CREATE PROCEDURE TopFilmMese(IN Mese INT)

BEGIN    
    WITH FilmProiettatiMese AS (
		SELECT Film, MarcaTemporale
        FROM Proiezioni P
        WHERE MONTH(MarcaTemporale) = Mese
    )
    
	SELECT Titolo, COUNT(*) AS Visualizzazioni, RANK() OVER (ORDER BY COUNT(*) DESC) AS Posizione
	FROM FilmProiettatiMese FM
    LEFT OUTER JOIN (
		Select Titolo, ID
		FROM Film
    ) as F ON F.ID = FM.film
	GROUP BY FM.Film
	LIMIT 10;

END $$

DELIMITER ;