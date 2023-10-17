DROP PROCEDURE IF EXISTS Analytics2;
DELIMITER $$
CREATE PROCEDURE Analytics2 (IN CodEdificio VARCHAR(16), OUT valore_finale float)
BEGIN

DECLARE Contributo_Sensore FLOAT DEFAULT 30; -- 30 per cento
DECLARE Contributo_Stato FLOAT DEFAULT 60; -- 60 per cento
DECLARE Contributo_EventiSismici FLOAT DEFAULT 10; -- 10 per cento
DECLARE Stringa VARCHAR(60);

SET Contributo_Sensore = (SELECT SUM(VarPercentuale)*0.3
						  FROM (SELECT M.ValoreX, M.ValoreY, M.ValoreZ, S.SogliaDiRischio, sqrt(M.ValoreX*M.ValoreX+M.ValoreY*M.ValoreY+M.ValoreZ*M.ValoreZ)/S.SogliaDiRischio AS VarPercentuale
								FROM misurazionetriassiale M
									 INNER JOIN
									 sensore S on M.Sensore = S.Codice
								     INNER JOIN 
								     alerttriassiale A on A.MisurazioneTriassiale = M.Codice             
						WHERE M.Edificio = CodEdificio and S.Grandezza = 'AccelerazioneAngolare') AS z);
                          
SET Contributo_Stato = (SELECT If(E.stato is null, 0, E.Stato)/ 3 * 0.6 as VarPercentualeStato
						FROM Edificio E
                        WHERE E.Codice = CodEdificio);
                        
SET Contributo_EventiSismici = (SELECT EventiEdificio/EventiTotali*0.1
							    FROM 	(SELECT count(*) as EventiTotali, (select count(*)
																			FROM EventoCalamitoso E1
																			INNER JOIN
																			Edificio E2 ON E2.AreaGeografica = E1.AreaGeografica
																			WHERE E1.NomeEventoCalamitoso = 'Terremoto' AND E2.Codice = CodEdificio) as EventiEdificio
								FROM EventoCalamitoso E
								WHERE E.NomeEventoCalamitoso = 'Terremoto') AS b);
                                
SET valore_finale = IFNULL(Contributo_EventiSismici + Contributo_Sensore + Contributo_Stato, 0 );

IF valore_finale = 0 THEN SET Stringa = 'Nessun rischio';
ELSE IF valore_finale <=3 THEN SET Stringa = 'Danni superficiali';
ELSE IF valore_finale <=5 THEN SET Stringa = 'Danni strutturali';
ELSE SET Stringa = 'Danni gravi alla struttura';
END IF;
END IF;
END IF;

SELECT valore_finale as IndiceCalcolato, Stringa as Messaggio;

END $$
DELIMITER ;

