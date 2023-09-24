-- Lorenzo Leoncini, Giulio Zingrillo. Progetto di Basi di Dati 2023

-- Questo script implementa le operazioni sui dati descritte nella sezione 4 della Documentazione.

USE plz;

-- ----------------------------------------------------
-- Operazione 1: Rating Assoluto, o Valutazione
-- -----------------------------------------------------


DROP PROCEDURE IF EXISTS rating_assoluto;

DELIMITER $$

CREATE PROCEDURE rating_assoluto (IN _idfilm INT, OUT _rating DOUBLE)
	BEGIN
		DECLARE temp, mediacritica, mediautenti, fasciapremialita, sommapesi, fasciaviews, visualizzazioni, celebritaregisti, celebritaattori, fasciapremialitaregisti, fasciaviewsregisti, numregisti, sommapremiregisti, sommaviewsregisti, numattori, fasciapremialitaattori, fasciaviewsattori, sommapremiattori, sommaviewsattori DOUBLE;
        SET mediacritica = (SELECT AVG(R.Voto) FROM Recensionecritico R WHERE R.Film = _idfilm);
        SET mediautenti = (SELECT AVG(R.Voto) FROM Recensioneutente R WHERE R.Film = _idfilm);
        SET sommapesi = (SELECT sum(P.Peso) FROM Premio P WHERE P.Id IN (SELECT P1.Premio FROM PremiazioneFilm P1 WHERE P1.Film = _idfilm));
        SET visualizzazioni = (SELECT F.Visualizzazioni FROM Film F WHERE F.Id = _idfilm);
        SET numregisti = (SELECT COUNT(*) FROM Direzione D WHERE D.Film = _idfilm);
        SET sommapremiregisti = (SELECT SUM(P.Peso) FROM Premio P WHERE P.Id IN (SELECT P1.Premio FROM PremiazioneRegista P1 WHERE P1.Regista IN (SELECT D.Artista FROM Direzione D WHERE D.Film = _idfilm)));
        SET sommaviewsregisti = (SELECT SUM(A.Visualizzazioni) FROM (SELECT D.Artista, SUM(F.Visualizzazioni) AS Visualizzazioni FROM Direzione D INNER JOIN Film F ON D.Film = F.Id WHERE D.Artista IN (SELECT D.Artista FROM Direzione D WHERE D.Film = _idfilm) GROUP BY D.Artista) AS A);
        SET numattori = (SELECT COUNT(*) FROM Interpretazione I WHERE I.Film = _idfilm);
        SET sommapremiattori = (SELECT SUM(P.Peso) FROM Premio P WHERE P.Id IN (SELECT P1.Premio FROM PremiazioneAttore P1 WHERE P1.Attore IN (SELECT I.Artista FROM Interpretazione I WHERE I.Film = _idfilm)));
        SET sommaviewsattori = (SELECT SUM(A.Visualizzazioni) FROM (SELECT I.Artista, SUM(F.Visualizzazioni) AS Visualizzazioni FROM Interpretazione I INNER JOIN Film F ON I.Film = F.Id WHERE I.Artista IN (SELECT I.Artista FROM Interpretazione I WHERE I.Film = _idfilm) GROUP BY I.Artista) AS A);
        SET temp = sommapremiregisti/numregisti;
        IF temp < 20 THEN
			SET fasciapremialitaregisti = 0;
		ELSEIF temp >= 20 AND temp < 30 THEN
			SET fasciapremialitaregisti = 1;
		ELSEIF temp >= 30 AND temp < 40 THEN
			SET fasciapremialitaregisti = 2;
		ELSEIF temp >= 40 AND temp < 50 THEN
			SET fasciapremialitaregisti = 3;
		ELSEIF temp >= 50 AND temp < 60 THEN
			SET fasciapremialitaregisti = 4;
		ELSE
			SET fasciapremialitaregisti = 5;
		END IF;
        SET temp = sommaviewsregisti/numregisti;
        IF temp < 30 THEN
			SET fasciaviewsregisti = 0;
		ELSEIF temp >= 30 AND temp < 45 THEN
			SET fasciaviewsregisti = 1;
		ELSEIF temp >= 45 AND temp < 60 THEN
			SET fasciaviewsregisti = 2;
		ELSEIF temp >= 60 AND temp < 75 THEN
			SET fasciaviewsregisti = 3;
		ELSEIF temp >= 75 AND temp < 90 THEN
			SET fasciaviewsregisti = 4;
		ELSE
			SET fasciaviewsregisti = 5;
		END IF;
        SET celebritaregisti = (fasciapremialitaregisti + fasciaviewsregisti)/2;
        
		SET temp = sommapremiattori/numattori;
        IF temp < 5 THEN
			SET fasciapremialitaattori = 0;
		ELSEIF temp >= 5 AND temp < 10 THEN
			SET fasciapremialitaattori = 1;
		ELSEIF temp >= 10 AND temp < 20 THEN
			SET fasciapremialitaattori = 2;
		ELSEIF temp >= 20 AND temp < 30 THEN
			SET fasciapremialitaattori = 3;
		ELSEIF temp >= 30 AND temp < 40 THEN
			SET fasciapremialitaattori = 4;
		ELSE
			SET fasciapremialitaattori = 5;
		END IF;
        SET temp = sommaviewsattori/numattori;
        IF temp < 40 THEN
			SET fasciaviewsattori = 0;
		ELSEIF temp >= 40 AND temp < 60 THEN
			SET fasciaviewsattori = 1;
		ELSEIF temp >= 60 AND temp < 80 THEN
			SET fasciaviewsattori = 2;
		ELSEIF temp >= 80 AND temp < 100 THEN
			SET fasciaviewsattori = 3;
		ELSEIF temp >= 100 AND temp < 120 THEN
			SET fasciaviewsattori = 4;
		ELSE
			SET fasciaviewsattori = 5;
		END IF;
        SET celebritaattori = (fasciapremialitaattori + fasciaviewsattori)/2;
        
        IF sommapesi < 30 THEN
			SET fasciapremialita = 0;
		ELSEIF sommapesi >= 30 AND sommapesi < 50 THEN
			SET fasciapremialita = 1;
		ELSEIF sommapesi >= 50 AND sommapesi < 70 THEN
			SET fasciapremialita = 2;
		ELSEIF sommapesi >= 70 AND sommapesi < 90 THEN
			SET fasciapremialita = 3;
		ELSEIF sommapesi >= 90 AND sommapesi < 110 THEN
			SET fasciapremialita = 4;
		ELSE
			SET fasciapremialita = 5;
		END IF;
        
        IF visualizzazioni < 20 THEN
			SET fasciaviews = 0;
		ELSEIF visualizzazioni >= 20 AND visualizzazioni < 30 THEN
			SET fasciaviews = 1;
		ELSEIF visualizzazioni >= 30 AND visualizzazioni < 40 THEN
			SET fasciaviews = 2;
		ELSEIF visualizzazioni >= 40 AND visualizzazioni < 50 THEN
			SET fasciaviews = 3;
		ELSEIF visualizzazioni >= 50 AND visualizzazioni < 60 THEN
			SET fasciaviews = 4;
		ELSE
			SET fasciaviews = 5;
		END IF;
        
		SET _rating = (mediacritica + 2*mediautenti + fasciapremialita + 4*fasciaviews + celebritaregisti + celebritaattori)/10;
    END $$
DELIMITER ;

-- -----------------------------------------------------
-- Operazione 2: Rating Relativo
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS rating_relativo;

DELIMITER $$

