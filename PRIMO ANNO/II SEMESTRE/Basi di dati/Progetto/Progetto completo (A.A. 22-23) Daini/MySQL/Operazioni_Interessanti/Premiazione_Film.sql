DROP PROCEDURE IF EXISTS Inserisci_Premiazione_Film_Procedura;
DELIMITER $$
CREATE PROCEDURE Inserisci_Premiazione_Film_Procedura(IN Nome VARCHAR(200),IN Istituzione VARCHAR(200),IN Anno_Premiazione_Film INT,IN Id_Film INT)
BEGIN
        DECLARE Premio_Esistente TINYINT DEFAULT 0;
        DECLARE Film_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Premio_Film PF
                        WHERE   PF.Nome = Nome AND PF.Istituzione = Istituzione
                    )
        THEN SET Premio_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Film F
                        WHERE   F.Id_Film = Id_Film
                    )
        THEN SET Film_Esistente = 1;
        END IF;

        IF (Premio_Esistente = 1 AND Film_Esistente = 1) THEN

            INSERT INTO Premiazione_Film VALUES(Id_Film,Nome,Istituzione,Anno_Premiazione_Film);

        ELSEIF(Premio_Esistente = 0 AND Film_Esistente = 1) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Premio per il film inesistente: Nome o Istituzione errati!';

        ELSEIF(Premio_Esistente = 1 AND Film_Esistente = 0) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Film inesistente: Id_Artista errato!';

        END IF;

END $$