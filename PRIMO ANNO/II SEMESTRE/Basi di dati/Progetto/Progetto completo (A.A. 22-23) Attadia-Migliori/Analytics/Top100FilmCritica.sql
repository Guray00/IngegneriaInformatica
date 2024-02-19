USE filmsphere;

DROP PROCEDURE IF EXISTS Top100FilmCritica;
DELIMITER $$
CREATE PROCEDURE Top100FilmCritica()
BEGIN
    SELECT F.Titolo, F.PunteggioCritica, Dense_RANK() OVER(ORDER BY F.PunteggioCritica DESC, R.NumeroRecensioni DESC) AS Posizione
    FROM Film F
    LEFT OUTER JOIN (
        SELECT Film, COUNT(*) AS NumeroRecensioni
        FROM Recensioni R
        INNER JOIN Utenti U ON R.Utente = U.ID
        WHERE U.Verificato = true
        GROUP BY Film
    ) AS R ON F.ID = R.Film
    ORDER BY Posizione
    LIMIT 100;
END $$
