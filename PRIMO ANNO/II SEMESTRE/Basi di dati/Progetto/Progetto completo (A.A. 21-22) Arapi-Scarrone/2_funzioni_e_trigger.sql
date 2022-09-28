use PAS;

/* TRIGGER / CHECK -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

cclockwise: funzione di utilità per controllare prodotti tra vettori
mn, mx: funzioni di utilità per trovare il minimo / massimo tra due interi
intersezione_muri: funzione che prende le coordinate di due muri e ritorna true se si intersecano
    per questa funzione, due muri non si intersecano se hanno un estremo in comune,
    ma invece si intersecano se un estremo di un muro è un punto interno dell'altro

check_piano: il piano è zero oppure esistono i piani intermedi
check_muro: il muro ha una lunghezza nonzero, collega due vani dello stesso piano e non interseca altri muri
check_apertura: l'apertura non supera gli estremi del muro a cui appartiene

check_sensore: il sensore deve trovarsi dentro un vano
alert_sensore: se l'ultima misura supera la soglia, genera l'alert

utilizzo_materiale: controlla alcuni vincoli sui materiali e aggiorna la ridondanza sul materiale rimasto
calcolo_costo_lavoro: funzione di utilità per calcolare il costo complessivo di un
	lavoro (manodopera, materiale e capocantiere)
costo_lavoro: aggiorna la ridondanza sul costo del progetto

cleanup_sensori: event giornaliero che elimina le misure più vecchie di una settimana se non sono alert

*/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop function if exists cclockwise;
drop function if exists mn;
drop function if exists mx;
drop function if exists intersezione_muri;
delimiter :)
create function cclockwise (x0 bigint, y0 bigint, x1 bigint, y1 bigint, x2 bigint, y2 bigint) returns tinyint deterministic
begin
	declare val bigint;
	set x1 = x1 - x0, x2 = x2 - x0, y1 = y1 - y0, y2 = y2 - y0;
    set val = x1 * y2 - x2 * y1;
    if val > 0 then return 1; end if;
    if val = 0 then return 0; end if;
    if val < 0 then return -1; end if;
end :)

create function mn (a int, b int) returns int deterministic
begin
    return if(a < b, a, b);
end :)
create function mx (a int, b int) returns int deterministic
begin
    return if(a > b, a, b);
end :)

create function intersezione_muri (x0 int, y0 int, x1 int, y1 int, x2 int, y2 int, x3 int, y3 int) returns tinyint deterministic
begin
	if cclockwise(x0, y0, x3, y3, x1, y1) * cclockwise(x0, y0, x1, y1, x2, y2) +
        cclockwise(x2, y2, x1, y1, x3, y3) * cclockwise(x2, y2, x3, y3, x0, y0) > 0 then
        -- non paralleli e si intersecano
	    return true;
	end if;
	if cclockwise(x0, y0, x2, y2, x1, y1) = 0 and cclockwise(x0, y0, x3, y3, x1, y1) = 0 then
		-- paralleli
		if (mn(x0, x1) >= mx(x2, x3) or mx(x0, x1) <= mn(x2, x3)) and
		    (mn(y0, y1) >= mx(y2, y3) or mx(y0, y1) <= mn(y2, y3)) then
            return false;
		end if;
		return true;
	end if;
    return false;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop trigger if exists check_piano;
delimiter :)
create trigger check_piano before insert on piano for each row
begin
    if NEW.numero > 0 and not exists (select 1 from piano where edificio = new.edificio and numero = new.numero-1)
	then
        signal sqlstate '45000'
        set message_text = "Non puoi inserire il piano x senza il piano x-1";
	end if;
    if NEW.numero < 0 and not exists (select 1 from piano where edificio = new.edificio and numero = new.numero+1)
	then
        signal sqlstate '45000'
        set message_text = "Non puoi inserire il piano sotterraneo x senza il piano x+1";
	end if;
