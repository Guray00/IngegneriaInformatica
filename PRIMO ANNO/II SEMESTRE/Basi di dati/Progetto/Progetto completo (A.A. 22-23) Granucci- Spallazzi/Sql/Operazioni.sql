-- --------------------------------
-- Rating Assoluto
-- --------------------------------


DROP PROCEDURE IF EXISTS rating_assoluto;

DELIMITER \\

CREATE PROCEDURE rating_assoluto (IN _idFilm INT, OUT _rating FLOAT)
	BEGIN
    DECLARE _mediaRecensioniUtente, _mediaRecensioniCritica FLOAT;
    DECLARE _premiFilm, _premiAttori, _premiRegista FLOAT;
    SET _mediaRecensioniUtente = (SELECT MediaRecensioni from Film Where Codice = _idFilm);
	SET _mediaRecensioniCritica = (Select ifnull(SUM(Valore)/(count(*)), 0)
									From recensione R
                                    Where R.Film = _idFilm);
    SET _premiFilm = (Select ifnull(sum(P.Valore), 0)
					FROM Vincita V  inner join Premio P on V.Premio = P.Tipo
                    WHERE V.Film = _idFilm);
                    
	SET _premiAttori = (Select ifnull(sum(P.Valore), 0)
						FROM Vincita V inner join premiazioneattore PA on V.Codice = PA.Vincita inner join premio P on V.Premio = P.Tipo
                        Where V.Film <> _idFilm and PA.Attore IN (Select P.Attore from Partecipazione P Where P.Film = _idFilm));
                        
	SET _premiRegista = (Select ifnull(sum(P.Valore), 0)
						FROM Vincita V inner join premiazioneregista PR on V.Codice = PR.Vincita inner join premio P on V.Premio = P.Tipo
                        Where V.Film <> _idFilm and PR.Regista = (Select F.Regista From Film F where F.Codice = _idFilm));
	
	
    SET _rating = (_mediaRecensioniUtente + 1.2 * (_mediaRecensioniCritica)) / (1 + 1.2) + (_premiFilm + 0.5 * _premiAttori + 0.8 * _premiRegista)/10;
    
    IF (_rating > 10) THEN 
		SET _rating = 10;
	END IF;
    
    END \\
DELIMITER ;


-- ---------------------------------------
-- Generi di Film
-- ----------------------------------------
DROP PROCEDURE IF EXISTS Generi_Film;
DELIMITER \\

Create procedure Generi_Film (IN _idFilm INT)
BEGIN
SELECT A.Genere
	FROM Appartenenza A
    WHERE A.Film = _idFilm;
 END \\
DELIMITER ;

-- -----------------------------------------
-- Inserimento Nuovo Acquisto
-- -----------------------------------------
DROP PROCEDURE if exists Inserimento_Nuovo_Acquisto;
DELIMITER \\
create procedure Inserimento_Nuovo_Acquisto(IN _numCarta bigINT , _tipoAbbonamento INT, out _successo BOOL)
	begin
    declare counter int default 1;
    declare _costo int;
    declare _utente VARCHAR(255);
    set _utente = (select Utente from CartaDiCredito where NumeroCarta = _NumCarta);
    set _costo = (select TariffaMensile from abbonamento where Tipo = _tipoAbbonamento);
    
    set _successo = true;
    IF (current_date() < (select Scadenza from cartadicredito where NumeroCarta = _numCarta)) THEN 		
        SET _successo = false;
        
    elseIF((select * 
		from Utente U inner join cartadicredito CDC on U.Codice = CDC.Utente inner join restrizioneAbbonamento RA on U.Stato = RA.Stato
		Where CDC.NumeroCarta= _numcarta and RA.Abbonamento = _tipoAbbonamento) IS NOT NULL) THEN
			SET _successo = false;
	elseif (select MAX(AC.inizioAbbonamento)
            from Acquisto AC inner join CartaDiCredito CDC on CDC.Utente = AC.Utente
			Where CDC.NumeroCarta = _numeroCarta) + INTERVAL (select A.Durata from abbonamento A where A.Tipo = _tipoAbbonamento) MONTH > CURRENT_DATE() THEN 
				SET _successo = false;
    END IF;
    if (_successo = true) THEN 
		INSERT INTO ACQUISTO 
        VALUES ((select CDC.Utente from CartaDiCredito CDC where CDC.Utente = _numCarta),  _tipoAbbonamento, curdate());
		set counter = (select Durata from abbonamento where Tipo = _tipoAbbonamento);
        While counter > 0 DO
			if(counter <> 1) THEN
				insert into fattura
				values (_costo, curdate(), curdate() + INTERVAL _counter MONTH, _utente, null);
            ELSE -- La prima fattura viene pagata in automatico
				insert into fattura
				values (_costo, curdate(), curdate() + INTERVAL _counter MONTH, _utente, _NumCarta);
			END IF;
            set counter = counter - 1;
        END WHILE;
	END IF;
    
END \\
DELIMITER ;

-- -----------------------------------------
-- Inserimento Nuova Connessione
-- ----------------------------------------


