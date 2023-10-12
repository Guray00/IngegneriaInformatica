-- ----------------------------
-- AREA STREAMING
-- ----------------------------

CREATE TABLE IF NOT EXISTS `Server` (
    -- Chiave
    `ID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    
    `CaricoAttuale` INT NOT NULL DEFAULT 0,

    `MaxConnessioni` INT NOT NULL DEFAULT 10000,
    
    -- Lunghezza massima della banda
    `LunghezzaBanda` FLOAT NOT NULL,
    
    -- Maxinum Transfer Unit
    `MTU` FLOAT NOT NULL,

    -- Posizione del Server
    `Posizione` POINT,

    -- Vincoli di dominio
    CHECK (`MaxConnessioni` > 0),
    CHECK (`LunghezzaBanda` > 0.0),
    CHECK (`MTU` > 0.0),
    CHECK (ST_X(`Posizione`) BETWEEN -180.00 AND 180.00), -- Contollo longitudine
    CHECK (ST_Y(`Posizione`) BETWEEN -90.00 AND 90.00) -- Controllo latitudine
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `PoP` (
    -- Associazione tra File e Server
    `File` INT NOT NULL,
    `Server` INT NOT NULL,
    
    -- Chiavi
    PRIMARY KEY (`File`, `Server`),
    FOREIGN KEY (`File`) REFERENCES `File`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Server`) REFERENCES `Server`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS `DistanzaPrecalcolata` (
    -- Associazione tra Paese e Server
    `Paese` CHAR(2) NOT NULL,
    `Server` INT NOT NULL,

    `ValoreDistanza` FLOAT DEFAULT 0.0,

    -- Chiavi
    PRIMARY KEY (`Paese`, `Server`),
    FOREIGN KEY (`Paese`) REFERENCES `Paese`(`Codice`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Server`) REFERENCES `Server`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE,

    -- Vincoli di dominio: controllo che una distanza sia non negativa e minore di un giro del mondo
    CHECK (`ValoreDistanza` BETWEEN 0.0 AND 40075.0)
) Engine=InnoDB;

DROP PROCEDURE IF EXISTS `CalcolaDistanzaPaese`;
DROP PROCEDURE IF EXISTS `CalcolaDistanzaServer`;

DROP TRIGGER IF EXISTS `InserimentoPaese`;
DROP TRIGGER IF EXISTS `ModificaPaese`;
DROP TRIGGER IF EXISTS `InserimentoServer`;
DROP TRIGGER IF EXISTS `ModificaServer`;
DELIMITER $$

CREATE PROCEDURE `CalcolaDistanzaPaese` (IN CodPaese CHAR(2))
BEGIN
    REPLACE INTO `DistanzaPrecalcolata` 
    (`Paese`, `Server`, `ValoreDistanza`)
        SELECT 
            `Paese`.`Codice`, `Server`.`ID`, 
            IF (
                `Paese`.`Codice` <> '??', 
                ST_DISTANCE_SPHERE(`Paese`.`Posizione`, `Server`.`Posizione`) / 1000,
                0)      
        FROM `Paese` CROSS JOIN `Server`
        WHERE `Paese`.`Codice` = CodPaese;
END ; $$

CREATE PROCEDURE `CalcolaDistanzaServer` (IN IDServer INT)
BEGIN
    REPLACE INTO `DistanzaPrecalcolata` (`Paese`, `Server`, `ValoreDistanza`)
        SELECT 
            `Paese`.`Codice`, `Server`.`ID`,
            IF (
                `Paese`.`Codice` <> '??', 
                ST_DISTANCE_SPHERE(`Paese`.`Posizione`, `Server`.`Posizione`) / 1000,
                0)            
        FROM `Server` CROSS JOIN `Paese`
        WHERE `Server`.`ID` = IDServer;
END ; $$

CREATE TRIGGER `InserimentoPaese`
AFTER INSERT ON `Paese`
FOR EACH ROW
BEGIN
    CALL CalcolaDistanzaPaese(NEW.`Codice`);
END ; $$

CREATE TRIGGER `ModificaPaese`
AFTER UPDATE ON `Paese`
FOR EACH ROW
BEGIN
    IF NEW.Posizione <> OLD.Posizione THEN
        CALL CalcolaDistanzaPaese(NEW.`Codice`);
    END IF;
END ; $$

CREATE TRIGGER `InserimentoServer`
AFTER INSERT ON `Server`
FOR EACH ROW
BEGIN
    CALL CalcolaDistanzaServer(NEW.`ID`);
END ; $$

CREATE TRIGGER `ModificaServer`
AFTER UPDATE ON `Server`
FOR EACH ROW
BEGIN
    IF NEW.Posizione <> OLD.Posizione THEN
        CALL CalcolaDistanzaServer(NEW.`ID`);
    END IF;
END ; $$

DELIMITER ;

CREATE TABLE IF NOT EXISTS `Erogazione` (
    -- Uguali a Visualizzazione
    `IP` INT UNSIGNED NOT NULL,
    `InizioConnessione` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `Utente` VARCHAR(100) NOT NULL,
    `Edizione` INT NOT NULL,
    `Timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Quando il Server ha iniziato a essere usato
    `InizioErogazione` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Il Server in uso
    `Server` INT NOT NULL,

    -- Chiavi
    PRIMARY KEY (`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`),
    FOREIGN KEY (`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`)
        REFERENCES `Visualizzazione`(`IP`, `InizioConnessione`, `Timestamp`, `Edizione`, `Utente`) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`Server`) REFERENCES `Server`(`ID`) ON UPDATE CASCADE ON DELETE CASCADE,

    -- Vincoli di dominio
    CHECK (`Timestamp` BETWEEN `InizioConnessione` AND `InizioErogazione`)
) Engine=InnoDB;

