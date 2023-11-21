DROP PROCEDURE IF EXISTS Conta_Premi_Film;
DELIMITER $$
CREATE PROCEDURE Conta_Premi_Film(IN Id_Film INT,OUT Quanti_Premi INT)
BEGIN

        SET Quanti_Premi =  (
                                SELECT  F.Quanti_Premi
                                FROM    Film F
                                WHERE   F.Id_Film = Id_Film
                            );

END $$
DELIMITER ;