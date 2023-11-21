DROP PROCEDURE IF EXISTS Conta_Premi_Attore;
DELIMITER $$
CREATE PROCEDURE Conta_Premi_Attore(IN Id_Artista INT,OUT Quanti_Premi INT)
BEGIN

        SET Quanti_Premi =  (
                                SELECT  A.Quanti_Premi
                                FROM    Attore A
                                WHERE   A.Id_Artista = Id_Artista
                            );

END $$
DELIMITER ;