DROP PROCEDURE IF EXISTS Inserisci_Premiazione_Regista_Procedura;
DELIMITER $$
CREATE PROCEDURE Inserisci_Premiazione_Regista_Procedura(IN Nome VARCHAR(200),IN Istituzione VARCHAR(200),IN Anno_Premiazione_Regista INT,IN Id_Artista INT)
BEGIN
        DECLARE Premio_Esistente TINYINT DEFAULT 0;
        DECLARE Regista_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Premio_Regista PR
                        WHERE   PR.Nome = Nome AND PR.Istituzione = Istituzione
                    )
        THEN SET Premio_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Regista R
                        WHERE   R.Id_Artista = Id_Artista
                    )
        THEN SET Regista_Esistente = 1;
        END IF;

        IF (Premio_Esistente = 1 AND Regista_Esistente = 1) THEN

            INSERT INTO Premiazione_Regista VALUES(Nome,Istituzione,Anno_Premiazione_Regista,Id_Artista);

        ELSEIF(Premio_Esistente = 0 AND Regista_Esistente = 1) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Premio per il regista inesistente: Nome o Istituzione errati!';

        ELSEIF(Premio_Esistente = 1 AND Regista_Esistente = 0) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Regista inesistente: Id_Artista errato!';

        END IF;

END $$