DROP FUNCTION IF EXISTS Calcola_Punteggio_Regista;
DELIMITER $$
CREATE FUNCTION Calcola_Punteggio_Regista(Nome VARCHAR(200),Peso DOUBLE)
RETURNS DOUBLE DETERMINISTIC
BEGIN

    DECLARE Peggiore_Trovato INT DEFAULT 0;
    DECLARE Peggior_Trovato INT DEFAULT 0;
    
    SET Peggior_Trovato = INSTR(Nome,'Peggior');
    SET Peggiore_Trovato = INSTR(Nome,'Peggiore');

   IF(Peggior_Trovato = 0 AND Peggiore_Trovato = 0) THEN

        RETURN Peso * 13.301;

    ELSE
        RETURN Peso * -13.301;

    END IF;

END $$

DELIMITER ;