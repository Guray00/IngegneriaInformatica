USE Azienda;

-- OPERAZIONE 1: CREAZIONE ACCOUNT

DROP PROCEDURE IF EXISTS CreaAccount;
DELIMITER $$
CREATE PROCEDURE CreaAccount (IN _nomeutente VARCHAR(50), IN _password VARCHAR(50), IN _domandasicurezza VARCHAR(100), IN _risposta VARCHAR(50), 
							  IN _codfiscale VARCHAR(50), IN _nome VARCHAR(50), IN _cognome VARCHAR(50), IN _telefono BIGINT(8), IN _cap INT, IN _via VARCHAR(50), 
							  IN _numero INT, IN _numdocumento INT, IN _tipologia VARCHAR(50), IN _datascadenza DATE, IN _enterilascio VARCHAR(50))
BEGIN
	-- CONTROLLO SE IL DOCUMENTO E' SCADUTO
	IF 
		(_datascadenza < CURRENT_DATE)
    THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Errore. È necessario fornire un documento valido per creare un account.';
		
    ELSE
		INSERT INTO Documento (NumDocumento, Tipologia, DataScadenza, EnteRilascio)
		VALUES  (_numdocumento, _tipologia, _datascadenza, _enterilascio);
        
        INSERT INTO Utente (CodFiscale, Nome, Cognome, Telefono, Numero, Via, Cap, Documento)
		VALUES	(_codfiscale, _nome, _cognome, _telefono, _numero, _via, _cap, _numdocumento);
        
        INSERT INTO Account (NomeUtente, Password, DomandaSicurezza, Risposta, Timestamp, CodFiscale)
		VALUES  (_nomeutente, _password, _domandasicurezza, _risposta, current_timestamp(), _codfiscale);
	END IF;
END $$
DELIMITER ;

-- CALL CreaAccount ('HMS', 'heatmysheet', 'Quali sono i tuoi pronomi?', 'she/her', 'VRSLSN21T28A390D', 'Alessandro', 'Versari', 
-- 					 '3925804720', 58129, 'Via Graniglio Incapo', 9, 123555, 'Porto d''Armi', '2026-05-12', 'Accademia Stormtrooper');

-- SELECT * FROM Account A INNER JOIN Utente U ON A.CodFiscale=U.CodFiscale INNER JOIN Documento D ON D.NumDocumento=U.Documento;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- OPERAZIONE 2: DATO L'ID DI UN ORDINE TROVARNE LA SPESA
-- L'OPERAZIONE DIVENTA ESTREMAMENTE BANALE A CAUSA DELLA RIDONDANZA INTRODOTTA

DROP PROCEDURE IF EXISTS SpesaOrdine;
DELIMITER $$
CREATE PROCEDURE SpesaOrdine (IN _codordine INT)
BEGIN
	SELECT CodOrdine, Spesa
    FROM Ordine
    WHERE CodOrdine=_codordine;
END $$
DELIMITER ;

-- MA QUESTA PROCEDURA FUNZIONA SOLO GRAZIE AL SEGUENTE TRIGGER:

DROP TRIGGER IF EXISTS CalcoloSpesa;
DELIMITER $$
CREATE TRIGGER CalcoloSpesa
AFTER UPDATE ON Unita
FOR EACH ROW
BEGIN
	DECLARE spesa_articoli FLOAT;
    DECLARE spesa_garanzia FLOAT;
    
    SET spesa_articoli = 
		(SELECT SUM(IFNULL(V.Prezzo,0))
        FROM Variante V INNER JOIN Unita U ON V.CodVariante=U.Variante INNER JOIN Ordine O ON O.CodOrdine=U.Acquisto
        WHERE U.Acquisto=NEW.Acquisto);
	
    SET spesa_garanzia = 
		(SELECT SUM(IFNULL(G.Costo,0))
        FROM Garanzia G INNER JOIN Unita U ON G.IDformula=U.Garanzia INNER JOIN Ordine O ON O.CodOrdine=U.Acquisto
        WHERE U.Acquisto=NEW.Acquisto);
        
	UPDATE Ordine 
    SET Spesa = spesa_articoli + spesa_garanzia
    WHERE CodOrdine=NEW.Acquisto;
END $$
DELIMITER ;

/*INSERT INTO Ordine (Timestamp, Stato, Spesa, Numero, Via, CAP, Cliente)
VALUES (current_timestamp(), 'Evaso', NULL, 4, 'Via De Angelis', 59260, 4);

UPDATE Unita 
SET Acquisto=5, Garanzia=1
WHERE (CodSeriale=5);

SELECT * FROM Ordine;*/


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- OPERAZIONE 3: TROVARE I PRODOTTI PIU' DIFETTOSI, QUELLI CIOE' MAGGIORMENTE SOTTOPOSTI A ASSISTENZE FISICHE

