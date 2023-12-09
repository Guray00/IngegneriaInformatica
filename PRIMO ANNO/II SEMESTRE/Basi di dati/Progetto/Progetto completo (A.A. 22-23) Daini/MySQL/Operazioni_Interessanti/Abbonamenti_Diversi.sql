DROP PROCEDURE IF EXISTS Quanti_Titolari_Diversi;
DELIMITER $$
CREATE PROCEDURE Quanti_Titolari_Diversi (IN Id_Cliente INT, OUT Quanti_Titolari_Diversi_ INT)
BEGIN
  
SET Quanti_Titolari_Diversi_ =   (
                                    
                                    SELECT  COUNT(*)
                                    FROM    Utente U INNER JOIN Abbonamento A INNER JOIN Fattura F INNER JOIN Carta C ON(U.Id_Cliente = A.Id_Cliente AND A.Numero_Fattura = F.Numero_Fattura AND F.CVV = C.CVV AND F.PAN = C.PAN)
                                    WHERE   U.Id_Cliente = Id_Cliente AND U.Nome = C.Nome_Titolare AND U.Cognome = C.Cognome_Titolare AND F.Scadenza < F.Data_Pagamento AND F.Data_Pagamento IS NOT NULL                  
                                );

END $$

DELIMITER ;
