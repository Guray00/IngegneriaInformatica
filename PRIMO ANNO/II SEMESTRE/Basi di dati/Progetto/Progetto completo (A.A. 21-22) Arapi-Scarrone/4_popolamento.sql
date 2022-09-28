use PAS;

/*
set @@foreign_key_checks = 0; -- svuotiamo tutto se dobbiamo rieseguire lo script
TRUNCATE Alert; TRUNCATE Apertura; TRUNCATE Calamita; TRUNCATE CapoCantiere; TRUNCATE Danneggiamento;
TRUNCATE Edificio; TRUNCATE Impiego; TRUNCATE Intonaco; TRUNCATE Lavoro; TRUNCATE LavoroSuEdificio;
TRUNCATE LavoroSuMuro; TRUNCATE LavoroSuVano; TRUNCATE Materiale; TRUNCATE MaterialeGenerico; TRUNCATE Mattone;
TRUNCATE Misura; TRUNCATE Muro; TRUNCATE Operaio; TRUNCATE Parquet; TRUNCATE Piano; TRUNCATE Piastrella;
TRUNCATE Pietra; TRUNCATE ProgettoEdilizio; TRUNCATE RischioGeologico; TRUNCATE Sensore; TRUNCATE StadioAvanzamento;
TRUNCATE UtilizzoMateriale; TRUNCATE Vano; TRUNCATE ZonaGeografica;
set @@foreign_key_checks = 1;
*/

/* PROCEDURE COMODE PER INSERIRE -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

insert_lavoro_edificio (stadio, inizio, descrizione, capo, compenso_capo, max_operai, edificio, out id)
insert_lavoro_vano (stadio, inizio, descrizione, capo, compenso_capo, max_operai, vano, out id)
insert_lavoro_muro (stadio, inizio, descrizione, capo, compenso_capo, max_operai, muro, lato, spessore, out id)

*/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

drop procedure if exists insert_lavoro_edificio;
drop procedure if exists insert_lavoro_vano;
drop procedure if exists insert_lavoro_muro;
delimiter :)
create procedure insert_lavoro_edificio
	(in stadio int, in inizio datetime, in descrizione varchar(45), in capo char(16),
     in compensocapo decimal(8, 2), in maxoperai int, in edificio int, out id_lavoro int)
begin
	declare edificio_giusto int;
    select edificio_rid
    from progettoedilizio P inner join stadioavanzamento S on S.progetto = P.id
    where S.id = stadio into edificio_giusto;
    if not edificio = edificio_giusto then
		signal sqlstate "45000" set message_text = "L'edificio su cui lavori deve corrispondere al progetto edilizio";
    end if;
    insert into lavoro values (default, stadio, inizio, null, descrizione, capo, compensocapo, maxoperai);
    set id_lavoro = last_insert_id();
    insert into lavorosuedificio values (id_lavoro, edificio);
end :)

create procedure insert_lavoro_vano
	(in stadio int, in inizio datetime, in descrizione varchar(45), in capo char(16),
     in compensocapo decimal(8, 2), in maxoperai int, in vano_ins int, out id_lavoro int)
begin
	declare edificio_ins, edificio_giusto int;
    select edificio_rid
    from progettoedilizio P inner join stadioavanzamento S on S.progetto = P.id
    where S.id = stadio into edificio_giusto;
    select edificio from vano where id = vano_ins into edificio_ins;
    if not edificio_ins = edificio_giusto then
		signal sqlstate "45000" set message_text = "L'edificio su cui lavori deve corrispondere al progetto edilizio";
    end if;
    insert into lavoro values (default, stadio, inizio, null, descrizione, capo, compensocapo, maxoperai);
    set id_lavoro = last_insert_id();
    insert into lavorosuvano values (id_lavoro, vano_ins);
end :)

create procedure insert_lavoro_muro
	(in stadio int, in inizio datetime, in descrizione varchar(45), in capo char(16),
     in compensocapo decimal(8, 2), in maxoperai int, in muro_ins int, in lato tinyint, in spessore decimal(4, 2), out id_lavoro int)
begin
	declare edificio_ins, edificio_giusto int;
    select edificio_rid
    from progettoedilizio P inner join stadioavanzamento S on S.progetto = P.id
    where S.id = stadio into edificio_giusto;
    select edificio from vano V inner join muro M on M.vano1 = V.id where M.id = muro_ins into edificio_ins;
    if not edificio_ins = edificio_giusto then
		signal sqlstate "45000" set message_text = "L'edificio su cui lavori deve corrispondere al progetto edilizio";
    end if;
    insert into lavoro values (default, stadio, inizio, null, descrizione, capo, compensocapo, maxoperai);
    set id_lavoro = last_insert_id();
    insert into lavorosumuro values (id_lavoro, muro_ins, spessore, lato);
end :)
delimiter ;

