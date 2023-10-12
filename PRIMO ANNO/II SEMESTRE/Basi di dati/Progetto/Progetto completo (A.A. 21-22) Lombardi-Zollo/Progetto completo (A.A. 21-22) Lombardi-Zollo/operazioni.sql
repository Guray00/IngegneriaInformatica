/* Operazione 1 - trovaAlert */
DROP PROCEDURE IF EXISTS trovaAlert;
DELIMITER $$

CREATE PROCEDURE trovaAlert(IN _areaGeografica VARCHAR(100), IN _data DATE, IN _tipo VARCHAR(100))
	BEGIN
		WITH 	EdificiColpiti AS	(
										SELECT 	DISTINCT Edificio
										FROM 	Eventualita
										WHERE	AreaGeografica = _areaGeografica
												AND
												TipoCalamita = _tipo
												AND
												Data = _data
									),
				SensoriCoinvolti AS	(
										SELECT	IDSensore, Edificio, Tipologia
                                        FROM	Sensore 
                                        WHERE	Edificio IN (SELECT * FROM EdificiColpiti)
									)
				SELECT	SC.Edificio, SC.IDSensore, SC.Tipologia, A.*
                FROM	Alert A
						INNER JOIN
                        SensoriCoinvolti SC	ON A.IDSensore = SC.IDSensore
                WHERE 	CAST(A.TimeStamp AS DATE) = _data;
	END $$

DELIMITER ;

/* Operazione 2 - topologiaEdificio */
DROP PROCEDURE IF EXISTS topologiaEdificio;
DELIMITER $$

CREATE PROCEDURE topologiaEdificio(IN _codEdificio CHAR(50))
	BEGIN
        
        WITH 	VaniEdificio AS	(
									SELECT	Piano, IDVano, LungMax, LargMax
									FROM	Vano
									WHERE	Edificio = _codEdificio
								)
        (
			SELECT	VE.Piano, VE.IDVano, VE.LungMax AS LungMaxVano, VE.LargMax AS LargMaxVano, "PA_Interno" AS Tipo, PAE.IDPuntoAccesso AS ID, PAE.Larghezza, PAE.Orientamento
			FROM  	VaniEdificio VE
			INNER JOIN
			PuntoAccessoEsterno PAE	ON VE.IDVano = PAE.IDVano AND VE.Piano = PAE.Piano
        )
        UNION
        (
			SELECT	VE.Piano, VE.IDVano, VE.LungMax AS LungMaxVano, VE.LargMax AS LargMaxVano, "PA_Esterno" AS Tipo, PAI.IDPuntoAccesso AS ID, PAI.Larghezza, AI.Orientamento
			FROM  	VaniEdificio VE
					INNER JOIN
					AccessoI AI	ON VE.IDVano = AI.IDVano AND VE.Piano = AI.Piano
					INNER JOIN
					PuntoAccessoInterno PAI ON AI.IDPuntoAccesso = PAI.IDPuntoAccesso
        )
        UNION
        (
			SELECT	VE.Piano, VE.IDVano, VE.LungMax AS LungMaxVano, VE.LargMax AS LargMaxVano, "Finestra" AS Tipo, F.IDFinestra AS ID, F.Larghezza, F.Orientamento
			FROM  	VaniEdificio VE
					INNER JOIN
					Finestra F	ON VE.IDVano = F.IDVano AND VE.Piano = F.Piano
        )
        ORDER BY Piano, IDVano;

	END $$
DELIMITER ;

/* Operazione 3 - rischiAnnui*/
DROP PROCEDURE IF EXISTS rischiAnnui;
DELIMITER $$

CREATE PROCEDURE rischiAnnui(IN _codEdificio CHAR(50))
	BEGIN

		DECLARE sede VARCHAR(100);
        SET sede =	(
						SELECT 	AreaGeografica
                        FROM	Edificio
                        WHERE	CodEdificio = _codEdificio
					);
		
        SELECT	*
        FROM	Rischio
        WHERE	AreaGeografica = sede
				AND
                YEAR(Data) = YEAR(CURRENT_DATE);
		
	END $$
