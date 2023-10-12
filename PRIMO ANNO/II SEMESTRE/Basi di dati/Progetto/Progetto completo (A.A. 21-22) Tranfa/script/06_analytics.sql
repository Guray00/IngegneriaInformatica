use SmartBuildings_CT;

drop function if exists costo_muro ;
delimiter $$
create function costo_muro()
RETURNS float
READS SQL DATA
NOT DETERMINISTIC
begin
	
    declare _costo_medio float;
    
	with 
		costo_mat as (
			select l.id_lavoro, sum(u.quantita*m.costo_unitario) costo
			from Lavoro l
			inner join UtilizzoMateriale u on l.id_lavoro=u.id_lavoro
			inner join Materiale m on m.codice_lotto=u.codice_lotto and m.fornitore=u.fornitore 
			group by l.id_lavoro
		),
		costo_sup as (
			select l.id_lavoro, sum(si.ore_lavoro*s.costo_orario) costo
			from Lavoro l
			inner join ImpiegoSupervisore si on si.id_risorsa=l.id_supervisore
			inner join Supervisore s on s.id_risorsa=si.id_risorsa
			group by l.id_lavoro
		),
		costo_op as (
			select l.id_lavoro, sum(oi.ore_lavoro*o.costo_orario) costo
			from Lavoro l
			inner join ImpiegoOperaio oi on oi.id_lavoro=l.id_lavoro
			inner join Operaio o on o.id_risorsa=oi.id_risorsa
			group by l.id_lavoro
		),
		costo_tot as (
			select l.id_lavoro, ifnull(cm.costo,0)+ifnull(cs.costo,0)+ifnull(co.costo,0) costo
			from Lavoro l
			left join costo_mat cm on cm.id_lavoro=l.id_lavoro
			left join costo_sup cs on cs.id_lavoro=l.id_lavoro
			left join costo_op co on co.id_lavoro=l.id_lavoro
		),
		costo_muro_progetto as (
			select op.id_muro, sa.id_progetto, sum(c.costo) costo
			from OperaMuraria op
			inner join Lavoro l on l.id_lavoro=op.id_lavoro
			inner join costo_tot c on c.id_lavoro=l.id_lavoro
			inner join StatoAvanzamento sa on sa.id_sal=l.id_sal
			group by op.id_muro, sa.id_progetto
		)
	select avg(costo) into _costo_medio
	from costo_muro_progetto
	;
	return _costo_medio;

end $$
delimiter ;
;
-- select costo_muro();

drop function if exists costo_solaio ;
delimiter $$
create function costo_solaio()
RETURNS float
READS SQL DATA
NOT DETERMINISTIC
begin
	
    declare _costo_medio float;
    
	with 
		costo_mat as (
			select l.id_lavoro, sum(u.quantita*m.costo_unitario) costo
			from Lavoro l
			inner join UtilizzoMateriale u on l.id_lavoro=u.id_lavoro
			inner join Materiale m on m.codice_lotto=u.codice_lotto and m.fornitore=u.fornitore 
			group by l.id_lavoro
		),
		costo_sup as (
			select l.id_lavoro, sum(si.ore_lavoro*s.costo_orario) costo
			from Lavoro l
			inner join ImpiegoSupervisore si on si.id_risorsa=l.id_supervisore
			inner join Supervisore s on s.id_risorsa=si.id_risorsa
			group by l.id_lavoro
		),
		costo_op as (
			select l.id_lavoro, sum(oi.ore_lavoro*o.costo_orario) costo
			from Lavoro l
			inner join ImpiegoOperaio oi on oi.id_lavoro=l.id_lavoro
			inner join Operaio o on o.id_risorsa=oi.id_risorsa
			group by l.id_lavoro
		),
		costo_tot as (
			select l.id_lavoro, ifnull(cm.costo,0)+ifnull(cs.costo,0)+ifnull(co.costo,0) costo
			from Lavoro l
			left join costo_mat cm on cm.id_lavoro=l.id_lavoro
			left join costo_sup cs on cs.id_lavoro=l.id_lavoro
			left join costo_op co on co.id_lavoro=l.id_lavoro
		),
		costo_solaio_progetto as (
			select v.id_edificio, v.piano, sa.id_progetto, sum(c.costo) costo
			from OperaImpalcato op
            inner join Vano v on v.id_vano=op.id_vano
			inner join Lavoro l on l.id_lavoro=op.id_lavoro
			inner join costo_tot c on c.id_lavoro=l.id_lavoro
			inner join StatoAvanzamento sa on sa.id_sal=l.id_sal
			group by v.id_edificio, v.piano, sa.id_progetto
		)
	select avg(costo) into _costo_medio
	from costo_solaio_progetto
	;
	return _costo_medio;