drop procedure if exists simula_sensori_terremoto;
delimiter :)
create procedure simula_sensori_terremoto (in _inizio_terremoto datetime, in _tipo varchar(45),
	in _lat decimal(9,6), in _long decimal(9,6), in _mercalli float, in _inizio_sensori datetime,
    in _fine datetime, in _zonageografica varchar(45))
begin
    declare finito boolean default 0;
    declare _id, i int;
    declare _lat_edificio, _long_edificio decimal(9,6);
    declare valore_sensore, val, _soglia, _max, _min, _k float;
    declare _i_datetime datetime(3);
    -- alcune variabili ausiliarie
    
    -- cursori per ogni sensore
    declare accelerometri_cursore cursor for
		select S.id, E.latitudine, E.longitudine, S.soglia, RG.coefficienterischio
        from edificio E inner join vano V on E.id = V.edificio
			inner join sensore S on S.vano = V.id
			inner join rischiogeologico RG on RG.zona = E.zonageografica
        where S.tipo='Accelerometro' and E.zonageografica=_zonageografica;
	
	declare giroscopi_cursore cursor for
		select S.id, E.latitudine, E.longitudine, S.soglia, RG.coefficienterischio
        from edificio E inner join vano V on E.id = V.edificio
			inner join sensore S on S.vano = V.id
			inner join rischiogeologico RG on RG.zona = E.zonageografica
        where S.tipo='Giroscopio' and E.zonageografica=_zonageografica;
        
	declare allungamento_cursore cursor for
		select S.id, E.latitudine, E.longitudine, S.soglia, RG.coefficienterischio
        from edificio E inner join vano V on E.id = V.edificio
			inner join sensore S on S.vano = V.id
			inner join rischiogeologico RG on RG.zona = E.zonageografica
        where S.tipo='Allungamento' and E.zonageografica=_zonageografica;
        
	declare temperatura_cursore cursor for
		select S.id, S.soglia
        from edificio E inner join vano V on E.id = V.edificio inner join sensore S on S.vano = V.id
        where S.tipo='Temperatura' and E.zonageografica=_zonageografica;
	
    declare umidita_cursore cursor for
		select S.id, S.soglia
        from edificio E inner join vano V on E.id = V.edificio inner join sensore S on S.vano = V.id
        where S.tipo='Umidita' and E.zonageografica=_zonageografica;
	
    declare continue handler for not found
	set finito = 1;
    
    open accelerometri_cursore;
    set finito = 0;
    ciclo: loop
		fetch accelerometri_cursore into _id, _lat_edificio, _long_edificio, _soglia, _k;
        if finito then
			leave ciclo;
		end if;
        set _max = 1.2*
			mercalli_to_pga(_mercalli)/power(distanza_superficie_terrestre(_lat, _long, _lat_edificio, _long_edificio)/_k+1, 2)
        /sqrt(3); -- il massimo di ogni componente (leggermente più alto di quello teorico per la componente casuale)
        set _i_datetime = _inizio_sensori;
        
        while _i_datetime <= _fine do
			if _i_datetime >= _inizio_terremoto then
				insert ignore into misura values
					(_i_datetime, _id, _max*(rand()*2-1), _max*(rand()*2-1), _max*(rand()*2-1));
			else
				insert ignore into misura values
					(_i_datetime, _id, 0.000001*(rand()*2-1), 0.000001*(rand()*2-1), 0.000001*(rand()*2-1));
            end if;
			set _i_datetime = _i_datetime + interval 0.5 second;
		end while;
    end loop ciclo;
    close accelerometri_cursore;
    
    open giroscopi_cursore;
    set finito = 0;
    ciclo: loop
		fetch giroscopi_cursore into _id, _lat_edificio, _long_edificio, _soglia, _k;
        if finito then
			leave ciclo;
		end if;
        set _max = 1.25*_soglia*
			mercalli_to_pga(_mercalli)/power(distanza_superficie_terrestre(_lat, _long, _lat_edificio, _long_edificio)/_k+1, 2);
            -- il massimo di ogni componente (in modo da superare ogni tanto la soglia)
        set _i_datetime = _inizio_sensori;
        
        while _i_datetime <= _fine do
			if _i_datetime >= _inizio_terremoto then
				insert ignore into misura values
					(_i_datetime, _id, _max*(rand()*2-1), _max*(rand()*2-1), _max*(rand()*2-1));
			else
				insert ignore into misura values
					(_i_datetime, _id, 0.000001*(rand()*2-1), 0.000001*(rand()*2-1), 0.000001*(rand()*2-1));
            end if;
			set _i_datetime = _i_datetime + interval 0.5 second;
		end while;
    end loop ciclo;
    close giroscopi_cursore;
    
    open allungamento_cursore;
    set finito = 0;
    ciclo: loop
		fetch allungamento_cursore into _id, _lat_edificio, _long_edificio, _soglia, _k;
        if finito then
			leave ciclo;
		end if;
		set _i_datetime = _inizio_sensori;
        
        select M.xoppureunico
        into valore_sensore
        from misura M
        where sensore = _id
        order by M.timestamp desc
        limit 1;
        
		set valore_sensore = ifnull(valore_sensore, 0);
        
        while _i_datetime <= _fine do
			if _i_datetime >= _inizio_terremoto then
				set valore_sensore = valore_sensore+
					_soglia*(1+mercalli_to_pga(_mercalli)/power(distanza_superficie_terrestre(_lat, _long, _lat_edificio, _long_edificio)/_k+1, 2));
			else 
				set valore_sensore = valore_sensore*(1+rand()/1000);
			end if;
            
			insert ignore into misura values
				(_i_datetime, _id, valore_sensore, 0, 0);

			set _i_datetime = _i_datetime + interval 1 hour;
		end while;
    end loop ciclo;
    close allungamento_cursore;
    
	open temperatura_cursore;
    set finito = 0;
    ciclo: loop
		fetch temperatura_cursore into _id, _soglia;
        if finito then
			leave ciclo;
		end if;
		set _i_datetime = _inizio_sensori;
        
        while _i_datetime <= _fine do
			insert ignore into misura values
				(_i_datetime, _id, _soglia*(2/3-2/3*sin(hour(_i_datetime+3)*2*pi()/24)-3*rand()), 0, 0);
				-- ciclo di 24 ore con orario più caldo alle 15 e più freddo alle 3, più componente casuale
			set _i_datetime = _i_datetime + interval 1 hour;
		end while;
    end loop ciclo;
    close temperatura_cursore;
    
    open umidita_cursore;
    set finito = 0;
    ciclo: loop
		fetch umidita_cursore into _id, _soglia;
        if finito then
			leave ciclo;
		end if;
		set _i_datetime = _inizio_sensori;
        
        while _i_datetime <= _fine do
			set val = _soglia*(2/3+2/3*sin(hour(_i_datetime)*2*pi()/24)-10*rand());
            if val>100 then set val=100; end if;
            
			insert ignore into misura values
				(_i_datetime, _id, val, 0, 0);
				-- ciclo di 24 ore con orario più umido alle 6 e più secco alle 18, più componente casuale
			set _i_datetime = _i_datetime + interval 1 hour;
		end while;
    end loop ciclo;
    close umidita_cursore;
    
    if _inizio_terremoto is not null then
		insert ignore into calamita (data, tipo, latitudine, longitudine) values (_inizio_terremoto, _tipo, _lat, _long);
		insert ignore into danneggiamento values (_inizio_terremoto, _tipo, _zonageografica);
	end if;