DROP PROCEDURE IF EXISTS AggiungiErogazioneServer;
DROP PROCEDURE IF EXISTS RimuoviErogazioneServer;

DROP TRIGGER IF EXISTS ModificaErogazione;
DROP TRIGGER IF EXISTS AggiungiErogazione;
DROP TRIGGER IF EXISTS RimuoviErogazione;

DELIMITER $$ 

CREATE PROCEDURE AggiungiErogazioneServer(IN ServerID INT)
BEGIN
    UPDATE `Server`
    SET `Server`.`CaricoAttuale` = `Server`.`CaricoAttuale` + 1
    WHERE `Server`.`ID` = ServerID;
END ; $$

CREATE PROCEDURE RimuoviErogazioneServer(IN ServerID INT)
BEGIN
    UPDATE `Server`
    SET `Server`.`CaricoAttuale` = GREATEST(`Server`.`CaricoAttuale` - 1, 0)
    WHERE `Server`.`ID` = ServerID;
END ; $$

CREATE TRIGGER `ModificaErogazione`
BEFORE UPDATE ON Erogazione
FOR EACH ROW     
BEGIN
    -- SET NEW.InizioErogazione = CURRENT_TIMESTAMP;
    IF NEW.`Server` <> OLD.`Server` THEN
        CALL AggiungiErogazioneServer(NEW.`Server`);
        CALL RimuoviErogazioneServer(OLD.`Server`);
    END IF;
END ; $$

CREATE TRIGGER `AggiungiErogazione` 
AFTER INSERT ON Erogazione
FOR EACH ROW     
BEGIN
    CALL AggiungiErogazioneServer(NEW.`Server`);
END ; $$

CREATE TRIGGER `RimuoviErogazione`
AFTER DELETE ON Erogazione
FOR EACH ROW     
BEGIN
    CALL RimuoviErogazioneServer(OLD.`Server`);
END ; $$

DELIMITER ;

CREATE TABLE IF NOT EXISTS `IPRange` (

    -- Range di IP4
    `Inizio` INT UNSIGNED NOT NULL,
    `Fine` INT UNSIGNED NOT NULL,

    -- Inizio e fine validita'
    `DataInizio` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `DataFine` TIMESTAMP NULL DEFAULT NULL,

    -- Paese che possiede
    `Paese` CHAR(2) NOT NULL DEFAULT '??',
        
    -- Chiavi
    PRIMARY KEY (`Inizio`, `Fine`, `DataInizio`),
    FOREIGN KEY (`Paese`) REFERENCES `Paese`(`Codice`) ON UPDATE CASCADE ON DELETE CASCADE,

    -- Vincoli di dominio
    CHECK (`Fine` >= `Inizio`),
    CHECK (`DataFine` >= `DataInizio`)
) Engine=InnoDB;


-- Rimuovo funzioni, trigger e schedule prima di riaggiungerli

DROP FUNCTION IF EXISTS `IpRangeCollidono`;
DROP FUNCTION IF EXISTS `IpRangeValidoInData`;
DROP FUNCTION IF EXISTS `IpAppartieneRangeInData`;

DROP FUNCTION IF EXISTS `Ip2Paese`;
DROP FUNCTION IF EXISTS `Ip2PaeseStorico`;

