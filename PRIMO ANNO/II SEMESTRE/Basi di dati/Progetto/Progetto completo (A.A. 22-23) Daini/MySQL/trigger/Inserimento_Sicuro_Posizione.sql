DROP TRIGGER IF EXISTS Trigger_Inserimento_Sicuro;

DELIMITER $$

CREATE TRIGGER Trigger_Inserimento_Sicuro BEFORE INSERT ON Posizione
FOR EACH ROW
BEGIN

    DECLARE Quanti_Stati_Diversi INT DEFAULT 0;

    SET Quanti_Stati_Diversi =  (
                                    SELECT  COUNT (DISTINCT Stato)
                                    FROM    Posizione P
                                );
    IF Quanti_Stati_Diversi = 150
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Troppi stati, non è possibile inserirne altri';

    END IF;

END $$

DELIMITER ;