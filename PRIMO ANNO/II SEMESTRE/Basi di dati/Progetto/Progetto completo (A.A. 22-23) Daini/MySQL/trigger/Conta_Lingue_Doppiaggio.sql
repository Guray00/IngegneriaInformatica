-- Active: 1647365195286@@127.0.0.1@3306@mydb
DROP TRIGGER IF EXISTS Trigger_Conta_Lingue_Doppiate;
DELIMITER $$
CREATE TRIGGER Trigger_Conta_Lingue_Doppiate AFTER INSERT ON Doppiaggio_Film
FOR EACH ROW
BEGIN

    DECLARE Presente_Lingua TINYINT DEFAULT 0;

    IF EXISTS   (
                    SELECT  1
                    FROM    Disposizione D
                    WHERE   D.Lingua = NEW.Lingua AND D.Id_Film = NEW.Id_Film
                ) 
	THEN
    
		SET Presente_Lingua = 1;       
	
    END IF;
    -- si aggiorna se la lingua per quel film è disponibile anche in disposizione

    IF Presente_Lingua = 1 THEN

    UPDATE  Film F
    SET     F.Quante_Lingue = F.Quante_Lingue + 1
    WHERE   F.Id_Film = NEW.Id_Film;

    END IF;

END $$

DELIMITER ;

