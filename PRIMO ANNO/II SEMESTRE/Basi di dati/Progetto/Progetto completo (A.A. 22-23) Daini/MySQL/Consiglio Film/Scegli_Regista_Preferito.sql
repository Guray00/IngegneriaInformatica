DROP PROCEDURE IF EXISTS Stampa_Film_Registi_Preferiti;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Registi_Preferiti()
BEGIN

           
        IF NOT EXISTS (SELECT table_name FROM information_schema.tables WHERE table_schema = 'mydb' AND table_name = 'lista_id_genere') THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabella Inesistente,chiamare prima la procedura Crea_Lista_Caratterizzazioni(Id_Utente)';
        END IF;
        
        -- uso la tabella che ho creato in Stampa_Film_Consigliati
        WITH Regista_Trovato AS  (
                                        SELECT  LID.*,D.Id_Artista
                                        FROM    Lista_Id_Genere LID INNER JOIN Direzione D ON LID.Id = D.Id_Film
                                ),
        Calcolo_Peso AS (
                                SELECT      RT.Id_Artista,PE.Nome,PE.Istituzione,PER.Anno_Premiazione_Regista,IF(PER.Nome IS NULL AND PER.Istituzione IS NULL AND PER.Anno_Premiazione_Regista IS NULL,100,Calcola_Punteggio_Film(PE.Nome,PE.Peso)) AS Punteggio_Premio
                                FROM        Regista_Trovato RT NATURAL LEFT OUTER JOIN Premiazione_Regista PER NATURAL LEFT OUTER JOIN Premio_Regista PE  
                                GROUP BY    RT.Id_Artista,PE.Nome,PE.Istituzione,PER.Anno_Premiazione_Regista
                        ),
        Artista_Punteggio_Alto AS   (
                                            SELECT      CP.Id_Artista,SUM(CP.Punteggio_Premio) AS Totale_Punteggio
                                            FROM        Calcolo_Peso CP
                                            GROUP BY    CP.Id_Artista
                                    )
        SELECT      RT.Id,APA.Totale_Punteggio
        FROM        Regista_Trovato RT NATURAL JOIN Artista_Punteggio_Alto APA
        GROUP BY    RT.Id    
        ORDER BY    APA.Totale_Punteggio DESC;   
        
END $$

DELIMITER ;