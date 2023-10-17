use SmartBuildings_CT;

-- -----------------------------------------------------
-- Operazione 1 (par. 4.2.1) - InserimentoMisura
-- -----------------------------------------------------
drop procedure if exists InserimentoMisura;
delimiter $$
create procedure InserimentoMisura (in _id_sensore int, 
									in _valore_x float, 
                                    in _valore_y float, 
                                    in _valore_z float,
                                    in _dataora datetime(5))
begin
	declare _soglia float;
    
    if _dataora is null then
		set _dataora = current_timestamp(5);
	end if;

	insert into Misura(id_sensore, valore_x, valore_y, valore_z, dataora)
    values (_id_sensore, _valore_x, _valore_y, _valore_z, _dataora) ;
    
    select valore_soglia into _soglia from Sensore where id_sensore = _id_sensore;
    
    if (abs(_valore_x) >= _soglia or abs(_valore_y) >= _soglia or abs(_valore_z) >= _soglia) then
		insert into Alert(id_sensore, valore_x, valore_y, valore_z, dataora)
		values (_id_sensore, _valore_x, _valore_y, _valore_z, _dataora) ;
	end if;
    
end $$
delimiter ;
;

-- -----------------------------------------------------
-- Operazione 2 (par. 4.2.2) - InserimentoTurnoOperaio
-- -----------------------------------------------------
drop procedure if exists InserimentoTurnoOperaio;
delimiter $$
create procedure InserimentoTurnoOperaio (	in _id_lavoro int, 
											in _id_risorsa char(16), 
											in _inizio datetime, 
											in _ore_lavoro float)
begin
	declare _id_supervisore char(16);
    select id_supervisore into _id_supervisore from Lavoro where id_lavoro = _id_lavoro;
    
    -- controlli dummy
    if _ore_lavoro <= 0.015 then
		signal sqlstate "45000" set message_text = "Non puoi inserire un turno di durata inferiore a 1 minuto";
    end if;
    
    -- sovrapposizioni di turni dell'operaio
    if (select count(*) from ImpiegoOperaio i where i.id_risorsa = _id_risorsa 
    and 
    (	(i.dataora >= _inizio and i.dataora < _inizio + interval _ore_lavoro*60 minute ) -- - da rivedere
        or
		(i.dataora + interval i.ore_lavoro*60 minute > _inizio and i.dataora + interval i.ore_lavoro*60 minute <= _inizio + interval _ore_lavoro*60 minute)
    )
    ) > 0 then
		signal sqlstate "45000" set message_text = "Il turno che si vuole inserire è in conflitto con un'altro turno assegnato all'operaio";
    end if;
    
    -- presenza del supervisore assegnato durante il turno dell'operaio
    if (select count(*) from ImpiegoSupervisore i where i.id_lavoro = _id_lavoro
    and i.dataora <= _inizio and i.dataora+ interval i.ore_lavoro*60 minute >= _inizio + interval _ore_lavoro*60 minute
    ) = 0 then
		signal sqlstate "45000" set message_text = "Durante il turno che si vuole inserire non è presente il supervisore";
    end if;
    
	-- check numero operai coordianti da supervisore
    if (select count(distinct id_risorsa)+1 from ImpiegoOperaio i where i.id_lavoro = _id_lavoro and i.id_risorsa != _id_risorsa
		) > (select max_operai from Supervisore where id_risorsa = _id_supervisore) then
		signal sqlstate "45000" set message_text = "E' stato raggiunto il numero massimo di risorse coordinabili dal supervisore";
    end if;
    
	-- check numero operai massimo che lavorano contemporaneamente
    if (select count(distinct id_risorsa)+1 from ImpiegoOperaio i where i.id_lavoro = _id_lavoro and i.id_risorsa != _id_risorsa
    and 
    (	(i.dataora <= _inizio and i.dataora + interval i.ore_lavoro*60 minute > _inizio )
        or
		(i.dataora > _inizio and i.dataora < _inizio + interval _ore_lavoro*60 minute )
    )
    ) > (select max_operai from Lavoro where id_lavoro = _id_lavoro) then
		signal sqlstate "45000" set message_text = "E' stato raggiunto il numero massimo di risorse che possono lavorare contemporaneamente";
    end if;
    
	insert into ImpiegoOperaio(id_lavoro, id_risorsa, dataora, ore_lavoro)
	values (_id_lavoro, _id_risorsa, _inizio, _ore_lavoro) ;

end $$
delimiter ;
;

-- -----------------------------------------------------
-- Operazione 3 (par. 4.2.3) - InstallazioneSensore
-- -----------------------------------------------------
drop procedure if exists InstallazioneSensore;
delimiter $$
create procedure InstallazioneSensore (	in _id_vano int, 
										in _tipo_sensore varchar(50), 
										in _valore_soglia float,
                                        in _x float,
                                        in _y float,
                                        in _z float )