end $$
delimiter ;
;
-- select costo_solaio();

-- -----------------------------------------------------
-- Accelerazione relativa media edifici orizzontale (xy) e verticale (z)
-- -----------------------------------------------------

drop function if exists accelerazione_differenziale_media_xy ;
delimiter $$
create function accelerazione_differenziale_media_xy ( )
RETURNS float
READS SQL DATA
NOT DETERMINISTIC
begin
	declare _acc float;
    
	with acc_piano as (
		select 	v.id_edificio, v.piano, 
				avg(sqrt(power(valore_x,2) + power(valore_y,2))) acc_xy,
				std(sqrt(power(valore_x,2) + power(valore_y,2))) st_err
		from Misura m
		inner join Sensore s on s.id_sensore=m.id_sensore
		inner join Vano v on v.id_vano=s.id_vano
		where
		s.tipo_sensore = 'ACCELEROMETRO' and 
        not exists (select * from Alert a where a.dataora=m.dataora and a.id_sensore=m.id_sensore)
		group by v.id_edificio, v.piano 
		),
	acc_diff_piano as (
		select a0.id_edificio, a0.piano, a0.acc_xy-a1.acc_xy acc_diff_xy
		from acc_piano a0
		left join acc_piano a1 on a0.id_edificio=a1.id_edificio and a0.piano=a1.piano+1 
		)
	select avg(abs(acc_diff_xy)) into _acc
	from acc_diff_piano
	;

	return _acc;
    
end $$
delimiter ;
;


drop function if exists accelerazione_differenziale_media_z ;
delimiter $$
create function accelerazione_differenziale_media_z ( )
RETURNS float
READS SQL DATA
NOT DETERMINISTIC
begin
	declare _acc float;
    
	with acc_piano as (
		select 	v.id_edificio, v.piano, 
				avg(abs(valore_z)) acc_z,
				std(abs(valore_z)) st_err
		from Misura m
		inner join Sensore s on s.id_sensore=m.id_sensore
		inner join Vano v on v.id_vano=s.id_vano
		where
		s.tipo_sensore = 'ACCELEROMETRO' and 
        not exists (select * from Alert a where a.dataora=m.dataora and a.id_sensore=m.id_sensore)
		group by v.id_edificio, v.piano 
		),
	acc_diff_piano as (
		select a0.id_edificio, a0.piano, a0.acc_z-a1.acc_z acc_diff_z
		from acc_piano a0
		left join acc_piano a1 on a0.id_edificio=a1.id_edificio and a0.piano=a1.piano+1 
		)
	select avg(abs(acc_diff_z)) into _acc
	from acc_diff_piano
	;

	return _acc;
    
end $$
delimiter ;
;

drop function if exists allungamento_differenziale_medio ;
delimiter $$
create function allungamento_differenziale_medio ( )
RETURNS float
READS SQL DATA
NOT DETERMINISTIC
begin
	declare _all float;
	
	with all_diff_sensore as (
		select m.id_sensore, m.dataora, m.valore_x - (lag(m.valore_x) over (partition by m.id_sensore order by m.dataora)) all_diff
		from Misura m
		inner join Sensore s on s.id_sensore=m.id_sensore
		where s.tipo_sensore = 'ESTENSIMETRO'
		and not exists (select * from Alert a where a.dataora=m.dataora and a.id_sensore=m.id_sensore)
		)
	select avg(all_diff) into _all
	from all_diff_sensore ;

	return _all;
    
