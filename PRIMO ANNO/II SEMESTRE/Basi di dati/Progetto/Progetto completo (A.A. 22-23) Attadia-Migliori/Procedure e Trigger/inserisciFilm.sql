USE filmsphere;

DROP PROCEDURE IF EXISTS inserisciFilm;
DELIMITER $$
CREATE PROCEDURE inserisciFilm(
	IN Titolo_ varchar(100),
	IN Descrizione_ varchar(350),
	IN Anno_di_produzione_ INT, 
    IN Durata_ INT,
	IN Genere_ varchar(45),
    IN PaeseDiProduzione_ varchar(45)
)

BEGIN
-- check paese
	IF NOT EXISTS (SELECT 1 FROM Paese P WHERE PaeseDiProduzione_ = P.Nome) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Paese inesistente nel Database.';
	END IF;
    
-- check film
	IF EXISTS (SELECT 1 FROM Film F WHERE Titolo_ = F.Titolo) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Film già presente.';
	END IF;
    
-- check genere
    IF NOT EXISTS (SELECT 1 FROM Genere G WHERE Genere_ = G.Nome) THEN
		INSERT INTO Genere
        VALUES(Genere);
	END IF;


	INSERT INTO Film (
		Titolo,
		Descrizione,
		AnnoDiProduzione,
        Durata,
		Genere,
        PaeseProduzione
    ) VALUES (
		Titolo_,
		Descrizione_,
		Anno_di_produzione_,
        Durata_,
		Genere_,
        PaeseDiProduzione_
    );
    
    INSERT INTO Appartenenza (Film, Genere)
    VALUES(
		LAST_INSERT_ID(), Genere_
    );
    
END $$
DELIMITER ;

-- ###############################################

DROP PROCEDURE IF EXISTS inserisciFileAudio;
DELIMITER $$
CREATE PROCEDURE inserisciFileAudio(
	IN Nome_ varchar(45),
	IN Dimensione_ INT,
    IN Film_ INT,
    IN Formato_ varchar(45), -- se formato è null, allora è un file di sottotitolaggio
    IN VersioneFormato_ int, -- se formato è null, mettere versione null
    IN Lingua_ varchar(45)  -- Null <-> File video ; lingua audio <-> File audio; lingua sottotitolaggio <-> Formato_ è NULL;
) 