CREATE PROCEDURE rating_relativo (IN _idfilm INT, _idutente INT, OUT _rating DOUBLE)
	BEGIN
		DECLARE f_autore, f_storia, f_critica, f_amati, f_popolari, f_premiati, f_star, storia, temp, mediacritica, mediautenti, fasciapremialita, sommapesi, fasciaviews, visualizzazioni, celebritaregisti, celebritaattori, fasciapremialitaregisti, fasciaviewsregisti, numregisti, sommapremiregisti, sommaviewsregisti, numattori, fasciapremialitaattori, fasciaviewsattori, sommapremiattori, sommaviewsattori DOUBLE DEFAULT 0;
	    SET f_autore = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _idutente AND I.Fattore = 'Film d’autore');
	    IF f_autore IS NULL THEN
			SET f_autore = 0;
		ELSE
	        SET numregisti = (SELECT COUNT(*) FROM Direzione D WHERE D.Film = _idfilm);
	        SET sommapremiregisti = (SELECT SUM(P.Peso) FROM Premio P WHERE P.Id IN (SELECT P1.Premio FROM PremiazioneRegista P1 WHERE P1.Regista IN (SELECT D.Artista FROM Direzione D WHERE D.Film = _idfilm)));
	        SET sommaviewsregisti = (SELECT SUM(A.Visualizzazioni) FROM (SELECT D.Artista, SUM(F.Visualizzazioni) AS Visualizzazioni FROM Direzione D INNER JOIN Film F ON D.Film = F.Id WHERE D.Artista IN (SELECT D.Artista FROM Direzione D WHERE D.Film = _idfilm) GROUP BY D.Artista) AS A);
            SET temp = sommapremiregisti/numregisti;
            IF temp < 20 THEN
                SET fasciapremialitaregisti = 0;
            ELSEIF temp >= 20 AND temp < 25 THEN
                SET fasciapremialitaregisti = 10;
            ELSEIF temp >= 25 AND temp < 30 THEN
                SET fasciapremialitaregisti = 20;
            ELSEIF temp >= 30 AND temp < 35 THEN
                SET fasciapremialitaregisti = 30;
            ELSEIF temp >= 35 AND temp < 40 THEN
                SET fasciapremialitaregisti = 40;
            ELSEIF temp >= 40 AND temp < 45 THEN
                SET fasciapremialitaregisti = 50;
            ELSEIF temp >= 45 AND temp < 50 THEN
                SET fasciapremialitaregisti = 60;
            ELSEIF temp >= 50 AND temp < 55 THEN
                SET fasciapremialitaregisti = 70;
            ELSEIF temp >= 55 AND temp < 60 THEN
                SET fasciapremialitaregisti = 80;
            ELSEIF temp >= 60 AND temp < 70 THEN
                SET fasciapremialitaregisti = 90;
            ELSE
                SET fasciapremialitaregisti = 100;
            END IF;
	        SET temp = sommaviewsregisti/numregisti;
	        IF temp < 30.000 THEN
			    SET fasciaviewsregisti = 0;
		    ELSEIF temp >= 30.000 AND temp < 33.750 THEN
			    SET fasciaviewsregisti = 5;
		    ELSEIF temp >= 33.750 AND temp < 37.500 THEN
			    SET fasciaviewsregisti = 10;
		    ELSEIF temp >= 37.500 AND temp < 41.250 THEN
			    SET fasciaviewsregisti = 15;
		    ELSEIF temp >= 41.250 AND temp < 45.000 THEN
			    SET fasciaviewsregisti = 20;
		    ELSEIF temp >= 45.000 AND temp < 48.750 THEN
			    SET fasciaviewsregisti = 25;
		    ELSEIF temp >= 48.750 AND temp < 52.500 THEN
			    SET fasciaviewsregisti = 30;
		    ELSEIF temp >= 52.500 AND temp < 56.250 THEN
			    SET fasciaviewsregisti = 35;
		    ELSEIF temp >= 56.250 AND temp < 60.000 THEN
			    SET fasciaviewsregisti = 40;
		    ELSEIF temp >= 60.000 AND temp < 63.750 THEN
			    SET fasciaviewsregisti = 45;
		    ELSEIF temp >= 63.750 AND temp < 67.500 THEN
			    SET fasciaviewsregisti = 50;
		    ELSEIF temp >= 67.500 AND temp < 71.250 THEN
			    SET fasciaviewsregisti = 55;
		    ELSEIF temp >= 71.250 AND temp < 75.000 THEN
			    SET fasciaviewsregisti = 60;
		    ELSEIF temp >= 75.000 AND temp < 78.750 THEN
			    SET fasciaviewsregisti = 65;
		    ELSEIF temp >= 78.750 AND temp < 82.500 THEN
			    SET fasciaviewsregisti = 70;
		    ELSEIF temp >= 82.500 AND temp < 86.250 THEN
			    SET fasciaviewsregisti = 75;
		    ELSEIF temp >= 86.250 AND temp < 90.000 THEN
			    SET fasciaviewsregisti = 80;
		    ELSEIF temp >= 90.000 AND temp < 93.750 THEN
			    SET fasciaviewsregisti = 85;
		    ELSEIF temp >= 93.750 AND temp < 97.500 THEN
			    SET fasciaviewsregisti = 90;
		    ELSEIF temp >= 97.500 AND temp < 105.000 THEN
			    SET fasciaviewsregisti = 95;
		    ELSE
			    SET fasciaviewsregisti = 100;
		    END IF;
	        SET celebritaregisti = (fasciapremialitaregisti + fasciaviewsregisti)/2;
		END IF;
	    SET f_storia = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _idutente AND I.Fattore = 'I film che hanno fatto la storia');
	    IF f_storia IS NULL THEN
			SET f_storia = 0;
		ELSE
	        SET storia = YEAR(CURRENT_DATE) - (SELECT F.Anno FROM Film F WHERE F.Id = _idfilm);
	        IF storia > 100 THEN
			SET storia = 100;
		    END IF;
		END IF;
	    SET f_critica = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _idutente AND I.Fattore = 'Esaltati dalla critica');
	    IF f_critica IS NULL THEN
			SET f_critica = 0;
		ELSE
	        SET mediacritica = (SELECT AVG(R.Voto) FROM Recensionecritico R WHERE R.Film = _idfilm);
		END IF;
	    SET f_amati = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _idutente AND I.Fattore = 'I più amati');
	    IF f_amati IS NULL THEN
			SET f_amati = 0;
		ELSE
	        SET mediautenti = (SELECT AVG(R.Voto) FROM Recensioneutente R WHERE R.Film = _idfilm);
		END IF;
        SET f_popolari = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _idutente AND I.Fattore = 'Popolari');
        IF f_popolari IS NULL THEN
			SET f_popolari = 0;
		ELSE
            SET visualizzazioni = (SELECT F.Visualizzazioni FROM Film F WHERE F.Id = _idfilm);
            IF visualizzazioni < 20.000 THEN
                SET fasciaviews = 0;
            ELSEIF visualizzazioni >= 20.000 AND visualizzazioni < 22.500 THEN
                SET fasciaviews = 5;
            ELSEIF visualizzazioni >= 22.500 AND visualizzazioni < 25.000 THEN
                SET fasciaviews = 10;
            ELSEIF visualizzazioni >= 25.000 AND visualizzazioni < 27.500 THEN
                SET fasciaviews = 15;
            ELSEIF visualizzazioni >= 27.500 AND visualizzazioni < 30.000 THEN
                SET fasciaviews = 20;
            ELSEIF visualizzazioni >= 30.000 AND visualizzazioni < 32.500 THEN
                SET fasciaviews = 25;
            ELSEIF visualizzazioni >= 32.500 AND visualizzazioni < 35.000 THEN
                SET fasciaviews = 30;
            ELSEIF visualizzazioni >= 35.000 AND visualizzazioni < 37.500 THEN
                SET fasciaviews = 35;
            ELSEIF visualizzazioni >= 37.500 AND visualizzazioni < 40.000 THEN
                SET fasciaviews = 40;
            ELSEIF visualizzazioni >= 40.000 AND visualizzazioni < 42.500 THEN
                SET fasciaviews = 45;
            ELSEIF visualizzazioni >= 42.500 AND visualizzazioni < 45.000 THEN
                SET fasciaviews = 50;
            ELSEIF visualizzazioni >= 45.000 AND visualizzazioni < 47.500 THEN
                SET fasciaviews = 55;
            ELSEIF visualizzazioni >= 47.500 AND visualizzazioni < 50.000 THEN
                SET fasciaviews = 60;
            ELSEIF visualizzazioni >= 50.000 AND visualizzazioni < 52.500 THEN
                SET fasciaviews = 65;
            ELSEIF visualizzazioni >= 52.500 AND visualizzazioni < 55.000 THEN
                SET fasciaviews = 70;
            ELSEIF visualizzazioni >= 55.000 AND visualizzazioni < 57.500 THEN
                SET fasciaviews = 75;
            ELSEIF visualizzazioni >= 57.500 AND visualizzazioni < 60.000 THEN
                SET fasciaviews = 80;
            ELSEIF visualizzazioni >= 60.000 AND visualizzazioni < 62.500 THEN
                SET fasciaviews = 85;
            ELSEIF visualizzazioni >= 62.500 AND visualizzazioni < 65.000 THEN
                SET fasciaviews = 90;
            ELSEIF visualizzazioni >= 65.000 AND visualizzazioni < 70.000 THEN
                SET fasciaviews = 95;
            ELSE
                SET fasciaviews = 100;
            END IF;
        END IF;
        SET f_star = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _idutente AND I.Fattore = 'Le star');
        IF f_star IS NULL THEN
			SET f_star = 0;
		ELSE
		    SET numattori = (SELECT COUNT(*) FROM Interpretazione I WHERE I.Film = _idfilm);
	        SET sommapremiattori = (SELECT SUM(P.Peso) FROM Premio P WHERE P.Id IN (SELECT P1.Premio FROM PremiazioneAttore P1 WHERE P1.Attore IN (SELECT I.Artista FROM Interpretazione I WHERE I.Film = _idfilm)));
	        SET sommaviewsattori = (SELECT SUM(A.Visualizzazioni) FROM (SELECT I.Artista, SUM(F.Visualizzazioni) AS Visualizzazioni FROM Interpretazione I INNER JOIN Film F ON I.Film = F.Id WHERE I.Artista IN (SELECT I.Artista FROM Interpretazione I WHERE I.Film = _idfilm) GROUP BY I.Artista) AS A);
            SET temp = sommapremiattori/numattori;
        	IF temp < 5 THEN
			    SET fasciapremialitaattori = 0;
		    ELSEIF temp >= 5 AND temp < 10 THEN
			    SET fasciapremialitaattori = 10;
		    ELSEIF temp >= 10 AND temp < 15 THEN
			    SET fasciapremialitaattori = 20;
		    ELSEIF temp >= 15 AND temp < 20 THEN
			    SET fasciapremialitaattori = 30;
		    ELSEIF temp >= 20 AND temp < 25 THEN
			    SET fasciapremialitaattori = 40;
		    ELSEIF temp >= 25 AND temp < 30 THEN
			    SET fasciapremialitaattori = 50;
		    ELSEIF temp >= 30 AND temp < 35 THEN
			    SET fasciapremialitaattori = 60;
		    ELSEIF temp >= 35 AND temp < 40 THEN
			    SET fasciapremialitaattori = 70;
		    ELSEIF temp >= 40 AND temp < 45 THEN
			    SET fasciapremialitaattori = 80;
            ELSEIF temp >= 45 AND temp < 50 THEN
                SET fasciapremialitaattori = 90;
            ELSE
                SET fasciapremialitaattori = 100;
            END IF;
            SET temp = sommaviewsattori/numattori;
            IF temp < 40.000 THEN
                SET fasciaviewsattori = 0;
            ELSEIF temp >= 40.000 AND temp < 45.000 THEN
                SET fasciaviewsattori = 5;
            ELSEIF temp >= 45.000 AND temp < 50.000 THEN
                SET fasciaviewsattori = 10;
            ELSEIF temp >= 50.000 AND temp < 55.000 THEN
                SET fasciaviewsattori = 15;
            ELSEIF temp >= 55.000 AND temp < 60.000 THEN
                SET fasciaviewsattori = 20;
            ELSEIF temp >= 60.000 AND temp < 65.000 THEN
                SET fasciaviewsattori = 25;
            ELSEIF temp >= 65.000 AND temp < 70.000 THEN
                SET fasciaviewsattori = 30;
            ELSEIF temp >= 70.000 AND temp < 75.000 THEN
                SET fasciaviewsattori = 35;
            ELSEIF temp >= 75.000 AND temp < 80.000 THEN
                SET fasciaviewsattori = 40;
            ELSEIF temp >= 80.000 AND temp < 85.000 THEN
                SET fasciaviewsattori = 45;
            ELSEIF temp >= 85.000 AND temp < 90.000 THEN
                SET fasciaviewsattori = 50;
            ELSEIF temp >= 90.000 AND temp < 95.000 THEN
                SET fasciaviewsattori = 55;
            ELSEIF temp >= 95.000 AND temp < 100.000 THEN
                SET fasciaviewsattori = 60;
            ELSEIF temp >= 100.000 AND temp < 105.000 THEN
                SET fasciaviewsattori = 65;
            ELSEIF temp >= 105.000 AND temp < 110.000 THEN
                SET fasciaviewsattori = 70;
            ELSEIF temp >= 110.000 AND temp < 115.000 THEN
                SET fasciaviewsattori = 75;
            ELSEIF temp >= 115.000 AND temp < 120.000 THEN
                SET fasciaviewsattori = 80;
            ELSEIF temp >= 120.000 AND temp < 125.000 THEN
                SET fasciaviewsattori = 85;
            ELSEIF temp >= 125.000 AND temp < 130.000 THEN
                SET fasciaviewsattori = 90;
            ELSEIF temp >= 130.000 AND temp < 140.000 THEN
                SET fasciaviewsattori = 95;
            ELSE
                SET fasciaviewsattori = 100;
            END IF;
            SET celebritaattori = (fasciapremialitaattori + fasciaviewsattori)/2;
        END IF;
	    SET f_premiati = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _idutente AND I.Fattore = 'Premiati');
	    IF f_premiati IS NULL THEN
			SET f_premiati = 0;
		ELSE
	        SET sommapesi = (SELECT sum(P.Peso) FROM Premio P WHERE P.Id IN (SELECT P1.Premio FROM PremiazioneFilm P1 WHERE P1.Film = _idfilm));
		    IF sommapesi < 30 THEN
			    SET fasciapremialita = 0;
            ELSEIF sommapesi >= 30 AND sommapesi < 40 THEN
                SET fasciapremialita = 10;
            ELSEIF sommapesi >= 40 AND sommapesi < 50 THEN
                SET fasciapremialita = 20;
            ELSEIF sommapesi >= 50 AND sommapesi < 60 THEN
                SET fasciapremialita = 30;
            ELSEIF sommapesi >= 60 AND sommapesi < 70 THEN
                SET fasciapremialita = 40;
            ELSEIF sommapesi >= 70 AND sommapesi < 80 THEN
                SET fasciapremialita = 50;
            ELSEIF sommapesi >= 80 AND sommapesi < 90 THEN
                SET fasciapremialita = 60;
            ELSEIF sommapesi >= 90 AND sommapesi < 100 THEN
                SET fasciapremialita = 70;
            ELSEIF sommapesi >= 100 AND sommapesi < 110 THEN
                SET fasciapremialita = 80;
            ELSEIF sommapesi >= 110 AND sommapesi < 120 THEN
                SET fasciapremialita = 90;
            ELSE
                SET fasciapremialita = 100;
            END IF;
	    END IF;


		SET _rating = (mediacritica * f_critica + mediautenti * f_amati + fasciapremialita * f_premiati + fasciaviews * f_popolari + celebritaregisti * f_autore + celebritaattori * f_star + storia * f_storia)/(f_autore + f_storia + f_critica + f_amati + f_popolari + f_premiati + f_star);
	END $$
