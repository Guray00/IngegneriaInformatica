-- Lorenzo Leoncini, Giulio Zingrillo. Progetto di Basi di Dati 2023

-- Questo script definisce i trigger che implementano i vincoli del database.


-- Vincoli intrarelazionali di dominio
-- Numero Carta di Credito
USE plz;
DROP TRIGGER IF EXISTS int_pos_abbonamento;

DELIMITER $$

CREATE TRIGGER int_pos_abbonamento
BEFORE INSERT ON Abbonamento FOR EACH ROW
BEGIN
  IF NEW.Tariffa < 0 OR NEW.Durata < 0 OR NEW.MaxOre < 0 OR NEW.EtaMinima < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_artista;

DELIMITER $$

CREATE TRIGGER int_pos_artista
BEFORE INSERT ON Artista FOR EACH ROW
BEGIN
  IF NEW.Id < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_contenuto;

DELIMITER $$

CREATE TRIGGER int_pos_contenuto
BEFORE INSERT ON Contenuto FOR EACH ROW
BEGIN
  IF NEW.Id < 0 OR NEW.Dimensione < 0 OR NEW.Lunghezza < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_critico;

DELIMITER $$

CREATE TRIGGER int_pos_critico
BEFORE INSERT ON Critico FOR EACH ROW
BEGIN
  IF NEW.Id < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_dispositivo;

DELIMITER $$

CREATE TRIGGER int_pos_dispositivo
BEFORE INSERT ON Dispositivo FOR EACH ROW
BEGIN
  IF NEW.Id < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_erogazione;

DELIMITER $$

CREATE TRIGGER int_pos_erogazione
BEFORE INSERT ON Erogazione FOR EACH ROW
BEGIN
  IF NEW.Id < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_fattura;

DELIMITER $$

CREATE TRIGGER int_pos_fattura
BEFORE INSERT ON Fattura FOR EACH ROW
BEGIN
  IF NEW.Id < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_film;

DELIMITER $$

CREATE TRIGGER int_pos_film
BEFORE INSERT ON Film FOR EACH ROW
BEGIN
  IF NEW.Id < 0 OR NEW.Durata < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_formatoaudio;

DELIMITER $$

CREATE TRIGGER int_pos_formatoaudio
BEFORE INSERT ON FormatoAudio FOR EACH ROW
BEGIN
  IF NEW.Codice < 0 OR NEW.Bitrate < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_formatovideo;

DELIMITER $$

CREATE TRIGGER int_pos_formatovideo
BEFORE INSERT ON FormatoVideo FOR EACH ROW
BEGIN
  IF NEW.Codice < 0 OR NEW.Bitrate < 0 OR NEW.Risoluzione < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_formatovideo;

DELIMITER $$

CREATE TRIGGER int_pos_formatovideo
BEFORE INSERT ON FormatoVideo FOR EACH ROW
BEGIN
  IF NEW.Codice < 0 OR NEW.Bitrate < 0 OR NEW.Risoluzione < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_premio;

DELIMITER $$

CREATE TRIGGER int_pos_premio
BEFORE INSERT ON Premio FOR EACH ROW
BEGIN
  IF NEW.Id < 0 OR NEW.Anno < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_premio;

DELIMITER $$

CREATE TRIGGER int_pos_premio
BEFORE INSERT ON Premio FOR EACH ROW
BEGIN
  IF NEW.Id < 0 OR NEW.Anno < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_server;

DELIMITER $$

CREATE TRIGGER int_pos_server
BEFORE INSERT ON Server FOR EACH ROW
BEGIN
  IF NEW.Id < 0 OR NEW.LarghezzaBanda < 0 OR NEW.CapacitaMax < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS int_pos_utente;

DELIMITER $$

CREATE TRIGGER int_pos_utente
BEFORE INSERT ON Utente FOR EACH ROW
BEGIN
  IF NEW.Codice < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS data_post_connessione;

DELIMITER $$

CREATE TRIGGER data_post_connessione
BEFORE INSERT ON Connessione FOR EACH ROW
BEGIN
  IF NEW.Inizio < '2022-09-15' OR NEW.Fine < '2022-09-15' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS data_post_erogazione;

DELIMITER $$

CREATE TRIGGER data_post_erogazione
BEFORE INSERT ON Erogazione FOR EACH ROW
BEGIN
  IF NEW.Inizio < '2022-09-15' OR NEW.Fine < '2022-09-15' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS data_post_fattura;

DELIMITER $$

CREATE TRIGGER data_post_fattura
BEFORE INSERT ON Fattura FOR EACH ROW
BEGIN
  IF NEW.Saldo < '2022-09-15' OR NEW.Emissione < '2022-09-15' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS data_post_recensionecritico;

DELIMITER $$

CREATE TRIGGER data_post_recensionecritico
BEFORE INSERT ON RecensioneCritico FOR EACH ROW
BEGIN
  IF NEW.Data < '2022-09-15' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS data_post_recensioneutente;

DELIMITER $$

CREATE TRIGGER data_post_recensioneutente
BEFORE INSERT ON RecensioneUtente FOR EACH ROW
BEGIN
  IF NEW.Data < '2022-09-15' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS data_post_utente;

DELIMITER $$

