DROP PROCEDURE IF EXISTS Ascolto_Suggerimento;
DELIMITER $$

CREATE PROCEDURE Ascolto_Suggerimento   (
                                            IN Id_Utente INT,
                                            IN Id_Film INT,
                                            IN Nome_Film VARCHAR(100),
                                            IN Anno_Produzione INT,
                                            IN Durata INT,
                                            IN Paese_Produzione VARCHAR(100),
                                            IN Genere VARCHAR(100),
                                            IN Descrizione TEXT
                                        )
BEGIN

DECLARE Utente_Presente TINYINT DEFAULT 0; 
DECLARE Film_Esistente TINYINT DEFAULT 0;
DECLARE Abbonamento_Cliente VARCHAR(40) DEFAULT '';
DECLARE Punteggio DOUBLE DEFAULT 0;

-- grazie al LOG posso ricavare informazioni sull'utente
IF EXISTS   (
                SELECT  1
                FROM    Log_Utenti LU
                WHERE   LU.Id = Id_Utente
            )
THEN SET Utente_Presente = 1;

END IF;

IF EXISTS   (
                SELECT  1
                FROM    Film F
                WHERE   F.Id_Film = Id_Film
            )
THEN SET Film_Esistente = 1;

END IF;

-- se l'utente non è presente, il suo suggerimento non viene colto e viene lanciato un messaggio d'errore
IF Utente_Presente = 0 THEN

    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Utente non presente fra la lista di abbonati di tipo Incredible o King';

END IF;

-- se il film già esiste, si da un messaggio di errore:
IF Film_Esistente = 1 THEN

    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Film già esistente nel catalogo!';

END IF;


SET Abbonamento_Cliente =   (
                                SELECT  LU.Tipo_Abbonamento
                                FROM    Log_Utenti LU
                                WHERE   LU.Id = Id_Utente
                            );

IF(Abbonamento_Cliente = 'Incredible') THEN
    
    SET Punteggio = 10;

ELSE 

    SET Punteggio = 70;

END IF;

	 IF NOT EXISTS	(	SELECT table_name 
						FROM information_schema.tables 
						WHERE table_schema = 'mydb' AND table_name = 'lista_id_genere'
					) 
	THEN
			CREATE TABLE Suggerimento_Utenti(
                                                    Id_Utente INT NOT NULL,
                                                    Id_Film INT NOT NULL,
                                                    Nome_Film VARCHAR(100) NOT NULL,
                                                    Anno_Produzione INT NOT NULL,
                                                    Durata INT NOT NULL,
                                                    Paese_Produzione VARCHAR(100) NOT NULL,
                                                    Genere VARCHAR(100) NOT NULL,
                                                    Descrizione TEXT NOT NULL,
                                                    Punteggio DOUBLE NOT NULL,
                                                    PRIMARY KEY(Id_Utente,Id_Film)
                                                );
	END IF;

INSERT INTO Suggerimento_Utenti VALUES (Id_Utente,Id_Film,Nome_Film,Anno_Produzione,Durata,Paese_Produzione,Genere,Descrizione,Punteggio);

END $$

DELIMITER ;