DROP PROCEDURE IF EXISTS Inserimento_Nuova_Connessione;
DELIMITER \\
CREATE procedure Inserimento_Nuova_Connessione(IN _codiceUtente varchar(255), _ip INT, _codiceDispositivo INT, out _successo BOOL)
	begin
		declare _stato varchar(255);
        -- Messaggi di errore dovuti all'input incorretto di dati
        IF _codiceUtente NOT IN (select Codice from Utente) THEN 
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'CodiceUtente Non valido';
        ELSEIF _ip NOT between 1 and 255255255255 THEN
			SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Ip non valido';
		ELSEIF _codiceDispositivo NOT IN (select Codice from Dispositivo) THEN 
			SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Dispositivo non valido';
        END IF;
        
        SET _successo = TRUE;
        -- Messaggi di errore dovuti alle ragioni descritte nella documentazione
        IF (select F.CartaDiCredito 
			From Fattura F
            Where F.Utente = _codiceUtente and F.Scadenza = (
																Select min(Scadenza)
																From Fattura
																Where Scadenza > curdate())) IS NOT NULL THEN
			SET _successo = FALSE;
        
        END IF;
        
        set _stato = (select Nome 
					from stato 
					where _ip between IpInizio and IpFine);
		
		if _stato IN (select RA.Stato
					from restrizioneabbonamento RA natural join Abbonamento AB natural join acquisto AC
                    Where AC.Utente = _codiceUtente and AC.InizioAbbonamento = (select max(InizioAbbonamento)
																				from acquisto
                                                                                Where Utente = _codiceUtente) ) THEN
			SET _successo = FALSE;
		elseIF (select ConnessioniAttive from Utente where Codice = _codiceUtente) <= (select AB.MaxConnessioni 
																						from Acquisto AC natural join Abbonamento AB 
                                                                                        WHERE AC.Utente = _codiceUtente and AC.InizioAbbonamento = (select max(InizioAbbonamento)
																															from acquisto
																															Where Utente = _codiceUtente) ) THEN
			set _successo = FALSE;
        END IF;
        
        INSERT INTO connessione
        VALUES (current_timestamp(), _codiceDispositivo, _Ip, null, _codiceUtente);
        
    end \\
DELIMITER ;


-- ------------------------------------
-- Inserimento Nuova Visualizzazione
-- -----------------------------------

-- Funzione per calcolare la ditanza tra due punti sulla terra
DROP function if exists Calcola_Distanza;
DELIMITER \\

CREATE FUNCTION Calcola_Distanza(
    latitudine1 FLOAT, longitudine1 FLOAT,
    latitudine2 FLOAT, longitudine2 FLOAT
) RETURNS FLOAT
DETERMINISTIC
BEGIN
	
    DECLARE raggio FLOAT DEFAULT 6371; -- 
    
    DECLARE dlat FLOAT;
    DECLARE dlon FLOAT;
    DECLARE a FLOAT;
    DECLARE c FLOAT;
    DECLARE distanza FLOAT;
	
    SET raggio = 6371;
    SET dlat = RADIANS(latitudine2 - latitudine1);
    SET dlon = RADIANS(longitudine2 - longitudine1);

    SET a = SIN(dlat / 2) * SIN(dlat / 2) + COS(RADIANS(latitudine1)) * COS(RADIANS(latitudine2)) * SIN(dlon / 2) * SIN(dlon / 2);
    SET c = 2 * ATAN2(SQRT(a), SQRT(1 - a));

    SET distanza = raggio * c;

    RETURN distanza;
END \\

DELIMITER ;

DROP PROCEDURE IF EXISTS Inserimento_Nuova_Visualizzazione;
DELIMITER \\
CREATE PROCEDURE Inserimento_Nuova_Visualizzazione(in _InizioC timestamp, _DispositivoC INT, _CodiceFC INT, out _successo BOOL)
BEGIN
	DECLARE _MaxGB INT;
    DECLARE _MaxRisoluzione INT;
    DECLARE _MBGuardati INT;
	DECLARE _BestServer INT;
    DECLARE _UtenteLatitudine FLOAT;
    DECLARE _UtenteLongitudine FLOAT;
    
    
    IF _InizioC NOT IN (select Inizio from Connessione) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'InizioConnessione non valido';
    ELSEIF _DispositivoC NOT IN (select dispositivo from connessione) Then 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Dispositivo non valido';
    ELSEIF _CodiceFC NOT IN (select codice from filmcodificato) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Codice Film Codificato non valido';
	END IF;

    SET _successo = TRUE;
	SET _MBGuardati = (select SUM (FA.bitrate + FV.bitrate)
				from Visualizzazione V inner join ConnessioneC on V.InizioConnessione = C.Inizio and V.DispositivoConnessione = C.Dispositivo
                inner join filmcodificato FC on FC.Codice = V.FilmCodificato inner join FormatoVideo FV on FV.Codice = FC.FormatoVideo
				inner join formatoaudio FA on FA.Codice = FC.FormatoVideo inner join acquisto AC on AC.Utente = C.Utente inner join Abbonamento AB on AC.Abbonamento = AB.Tipo
					
				Where C.Utente = (Select Utente from connessione where Inizio = _InizioC and Dispositivo = _DispositivoC) and
					AC.InizioAbbonamento = (select max(InizioAbbonamento)
											From Acquisto
                                            Where Utente = (Select Utente from connessione where Inizio = _InizioC and Dispositivo = _DispositivoC)
					and Date(V.Inizio) >= AC.InizioAbbonamento
                ));

    SET _MaxGB = (select AB.MaxGB
				from acquisto AC inner join Abbonamento AB
                where AC.Utente = (select Utente
									from Connessione
                                    Where Inizio = _InizioC and Dispositivo = _DispositivoC ) 
				and AC.InizioAbbonamento = (select max(InizioAbbonamento)
											from Acquisto
											Where Utente =
													(select Utente
													from Connessione
													Where Inizio = _InizioC and Dispositivo = _DispositivoC 
													)));
    SET _MaxRisoluzione = (select ifnull(AB.MaxRisoluzione, 99999)
						from acquisto AC inner join Abbonamento AB
						where AC.Utente = (select Utente
								from Connessione
								Where Inizio = _InizioC and Dispositivo = _DispositivoC ) 
							and AC.InizioAbbonamento = (select max(InizioAbbonamento)
										from Acquisto
										Where Utente =
												(select Utente
												from Connessione
												Where Inizio = _InizioC and Dispositivo = _DispositivoC 
												)));
	SET _UtenteLatitudine = (select S.Latitudine
							from Stato S 
                            Where (select IP from connessione where Inizio = _InizioC and Dispositivo = _DispositivoC) between S.InizioIp and S.FineIp);
	SET _UtenteLongitudine = (select S.Longitudine
								from Stato S
                                Where (select IP from connessione where Inizio = _InizioC and Dispositivo = _DispositivoC) between S.InizioIp and S.FineIp);
                                
                                
    IF (select FV.Risoluzione 
		from filmcodificato FC inner join formatovideo FV ON FC.FormatoVideo = FV.Codice 
        WHERE FC.Codice = _CodiceFC) > _MaxRisoluzione THEN
        
        SET _successo = false;
        
	ELSEIF (select FV.Bitrate + FA.Bitrate
			from filmcodificato FC inner join formatovideo FV on FC.FormatoVideo = FV.codice
				inner join formatoaudio FA on FC.formatoaudio = FA.codice
                Where FC.Codice = _CodiceFC) + _MBGuardati > _MaxGb * 1000 THEN
		set _successo = false;
	ELSEIF _CodiceFC in (select RF.FilmCodificato
						from restrizioneformato RF natural join Stato S
                        where (select IP from connessione where Inizio = _InizioC and Dispositivo = _DispositivoC) between  S.InizioIp and S.FineIp ) THEN
                        
		set _successo = false;
	
	ELSE 
    SET _BestServer = (select Codice
						from server S 
                        Where S.CapacitaAttuale <> S.CapacitaMassima and S.BandaAttuale + (select FV.Bitrate + FA.Bitrate
															from filmcodificato FC inner join formatovideo FV on FC.FormatoVideo = FV.codice
															inner join formatoaudio FA on FC.formatoaudio = FA.codice
                                                            Where FC.Codice = _CodiceFC) < S.LarghezzaDiBanda  
							and  _codiceFC IN (select FilmCodificato From possessoserver PS  Where PS = S1.server)
							and Calcola_Distanza(S.latitudine, S.longitudine,_UtenteLatitudine, _UtenteLongitudine) = 
									(select min(Calcola_Distanza(S.latitudine, S.longitudine,_UtenteLatitudine, _UtenteLongitudine))
									from Server S1
                                     Where S1.CapacitaAttuale <> S1.CapacitaMassima and S1.BandaAttuale + (select FV.Bitrate + FA.Bitrate
															from filmcodificato FC inner join formatovideo FV on FC.FormatoVideo = FV.codice
															inner join formatoaudio FA on FC.formatoaudio = FA.codice
                                                            Where FC.Codice = _CodiceFC) < S1.LarghezzaDiBanda and _codiceFC IN (select FilmCodificato
																																From possessoserver PS
                                                                                                                                Where PS = S1.server)));
		IF _BestServer is NULL THEN
			set _successo = False;
            SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Nessun server disponibile valido';
		END IF;
	
    INSERT INTO visualizzazione
    VALUES (current_timestamp(), _InizioC, _DispositivoC, null, _BestServer, _CodiceFC);
    END IF;