DELIMITER ;

-- -----------------------------------------------------
-- Operazione 3: Raccomandazione di Contenuti
-- -----------------------------------------------------


drop procedure if exists raccomandazione_contenuti;
delimiter $$
create procedure raccomandazione_contenuti(in _utente INT, in _n INT)
begin
    declare finito tinyint(1) default 0;
    declare _film, fatture_inevase, visualizzazioni_totali int default 0;
    declare c_storico_genere, c_storico_attori, c_storico_registi, c_storico_paese, media_cs double default 0;
    -- individuiamo preliminarmente i film target, che possono essere restituiti dalla procedura
    declare c cursor for
        with LingueAudioVisualizzazioni as (
            select LinguaAudio, count(*) as Visualizzazioni
            from contenuto c
            inner join erogazione e on c.Id = e.Contenuto
            inner join connessione c3 on e.Dispositivo = c3.Dispositivo and e.Inizio = c3.Inizio
            where Utente = _utente
            and LinguaAudio is not null
            group by LinguaAudio
        ),
        LingueAudioTarget as (
            select LinguaAudio
            from LingueAudioVisualizzazioni
            where Visualizzazioni/(select sum(Visualizzazioni) from LingueAudioVisualizzazioni ) >0.05
        ),
        LinguaSottotitoliVisualizzazioni as (
            select Lingua, count(*) as Visualizzazioni
            from contenuto c
            inner join erogazione e on c.Id = e.Contenuto
            inner join connessione c3 on e.Dispositivo = c3.Dispositivo and e.Inizio = c3.Inizio
            inner join sottotitoli s2 on e.Contenuto = s2.Contenuto
            where Utente = _utente
            group by Lingua
        ),
        LinguaSottotitoliTarget as (
            select Lingua
            from LinguaSottotitoliVisualizzazioni
            where Visualizzazioni/(select sum(Visualizzazioni) from LinguaSottotitoliVisualizzazioni ) >0.05
        )
        select distinct Id
        from film f
        where not exists(
            -- nessun contenuto del film deve essere soggetto a restrizioni nel Paese di residenza dell'utente
            select *
            from contenuto c inner join restrizionecontenuto r
            on c.Id = r.Contenuto
            where c.Film= f.Id
            and r.Paese = (
                select Nazionalita
                from plz.utente u
                where u.Codice = _utente
                )
        )
    and not exists (
    -- il contenuto non deve mai essere stato visualizzato dall'utente
        select *
        from contenuto c inner join erogazione e
        on c.Id = e.Contenuto
        inner join connessione c2 on e.Dispositivo = c2.Dispositivo and e.Inizio = c2.Inizio
        where c.Film = f.Id
        and c2.Utente = _utente
        )
    and exists (
        -- deve esistere un contenuto rappresentante il film che sia disponibile nel piano di abbonamento dell'utente
        select *
        from contenuto c inner join offertacontenuto o on c.Id = o.Contenuto
        where c.Film = f.Id
        and o.Abbonamento = (
            select Abbonamento
            from utente u2
            where u2.Codice = _utente
            )
        )
    and exists (
        -- deve esistere un contenuto rappresentante il film che sia relativo una lingua audio target
        select *
        from contenuto c where c.Film = f.Id
        and c.LinguaAudio in (select * from LingueAudioTarget)
        )
    and exists(
    -- deve esistere un contenuto rappresentante il film che sia relativo una lingua audio target
        select *
        from contenuto c inner join sottotitoli s on c.Id = s.Contenuto
        where c.Film = f.Id
        and s.Lingua in (select * from LinguaSottotitoliTarget)
        );
    declare continue handler for not found set finito=1;

    -- verifichiamo che l'utente sia in regola con i pagamenti
    select count(*) into fatture_inevase
    from fattura
    where Utente = _utente
    and Saldo is null
    and current_date>Emissione + interval 30 day;
    if fatture_inevase > 0
        then select  'Utente non in regola con i pagamenti';
    else
        select count(*) into visualizzazioni_totali from contenuto c inner join erogazione e on c.Id = e.Contenuto
            inner join connessione conn on conn.Inizio = e.Inizio
            and conn.Dispositivo = e.Dispositivo
            where conn.Utente = 1;
            drop temporary table if exists `Provvisoria`;
            create temporary table `Provvisoria`(
                `Film` INT NOT NULL,
            `Storico` DOUBLE NOT NULL,
            PRIMARY KEY (`Film`)
            );
        open c;
        scan: loop
            fetch c into _film;
            if finito = 1
                then leave scan;
            end if;
            -- coefficiente di storico genere: individuo la percentuale di visualizzazioni, da parte dell'utente, di film che appartengono al genere del film target
            select count(*)/visualizzazioni_totali into c_storico_genere
            from contenuto c inner join erogazione e on c.Id = e.Contenuto
            inner join connessione conn on conn.Inizio = e.Inizio
            and conn.Dispositivo = e.Dispositivo
            inner join appartenenza a on a.Film = c.Film
            where a.Genere in (select Genere from appartenenza a2 where a2.Film = _film)
            and conn.Utente = _utente;
            -- coefficiente di storico attori: individuo la percentuale di visualizzazioni, da parte dell'utente, di film interpretati dagli attori del film in esame
            with visualizzazioni_totali_attori as (
                select i.Artista, count(*) as Visualizzazioni
                from contenuto c inner join erogazione e on c.Id = e.Contenuto
                inner join connessione conn on conn.Inizio = e.Inizio
                and conn.Dispositivo = e.Dispositivo
                inner join interpretazione i on c.Film = i.Film
                where conn.Utente = _utente
                group by i.Artista
            ),
            visualizzazioni_percentuali as (
                select Artista, Visualizzazioni/(select sum(Visualizzazioni) from visualizzazioni_totali_attori) as visPerc
                from visualizzazioni_totali_attori
                group by Artista
                )
            select ifnull(0, sum(visPerc)) into c_storico_attori
            from visualizzazioni_percentuali natural join interpretazione i where i.Film = _film;

            -- coefficiente di storico registi: individuo la percentuale di visualizzazioni, da parte dell'utente, di film diretti dai registi del film in esame
            with visualizzazioni_totali_registi as (
                select d.Artista, count(*) as Visualizzazioni
                from contenuto c inner join erogazione e on c.Id = e.Contenuto
                inner join connessione conn on conn.Inizio = e.Inizio
                and conn.Dispositivo = e.Dispositivo
                inner join direzione d on c.Film = d.Film
                where conn.Utente = _utente
                group by d.Artista
            ),
            visualizzazioni_percentuali as (
                select Artista, Visualizzazioni/(select sum(Visualizzazioni) from visualizzazioni_totali_registi) as visPerc
                from visualizzazioni_totali_registi
                group by Artista
                )
            select ifnull(0, sum(visPerc)) into c_storico_registi
            from visualizzazioni_percentuali natural join direzione d where d.Film = _film;

             -- coefficiente di storico Paesi: individuo la percentuale di visualizzazioni, da parte dell'utente, di film prodotti nello stesso Paese del film in esame
            select count(*)/visualizzazioni_totali into c_storico_paese
            from contenuto c inner join erogazione e on c.Id = e.Contenuto
            inner join connessione conn on e.Dispositivo = conn.Dispositivo
            and e.Inizio = conn.Inizio
            inner join film f on f.Id = c.Film
            where f.Paese = (
                select f2.Paese
                from film f2
                where f2.Id = _film
                )
            and conn.Utente= _utente;
            -- calcolo la media dei coefficienti di storico del film
            set media_cs = (5*c_storico_genere+2*c_storico_attori+4*c_storico_registi+c_storico_paese)/12;
            replace into Provvisoria values(_film, media_cs);
            

        end loop;
        close c;
        select Film from Provvisoria
        order by Storico desc
        limit _n;
        drop temporary table Provvisoria;

        end if;
