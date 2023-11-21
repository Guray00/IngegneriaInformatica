DROP PROCEDURE IF EXISTS Genera_Classifica;
DELIMITER $$
CREATE PROCEDURE Genera_Classifica()
BEGIN
    -- affianco alla tabella formato,il formato successivo dello stessi film, rilasciati in date differenti
     WITH Tabella_Appoggio AS   (
                                    SELECT  FM.Id_Film,FM.Id_Formato,FM.Data_Aggiornamento,FM.Data_Rilascio,LEAD(FM.Data_Rilascio,1) OVER A AS Data_Rilascio_Successiva
                                    FROM    Film_Formato FM
                                    WINDOW A AS (
                                                    PARTITION BY FM.Id_Film,FM.Id_Formato,FM.Data_Aggiornamento
                                                    ORDER BY FM.Data_Rilascio
                                                )
                                ), 
    -- creo la tabella delle date visualizzate, che rispettono il formato delle date che risulta essere corretto, ovvero compreso fra la data del rilascio e del suo successivo, per ciascun film
	 Tabella_Appoggio2 AS(
                            SELECT  VF.Id_Film, TA.Id_Formato,TA.Data_Aggiornamento,TA.Data_Rilascio,VF.Ora_Visualizzazione,TA.Data_Rilascio_Successiva -- COUNT(*) AS Quante_Visualizzazioni --
                            FROM    Visualizzazioni_Film VF NATURAL JOIN Tabella_Appoggio TA
                            WHERE   TA.Data_Rilascio_Successiva IS NULL AND ( (DATE(VF.Ora_Visualizzazione) >= TA.Data_Rilascio) OR ( TA.Data_Rilascio_Successiva IS NOT NULL AND DATE(VF.Ora_Visualizzazione) BETWEEN TA.Data_Rilascio AND TA.Data_Rilascio_Successiva) )
                            ),
    -- conto le visualizzazioni corrette per ogni formato del film
    Conteggio_Visualizzazioni AS (
                                    SELECT      TA.Id_Film, TA.Id_Formato, TA.Data_Aggiornamento, COUNT(DISTINCT TA.Ora_Visualizzazione) AS Quante_Visualizzazioni
                                    FROM        Tabella_Appoggio2 TA
                                    GROUP BY    TA.Id_Film,TA.Id_Formato,TA.Data_Aggiornamento
                                ),
    -- classifica del film più visualizzati per ciascun formato, basandosi su quante visualizzazioni ha ricevuto
    Classifica_Appoggio AS (
                                SELECT CV.Id_Film, CV.Id_Formato,CV.Data_Aggiornamento, CV.Quante_Visualizzazioni, DENSE_RANK() OVER S AS Graduatoria
                                FROM Conteggio_Visualizzazioni CV
                                WINDOW S AS (
                                                ORDER BY CV.Quante_Visualizzazioni DESC
                                            )
                            )

    SELECT CA.Id_Film, CA.Id_Formato, CA.Quante_Visualizzazioni, CA.Graduatoria
    FROM Classifica_Appoggio CA
    ORDER BY CA.Graduatoria;
    

END $$

DELIMITER ;
    
    
        