end :)
delimiter ;

drop trigger if exists check_muro;
delimiter :)
create trigger check_muro before insert on muro for each row
begin
    declare error_str varchar(255) default null;
    declare p, e int default 0;
    
	if new.x0 = new.x1 and new.y0 = new.y1 then
		signal sqlstate "45000" set message_text = "Non puoi inserire un muro di lunghezza nulla";
	end if;
    
    if new.vano1 = new.vano2 then
		signal sqlstate "45000" set message_text = "Il muro non può dividere un vano da sé stesso";
    elseif new.vano2 is not null then
		select count(distinct V.piano), count(distinct V.edificio)
		from vano V where V.id = new.vano1 or V.id = new.vano2
        into p, e;
		if p > 1 or e > 1 then
			signal sqlstate "45000" set message_text = "Il muro non può dividere due vani appartenenti a due piani o edifici diversi";
        end if;
    end if;
    
    if exists (
		select 1 from muro M inner join vano V on M.vano1 = V.id
		where (V.piano, V.edificio) = (select V.piano, V.edificio from vano V where V.id = new.vano1)
		and intersezione_muri(M.x0, M.y0, M.x1, M.y1, new.x0, new.y0, new.x1, new.y1))
	then signal sqlstate "45000" set message_text = "Il muro non può intersecare altri muri";
	end if;
end :)
delimiter ;

drop trigger if exists check_apertura;
delimiter :)
create trigger check_apertura before insert on apertura for each row
begin
	declare len, h int;
    set len = (select sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0)) from muro where id = new.muro);
    set h = (select min(if(V.altezzamax is null, 696969, V.altezzamax)) from muro M inner join vano V on M.vano1 = V.id or M.vano2 = V.id where M.id = new.muro);
	if new.sopra <= new.sotto or new.destra = new.sinistra then
		signal sqlstate "45000" set message_text = "Altezza o larghezza nulle";
	end if;
    if new.sopra > h then
		signal sqlstate "45000" set message_text = "L'apertura non può essere più alta dei due vani che collega";
	end if;
    if new.sotto < 0 then
		signal sqlstate "45000" set message_text = "L'apertura non può scendere più in basso del pavimento";
	end if;
	if new.sinistra < 0 or new.destra < 0 then
		signal sqlstate "45000" set message_text = "L'apertura non può andare prima dell'inizio del muro";
	end if;
    if new.sinistra > len or new.destra > len then
		signal sqlstate "45000" set message_text = "L'apertura non può andare oltre la fine del muro";
	end if;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop trigger if exists check_sensore;
delimiter :)
create trigger check_sensore before insert on sensore for each row
begin
	declare x_off, y_off, zmax, cnt, x2, y2 int;
    declare vert, sul_muro boolean;
    select altezzamax from vano where id = new.vano into zmax;
	if not new.z between 0 and zmax then signal sqlstate "45000" set message_text = "Altezza del sensore non valida"; end if;
    select min(if(x0 < x1, x0, x1)), min(if(y0 < y1, y0, y1)) from muro where vano1 = new.vano or vano2 = new.vano into x_off, y_off;

	set x2 = new.x + x_off;
    set y2 = new.y + y_off;

    select exists (select M.id from muro M where (M.vano1 = new.vano or M.vano2 = new.vano) and ((x2, y2) = (M.x0, M.y0) or (x2, y2) = (M.x0, M.y0))) into vert;
	select count(*) into cnt from muro M where (M.vano1 = new.vano or M.vano2 = new.vano)
        and intersezione_muri(x0, y0, x1, y1, x2, y2, x2 + 1000000, y2 + 1);

	select exists(
		select M.id
        from muro M
        where (M.vano1 = new.vano or M.vano2 = new.vano) and
			x0 * (y1 - y2) + x1 * (y2 - y0) + x2 * (y0 - y1) = 0 and x2 between mn(x0, x1) and mx(x0, x1) and y2 between mn(y0, y1) and mx(y0, y1)
    ) into sul_muro;	-- controlla che l'area del triangolo tra sensore e estremi del muro sia nulla ovvero che sia posto su una parete
    
	if (not vert) and (not cnt % 2) and (not sul_muro) then
		signal sqlstate "45000" set message_text = "Il sensore è fuori dal suo vano";
    end if;
    
    if new.tipo = "Allungamento" and not sul_muro then
		signal sqlstate "45000" set message_text = "Il sensore deve essere posto su un muro, le coordinate fornite sono errate";
    end if;