DROP FUNCTION IF EXISTS `IpRangePossoInserire`;

DROP PROCEDURE IF EXISTS `IpRangeInserisciFidato`;
DROP PROCEDURE IF EXISTS `IpRangeInserisciAdessoFidato`;

DROP PROCEDURE IF EXISTS `IpRangeProvaInserire`;
DROP PROCEDURE IF EXISTS `IpRangeProvaInserireAdesso`;

DROP TRIGGER IF EXISTS `IpRangeControlloAggiornamento`;

DELIMITER $$

-- ----------------------------------------------------
--
--         Funzioni di utilita' sui Range IP4
--
-- ----------------------------------------------------

CREATE FUNCTION `IpRangeCollidono`(
    Inizio1 INT UNSIGNED, Fine1 INT UNSIGNED, 
    Inizio2 INT UNSIGNED, Fine2 INT UNSIGNED)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Si assume che Fine1 >= Inizio1
    -- Si assume che Fine2 >= Inizio2

    IF Inizio1 > Inizio2 THEN
        RETURN Fine2 >= Inizio1;
    END IF;
    -- Dobbiamo controllare se Inizio1 <= Inizio2 <= Fine2
    -- Sappiamo gia' pero' che Inizio1 <= Inizio2
    -- Quindi dobbiamo solo controllare Inizio2 <= Fine1
    RETURN Inizio2 <= Fine1;
END ; $$

CREATE FUNCTION `IpRangeValidoInData`(
    InizioValidita TIMESTAMP, 
    FineValidita TIMESTAMP, 
    IstanteDaControllare TIMESTAMP)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    IF IstanteDaControllare IS NULL THEN
        RETURN FineValidita IS NULL;
    END IF;

    RETURN IstanteDaControllare BETWEEN InizioValidita AND IFNULL(FineValidita, CURRENT_TIMESTAMP);
END ; $$

CREATE FUNCTION `IpAppartieneRangeInData`(
    Inizio INT UNSIGNED,
    Fine INT UNSIGNED,
    DataInizio TIMESTAMP,
    DataFine TIMESTAMP,
    IP INT UNSIGNED,
    DataDaControllare TIMESTAMP)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN 
        (IP BETWEEN Inizio AND Fine) AND IpRangeValidoInData(DataInizio, DataFine, DataDaControllare);
END ; $$