end $$
delimiter ;

-- -----------------------------------------------------
-- Operazione 4: Scelta di un Server per l'erogazione di un Contenuto a un Utente
-- -----------------------------------------------------

drop procedure if exists scegli_server;
delimiter $$
create procedure scegli_server(_inizio timestamp, _dispositivo int, _contenuto int)
begin
    declare paese_di_connessione varchar(45) default '';
    declare bandadisponibile bigint default 0;
    declare s, jitter int default 0;
    declare serverfinale int default 0;
    declare latitudine_p, longitudine_p, latitudine_s, longitudine_s,chi double default 0;
    declare finito integer default 0;
    declare _IP bigint default 0;
    -- individuo i server che possiedono il contenuto
    declare c cursor for
        select P.Server
        from possessoserver P
        where P.Contenuto=_contenuto;
    declare continue handler for not found 
		set finito=1;
    -- risalgo all'indirizzo IP
    select IP into _IP
    from connessione
    where Inizio = _inizio
    and Dispositivo = _dispositivo;
    -- risalgo al Paese da cui si sta collegando l'utente
    select Nome
    from Paese
    where _IP>InizioIP
    and _IP < FineIP into paese_di_connessione;
    -- recupero latitudine e longitudine del paese
    select Latitudine, Longitudine into latitudine_p, longitudine_p
    from paese
    where Nome = paese_di_connessione;
    drop temporary table if exists provvisoria_server;
    create temporary table provvisoria_server (
        `Server` int not null,
        `Chi` double not null
    );
    set finito = 0;
    open c;
    scan: loop
        fetch c into s;
        if finito = 1
            then leave scan;
        end if;
        select ser.Jitter, ser.Latitudine, ser.Longitudine, ser.BandaDisponibile into jitter, latitudine_s, longitudine_s, bandadisponibile
        from server ser
        where ser.Id = s;
        set chi = bandadisponibile/(power(power((latitudine_s-latitudine_p),2)+power((longitudine_s-longitudine_p),2), 0.5))/jitter;
        insert into provvisoria_server values (s, chi);
        
    end loop scan;
    close c;
    select p.Server
    from provvisoria_server p
    order by p.Chi desc
    limit 1;
    select p.Server into serverfinale
    from provvisoria_server p
    order by p.Chi desc
    limit 1;
    drop temporary table provvisoria_server;
    insert into erogazione(`Inizio`, `Fine`, `Contenuto`, `Server`, `InizioConnessione`, `Dispositivo`) values (current_timestamp, null, _contenuto, serverfinale, _inizio, _dispositivo);
end $$
delimiter ;

-- -----------------------------------------------------
-- Operazione 5: Caching
-- -----------------------------------------------------

-- In fase di implementazione abbiamo scelto di cosiderare gli ultimi 365 giorni per evidenziare il funzionamento
DROP PROCEDURE IF EXISTS caching;

DELIMITER $$