end :)
delimiter ;

-- INSERIMENTI -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

insert into zonageografica values ("Toscana"), ("Liguria");
insert into edificio (id, latitudine, longitudine, zonageografica) values (1, 42.955, 10.666, "Toscana");
insert into piano values (0, 1);
insert into vano (id, piano, edificio, lunghezza, larghezza, altezzamax, funzione) values
    (1, 0, 1, 7000, 2000, 3000, "Veranda"), -- 1
    (2, 0, 1, 7000, 6000, 3000, "CucinaSoggiorno"), -- 2
    (3, 0, 1, 3000, 2000, 3000, "Bagno"), -- 3
    (4, 0, 1, 4000, 3000, 3000, "Camera"), -- 4
    (5, 0, 1, 4000, 3000, 3000, "Camera"); -- 5
insert into muro (id, x0, y0, x1, y1, vano1, vano2) values
    (1, 8000, 7000, 10000, 7000, 1, null),
    (2, 10000, 7000, 10000, 0,   1, null), -- -- 2
    (3, 10000, 0, 8000, 0,       1, null), -- 3
    (4, 8000, 0, 8000, 7000,     1, 2), -- 4
    (5, 8000, 0, 4000, 0,        2, null),
    (6, 4000, 0, 4000, 3000,     2, 5),
    (7, 4000, 3000, 2000, 3000,  2, 5), -- 7
    (8, 2000, 3000, 2000, 4000,  2, 4), -- 8
    (9, 2000, 4000, 3000, 4000,  2, 4),
    (10, 3000, 4000, 5000, 4000,  2, 3), -- 10
    (11, 5000, 4000, 5000, 7000,  2, 3),
    (12, 5000, 7000, 8000, 7000,  2, null),
    (13, 3000, 4000, 3000, 7000,  3, 4),
    (14, 3000, 7000, 5000, 7000,  3, null),
    (15, 2000, 3000, 0, 3000,     4, 5),
    (16, 0, 3000, 0, 7000,        4, null),
    (17, 0, 7000, 3000, 7000,     4, null),
    (18, 4000, 0, 0, 0,           5, null),
    (19, 0, 0, 0, 3000,           5, null);
