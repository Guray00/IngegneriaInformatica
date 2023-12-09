DROP PROCEDURE IF EXISTS Inserisci_Nuova_Connessione;
DELIMITER $$
CREATE PROCEDURE Inserisci_Nuova_Connessione (IN Id_Cliente INT,IN Tipo VARCHAR(80),IN Longitudine DOUBLE,IN Latitudine DOUBLE,IN IP CHAR(21),IN Inizio_Connesione TIMESTAMP,IN Fine_Connessione TIMESTAMP)
BEGIN

        DECLARE Utente_Esistente TINYINT DEFAULT 0;
        DECLARE Posizione_Esistente TINYINT DEFAULT 0;

        IF EXISTS   (
                        SELECT  1
                        FROM    Utente U
                        WHERE   U.Id_Cliente = Id_Cliente
                    )
        THEN SET Utente_Esistente = 1;

        END IF;

        IF EXISTS   (
                        SELECT  1
                        FROM    Posizione P
                        WHERE   P.Latitudine = Latitudine AND P.Longitudine = Longitudine
                    )
        THEN SET Posizione_Esistente = 1;

        END IF;

        IF (Utente_Esistente = 1 AND Posizione_Esistente = 1) THEN

            INSERT INTO Dispositivo VALUES(IP, Tipo, Longitudine, Latitudine, Inizio_Connesione, Fine_Connessione);

            INSERT INTO Connessione VALUES(IP,Id_Cliente,Inizio_Connesione,Fine_Connessione);

        ELSEIF (Utente_Esistente = 0 AND Posizione_Esistente = 1) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente inesistente: Id_Cliente errato!';

        ELSEIF (Utente_Esistente = 1 AND Posizione_Esistente = 0) THEN 

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Posizione inesistente: Longitudine o Latitudine errati!';

        END IF;

END $$

DELIMITER ;