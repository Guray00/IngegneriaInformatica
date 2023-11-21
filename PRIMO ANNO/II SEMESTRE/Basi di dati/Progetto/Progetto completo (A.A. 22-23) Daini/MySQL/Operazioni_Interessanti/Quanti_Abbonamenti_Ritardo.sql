DROP PROCEDURE IF EXISTS Conta_Abbonamenti_Ritardo;
DELIMITER $$
CREATE PROCEDURE Conta_Abbonamenti_Ritardo(IN Id_Cliente_ INT, OUT Quanti_Ritardi_ INT)
BEGIN
  
        SET Quanti_Ritardi_ =    (
                                    SELECT  U.Quanti_Ritardi
                                    FROM    Utente U
                                    WHERE   U.Id_Cliente = Id_Cliente_
                                );

END $$
DELIMITER ;