CREATE PROCEDURE caching (IN _id INT, _n INT)
	BEGIN
		DECLARE lower_bound, upper_bound, etautente, autore, storia, critica, amati, popolari, star, premiati INT;
        DECLARE datanascitautente, datacreazioneaccount DATE;
        DECLARE nazionalitautente VARCHAR(45);
        SET autore = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _id AND I.Fattore = 'Film d’autore');
		SET storia = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _id AND I.Fattore = 'I film che hanno fatto la storia');
		SET critica = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _id AND I.Fattore = 'Esaltati dalla critica');
		SET amati = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _id AND I.Fattore = 'I più amati');
		SET popolari = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _id AND I.Fattore = 'Popolari');
		SET star = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _id AND I.Fattore = 'Le star');
		SET premiati = (SELECT I.Valore FROM Importanza I WHERE I.Utente = _id AND I.Fattore = 'Premiati');
        SET nazionalitautente = (SELECT U.Nazionalita FROM Utente U WHERE U.Codice = _id);
        SET datanascitautente = (SELECT U.DataNascita FROM Utente U WHERE U.Codice = _id);
		SET datacreazioneaccount =  (SELECT U.Inizio FROM Utente U WHERE U.Codice = _id);
		SET etautente = YEAR(CURRENT_DATE) - YEAR(datanascitautente);
		IF etautente >= 13 AND etautente <= 18 THEN
			SET lower_bound = 13;
            SET upper_bound = 18;
		ELSEIF etautente >= 19 AND etautente <= 34 THEN
			SET lower_bound = 19;
            SET upper_bound = 34;
		ELSEIF etautente >= 35 AND etautente <= 64 THEN
			SET lower_bound = 35;
            SET upper_bound = 64;
		ELSEIF etautente >= 65 THEN
			SET lower_bound = 65;
            SET upper_bound = 150;
		END IF;

				WITH lingueaudio AS (
				SELECT DISTINCT C1.LinguaAudio
				FROM Connessione C INNER JOIN Erogazione E ON (C.Inizio = E.InizioConnessione AND C.Dispositivo = E.Dispositivo) INNER JOIN Contenuto C1 ON E.Contenuto = C1.Id
				WHERE C.Utente = _id AND C1.LinguaAudio IS NOT NULL
			),
			codificaformatiaudio AS (
				SELECT DISTINCT C1.CodificaAudio
				FROM Connessione C INNER JOIN Erogazione E ON (C.Inizio = E.InizioConnessione AND C.Dispositivo = E.Dispositivo) INNER JOIN Contenuto C1 ON E.Contenuto = C1.Id
				WHERE C.Utente = _id AND C1.CodificaAudio IS NOT NULL
			),
			codificaformatovideo AS (
				SELECT DISTINCT C2.FormatoVideo
				FROM Connessione C INNER JOIN Erogazione E ON (C.Inizio = E.InizioConnessione AND C.Dispositivo = E.Dispositivo) INNER JOIN Contenuto C1 ON E.Contenuto = C1.Id INNER JOIN CodificaVideo C2 ON C2.Contenuto = C1.Id
				WHERE C.Utente = _id AND E.Contenuto IN (SELECT C2.Contenuto
														 FROM CodificaVideo C2)
			),
			contenutinoncensurati AS (
				SELECT DISTINCT R.Contenuto
				FROM RestrizioneContenuto R
				WHERE R.Paese <> nazionalitautente
			),
			contenutinelpianoabbonamento AS (
				SELECT DISTINCT O.Contenuto
				FROM OffertaContenuto O
				WHERE O.Abbonamento = (SELECT U.Abbonamento FROM Utente U WHERE U.Codice = _id)
			),
			contenutitargetaudio AS (
				SELECT C.Id
				FROM Contenuto C
				WHERE C.LinguaAudio IN (select * from lingueaudio) AND C.CodificaAudio IN (select * from codificaformatiaudio) AND C.Id IN (select * from contenutinoncensurati) AND C.Id IN (select * from contenutinelpianoabbonamento)
			),
			contenutitargetvideo AS (
				SELECT C.Id
				FROM Contenuto C INNER JOIN CodificaVideo C1 ON C1.Contenuto = C.Id
				WHERE C1.FormatoVideo IN (select * from codificaformatovideo) AND C.Id IN (select * from contenutinoncensurati) AND C.Id IN (select * from contenutinelpianoabbonamento)
			),
			contenutitarget AS (
				SELECT * FROM contenutitargetaudio
				UNION
				SELECT * FROM contenutitargetvideo
			),
			autore1 AS (SELECT I.Utente
					   FROM Importanza I
					   WHERE I.Fattore = 'Film d’autore' AND abs(I.Valore - autore) <= 20
			),
			storia1 AS (SELECT I.Utente
					   FROM Importanza I
					   WHERE I.Fattore = 'I film che hanno fatto la storia' AND abs(I.Valore - storia) <= 20
			),
			critica1 AS (SELECT I.Utente
					   FROM Importanza I
					   WHERE I.Fattore = 'Esaltati dalla critica' AND abs(I.Valore - critica) <= 20
			),
			amati1 AS (SELECT I.Utente
					   FROM Importanza I
					   WHERE I.Fattore = 'I più amati' AND abs(I.Valore - amati) <= 20
			),
			popolari1 AS (SELECT I.Utente
					   FROM Importanza I
					   WHERE I.Fattore = 'Popolari' AND abs(I.Valore - popolari) <= 20
			),
			star1 AS (SELECT I.Utente
					   FROM Importanza I
					   WHERE I.Fattore = 'Le star' AND abs(I.Valore - star) <= 20
			),
			premiati1 AS (SELECT I.Utente
					   FROM Importanza I
					   WHERE I.Fattore = 'Premiati' AND abs(I.Valore - premiati) <= 20
			),
			movie_index AS (
				SELECT C.Id, (SELECT COUNT(*)
							  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN Utente U ON C1.Utente = U.Codice
							  WHERE E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)) AND E.Contenuto IN (SELECT C2.Id
																									 FROM Contenuto C2
																									 WHERE C2.Film = (SELECT C3.Film
																													  FROM Contenuto C3
																													  WHERE C3.Id = C.Id
																													  )
																									 ) AND YEAR(CURRENT_DATE) - YEAR(U.DataNascita) >= lower_bound AND YEAR(CURRENT_DATE) - YEAR(U.DataNascita) <= upper_bound
							  ) AS Generazione, (SELECT COUNT(*)
							  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN Utente U ON C1.Utente = U.Codice
							  WHERE E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)) AND E.Contenuto IN (SELECT C2.Id
																									 FROM Contenuto C2
																									 WHERE C2.Film = (SELECT C3.Film
																													  FROM Contenuto C3
																													  WHERE C3.Id = C.Id
																													  )
																									 ) AND U.Nazionalita = nazionalitautente
							  ) AS Paese, (SELECT COUNT(*)
							  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN Utente U ON C1.Utente = U.Codice
							  WHERE E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)) AND E.Contenuto IN (SELECT C2.Id
																									 FROM Contenuto C2
																									 WHERE C2.Film = (SELECT C3.Film
																													  FROM Contenuto C3
																													  WHERE C3.Id = C.Id
																													  )
																									 ) AND U.Codice IN (SELECT Utente
																														FROM autore1 NATURAL JOIN storia1 NATURAL JOIN critica1 NATURAL JOIN amati1 NATURAL JOIN popolari1 NATURAL JOIN star1 NATURAL JOIN premiati1
																														)
							  ) AS Preferenze, (SELECT COUNT(*)
							  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN Utente U ON C1.Utente = U.Codice
							  WHERE E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)) AND E.Contenuto IN (SELECT C2.Id
																									 FROM Contenuto C2
																									 WHERE C2.Film = (SELECT C3.Film
																													  FROM Contenuto C3
																													  WHERE C3.Id = C.Id
																													  )
																									 )
							  ) AS Totale
				FROM contenutitarget C
			),
			codec_index_audio AS (
				SELECT C.Id, (
							  SELECT COUNT(*)
							  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN contenutitargetaudio A ON A.Id = E.Contenuto
							  WHERE C1.Utente = _id AND E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)) AND E.Contenuto IN (
																																   SELECT C2.Id
																																   FROM contenutitargetaudio C2 INNER JOIN Contenuto C4 ON C2.Id = C4.Id INNER JOIN FormatoAudio F ON C4.CodificaAudio = F.Codice
																																   WHERE F.Famiglia = (SELECT F1.Famiglia
																																					   FROM contenutitargetaudio C3 INNER JOIN Contenuto C5 ON C3.Id = C5.Id INNER JOIN FormatoAudio F1 ON C5.CodificaAudio = F1.Codice
																																					   WHERE C3.Id = C.Id
																																					   )
																																   )
							 ) AS StessaFamiglia,
							  (SELECT COUNT(*)
							  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN contenutitargetaudio A ON A.Id = E.Contenuto
							  WHERE C1.Utente = _id AND E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)) 
							 ) AS Totale
				FROM contenutitargetaudio C
			),
			codec_index_video AS (
				SELECT C.Id, (SELECT COUNT(*)
							  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN contenutitargetvideo V ON V.Id = E.Contenuto
							  WHERE C1.Utente = _id AND E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)) AND E.Contenuto IN (
																																   SELECT C2.Id
																																   FROM contenutitargetvideo C2 INNER JOIN Contenuto C3 ON C2.Id = C3.Id INNER JOIN CodificaVideo C4 ON C2.Id = C4.Contenuto INNER JOIN FormatoVideo F ON C4.FormatoVideo = F.Codice
																																   WHERE F.Famiglia = (
																																						SELECT F1.Famiglia
																																						FROM contenutitargetvideo C5 INNER JOIN Contenuto C6 ON C5.Id = C6.Id INNER JOIN CodificaVideo C7 ON C5.Id = C7.Contenuto INNER JOIN FormatoVideo F1 ON C7.FormatoVideo = F1.Codice
																																						WHERE C5.Id = C.Id
																																						)
																																   )
							  ) AS StessaFamiglia, 
							  (SELECT COUNT(*)
							  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN contenutitargetvideo V ON V.Id = E.Contenuto
							  WHERE C1.Utente = _id AND E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY))
							  ) AS Totale
				FROM contenutitargetvideo C
			),
			codec_index AS (
			SELECT * FROM codec_index_audio
			UNION
			SELECT * FROM codec_index_video
			),
			language_index_audio AS (
			SELECT C.Id, (
						  SELECT COUNT(*)
						  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN contenutitargetaudio A ON A.Id = E.Contenuto
						  WHERE C1.Utente = _id AND E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)) AND E.Contenuto IN (
																															   SELECT C2.Id
																															   FROM contenutitargetaudio C2 INNER JOIN Contenuto C3 ON C2.Id = C3.Id
																															   WHERE C3.LinguaAudio = (SELECT C5.LinguaAudio
																																					   FROM contenutitargetaudio C4 INNER JOIN Contenuto C5 ON C4.Id = C5.Id
																																					   WHERE C4.Id = C.Id
																																				   )
																															   )
						 ) AS StessaLingua,
						  (SELECT COUNT(*)
						  FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo) INNER JOIN contenutitargetaudio A ON A.Id = E.Contenuto
						  WHERE C1.Utente = _id AND E.Inizio > (DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)) 
						 ) AS Totale
			FROM contenutitargetaudio C
			),
            language_index AS (
				SELECT * FROM language_index_audio
                UNION
                SELECT C.Id, 1 as StessaLingua, 1 as Totale FROM contenutitargetvideo C
            ),
			vis_di_gamma AS (
				SELECT C.Id, (
							SELECT COUNT(*)
							FROM Connessione C1 INNER JOIN Erogazione E ON (C1.Inizio = E.InizioConnessione AND C1.Dispositivo = E.Dispositivo)
							WHERE C1.Utente = _id  AND E.Contenuto = C.Id
							 ) AS Vis
				FROM contenutitarget C
			),
            memory_index AS (
				SELECT V.Id, pow(2.71, (V.Vis - 3)) AS Mem FROM vis_di_gamma V WHERE V.Vis < 3
                UNION
                SELECT V.Id, pow(0.8, (V.Vis - 3)) AS Mem FROM vis_di_gamma V WHERE V.Vis >= 3
			),
            pi_greco AS (
				SELECT M.Id,  ((M.Generazione/M.Totale)*4 + (M.Paese/M.Totale)*4 + (M.Preferenze/M.Totale)*2)/10 * (C.StessaFamiglia/C.Totale) * (L.StessaLingua/L.Totale) * M1.Mem AS Pi
                FROM movie_index M INNER JOIN codec_index C ON M.Id = C.Id INNER JOIN language_index L ON M.Id = L.Id INNER JOIN memory_index M1 ON M.Id = M1.Id
            )
			SELECT P.Id
			FROM pi_greco P
			order by P.Pi desc
		limit _n;
    END $$
