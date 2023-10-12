USE `FilmSphere`;

    DROP PROCEDURE IF EXISTS `CambioAbbonamento`;
DELIMITER //
CREATE PROCEDURE `CambioAbbonamento`(IN codice_utente VARCHAR(100), IN tipo_abbonamento VARCHAR(50))
BEGIN

    DECLARE fatture_non_pagate INT;
    SET fatture_non_pagate := (
        SELECT
            COUNT(*)
        FROM Fattura
        WHERE Utente = codice_utente
        AND CartaDiCredito IS NULL
    );

    IF fatture_non_pagate > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Utente non in pari coi pagamenti';

    ELSE

        UPDATE Utente
        SET Abbonamento = tipo_abbonamento, DataInizioAbbonamento = CURRENT_DATE()
        WHERE Codice = codice_utente;

    END IF;

END
//
DELIMITER ;