DELIMITER ;

/* Operazione 4 - leggiaBustaPaga */
DROP PROCEDURE IF EXISTS leggiBustaPaga;
DELIMITER $$

CREATE PROCEDURE leggiBustaPaga(IN _codFisc CHAR(16), OUT bustaPaga_ FLOAT)
	BEGIN
		IF 	( DAY( CURRENT_DATE ) <> 28 ) THEN
			BEGIN
				SET bustaPaga_ = NULL;
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Lettura busta paga non autorizzata!';
			END;
		END IF;
        
        SET bustaPaga_ =	(
								SELECT 	BustaPaga
								FROM	Operaio
								WHERE	CFisc = _codFisc
                            );
		
        UPDATE 	Operaio
		SET 	BustaPaga = 0
		WHERE	CFisc = _codFisc;
        
	END $$
DELIMITER ;

-- Trigger per aggiornamento ridondanza
DROP TRIGGER IF EXISTS aggiornaBustaPaga;
DELIMITER $$
CREATE TRIGGER aggiornaBustaPaga
AFTER INSERT ON LavoriTurno
FOR EACH ROW
	BEGIN

	DECLARE manodopera FLOAT;
    SET manodopera =	(
							SELECT	Manodopera
							FROM	Operaio
							WHERE	CFisc = NEW.CFiscLavoratore
						);

	UPDATE 	Operaio
	SET 	BustaPaga = BustaPaga + NEW.NumeroOre*manodopera
    WHERE	CFisc = NEW.CFiscLavoratore;

	END $$
DELIMITER ;

/* Operazione 5 - costoMaterialiStadio*/
DROP PROCEDURE IF EXISTS costoMaterialiStadio;

DELIMITER $$

CREATE PROCEDURE costoMaterialiStadio(IN _codProgetto CHAR(50), IN _dataInizio DATE, OUT costoMateriali_ FLOAT)
	
    BEGIN
		SET costoMateriali_ =	(
									SELECT	CostoMateriali
									FROM	Stadio
									WHERE	CodProgetto = _codProgetto
											AND
											DataInizio = _dataInizio     
								);
	END $$

DELIMITER ;

-- Trigger per aggiornamento ridondanza
DROP TRIGGER IF EXISTS aggiornaCostoMateriali1;
DELIMITER $$
CREATE TRIGGER aggiornaCostoMateriali1
AFTER INSERT ON Intonaco
FOR EACH ROW
BEGIN
	DECLARE quantita FLOAT;
	DECLARE lavoroTarget CHAR(50);
	DECLARE codProgettoStadio CHAR(50);
	DECLARE dataInizioStadio CHAR(50);
    
	SELECT	Quantita, CodLavoro
	INTO	quantita, lavoroTarget
	FROM	Materiale
	WHERE	NomeFornitore = NEW.NomeFornitore
			AND
			CodLotto = NEW.CodLotto;

	SELECT	CodProgetto, DataInizio
	INTO	codProgettoStadio, dataInizioStadio
	FROM	Lavoro
	WHERE	CodLavoro = lavoroTarget;
    
    UPDATE 	Stadio
    SET		CostoMateriali = CostoMateriali + NEW.Costo_kg*quantita
    WHERE	DataInizio = dataInizioStadio
			AND
            CodProgetto = codProgettoStadio;
                        
END$$
DELIMITER ;

-- Trigger per aggiornamento ridondanza
DROP TRIGGER IF EXISTS aggiornaCostoMateriali2;
DELIMITER $$
CREATE TRIGGER aggiornaCostoMateriali2
AFTER INSERT ON Pietra
FOR EACH ROW
BEGIN
	DECLARE quantita FLOAT;
	DECLARE lavoroTarget CHAR(50);
	DECLARE codProgettoStadio CHAR(50);
	DECLARE dataInizioStadio CHAR(50);
    
	SELECT	Quantita, CodLavoro
	INTO	quantita, lavoroTarget
	FROM	Materiale
	WHERE	NomeFornitore = NEW.NomeFornitore
			AND
			CodLotto = NEW.CodLotto;

	SELECT	CodProgetto, DataInizio
	INTO	codProgettoStadio, dataInizioStadio
	FROM	Lavoro
	WHERE	CodLavoro = lavoroTarget;
    
    UPDATE 	Stadio
    SET		CostoMateriali = CostoMateriali + NEW.Costo_kg*quantita
    WHERE	DataInizio = dataInizioStadio
			AND
            CodProgetto = codProgettoStadio;
	