end :)
delimiter ;

drop trigger if exists alert_sensore;
delimiter :)
create trigger alert_sensore after insert on misura for each row
begin
	declare x, y, z, maxval float;
    select soglia from sensore where id = new.sensore into maxval;
    set x = new.xoppureunico;
    set y = if(new.y is null, 0, new.y);
    set z = if(new.z is null, 0, new.z);
    if(x*x + y*y + z*z > maxval * maxval and not exists
        (select 1 from alert where sensore = new.sensore and timestamp between new.timestamp - interval 2 minute and new.timestamp))
	then insert into alert values (new.timestamp, new.sensore); end if;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop trigger if exists utilizzo_materiale;
delimiter :)
create trigger utilizzo_materiale before insert on utilizzomateriale for each row
begin
	declare _muro, _lato, _copertura, _portante tinyint default null;
    if (select quantitarimasta_rid from materiale where codicelotto = new.materiale) < new.quantita then
		signal sqlstate "45000" set message_text = "Stai cercando di usare più materiale di quello che ti rimane";
    end if;
    select muro, lato into _muro, _lato from lavorosumuro where lavoro=new.lavoro;
    
    if _muro is not null then
		select copertura, portante into _copertura, _portante from materiale where codicelotto=new.materiale;
		if _lato=0 and not _portante then
			signal sqlstate "45000" set message_text = "Il materiale per la costruzione del muro deve essere portante";
		end if;
		if _lato!=0 and not _copertura then
			signal sqlstate "45000" set message_text = "Il materiale per le pareti del muro deve essere di copertura";
		end if;
        
		if not (select UM.Quantita
				from LavoroSuMuro LSM inner join Lavoro L on LSM.Lavoro=L.ID inner join UtilizzoMateriale UM on L.ID=UM.Lavoro
				where LSM.Muro = _muro and LSM.Lato = 0 and L.datafine order by L.datafine desc limit 1
			   ) > 0 then
			signal sqlstate "45000" set message_text = "Non puoi ricoprire un muro non costruito";
		end if;
  
        -- controlla se ci sono altri materiali utilizzati per il rivestimento del muro
        if exists( select 1 from utilizzomateriale UM natural join lavorosumuro LSM
			       where LSM.lato!=0 and UM.lavoro=new.lavoro) then
            signal sqlstate "45000" set message_text = "Un lavoro di copertura di una parete può avere un solo materiale";
		end if;
	end if;
    update materiale
    set quantitarimasta_rid = quantitarimasta_rid - new.quantita
    where codicelotto = new.materiale;
end :)
delimiter ;

drop function if exists calcolo_costo_lavoro;
delimiter :)
create function calcolo_costo_lavoro(_id_lavoro int) returns decimal(10,2) reads sql data
begin
	declare costo_impiego, costo_materiale, costo_capocantiere decimal(10,2) default 0;

	select sum(O.pagaoraria) / 12
    into costo_impiego
	from impiego I inner join operaio O on I.operaio = O.codicefiscale
	where I.lavoro = _id_lavoro;
    
	select sum(U.quantita * M.costounitario)
    into costo_materiale
	from utilizzomateriale U inner join materiale M on U.materiale = M.codicelotto
	where U.lavoro = _id_lavoro;
    
    select compensocapocantiere
    into costo_capocantiere
    from lavoro
    where id=_id_lavoro;
    
    return costo_impiego + costo_materiale + costo_capocantiere;