end $$
delimiter ;
;

-- select accelerazione_differenziale_media_xy() ;
-- select accelerazione_differenziale_media_z() ;
-- select allungamento_differenziale_medio() ;


-- -----------------------------------------------------
-- Stato elementi
-- -----------------------------------------------------

drop procedure if exists stato_murature;
delimiter $$
create procedure stato_murature ( )
begin
	
    drop temporary table if exists stato_murature;
    create temporary table stato_murature(id int auto_increment primary key, id_edificio int, piano int, 
										acc_diff_xy float, acc_diff_xy_media float, scostamento float,
                                        numero_eventi_superamento int, deficit_muratura float ) ;
    
    insert into stato_murature(id_edificio, piano, acc_diff_xy, acc_diff_xy_media, 
								scostamento, numero_eventi_superamento, deficit_muratura)
	with acc_piano as (
		select 	v.id_edificio, v.piano, 
				avg(sqrt(power(valore_x,2) + power(valore_y,2))) acc_xy
		from Misura m
		inner join Sensore s on s.id_sensore=m.id_sensore
		inner join Vano v on v.id_vano=s.id_vano
		where
		s.tipo_sensore = 'ACCELEROMETRO' and 
        not exists (select * from Alert a where a.dataora=m.dataora and a.id_sensore=m.id_sensore)
		group by v.id_edificio, v.piano 
		),
	acc_diff_piano as (
		select a0.id_edificio, a0.piano, a0.acc_xy-a1.acc_xy acc_diff_xy
		from acc_piano a0
		left join acc_piano a1 on a0.id_edificio=a1.id_edificio and a0.piano=a1.piano+1 
		),
	sopra_soglia_giorno as (
		select	v.id_edificio, v.piano, date(a.dataora) as data, 
				avg(s.valore_soglia) media_soglia, 
				avg(sqrt(power(a.valore_x,2) + power(a.valore_y,2))) acc_alert_xy,  
				1 as numero_eventi_superamento
        from Alert a
        inner join Sensore s on s.id_sensore=a.id_sensore
        inner join Vano v on v.id_vano=s.id_vano
        where s.tipo_sensore = 'ACCELEROMETRO'
        group by v.id_edificio, v.piano, date(a.dataora) ),
	acc_sopra_soglia as (
		select	id_edificio, piano, avg(media_soglia) media_soglia, 
				avg(acc_alert_xy) acc_alert_xy,  
				count(numero_eventi_superamento) as numero_eventi_superamento
        from sopra_soglia_giorno
        group by id_edificio, piano
    ),
    stato as (
		select	a.id_edificio, a.piano - 1 as piano, a.acc_diff_xy,
				accelerazione_differenziale_media_xy() as acc_diff_xy_media,
				(a.acc_diff_xy - accelerazione_differenziale_media_xy())/(accelerazione_differenziale_media_xy())*100 as scostamento,
				ifnull(sup.numero_eventi_superamento,0) numero_eventi_superamento
		from acc_diff_piano a
		left join acc_sopra_soglia sup on sup.id_edificio=a.id_edificio and sup.piano=a.piano)
	select 	id_edificio, piano, acc_diff_xy,
			acc_diff_xy_media, scostamento,
			numero_eventi_superamento , 
            (case when scostamento>0 
				then scostamento*(max(piano) over (partition by id_edificio) - piano + 1) 
				else 0 
			end)*(1+numero_eventi_superamento) as deficit_muratura
	from stato ;
    
    -- select * from stato_murature ;
    
end $$
delimiter ;
;
-- call stato_murature ;