END \\

DELIMITER ;

-- ----------------------------------------------
-- Rating Personalizzato
-- ----------------------------------------------

DROP PROCEDURE IF EXISTS rating_personalizzato;
DELIMITER \\
CREATE PROCEDURE rating_personalizzato(in _codiceUtente VARCHAR(255), _codiceFilm INT, out _rating int)
BEGIN 
	Declare rating_assoluto INT;
    declare finito int default 0;
    declare _preferenza VARCHAR(63);
    Declare _preferenzeSelezionate INT default 0;
    declare VM INT default 1;
    declare PA float default 0;
    declare PR float default 0;
    declare CL float default 0;
    declare BB float default 0;
    declare VSG float default 0;
    declare PrA float default 0;
    
    declare PesoVar float default (1/3);
    Declare _cur CURSOR FOR
		select S.Preferenza
		From selezione S
        Where S.Utente = _codiceUtente;
	declare continue handler
		for not found set finito = 1;
    
    
    IF (_codiceUtente not in (select Codice from Utente)) THEN
		 SIGNAL SQLSTATE '45000' 
		 SET MESSAGE_TEXT = 'codiceUtente non valido';
	ELSEIF (_codiceFilm not in (select Codice from Film)) THEN
		 SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'codiceFilm non valido';
	END IF;
    
    CALL rating_assoluto(_codiceFilm, rating_assoluto);
    
    open _cur;