DROP PROCEDURE IF EXISTS ProdottiDifettosi;
DELIMITER $$
CREATE PROCEDURE ProdottiDifettosi ()
BEGIN
	SELECT P.Marca, P.Nome, P.Modello, COUNT(A.Codice) AS Guasti
    FROM Prodotto P INNER JOIN Variante V ON P.CodProdotto=V.Prodotto
    INNER JOIN Unita U ON V.CodVariante=U.Variante
    INNER JOIN AssistenzaFisica A ON U.CodSeriale=A.Unita
    GROUP BY P.CodProdotto
    ORDER BY Guasti DESC;
END $$
DELIMITER ;
	
/*    SELECT P.Marca, P.Nome, P.Modello, A.Codice
    FROM Prodotto P INNER JOIN Variante V ON P.CodProdotto=V.Prodotto
	INNER JOIN Unita U ON V.CodVariante=U.Variante
    INNER JOIN AssistenzaFisica A ON U.CodSeriale=A.Unita;*/
    
-- CALL ProdottiDifettosi;


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- OPERAZIONE 4: DATO UN CODICE DI ERRORE, TROVARE IL GUASTO A CUI SI RIFERISCE E I SUOI POSSIBILI RIMEDI

DROP PROCEDURE IF EXISTS ErroreRilevato;
DELIMITER $$
CREATE PROCEDURE ErroreRilevato (IN _coderrore INT)
BEGIN
	SELECT G.Nome, R.Descrizione
    FROM Guasto G INNER JOIN Errore E ON G.CodGuasto=E.Guasto
    INNER JOIN Rimedio R ON R.Errore=E.CodErrore
    WHERE E.CodErrore=_coderrore;
END $$
DELIMITER ;

/*SELECT *
FROM Guasto G INNER JOIN Errore E ON G.CodGuasto=E.Guasto
INNER JOIN Rimedio R ON R.Errore=E.CodErrore
WHERE E.CodErrore=2;*/

-- CALL ErroreRilevato(2);


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- OPERAZIONE 5: CALCOLARE LA IL PUNTEGGIO MEDIO TOTALE DI TUTTE LE RECENSIONI DI UN DATO PRODOTTO

DROP PROCEDURE IF EXISTS MediaRecensioni;
DELIMITER $$
CREATE PROCEDURE MediaRecensioni (IN _codprodotto INT)
BEGIN
	DECLARE _servizio FLOAT;
    DECLARE _qualita FLOAT;
    DECLARE _prezzo FLOAT;
    DECLARE _risultato FLOAT(2,1);
    
	SELECT AVG(R.Servizio), AVG(R.Qualita), AVG(R.Prezzo) INTO _servizio, _qualita, _prezzo
	FROM Recensione R INNER JOIN Unita U ON U.CodSeriale=R.Unita
	INNER JOIN Variante V ON V.CodVariante=U.Variante
	INNER JOIN Prodotto P ON P.CodProdotto=V.Prodotto
	WHERE CodProdotto=_codprodotto;

    SET _risultato = ((_servizio + _qualita + _prezzo) /3);
    
    SELECT Marca, Nome, Modello, _risultato AS Punteggio
    FROM Prodotto
    WHERE CodProdotto=_codprodotto;
END $$
DELIMITER ;

-- CALL MediaRecensioni(2);

/*SELECT P.Marca, P.Nome, P.Modello, R.Servizio, R.Qualita, R.Prezzo
FROM Recensione R INNER JOIN Unita U ON U.CodSeriale=R.Unita
INNER JOIN Variante V ON V.CodVariante=U.Variante
INNER JOIN Prodotto P ON P.CodProdotto=V.Prodotto
WHERE P.CodProdotto=2;*/


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- OPERAZIONE 6: PER OGNI PRODOTTO ACQUISTATO ALMENO UNA VOLTA, TROVARE LA SUA VARIANTE PIU' VENDUTA

DROP PROCEDURE IF EXISTS VariantePiuVenduta;
DELIMITER $$
CREATE PROCEDURE VariantePiuVenduta ()
BEGIN
	WITH MostVenduti AS
		(SELECT P.CodProdotto, P.Marca, P.Nome, P.Modello, V.CodVariante, COUNT(*) AS Vendite
		FROM Prodotto P INNER JOIN Variante V ON P.CodProdotto=V.Prodotto
		INNER JOIN Unita U ON U.Variante=V.CodVariante
		WHERE U.Acquisto IS NOT NULL
		GROUP BY V.CodVariante)
		
	SELECT M.Marca, M.Nome, M.Modello, M.CodVariante
	FROM MostVenduti M
	WHERE M.Vendite =
		(SELECT MAX(M1.Vendite)
		FROM MostVenduti M1
		WHERE M1.CodProdotto=M.CodProdotto);
END $$
DELIMITER ;

