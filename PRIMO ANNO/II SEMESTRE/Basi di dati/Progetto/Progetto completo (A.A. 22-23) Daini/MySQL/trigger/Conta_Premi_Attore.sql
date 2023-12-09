DROP TRIGGER IF EXISTS Trigger_Quanti_Premi_Attore;

DELIMITER $$

CREATE TRIGGER Trigger_Quanti_Premi_Attore AFTER INSERT ON Premiazione_Regista
FOR EACH ROW
BEGIN


    UPDATE Attore A
    SET A.Quanti_Premi = A.Quanti_Premi + 1 
    WHERE A.Id_Artista = NEW.Id_Artista;

END $$

DELIMITER $$