pref_loop: LOOP
		fetch _cur into _preferenza;
		IF finito = 1 THEN
			LEAVE pref_loop;
		
        elseif _preferenza = 'Attori' THEN
			set _preferenzeSelezionate = _preferenzeSelezionate + 1;
            set PA = 0.5 * ((select COUNT(*)
							from partecipazione P
                            Where P.Attore IN (select Attore
												from Partecipazione
                                                Where Film = _codiceFilm)) / (select IF(Count(*) = 0, 1, Count(*))
																				from Partecipazione
                                                                                Where Film = _CodiceFilm));
			IF PA > 10 THEN
				SET PA = 10;
			END IF;
        elseif _preferenza = 'Registi' THEN
			set _preferenzeSelezionate = _preferenzeSelezionate + 1;
             set PR = 0.8 * (select COUNT(*)
							from Film F
                            Where F.Regista IN (select Regista
												from Film
                                                Where Codice = _codiceFilm));
			IF PA > 10 THEN
				SET PA = 10;
			END IF;
        elseif _preferenza = 'Classici' THEN
			set _preferenzeSelezionate = _preferenzeSelezionate + 1;
            set CL = 0.129 * (year(curdate()) - (select AnnoProduzione
										from film
										where codice = _CodiceFilm));
			IF CL > 10 THEN
				SET CL = 10;
			END IF;
        elseif _preferenza = 'BlockBusters' THEN
			set _preferenzeSelezionate = _preferenzeSelezionate + 1;
			SET VM = ceil((select AVG(cnt) 
						from (
							select COUNT(*) as cnt
                            from visualizzazione V natural join filmcodificato FC
							group by FC.film) AS vis));
                            
			IF (select count(*)
				from Visualizzazione V natural join filmcodificato FC
				Where FC.film = _codiceFilm) = 0 THEN
				
                SET BB = 0;
            ELSE
				SET BB =5 * (log((select if(count(*) < 1, 1, count(*))
						from Visualizzazione V natural join filmcodificato FC
						Where FC.film = _codiceFilm)) / LOG(if(VM < 2, 2, VM)));
			END IF;
			IF BB > 10 THEN
				SET BB = 10;
			END IF;
        END IF;
	END loop pref_loop;
    close _cur;
    
    SET PesoVar =(10 - _preferenzeSelezionate) / 3;
    
    SET VSG = (Select Count(Distinct V.Inizio, V.InizioConnessione, V.dispositivoConnessione)
				from Visualizzazione V natural join filmcodificato FC natural join film F natural join appartenenza A 
					inner join connessione C ON C.Inizio = V.InizioConnessione and C.dispositivo = V.DispositivoConnessione
                Where C.Utente = _codiceUtente and A.Genere IN (select Genere from appartenenza where film = _codiceFilm)) / 
					(select if(count(*) = 0, 1, count(*))
					from visualizzazione V inner join connessione C on C.Inizio = V.InizioConnessione and C.dispositivo = V.DispositivoConnessione
                    Where C.Utente = _codiceUtente) * 10;
	
    SET PrA = (
			Select AVG(cnt) 
			from (Select Count(distinct V.Inizio, V.InizioConnessione, V.DispositivoConnessione) / (select(if(COUNT(*) = 0, 1, count(*)))
												from Visualizzazione V inner join connessione C ON C.Inizio = V.InizioConnessione and C.dispositivo = V.DispositivoConnessione
																											WHERE C.Utente ='U1') as cnt
							from Visualizzazione V inner join connessione C ON C.Inizio = V.InizioConnessione and C.dispositivo = V.DispositivoConnessione
								inner join filmcodificato FC on FC.Codice = V.FilmCodificato inner join Film F on F.Codice = FC.Film 
									inner join partecipazione P on P.Film = F.Codice
							Where C.Utente = 'U1' and P.Attore IN (select Attore
																			from partecipazione
																			Where Film = 1)
							group by P.Attore)
							AS conto_attore) * 10;
	SET _rating = ROUND((PesoVar * rating_assoluto + PesoVar * VSG + PesoVar * PrA + PA + CL + BB) / 10);
END \\
DELIMITER ;

-- -----------------------------------------
-- Raccomandazione Contenuti
-- -----------------------------------------

Drop procedure if exists raccomandazione_contenuti;
DELIMITER \\
create procedure raccomandazione_contenuti (IN _codiceUtente VARCHAR(255))
BEGIN
	

	
declare finito int default 0;
declare _film int;
declare _Punti int;
declare RP int;
declare cur cursor for
	with FilmCodificatiRaccomandabili as (
		select FC.Codice, FC.Lunghezza, FC.Dimensione, FV.Risoluzione, FC.FormatoVideo, FC.FormatoAudio 
		from filmcodificato FC left outer join restrizioneformato RF on FC.Codice = RF.FilmCodificato inner join formatovideo FV on (FC.FormatoVideo = FV.Codice)
		Where RF.Stato <> (select Stato from Utente where Codice = _codiceUtente) 
			and FV.Risoluzione < (select ifnull(AB.MaxRisoluzione, 99999)
									from Abbonamento AB inner join Acquisto AC on AB.Tipo = AC.abbonamento
									Where AC.Utente = _codiceUtente and AC.InizioAbbonamento = (select max(InizioAbbonamento)
																								from Acquisto 
																								where Utente = _codiceUtente))
	),
    FilmVisualizzati as (
		select distinct F.Codice
        from Visualizzazione V inner join filmcodificato FC on V.FilmCodificato = FC.Codice inner join film F on FC.Film = F.Codice
			inner join Connessione C on V.InizioConnessione = C.Inizio and V.DispositivoConnessione = C.Dispositivo
		where C.Utente = _codiceUtente
        ),
    FilmCodificaAmmissibili as (
		select FC.Codice as CodiceCodificato, F.Codice as Film, FC.FormatoVideo, FV.AspectRatio, FV.Risoluzione
        from film F inner join filmcodificato FC on FC.film = F.Codice inner join formatovideo FV on FC.FormatoVideo = FV.Codice
        Where  FC.Codice not in (select Codice from FilmCodificatiRaccomandabili) and F.Codice not in (select codice from FilmVisualizzati)
    ),
    VisualizzazioniLingua as (
		select Lingua
		from Visualizzazione V natural join FilmCodificato FC natural join Audio A
			inner join Connessione C on V.InizioConnessione = C.Inizio and V.DispositivoConnessione = C.Dispositivo
		Where C.Utente = _codiceUtente 
		group by A.Lingua
		Order by COUNT(*) DESC
		LIMIT 2 ),
    
    FilmInLinguePreferite as (
		select distinct FCA.CodiceCodificato as LinguaTop
        from FilmCodificaAmmissibili FCA inner join audio A on FCA.CodiceCodificato = A.FilmCodificato
        Where A.Lingua IN (Select Lingua from VisualizzazioniLingua)
	),
    DispositivoPiuUsato as (
		select D.Codice, D.Risoluzione, D.AspectRatio
        from Dispositivo D inner join Connessione C on D.Codice = C.Dispositivo
		Where C.Utente =  _codiceUtente
        group by D.Codice, D.Risoluzione, D.AspectRatio
        ORDER BY count(*)
        LIMIT 1
    ),
	FilmInRisoluzioneGiusta as (
		select distinct FCA.CodiceCodificato
        from filmCodificaAmmissibili FCA 
        Where FCA.Risoluzione = (select Risoluzione
								from DispositivoPiuUsato)
    ),
	FilmInAspectRatioGiusto as (
		select distinct FCA.CodiceCodificato
        from filmCodificaAmmissibili FCA
        where FCA.AspectRatio = (select AspectRatio
								from DispositivoPiuUsato)
    )
	select FCA.Film, MAX(PunteggioParziale) as Punti
	from (select FCA.CodiceCodificato, COUNT(if(FR.CodiceCodificato IS NULL, 0, 1)) + COUNT(if(FAR.CodiceCodificato is null, 0, 1)) +
			COUNT(if(FLP.LinguaTop is null, 0, 5)) as PunteggioParziale
	from FilmCodificaAmmissibili FCA left outer join FilmInRisoluzioneGiusta FR on FCA.CodiceCodificato = FR.CodiceCodificato
		left outer join FilmInAspectRatioGiusto FAR on FCA.CodiceCodificato = FAR.CodiceCodificato
			left outer join FilmInLinguePreferite FLP on FCA.CodiceCodificato = FLP.LinguaTop
	group by FCA.CodiceCodificato) AS P inner join FilmCodificaAmmissibili FCA on P.CodiceCodificato = FCA.CodiceCodificato
    group by FCA.Film;
    