/*SELECT P.Marca, P.Nome, P.Modello, V.CodVariante, COUNT(*) AS Vendite
FROM Prodotto P INNER JOIN Variante V ON P.CodProdotto=V.Prodotto
INNER JOIN Unita U ON U.Variante=V.CodVariante
WHERE U.Acquisto IS NOT NULL
GROUP BY V.CodVariante;*/

-- CALL VariantePiuVenduta;


-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- OPERAZIONE 7: FARE UNA CLASSIFICA DEI PRODOTTI PIU INSODDISFACENTI, CIOE' QUELLI PIU' SPESSO RESI PER DIRITTO DI RECESSO
DROP PROCEDURE IF EXISTS ClassificaInsoddisfacenti;
DELIMITER $$
CREATE PROCEDURE ClassificaInsoddisfacenti ()
BEGIN
	WITH ResiPerRecesso AS
		(SELECT P.Marca, P.Nome, P.Modello, COUNT(*) AS ResiRecesso
		FROM Prodotto P INNER JOIN Variante V ON P.CodProdotto=V.Prodotto
		INNER JOIN Unita U ON U.Variante=V.CodVariante
		INNER JOIN Reso R ON R.Unita=U.CodSeriale
		WHERE R.Motivo=1
		GROUP BY P.CodProdotto)

	SELECT Marca, Nome, Modello, RANK() OVER (ORDER BY ResiRecesso DESC) Classifica
	FROM ResiPerRecesso;
END $$
DELIMITER ;

/*SELECT P.Marca, P.Nome, P.Modello, COUNT(*) AS ResiRecesso
FROM Prodotto P INNER JOIN Variante V ON P.CodProdotto=V.Prodotto
INNER JOIN Unita U ON U.Variante=V.CodVariante
INNER JOIN Reso R ON R.Unita=U.CodSeriale
WHERE R.Motivo=1
GROUP BY P.CodProdotto;*/

-- CALL ClassificaInsoddisfacenti;


-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- OPERAZIONE 8: PER OGNI LOTTO, INDICARE LA PERCENTUALE DI VENDITA, CIOE' QUANTE DELLE UNITA' DEL LOTTO SONO STATE VENDUTE IN PERCENTUALE

DROP PROCEDURE IF EXISTS VenditaLottoPercentuale;
DELIMITER $$
CREATE PROCEDURE VenditaLottoPercentuale ()
BEGIN
	WITH VenditePerLotto AS
		(SELECT L.CodiceLotto, COUNT(*) AS Vendite 
		FROM Lotto L INNER JOIN Unita U ON U.Lotto=L.CodiceLotto
		WHERE U.Acquisto IS NOT NULL
		GROUP BY L.CodiceLotto)
		
	SELECT L.CodiceLotto, ((V.Vendite / L.Quantita) * 100) AS 'Vendita(%)'
	FROM Lotto L INNER JOIN VenditePerLotto V ON V.CodiceLotto=L.CodiceLotto;
END $$
DELIMITER ;

/*SELECT L.CodiceLotto, L.Quantita, COUNT(*) AS Vendite 
FROM Lotto L INNER JOIN Unita U ON U.Lotto=L.CodiceLotto
WHERE U.Acquisto IS NOT NULL
GROUP BY L.CodiceLotto;*/

-- CALL VenditaLottoPercentuale;


-- MA QUESTA PROCEDURA FUNZIONA SOLO PERCHE' SAPPIAMO A PRIORI LA QUANTITA' DI OGNI LOTTO GRAZIE AL SEGUENTE TRIGGER:

DROP TRIGGER IF EXISTS CalcoloQuantitaLotto;
DELIMITER $$
CREATE TRIGGER CalcoloQuantitaLotto
AFTER INSERT ON Unita
FOR EACH ROW
BEGIN
	UPDATE Lotto
    SET Quantita = Quantita + 1
    WHERE CodiceLotto=NEW.Lotto;
END $$
DELIMITER ;

/*INSERT INTO Lotto (Tipo, SedeProduzione, DataProduzione, DurataPreventiva, DurataEffettiva, Categoria, Sequenza, Magazzino, Settore, DataStock, DataRilascio, Prodotto, Quantita)
VALUES ('Prodotto', 'Milano', '2021-09-09', 10, 10, NULL, 1, 1, 'B9', '2021-10-09', NULL, 1, DEFAULT);

INSERT INTO Unita (Variante, Garanzia, Lotto, Acquisto)
VALUES	('S8 8Gb ram', NULL, 4, NULL),
        ('S8 8Gb ram', NULL, 4, NULL),
        ('S8 8Gb ram', NULL, 4, NULL),
        ('S8 8Gb ram', NULL, 4, NULL),
        ('S8 8Gb ram', NULL, 4, NULL),
        ('S8 8Gb ram', NULL, 4, NULL);

SELECT CodiceLotto, Quantita
FROM Lotto
WHERE CodiceLotto=4;*/

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
