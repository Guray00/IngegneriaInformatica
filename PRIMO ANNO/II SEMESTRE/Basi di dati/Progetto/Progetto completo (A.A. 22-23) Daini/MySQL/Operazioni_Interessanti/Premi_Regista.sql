DROP PROCEDURE IF EXISTS Conta_Premi_Regista;
DELIMITER $$
CREATE PROCEDURE Conta_Premi_Regista(IN Id_Artista INT,OUT Quanti_Premi INT)
BEGIN

        SET Quanti_Premi =  (
                                SELECT  R.Quanti_Premi
                                FROM    Regista R
                                WHERE   R.Id_Artista = Id_Artista
                            );

END $$
DELIMITER ;