END$$
DELIMITER ;

-- Trigger per aggiornamento ridondanza
DROP TRIGGER IF EXISTS aggiornaCostoMateriali3;
DELIMITER $$
CREATE TRIGGER aggiornaCostoMateriali3
AFTER INSERT ON Altro
FOR EACH ROW
BEGIN
	DECLARE quantita FLOAT;
	DECLARE lavoroTarget CHAR(50);
	DECLARE codProgettoStadio CHAR(50);
	DECLARE dataInizioStadio CHAR(50);
    
	SELECT	Quantita, CodLavoro
	INTO	quantita, lavoroTarget
	FROM	Materiale
	WHERE	NomeFornitore = NEW.NomeFornitore
			AND
			CodLotto = NEW.CodLotto;

	SELECT	CodProgetto, DataInizio
	INTO	codProgettoStadio, dataInizioStadio
	FROM	Lavoro
	WHERE	CodLavoro = lavoroTarget;
    
    UPDATE 	Stadio
    SET		CostoMateriali = CostoMateriali + NEW.Costo*quantita
    WHERE	DataInizio = dataInizioStadio
			AND
            CodProgetto = codProgettoStadio;
	
END$$
DELIMITER ;

-- Trigger per aggiornamento ridondanza
DROP TRIGGER IF EXISTS aggiornaCostoMateriali4;
DELIMITER $$
CREATE TRIGGER aggiornaCostoMateriali4
AFTER INSERT ON Piastrella
FOR EACH ROW
BEGIN
	DECLARE quantita FLOAT;
	DECLARE lavoroTarget CHAR(50);
	DECLARE codProgettoStadio CHAR(50);
	DECLARE dataInizioStadio CHAR(50);
    
	SELECT	Quantita, CodLavoro
	INTO	quantita, lavoroTarget
	FROM	Materiale
	WHERE	NomeFornitore = NEW.NomeFornitore
			AND
			CodLotto = NEW.CodLotto;

	SELECT	CodProgetto, DataInizio
	INTO	codProgettoStadio, dataInizioStadio
	FROM	Lavoro
	WHERE	CodLavoro = lavoroTarget;
    
    UPDATE 	Stadio
    SET		CostoMateriali = CostoMateriali + NEW.Costo_mq*quantita
    WHERE	DataInizio = dataInizioStadio
			AND
            CodProgetto = codProgettoStadio;
	
END$$
DELIMITER ;

-- Trigger per aggiornamento ridondanza
DROP TRIGGER IF EXISTS aggiornaCostoMateriali5;
DELIMITER $$
CREATE TRIGGER aggiornaCostoMateriali5
AFTER INSERT ON Mattone
FOR EACH ROW
BEGIN
	DECLARE quantita FLOAT;
	DECLARE lavoroTarget CHAR(50);
	DECLARE codProgettoStadio CHAR(50);
	DECLARE dataInizioStadio CHAR(50);
    
	SELECT	Quantita, CodLavoro
	INTO	quantita, lavoroTarget
	FROM	Materiale
	WHERE	NomeFornitore = NEW.NomeFornitore
			AND
			CodLotto = NEW.CodLotto;

	SELECT	CodProgetto, DataInizio
	INTO	codProgettoStadio, dataInizioStadio
	FROM	Lavoro
	WHERE	CodLavoro = lavoroTarget;
    
    UPDATE 	Stadio
    SET		CostoMateriali = CostoMateriali + NEW.Costo_mq*quantita
    WHERE	DataInizio = dataInizioStadio
			AND
            CodProgetto = codProgettoStadio;
	
