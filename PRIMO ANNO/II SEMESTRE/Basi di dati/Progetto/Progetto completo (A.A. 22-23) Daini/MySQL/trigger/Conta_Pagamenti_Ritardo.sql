-- Active: 1647365195286@@127.0.0.1@3306@mydb
DROP TRIGGER IF EXISTS Trigger_Aggiorna_Quanti_Ritardi;
DELIMITER $$
CREATE TRIGGER Trigger_Aggiorna_Quanti_Ritardi AFTER INSERT ON Abbonamento FOR EACH ROW
BEGIN

DECLARE Ritardo_Giusto TINYINT DEFAULT 0;

IF EXISTS   (
                    -- gli abbonamenti con Id_Cliente che si sta inserendo e con fattura in ritardo
                    SELECT  1
                    FROM    Abbonamento A NATURAL JOIN Fattura F
                    WHERE   A.Id_Cliente = NEW.Id_Cliente AND A.Numero_Fattura = NEW.Numero_Fattura AND 
                            (
                                (F.Data_Pagamento > F.Scadenza AND F.Data_Pagamento IS NOT NULL) 
                                OR (F.Data_Pagamento IS NULL AND F.Scadenza < CURRENT_DATE) 
                            )
            )
THEN            
    
    SET Ritardo_Giusto = 1;

END IF;

IF Ritardo_Giusto = 1
THEN
    
    UPDATE  Utente U
    SET     U.Quanti_Ritardi = U.Quanti_Ritardi + 1
    WHERE   Id_Cliente = NEW.Id_Cliente;

END IF;

END $$

DELIMITER ;