insert into apertura (muro, sotto, sopra, sinistra, destra, tipo) values
	(3, 0, 2000, 900, 1900, "Porta"),
	(4, 0, 2000, 4269, 3269, "Porta"),
	(7, 0, 2000, 1500, 500, "Porta"),
	(8, 0, 2000, 950, 50, "Porta"),
	(10, 0, 2000, 1500, 500, "Porta"),
	(2, 800, 2100, 1300, 6000, "Finestra"),
	(4, 0, 2100, 5700, 5000, "Finestra"),
	(4, 800, 2100, 2500, 1500, "Finestra"),
	(5, 800, 2100, 500, 3000, "Finestra"),
	(16, 800, 2100, 1000, 3000, "Finestra"),
    (19, 800, 2100, 1000, 2000, "Finestra");

-- Materiali -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
insert into Materiale values
    ("LI1206Y04", 300, 1, "2012-08-04", "Bricoman", 300, 1, 0, 0), -- litri di intonaco 1
    ("LI1207R02", 100, 1, "2012-08-04", "Bricoman", 100, 1, 0, 0), -- litri di intonaco 2
    ("LM1112M05", 4269, 0.45, "2012-05-17", "Leroy Merlin", 4269, 0, 0, 1), -- mattoni
    ("LP1208Q11", 400, 1, "2012-08-04", "Bricoman", 400, 1, 1, 0), -- piastrelle
    ("LP1204R08", 100, 1.70, "2012-08-04", "Bricoman", 100, 0, 1, 0), -- parquet
    ("LT1201C02", 600, 2.20, "2012-07-13", "Leroy Merlin", 600, 0, 0, 0), -- tegole
    ("LC1105P00", 10, 120, "2012-05-17", "Leroy Merlin", 100, 0, 0, 1), -- m^3 cemento
    ("LS1106G02", 50, 50, "2012-05-17", "Leroy Merlin", 500, 0, 0, 1); -- m^3 sabbia
insert into Intonaco values
	("LI1206Y04", "Premiscelato", "Giallo"),
    ("LI1207R02", "A calce", "Rosa");
insert into Mattone values
	("LM1112M05", "Cilindrica cava", "Laterizio", 250, 120, 65);
insert into Piastrella values
	("LP1208Q11", "Ceramica", "Naturale", 220, 4, 3);
insert into Parquet values
	("LP1204R08", "Rovere");
insert into MaterialeGenerico values
	("LT1201C02", "Tegole a coppo in terracotta", "Protezione tetto", 420, 160, 85),
    ("LC1105P00", "Cemento in polvere", "Legante strutturale", NULL, NULL, NULL),
    ("LS1106G02", "Sabbia", "Miscelazione con cemento", NULL, NULL, NULL);

-- Lavoratori -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

insert into Operaio values 
	('RSSMRA70A01H501S', 'Mario', 'Rossi', 8.5),
	('VRDLGU60A01F205P', 'Luigi', 'Verdi', 10),
	('RSOSRA85C08G702J', 'Sara', 'Rosa', 12),
	('BNCCRL85P26L219R', 'Carlo', 'Bianchi', 8),
    ('MRRPLA65E05G702C', 'Paolo', 'Marroni', 9),
    ("CNLHSN02P11G999O", "Hasan", "con l'H davanti", 12),
	("SPTTRN02L06D297H", "Train", "Spotting", 12);

insert into CapoCantiere values
	('NRECLD90T25D612Z', 'Claudia', 'Neri', 4),
	('VLIMRA75B28L483I', 'Mauro', 'Viola', 10);

-- Lavori costruzione -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

insert into progettoedilizio values	(1, 0.00, 1);

insert into stadioavanzamento values
	(1, 1, '2022-08-31', '2022-09-17'),
	(2, 1, '2022-09-18', '2022-09-26');

call insert_lavoro_edificio(1, '2022-08-31 08:00:00', 'Posa fondamenta', 'NRECLD90T25D612Z', 120, 10, 1, @id_lavoro);
insert into utilizzomateriale values
	("LC1105P00", @id_lavoro, 5),		-- cemento
    ("LS1106G02", @id_lavoro, 15);		-- sabbia
call insert_impiego('2022-08-31 08:00:00', '2022-08-31 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-08-31 16:00:00', '2022-08-31 20:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-08-31 17:00:00', '2022-08-31 20:30:00', 'RSOSRA85C08G702J', @id_lavoro);
call insert_impiego('2022-09-05 15:30:00', '2022-09-05 18:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-09-05 16:00:00', '2022-09-05 18:00:00', 'RSOSRA85C08G702J', @id_lavoro);
call insert_impiego('2022-09-05 17:00:00', '2022-09-05 20:00:00', 'VRDLGU60A01F205P', @id_lavoro);
call insert_impiego('2022-09-07 09:30:00', '2022-09-07 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-09-07 09:30:00', '2022-09-07 12:00:00', 'RSOSRA85C08G702J', @id_lavoro);
call insert_impiego('2022-09-07 09:30:00', '2022-09-07 12:30:00', 'VRDLGU60A01F205P', @id_lavoro);
update lavoro set datafine='2022-09-07 12:30:00' where id=@id_lavoro;