CREATE TRIGGER data_post_utente
BEFORE INSERT ON Utente FOR EACH ROW
BEGIN
  IF NEW.Inizio < '2022-09-15' OR NEW.DataNascita > CURRENT_DATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS pos_paese;

DELIMITER $$

CREATE TRIGGER pos_paese
BEFORE INSERT ON Paese FOR EACH ROW
BEGIN
  IF NEW.Latitudine < -100 OR NEW.Latitudine > 100 OR NEW.Longitudine < -100 OR NEW.Longitudine > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS pos_server;

DELIMITER $$

CREATE TRIGGER pos_server
BEFORE INSERT ON Server FOR EACH ROW
BEGIN
  IF NEW.Latitudine < -100 OR NEW.Latitudine > 100 OR NEW.Longitudine < -100 OR NEW.Longitudine > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dati inseriti non validi';
  END IF;
END $$
DELIMITER ;

-- Attributi interi con particolari vincoli di dominio
DROP TRIGGER IF EXISTS numero_carta;

DELIMITER $$

CREATE TRIGGER numero_carta
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
BEGIN
  IF NEW.Numero < 1000000000000000 OR NEW.Numero > 9999999999999999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Numero Carta di Credito non valido';
  END IF;

END $$
DELIMITER ;

-- CVV Carta di Credito
DROP TRIGGER IF EXISTS cvv_carta;

DELIMITER $$

CREATE TRIGGER cvv_carta
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
BEGIN
  IF NEW.CVV < 100 OR NEW.CVV > 999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'CVV Carta di Credito non valido';
  END IF;

END $$
DELIMITER ;

-- Mese di Scadenza Carta di Credito
DROP TRIGGER IF EXISTS mesescadenza_carta;

DELIMITER $$

CREATE TRIGGER mesescadenza_carta
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
BEGIN
  IF NEW.MeseScadenza < 1 OR NEW.MeseScadenza > 12 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Mese di Scadenza Carta di Credito non valido';
  END IF;

END $$
DELIMITER ;

-- Anno di Scadenza Carta di Credito
DROP TRIGGER IF EXISTS annoscadenza_carta;

DELIMITER $$

CREATE TRIGGER annoscadenza_carta
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
BEGIN
  IF NEW.AnnoScadenza < 2023 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Anno di Scadenza Carta di Credito non valido';
  END IF;

END $$
DELIMITER ;

-- IP Connessione
DROP TRIGGER IF EXISTS ip_connessione;

DELIMITER $$

CREATE TRIGGER ip_connessione
BEFORE INSERT ON Connessione FOR EACH ROW
BEGIN
  IF NEW.IP < 0 OR NEW.IP > 255255255255 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'IP non valido';
  END IF;

END $$
DELIMITER ;

-- Carta di Credito della Fattura
DROP TRIGGER IF EXISTS carta_fattura;

DELIMITER $$

CREATE TRIGGER carta_fattura
BEFORE INSERT ON Fattura FOR EACH ROW
BEGIN
  IF NEW.CartaDiCredito < 1000000000000000 OR NEW.CartaDiCredito > 9999999999999999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Numero Carta di Credito non valido';
  END IF;

END $$
DELIMITER ;

-- Anno Film
DROP TRIGGER IF EXISTS anno_film;

DELIMITER $$

CREATE TRIGGER anno_film
BEFORE INSERT ON Film FOR EACH ROW
BEGIN
  IF NEW.Anno < 1900 OR NEW.Anno > YEAR(CURRENT_DATE) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Anno non valido';
  END IF;

END $$
DELIMITER ;

-- Valore di importanza
DROP TRIGGER IF EXISTS valore_importanza;

DELIMITER $$

CREATE TRIGGER valore_importanza
BEFORE INSERT ON Importanza FOR EACH ROW
BEGIN
  IF NEW.Valore < 1 OR NEW.Valore > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Valore di importanza non valido';
  END IF;

END $$
DELIMITER ;

-- Inizio IP Paese
DROP TRIGGER IF EXISTS inizioip_paese;

DELIMITER $$

CREATE TRIGGER inizioip_paese
BEFORE INSERT ON Paese FOR EACH ROW
BEGIN
  IF NEW.InizioIP < 0 OR NEW.InizioIP > 255255255255 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'IP non valido';
  END IF;

END $$
DELIMITER ;

-- Fine IP Paese
DROP TRIGGER IF EXISTS fineip_paese;

DELIMITER $$

CREATE TRIGGER fineip_paese
BEFORE INSERT ON Paese FOR EACH ROW
BEGIN
  IF NEW.FineIP < 0 OR NEW.FineIP > 255255255255 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'IP non valido';
  END IF;

END $$
DELIMITER ;

-- Peso del Premio
DROP TRIGGER IF EXISTS peso_premio;

DELIMITER $$

CREATE TRIGGER peso_premio
BEFORE INSERT ON Premio FOR EACH ROW
BEGIN
  IF NEW.Peso < 0 OR NEW.Peso > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Peso non valido';
  END IF;

END $$
DELIMITER ;

-- Voto recensione del critico
DROP TRIGGER IF EXISTS voto_recensionecritico;

DELIMITER $$