end :)
delimiter ;

drop trigger if exists costo_lavoro;
delimiter :)
create trigger costo_lavoro after update on lavoro for each row
begin
    if old.datafine is null and new.datafine is not null then
	    update progettoedilizio
		set costolavori_rid = costolavori_rid + calcolo_costo_lavoro(new.id)
		where id = (select progetto from stadioavanzamento where id = new.codicestadio);
    end if;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop event if exists cleanup_sensori;
create event cleanup_sensori on schedule every 1 day
do delete M from misura M left outer join alert A on M.sensore = A.sensore
        and M.timestamp between A.timestamp - interval 69 minute and A.timestamp + interval 69 minute
    where M.timestamp < current_timestamp - interval 1 week and A.sensore is null;

/* OPERAZIONI -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

1 Superficie di un vano / piano / edificio (functions, in: la chiave, out: superficie in m^2; si assume < 1 km^2)
2 Costo lavori di un edificio (function, in: edificio, out: costo)
3 Calcolo stipendio operai (per stamparli tutti, procedure con anno e mese; per trovarne uno, funzione con anno mese cf)
4 Inserimento turno (procedure, in: inizio, fine, cf_operaio, lavoro, out: nulla)
5 Edifici in costruzione / in ristrutturazione / completati (procedure, in: timestamp, out: conta)
6 Quale stadio di avanzamento è più in ritardo (quello non ancora finito che aveva la fine stimata più vecchia)
7 Data una parete, trova colore e data lavoro (procedure, in: muro e lato, out: colore e data)
8 Dato un istante elenca operai al lavoro e relativi edifici (procedure, in: timestamp, stdout: result set di operai e edifici)

*/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop function if exists superficie_vano;
drop function if exists superficie_piano;
drop function if exists superficie_edificio;
delimiter :)
create function superficie_vano (v int) returns decimal(9, 3) reads sql data
begin
    declare y1, y2 decimal(8, 3); -- calcolo dell'area come somma con segno delle aree dei trapezi
    select 0.0000005 * sum((x1 - x0) * (y0 + y1)) from muro where vano1 = v into y1;
    select 0.0000005 * sum((x1 - x0) * (y0 + y1)) from muro where vano2 = v into y2;
    return y1 - y2;
end :)
create function superficie_piano (n int, e int) returns decimal(9, 3) reads sql data
begin
    declare y decimal(8, 3);
    with vani as (select id from vano where piano = n and edificio = e)
    select 0.0000005 * sum((x1 - x0) * (y0 + y1)) from muro where vano1 in (select * from vani) and vano2 is null into y;
    -- come per il singolo vano, ma ottimizza per i muri interni
    return y;
end :)
create function superficie_edificio (e int) returns decimal(9, 3) reads sql data
begin
    declare y decimal(8, 3);
    with vani as (select id from vano where edificio = e)
    select 0.0000005 * sum((x1 - x0) * (y0 + y1)) from muro where vano1 in (select * from vani) and vano2 is null into y;
    -- come per il singolo vano, ma ottimizza per i muri interni
    return y;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop function if exists costo_lavori_edificio;
delimiter :)
create function costo_lavori_edificio(e int) returns decimal(11, 2) reads sql data
begin
    declare costo decimal(11, 2);
    select sum(CostoLavori_rid) from ProgettoEdilizio where edificio_rid = e into costo;
    return costo;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop procedure if exists calcola_tutti_stipendi;
drop function if exists stipendio;
delimiter :)
create procedure calcola_tutti_stipendi (in anno int, in mese int)
begin
	select O.codicefiscale as Operaio, count(*) * O.pagaoraria / 12 as Stipendio
	from impiego I inner join operaio O on I.operaio = O.codicefiscale
	where year(I.inizio) = anno and month(I.inizio) = mese
	group by O.codicefiscale;