DELIMITER ;





-- -----------------------------------------------------
-- Operazione 6a: Registrazione di un Utente
-- -----------------------------------------------------


DROP PROCEDURE IF EXISTS registrazione_utente;

DELIMITER $$
CREATE PROCEDURE registrazione_utente (IN _nome VARCHAR(255), _cognome VARCHAR(255), _email VARCHAR(255), _password VARCHAR(255), _nazionalita VARCHAR(45), _datanascita DATE, OUT _check BOOL)
	BEGIN
		DECLARE temp1 INT;
        SET temp1 = (SELECT COUNT(*) FROM utente U WHERE U.Email = _email);

        IF temp1 = 1 OR _email not like '%@%.%'THEN
			SET _check = FALSE;
		ELSE
			INSERT INTO Utente(Nome, Cognome, Email, Password, Nazionalita, DataNascita)
            VALUES (_nome, _cognome, _email, _password, _nazionalita, _datanascita);
            SET _check = TRUE;
		END IF;
    END $$
DELIMITER ;

-- -----------------------------------------------------
-- Operazione 6b: Sottoscrizione del Servizio da parte di un utente
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sottoscrizione_servizio;

DELIMITER $$

CREATE PROCEDURE sottoscrizione_servizio (IN _codice INT, _abbonamento VARCHAR(45), _numero BIGINT, _cvv INT, _nome VARCHAR(255), _cognome VARCHAR(255), _mese INT, _anno INT, OUT _check BOOL)
	BEGIN
		DECLARE temp1, temp2, etautente, etamin, num_prov, num_utenti INT;
        DECLARE datanascita DATE;
        SET datanascita = (SELECT U.DataNascita FROM utente U WHERE U.Codice = _codice);
        SET num_utenti = (SELECT count(*) FROM Utente U WHERE U.Codice = _codice);
        SET temp1 = (SELECT COUNT(*) FROM abbonamento A WHERE A.Nome = _abbonamento);
        SET temp2 = (SELECT COUNT(*) FROM restrizioneabbonamento R WHERE R.Abbonamento = _abbonamento AND R.Paese = (SELECT Nazionalita FROM utente U WHERE U.Codice = _codice));
        SET etamin = (SELECT A.EtaMinima FROM abbonamento A WHERE A.Nome = _abbonamento);
        SET etautente = YEAR(CURRENT_DATE) - YEAR(datanascita);
        IF temp1 = 0 OR temp2 = 1 OR etautente < etamin OR num_utenti = 0 THEN
			SET _check = FALSE;
		ELSE
			SELECT COUNT(*) into num_prov
            FROM CartaDiCredito C
            WHERE C.Numero = _numero;
            IF num_prov = 0 THEN
				INSERT INTO cartadicredito
				VALUES (_numero, _cvv, _nome, _cognome, _mese, _anno);
			END IF;
			UPDATE Utente U
            SET U.Abbonamento = _abbonamento, U.CartaDiCredito = _numero, U.Inizio = current_date()
            WHERE U.Codice = _codice;
           
			
            SET _check = TRUE;
		END IF;
    END $$
DELIMITER ;

-- -----------------------------------------------------
-- Operazione 7: Emissione di una Fattura
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS emissione_fattura;

DELIMITER $$

CREATE PROCEDURE emissione_fattura(in _utente int, out _check tinyint(1))
begin
    DECLARE abbonamento VARCHAR(45);
    DECLARE carta_di_credito BIGINT;
    DECLARE mese_scadenza INT;
    DECLARE anno_scadenza INT;
    -- recuperiamo i dati di abbonamento e carta di credito associati all'utente
    select U.Abbonamento, U.CartaDiCredito from plz.utente U where U.Codice=_utente into abbonamento, carta_di_credito;
    -- verifichiamo che la carta di credito non sia scaduta
    select MeseScadenza, AnnoScadenza from cartadicredito where Numero=carta_di_credito into mese_scadenza, anno_scadenza;
    if anno_scadenza<year(current_date) or (anno_scadenza=year(current_date)and mese_scadenza<month(current_date))
        then set _check=false;
    else
        insert into fattura(`Saldo`, `Emissione`, `Utente`, `CartaDiCredito`, `Abbonamento`) values(null, current_date, _utente, carta_di_credito, abbonamento);
        set _check = true;
    end if;
end $$

DELIMITER ;



-- -----------------------------------------------------
-- Rinnova abbonamento, parte dell'operazione 7
-- -----------------------------------------------------

drop event if exists rinnova_abbonamento;

DELIMITER $$

create event rinnova_abbonamento
on schedule every 1 day starts '2023-09-30 03:00:00' do
begin
    declare _user int;
    declare _abbonamento varchar(45);
    declare _durata int;
    declare _inizio date;
    declare _check tinyint(1);
    declare _fine tinyint(1) default 0;
    declare c cursor for select Codice from plz.utente where day(utente.Inizio)=day(current_date);
    declare continue handler for not found set _fine = 1;
    open c;
    scan: loop
        fetch c into _user;
        if _fine=1
            then leave scan;
        end if;
        select Abbonamento, Inizio from utente where Codice = _user into _abbonamento, _inizio;
        select Durata from abbonamento where Nome = _abbonamento;
        if _inizio + interval _durata month > current_date
            then update utente set Abbonamento=null, Inizio=null where Codice=_user;
        else
            call emissione_fattura(_user, _check);
        end if;
        
    end loop;
    close c;
end $$
DELIMITER ;
-- -----------------------------------------------------
-- Operazione 8: Inserimento di una recensione
-- -----------------------------------------------------

