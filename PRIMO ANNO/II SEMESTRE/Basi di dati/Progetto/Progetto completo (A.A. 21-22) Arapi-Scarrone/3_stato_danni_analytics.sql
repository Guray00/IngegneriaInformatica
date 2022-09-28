use PAS;

-- parametri costanti per le prossime funzioni; devono persistere quindi @var non andava bene
delimiter :)
drop function if exists peso_struttura :)                       create function peso_struttura() returns float deterministic begin return                       1; end :)
drop function if exists peso_muri :)                            create function peso_muri() returns float deterministic begin return                            1; end :)
drop function if exists peso_ambiente :)                        create function peso_ambiente() returns float deterministic begin return                        0.1; end :)
drop function if exists coefficiente_struttura_accelerometro :) create function coefficiente_struttura_accelerometro() returns float deterministic begin return 10; end :)
drop function if exists coefficiente_struttura_giroscopio :)    create function coefficiente_struttura_giroscopio() returns float deterministic begin return    5; end :)
drop function if exists coefficiente_muri :)                    create function coefficiente_muri() returns float deterministic begin return                    1; end :)
drop function if exists coefficiente_ambiente_temperatura :)    create function coefficiente_ambiente_temperatura() returns float deterministic begin return    0.5; end :)
drop function if exists coefficiente_ambiente_escursione :)     create function coefficiente_ambiente_escursione() returns float deterministic begin return     0.5; end :)
drop function if exists offset_escursione :)                    create function offset_escursione() returns float deterministic begin return                    10; end :)
drop function if exists coefficiente_ambiente_umidita :)        create function coefficiente_ambiente_umidita() returns float deterministic begin return        0.25; end :)
drop function if exists soglia_ricostruzione :)                 create function soglia_ricostruzione() returns float deterministic begin return                 50; end :)
delimiter ;

-- DANNI -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop function if exists pga_to_mercalli;
delimiter :)
create function pga_to_mercalli(_pga float) returns float deterministic
begin
	return 8.869*power(_pga, 0.1935117);
end :)
delimiter ;

drop function if exists mercalli_to_pga;
delimiter :)
create function mercalli_to_pga(_mercalli float) returns float deterministic
begin
	return power(_mercalli/8.869, 1/0.1935117);
end :)
delimiter ;

drop function if exists distanza_superficie_terrestre;
delimiter :)
create function distanza_superficie_terrestre(lat1 decimal(9,6), long1 decimal(9,6),
	lat2 decimal(9,6), long2 decimal(9,6)) returns float deterministic
begin
	set lat1 = lat1 * pi() / 180;
    set long1 = long1 * pi() / 180;
    set lat2 = lat2 * pi() / 180;
    set long2 = long2 * pi() / 180;
	return 6373*acos((sin(lat1) * sin(lat2)) + cos(lat1) * cos(lat2) * cos(long2-long1));
end :)
delimiter ;

drop function if exists media_sopra_soglia;
delimiter :)
create function media_sopra_soglia(_edificio int, _tipo varchar(45), _datetime_end datetime, _datetime_start datetime) returns float reads sql data
begin
	declare media_medie float;
    
	select avg(media_sensore)
	into media_medie
    from (
		select
			S.id,
			S.soglia,
			avg(M.xOppureUnico) as media_sensore
		from sensore S inner join vano V on S.vano=V.id inner join misura M on M.sensore=S.id
		where V.edificio = _edificio and S.tipo=_tipo and M.timestamp between _datetime_start and _datetime_end
        group by S.id
        ) sensors_avg
	where media_sensore > soglia;
    
	return ifnull(media_medie, 0);
end :)
delimiter ;

drop function if exists media_triassiale;
delimiter :)
create function media_triassiale(_edificio int, _tipo varchar(45), _limit int, _datetime datetime) returns float reads sql data
begin
	declare media_modulo float;
    
	select avg(modulo)
	into media_modulo
    from (
		select
			S.soglia,
			sqrt(power(M.xOppureUnico, 2)+power(M.y, 2)+power(M.z, 2)) as modulo
		from sensore S inner join vano V on S.vano=V.id inner join misura M on M.sensore=S.id
		where V.edificio = _edificio and S.tipo=_tipo and M.timestamp <= _datetime
        order by modulo desc
        limit _limit
        ) top_values;
    
		return ifnull(media_modulo, 0);