declare continue handler for not found set finito =1 ;

if _codiceUtente not in (select codice from Utente) THEN
		SIGNAL SQLSTATE '45000' 
		 SET MESSAGE_TEXT = 'codiceUtente non valido';
	END IF;
    
drop temporary table if exists `punteggi`;
create temporary table `punteggi`(
	`Film` Int not null,
    `Punteggio` int not null,
    PRIMARY KEY(`Film`)
	);
open cur;
scan: loop
	fetch cur into _film, _Punti;
    if finito = 1 then
		leave scan;
	END IF;
	call rating_personalizzato(_codiceUtente, _film, RP);
    insert into punteggi
    values (_film, RP + _Punti);
    
end loop;
close cur;

select Film
from punteggi 
order by Punteggio
limit 10;
drop temporary table punteggi;

END \\

DELIMITER ;

-- -----------------------------
-- Caching
-- -----------------------------
DROP PROCEDURE IF EXISTS Caching;
DELIMITER \\
CREATE PROCEDURE caching(in _codiceUtente VARCHAR(255))
BEGIN


declare _filmCodificato int;
declare UtenteLatitudine float;
declare UtenteLongitudine float;
declare finito int default 0;
declare _film int;
declare _Punti int;
declare RP int;
declare _serverTop int;
declare _server2 int;
declare _server3 int;


declare cur cursor for
	with FilmCodificatiRaccomandabili as (
		select FC.Codice, FC.Lunghezza, FC.Dimensione, FV.Risoluzione, FC.FormatoVideo, FC.FormatoAudio 
		from filmcodificato FC left outer join restrizioneformato RF on FC.Codice = RF.FilmCodificato inner join formatovideo FV on (FC.FormatoVideo = FV.Codice)
		Where RF.Stato <> (select Stato from Utente where Codice= _codiceUtente) 
			and FV.Risoluzione < (select ifnull(AB.MaxRisoluzione, 99999)
									from Abbonamento AB inner join Acquisto AC on AC.Abbonamento = AB.Tipo
									Where AC.Utente = _codiceUtente and AC.InizioAbbonamento = (select max(InizioAbbonamento)
																								from Acquisto 
																								where Utente = _codiceUtente))
	),
	FilmVisualizzati as (
		select distinct F.Codice
        from Visualizzazione V natural join filmcodificato FC natural join film F 
			inner join Connessione C on V.InizioConnessione = C.Inizio and V.DispositivoConnessione = C.Dispositivo
		where C.Utente = _codiceUtente
    ),
    FilmCodificaAmmissibili as (
		select FC.Codice as CodiceCodificato, F.Codice as Film, FC.FormatoVideo, FV.AspectRatio, FV.Risoluzione
        from film F inner join filmcodificato FC on FC.film = F.Codice inner join formatovideo FV on FC.FormatoVideo = FV.Codice
        Where  FC.Codice not in (select Codice from FilmCodificatiRaccomandabili) and F.Codice not in (select codice from FilmVisualizzati)
    ),
    VisualizzazioniLingua as (
		select Lingua
		from Visualizzazione V natural join FilmCodificato FC natural join Audio A
			inner join Connessione C on V.InizioConnessione = C.Inizio and V.DispositivoConnessione = C.Dispositivo
		Where C.Utente = _codiceUtente 
		group by A.Lingua
		Order by COUNT(*) DESC
		LIMIT 2
    ),
    FilmInLinguePreferite as (
		select distinct FCA.CodiceCodificato as LinguaTop
        from FilmCodificaAmmissibili FCA inner join audio A on FCA.CodiceCodificato = A.FilmCodificato
			
        Where A.Lingua IN (select Lingua
							from VisualizzazioniLingua)
	),
    DispositivoPiuUsato as (
		select D.Codice, D.Risoluzione, D.AspectRatio
        from Dispositivo D inner join Connessione C on D.Codice = C.Dispositivo
		Where C.Utente =  _codiceUtente
        group by D.Codice, D.Risoluzione, D.AspectRatio
        ORDER BY count(*)
        LIMIT 1
    ),
	FilmInRisoluzioneGiusta as (
		select distinct FCA.CodiceCodificato
        from filmCodificaAmmissibili FCA 
        Where FCA.Risoluzione = (select Risoluzione
								from DispositivoPiuUsato)
    ),
	FilmInAspectRatioGiusto as (
		select distinct FCA.CodiceCodificato
        from filmCodificaAmmissibili FCA
        where FCA.AspectRatio = (select AspectRatio
								from DispositivoPiuUsato)
    ),
    
