DROP PROCEDURE IF EXISTS Trova_Stato_Importo;
DELIMITER $$
CREATE PROCEDURE Trova_Stato_Importo(IN Durata_Abbonamento INT,IN Tipo_Abbonamento VARCHAR(100),OUT Stato TINYINT,OUT Importo DOUBLE)
BEGIN

        DECLARE Prezzo_Base DOUBLE DEFAULT 0;

        IF(Durata_Abbonamento <> 1 AND Durata_Abbonamento % 3 <> 0) THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Durata abbonamento errato: possibile 1 mese o un numero di mesi multiplo di 3!';

        END IF;

        IF Tipo_Abbonamento = 'Basic' THEN
            SET Stato = 1;
            SET Prezzo_Base = 3;
        ELSEIF Tipo_Abbonamento = 'Premium' THEN
            SET Stato = 1;
            SET Prezzo_Base = 5;
        ELSEIF Tipo_Abbonamento = 'Special' THEN
            SET Stato = 0;
            SET Prezzo_Base = 8;
        ELSEIF Tipo_Abbonamento = 'Incredible' THEN
            SET Stato = 0;
            SET Prezzo_Base = 10;
        ELSEIF Tipo_Abbonamento = 'King' THEN
            SET Stato = 0;
            SET Prezzo_Base = 12;

        ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abbonamento di tipo Inesistente!';
        END IF;

        SET Importo = ROUND(Prezzo_Base + Prezzo_Base * (Durata_Abbonamento * Durata_Abbonamento/100),2); 

END $$

DELIMITER ;