CREATE TRIGGER voto_recensionecritico
BEFORE INSERT ON RecensioneCritico FOR EACH ROW
BEGIN
  IF NEW.Voto < 1 OR NEW.Voto > 5 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Voto non valido';
  END IF;

END $$
DELIMITER ;

-- Voto recensione dell'utente
DROP TRIGGER IF EXISTS voto_recensioneutente;

DELIMITER $$

CREATE TRIGGER voto_recensioneutente
BEFORE INSERT ON RecensioneUtente FOR EACH ROW
BEGIN
  IF NEW.Voto < 1 OR NEW.Voto > 5 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Voto non valido';
  END IF;

END $$
DELIMITER ;

-- Jitter del Server
DROP TRIGGER IF EXISTS jitter_server;

DELIMITER $$

CREATE TRIGGER jitter_server
BEFORE INSERT ON Server FOR EACH ROW
BEGIN
  IF NEW.Jitter < 1 OR NEW.Jitter > 10 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Jitter non valido';
  END IF;

END $$
DELIMITER ;

-- Carta di Credito dell'Utente
DROP TRIGGER IF EXISTS carta_utente;

DELIMITER $$

CREATE TRIGGER carta_utente
BEFORE INSERT ON Utente FOR EACH ROW
BEGIN
  IF NEW.CartaDiCredito < 1000000000000000 OR NEW.CartaDiCredito > 9999999999999999 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Numero Carta di Credito non valido';
  END IF;

END $$
DELIMITER ;

-- Vincoli intrarelazionali di n-upla
-- Artista(Attore) e Artista(Regista) non possono essere entrambi nulli;
DROP TRIGGER IF EXISTS artista_o_regista;

DELIMITER $$

CREATE TRIGGER artista_o_regista
BEFORE INSERT ON Artista FOR EACH ROW
BEGIN
  IF NEW.Attore = NULL AND NEW.Regista = NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Attore e Regista non possono essere entrambi nulli';
  END IF;

END $$
DELIMITER ;

-- La data definita dagli attributi CartaDiCredito(Mese) e CartaDiCredito(Anno) deve essere futura
DROP TRIGGER IF EXISTS data_carta_futura;

DELIMITER $$

CREATE TRIGGER data_carta_futura
BEFORE INSERT ON CartaDiCredito FOR EACH ROW
BEGIN
  IF NEW.AnnoScadenza < YEAR(CURRENT_DATE) OR (NEW.AnnoScadenza = YEAR(CURRENT_DATE) AND NEW.MeseScadenza <= MONTH(CURRENT_DATE)) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Carta Scaduta';
  END IF;

END $$
DELIMITER ;

-- Paese(InizioIP) deve essere minore di Paese(FineIP)
DROP TRIGGER IF EXISTS ip_paese;

DELIMITER $$

CREATE TRIGGER ip_paese
BEFORE INSERT ON Paese FOR EACH ROW
BEGIN
  IF NEW.InizioIP >= NEW.FineIP THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Paese(InizioIP) deve essere minore di Paese(FineIP)';
  END IF;

END $$
DELIMITER ;

-- Premio(Attore), Premio(Film), Premio(Regista) non possono essere tutti nulli
DROP TRIGGER IF EXISTS premio;

DELIMITER $$

CREATE TRIGGER premio
BEFORE INSERT ON Premio FOR EACH ROW
BEGIN
  IF NEW.Attore = NULL AND NEW.Film = NULL AND NEW.Regista = NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Premio(Attore), Premio(Film), Premio(Regista) non possono essere tutti nulli';
  END IF;

END $$
DELIMITER ;

-- Vincoli di integrità referenziale
-- Ogni film in Appartenenza deve comparire nella tabella Film
DROP TRIGGER IF EXISTS appartenenza_film_film;

DELIMITER $$

CREATE TRIGGER appartenenza_film_film
BEFORE INSERT ON Appartenenza FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Film F
     WHERE F.Id = NEW.Film
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni film in Appartenenza deve comparire nella tabella Film';
  END IF;

END $$
DELIMITER ;

-- Ogni contenuto in CodificaVideo deve comparire nella tabella Contenuto
DROP TRIGGER IF EXISTS codificavideo_contenuto_contenuto;

DELIMITER $$

CREATE TRIGGER codificavideo_contenuto_contenuto
BEFORE INSERT ON CodificaVideo FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Contenuto C
     WHERE C.Id = NEW.Contenuto
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni contenuto in CodificaVideo deve comparire nella tabella Contenuto';
  END IF;

END $$
DELIMITER ;

-- Ogni formato video in CodificaVideo deve comparire nella tabella FormatoVideo
DROP TRIGGER IF EXISTS codificavideo_formatovideo_formatovideo;

DELIMITER $$

CREATE TRIGGER codificavideo_formatovideo_formatovideo
BEFORE INSERT ON CodificaVideo FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM FormatoVideo F
     WHERE F.Codice = NEW.FormatoVideo
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni formato video in CodificaVideo deve comparire nella tabella FormatoVideo';
  END IF;

END $$
DELIMITER ;

-- Ogni dispositivo nella tabella Connessione deve comparire nella tabella Dispositivo
DROP TRIGGER IF EXISTS connessione_dispositivo_dispositivo;