drop procedure if exists stato_solai;
delimiter $$
create procedure stato_solai ( )
begin
	
    drop temporary table if exists stato_solai;
    create temporary table stato_solai(id int auto_increment primary key, id_edificio int, piano int, 
										acc_diff_z float, acc_diff_z_media float, scostamento float, 
                                        numero_eventi_superamento int, deficit_solai float) ;
    
    insert into stato_solai(id_edificio, piano, acc_diff_z, acc_diff_z_media, 
							scostamento, numero_eventi_superamento, deficit_solai)
	with acc_piano as (
		select 	v.id_edificio, v.piano, 
				avg(abs(valore_z)) acc_z
		from Misura m
		inner join Sensore s on s.id_sensore=m.id_sensore
		inner join Vano v on v.id_vano=s.id_vano
		where
		s.tipo_sensore = 'ACCELEROMETRO' and 
        not exists (select * from Alert a where a.dataora=m.dataora and a.id_sensore=m.id_sensore)
		group by v.id_edificio, v.piano 
		),
	acc_diff_piano as (
		select a0.id_edificio, a0.piano, a0.acc_z-a1.acc_z acc_diff_z
		from acc_piano a0
		left join acc_piano a1 on a0.id_edificio=a1.id_edificio and a0.piano=a1.piano+1 
		),
	sopra_soglia_giorno as (
		select	v.id_edificio, v.piano, date(a.dataora) as data, 
				avg(s.valore_soglia) media_soglia, 
				avg(a.valore_z) acc_alert_z, 
				1 as numero_eventi_superamento
        from Alert a
        inner join Sensore s on s.id_sensore=a.id_sensore
        inner join Vano v on v.id_vano=s.id_vano
        where s.tipo_sensore = 'ACCELEROMETRO'
        group by v.id_edificio, v.piano, date(a.dataora) ),
	acc_sopra_soglia as (
		select	id_edificio, piano, avg(media_soglia) media_soglia, 
				avg(acc_alert_z) acc_alert_z,  
				count(numero_eventi_superamento) as numero_eventi_superamento
        from sopra_soglia_giorno
        group by id_edificio, piano
    ),
    stato as (
		select	a.id_edificio, a.piano, a.acc_diff_z,
				accelerazione_differenziale_media_z() acc_diff_z_media,
				(a.acc_diff_z - accelerazione_differenziale_media_z())/(accelerazione_differenziale_media_z())*100 scostamento,
				ifnull(sup.numero_eventi_superamento,0) as numero_eventi_superamento
		from acc_diff_piano a
		left join acc_sopra_soglia sup on sup.id_edificio=a.id_edificio and sup.piano=a.piano
		)
	select 	id_edificio, piano, acc_diff_z,
			acc_diff_z_media, scostamento,
			numero_eventi_superamento , 
            (case when scostamento>0 
				then scostamento * piano
				else 0 
			end)*(1+numero_eventi_superamento) as deficit_solai
	from stato ;
    
    -- select * from stato_solai ;
    
end $$
delimiter ;
;
-- call stato_solai() ;

