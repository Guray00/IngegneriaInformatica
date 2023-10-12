USE `FilmSphere`;

CREATE OR REPLACE VIEW `FilmMiglioriRecensioni` AS
    SELECT f.`Titolo`, f.`ID`, f.`MediaRecensioni`
    FROM `Film` f
    WHERE f.`MediaRecensioni` > (
        SELECT AVG(f2.`MediaRecensioni`)
        FROM `Film` f2)
    ORDER BY f.`MediaRecensioni` DESC
    LIMIT 20;
    
-- SELECT * FROM `FilmMiglioriRecensioni`;