DELIMITER $$

CREATE TRIGGER connessione_dispositivo_dispositivo
BEFORE INSERT ON Connessione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Dispositivo D
     WHERE D.Id = NEW.Dispositivo
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni dispositivo nella tabella Connessione deve comparire nella tabella Dispositivo';
  END IF;

END $$
DELIMITER ;

-- Ogni utente nella tabella Connessione deve comparire nella tabella Utente
DROP TRIGGER IF EXISTS connessione_utente_utente;

DELIMITER $$

CREATE TRIGGER connessione_utente_utente
BEFORE INSERT ON Connessione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Utente U
     WHERE U.Codice = NEW.Utente
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni utente nella tabella Connessione deve comparire nella tabella Utente';
  END IF;

END $$
DELIMITER ;

-- Ogni film nella tabella Contenuto deve comparire nella tabella Film
DROP TRIGGER IF EXISTS contenuto_film_film;

DELIMITER $$

CREATE TRIGGER contenuto_film_film
BEFORE INSERT ON Contenuto FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Film F
     WHERE F.Id = NEW.Film
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni film nella tabella Contenuto deve comparire nella tabella Film';
  END IF;

END $$
DELIMITER ;

-- Ogni codifica audio nella tabella Contenuto deve comparire nella tabella FormatoAudio
DROP TRIGGER IF EXISTS contenuto_codificaaudio_formatoaudio;

DELIMITER $$

CREATE TRIGGER contenuto_codificaaudio_formatoaudio
BEFORE INSERT ON Contenuto FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM FormatoAudio F
     WHERE F.Codice = NEW.CodificaAudio
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni codifica audio nella tabella Contenuto deve comparire nella tabella FormatoAudio';
  END IF;

END $$
DELIMITER ;

-- Ogni film nella tabella Direzione deve comparire nella tabella Film
DROP TRIGGER IF EXISTS direzione_film_film;

DELIMITER $$

CREATE TRIGGER direzione_film_film
BEFORE INSERT ON Direzione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Film F
     WHERE F.Id = NEW.Film
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni film nella tabella Direzione deve comparire nella tabella Film';
  END IF;

END $$
DELIMITER ;

-- Ogni artista nella tabella Direzione deve comparire nella tabella Artista
DROP TRIGGER IF EXISTS direzione_artista_artista;

DELIMITER $$

CREATE TRIGGER direzione_artista_artista
BEFORE INSERT ON Direzione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Artista A
     WHERE A.Id = NEW.Artista
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni artista nella tabella Direzione deve comparire nella tabella Artista';
  END IF;

END $$
DELIMITER ;

-- Ogni contenuto nella tabella Erogazione deve comparire nella tabella Contenuto
DROP TRIGGER IF EXISTS erogazione_contenuto_contenuto;

DELIMITER $$

CREATE TRIGGER erogazione_contenuto_contenuto
BEFORE INSERT ON Erogazione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Contenuto C
     WHERE C.Id = NEW.Contenuto
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni contenuto nella tabella Erogazione deve comparire nella tabella Contenuto';
  END IF;

END $$
DELIMITER ;

-- Ogni server nella tabella Erogazione deve comparire nella tabella Server
DROP TRIGGER IF EXISTS erogazione_server_server;

DELIMITER $$

CREATE TRIGGER erogazione_server_server
BEFORE INSERT ON Erogazione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Server S
     WHERE S.Id = NEW.Server
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni server nella tabella Erogazione deve comparire nella tabella Server';
  END IF;

END $$
DELIMITER ;

-- Ogni timestamp di inizio connessione nella tabella Erogazione deve comparire nella tabella Connessione
DROP TRIGGER IF EXISTS erogazione_inizioconnessione_connessione;

DELIMITER $$

CREATE TRIGGER erogazione_inizioconnessione_connessione
BEFORE INSERT ON Erogazione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Connessione C
     WHERE C.Inizio = NEW.InizioConnessione
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni timestamp di inizio connessione nella tabella Erogazione deve comparire nella tabella Connessione';
  END IF;

END $$
DELIMITER ;

-- Ogni dispositivo nella tabella Erogazione deve comparire nella tabella Dispositivo
DROP TRIGGER IF EXISTS erogazione_dispositivo_dispositivo;

DELIMITER $$

CREATE TRIGGER erogazione_dispositivo_dispositivo
BEFORE INSERT ON Erogazione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Dispositivo D
     WHERE D.Id = NEW.Dispositivo
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni dispositivo nella tabella Erogazione deve comparire nella tabella Dispositivo';
  END IF;

END $$
DELIMITER ;

-- Ogni utente nella tabella Fattura deve comparire nella tabella Utente
DROP TRIGGER IF EXISTS fattura_utente_utente;

DELIMITER $$

CREATE TRIGGER fattura_utente_utente
BEFORE INSERT ON Fattura FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Utente U
     WHERE U.Codice = NEW.Utente
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni utente nella tabella Fattura deve comparire nella tabella Utente';
  END IF;

END $$
DELIMITER ;

-- Ogni carta di credito nella tabella Fattura deve comparire nella tabella CartaDiCredito
DROP TRIGGER IF EXISTS fattura_cartadicredito_cartadicredito;

