DROP FUNCTION IF EXISTS Calcola_Punteggio_Film;
DELIMITER $$
CREATE FUNCTION Calcola_Punteggio_Film(Nome VARCHAR(200),Peso DOUBLE)
RETURNS DOUBLE DETERMINISTIC
BEGIN

    DECLARE Peggiore_Trovato INT DEFAULT 0;
    DECLARE Peggior_Trovato INT DEFAULT 0;

    SET Peggior_Trovato = INSTR('Peggior',Nome);
    SET Peggiore_Trovato = INSTR('Peggiore',Nome);

    IF(Peggior_Trovato = 0 AND Peggiore_Trovato = 0) THEN

        RETURN Peso * 13.301;

    ELSE
        RETURN Peso * -13.301;

    END IF;

END $$

DELIMITER ;