end :)
delimiter ;

drop function if exists linear_best_fit_predict;
delimiter :)
create function linear_best_fit_predict (sensore_id int, _datetime_end datetime, _datetime_start datetime, _datetime_predict datetime) returns float reads sql data
begin
	declare x_avg, y_avg, m, q float;
    
	select avg(xOppureUnico), avg(to_seconds(timestamp)-to_seconds(_datetime_end))
	into y_avg, x_avg
    from misura
    where sensore = sensore_id and timestamp between _datetime_start and _datetime_end;
    
    select
		sum((to_seconds(timestamp)-to_seconds(_datetime_end) - x_avg)*(xOppureUnico-y_avg))/
        sum(power((to_seconds(timestamp)-to_seconds(_datetime_end))-x_avg, 2)), -- m
        y_avg - x_avg*
        sum((to_seconds(timestamp)-to_seconds(_datetime_end) - x_avg)*(xOppureUnico-y_avg))/
        sum(power((to_seconds(timestamp)-to_seconds(_datetime_end))-x_avg, 2)) -- q
	into m, q
    from misura
    where sensore = sensore_id and timestamp between _datetime_start and _datetime_end;
    
    return m*(to_seconds(_datetime_predict)-to_seconds(_datetime_end)) + q;
end :)
delimiter ;

/*
Stima la gravità causata da una calamità in un dato punto di una zona geografica,
sfruttando l'intensità calcolata con i dati dei sensori e i coefficienti di rischio della zona
*/
drop function if exists stima_gravita;
delimiter :)
create function stima_gravita(_datacalamita datetime, _tipocalamita varchar(45), _latitudine decimal(9,6), _longitudine decimal(9,6), _zona varchar(45)) returns float reads sql data
begin
	declare _lat_centro, _long_centro decimal(9, 6);
    declare _intensita, _k float;
    
	select latitudine, longitudine, intensita
    into _lat_centro, _long_centro, _intensita
    from calamita
    where data = _datacalamita and tipo = _tipocalamita;
    
    if _lat_centro is null or _long_centro is null or _intensita is null then
		signal sqlstate "45000" set message_text = "Calamita non inserita correttamente";
	end if;
    
    select coefficienterischio into _k from rischiogeologico where zona = _zona and tipologia = _tipocalamita;
    
	if _k is null then
		signal sqlstate "45000" set message_text = "ZonaGeografica non soggetta a tale rischio o parametri errati";
	end if;
    
    return pga_to_mercalli(mercalli_to_pga(_intensita)/power(distanza_superficie_terrestre(_latitudine, _longitudine, _lat_centro, _long_centro)/_k+1, 2));
end :)
delimiter ;

drop trigger if exists update_intensita_calamita;
delimiter :)
create trigger update_intensita_calamita after insert on danneggiamento for each row
begin
	declare _data datetime(3);
    declare _latitudine, _longitudine decimal (9,6);
    declare _tipo varchar(45);
    declare _intensita_stimata float;
    
	select data, tipo, latitudine, longitudine
    into _data, _tipo, _latitudine, _longitudine
    from calamita
    where data=new.datacalamita and tipo=new.tipocalamita;
    
	select avg(
		pga_to_mercalli(media_triassiale(E.id, 'Accelerometro', 10, _data + interval 1 day) *
        power(distanza_superficie_terrestre(_latitudine, _longitudine, E.latitudine, E.longitudine)/R.coefficienterischio+1, 2)))	-- +1 evitare potenza infinita nel punto della calamita
	into _intensita_stimata
    from danneggiamento D natural join edificio E natural join rischiogeologico R
    where D.datacalamita = _data and D.tipocalamita = _tipo;
    
    update calamita
    set intensita =_intensita_stimata
    where data = _data and tipo = _tipo;
end :)
delimiter ;

