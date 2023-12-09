DROP TRIGGER IF EXISTS Trigger_Quanti_Premi_Film;
DELIMITER $$
CREATE TRIGGER Trigger_Quanti_Premi_Film AFTER INSERT ON Premiazione_Film
FOR EACH ROW
BEGIN

    UPDATE Film F
    SET F.Quanti_Premi = Quanti_Premi + 1
    WHERE F.Id_Film = NEW.Id_Film;

END $$
DELIMITER ;