DELIMITER $$

CREATE TRIGGER fattura_cartadicredito_cartadicredito
BEFORE INSERT ON Fattura FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM CartaDiCredito C
     WHERE C.Numero = NEW.CartaDiCredito
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni carta di credito nella tabella Fattura deve comparire nella tabella CartaDiCredito';
  END IF;

END $$
DELIMITER ;

-- Ogni abbonamento nella tabella Fattura deve comparire nella tabella Abbonamento
DROP TRIGGER IF EXISTS fattura_abbonamento_abbonamento;

DELIMITER $$

CREATE TRIGGER fattura_abbonamento_abbonamento
BEFORE INSERT ON Fattura FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Abbonamento A
     WHERE A.Nome = NEW.Abbonamento
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni abbonamento nella tabella Fattura deve comparire nella tabella Abbonamento';
  END IF;

END $$
DELIMITER ;

-- Ogni paese nella tabella Film deve comparire nella tabella Paese
DROP TRIGGER IF EXISTS film_paese_paese;

DELIMITER $$

CREATE TRIGGER film_paese_paese
BEFORE INSERT ON Film FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Paese P
     WHERE P.Nome = NEW.Paese
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni paese nella tabella Film deve comparire nella tabella Paese';
  END IF;

END $$
DELIMITER ;

-- Ogni utente nella tabella Importanza deve comparire nella tabella Utente
DROP TRIGGER IF EXISTS importanza_utente_utente;

DELIMITER $$

CREATE TRIGGER importanza_utente_utente
BEFORE INSERT ON Importanza FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Utente U
     WHERE U.Codice = NEW.Utente
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni utente nella tabella Importanza deve comparire nella tabella Utente';
  END IF;

END $$
DELIMITER ;

-- Ogni artista nella tabella Interpretazione deve comparire nella tabella Artista
DROP TRIGGER IF EXISTS interpretazione_artista_artista;

DELIMITER $$

CREATE TRIGGER interpretazione_artista_artista
BEFORE INSERT ON Interpretazione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Artista A
     WHERE A.Id = NEW.Artista
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni artista nella tabella Interpretazione deve comparire nella tabella Artista';
  END IF;

END $$
DELIMITER ;

-- Ogni film nella tabella Interpretazione deve comparire nella tabella Film
DROP TRIGGER IF EXISTS interpretazione_film_film;

DELIMITER $$

CREATE TRIGGER interpretazione_film_film
BEFORE INSERT ON Interpretazione FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Film F
     WHERE F.Id = NEW.Film
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni film nella tabella Interpretazione deve comparire nella tabella Film';
  END IF;

END $$
DELIMITER ;

-- Ogni abbonamento nella tabella OffertaContenuto deve comparire nella tabella Abbonamento
DROP TRIGGER IF EXISTS offertacontenuto_abbonamento_abbonamento;

DELIMITER $$

CREATE TRIGGER offertacontenuto_abbonamento_abbonamento
BEFORE INSERT ON OffertaContenuto FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Abbonamento A
     WHERE A.Nome = NEW.Abbonamento
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni abbonamento nella tabella OffertaContenuto deve comparire nella tabella Abbonamento';
  END IF;

END $$
DELIMITER ;

-- Ogni contenuto nella tabella OffertaContenuto deve comparire nella tabella Contenuto
DROP TRIGGER IF EXISTS offertacontenuto_contenuto_contenuto;

DELIMITER $$

CREATE TRIGGER offertacontenuto_contenuto_contenuto
BEFORE INSERT ON OffertaContenuto FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Contenuto C
     WHERE C.Id = NEW.Contenuto
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni contenuto nella tabella OffertaContenuto deve comparire nella tabella Contenuto';
  END IF;

END $$
DELIMITER ;

-- Ogni abbonamento nella tabella OffertaFunzionalità deve comparire nella tabella Abbonamento
DROP TRIGGER IF EXISTS offertafunzionalità_abbonamento_abbonamento;

DELIMITER $$

CREATE TRIGGER offertafunzionalità_abbonamento_abbonamento
BEFORE INSERT ON OffertaFunzionalita FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Abbonamento A
     WHERE A.Nome = NEW.Abbonamento
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni abbonamento nella tabella OffertaFunzionalità deve comparire nella tabella Abbonamento';
  END IF;

END $$
DELIMITER ;

-- Ogni contenuto nella tabella PossessoServer deve comparire nella tabella Contenuto
DROP TRIGGER IF EXISTS possessoserver_contenuto_contenuto;

DELIMITER $$

CREATE TRIGGER possessoserver_contenuto_contenuto
BEFORE INSERT ON PossessoServer FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Contenuto C
     WHERE C.Id = NEW.Contenuto
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni contenuto nella tabella PossessoServer deve comparire nella tabella Contenuto';
  END IF;

END $$
DELIMITER ;

-- Ogni server nella tabella PossessoServer deve comparire nella tabella Server
DROP TRIGGER IF EXISTS possessoserver_server_server;

DELIMITER $$

CREATE TRIGGER possessoserver_server_server
BEFORE INSERT ON PossessoServer FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Server S
     WHERE S.Id = NEW.Server
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni server nella tabella PossessoServer deve comparire nella tabella Server';
  END IF;

