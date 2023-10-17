USE `FilmSphere`;

DELIMITER $$
DROP PROCEDURE IF EXISTS `TestMigliorServer` $$

CREATE PROCEDURE `TestMigliorServer`()
BEGIN
    DECLARE Server1 INT DEFAULT 1;
    DECLARE Server2 INT DEFAULT 2;
    DECLARE FileInserito INT DEFAULT 1;
    DECLARE EdizioneInserita INT DEFAULT 1;
    DECLARE TS TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

    -- Inserimento di Server fasulli da usare

    INSERT INTO `Server` (`MaxConnessioni`, `LunghezzaBanda`, `MTU`, `Posizione`) VALUES
    (1, 1, 1, POINT(10.3902697, 43.7214734));

    SET Server1 = LAST_INSERT_ID();

    INSERT INTO `Server` (`MaxConnessioni`, `LunghezzaBanda`, `MTU`, `Posizione`) VALUES
    (3, 1, 1, POINT(0, 0));

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

    -- Un utente si connette

    REPLACE INTO `Connessione` (`IP`, `Inizio`, `Utente`, `Hardware`) VALUES
    (INET_ATON('193.205.81.1'), TS, 'richie-314', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36');

    -- L'utente prova a vedere un'edizione che ha scelto e ottiene un risultato

    CALL `MigliorServer`('richie-314', EdizioneInserita, INET_ATON('193.205.81.7'), 10000, 16384, 'MPEG-4, H', NULL, @FileID1, @ServerID1);
    
    DO SLEEP(1); -- Simula delay per l'inizio del contenuto in pratica

    REPLACE INTO `Visualizzazione` (`IP`, `InizioConnessione`, `Utente`, `Edizione`, `Timestamp`) VALUES
    (INET_ATON('193.205.81.1'), TS, 'richie-314', EdizioneInserita, TS);

    REPLACE INTO `Erogazione` (`IP`, `InizioConnessione`, `Utente`, `Edizione`, `Timestamp`, `Server`) VALUES
    (INET_ATON('193.205.81.1'), TS, 'richie-314', EdizioneInserita, TS, @ServerID1);

    -- Un altra connessione inizia e vuole vedere la stessa edizione: il risultato cambia

    REPLACE INTO `Connessione` (`IP`, `Inizio`, `Utente`, `Hardware`) VALUES
    (INET_ATON('193.205.81.7'), TS, 'richie-314', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36');

    
    CALL `MigliorServer`('richie-314', EdizioneInserita, INET_ATON('193.205.81.7'), 10000, 16384, 'MPEG-4, H', NULL, @FileID2, @ServerID2);

    -- Rimozione dei dati ineriti per il test

    DELETE FROM `Edizione` WHERE `ID` = EdizioneInserita; -- Cancella Edizone, File, PoP, Erogazione
    DELETE FROM `Server` WHERE `ID` = Server1 OR `ID` = Server2;

    -- Visualizzazione dei risultati del TEST

    SELECT CONCAT(Server1, ', ', Server2) AS "ServerInseriti", FileInserito, @FileID1, @ServerID1, @FileID2, @ServerID2;
    
END ; $$

DELIMITER ;

CALL `TestMigliorServer`();