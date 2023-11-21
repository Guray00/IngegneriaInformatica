DROP PROCEDURE IF EXISTS Stampa_Film_Preferiti;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Preferiti()
BEGIN

        
        IF NOT EXISTS (SELECT table_name FROM information_schema.tables WHERE table_schema = 'mydb' AND table_name = 'lista_id_genere') THEN
        
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabella Inesistente,chiamare prima la procedura Crea_Lista_Caratterizzazioni(Id_Utente)';
        
        END IF;

        -- uso la tabella che ho creato in Stampa_Film_Consigliati
        WITH Film_Trovato AS    (
                                        SELECT  LID.Genere,LID.Id AS Id_Film,PF.Nome,PF.Istituzione,PF.Anno_Premiazione_Film
                                        FROM    Lista_Id_Genere LID LEFT OUTER JOIN Premiazione_Film PF ON LID.Id = PF.Id_Film
                                ),
        Calcolo_Peso AS (
                                SELECT          FT.Id_Film,FT.Nome,FT.Istituzione,FT.Anno_Premiazione_Film,IF(PF.Nome IS NULL AND PF.Istituzione IS NULL AND PF.Anno_Premiazione_Film IS NULL,100,Calcola_Punteggio_Film(PF.Nome,PF.Peso)) AS Punteggio_Premio
                                FROM            Film_Trovato FT NATURAL LEFT OUTER JOIN Premio_Film PF
                                GROUP BY        FT.Id_Film,FT.Nome,FT.Istituzione,PF.Anno_Premiazione_Film
                        ),
        Film_Punteggio AS (
                                SELECT      CP.Id_Film,SUM(CP.Punteggio_Premio) AS Totale_Punteggio
                                FROM        Calcolo_Peso CP
                                GROUP BY    CP.Id_Film
                          )
        
        SELECT          FM.Id_Film,FM.Totale_Punteggio
        FROM            Film_Punteggio FM
        ORDER BY        FM.Totale_Punteggio DESC;    

END $$

DELIMITER ;