END $$
DELIMITER ;

-- Ogni artista nella tabella PremiazioneAttore deve comparire nella tabella Artista
DROP TRIGGER IF EXISTS premiazioneattore_artista_artista;

DELIMITER $$

CREATE TRIGGER premiazioneattore_artista_artista
BEFORE INSERT ON PremiazioneAttore FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Artista A
     WHERE A.Id = NEW.Attore
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni artista nella tabella PremiazioneAttore deve comparire nella tabella Artista';
  END IF;

END $$
DELIMITER ;

-- Ogni premio nella tabella PremiazioneAttore deve comparire nella tabella Premio
DROP TRIGGER IF EXISTS premiazioneattore_premio_premio;

DELIMITER $$

CREATE TRIGGER premiazioneattore_premio_premio
BEFORE INSERT ON PremiazioneAttore FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Premio P
     WHERE P.Id = NEW.Premio
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni premio nella tabella PremiazioneAttore deve comparire nella tabella Premio';
  END IF;

END $$
DELIMITER ;

-- Ogni film nella tabella PremiazioneFilm deve comparire nella tabella Film
DROP TRIGGER IF EXISTS premiazionefilm_film_film;

DELIMITER $$

CREATE TRIGGER premiazionefilm_film_film
BEFORE INSERT ON PremiazioneFilm FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Film F
     WHERE F.Id = NEW.Film
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni film nella tabella PremiazioneFilm deve comparire nella tabella Film';
  END IF;

END $$
DELIMITER ;

-- Ogni premio nella tabella PremiazioneFilm deve comparire nella tabella Premio
DROP TRIGGER IF EXISTS premiazionefilm_premio_premio;

DELIMITER $$

CREATE TRIGGER premiazionefilm_premio_premio
BEFORE INSERT ON PremiazioneFilm FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Premio P
     WHERE P.Id = NEW.Premio
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni premio nella tabella PremiazioneFilm deve comparire nella tabella Premio';
  END IF;

END $$
DELIMITER ;

-- Ogni artista nella tabella PremiazioneRegista deve comparire nella tabella Artista
DROP TRIGGER IF EXISTS premiazioneregista_artista_artista;

DELIMITER $$

CREATE TRIGGER premiazioneregista_artista_artista
BEFORE INSERT ON PremiazioneRegista FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Artista A
     WHERE A.Id = NEW.Regista
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni artista nella tabella PremiazioneRegista deve comparire nella tabella Artista';
  END IF;

END $$
DELIMITER ;

-- Ogni premio nella tabella PremiazioneRegista deve comparire nella tabella Premio
DROP TRIGGER IF EXISTS premiazioneregista_premio_premio;

DELIMITER $$

CREATE TRIGGER premiazioneregista_premio_premio
BEFORE INSERT ON PremiazioneRegista FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Premio P
     WHERE P.Id = NEW.Premio
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni premio nella tabella PremiazioneRegista deve comparire nella tabella Premio';
  END IF;

END $$
DELIMITER ;

-- Ogni critico nella tabella RecensioneCritico deve comparire nella tabella Critico
DROP TRIGGER IF EXISTS recensionecritico_critico_critico;

DELIMITER $$

CREATE TRIGGER recensionecritico_critico_critico
BEFORE INSERT ON RecensioneCritico FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Critico C
     WHERE C.Id = NEW.Critico
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni critico nella tabella RecensioneCritico deve comparire nella tabella Critico';
  END IF;

END $$
DELIMITER ;

-- Ogni film nella tabella RecensioneCritico deve comparire nella tabella Film
DROP TRIGGER IF EXISTS recensionecritico_film_film;

DELIMITER $$

CREATE TRIGGER recensionecritico_film_film
BEFORE INSERT ON RecensioneCritico FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Film F
     WHERE F.Id = NEW.Film
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni film nella tabella RecensioneCritico deve comparire nella tabella Film';
  END IF;

END $$
DELIMITER ;

-- Ogni utente nella tabella RecensioneUtente deve comparire nella tabella Utente
DROP TRIGGER IF EXISTS recensioneutente_utente_utente;

DELIMITER $$

CREATE TRIGGER recensioneutente_utente_utente
BEFORE INSERT ON RecensioneUtente FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Utente U
     WHERE U.Codice = NEW.Utente
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni utente nella tabella RecensioneUtente deve comparire nella tabella Utente';
  END IF;

END $$
DELIMITER ;

-- Ogni film nella tabella RecensioneUtente deve comparire nella tabella Film
DROP TRIGGER IF EXISTS recensioneutente_film_film;

DELIMITER $$

CREATE TRIGGER recensioneutente_film_film
BEFORE INSERT ON RecensioneUtente FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Film F
     WHERE F.Id = NEW.Film
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni film nella tabella RecensioneUtente deve comparire nella tabella Film';
  END IF;

END $$
DELIMITER ;

-- Ogni abbonamento nella tabella RestrizioneAbbonamento deve comparire nella tabella Abbonamento
DROP TRIGGER IF EXISTS restrizioneabbonamento_abbonamento_abbonamento;

