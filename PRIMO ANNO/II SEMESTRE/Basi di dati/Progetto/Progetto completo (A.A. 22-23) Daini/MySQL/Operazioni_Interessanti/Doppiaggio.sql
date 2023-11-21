DROP PROCEDURE IF EXISTS Inserisci_Doppiaggio;
DELIMITER $$
CREATE PROCEDURE Inserisci_Doppiaggio(IN Lingua VARCHAR(100),IN Id_Film INT)
BEGIN

        DECLARE Lingua_Esistente TINYINT DEFAULT 0;
        DECLARE Film_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Doppiaggio_FIlm DF
                        WHERE   DF.Id_Film = Id_Film
                    )
        THEN SET Lingua_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Film F
                        WHERE   F.Id_Film = Id_Film
                    )
        THEN SET Film_Esistente = 1;

        END IF;

        IF (Lingua_Esistente = 1 AND Film_Esistente = 1) THEN

            INSERT INTO Doppiaggio_Film VALUES (Id_Film,Lingua);

        ELSEIF (Lingua_Esistente = 0 AND Film_Esistente = 1) THEN 

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lingua Inesistente: Lingua errata!';   

        ELSEIF (Lingua_Esistente = 1 AND Film_Esistente = 0) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Film Inesistente: Id_Film errato!';   

        END IF;

END $$
DELIMITER ;