begin
    -- controllo se le coordinate sono contenute nel poligono oppure lungo i bordi
	declare _poligono_vano, _punto_sensore geometry;
    declare _altezza_vano float;
    select altezza into _altezza_vano from Vano v where v.id_vano=_id_vano ;
    select	ST_GeomFromText(concat('polygon ((',GROUP_CONCAT(concat(xi,' ',yi,',',xf,' ',yf)),'))')) 
			into _poligono_vano 
	from Muro m 
	inner join Perimetro p on p.id_muro=m.id_muro
	where p.id_vano=_id_vano ;
    select ST_GeomFromText(concat('point (',_x,' ',_y,')')) into _punto_sensore ;
    
    -- se sul bordo allora altezza comrpesa 0-altezza_vano se non sul bordo altezza 0
    if not (
		(_tipo_sensore!='ACCELEROMETRO' and st_touches(_punto_sensore, _poligono_vano) and _z between 0 and _altezza_vano)
        or 
        (_tipo_sensore!='ESTENSIMETRO' and ST_CONTAINS(_poligono_vano, _punto_sensore) and (_z = 0 or _z = _altezza_vano))
			) then
		signal sqlstate "45000" set message_text = "Le coordinate del sensore non sono contenute nel vano specificato (oppure sul perimetro)";
    end if;
    
	insert into Sensore(id_vano, tipo_sensore, valore_soglia, x, y, z)
	values (_id_vano, _tipo_sensore, _valore_soglia, _x, _y, _z) ;

end $$
delimiter ;
;

-- -----------------------------------------------------
-- Operazione 4 (par. 4.2.4) - CostoSAL
-- -----------------------------------------------------
drop function if exists CostoSAL;
delimiter $$
create function CostoSAL (	_id_sal int )
RETURNS float
READS SQL DATA
NOT DETERMINISTIC
begin
	declare _costo float;
    
	select sa.costo_sal into _costo from StatoAvanzamento sa where sa.id_sal = _id_sal ;

	return _costo;
    
end $$
delimiter ;
;

-- -----------------------------------------------------
-- Operazione 5 (par. 4.2.5) - InserimentoAltroMateriale
-- -----------------------------------------------------
drop procedure if exists InserimentoAltroMateriale;
delimiter $$
create procedure InserimentoAltroMateriale (	in _codice_lotto int, 
                                                in _fornitore varchar(50), 
                                                in _nome_materiale varchar(50), 
                                                in _data_acquisto datetime, 
                                                in _costo_unitario float, 
                                                in _unita_misura varchar(2), 
                                                in _peso_medio float,
                                                in _disegno varchar(50),
                                                in _tipo_materiale varchar(50),
                                                in _spessore float,
                                                in _larghezza float, 
                                                in _lunghezza float )
begin
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    begin
		SHOW ERRORS;
		ROLLBACK;
	end;
    
	start transaction;
		insert into Materiale(codice_lotto, fornitore, nome_materiale, data_acquisto, costo_unitario, unita_misura)
		values (_codice_lotto, _fornitore, _nome_materiale, _data_acquisto, _costo_unitario, _unita_misura) ;
		
		insert into AltroMateriale(codice_lotto, fornitore, peso_medio, disegno, tipo_materiale, spessore, larghezza, lunghezza)
		values (_codice_lotto, _fornitore, _peso_medio, _disegno, _tipo_materiale, _spessore, _larghezza, _lunghezza) ;
	commit;
    
end $$
delimiter ;
;

-- -----------------------------------------------------
-- Operazione 6 (par. 4.2.6) - ListaProgettiInCorso
-- -----------------------------------------------------
drop procedure if exists ListaProgettiInCorso;
delimiter $$
create procedure ListaProgettiInCorso (	)
begin

	select p.id_progetto, p.tipo_progetto, p.data_inizio, p.data_fine_stimata,
			p.id_edificio, e.tipo_edificio , max(sa.data_fine_effettiva) nuova_fine_stimata
    from Progetto p
    inner join StatoAvanzamento sa on sa.id_progetto=p.id_progetto
    inner join Edificio e on e.id_edificio=p.id_edificio
    where sa.data_fine_effettiva is null or sa.data_fine_effettiva > current_date()
    group by p.id_progetto, p.tipo_progetto, p.data_inizio, p.data_fine_stimata,
			p.id_edificio, e.tipo_edificio
    ;

end $$
delimiter ;
;

-- -----------------------------------------------------
-- Operazione 7 (par. 4.2.7) - Impegno2SettimaneOperaio
-- -----------------------------------------------------
drop procedure if exists Impegno2SettimaneOperaio;
delimiter $$
create procedure Impegno2SettimaneOperaio (	in _id_risorsa char(16)	)
begin

	select i.id_risorsa, i.id_lavoro, l.id_supervisore, i.dataora inizio, 
			(i.dataora + interval i.ore_lavoro*60 minute) as fine
    from ImpiegoOperaio i
    natural join Lavoro l 
    where i.id_risorsa = _id_risorsa
    and i.dataora >= now()
    and i.dataora + interval ore_lavoro*60 minute <= now() + interval 2 week
    order by i.id_lavoro, i.dataora
    ;

end $$
delimiter ;
;

-- -----------------------------------------------------
-- Operazione 8 (par. 4.2.8) - DatiEdificio
-- -----------------------------------------------------
drop procedure if exists DatiEdificio;
delimiter $$
create procedure DatiEdificio (	in _id_edificio int	)
begin

	select e.id_edificio, e.tipo_edificio, p.piano, v.id_vano, 
			v.funzione, v.lunghezza*v.larghezza as superficie_stimata
    from Edificio e
    natural join Piano p
    natural join Vano v 
    where e.id_edificio = _id_edificio
    order by p.piano, v.funzione
    ;

end $$
delimiter ;
;