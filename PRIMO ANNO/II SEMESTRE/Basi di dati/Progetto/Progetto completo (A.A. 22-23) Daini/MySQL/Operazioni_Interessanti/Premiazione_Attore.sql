DROP PROCEDURE IF EXISTS Inserisci_Premiazione_Attore_Procedura;
DELIMITER $$
CREATE PROCEDURE Inserisci_Premiazione_Attore_Procedura(IN Nome VARCHAR(200),IN Istituzione VARCHAR(200),IN Anno_Premiazione_Attore INT,IN Id_Artista INT)
BEGIN
        DECLARE Premio_Esistente TINYINT DEFAULT 0;
        DECLARE Attore_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Premio_Attore PA
                        WHERE   PA.Nome = Nome AND PA.Istituzione = Istituzione
                    )
        THEN SET Premio_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Attore A
                        WHERE   A.Id_Artista = Id_Artista
                    )
        THEN SET Attore_Esistente = 1;
        END IF;

        IF (Premio_Esistente = 1 AND Attore_Esistente = 1) THEN

            INSERT INTO Premiazione_Attore VALUES(Nome,Istituzione,Id_Artista,Anno_Premiazione_Attore);

        ELSEIF(Premio_Esistente = 0 AND Attore_Esistente = 1) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Premio per il attore inesistente: Nome o Istituzione errati!';

        ELSEIF(Premio_Esistente = 1 AND Attore_Esistente = 0) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Attore inesistente: Id_Artista errato!';

        END IF;

END $$

DELIMITER ;