BEGIN
-- check film
	IF EXISTS (SELECT 1 FROM Film F WHERE F.ID = Film_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'File già esistente.';
	END IF;
    
-- check dimensione
	IF Dimensione_ < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Dimensione non valida.';
	END IF;
    
-- check Formato
	IF NOT EXISTS (SELECT 1 FROM FormatiAudio F WHERE F.Codec = Formato_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Codec non presente o inesistente.';
	END IF;
    
-- check Versione
	IF NOT EXISTS (SELECT 1 FROM FormatiAudio F WHERE F.Versione = VersioneFormato_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Versione non presente.';
	END IF;
    
-- check lingua
	IF NOT EXISTS (SELECT 1 FROM Lingue L WHERE L.Nome = Lingua_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Lingua inesistente o non presente nel database.';
	END IF;
    
    INSERT INTO FileAudio (Nome, Dimensione, Lingua, FormatoAudio, VersioneAudio, Film)
    VALUES (Nome_, Dimensione_, Lingua_, Formato_, VersioneFormato_, Film_);

 
END $$
DELIMITER ;

-- ###############################################

DROP PROCEDURE IF EXISTS inserisciFileVideo;
DELIMITER $$
CREATE PROCEDURE inserisciFileVideo(
	IN Nome_ varchar(45),
	IN Dimensione_ INT,
    IN Film_ INT,
    IN Formato_ varchar(45), 
    IN VersioneFormato_ int, 
    IN Lingua_ varchar(45)
) 

BEGIN    
-- check film
	IF EXISTS (SELECT 1 FROM Film F WHERE F.ID = Film_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'File già esistente.';
	END IF;

-- check dimensione
	IF Dimensione_ < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Dimensione non valida.';
	END IF;
    
-- check Formato
	IF NOT EXISTS (SELECT 1 FROM FormatiVideo F WHERE F.Codec = Formato_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Codec non presente o inesistente.';
	END IF;
    
-- check Versione
	IF NOT EXISTS (SELECT 1 FROM FormatiVideo F WHERE F.Versione = VersioneFormato_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Versione non presente.';
	END IF;
    
    INSERT INTO FileVideo (Nome, Dimensione, FormatoVideo, VersioneVideo, Film)
    VALUES (Nome_, Dimensione_, Formato_, VersioneFormato_, Film_);

 
END $$
DELIMITER ;

-- #####################################################

DROP PROCEDURE IF EXISTS inserisciFileSottotitoli;
DELIMITER $$
CREATE PROCEDURE inserisciFileSottotitoli(
	IN Nome_ varchar(45),
	IN Dimensione_ INT,
    IN Film_ INT,
    IN Lingua_ varchar(45)
) 

BEGIN
-- check film
	IF EXISTS (SELECT 1 FROM Film F WHERE F.ID = Film_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'File già esistente.';
	END IF;
    
-- check dimensione
	IF Dimensione_ < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Dimensione non valida. Inserire versione valida.';
	END IF;
        
-- check lingua
	IF NOT EXISTS (SELECT 1 FROM Lingua L WHERE Lingua_ = L.Nome) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Lingua inesistente o non presente nel database.';
	END IF;

	INSERT INTO FileSottotitoli (Nome, Dimensione, Lingua, Film)
    VALUES (Nome_, Dimensione_, Lingua_, Film_);
 
END $$
DELIMITER ;

-- ###############################################

DROP PROCEDURE IF EXISTS inserisciPersona;
DELIMITER $$
CREATE PROCEDURE inserisciPersona(
	IN Nome_ varchar(45),
	IN Cognome_ varchar(45),
    IN Nazionalità_ varchar(45)  -- o meglio, il Paese di provenienza
)

BEGIN

    IF NOT EXISTS (SELECT 1 FROM Paese WHERE P.Nome = Nazionalità_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Paese inesistente.';
        END IF;
        
	INSERT INTO Persona (Nome, Cognome, Nazionalità)
    VALUES (Nome_, Cognome_, Nazionalità_);

END $$
DELIMITER ;

-- #############################################
DROP PROCEDURE IF EXISTS inserisciInterpretazione;
DELIMITER $$
CREATE PROCEDURE inserisciInterpretazione(
	IN Attore_ INT,
	IN Film_ INT
)

BEGIN
	IF NOT EXISTS (SELECT 1 FROM Persona P WHERE P.ID = Attore_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Campo Attore non valido.';
        END IF;
	
    IF NOT EXISTS (SELECT 1 FROM Film F WHERE F.ID = Film_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Campo Film non valido.';
        END IF;
        
	INSERT INTO Interpretazione (Attore, Film)
    VALUES (Attore_, Film_);

END $$
DELIMITER ;

-- #############################################

DROP PROCEDURE IF EXISTS inserisciRegia;
DELIMITER $$
CREATE PROCEDURE inserisciRegia(
	IN Regista_ INT,
	IN Film_ INT
)

BEGIN
	IF NOT EXISTS (SELECT 1 FROM Persona P WHERE P.ID = Regista_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Campo Regista non valido.';
        END IF;
	
    IF NOT EXISTS (SELECT 1 FROM Film F WHERE F.ID = Film_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Campo Film non valido.';
        END IF;
        
	INSERT INTO Regia (Regista, Film)
    VALUES (Regista_, Film_);

END $$
DELIMITER ;

-- ################################################

DROP PROCEDURE IF EXISTS appartenenzaGenere;
DELIMITER $$
CREATE PROCEDURE appartenenzaGenere(
	IN Genere_ varchar(45),
	IN Film_ INT
)

BEGIN
    IF NOT EXISTS (SELECT 1 FROM Film F WHERE F.ID = Film_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Campo Film non valido.';
        END IF;
        
	IF NOT EXISTS (SELECT 1 FROM Generi G WHERE G.Nome = Genere_) THEN
		INSERT INTO Genere
        VALUES(Genere);
	END IF;
        
	INSERT INTO Appartenenza (Genere, Film)
    VALUES (Genere_, Film_);

END $$
DELIMITER ;

-- ################################################
DROP PROCEDURE IF EXISTS inserisciPremio;
DELIMITER $$
CREATE PROCEDURE inserisciPremio(
	IN NomeCompleto_ varchar(45),
    IN Anno_ INT,
    IN Persona_ INT,
	IN Film_ INT
)

BEGIN
    IF NOT EXISTS (SELECT 1 FROM Film F WHERE F.ID = Film_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Campo Film non valido.';
        END IF;
        
	IF NOT EXISTS (SELECT 1 FROM Persone P WHERE P.ID = Attore_) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Campo Persona non valido.';
        END IF;
        
	INSERT INTO Premio (Nome, Edizione, Persona, Film)
    VALUES (NomeCompleto_, Anno_, Film_, Persona_, Film_);

END $$
DELIMITER ;