drop procedure if exists stato_edificio;
delimiter :)
create procedure stato_edificio (in _edificio int, in _datetime datetime, out stato_generale float, out stato_struttura float, out stato_muri float, out stato_ambiente float)
begin
	declare escursione float;
    
	set stato_struttura = 
		media_triassiale(_edificio, 'Accelerometro', 300, _datetime)*coefficiente_struttura_accelerometro()
        + media_triassiale(_edificio, 'Giroscopio', 300, _datetime)*coefficiente_struttura_giroscopio();

	select sum(prediction-soglia)*coefficiente_muri()
    into stato_muri
    from (
		select
			S.soglia,
			linear_best_fit_predict(S.id, _datetime, _datetime-interval 1 week, _datetime+interval 1 week) as prediction
		from sensore S inner join vano V on S.vano = V.id
		where V.edificio = _edificio and S.tipo='Allungamento'
        ) sensors_predict
	where prediction > soglia;
    
	set stato_muri = ifnull(stato_muri, 0);
    
    select max(M.xOppureUnico)-min(M.xOppureUnico)
	into escursione
	from sensore S inner join vano V on S.vano = V.id inner join misura M on M.sensore = S.id
	where
		V.edificio = _edificio and
        S.tipo='Temperatura' and
        M.timestamp between _datetime-interval 1 week and _datetime;
    
    if escursione is null or escursione < offset_escursione() then
		set escursione = 0;
	else
		set escursione = escursione-offset_escursione();
	end if;
    
	set stato_ambiente = 
		media_sopra_soglia(_edificio, 'Temperatura', _datetime, _datetime-interval 1 week)*coefficiente_ambiente_temperatura()
        + media_sopra_soglia(_edificio, 'Umidita',  _datetime, _datetime-interval 1 week)*coefficiente_ambiente_umidita()
		+ escursione*coefficiente_ambiente_escursione();

    set stato_generale = (stato_struttura*peso_struttura() + stato_muri*peso_muri() + stato_ambiente*peso_ambiente())/(peso_struttura()+peso_muri()+peso_ambiente());
end :)
delimiter ;

/* ANALYTICS: consigli di intervento -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   muro_sensore: determina in quale muro si trova il sensore (se è in un'intersezione, il primo che trova)
   costo_costruzione_muro_from_sensore: se il muro / i muri crollano, quanto costa ricostruirli
   consigli_intervento: scrive in output i consigli
*/
drop function if exists muro_sensore;
delimiter :)
create function muro_sensore(_id_sensore int) returns int reads sql data
begin
	declare x2, y2, id_muro int;
    
    select min(if(x0 < x1, x0, x1))+S.x, min(if(y0 < y1, y0, y1))+S.y
	into x2, y2
	from muro M inner join sensore S on (M.vano1 = S.vano or M.vano2 = S.vano)
    where S.id=_id_sensore
    group by S.x, S.y; -- per far felice only_full_group_by, ma tanto è const

	select M.id
    into id_muro
	from muro M inner join sensore S on (M.vano1 = S.vano or M.vano2 = S.vano)
	where S.id = _id_sensore and
		x0 * (y1 - y2) + x1 * (y2 - y0) + x2 * (y0 - y1) = 0 and x2 between mn(x0, x1) and mx(x0, x1) and y2 between mn(y0, y1) and mx(y0, y1)
	limit 1; -- se il sensore è posto all'intersezioni di due muri ne ritorno solo uno, nel calcolo del costo vengono considerati entrambi
    
    return id_muro;
end :)
delimiter ;

drop function if exists costo_costruzione_muro_from_sensore;
delimiter :)
create function costo_costruzione_muro_from_sensore(_id_sensore int) returns decimal(10,2) reads sql data
begin
	declare costo decimal (10, 2) default 0;
    declare x2, y2 int;
    
    select min(if(x0 < x1, x0, x1))+S.x, min(if(y0 < y1, y0, y1))+S.y
	into x2, y2
	from muro M inner join sensore S on (M.vano1 = S.vano or M.vano2 = S.vano)
    where S.id=_id_sensore
    group by S.x, S.y; -- per far felice only_full_group_by, ma tanto è const
    
	select sum(calcolo_costo_lavoro(LSM.lavoro))
	into costo
	from muro M inner join sensore S on (M.vano1 = S.vano or M.vano2 = S.vano) inner join lavorosumuro LSM on M.id=LSM.muro
	where S.id = _id_sensore and
		x0 * (y1 - y2) + x1 * (y2 - y0) + x2 * (y0 - y1) = 0 and x2 between mn(x0, x1) and mx(x0, x1) and y2 between mn(y0, y1) and mx(y0, y1);

	return costo;
