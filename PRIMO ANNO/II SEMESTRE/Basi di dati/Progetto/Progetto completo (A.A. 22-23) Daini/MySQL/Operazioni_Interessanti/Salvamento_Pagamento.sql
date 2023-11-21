DROP PROCEDURE IF EXISTS Inserisci_Pagamento_Abbonamento;

DELIMITER $$

CREATE PROCEDURE Inserisci_Pagamento_Abbonamento (IN Id_Cliente INT ,IN Numero_Fattura VARCHAR(45) ,IN Durata_Abbonamento INT ,IN Tipo VARCHAR(100) ,IN Caratterizzazione TEXT,IN Eta TINYINT, IN Ore_Massime INT ,IN Data_Pagamento DATE ,IN Scadenza DATE,IN CVV CHAR(3), IN PAN VARCHAR(19) ,IN Nome_Titolare VARCHAR(100) ,IN Cognome_Titolare VARCHAR(100) ,IN Circuito_Carta VARCHAR(100))
BEGIN

    DECLARE Esistenza_Cliente TINYINT DEFAULT 0;
    DECLARE Esistenza_Carta TINYINT DEFAULT 0;
    DECLARE Stato TINYINT DEFAULT 0;
    DECLARE Importo DOUBLE DEFAULT 0;

     IF EXISTS   (
                    SELECT  1
                    FROM    Utente U
                    WHERE   U.Id_Cliente = Id_Cliente
                )
    THEN SET Esistenza_Cliente = 1;

    END IF;

    IF EXISTS   (
                    SELECT  1
                    FROM    Carta C
                    WHERE   C.CVV = CVV AND C.PAN = PAN
                )
    THEN SET Esistenza_Carta = 1;

    END IF;

    -- creare una procedura che mi consenta di ricavare, dato Durata_Abbonamento e Tipo, informazioni su Importo e Stato

    IF Esistenza_Cliente = 1 THEN

    -- inserire la carta, se non ci sono informazioni coerenti

        IF Esistenza_Cliente = 0 THEN
        
            INSERT INTO Carta VALUES (CVV,PAN,Nome_Titolare,Cognome_Titolare,Circuito_Carta);
        
        END IF;

        CALL Trova_Stato_Importo(Durata_Abbonamento,Tipo,Stato,Importo);

    -- inserire la fattura

    INSERT INTO Fattura VALUES (Numero_Fattura,Importo,Scadenza,Data_Pagamento,CVV,PAN);

    -- inserire Abbonamento

    INSERT INTO Abbonamento VALUES (Durata_Abbonamento,Tipo,Caratterizzazione,Stato,Eta,Ore_Massime,Numero_Fattura,Id_Cliente);

    ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente inesistente: Id_Cliente Errato!';

    END IF;

END $$

DELIMITER ;