end :)

create function stipendio (anno int, mese int, dipendente char(16)) returns decimal(8, 2) reads sql data
begin
    declare ret decimal(8, 2);
    declare paga_oraria decimal(8, 2);
    select pagaoraria from operaio where codicefiscale = dipendente into paga_oraria;
	select count(*) * paga_oraria / 12 as Stipendio from impiego I
	where year(I.inizio) = anno and month(I.inizio) = mese and I.operaio = dipendente
    into ret;
    return ifnull(ret, 0);
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop procedure if exists insert_impiego;
delimiter :)
create procedure insert_impiego (in _inizio datetime, in _fine datetime, in _operaio char(16), in _lavoro int)
begin
    declare conta_lavoratori1 int;
    declare conta_lavoratori2, limite1, limite2 int;
    set _inizio = _inizio - interval (second(_inizio)) second - interval (minute(_inizio)%5) minute; -- arrotonda a 5 minuti per difetto
    set _fine = _fine - interval (second(_fine)+1) second - interval (minute(_fine)%5) minute; -- same, ma -1 secondo (tipo 16:59:59)
    if not _inizio < _fine then
		signal sqlstate "45000" set message_text = "Non puoi inserire un turno null o inferiore a una fascia di 5 minuti";
    end if;
    
    select count(distinct operaio) + 1  into conta_lavoratori1
		from impiego I
		where lavoro = _lavoro and operaio != _operaio;
    
    select max(numero) into conta_lavoratori2
		FROM
        ( select count(operaio) + 1 as numero from impiego I
			where I.inizio between _inizio and _fine and lavoro = _lavoro and operaio != _operaio
			group by I.inizio
		) operai;
    
    select C.maxoperai, L.maxoperaiinsieme into limite1, limite2
		from lavoro L inner join capocantiere C on L.capocantiere = C.codicefiscale
        where L.id = _lavoro;
    
	if conta_lavoratori1 > limite1 then
		signal sqlstate "45000" set message_text = "Ci sono troppi operai per questo capo cantiere";
    end if;
    if conta_lavoratori2 > limite2 then
		signal sqlstate "45000" set message_text = "Ci sono troppi operai a fare lo stesso lavoro allo stesso tempo";
    end if;
    if exists(
      select * from impiego I
      where I.inizio between _inizio and _fine and lavoro != _lavoro and operaio = _operaio
	) then
		signal sqlstate "45000" set message_text = "Operaio assegnato ad un diverso lavoro";
	end if;

    
    while _inizio < _fine do
        insert ignore into impiego values (_inizio, _operaio, _lavoro);
        set _inizio = _inizio + interval 5 minute;
    end while;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop procedure if exists conta_edifici_con_lavori;
delimiter :)
create procedure conta_edifici_con_lavori
(in _data date, out da_costruire int, out finiti int, out in_costruzione int, out in_ristrutturazione int)
begin
    with stato_progetti as (
        select P.edificio_rid as edificio,
            (ifnull(min(L.datainizio), _data + interval 1 day) <= _data) -- 1 se almeno un lavoro del progetto è cominciato
            + (max(ifnull(L.datafine, _data + interval 1 day)) <= _data) as stato -- un altro 1 se tutti i lavori sono finiti
        from lavoro L inner join stadioavanzamento S on L.codicestadio = S.id
            inner join progettoedilizio P on S.progetto = P.id
        group by P.id),
	cnt as (select edificio, sum(stato = 1) as conta_1, sum(stato = 2) as conta_2
            from stato_progetti group by edificio)        
    select sum(!conta_1 and !conta_2), sum(!conta_1 and conta_2),
           sum(conta_1 and !conta_2), sum(conta_1 and conta_2) from cnt
    into da_costruire, finiti, in_costruzione, in_ristrutturazione;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop procedure if exists stadio_in_ritardo;
