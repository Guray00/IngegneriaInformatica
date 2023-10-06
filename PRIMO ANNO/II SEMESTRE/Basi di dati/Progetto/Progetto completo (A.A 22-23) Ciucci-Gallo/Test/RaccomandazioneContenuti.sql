USE `FilmSphere`;

SELECT `Titolo`, `ID`, RatingFilm(`ID`)
FROM `Film` 
LIMIT 10;

SELECT `Titolo`, `ID`, RatingUtente(ID, 'richie-314')
FROM Film
ORDER BY RatingUtente(ID, 'richie-314') DESC;

CALL RaccomandazioneContenuti('richie-314', 5);
