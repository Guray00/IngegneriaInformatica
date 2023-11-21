DROP TRIGGER IF EXISTS Trigger_Quanti_Premi_Regista;

DELIMITER $$

CREATE TRIGGER Trigger_Quanti_Premi_Regista AFTER INSERT ON Premiazione_Attore
FOR EACH ROW
BEGIN

    UPDATE Regista R
    SET R.Quanti_Premi = R.Quanti_Premi + 1
    WHERE R.Id_Artista = NEW.Id_Artista;

END $$

DELIMITER ;