end :)
delimiter ;

drop procedure if exists consigli_intervento;
delimiter :)
create procedure consigli_intervento(_edificio int, _datetime datetime)
begin
	select
		(prediction-soglia)*coefficiente_muri() as urgenza,
		if((prediction-soglia)*coefficiente_muri() < soglia_ricostruzione(), 'Consolidamento', 'Ricostruzione') as intervento,
        'Muro' as tipo_elemento,
        muro_sensore(SP.id) as id_elemento,
        costo_costruzione_muro_from_sensore(SP.id) as stima_spesa_crollo,
        SP.id as id_sensore
    from (
		select
			S.id,
			S.soglia,
			linear_best_fit_predict(S.id, _datetime, _datetime-interval 1 week, _datetime+interval 1 week) as prediction
		from sensore S inner join vano V on S.vano = V.id
		where V.edificio = _edificio and S.tipo='Allungamento'
        ) SP
	where prediction > soglia
 
    union
    
    select
		media_triassiale(_edificio, 'Accelerometro', 300, _datetime)*coefficiente_struttura_accelerometro() as urgenza,
		if(media_triassiale(_edificio, 'Accelerometro', 300, _datetime)*coefficiente_struttura_accelerometro() < soglia_ricostruzione(), 'Consolidamento', 'Ricostruzione') as intervento,
        'Struttura edificio' as tipo_elemento,
        null as id_elemento,
        costo_lavori_edificio(_edificio) as stima_spesa_crollo,
        null as id_sensore
        
	union
    
	select
        media_triassiale(_edificio, 'Giroscopio', 300, _datetime)*coefficiente_struttura_giroscopio() as urgenza,
		if(media_triassiale(_edificio, 'Giroscopio', 300, _datetime)*coefficiente_struttura_giroscopio() < soglia_ricostruzione(), 'Raddrizzamento', 'Ricostruzione') as intervento,
        'Struttura edificio' as tipo_elemento,
        null as id_elemento,
        costo_lavori_edificio(_edificio) as stima_spesa_crollo,
        null as id_sensore
        
	union

    select * from
		(select
			(max(M.xOppureUnico)-min(M.xOppureUnico)-offset_escursione())*coefficiente_ambiente_escursione() as urgenza,
			'Cappotti di isolamento' as intervento,
			'Vano' as tipo_elemento,
			V.id as id_elemento,
			0 as stima_spesa_crollo,
			S.id as id_sensore
		from sensore S inner join vano V on S.vano = V.id inner join misura M on M.sensore = S.id
		where
			V.edificio = _edificio and
			S.tipo='Temperatura' and
			M.timestamp between _datetime-interval 1 week and _datetime
		group by S.id) TMP
	where TMP.urgenza >= 0
    
    union
    
    select * from
		(select
			(avg(M.xOppureUnico)-S.soglia)*coefficiente_ambiente_temperatura() as urgenza,
			'Installazione climatizzazione' as intervento,
			'Vano' as tipo_elemento,
			V.id as id_elemento,
			0 as stima_spesa_crollo,
			S.id as id_sensore
		from sensore S inner join vano V on S.vano = V.id inner join misura M on M.sensore = S.id
		where
			V.edificio = _edificio and
			S.tipo='Temperatura' and
			M.timestamp between _datetime-interval 1 week and _datetime
		group by S.id) TMP
    where TMP.urgenza >= 0
    
    union
    
    select * from 
		(select
			(avg(M.xOppureUnico)-S.soglia)*coefficiente_ambiente_umidita() as urgenza,
			'Installazione deumidificatore' as intervento,
			'Vano' as tipo_elemento,
			V.id as id_elemento,
			0 as stima_spesa_crollo,
			S.id as id_sensore
		from sensore S inner join vano V on S.vano = V.id inner join misura M on M.sensore = S.id
		where
			V.edificio = _edificio and
			S.tipo='Umidita' and
			M.timestamp between _datetime-interval 1 week and _datetime
		group by S.id) TMP
    where TMP.urgenza >= 0

    order by urgenza desc;
    