PunteggioCodifica as (
	select FCA.CodiceCodificato, COUNT(if(FR.CodiceCodificato IS NULL, 0, 1)) + COUNT(if(FAR.CodiceCodificato is null, 0, 1)) +
			COUNT(if(FLP.LinguaTop is null, 0, 5)) as PunteggioParziale
	from FilmCodificaAmmissibili FCA left outer join FilmInRisoluzioneGiusta FR on FCA.CodiceCodificato = FR.CodiceCodificato
		left outer join FilmInAspectRatioGiusto FAR on FCA.CodiceCodificato = FAR.CodiceCodificato
			left outer join FilmInLinguePreferite FLP on FCA.CodiceCodificato = FLP.LinguaTop
	group by FCA.CodiceCodificato
    ),
PunteggioFilm as (
	select FCA.Film, MAX(P.PunteggioParziale) as Punti
	from PunteggioCodifica P inner join FilmCodificaAmmissibili FCA on P.CodiceCodificato = FCA.CodiceCodificato
    group by FCA.Film
)
select PF.Film, PF.Punti, FCA.CodiceCodificato
from FilmCodificaAmmissibili FCA inner join PunteggioCodifica PC  on PC.CodiceCodificato = FCA.CodiceCodificato inner join PunteggioFilm PF on PF.Film = FCA.Film
Where PC.punteggioparziale = (select MAX(PC.punteggioparziale)
								from punteggioCodifica PC1 inner join FilmCodificaAmmissibili FCA1 on PC1.CodiceCodificato = FCA1.CodiceCodificato
                                where FCA.Film = FCA1.Film);
declare continue handler for not found set finito =1 ;


if _codiceUtente not in (select codice from Utente) THEN
		SIGNAL SQLSTATE '45000' 
		 SET MESSAGE_TEXT = 'codiceUtente non valido';
	END IF;

drop temporary table if exists `punteggi`;
create temporary table `punteggi`(
	`Film` Int not null,
    `Punteggio` int not null,
    `FilmCodificaTop` int not null,
    PRIMARY KEY(`Film`)
	);
open cur;
scan: loop
	fetch cur into _film, _Punti, _filmCodificato;
    if finito = 1 then
		leave scan;
	END IF;
	call rating_personalizzato(_codiceUtente, _codiceFilm, RP);
    replace into  punteggi
    values (_film, RP + _Punti, _filmCodificato);
    
end loop;
close cur;
set UtenteLatitudine =  (select Latitudine
						from Stato natural join Utente
						Where Codice = _codiceUtente);
set UtenteLongitudine = (select Longitudine
						from Stato natural join Utente
						Where Codice = _codiceUtente);
set _serverTop = (
	select Codice
    from Server S
    Where (Calcola_Distanza(S.Latitudine, S.Longitudine,UtenteLatitudine,UtenteLongitudine)  = 
			(select min(calcola_Distanza(S1.Latitudine, S1.Longitudine, UtenteLatitudine, UtenteLongitudine))
			from Server S1))
            LIMIT 1);

set _server2 = (
	select Codice
    from Server S
    ORDER BY Calcola_Distanza(S.Latitudine, S.Longitudine,UtenteLatitudine,UtenteLongitudine)
    LIMIT 1 OFFSET 1);
set _server3 = (
	select Codice
    from Server S
    ORDER BY Calcola_Distanza(S.Latitudine, S.Longitudine,UtenteLatitudine,UtenteLongitudine)
    LIMIT 1 OFFSET 2);


    replace into possessoserver
	select P.FilmCodificaTop, _serverTop
	from Punteggi P
    Order by Punteggio
    Limit 10;
    
    replace into possessoserver
    select P.FilmCodificaTop, _server2
    from Punteggi P
    Order by Punteggio
    Limit 3;
    
    replace into possessoserver
    select P.FilmCodificaTop, _server3
    from Punteggi P
    order by Punteggio
    Limit 3;
    
END \\
DELIMITER ;

-- ---------------------------------
-- Bilanciamento del carico
-- ----------------------------------
DROP PROCEDURE IF EXISTS Bilanciamento_del_carico;
DELIMITER \\
Create procedure Bilanciamento_del_carico()
begin
	declare finito INT default 0;
    declare _ServerFonte int;
    declare _filmCodificato int;
	declare closest_server INT;
    declare cur cursor for 
		with PSV as (
		select V.Inizio, V.InizioConnessione, V.DispositivoConnessione, V.Server, S.LarghezzaDiBanda, (FA.Bitrate + FV.Bitrate) * (timestampdiff(second, V.Inizio, V.Fine)) as Punteggio
            from Visualizzazione V inner join filmcodificato FC on V.FilmCodificato = FC.Codice 
				inner join FormatoVideo FV on FC.FormatoVideo = FV.Codice inner join FormatoAudio FA on FC.FormatoAudio = FA.Codice inner join Server S on V.server = S.Codice
			Where V.Fine IS NOT NULL
        ),
        PS as (
			select PSV.Server, PSV.LarghezzaDiBanda , SUM(PSV.Punteggio) as Punti
            from PSV
            group by PSV.Server, PSV.LarghezzaDiBanda
        ), ServerPunti as (
			select PS.Server, RANK() OVER(ORDER BY (PS.Punti/PS.LarghezzaDiBanda) DESC) as Sovraccarico
			from PS),
		ServerFilmCod as (
			select distinct SP.Server, FC.Codice, ((FA.Bitrate + FV.Bitrate) * FC.Lunghezza ) as PSF
            from ServerPunti SP inner join Visualizzazione V on SP.Server = V.Server inner join filmcodificato FC on V.FilmCodificato = FC.Codice
				inner join FormatoVideo FV on FC.FormatoVideo = FV.Codice inner join FormatoAudio FA on FC.FormatoAudio = FA.Codice
            Where SP.Sovraccarico <= 3
        ), PunteggioSovraccaricoCodSer as (
			select SFC.Server, SFC.Codice, RANK() OVER(PARTITION BY SFC.Server ORDER BY SFC.PSF DESC) as PunteggioSovraccarico
			from ServerFilmCod SFC
        )
        select PSCD.Server, PSCD.Codice
        from PunteggioSovraccaricoCodSer PSCD
        Where PSCD.PunteggioSovraccarico < ceil(0.1 * (select COUNT(*)
														from PunteggioSovraccaricoCodSer PSCD1
                                                        Where PSCD.Server = PSCD1.Server));
                                                        
                                                        
        declare continue handler for not found set finito = 1;
        drop temporary table if exists `Provvisoria`;
        create temporary table `Provvisoria`(
        `ServerFonte` INT NOT NULL,
        `FilmCodificato` INT NOT NULL,
        `ServerDestinazione` INT NOT NULL,
        PRIMARY KEY(`ServerFonte`, `FilmCodificato`, `ServerDestinazione`)
        );
	open cur;
	scan: loop
		fetch cur into _ServerFonte, _FilmCodificato;
        IF (FINITO = 1) THEN 
			LEAVE scan;
		END IF;
        SET closest_server = (select S.Codice
							From Server S
                                Where Calcola_Distanza(S.latitudine, S.Longitudine, (select Latitudine
																					from Server
																					Where Codice = _ServerFonte), (select Longitudine
																													from Server
                                                                                                                    Where Codice = _ServerFonte)) =
										(select min(Calcola_Distanza(S.latitudine, S.Longitudine, (select Latitudine
																					from Server
																					Where Codice = _ServerFonte), (select Longitudine
																													from Server
                                                                                                                    Where Codice = _ServerFonte)))
										from Server S)
								);
		INSERT INTO Provvisoria
        VALUES (_ServerFonte, _FilmCodificato, _ClosestServer);
	end loop;
    Select *
    from Provvisoria;
    drop temporary table Provvisoria;
        
