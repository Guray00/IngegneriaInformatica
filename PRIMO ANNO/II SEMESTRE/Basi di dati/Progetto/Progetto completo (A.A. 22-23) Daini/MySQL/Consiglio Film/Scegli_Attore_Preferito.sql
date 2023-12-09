DROP PROCEDURE IF EXISTS Stampa_Film_Attori_Preferiti;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Attori_Preferiti()
BEGIN

-- verifico che la tabella esista

        IF NOT EXISTS (SELECT table_name FROM information_schema.tables WHERE table_schema = 'mydb' AND table_name = 'lista_id_genere') THEN
        
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabella Inesistente,chiamare prima la procedura Crea_Lista_Caratterizzazioni(Id_Utente)';

        END IF;


        -- uso la tabella che ho creato in Stampa_Film_Consigliati
        WITH Attore_Trovato AS  (
                                        SELECT  LID.*,I.Id_Artista
                                        FROM    Lista_Id_Genere LID INNER JOIN Interpretazione I ON LID.Id = I.Id_Film
                                ),
        Calcolo_Peso AS (
                                SELECT      ATO.Id_Artista,PA.Nome,PA.Istituzione,PA.Anno_Premiazione_Regista,IF(PA.Nome IS NULL AND PA.Istituzione IS NULL AND PA.Anno_Premiazione_Regista IS NULL,100,Calcola_Punteggio_Attore(PA.Nome,PA.Peso)) AS Punteggio_Premio
                                FROM        Attore_Trovato ATO NATURAL LEFT OUTER JOIN Premiazione_Attore PAT NATURAL LEFT OUTER JOIN Premio_Attore PA
                                GROUP BY    ATO.Id_Artista,PA.Nome,PA.Istituzione,PA.Anno_Premiazione_Regista -- va corretto con attore al suo posto
                        ),
        Artista_Punteggio_Alto AS   (
                                            SELECT      CP.Id_Artista,SUM(CP.Punteggio_Premio) AS Totale_Punteggio
                                            FROM        Calcolo_Peso CP
                                            GROUP BY    CP.Id_Artista
                                    )
       
        SELECT          ATO.Id,SUM(APA.Totale_Punteggio) AS Punteggio_Film
        FROM            Attore_Trovato ATO NATURAL JOIN Artista_Punteggio_Alto APA  
        GROUP BY        ATO.Id;   
        
        

END $$

DELIMITER ;