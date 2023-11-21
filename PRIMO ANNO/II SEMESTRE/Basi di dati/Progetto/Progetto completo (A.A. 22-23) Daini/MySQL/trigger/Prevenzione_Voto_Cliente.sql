-- Active: 1647365195286@@127.0.0.1@3306@mydb
DROP TRIGGER IF EXISTS Trigger_Voto_Utente;

DELIMITER $$

CREATE TRIGGER Trigger_Voto_Utente BEFORE INSERT ON Voto_Utente
FOR EACH ROW
BEGIN

DECLARE Film_Visualizzato TINYINT DEFAULT 0;

IF EXISTS   (
                SELECT  1
                FROM    Visualizzazioni_Film VF
                WHERE   VF.Id_Cliente = NEW.Id_Cliente AND VF.Id_Film = NEW.Id_Film
            )  
THEN SET Film_Visualizzato = 1;

END IF;

IF Film_Visualizzato = 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Recensione su un film mai visualizzato.';

END IF;

END $$

DELIMITER ;