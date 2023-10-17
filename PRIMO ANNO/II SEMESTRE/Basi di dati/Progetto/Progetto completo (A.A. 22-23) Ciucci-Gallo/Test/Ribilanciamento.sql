USE `FilmSphere`;

DELIMITER $$
DROP PROCEDURE IF EXISTS `TestRibilanciamento` $$

CREATE PROCEDURE `TestRibilanciamento`()
BEGIN
    DECLARE Server1 INT DEFAULT 1;
    DECLARE Server2 INT DEFAULT 2;
    DECLARE FileInserito INT DEFAULT 1;
    DECLARE EdizioneInserita INT DEFAULT 1;
    DECLARE TS TIMESTAMP DEFAULT CURRENT_TIMESTAMP - INTERVAL 31 MINUTE;

    -- Inserimento di Server fasulli da usare

    INSERT INTO `Server` (`MaxConnessioni`, `LunghezzaBanda`, `MTU`, `Posizione`) VALUES
    (2, 1, 1, POINT(12.4896506, 41.8902102)); -- Posizione: Colosseo

    SET Server1 = LAST_INSERT_ID();

    INSERT INTO `Server` (`MaxConnessioni`, `LunghezzaBanda`, `MTU`, `Posizione`) VALUES
    (3, 1, 1, POINT(10.3902697, 43.7214734)); -- Posizione: Polo A Ingegneria

    SET Server2 = LAST_INSERT_ID();

    -- Inserimento dell'edizione fasulla e del file fasullo

    INSERT INTO `Edizione` (`Film`, `Anno`, `Tipo`, `Lunghezza`) VALUES
    (1, YEAR(CURRENT_DATE), 'Edizione di Test', 2 * 3600);

    SET EdizioneInserita = LAST_INSERT_ID();

    INSERT INTO `File` (
        `Edizione`, `Dimensione`, `BitRate`, `FormatoContenitore`, 
        `FamigliaAudio`, `VersioneAudio`, `FamigliaVideo`, `VersioneVideo`,
        `Risoluzione`, `FPS`, `BitDepth`, `Frequenza`) VALUES
    (
        EdizioneInserita, 10000, 1.0, 'MP4', 
        'MPEG-4', 1, 'H', 265, 
        1080, 60.0, 32, 1000000);

    SET FileInserito = LAST_INSERT_ID();

    -- Si rende il file presente nei server appena inseriti

    REPLACE INTO `PoP` (`File`, `Server`) VALUES (FileInserito, Server1), (FileInserito, Server2);

    -- Due connessioni iniziano ed utilizzano lo stesso server

    REPLACE INTO `Connessione` (`IP`, `Inizio`, `Utente`, `Hardware`) VALUES
    (INET_ATON('193.205.81.1'), TS, 'richie-314', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36'),
    (INET_ATON('193.205.81.7'), TS, 'richie-314', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36');
    
    CALL `MigliorServer`('richie-314', EdizioneInserita, INET_ATON('193.205.81.1'), 10000, 16384, 'MPEG-4, H', NULL, @FileID, @ServerID);

    REPLACE INTO `Visualizzazione` (`IP`, `InizioConnessione`, `Utente`, `Edizione`, `Timestamp`) VALUES
    (INET_ATON('193.205.81.1'), TS, 'richie-314', EdizioneInserita, TS),
    (INET_ATON('193.205.81.7'), TS, 'richie-314', EdizioneInserita, TS);

    REPLACE INTO `Erogazione` (`IP`, `InizioConnessione`, `Utente`, `Edizione`, `Timestamp`, `Server`, `InizioErogazione`) VALUES
    (INET_ATON('193.205.81.1'), TS, 'richie-314', EdizioneInserita, TS, @ServerID, TS),
    (INET_ATON('193.205.81.7'), TS, 'richie-314', EdizioneInserita, TS, @ServerID, TS);

    -- Nel durante l'Evento RibilanciamentoCarico viene eseguito, individua le modifiche migliori e le memorizza in `ModificaErogazioni`, in attesa che vengano effettuate

    CALL `RibilanciamentoCarico`();
    
    SELECT * FROM `ModificaErogazioni`;
    
END ; $$

DELIMITER ;

CALL `TestRibilanciamento`();