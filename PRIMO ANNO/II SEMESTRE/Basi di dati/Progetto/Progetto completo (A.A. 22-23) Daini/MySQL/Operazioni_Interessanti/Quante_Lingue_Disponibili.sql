DROP PROCEDURE IF EXISTS Quante_Lingue_Disponibili_Doppiaggio_Sottotitolo;
DELIMITER $$
CREATE PROCEDURE Quante_Lingue_Disponibili_Doppiaggio_Sottotitolo(IN Id_Film INT,OUT Quante_Lingue INT)
BEGIN

    SET Quante_Lingue =     (
                                SELECT  F.Quante_Lingue
                                FROM    Film F
                                WHERE   F.Id_Film = Id_Film
                            );

END $$
DELIMITER ;