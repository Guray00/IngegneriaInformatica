USE `FilmSphere`;

CALL VinciteDiUnFilm(1);

CALL GeneriDiUnFilm(1, 'richie-314');

CALL FileMiglioreQualita(1, 'richie-314');

CALL FilmEsclusiAbbonamento('Pro', @n); SELECT @n;

CALL FilmDisponibiliInLinguaSpecifica('Italiano');

CALL FilmPiuVistiRecentemente(10);

CALL CambioAbbonamento('aaliyah6s2w', 'Pro');

SELECT * FROM FilmMiglioriRecensioni;