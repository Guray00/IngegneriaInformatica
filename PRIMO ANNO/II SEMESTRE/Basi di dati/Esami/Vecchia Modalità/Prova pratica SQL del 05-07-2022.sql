/*
Prova pratica di Basi Di Dati del 05/07/2022

Scrivere una stored procedure che, ricevuta in ingresso la matricola di un medico cardiologo e quella di un gastroenterologo,
 consideri le loro visite effettuate negli ultimi dieci anni, e restituisca la matricola e il cognome del medico che,
 in almeno due mesi, ha effettuato un numero di visite giornaliere strettamente crescente per un lasso di tempo (numero di giorni) maggiore,
 in entrambi i mesi, rispetto all'altro medico, nei corrispondenti due mesi.

 Nella soluzione avevo capito che i giorni dovevano essere consecutivi, invece pistolesi contava le visite cresenti
 anche se in giorni non consecutivi (ad esempio se un medico fa una visita il primo giorno del mese e due visite il
 quinto giorno del mese pistolesi la conta buona mentre la mia soluzione no).

 Nonostante questo pistolesi ha detto che è indifferente e la soluzione è corretta.
*/


DELIMITER $$
DROP PROCEDURE IF EXISTS confronta_medici $$
CREATE PROCEDURE confronta_medici (
	matricola_cardiologo VARCHAR(10),
    matricola_gastroenterologo VARCHAR(10)
)
BEGIN
    DECLARE fetch_anno INT DEFAULT 0;
    DECLARE fetch_mese INT DEFAULT 0;
    DECLARE fetch_giorno INT DEFAULT 0;
	DECLARE fetch_visiteMC INT DEFAULT 0;
	DECLARE fetch_visiteMG INT DEFAULT 0;
    
    DECLARE last_mese INT DEFAULT 0;
    DECLARE last_visiteMC INT DEFAULT 0;
    DECLARE last_visiteMG INT DEFAULT 0;
    
	DECLARE vittorieMC INT DEFAULT 0;
    DECLARE vittorieMG INT DEFAULT 0;
    DECLARE visite_mensiliMC INT DEFAULT 0;
    DECLARE visite_mensiliMG INT DEFAULT 0;
    DECLARE best_visite_mensiliMG INT DEFAULT 0;
    DECLARE best_visite_mensiliMG INT DEFAULT 0;
    
    DECLARE finito TINYINT(1) DEFAULT 0;
    
    DECLARE cur CURSOR FOR
    # Supponendo che la clinica visiti almeno un paziente al giorno ogni giorno negli ultimi 10 anni
    # (questo mi serve per contare come zero i giorni senza visite ed implementare la parte dei giorni consecutivi)
	WITH giorni AS (
		SELECT DISTINCT YEAR(V.Data) AS Anno, MONTH(V.Data) AS Mese, DAY(V.Data) AS Giorno
		FROM Visita V
		WHERE YEAR(V.Data) > YEAR(CURRENT_DATE) - 10
	), medico_cardiologo AS (
		SELECT YEAR(V.Data) AS Anno, MONTH(V.Data) AS Mese, DAY(V.Data) AS Giorno, COUNT(*) AS Visite
		FROM Visita V
		WHERE V.Medico = matricola_cardiologo
			  AND YEAR(V.Data) > YEAR(CURRENT_DATE) - 10
		GROUP BY YEAR(V.Data), MONTH(V.Data), DAY(V.Data)
	), medico_gastroenterologo AS (
		SELECT YEAR(V.Data) AS Anno, MONTH(V.Data) AS Mese, DAY(V.Data) AS Giorno, COUNT(*) AS Visite
		FROM Visita V
		WHERE V.Medico = matricola_gastroenterologo
			  AND YEAR(V.Data) > YEAR(CURRENT_DATE) - 10
		GROUP BY YEAR(V.Data), MONTH(V.Data), DAY(V.Data)
	), visite_medico_cardiologo AS (
    	SELECT G.Anno, G.Mese, G.Giorno, IFNULL(MC.Visite, 0) AS Visite
		FROM giorni G NATURAL LEFT OUTER JOIN medico_cardiologo MC
    ), visite_medico_gastroenterologo AS (
		SELECT G.Anno, G.Mese, G.Giorno, IFNULL(MG.Visite, 0) AS Visite
		FROM giorni G NATURAL LEFT OUTER JOIN matricola_gastroenterologo MG
    )
	SELECT VMC.Anno, VMC.Mese, VMC.Giorno, VMC.Visite AS VisiteMC, VMG.Visite AS VisiteMG
    FROM visite_medico_cardiologo VMC NATURAL JOIN visite_medico_gastroenterologo VMG
    ORDER BY VMC.Anno, VMC.Mese, VMC.Giorno;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finito = 1;
    
	# Verificare i parametri passati in input siano effettivamente un cardiologo ed un gastroenterologo
    IF NOT EXISTS (
		SELECT *
        FROM Medico M
        WHERE M.Specializzazione = 'Cardiologia'
			  AND M.Matricola = medico_cardiologo
    ) OR NOT EXISTS (
		SELECT *
        FROM Medico M
        WHERE M.Specializzazione = 'Gastroenterologia'
			  AND M.Matricola = medico_gastroenterologo
    ) THEN 
		SIGNAL SQLSTATE '45000';
        SET MESSAGE_TEXT = 'I medici non rispettano le condizioni della procedura';
    END IF;
    
    OPEN cur;
    
    scan: LOOP
		FETCH cur INTO fetch_anno, fetch_mese, fetch_giorno, fetch_visiteMC, fetch_visiteMG;
        IF finito = 1 THEN LEAVE scan; END IF;
        
        SET last_mese = fetch_mese;
        
        # Se cambia il mese decreto il vincitore del mese e resetto le statistiche
        IF last_mese <> fetch_mese THEN
			IF best_visite_mensiliMC > best_visite_mensiliMG THEN
				SET vittorieMC = vittorieMC + 1;
			ELSEIF best_visite_mensiliMC < best_visite_mensiliMG THEN
				SET vittorieMG = vittorieMG + 1;
			END IF;
            
			SET visite_mensiliMC = 0;
            SET visite_mensiliMG = 0;
            SET last_visiteMC = 0;
            SET last_visiteMG = 0;
            SET best_visite_mensiliMC = 0;
            SET best_visite_mensiliMG = 0;
            
		# Se il mese non cambia continuo il conteggio
		ELSE 
			IF (last_visiteMC < fetch_visiteMC) THEN
				SET visite_mensiliMC = visite_mensiliMC + 1;
			END IF;
            
            IF (last_visiteMC < fetch_visiteMC) THEN
                SET visite_mensiliMG = visite_mensiliMG + 1;
			END IF;
            
            # Tiene conto del fatto che se si intorrompe la striscia di valori crescenti posso (spesso) trovarne una maggiore nello stesso mese
            IF (visite_mensiliMC > best_visite_mensiliMC) THEN
				SET best_visite_mensiliMC = visite_mensiliMC;
			END IF;
            
		    IF (visite_mensiliMG > best_visite_mensiliMG) THEN
				SET best_visite_mensiliMG = visite_mensiliMG;
			END IF;
            
			SET last_visteMC = fetch_visiteMC;
            SET last_visiteMG = fetch_visiteMG;
        END IF;
        
        ITERATE scan;
    END LOOP;
    
	CLOSE cur;
       
	# + 2 Perchè in almeno due mesi deve essere il vincitore 
    # questa ultima parte potrebbe essere leggermente sbagliata ma il senso è quello
    # (pistolesi praticamente non l'ha quasi letta)
    IF (vittorieMC >= vittorieMG + 2) THEN
		SELECT M.Matricola, M.Cognome
        FROM Medico M
        WHERE M.Matricola = matricola_cardiologo;
    ELSEIF (vittorieMG >= vittorieMC + 2) THEN
		SELECT M.Matricola, M.Cognome
        FROM Medico M
        WHERE M.Matricola = matricola_cardiologo;
	ELSE SELECT NULL;
    END IF;
    
END
$$ DELIMITER ;