END$$
DELIMITER ;

/* Operazione 6 - nuovoOperaio*/
DROP PROCEDURE IF EXISTS nuovoOperaio;

DELIMITER $$

CREATE PROCEDURE nuovoOperaio (IN _codFiscOperaio CHAR(16), IN _manodopera FLOAT, IN _codFiscCapo CHAR(16))
	
    BEGIN
		
        DECLARE operaiCapo INT DEFAULT 0;
        DECLARE operaiCapoMax INT;
        
        SET operaiCapo = (
							SELECT COUNT(*) as nOperai
    						FROM Operaio
    						WHERE CapoCantiere = _codFiscCapo
						 );
                         
		SET operaiCapoMax = (
							  SELECT OperaiMax
                              FROM CapoCantiere
                              WHERE CFisc = _codFiscCapo
                            );
		
        IF (operaiCapo = operaiCapoMax) THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Il Capo Cantiere non può supervisionare altri Operai!';
		END IF;
        
        INSERT INTO Operaio
        VALUES(_codFiscOperaio, _manodopera, _codFiscCapo, 0);
        
	END $$

DELIMITER ;

/* Operazione 7 - valutaAlert*/
DROP PROCEDURE IF EXISTS valutaAlert;

DELIMITER $$

CREATE PROCEDURE valutaAlert(IN _timestamp TIMESTAMP, IN _IDSensore CHAR(50), OUT edificio_ CHAR(50), OUT piano_ INT, OUT vano_ CHAR(50), OUT parte_ VARCHAR(100), pericolosita_ FLOAT)
	
    BEGIN
    
		DECLARE soglia FLOAT;
		
		SET	edificio_ =	(
							SELECT	Edificio
                            FROM	Sensore
                            WHERE	IDSensore = _IDSensore
                        );
                        
		SET	piano_ =	(
							SELECT	Piano
                            FROM	Sensore
                            WHERE	IDSensore = _IDSensore
                        );                  
        
		SET	vano_ =	(
						SELECT	Vano
						FROM	Sensore
						WHERE	IDSensore = _IDSensore
					);
                        
		SET	parte_ =	(
							SELECT	Parte
                            FROM	Sensore
                            WHERE	IDSensore = _IDSensore
                        );
                        
		SET	soglia =	(
							SELECT	Soglia
                            FROM	Sensore
                            WHERE	IDSensore = _IDSensore
                        );
		
		SET pericolosita_ =	(
								SELECT	ValoreMisurato
								FROM	Alert
								WHERE	Timestamp = _timestamp
										AND
                                        IDSensore = _IDSensore
							) - soglia;
        
	END $$

DELIMITER ;

/* Operazione 8 - matrialiLavoro */
DROP PROCEDURE IF EXISTS materialiLavoro;

DELIMITER $$