end \\
DELIMITER ;


-- --------------------------------------------------
-- Custom Analytics: Profilazione di Film Per Genere
-- --------------------------------------------------

DROP procedure IF EXISTS Custom_Analytic;
DELIMITER \\

CREATE procedure Custom_Analytic()
BEGIN
	declare finito int default 0;
    declare _Genere VARCHAR(63);
    declare _Durata VARCHAR(15);
    declare _Stato VARCHAR(255);
    declare _Anno int;
	declare cur cursor for
	with DurataFilm as (select F.Codice, IF (F.Durata >90, (IF(F.Durata > 120, (IF(F.Durata > 150, 'Molto Lungo', 'Lungo')), 'Medio')), 'Corto') as Durata, F.PaeseDiProduzione, F.AnnoProduzione
						from Film F
	),
    VisualizzazioniFilm as (
		Select DF.Codice, DF.Durata, DF.PaeseDiProduzione, DF.AnnoProduzione, COUNT(*) as Visualizzazioni
        from DurataFilm DF inner join FilmCodificato FC on DF.Codice = FC.Film inner join visualizzazione V on FC.Codice = V.FilmCodificato
        Where MONTH(V.Inizio) = MONTH(Current_DATE) and YEAR(V.Inizio) = YEAR(Current_date)
        group by DF.Codice, Df.Durata, DF.PaeseDiProduzione, DF.AnnoProduzione
    ),
    SommeDurata as (
		select A.Genere, VF.Durata, SUM(VF.Visualizzazioni) as ContoDurata
		from VisualizzazioniFilm VF inner join Appartenenza A on VF.Codice = A.Genere
		GROUP BY A.Genere, VF.Durata
    ),
    SommePaese as (
		select A.Genere, VF.PaeseDiProduzione, SUM(VF.Visualizzazioni) as ContoPaese
		from VisualizzazioniFilm VF inner join Appartenenza A on VF.Codice = A.Genere
		group by A.Genere, VF.PaeseDiProduzione
    ),
    SommeAnno as (
		select A.Genere, VF.AnnoProduzione, SUM(VF.Visualizzazioni) as ContoAnno
		from VisualizzazioniFilm VF inner join Appartenenza A on VF.Codice = A.Genere
		group by A.Genere, VF.AnnoProduzione
    ),
    valoriPiuComuni as (
    select SD.Genere, MAX(SD.ContoDurata) AS MaxDurata, MAX(SP.ContoPaese) as MaxPaese, MAX(SA.ContoAnno) as MaxAnno
    from SommeDurata SD inner join SommePaese SP ON SD.Genere = SP.Genere inner join SommeAnno SA on SP.Genere = SA.Genere
	group by SD.Genere)
    
    select VPC.Genere, SD.Durata, SP.PaeseDiProduzione, SA.AnnoProduzione
    from valoriPiuComuni VPC inner join SommeDurata SD on VPC.genere = SD.Genere inner join sommePaese SP on VPC.Genere = SP.Genere inner join SommeAnno SA on SA.Genere = VPC.Genere
    Where VPC.MaxDurata = SD.ContoDurata and VPC.MaxPaese = SP.ContoPaese and VPC.MaxAnno = SA.ContoAnno;
	
     
    declare continue handler for not found set finito = 1;
    
    drop temporary table if exists `provvisoriacu`;
    create temporary table `provvisoriacu`(
		`Genere` VARCHAR(63) NOT NULL,
        `Durata` VARCHAR(15) NOT NULL,
        `PaeseDiProduzione` VARCHAR(255) NOT NULL,
        `AnnoProduzione` INT NOT NULL,
        PRIMARY KEY (`Genere`)
    );
    open cur;
    scan: loop
		fetch cur into _Genere, _Durata, _Stato, _Anno;
        IF (finito = 1) THEN
			LEAVE scan;
		END IF;
        
        replace into `provvisoriacu`
        values (_Genere, _Durata, _Stato, _Anno);
    end loop;
	
select *
From provvisoriacu;
drop temporary table `provvisoriacu`;
END \\

DELIMITER ;