drop procedure if exists stato_muri;
delimiter $$
create procedure stato_muri ( )
begin
	
    drop temporary table if exists stato_muri;
    create temporary table stato_muri(id int auto_increment primary key, id_edificio int, piano int, id_muro int, 
										all_ float, all_medio float, scostamento float,
                                        numero_eventi_superamento int, deficit_locale_muri float) ;
    
    insert into stato_muri(id_edificio, piano, id_muro, all_, all_medio, 
							scostamento, numero_eventi_superamento, deficit_locale_muri)
	with all_diff_sensore as (
		select m.id_sensore, m.dataora, m.valore_x - (lag(m.valore_x) over (partition by m.id_sensore order by m.dataora)) all_diff
		from Misura m
		inner join Sensore s on s.id_sensore=m.id_sensore
		where s.tipo_sensore = 'ESTENSIMETRO'
		and not exists (select * from Alert a where a.dataora=m.dataora and a.id_sensore=m.id_sensore)
		),    
    all_muro as (
		select 	v.id_edificio, v.piano, mu.id_muro,
				avg(m.all_diff) all_diff
		from all_diff_sensore m
		inner join Sensore s on s.id_sensore=m.id_sensore
		inner join Vano v on v.id_vano=s.id_vano
        inner join Perimetro p on p.id_vano=v.id_vano
        inner join Muro mu on mu.id_muro=p.id_muro and ST_Intersects(ST_GeomFromText(concat('point (',s.x,' ',s.y,')')), ST_GeomFromText(concat('linestring (',mu.xi,' ',mu.yi,',',mu.xf,' ',mu.yf,')')))
		group by v.id_edificio, v.piano, mu.id_muro
		),
	sopra_soglia_giorno as (
		select	v.id_edificio, v.piano, date(a.dataora) as data, 
				avg(s.valore_soglia) media_soglia, 
				avg(a.valore_x) acc_alert_all, 
				1 as numero_eventi_superamento
        from Alert a
        inner join Sensore s on s.id_sensore=a.id_sensore
        inner join Vano v on v.id_vano=s.id_vano
        where s.tipo_sensore = 'ESTENSIMETRO'
        group by v.id_edificio, v.piano, date(a.dataora) ),
	acc_sopra_soglia as (
		select	id_edificio, piano, avg(media_soglia) media_soglia, 
				avg(acc_alert_all) acc_alert_all,  
				count(numero_eventi_superamento) as numero_eventi_superamento
        from sopra_soglia_giorno
        group by id_edificio, piano
    ),
	muri_piano as (
		select v.id_edificio, v.piano, count(distinct id_muro) numero_muri
        from Perimetro p
        inner join Vano v on v.id_vano=p.id_vano
        group by v.id_edificio, v.piano
    ),
    stato as (
		select	a.id_edificio, a.piano, a.id_muro, a.all_diff,
				allungamento_differenziale_medio() all_diff_medio,
				(a.all_diff - allungamento_differenziale_medio())/(allungamento_differenziale_medio())*100 scostamento,
				ifnull(sup.numero_eventi_superamento,0) numero_eventi_superamento,
                n.numero_muri
		from all_muro a
        inner join muri_piano n on n.id_edificio=a.id_edificio and n.piano=a.piano
		left join acc_sopra_soglia sup on sup.id_edificio=a.id_edificio and sup.piano=a.piano
		)
	select 	id_edificio, piano, id_muro, all_diff,
			all_diff_medio, scostamento,
			numero_eventi_superamento , 
			(case when scostamento>0 
				then scostamento*(max(piano) over (partition by id_edificio) - piano + 1) 
				else 0 
			end)*(1+numero_eventi_superamento)/numero_muri as deficit_locale_muri
	from stato ;
    
    -- select * from stato_muri ;
    
end $$
delimiter ;
;
-- call stato_muri() ;

-- call stato_murature() ;
-- call stato_solai() ;
-- call stato_muri() ;

drop procedure if exists stato_edifici;
delimiter $$
create procedure stato_edifici ( )
begin
	
    call stato_murature() ;
	call stato_solai() ;
	call stato_muri() ;
    
    with 
    stato_murature_edificio as (
		select id_edificio, sum(deficit_muratura) deficit
		from stato_murature s
		group by id_edificio),
    stato_solai_edificio as (
		select id_edificio, sum(deficit_solai) deficit
		from stato_solai s
		group by id_edificio ),
    stato_muri_edificio as (
		select id_edificio, sum(deficit_locale_muri) deficit
		from stato_muri s
		group by id_edificio ),
	last_rischio as (
		select r.id_area, r.rischio, r.coeff_rischio, r.dataora,
				lead(r.coeff_rischio) over(partition by r.id_area, r.rischio order by r.dataora) lead_coeff
        from Rischio r
    )
	select	m.id_edificio, e.id_area,
			round(m.deficit + s.deficit + l.deficit, 0) stato_danno, 
			r.coeff_rischio, 
            round((m.deficit + s.deficit + l.deficit)*coeff_rischio,0) as stato_rischio,
            rank() over( order by (m.deficit + s.deficit + l.deficit)*coeff_rischio desc) as ranking
    from stato_muri_edificio m
    inner join stato_solai_edificio s on m.id_edificio=s.id_edificio 
    inner join stato_murature_edificio l on m.id_edificio=l.id_edificio
    inner join Edificio e on e.id_edificio=m.id_edificio
    left join last_rischio r on r.id_area=e.id_area and r.rischio='SISMICO' and r.lead_coeff is null
    ;
	