CREATE FUNCTION `Ip2PaeseStorico`(ip INT UNSIGNED, DataDaControllare TIMESTAMP)
RETURNS CHAR(2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE Codice CHAR(2) DEFAULT '??';

    IF ip IS NULL THEN
        RETURN Codice;
    END IF;

    SELECT r.Paese INTO Codice
    FROM `IPRange` r
    WHERE IpAppartieneRangeInData(
        r.`Inizio`, r.`Fine`, 
        r.`DataInizio`, r.`DataFine`, 
        ip, DataDaControllare)
    LIMIT 1;

    IF Codice IS NULL THEN
        SET Codice = '??';
    END IF;

    RETURN Codice;
END ; $$

CREATE FUNCTION `Ip2Paese`(ip INT UNSIGNED)
RETURNS CHAR(2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    RETURN Ip2PaeseStorico(ip, CURRENT_TIMESTAMP);
END ; $$


-- -----------------------------------------------------------------
--
--  Procedure di inserimento per mantenere IPRanges consistenti
--
-- -----------------------------------------------------------------

CREATE FUNCTION `IpRangePossoInserire` (
    `NewInizio` INT UNSIGNED , `NewFine` INT UNSIGNED, 
    `NewDataInizio` TIMESTAMP, `NewPaese` CHAR(2))
RETURNS BOOLEAN
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    -- Controlliamo se il record esiste gia' (ma con data diversa)
    IF EXISTS (
        SELECT * 
        FROM `IPRange` r
        WHERE 
            r.`Inizio` = `NewInizio` AND 
            r.`Fine` = `NewFine` AND 
            IpRangeValidoInData(r.`DataInizio`, r.`DataFine`, `NewDataInizio`) AND 
            -- Se puntano allo stesso paese vuol dire che e' il solito range non ancora scaduto
            r.`Paese` = `NewPaese`
        ) THEN
        
        RETURN FALSE;
    END IF;

    -- Un record gia' presente, con priorita' maggiori, "rompe" quello appena inserito
    IF EXISTS (
        SELECT * 
        FROM `IPRange` r
        WHERE 
            IpRangeCollidono(`NewInizio`, `NewFine`, r.`Inizio`, r.`Fine`) AND
            IpRangeValidoInData(r.`DataInizio`, r.`DataFine`, `NewDataInizio`) AND
            r.`Paese` <> '??'
        ) THEN
        
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END ; $$

-- Inserimento di range senza effettuare controlli

CREATE PROCEDURE `IpRangeInserisciFidato` (
    IN `NewInizio` INT UNSIGNED, IN `NewFine` INT UNSIGNED, 
    IN `NewDataInizio` TIMESTAMP, IN `NewDataFine` TIMESTAMP, 
    IN `NewPaese` CHAR(2), IN `InvalidaCollisioni` BOOLEAN
)
BEGIN
    IF `InvalidaCollisioni` THEN
        -- Se il record inserito "rompe" uno gia' presente, con meno piorita' si fa scadere quello gia' presente
        UPDATE `IPRange`
        SET `IPRange`.`DataFine` = `NewDataInizio` - INTERVAL 1 SECOND -- I timestamp vengono tenuti leggermente differenti
        WHERE
            IpRangeCollidono(`NewInizio`, `NewFine`, `IPRange`.`Inizio`, `IPRange`.`Fine`)  AND
            IpRangeValidoInData(`NewDataInizio`, `NewDataFine`, `IPRange`.`DataInizio`);
    END IF;
    
    -- Inserisco essendo sicuro di aver mantenuto coerenza tra gli ip
    INSERT INTO `IPRange` (`Inizio`, `Fine`, `DataInizio`, `DataFine`, `Paese`) VALUES
    (`NewInizio`, `NewFine`, `NewDataInizio`, `NewDataFine`, `NewPaese`);
END ; $$

-- Inserisce solo se passa controlli

CREATE PROCEDURE `IpRangeProvaInserire` (
    IN `NewInizio` INT UNSIGNED, IN `NewFine` INT UNSIGNED, 
    IN `NewDataInizio` TIMESTAMP, IN `NewDataFine` TIMESTAMP, 
    `NewPaese` CHAR(2)
)
insert_body:BEGIN

    -- Controllo sulla consistenza del range temporale
    IF `NewDataFine` IS NOT NULL AND `NewDataFine` < `NewDataInizio` THEN
        SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = 'Range di date invertito: DataInizio > DataFine';
        LEAVE insert_body;
    END IF;

    -- Controllo sulla consistenza del range
    IF `NewFine` < `NewInizio` THEN
        SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = 'Range invertito: Inizio > Fine';
        LEAVE insert_body;
    END IF;

    -- Controllo sull'esistenza del paese
    IF `NewPaese` = '??' OR NOT EXISTS (
        SELECT *
        FROM `Paese` P
        WHERE P.`Codice` = `NewPaese`
    ) THEN
        SIGNAL SQLSTATE '01000'
            SET MESSAGE_TEXT = 'Paese non trovato!';
        LEAVE insert_body;
    END IF;

    CALL `IpRangeInserisciFidato`(`NewInizio`, `NewFine`, `NewDataInizio`, `NewDataFine`, `NewPaese`, TRUE);
END ; $$

-- Inserimenti di range validi dal momento stesso

CREATE PROCEDURE `IpRangeInserisciAdessoFidato` (
    IN `NewInizio` INT UNSIGNED, IN `NewFine` INT UNSIGNED, IN `NewPaese` CHAR(2), IN `InvalidaCollisioni` BOOLEAN)
BEGIN
    CALL `IpRangeInserisciFidato`(`NewInizio`, `NewFine`, CURRENT_TIMESTAMP, NULL, `NewPaese`, `InvalidaCollisioni`);
END ; $$

CREATE PROCEDURE `IpRangeProvaInserireAdesso` (
    IN `NewInizio` INT UNSIGNED, IN `NewFine` INT UNSIGNED, `NewPaese` CHAR(2))
BEGIN
    CALL `IpRangeProvaInserire`(`NewInizio`, `NewFine`, CURRENT_TIMESTAMP, NULL, `NewPaese`);
END ; $$


CREATE TRIGGER `IpRangeControlloAggiornamento`
BEFORE UPDATE ON `IPRange`
FOR EACH ROW
BEGIN

    IF NEW.`Inizio` <> OLD.`Inizio` OR NEW.`Fine` <> OLD.`Fine` THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non si possono modificare i range! Cancellare il range e inserirne uno nuovo.';
    END IF;
    
END ; $$

DELIMITER ;