call insert_lavoro_muro(1, '2022-09-15 08:00:00', 'Costruzione muro bagno', 'VLIMRA75B28L483I', 30, 5, 10, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2022-09-15 08:00:00', '2022-09-15 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-09-15 08:00:00', '2022-09-15 12:00:00', 'BNCCRL85P26L219R', @id_lavoro);
update lavoro set datafine='2022-09-15 12:00:00' where id=@id_lavoro;

call insert_lavoro_muro(1, '2022-09-15 14:00:00', 'Costruzione muro bagno', 'VLIMRA75B28L483I', 30, 5, 11, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 60),		-- mattoni
	("LC1105P00", @id_lavoro, 0.15),		-- cemento
    ("LS1106G02", @id_lavoro, 0.6);		-- sabbia
call insert_impiego('2022-09-15 14:00:00', '2022-09-15 20:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-09-15 14:00:00', '2022-09-15 20:00:00', 'BNCCRL85P26L219R', @id_lavoro);
update lavoro set datafine='2022-09-15 20:00:00' where id=@id_lavoro;

call insert_lavoro_muro(1, '2022-09-16 07:00:00', 'Costruzione muro bagno', 'VLIMRA75B28L483I', 30, 5, 13, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 60),		-- mattoni
	("LC1105P00", @id_lavoro, 0.15),	-- cemento
    ("LS1106G02", @id_lavoro, 0.6);		-- sabbia
call insert_impiego('2022-09-16 07:00:00', '2022-09-16 13:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-09-16 07:00:00', '2022-09-16 13:00:00', 'BNCCRL85P26L219R', @id_lavoro);
update lavoro set datafine='2022-09-16 13:00:00' where id=@id_lavoro;

call insert_lavoro_muro(1, '2022-09-16 15:00:00', 'Costruzione muro bagno', 'VLIMRA75B28L483I', 30, 5, 14, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2022-09-16 15:00:00', '2022-09-16 19:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-09-16 15:00:00', '2022-09-16 19:00:00', 'BNCCRL85P26L219R', @id_lavoro);
update lavoro set datafine='2022-09-16 19:00:00' where id=@id_lavoro;


-- Intonaco nel bagno e sulla facciata esterna del muro del bagno
call insert_lavoro_muro(2, '2022-09-18 08:30:00', 'Primo strato intonaco giallo', 'NRECLD90T25D612Z', 3, 2, 10, 2, 1, @id_lavoro);
insert into utilizzomateriale values ("LI1206Y04", @id_lavoro, 6);
call insert_impiego('2022-09-18 08:30:00', '2022-09-18 09:30:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-18 09:30:00' where id=@id_lavoro;

call insert_lavoro_muro(2, '2022-09-18 09:30:00', 'Primo strato intonaco giallo', 'NRECLD90T25D612Z', 3, 2, 11, 2, 1, @id_lavoro);
insert into utilizzomateriale values ("LI1206Y04", @id_lavoro, 9);
call insert_impiego('2022-09-18 09:30:00', '2022-09-18 11:00:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-18 11:00:00' where id=@id_lavoro;

call insert_lavoro_muro(2, '2022-09-18 11:00:00', 'Primo strato intonaco giallo', 'NRECLD90T25D612Z', 3, 2, 13, 1, 1, @id_lavoro);
insert into utilizzomateriale values ("LI1206Y04", @id_lavoro, 9);
call insert_impiego('2022-09-18 11:00:00', '2022-09-18 12:30:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-18 12:30:00' where id=@id_lavoro;

call insert_lavoro_muro(2, '2022-09-18 15:30:00', 'Primo strato intonaco giallo', 'NRECLD90T25D612Z', 6, 2, 14, 3, 1, @id_lavoro);
insert into utilizzomateriale values ("LI1206Y04", @id_lavoro, 12);
call insert_impiego('2022-09-18 15:30:00', '2022-09-18 17:30:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-18 17:30:00' where id=@id_lavoro;

call insert_lavoro_muro(2, '2022-09-19 08:30:00', 'Secondo strato intonaco giallo', 'NRECLD90T25D612Z', 3, 2, 10, 2, 1, @id_lavoro);
insert into utilizzomateriale values ("LI1206Y04", @id_lavoro, 6);
call insert_impiego('2022-09-19 08:30:00', '2022-09-19 09:30:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-19 09:30:00' where id=@id_lavoro;

call insert_lavoro_muro(2, '2022-09-19 09:30:00', 'Secondo strato intonaco giallo', 'NRECLD90T25D612Z', 3, 2, 11, 2, 1, @id_lavoro);
insert into utilizzomateriale values ("LI1206Y04", @id_lavoro, 9);
call insert_impiego('2022-09-19 09:30:00', '2022-09-19 11:00:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-19 11:00:00' where id=@id_lavoro;

call insert_lavoro_muro(2, '2022-09-19 11:00:00', 'Secondo strato intonaco giallo', 'NRECLD90T25D612Z', 3, 2, 13, 1, 1, @id_lavoro);
insert into utilizzomateriale values ("LI1206Y04", @id_lavoro, 9);
call insert_impiego('2022-09-19 11:00:00', '2022-09-19 12:30:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-19 12:30:00' where id=@id_lavoro;

call insert_lavoro_muro(2, '2022-09-19 15:30:00', 'Secondo strato intonaco giallo', 'NRECLD90T25D612Z', 6, 2, 14, 3, 1, @id_lavoro);
insert into utilizzomateriale values ("LI1206Y04", @id_lavoro, 12);
call insert_impiego('2022-09-19 15:30:00', '2022-09-19 17:30:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-19 17:30:00' where id=@id_lavoro;

call insert_lavoro_muro(2, '2022-09-20 08:30:00', 'Terzo strato intonaco rosa facciata esterna', 'VLIMRA75B28L483I', 5, 2, 14, 2, 2, @id_lavoro);
insert into utilizzomateriale values ("LI1207R02", @id_lavoro, 12);
call insert_impiego('2022-09-20 08:30:00', '2022-09-20 11:30:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-20 11:30:00' where id=@id_lavoro;

-- piastrelle su muro bagno, facciata destra (interna)
call insert_lavoro_muro(2, '2022-09-20 15:30:00', 'Piastrelle decorative bagno', 'NRECLD90T25D612Z', 6, 2, 14, 1, 0, @id_lavoro);
insert into utilizzomateriale values ("LP1208Q11", @id_lavoro, 100);
call insert_impiego('2022-09-20 15:30:00', '2022-09-20 17:30:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-20 17:30:00' where id=@id_lavoro;
/*
call insert_lavoro_muro(2, '2022-09-20 15:30:00', 'Test rimozione copertura muro bagno', 'NRECLD90T25D612Z', 6, 2, 14, 1, 0, @id_lavoro);
insert into utilizzomateriale values ("LP1208Q11", @id_lavoro, 0);
call insert_impiego('2022-09-25 15:30:00', '2022-09-25 17:30:00', 'RSOSRA85C08G702J', @id_lavoro);
update lavoro set datafine='2022-09-25 17:30:00' where id=@id_lavoro;
*/

-- Pavimento bagno con piastrelle
call insert_lavoro_vano(2, '2022-09-20 08:30:00', 'Posa piastrelle bagno', 'VLIMRA75B28L483I', 40, 4, 3, @id_lavoro);
insert into utilizzomateriale values ("LP1208Q11", @id_lavoro, 140);
call insert_impiego('2022-09-20 08:30:00', '2022-09-20 12:30:00', 'MRRPLA65E05G702C', @id_lavoro);
call insert_impiego('2022-09-20 08:30:00', '2022-09-20 12:30:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-09-20 08:30:00', '2022-09-20 12:30:00', 'VRDLGU60A01F205P', @id_lavoro);
call insert_impiego('2022-09-23 08:30:00', '2022-09-23 12:30:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2022-09-23 08:30:00', '2022-09-23 12:30:00', 'VRDLGU60A01F205P', @id_lavoro);
update lavoro set datafine='2022-09-23 12:30:00' where id=@id_lavoro;

/* Installazione sensori */

insert into sensore (vano, tipo, soglia, x, y, z) values
	(1, 'Temperatura', 30, 1000, 3500, 3000),
    (1, 'Umidita', 90, 1000, 3500, 3000),
    (4, 'Temperatura', 30, 1000, 0, 3000),
    (4, 'Umidita', 90, 1000, 0, 3000),
    (5, 'Temperatura', 30, 1500, 2000, 3000),
    (5, 'Umidita', 90, 1500, 2000, 3000),
    (3, 'Accelerometro', 0.05, 1000, 1500, 3000),
    (3, 'Giroscopio', 0.05, 1000, 1500, 3000),
    (3, 'Allungamento', 3, 0, 1500, 1000),
    (3, 'Allungamento', 3, 1000, 0, 1000);


/* Altre case per testare le calamità */

/* Secondo edificio */
insert into edificio (id, latitudine, longitudine, zonageografica) values (2, 43.722977, 10.396566, "Toscana");
insert into piano values (0, 2);
insert into vano (id, piano, edificio, lunghezza, larghezza, altezzamax, funzione) values
    (6, 0, 2, 15000, 15000, 58360, "Open space");
insert into muro (id, x0, y0, x1, y1, vano1, vano2) values
    (20, 0, 0, 0, 15000, 6, null),
    (21, 0, 15000, 15000, 15000, 6, null),
    (22, 15000, 15000, 15000, 0, 6, null),
    (23, 15000, 0, 0, 0, 6, null);
insert into apertura (muro, sotto, sopra, sinistra, destra, tipo) values
	(23, 0, 2000, 900, 1900, "Porta");

insert into progettoedilizio values	(2, 0.00, 2);

insert into stadioavanzamento values
	(3, 2, '2021-08-01', '2021-08-15'),
	(4, 2, '2021-09-01', '2021-09-07');

call insert_lavoro_edificio(3, '2021-08-01 08:00:00', 'Posa fondamenta', 'NRECLD90T25D612Z', 120, 10, 2, @id_lavoro);
insert into utilizzomateriale values
	("LC1105P00", @id_lavoro, 5),		-- cemento
    ("LS1106G02", @id_lavoro, 15);		-- sabbia
call insert_impiego('2021-08-01 08:00:00', '2021-08-01 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2021-08-01 16:00:00', '2021-08-01 20:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2021-08-01 17:00:00', '2021-08-01 20:30:00', 'RSOSRA85C08G702J', @id_lavoro);
call insert_impiego('2021-08-05 15:30:00', '2021-08-05 18:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2021-08-05 16:00:00', '2021-08-05 18:00:00', 'RSOSRA85C08G702J', @id_lavoro);
call insert_impiego('2021-08-05 17:00:00', '2021-08-05 20:00:00', 'VRDLGU60A01F205P', @id_lavoro);
call insert_impiego('2021-08-07 09:30:00', '2021-08-07 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2021-08-07 09:30:00', '2021-08-07 12:00:00', 'RSOSRA85C08G702J', @id_lavoro);
call insert_impiego('2021-08-07 09:30:00', '2021-08-07 12:30:00', 'VRDLGU60A01F205P', @id_lavoro);
update lavoro set datafine='2021-08-07 12:30:00' where id=@id_lavoro;


call insert_lavoro_muro(4, '2021-09-03 08:00:00', 'Costruzione muro', 'VLIMRA75B28L483I', 30, 5, 20, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2021-09-03 08:00:00', '2021-09-03 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
update lavoro set datafine='2021-09-03 12:00:00' where id=@id_lavoro;

call insert_lavoro_muro(4, '2021-09-04 08:00:00', 'Costruzione muro', 'VLIMRA75B28L483I', 30, 5, 21, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2021-09-04 08:00:00', '2021-09-04 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
update lavoro set datafine='2021-09-04 12:00:00' where id=@id_lavoro;

call insert_lavoro_muro(4, '2021-09-05 08:00:00', 'Costruzione muro', 'VLIMRA75B28L483I', 30, 5, 22, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2021-09-05 08:00:00', '2021-09-05 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
update lavoro set datafine='2021-09-05 12:00:00' where id=@id_lavoro;

call insert_lavoro_muro(4, '2021-09-06 08:00:00', 'Costruzione muro', 'VLIMRA75B28L483I', 30, 5, 23, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2021-09-06 08:00:00', '2021-09-06 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
update lavoro set datafine='2021-09-06 12:00:00' where id=@id_lavoro;

insert into sensore (vano, tipo, soglia, x, y, z) values
	(6, 'Temperatura', 30, 7500, 0, 2000),
    (6, 'Umidita', 90, 7500, 0, 2000),
    (6, 'Accelerometro', 0.05, 7500, 7500, 58360),
    (6, 'Giroscopio', 0.05, 7500, 7500, 58360),
    (6, 'Allungamento', 3, 0, 7500, 1000),
    (6, 'Allungamento', 3, 15000, 7500, 1000);

/* Terzo edificio */
insert into edificio (id, latitudine, longitudine, zonageografica) values (3, 44.061980, 10.012952, "Liguria");
insert into piano values (0, 3);
insert into vano (id, piano, edificio, lunghezza, larghezza, altezzamax, funzione) values
    (7, 0, 3, 10000, 10000, 3000, "Open space");
insert into muro (id, x0, y0, x1, y1, vano1, vano2) values
    (24, 0, 0, 0, 10000, 7, null),
    (25, 0, 10000, 10000, 10000, 7, null),
    (26, 10000, 10000, 10000, 0, 7, null),
    (27, 10000, 0, 0, 0, 7, null);
insert into apertura (muro, sotto, sopra, sinistra, destra, tipo) values
	(27, 0, 2000, 900, 1900, "Porta");

insert into progettoedilizio values	(3, 0.00, 3);

insert into stadioavanzamento values
	(5, 3, '2021-05-01', '2021-05-15'),
	(6, 3, '2021-06-01', '2021-06-07');

call insert_lavoro_edificio(5, '2021-05-01 08:00:00', 'Posa fondamenta', 'NRECLD90T25D612Z', 120, 10, 3, @id_lavoro);
insert into utilizzomateriale values
	("LC1105P00", @id_lavoro, 5),		-- cemento
    ("LS1106G02", @id_lavoro, 15);		-- sabbia
call insert_impiego('2021-05-01 08:00:00', '2021-05-01 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2021-05-01 16:00:00', '2021-05-01 20:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2021-05-01 17:00:00', '2021-05-01 20:30:00', 'RSOSRA85C08G702J', @id_lavoro);
call insert_impiego('2021-05-05 15:30:00', '2021-05-05 18:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2021-05-05 16:00:00', '2021-05-05 18:00:00', 'RSOSRA85C08G702J', @id_lavoro);
call insert_impiego('2021-05-05 17:00:00', '2021-05-05 20:00:00', 'VRDLGU60A01F205P', @id_lavoro);
call insert_impiego('2021-05-07 09:30:00', '2021-05-07 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
call insert_impiego('2021-05-07 09:30:00', '2021-05-07 12:00:00', 'RSOSRA85C08G702J', @id_lavoro);
call insert_impiego('2021-05-07 09:30:00', '2021-05-07 12:30:00', 'VRDLGU60A01F205P', @id_lavoro);
update lavoro set datafine='2021-05-07 12:30:00' where id=@id_lavoro;


call insert_lavoro_muro(6, '2021-06-03 08:00:00', 'Costruzione muro', 'VLIMRA75B28L483I', 30, 5, 24, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2021-06-03 08:00:00', '2021-06-03 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
update lavoro set datafine='2021-06-03 12:00:00' where id=@id_lavoro;

call insert_lavoro_muro(6, '2021-06-04 08:00:00', 'Costruzione muro', 'VLIMRA75B28L483I', 30, 5, 25, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2021-06-04 08:00:00', '2021-06-04 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
update lavoro set datafine='2021-06-04 12:00:00' where id=@id_lavoro;

call insert_lavoro_muro(6, '2021-06-05 08:00:00', 'Costruzione muro', 'VLIMRA75B28L483I', 30, 5, 26, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2021-06-05 08:00:00', '2021-06-05 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
update lavoro set datafine='2021-06-05 12:00:00' where id=@id_lavoro;

call insert_lavoro_muro(6, '2021-06-06 08:00:00', 'Costruzione muro', 'VLIMRA75B28L483I', 30, 5, 27, 0, 0, @id_lavoro);
insert into utilizzomateriale values
	("LM1112M05", @id_lavoro, 40),		-- mattoni
	("LC1105P00", @id_lavoro, 0.1),		-- cemento
    ("LS1106G02", @id_lavoro, 0.4);		-- sabbia
call insert_impiego('2021-06-06 08:00:00', '2021-06-06 12:00:00', 'RSSMRA70A01H501S', @id_lavoro);
update lavoro set datafine='2021-06-06 12:00:00' where id=@id_lavoro;

insert into sensore (vano, tipo, soglia, x, y, z) values
	(7, 'Temperatura', 30, 5000, 0, 2000),
    (7, 'Umidita', 90, 5000, 0, 2000),
    (7, 'Accelerometro', 0.05, 5000, 5000, 3000),
    (7, 'Giroscopio', 0.05, 5000, 5000, 3000),
    (7, 'Allungamento', 3, 0, 5000, 1000),
    (7, 'Allungamento', 3, 10000, 5000, 1000);


/* Popolamento dati dei sensori e coefficienti rischio */
insert into rischiogeologico values ('Toscana', 'Terremoto', 180);
insert into rischiogeologico values ('Liguria', 'Terremoto', 180);

-- terremoto vecchio boh
call simula_sensori_terremoto ('2000-01-01 9:57:00', 'Terremoto', 43, 10, 7, '2000-01-01 07:00:00', '2000-01-01 10:02:00', 'Toscana');

call simula_sensori_terremoto ('2022-09-26 12:57:00', 'Terremoto',
	43.758958, 11.262258, 9, '2022-09-26 11:00:00',
    '2022-09-26 13:02:00', 'Toscana');	-- Terremoto abbastanza violento a Firenze
call simula_sensori_terremoto ('2022-09-26 12:57:00', 'Terremoto',
	43.758958, 11.262258, 9, '2022-09-26 11:00:00',
    '2022-09-26 13:02:00', 'Liguria');	-- lo stesso terremoto colpisce anche la Liguria
-- insert into danneggiamento values ('2022-09-26 12:57:00', 'Terremoto', 'Liguria'); -- colpisce anche la liguria