CREATE PROCEDURE materialiLavoro(IN _codLavoro CHAR(50))
	
    BEGIN
    
		WITH MaterialiTarget AS	(
									SELECT	CodLotto, NomeFornitore, Quantita
                                    FROM	Materiale
                                    WHERE	CodLavoro = _codLavoro
								)
		(
			SELECT	M.Tipo, M.CodLotto, M.NomeFornitore, M.Quantita, CONCAT	(
																				'Tipo = ', I.Tipo, ', ',
                                                                            	'Spessore = ', I.Spessore, ', ',
                                                                            	'Costo_kg = ', I.Costo_kg
																			) AS Info
            FROM	Materiale M
					NATURAL JOIN
                    Intonaco I
        )
        UNION
		(
			SELECT	M.Tipo, M.CodLotto, M.NomeFornitore, M.Quantita, CONCAT	(
																				'Tipo = ', P.Tipo, ', ',
                                                                                'Disposizione = ', P.Disposizione, ', ',
                                                                                'Costo_kg = ', P.Costo_kg, ', ',
                                                                                IF(P.Decorativa,'Decorativa','Non Decorativa'), ', ',
																				'PesoMedio = ', P.PesoMedio, ', ',
																				'SuperficieMedia = ', P.SuperficieMedia
																			) AS Info
            FROM	Materiale M
					NATURAL JOIN
                    Pietra P        
        )
        UNION
		(
			SELECT	M.Tipo, M.CodLotto, M.NomeFornitore, M.Quantita, CONCAT	(
                                                                            	'Costo_mq = ', MA.Costo_mq, ', ',
																				'Larghezza = ', MA.Larghezza, ', ',
																				'Lunghezza = ', MA.Lunghezza, ', ',
																				'Altezza = ', MA.Altezza, ', ',
																				'Costituente = ', MA.Costituente, ', ',
																				IF(MA.Isolante,'Isolante','Non Isolante'), ', ',
																				IF(MA.Alveolato,'Alveolatura = ','Non Alveolato'), ', ',
																				IF(MA.Alveolato, MA.TipoAlveolatura, '')
																			) AS Info
            FROM	Materiale M
					NATURAL JOIN
                    Mattone MA        
        )
        UNION
		(
			SELECT	M.Tipo, M.CodLotto, M.NomeFornitore, M.Quantita, CONCAT	(
																				'TipoDisegno = ', P.TipoDisegno, ', ',
                                                                                'Costo_mq = ', P.Costo_mq, ', ',
                                                                                'Costituente = ', P.Costituente, ', ',
                                                                                'NumLati = ', P.NumLati, ', ',
                                                                                'LungLato = ', P.LungLato, ', ',
                                                                                'Fuga = ', P.Fuga, ', ',
                                                                                'Adesivo = ', P.Adesivo
																			) AS Info
            FROM	Materiale M
					NATURAL JOIN
                    Piastrella P
        )
		UNION
		(
			SELECT	M.Tipo, M.CodLotto, M.NomeFornitore, M.Quantita, CONCAT (
																				'Tipo = ', A.Tipo, ', ',
                                                                            	'Costo = ', A.Costo, ', ',
                                                                            	'Altezza = ', A.Altezza, ', ',
                                                                            	'Lunghezza = ', A.Lunghezza, ', ',
                                                                            	'Larghezza = ', A.Larghezza, ', ',
                                                                            	'Peso = ', A.Peso
																			) AS Info
            FROM	Materiale M
					NATURAL JOIN
                    Altro A        
        );

	END $$

DELIMITER ;

/* Analytics 1 - consigliIntervento*/
DROP PROCEDURE IF EXISTS consigliIntervento;

DELIMITER $$

CREATE PROCEDURE consigliIntervento(IN _codEdificio CHAR(50))
	
    BEGIN
		
        DECLARE coefficienteRischio FLOAT;
        
        DECLARE NPianiEdificio INT;
        
        SET coefficienteRischio =	(
										SELECT 	R.Coefficiente
										FROM	Rischio R
												INNER JOIN
												Edificio E	ON R.AreaGeografica = E.AreaGeografica
										WHERE	E.CodEdificio = _codEdificio
												AND
												R.Tipo = "Sismico"
												AND
												R.Data >= ALL	(
																	SELECT 	R1.Coefficiente
																	FROM	Rischio R1
																			INNER JOIN
																			Edificio E1	ON R1.AreaGeografica = E1.AreaGeografica
																	WHERE	E1.CodEdificio = _codEdificio
																			AND
																			R1.Tipo = "Sismico"
																)
									);
		
        SET NPianiEdificio =	(
									SELECT	COUNT(*)
                                    FROM	Pianta
                                    WHERE	CodEdificio = _codEdificio
								);
    
		WITH AlertTarget AS	(
								SELECT	*
								FROM	Alert A
										INNER JOIN
										Sensore S	ON S.IDSensore = A.IDSensore
								WHERE	S.CodEdificio = _codEdificio
										AND	(
												S.Tipologia = "Giroscopio" OR
												S.Tipologia = "Accelerometro" OR
												S.Tipologia = "Posizione"
											)
							),
			UltimiAlert AS 	(
								SELECT	*, 	(	
												(ABS(A1.ValoreMisurato-A1.Soglia)/A1.Soglia)*100 
												+
                                                (ABS(A1.ValoreMisurato-A1.Soglia)/A1.Soglia)*100*coefficienteRischio 
											) 	AS PDanno
                                FROM	AlertTarget A1
                                WHERE	A1.TimeStamp >= ALL	(
																SELECT	A2.TimeStamp
                                                                FROM	AlertTarget A2
																WHERE	A2.IDSensore = A1.IDSensore
															)
							)


			SELECT	A.IDVano, A.Piano,	(
											IF	( ( A.Tipologia = "Giroscopio" OR A.Tipologia = "Accelerometro") AND A.Piano < NPianiEdificio, CONCAT("Rifacimento solaio al piano",A.Piano),
											IF	( ( A.Tipologia = "Giroscopio" OR A.Tipologia = "Accelerometro") AND A.Piano = NPianiEdificio, "Rifacimento copertura",
											CONCAT("Risanamento parte ",A.Parte)))
										)	AS Consiglio,
										(
											IF	( A1.PDanno BETWEEN 1 AND 20, "60 Giorni",
                                            IF	( A1.PDanno BETWEEN 21 AND 40, "40 Giorni",
                                            IF	( A1.PDanno BETWEEN 41 AND 60, "20 Giorni",
                                            IF	( A1.PDanno BETWEEN 61 AND 80, "10 Giorni",
                                            IF	( A1.PDanno BETWEEN 81 AND 100, "3 Giorni",
                                            "Immediato")))))
                                        )	AS TempoInterventoMax
                                                
            FROM	UltimiAlert A;

	END $$

