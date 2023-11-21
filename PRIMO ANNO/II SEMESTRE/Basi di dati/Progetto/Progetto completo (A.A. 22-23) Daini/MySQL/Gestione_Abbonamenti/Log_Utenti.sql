DROP PROCEDURE IF EXISTS Procedura_Lista;
DELIMITER $$
CREATE PROCEDURE Procedura_Lista()
BEGIN


-- se la tabella di log non esiste, la creiamo

    IF NOT EXISTS (SELECT table_name FROM information_schema.tables WHERE table_schema = 'mydb' AND table_name = 'log_suggerimenti') THEN
    
            CREATE TABLE Log_Utenti (
                                        Id INT NOT NULL,
                                        Tipo_Abbonamento VARCHAR(100) NOT NULL,
                                        PRIMARY KEY(Id_Utente)        
                                    ); 

    END IF;

    -- troviamo gli utenti che contengono abbonamenti King e incredible del mese
    INSERT INTO Log_Utenti
    WITH Utenti_Corretti AS (
                                SELECT  A.Id_Utente,A.Tipo
                                FROM    Abbonamento A
                                WHERE   (A.Tipo = 'Incredible' OR A.Tipo = 'King') AND MONTH(A.Data_Pagamento) + A.Durata_Abbonamento >= MONTH(CURRENT_DATE)
                            )
    -- inseriamo quelli non presenti nel LOG
    SELECT  UC.*
    FROM    Log_Utenti LU LEFT OUTER JOIN Utenti_Corretti UC ON (LU.Id = UC.Id_Utente AND LU.Tipo_Abbonamento = UC.Tipo)
    WHERE   UC.Id_Utente IS NULL;


    -- eliminiamo quelli non più abbonati
    WITH Utenti_Corretti AS (
                                SELECT  A.Id_Utente,A.Tipo
                                FROM    Abbonamento A
                                WHERE   (A.Tipo = 'Incredible' OR A.Tipo = 'King') AND MONTH(A.Data_Pagamento) + A.Durata_Abbonamento >= MONTH(CURRENT_DATE)
                            )
    -- eliminiamo il log vecchio
    DELETE FROM Log_Utenti LU
    WHERE (LU.Id,LU.Tipo_Abbonamento) NOT IN(
                                                SELECT  UC.*
                                                FROM    Utenti_Corretti UC
                                            );


END $$

DELIMITER ;