drop procedure if exists inserisci_recensione;
delimiter $$
create procedure inserisci_recensione(in _voto int, in _testo varchar(3000), in _film int, in _recensore int, in _critico tinyint(1), out check_ tinyint(1))
begin
    -- verifichiamo che l'utente, o il critico, non abbia già recensito il film
    -- il booleano 'critico' discrimina se il recensore e' un critico o meno
    declare recensioniprecedenti, conta_film, conta_recensore int default 0;
    if _critico=1
        then select count(*) into recensioniprecedenti from recensionecritico
            where Critico = _recensore
            and Film = _film;
            select count(*) from Critico C WHERE C.Id = _recensore into conta_recensore;
    else select count(*) into recensioniprecedenti from recensioneutente
            where Utente = _recensore
            and Film = _film;
            select count(*) from Utente U WHERE U.Codice = _recensore into conta_recensore;
    end if;
    SELECT COUNT(*) FROM Film F WHERE F.Id = _film into conta_film;
    if recensioniprecedenti > 0 then set check_ = false;
    else
        if _critico=1 then
            insert into recensionecritico values(_recensore, _film, current_date, _testo, _voto);
        else insert into recensioneutente values (_recensore, _film, current_date, _testo, _voto);
        end if;
		set check_ = true;
    end if;
end $$
delimiter ;

-- -----------------------------------------------------
-- Operazione 9: Bilanciamento del Carico
-- -----------------------------------------------------

 -- indice sigma

drop procedure if exists indice_sigma;
delimiter $$
create procedure indice_sigma(in _server int, out sigma_ double)
begin
    declare beta_1, beta_2, beta_3 double default 0;
    declare larghezza_banda bigint default 0;

    select LarghezzaBanda into larghezza_banda
    from server where Id = _server;

    select 100*sum(Contenuto.Dimensione)/(larghezza_banda*3600*24*30) into beta_1
    from erogazione
    inner join contenuto on erogazione.Contenuto = contenuto.Id
    where erogazione.Server = _server
    and erogazione.Inizio + interval 90 day > current_date
    and erogazione.Inizio + interval 60 day <= current_date;

    select 100*sum(Contenuto.Dimensione)/(larghezza_banda*3600*24*30) into beta_2
    from erogazione
    inner join contenuto on erogazione.Contenuto = contenuto.Id
    where erogazione.Server = _server
    and erogazione.Inizio + interval 60 day > current_date
    and erogazione.Inizio + interval 30 day <= current_date;

    select 100*sum(Contenuto.Dimensione)/(larghezza_banda*3600*24*30) into beta_3
    from erogazione
    inner join contenuto on erogazione.Contenuto = contenuto.Id
    where erogazione.Server = _server
    and erogazione.Inizio + interval 30 day > current_date;

    set sigma_ = (beta_3 + (100-beta_3)*(beta_3-beta_2)/2+ (100-beta_3)*(beta_3 - beta_1)/2)/2 + 50;
end $$
delimiter ;

-- coefficiente eta

drop procedure if exists coefficiente_eta;
delimiter $$
create procedure  coefficiente_eta(in _contenuto int, in server_target int, in server_destinazione int, out eta_ double)
begin
    declare vis int default 0;
    declare b_disp_media_target, b_disp_media_destinazione, num bigint default 0;
    declare distanza_server, lat_d, lon_d, lat_t, lon_t, dim double default 0;
    select Latitudine, Longitudine into lat_t, lon_t
    from server
    where Id = server_target;

    select Latitudine, Longitudine into lat_d, lon_d
    from server
    where Id = server_destinazione;

    select count(*) into vis
    from erogazione
    where Contenuto = _contenuto
    and Server = server_target
    and Inizio + interval 30 day >= current_date;

    select Dimensione/1000000 into dim
    from contenuto
    where Id = _contenuto;

    select (Server.LarghezzaBanda*30*24*3600 - sum(Contenuto.Dimensione))/1000000000000 into b_disp_media_target
    from server
    inner join erogazione
        on erogazione.Server = Server.Id
    inner join contenuto
        on contenuto.Id = erogazione.Contenuto
    where Server.Id = server_target
    and erogazione.Inizio + interval 30 day >= current_date
    group by Server.LarghezzaBanda;

    select (Server.LarghezzaBanda*30*24*3600 - sum(Contenuto.Dimensione))/1000000000000 into b_disp_media_destinazione
    from server
    inner join erogazione
        on erogazione.Server = Server.Id
    inner join contenuto
        on contenuto.Id = erogazione.Contenuto
    where Server.Id = server_destinazione
    and erogazione.Inizio + interval 30 day >= current_date
    group by server.LarghezzaBanda;

    set distanza_server = (power(power((lat_t-lat_d),2)+power((lon_t-lon_d),2), 0.5));

    set num = vis*dim*(b_disp_media_destinazione- b_disp_media_target);
    set eta_ = num /distanza_server;
end $$
delimiter ;

-- procedura finale

drop procedure if exists bilanciamento_carico;
delimiter $$
    create procedure bilanciamento_carico(in _server_target int, in _n int, out sigma_ double )
    begin
    declare s_d, c int default 0;
    declare _eta double default 0;
    declare finito tinyint(1) default 0;
    declare cur cursor for
    select server.Id as server_destinazione, contenuto.Id as contenuto_da_spostare
    from server cross join contenuto
    where (server.Id, contenuto.Id) not in (
        select Server, Contenuto
        from possessoserver
        )
    and contenuto.Id in (
        select Contenuto
        from possessoserver
        where Server = _server_target
        );
    declare continue handler for not found set finito = 1;
    drop temporary table if exists provvisoria_bilanciamento;
    create temporary table provvisoria_bilanciamento(
        `Server` int not null,
        `Contenuto` int not null,
        `Eta` double not null
    );
    open cur;
    scan : loop
        fetch cur into s_d, c;
		if finito
        then leave scan;
        end if;
        call coefficiente_eta(c, _server_target, s_d, _eta);
        insert into provvisoria_bilanciamento values (s_d, c, _eta);
        
    end loop ;
    close cur;
    call indice_sigma(_server_target, sigma_);
    select _server_target as Da, Server as A, Contenuto
    from provvisoria_bilanciamento
    order by Eta desc
    limit _n;
    drop temporary table provvisoria_bilanciamento;
         end $$
delimiter ;

-- -----------------------------------------------------
-- Operazione 10a: Fruizione Media dei Vincoli dell'Abbonamento
-- -----------------------------------------------------