end $$
delimiter ;
;

-- call stato_edifici() ;



drop procedure if exists consigli_intervento_edificio;
delimiter $$
create procedure consigli_intervento_edificio (in _id_edificio int)
begin
	
    call stato_murature() ;
	call stato_solai() ;
	call stato_muri() ;
    
	with 
	muri_piano as (
		select v.id_edificio, v.piano, count(distinct id_muro) numero_muri
        from Perimetro p
        inner join Vano v on v.id_vano=p.id_vano
        group by v.id_edificio, v.piano
    ),
    effetto_domino_piano as (
		select *, 
				sum(numero_muri) over(partition by id_edificio order by piano desc) numero_muri_sopra,
				sum(numero_muri) over(partition by id_edificio order by piano asc) numero_muri_sotto,
				max(piano) over(partition by id_edificio) - piano as numero_solai_sopra,
				piano - min(piano) over(partition by id_edificio) as numero_solai_sotto
		from muri_piano ),    
    stato_elementi as (
		select	m.id_edificio, 'piano' as oggetto, m.piano as id, 
				m.deficit_muratura as deficit, 'rinforzo muratura' as intervento,
                round(n.numero_muri*costo_muro()*(m.scostamento/100),0) as costo_immediato,
                round(n.numero_muri_sopra*costo_muro() + n.numero_solai_sopra*costo_solaio(),0) as costo_futuro,
                1 as rischio
		from stato_murature m
        inner join effetto_domino_piano n on n.id_edificio=m.id_edificio and n.piano=m.piano
        where m.deficit_muratura > 0
        union
		select	s.id_edificio, 'piano' as oggetto, s.piano as id, 
				s.deficit_solai as deficit, 'consolidamento solaio' as intervento,
                round(1*costo_solaio()*(s.scostamento/100),0) as costo_immediato,
                round(n.numero_solai_sotto*costo_solaio(),0) as costo_futuro,
                1 as rischio
		from stato_solai s
        inner join effetto_domino_piano n on n.id_edificio=s.id_edificio and n.piano=s.piano
        where s.deficit_solai > 0
        union
		select	m.id_edificio, 'id muro' as oggetto, m.id_muro as id, 
				m.deficit_locale_muri as deficit, 'rinforzo locale muratura' as intervento,
                round(1*costo_muro()*(m.scostamento/100),0) as costo_immediato,
                round(n.numero_muri_sopra*costo_muro() + n.numero_solai_sopra*costo_solaio(),0) as costo_futuro,
                1/n.numero_muri as rischio
		from stato_muri m
        inner join effetto_domino_piano n on n.id_edificio=m.id_edificio and n.piano=m.piano
        where m.deficit_locale_muri > 0
    ),
	last_rischio as (
		select r.id_area, r.rischio, r.coeff_rischio, r.dataora,
				lead(r.coeff_rischio) over(partition by r.id_area, r.rischio order by r.dataora) lead_coeff
        from Rischio r
    )
	select 	e.id_edificio, e.tipo_edificio, 
			s.oggetto, s.id, s.deficit, s.intervento, 
            s.costo_immediato, s.costo_futuro,
            round(1/r.coeff_rischio/s.rischio) as giorni_prima_del_rischio,
            rank() over(order by costo_futuro/round(1/r.coeff_rischio/s.rischio) desc) ranking
    from stato_elementi s
    inner join Edificio e on e.id_edificio=s.id_edificio
    left join last_rischio r on r.id_area=e.id_area and r.rischio='SISMICO' and r.lead_coeff is null
    where e.id_edificio = _id_edificio
    ;
	
end $$
delimiter ;
;

-- call consigli_intervento_edificio(20);

