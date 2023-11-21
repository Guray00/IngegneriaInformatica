DROP PROCEDURE IF EXISTS Conta_Dispositivi_Diversi;
DELIMITER $$
CREATE PROCEDURE Conta_Dispositivi_Diversi(IN Id_Cliente INT,OUT Quanti_Dispositivi INT)
BEGIN

        SET Quanti_Dispositivi =    (
                                        SELECT  U.Quanti_Dispositivi
                                        FROM    Utente U
                                        WHERE   U.Id_Cliente = Id_Cliente
                                    );

END $$
DELIMITER ;