DELIMITER $$

CREATE TRIGGER restrizioneabbonamento_abbonamento_abbonamento
BEFORE INSERT ON RestrizioneAbbonamento FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Abbonamento A
     WHERE A.Nome = NEW.Abbonamento
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni abbonamento nella tabella RestrizioneAbbonamento deve comparire nella tabella Abbonamento';
  END IF;

END $$
DELIMITER ;

-- Ogni paese nella tabella RestrizioneAbbonamento deve comparire nella tabella Paese
DROP TRIGGER IF EXISTS restrizioneabbonamento_paese_paese;

DELIMITER $$

CREATE TRIGGER restrizioneabbonamento_paese_paese
BEFORE INSERT ON RestrizioneAbbonamento FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Paese P
     WHERE P.Nome = NEW.Paese
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni paese nella tabella RestrizioneAbbonamento deve comparire nella tabella Paese';
  END IF;

END $$
DELIMITER ;

-- Ogni contenuto nella tabella RestrizioneContenuto deve comparire nella tabella Contenuto
DROP TRIGGER IF EXISTS restrizionecontenuto_contenuto_contenuto;

DELIMITER $$

CREATE TRIGGER restrizionecontenuto_contenuto_contenuto
BEFORE INSERT ON RestrizioneContenuto FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Contenuto C
     WHERE C.Id = NEW.Contenuto
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni contenuto nella tabella RestrizioneContenuto deve comparire nella tabella Contenuto';
  END IF;

END $$
DELIMITER ;

-- Ogni paese nella tabella RestrizioneContenuto deve comparire nella tabella Paese
DROP TRIGGER IF EXISTS restrizionecontenuto_paese_paese;

DELIMITER $$

CREATE TRIGGER restrizionecontenuto_paese_paese
BEFORE INSERT ON RestrizioneContenuto FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Paese P
     WHERE P.Nome = NEW.Paese
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni paese nella tabella RestrizioneContenuto deve comparire nella tabella Paese';
  END IF;

END $$
DELIMITER ;

-- Ogni contenuto nella tabella Sottotitoli deve comparire nella tabella Contenuto
DROP TRIGGER IF EXISTS sottotitoli_contenuto_contenuto;

DELIMITER $$

CREATE TRIGGER sottotitoli_contenuto_contenuto
BEFORE INSERT ON Sottotitoli FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Contenuto C
     WHERE C.Id = NEW.Contenuto
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni contenuto nella tabella Sottotitoli deve comparire nella tabella Contenuto';
  END IF;

END $$
DELIMITER ;

-- Ogni nazionalità nella tabella Utente deve comparire nella tabella Paese
DROP TRIGGER IF EXISTS utente_nazionalita_paese;

DELIMITER $$

CREATE TRIGGER utente_nazionalita_paese
BEFORE INSERT ON Utente FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp = 
    (SELECT COUNT(*)
     FROM Paese P
     WHERE P.Nome = NEW.Nazionalita
    );
  IF temp = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni nazionalità nella tabella Utente deve comparire nella tabella Paese';
  END IF;

END $$
DELIMITER ;

-- Ogni carta di credito nella tabella Utente deve comparire nella tabella CartaDiCredito
DROP TRIGGER IF EXISTS utente_cartadicredito_cartadicredito;

DELIMITER $$

CREATE TRIGGER utente_cartadicredito_cartadicredito
BEFORE INSERT ON Utente FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp =
    (SELECT COUNT(*)
     FROM CartaDiCredito C
     WHERE C.Numero= NEW.CartaDiCredito
    );
  IF temp = 0 and new.CartaDiCredito is not null THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni carta di credito nella tabella Utente deve comparire nella tabella CartaDiCredito';
  END IF;

END $$
DELIMITER ;

-- Ogni abbonamento nella tabella Utente deve comparire nella tabella Abbonamento
DROP TRIGGER IF EXISTS utente_abbonamento_abbonamento;

DELIMITER $$

CREATE TRIGGER utente_abbonamento_abbonamento
BEFORE INSERT ON Utente FOR EACH ROW
BEGIN
  DECLARE temp INT DEFAULT 0;
  SET temp =
    (SELECT COUNT(*)
     FROM Abbonamento A
     WHERE A.Nome= NEW.Abbonamento
    );
  IF temp = 0 and new.Abbonamento is not null THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ogni abbonamento nella tabella Utente deve comparire nella tabella Abbonamento';
  END IF;
END $$
DELIMITER ;
-- Altri vincoli interrelazionali
-- Un Artista può comparire nella tabella Interpretazione solo se il suo attributo Attore vale 1
DROP TRIGGER IF EXISTS interpretazione_artista_1;

DELIMITER $$

CREATE TRIGGER interpretazione_artista_1
BEFORE INSERT ON Interpretazione FOR EACH ROW
BEGIN
  DECLARE artista INT DEFAULT 0;
  SET artista = 
    (SELECT A.Attore
     FROM Artista A
     WHERE A.Id = NEW.Artista
    );
  IF artista = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Artista può comparire nella tabella Interpretazione solo se il suo attributo Attore vale 1';
  END IF;

END $$
DELIMITER ;

