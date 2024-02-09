USE filmsphere;

DROP PROCEDURE IF EXISTS ArchiviazioneFile;
DELIMITER $$

CREATE PROCEDURE ArchiviazioneFile(IN Paese_ VARCHAR(45), IN FileDaInserire_ VARCHAR(45), IN TipoFile INT)
BEGIN
    DECLARE ServerID INT;
    DECLARE PesoFile INT;

    SELECT ID INTO ServerID
    FROM Server_
    WHERE Sede = Paese_
    ORDER BY Carico ASC
    LIMIT 1;

    IF TipoFile = 0 THEN
        SELECT Dimensione INTO PesoFile
        FROM FileAudio
        WHERE Nome = FileDaInserire_;

        INSERT INTO ArcFileAudio (FileAudio, Server_)
        VALUES (FileDaInserire_, ServerID);

    ELSEIF TipoFile = 1 THEN
        SELECT Dimensione INTO PesoFile
        FROM FileVideo
        WHERE Nome = FileDaInserire_;

        INSERT INTO ArcFileVideo (FileVideo, Server_)
        VALUES (FileDaInserire_, ServerID);

    ELSEIF TipoFile = 2 THEN
        SELECT Dimensione INTO PesoFile
        FROM FileSottotitoli
        WHERE Nome = FileDaInserire_;

        INSERT INTO ArcFileSottotitoli (FileSottotitoli, Server_)
        VALUES (FileDaInserire_, ServerID);

    END IF;

    UPDATE Server_
    SET Carico = Carico + PesoFile
    WHERE ID = ServerID;

END $$

DELIMITER ;
