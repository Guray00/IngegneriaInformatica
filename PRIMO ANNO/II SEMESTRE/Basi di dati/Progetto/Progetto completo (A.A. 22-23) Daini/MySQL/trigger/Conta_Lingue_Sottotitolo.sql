DROP TRIGGER IF EXISTS Trigger_Conta_Lingue;
DELIMITER $$
CREATE TRIGGER Trigger_Conta_Lingue AFTER INSERT ON Disposizione
FOR EACH ROW
BEGIN

    DECLARE Doppiaggio_Esistente TINYINT DEFAULT 0;

    IF EXISTS   ( 
                    SELECT  1
                    FROM    Doppiaggio_Film DF
                    WHERE   DF.Lingua = NEW.Lingua AND DF.Id_Film = NEW.Id_Film         
                )
    THEN

        SET Doppiaggio_Esistente = 1;     

    END IF;
    -- si aggiorna se la lingua per quel film è disponibile anche in disposizione

    IF Doppiaggio_Esistente = 1 THEN

        UPDATE  Film F
        SET     F.Quante_Lingue = F.Quante_Lingue + 1
        WHERE   F.Id_Film = NEW.Id_Film; 

    END IF;

END $$

DELIMITER ;