end :)
delimiter ;

/* ANALYTICS: stima dei danni -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
   media_triassiale_durante_terremoto: accelerazione (scalare) media nei campioni più forti nei minuti vicini a un terremoto
   peggioramento_per_calamita: per i sensori di allungamento, valore dopo la calamità - prima
   stima_danni_terremoto: dato un sensore di allungamento, stima il valore che questo potrebbe raggiungere (e quindi i danni) dopo un terremoto simulato
*/

drop function if exists media_triassiale_durante_terremoto;
delimiter :)
create function media_triassiale_durante_terremoto(_edificio int, _tipo varchar(45), _limit int, _datetime datetime) returns float reads sql data
begin
	declare media_modulo float;
    
	select avg(modulo)
	into media_modulo
    from (
		select
			S.soglia,
			sqrt(power(M.xOppureUnico, 2)+power(M.y, 2)+power(M.z, 2)) as modulo
		from sensore S inner join vano V on S.vano=V.id inner join misura M on M.sensore=S.id
		where V.edificio = _edificio and S.tipo=_tipo and M.timestamp between _datetime-interval 15 minute and _datetime+interval 15 minute
        order by modulo desc
        limit _limit
        ) top_values;
    return ifnull(media_modulo, 0);
end :)
delimiter ;

drop function if exists peggioramento_per_calamita;
delimiter :)
create function peggioramento_per_calamita(_sensore int, _data datetime, _tipo varchar(45)) returns float reads sql data
begin
	declare result float;
    
	select max(M.xoppureunico) - min(M.xoppureunico)
    into result
    from sensore S inner join misura M on S.id=M.sensore
    where S.id=_sensore and M.timestamp between _data-interval 6 hour and _data+interval 6 hour;
    
    return result;
end :)
delimiter ;

drop procedure if exists stima_danni_terremoto;
delimiter :)
create procedure stima_danni_terremoto(in _sensore int, in _intensita float, in _lat decimal(9,6), in _long decimal(9,6))
begin
	declare valore_attuale, stima_intensita, m, q, x_avg, y_avg float;
    
    select xoppureunico
    into valore_attuale
    from misura
    where sensore=_sensore and timestamp=(select max(timestamp) from misura where sensore=_sensore);
    
    select mercalli_to_pga(_intensita)/power(distanza_superficie_terrestre(_lat, _long, E.latitudine, E.longitudine)/R.coefficienterischio+1, 2)
    into stima_intensita
    from sensore S inner join vano V on S.vano=V.id
		inner join edificio E on V.edificio=E.id
		inner join rischiogeologico R on E.zonageografica=R.zona
	where R.tipologia='Terremoto' and S.id=_sensore;
    
    create temporary table if not exists storico(
		x float,
        y float
    ) ENGINE = InnoDB;
    
    truncate table storico;
    
    insert into storico
	select
		media_triassiale_durante_terremoto(E.id, 'Accelerometro', 10, C.data) as x,
		peggioramento_per_calamita(_sensore, C.data, C.tipo) as y
	from sensore S inner join vano V on S.vano=V.id
		inner join edificio E on V.edificio=E.id
		natural join danneggiamento D
		inner join calamita C on (C.data=D.datacalamita and C.tipo=D.tipocalamita)
	where D.tipocalamita='Terremoto' and S.id=_sensore;
	
	select
		avg(x),
		avg(y)
	into x_avg, y_avg
	from storico;
  
    if x_avg is null then
	    signal sqlstate '45000'
        set message_text = "Non ci sono dati sufficienti per stimare i danni presso questo sensore.";
    elseif 0 != (select sum(power(x-x_avg, 2)) from storico) then
        select
    		sum((x - x_avg)*(y-y_avg))/
            sum(power(x-x_avg, 2)), -- m
            y_avg - x_avg*
            sum((x - x_avg)*(y-y_avg))/
            sum(power(x-x_avg, 2)) -- q
	    into m, q
        from storico;
    else
        select 0, x_avg into m, q;
	end if;
    select valore_attuale + m*stima_intensita + q;
    
end :)
delimiter ;