delimiter :)
create procedure stadio_in_ritardo (in _data date)
begin
	if _data is null then
		set _data = current_date();
	end if;
    
    select id, datediff(_data, datafinestimata) as GiorniRitardo
    from (
		select SA.id, SA.datafinestimata, rank() over (order by SA.datafinestimata asc) as severity
		from stadioavanzamento SA inner join lavoro L on L.codicestadio = SA.id
		where (L.datafine is null or L.datafine > _data) and SA.datafinestimata < _data
        ) severity_rank
	where severity = 1;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop procedure if exists stato_parete;
delimiter :)
create procedure stato_parete (in _muro int, in _lato bool, out stato_colore_parete varchar(50), out data_modifica date) -- lato 0: destra; lato 1: sinistra
begin
	declare lato_lavoro tinyint default null;
    declare _materiale varchar(20);
    declare _quantita float;
    set stato_colore_parete = null;
    set data_modifica = null;
    
    if _lato != 0 and _lato != 1 then
		signal sqlstate "45000" set message_text = 'Lato non valido, valori accettati 0 (lato destro) o 1 (lato sinistro)';
	end if;
    
	select LSM.Lato, UM.Materiale, UM.Quantita, L.DataFine
    into lato_lavoro, _materiale, _quantita, data_modifica
    from LavoroSuMuro LSM inner join Lavoro L on LSM.Lavoro=L.ID
		inner join UtilizzoMateriale UM on L.ID=UM.Lavoro
    where LSM.Muro=_muro and (LSM.Lato=0 or LSM.Lato & (1<<_lato)) and L.datafine is not null
    order by L.DataFine desc
    limit 1;
    
    if lato_lavoro is null or (lato_lavoro = 0 and _quantita <= 0) then
		set stato_colore_parete = 'Parete demolita o non costruita';
	elseif lato_lavoro = 0 or _quantita <= 0 then
		set stato_colore_parete = 'Parete non ricoperta';
	else
		select Colore into stato_colore_parete
		from Intonaco I
		where I.Materiale = _materiale
		limit 1;
		if stato_colore_parete is null then
			if exists(select * from piastrella P where P.materiale = _materiale) then
				set stato_colore_parete = 'Piastrella';
			elseif exists(select * from pietra P where P.materiale = _materiale) then
				set stato_colore_parete = 'Pietra a vista';
			else
				select concat("Materiale generico: ", descrizione) into stato_colore_parete
				from materialegenerico M where M.materiale = _materiale
				limit 1;
			end if;
		end if;
	end if;
end :)
delimiter ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop procedure if exists stato_lavoratori;
delimiter :)
create procedure stato_lavoratori (in data_orario datetime)
begin
	select I.operaio, PE.edificio_rid
    from impiego I inner join lavoro L on I.lavoro = L.id
		inner join stadioavanzamento SA on L.codicestadio = SA.id
        inner join progettoedilizio PE on SA.progetto = PE.id
	where I.inizio = data_orario - interval (second(data_orario)) second - interval (minute(data_orario)%5) minute;
end :)
delimiter ;

/* EXTRA -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

orientamento_apertura (non sapevamo se contarla come un'operazione)
  in: muro, sinistra, destra
  out: un angolo intero in gradi [-180, 180) relativo al nord;
    -180 = S, -135 = SW, -90 = W, -45 = NW, 0 = N, 45 = NE, 90 = E, 135 = SE

*/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop function if exists orientamento_apertura;
delimiter :)
create function orientamento_apertura(m int, sinistra int, destra int) returns int reads sql data
begin
    declare dx, dy int;
    select x1-x0, y1-y0 from muro where id = m into dx, dy;
    if sinistra > destra then set dx = -dx, dy = -dy; end if;
    return -atan2(dy, dx) * 180 / 3.14159265;
end :)
delimiter ;