DELIMITER ;

/* Analytics 2 - stimaDanni*/
DROP PROCEDURE IF EXISTS stimaDanni;

DELIMITER $$

CREATE PROCEDURE stimaDanni(IN _codEdificio CHAR(50), IN gravita INT, OUT danni_ VARCHAR(100))
	
    BEGIN
		
        DECLARE stato FLOAT;
        DECLARE primoContributo FLOAT;
        DECLARE secondoContributo FLOAT;
        DECLARE terzoContributo FLOAT;

		SET primoContributo =	(
									SELECT	SUM( ( S.Soglia - P.Larghezza )/MONTH(P.TimeStamp) )*0.2 AS contributo
									FROM	Sensore S
											INNER JOIN
											Posizione P ON S.IDSensore = P.IDSensore
									WHERE	S.Edificio = _codEdificio
								);
                                
		SET secondoContributo =	(
									SELECT	SUM( ( S.Soglia - SQRT(POWER(G.Wx,2) + POWER(G.Wy,2) + POWER(G.Wz,2)) )/MONTH(G.TimeStamp) )*0.4 AS contributo
									FROM	Sensore S
											INNER JOIN
											Giroscopio G ON S.IDSensore = G.IDSensore
									WHERE	S.Edificio = _codEdificio  
								);
                                
		SET secondoContributo =	(
									SELECT	SUM( ( S.Soglia - SQRT(POWER(A.X,2) + POWER(A.Y,2) + POWER(A.Z,2)) )/MONTH(A.TimeStamp) )*0.4 AS contributo
									FROM	Sensore S
											INNER JOIN
											Accelerometro A ON S.IDSensore = A.IDSensore
									WHERE	S.Edificio = _codEdificio
								);
                                
		SET stato = primoContributo + secondoContributo + terzoContributo;

		IF ( stato >= 0 AND gravita BETWEEN 0 AND 5) THEN 
			SET danni_ = "Nessun danno";
		ELSEIF ( stato > 0 AND gravita BETWEEN 5 AND 10)THEN
			SET danni_ = "Danni lievi";
		ELSEIF ( stato <= 0 AND gravita BETWEEN 0 AND 5) THEN
			SET danni_ = "Danni moderati";
		ELSEIF ( stato < 0 AND gravita BETWEEN 5 AND 10) THEN
			SET danni_ = "Danni ingenti";
		ELSE
			SET danni_ = "Si e' verificato un errore.";
        END IF;
	END $$

DELIMITER ;