-- Un Artista può comparire nella tabella Direzione solo se il suo attributo Regista vale 1
DROP TRIGGER IF EXISTS direzione_regista_1;

DELIMITER $$

CREATE TRIGGER direzione_regista_1
BEFORE INSERT ON Direzione FOR EACH ROW
BEGIN
  DECLARE artista INT DEFAULT 0;
  SET artista = 
    (SELECT A.Regista
     FROM Artista A
     WHERE A.Id = NEW.Artista
    );
  IF artista = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Artista può comparire nella tabella Direzione solo se il suo attributo Regista vale 1';
  END IF;

END $$
DELIMITER ;

-- Un Artista può comparire nella tabella PremiazioneAttore solo se il suo attributo Attore vale 1
DROP TRIGGER IF EXISTS premiazione_attore_attore_1;

DELIMITER $$

CREATE TRIGGER premiazione_attore_attore_1
BEFORE INSERT ON PremiazioneAttore FOR EACH ROW
BEGIN
  DECLARE artista INT DEFAULT 0;
  SET artista = 
    (SELECT A.Attore
     FROM Artista A
     WHERE A.Id = NEW.Attore
    );
  IF artista = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Artista può comparire nella tabella PremiazioneAttore solo se il suo attributo Attore vale 1';
  END IF;

END $$
DELIMITER ;

-- Un Premio può comparire nella tabella PremiazioneAttore solo se il suo attributo Attore vale 1
DROP TRIGGER IF EXISTS premiazione_attore_premio_1;

DELIMITER $$

CREATE TRIGGER premiazione_attore_premio_1
BEFORE INSERT ON PremiazioneAttore FOR EACH ROW
BEGIN
  DECLARE premio INT DEFAULT 0;
  SET premio = 
    (SELECT P.Attore
     FROM Premio P
     WHERE P.Id = NEW.Premio
    );
  IF premio = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Premio può comparire nella tabella PremiazioneAttore solo se il suo attributo Attore vale 1';
  END IF;

END $$
DELIMITER ;

-- Un Premio può comparire nella tabella PremiazioneFilm solo se il suo attributo Film vale 1
DROP TRIGGER IF EXISTS premiazione_film_1;

DELIMITER $$

CREATE TRIGGER premiazione_film_1
BEFORE INSERT ON PremiazioneFilm FOR EACH ROW
BEGIN
  DECLARE premio INT DEFAULT 0;
  SET premio = 
    (SELECT P.Film
     FROM Premio P
     WHERE P.Id = NEW.Premio
    );
  IF premio = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Premio può comparire nella tabella PremiazioneFilm solo se il suo attributo Film vale 1';
  END IF;

END $$
DELIMITER ;

-- Un Artista può comparire nella tabella PremiazioneRegista solo se il suo attributo Regista vale 1
DROP TRIGGER IF EXISTS premiazione_regista_regista_1;

DELIMITER $$

CREATE TRIGGER premiazione_regista_regista_1
BEFORE INSERT ON PremiazioneRegista FOR EACH ROW
BEGIN
  DECLARE artista INT DEFAULT 0;
  SET artista = 
    (SELECT A.Regista
     FROM Artista A
     WHERE A.Id = NEW.Regista
    );
  IF artista = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Artista può comparire nella tabella PremiazioneRegista solo se il suo attributo Regista vale 1';
  END IF;

END $$
DELIMITER ;

-- Un Premio può comparire nella tabella PremiazioneRegista solo se il suo attributo Regista vale 1
DROP TRIGGER IF EXISTS premiazione_regista_premio_1;

DELIMITER $$

CREATE TRIGGER premiazione_regista_premio_1
BEFORE INSERT ON PremiazioneRegista FOR EACH ROW
BEGIN
  DECLARE premio INT DEFAULT 0;
  SET premio = 
    (SELECT P.Regista
     FROM Premio P
     WHERE P.Id = NEW.Premio
    );
  IF premio = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un Premio può comparire nella tabella PremiazioneRegista solo se il suo attributo Regista vale 1';
  END IF;

END $$
DELIMITER ;


-- un contenuto può comparire nella tabella CodificaVideo solo se ha l'attributo CodificaAudio nullo

drop trigger if exists codifica_video_codifica_audio;
delimiter $$
create trigger codifica_video_codifica_audio
    before insert on codificavideo
    for each row
    begin
        declare cAudio int default 0;
        select CodificaAudio into cAudio
        from contenuto
        where Id = new.Contenuto;
        if cAudio is not null then
            SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un contenuto può comparire nella tabella CodificaVideo solo se il suo attributo CodificaAudio è nullo';
        end if;
    end $$
    delimiter ;

-- Un contenuto può comparire nella tabella Sottotitoli solo se il suo attributo LinguaAudio è nullo

drop trigger if exists doppiaggio_sottotitoli;
delimiter $$
create trigger doppiaggio_sottotitoli
    before insert on sottotitoli
    for each row
    begin
        declare lAudio varchar(45) default '';
        select LinguaAudio into lAudio
        from contenuto where Id = new.Contenuto;
        if lAudio is not null then
            SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Un contenuto può comparire nella tabella Sottotitoli solo se il suo attributo LinguaAudio è nullo';
        end if ;
    end $$

delimiter ;