drop procedure if exists fruizione_vincoli_abbonamento;
delimiter $$
create procedure fruizione_vincoli_abbonamento(in mese int, in anno int)
begin
   with base as (
       -- analizziamo la fascia Teen, per piano abbonamento e paese
    select 'Fascia Teen' as Fascia, utente.Codice, paese.Nome as Paese, utente.Abbonamento, sum(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio))/(3600*abbonamento.MaxOre) as fruizione_tempo, sum(contenuto.dimensione/contenuto.lunghezza*if(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)>Contenuto.Lunghezza, contenuto.Lunghezza, timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)))/(1000000000*abbonamento.MaxGB) as fruizione_GB
    from paese cross join abbonamento
    inner join utente
    on utente.Nazionalita = paese.Nome
    and utente.Abbonamento = abbonamento.Nome
    inner join connessione on connessione.Utente = utente.Codice
    inner join erogazione on connessione.Inizio = erogazione.Inizio and connessione.Dispositivo = erogazione.Dispositivo
    inner join contenuto on erogazione.Contenuto = Contenuto.Id
    where Abbonamento.MaxGB is not null and Abbonamento.MaxOre is not null
   and Utente.DataNascita +interval 13 year <= current_date and utente.DataNascita + interval 18 year >current_date
    and month(erogazione.Inizio) = mese and year(erogazione.Inizio) = anno
    group by utente.Codice, paese.Nome, utente.Abbonamento

    union

    -- fascia Young
    select 'Fascia Young' as Fascia, utente.Codice, paese.Nome as Paese, utente.Abbonamento, sum(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio))/(3600*abbonamento.MaxOre) as fruizione_tempo, sum(contenuto.dimensione/contenuto.lunghezza*if(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)>Contenuto.Lunghezza, contenuto.Lunghezza, timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)))/(1000000000*abbonamento.MaxGB) as fruizione_GB
    from paese cross join abbonamento
    inner join utente
    on utente.Nazionalita = paese.Nome
    and utente.Abbonamento = abbonamento.Nome
    inner join connessione on connessione.Utente = utente.Codice
    inner join erogazione on connessione.Inizio = erogazione.Inizio and connessione.Dispositivo = erogazione.Dispositivo
    inner join contenuto on erogazione.Contenuto = Contenuto.Id
    where Abbonamento.MaxGB is not null and Abbonamento.MaxOre is not null
   and Utente.DataNascita +interval 19 year <= current_date and utente.DataNascita + interval 35 year >current_date
    and month(erogazione.Inizio) = mese and year(erogazione.Inizio) = anno
    group by utente.Codice, paese.Nome, utente.Abbonamento

    union
    -- fascia Middle-Aged
    select 'Fascia Middle-Aged' as Fascia, utente.Codice, paese.Nome as Paese, utente.Abbonamento, sum(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio))/(3600*abbonamento.MaxOre) as fruizione_tempo, sum(contenuto.dimensione/contenuto.lunghezza*if(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)>Contenuto.Lunghezza, contenuto.Lunghezza, timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)))/(1000000000*abbonamento.MaxGB) as fruizione_GB
    from paese cross join abbonamento
    inner join utente
    on utente.Nazionalita = paese.Nome
    and utente.Abbonamento = abbonamento.Nome
    inner join connessione on connessione.Utente = utente.Codice
    inner join erogazione on connessione.Inizio = erogazione.Inizio and connessione.Dispositivo = erogazione.Dispositivo
    inner join contenuto on erogazione.Contenuto = Contenuto.Id
    where Abbonamento.MaxGB is not null and Abbonamento.MaxOre is not null
   and Utente.DataNascita +interval 36 year <= current_date and utente.DataNascita + interval 65 year >current_date
    and month(erogazione.Inizio) = mese and year(erogazione.Inizio) = anno
    group by utente.Codice, paese.Nome, utente.Abbonamento

    -- Fascia Senior
    union

    select 'Fascia Senior' as Fascia, utente.Codice, paese.Nome as Paese, utente.Abbonamento, sum(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio))/(3600*abbonamento.MaxOre) as fruizione_tempo, sum(contenuto.dimensione/contenuto.lunghezza*if(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)>Contenuto.Lunghezza, contenuto.Lunghezza, timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)))/(1000000000*abbonamento.MaxGB) as fruizione_GB
    from paese cross join abbonamento
    inner join utente
    on utente.Nazionalita = paese.Nome
    and utente.Abbonamento = abbonamento.Nome
    inner join connessione on connessione.Utente = utente.Codice
    inner join erogazione on connessione.Inizio = erogazione.Inizio and connessione.Dispositivo = erogazione.Dispositivo
    inner join contenuto on erogazione.Contenuto = Contenuto.Id
    where Abbonamento.MaxGB is not null and Abbonamento.MaxOre is not null
   and Utente.DataNascita +interval 66 year <= current_date
    and month(erogazione.Inizio) = mese and year(erogazione.Inizio) = anno
    group by utente.Codice, paese.Nome, utente.Abbonamento
   )
    select Abbonamento, Fascia, Paese, avg(fruizione_tempo) * 100 as fruizione_tempo_media, avg(fruizione_GB) * 100 as fruizione_GB_media
    from base
    group by Abbonamento, Fascia, Paese;
end $$
delimiter ;


-- -----------------------------------------------------
-- Operazione 10b: Lingue per tempo di fruizione, come audio e come sottotitoli
-- -----------------------------------------------------


DROP PROCEDURE IF EXISTS lingue_analytics;

DELIMITER $$

CREATE PROCEDURE lingue_analytics()
BEGIN
with fruizione_trimestre_precedente_sottotitoli as(
        select Lingua, sum(timediff( Fine, Inizio)) as sottotitoli_prec
        from erogazione natural join sottotitoli s
        where erogazione.Inizio +interval 3 month < current_date
        and erogazione.inizio + interval 6 month >= current_date
        group by Lingua
        ),
    fruizione_trimestre_precedente_audio as (
        select c.LinguaAudio as Lingua, sum(timediff(e.Fine, e.Inizio)) as audio_prec
        from erogazione e inner join contenuto c on e.Contenuto = c.Id
        where e.Inizio +interval 3 month < current_date
        and e.inizio + interval 6 month >= current_date
        and c.LinguaAudio is not null
        group by  c.LinguaAudio
        ),
    fruizione_trimestre_attuale_sottotitoli as(
        select Lingua, sum(timediff(Fine, Inizio)) as sottotitoli_attuali
        from erogazione natural join sottotitoli s
        where erogazione.Inizio +interval 3 month >= current_date
        and erogazione.Fine is not null
        group by Lingua
        ),
    fruizione_trimestre_attuale_audio as (
        select c.LinguaAudio as Lingua, sum(timediff(e.Fine, e.Inizio)) as audio_attuale
        from erogazione e inner join contenuto c on e.Contenuto = c.Id
        where e.Inizio +interval 3 month >= current_date
        and e.Fine is not null
        and c.LinguaAudio is not null
        group by  c.LinguaAudio)
    select Lingua, sottotitoli_attuali/3600 as ore_riproduzione_sottotitoli, audio_attuale/3600 as ore_riproduzione_audio,
           (sottotitoli_attuali/sottotitoli_prec -1)*100 as incremento_percentuale_sottotitoli, ((audio_attuale/audio_prec) -1)*100 as incremento_percentuale_audio from
    fruizione_trimestre_attuale_audio
    natural  join fruizione_trimestre_attuale_sottotitoli
    natural join fruizione_trimestre_precedente_audio
    natural join fruizione_trimestre_precedente_sottotitoli;
END $$

DELIMITER ;

-- -----------------------------------------------------
-- Operazione 11: Classifiche
-- -----------------------------------------------------
drop procedure if exists classifiche;

delimiter $$

create procedure classifiche()
begin
-- distinguo i formati audio e video tramite le lettere A e V
with contenuto_formato as (
  select Id as Contenuto, ifnull(concat(CodificaAudio, 'A'), concat(FormatoVideo, 'V')) as Formato
  from contenuto
  left outer join codificavideo
  on contenuto.Id = codificavideo.Contenuto
),
classifica_parziale_1 as (
    select Abbonamento, Nazionalita, Film, Formato, sum(if(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)>Contenuto.Lunghezza, contenuto.Lunghezza, timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio))) as secondi_riproduzione_formato
    from contenuto
    inner join erogazione on contenuto.Id = erogazione.Contenuto
    inner join contenuto_formato on contenuto_formato.Contenuto = contenuto.Id
    inner join connessione on erogazione.Dispositivo = connessione.Dispositivo and erogazione.Inizio = connessione.Inizio
    inner join utente on utente.Codice = connessione.Utente
    where erogazione.Inizio + interval 3 month > current_date
    and Abbonamento is not null
    group by Film, Nazionalita, Abbonamento, Formato
    order by Abbonamento, Nazionalita, Film, secondi_riproduzione_formato desc
    ),
    classifica_parziale_2 as (select u.Abbonamento, u.Nazionalita, Film, sum(if(timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio)>Contenuto.Lunghezza, contenuto.Lunghezza, timediff(ifnull(erogazione.Fine, current_timestamp), erogazione.Inizio))) as secondi_riproduzione_film
    from contenuto inner join erogazione on contenuto.Id = erogazione.Contenuto
    inner join connessione c on erogazione.Dispositivo = c.Dispositivo and erogazione.Inizio = c.Inizio
    inner join utente u on c.Utente = u.Codice
    where erogazione.Inizio + interval 3 month > current_date
    and Abbonamento is not null
    group by u.Abbonamento, u.Nazionalita, Contenuto.Film
    order by Abbonamento, Nazionalita, secondi_riproduzione_film desc)

    select Abbonamento, Nazionalita, Film, secondi_riproduzione_film, Formato, secondi_riproduzione_formato/secondi_riproduzione_film*100 as percentuale_riproduzione
    from classifica_parziale_1 natural join classifica_parziale_2
    where secondi_riproduzione_film is not null
    and secondi_riproduzione_formato is not null
    order by Abbonamento, Nazionalita, secondi_riproduzione_film desc, secondi_riproduzione_formato desc;
end $$
delimiter ;


-- -----------------------------------------------------
-- Operazione 12: Fine Erogazione
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS fine_erogazione;

DELIMITER $$

CREATE PROCEDURE fine_erogazione (IN _id INT, _fine DATETIME)
	BEGIN
		DECLARE dim BIGINT;
	        DECLARE dur INT;
	        SELECT C.Dimensione, C.Lunghezza INTO dim, dur
	        FROM Contenuto C
	        WHERE C.Id = (SELECT E.Contenuto
			      FROM Erogazione E
	                      WHERE E.Id = _id);
		UPDATE Erogazione E
	        SET E.Fine = _fine
	        WHERE E.Id = _id;
	        UPDATE Server S
	        SET S.BandaDisponibile = S.BandaDisponibile + (dim/dur)
	        WHERE S.Id = (SELECT E.Server
			      FROM Erogazione E
	                      WHERE E.Id = _id);
    END $$
DELIMITER ;