-- ----------------------------------
-- Classifiche
-- ----------------------------------
DROP PROCEDURE IF EXISTS classifica_stato;
DELIMITER \\
CREATE PROCEDURE classifica_stato()
begin
		with VisualizzazioniFilm as (
			select F.Codice, U.Stato, COUNT(*) as Visualizzazioni
            from Film F natural join FilmCodificato FC inner join visualizzazione V on FC.Codice = V.FilmCodificato 
				inner join Connessione C on C.Inizio = V.InizioConnessione and C.Dispositivo = V.DispositivoConnessione
					inner join Utente U on C.Utente = U.Codice
            group by F.Codice, U.Stato
        ), FilmCodificatoVisualizzazioni as (
			select FC.Codice, FC.Film, U.Stato, Count(*) as Visualizzazioni
            from FilmCodificato FC natural join Visualizzazione V inner join Connessione C on C.Inizio = V.InizioConnessione and C.Dispositivo = V.DispositivoConnessione
				inner join Utente U on C.Utente = U.Codice
            group by FC.Codice, FC.Film, U.Stato
		),
        FilmFilmCodificatoVis as (
			select VF.Stato, VF.Codice, VF.Visualizzazioni, FCV.Codice as CodiceCodificato, FCV.Visualizzazioni as VisualizzazioniContenuto
            from VisualizzazioniFilm VF inner join FilmCodificatoVisualizzazioni FCV on VF.Codice = FCV.Codice and VF.Stato = FCV.Stato
        )
		select FFC.Codice, FFC.Stato, RANK() OVER(partition by FFC.Stato order by FFC.Visualizzazioni DESC) as RankStato
        from FilmFilmCodificatoVis FFC;
        
END \\
DELIMITER ;

DROP PROCEDURE IF EXISTS classifica_abbonamento;
DELIMITER \\
CREATE PROCEDURE classifica_abbonamento()
Begin
	with visualizzazioniFilm as (
		select FC.Film, A.Abbonamento, COUNT(*) as Visualizzazioni
        from filmcodificato FC inner join visualizzazione V on V.FilmCodificato = FC.Codice inner join connessione C  on C.Inizio = V.InizioConnessione and C.Dispositivo = V.DispositivoConnessione
				inner join Utente U on C.Utente = U.Codice inner join acquisto A on A.Utente = U.Codice
		Where DAY(A.InizioAbbonamento) <= DAY(V.Inizio) and timestampdiff(DAY, V.Inizio, A.InizioAbbonamento) =(select min(timestampdiff(Day, V.Inizio, A.InizioAbbonamento))
																											from filmcodificato FC1 natural join visualizzazione V1 inner join connessione C1  on C1.Inizio = V1.InizioConnessione and C1.Dispositivo = V1.DispositivoConnessione
																											inner join Utente U1 on C1.Utente = U1.Codice inner join acquisto A1 on A1.Utente = U1.Codice
																											where DAY(A.InizioAbbonamento) <= DAY(V.Inizio) and FC1.Codice = FC.Codice and V.Inizio = V1.Inizio and V1.InizioConnessione = V.InizioConnessione
																												and V.DispositivoConnessione = V1.DispositivoConnessione
                                                                                                            )
		group by FC.Film, A.Abbonamento
    ), FilmCodificatoVisualizzazioni as (
		select FC.Film,FC.Codice, A.Abbonamento, COUNT(*) as Visualizzazioni
        from filmcodificato FC inner join visualizzazione V on FC.Codice = V.FilmCodificato join connessione C  on C.Inizio = V.InizioConnessione and C.Dispositivo = V.DispositivoConnessione
				inner join Utente U on C.Utente = U.Codice inner join acquisto A on A.Utente = U.Codice
		Where DAY(A.InizioAbbonamento) <= DAY(V.Inizio)  and timestampdiff(DAY, V.Inizio, A.InizioAbbonamento) = (select min(timestampdiff(Day, V1.Inizio, A1.InizioAbbonamento))
																											from filmcodificato FC1 natural join visualizzazione V1 inner join connessione C1  on C1.Inizio = V1.InizioConnessione and C1.Dispositivo = V1.DispositivoConnessione
																											inner join Utente U1 on C1.Utente = U1.Codice inner join acquisto A1 on A1.Utente = U1.Codice
																											where DAY(A.InizioAbbonamento) <= DAY(V.Inizio) and FC1.Codice = FC.Codice and V.Inizio = V1.Inizio and V1.InizioConnessione = V.InizioConnessione
																												and V.DispositivoConnessione = V1.DispositivoConnessione
                                                                                                            )
		group by FC.Film,FC.Codice, A.Abbonamento
    ),
	FilmFilmCodificatoVis as (
		select VF.Abbonamento, VF.Film, VF.Visualizzazioni, FCV.Codice as CodiceCodificato, FCV.Visualizzazioni as VisualizzazioniContenuto
		from VisualizzazioniFilm VF inner join FilmCodificatoVisualizzazioni FCV on VF.Film = FCV.Codice and VF.Abbonamento = FCV.Abbonamento
	)
	select FFC.Film, FFC.abbonamento, RANK() OVER(Partition by FFC.Abbonamento ORDER BY (Visualizzazioni) DESC) as RankFilm, FFC.CodiceCodificato, RANK()  OVER(Partition by FFC.Abbonamento, FFC.CodiceCodificato order by(VisualizzazioniContenuto) DESC) as RankCodificato
	from FilmFilmCodificatoVis FFC;
    
    
    
END \\
DELIMITER ;


DROP PROCEDURE IF EXISTS Classifiche;
DELIMITER \\
CREATE PROCEDURE Classifiche(in _tipo varchar(15))
begin
	IF (_tipo <> 'Stato' and _tipo <> 'Abbonamento') THEN 
		SIGNAL SQLSTATE '45000' 
		 SET MESSAGE_TEXT = 'Input non valido';
	END IF;
	IF (_tipo = 'Stato') THEN 
		call classifica_stato();
	else
		call classifica_abbonamento();
	END IF;
end \\
DELIMITER ;



