use SmartBuildings_CT;
SET SQL_SAFE_UPDATES = 0;
SET GLOBAL event_scheduler = ON;

-- -----------------------------------------------------
-- Evento 1 (par 4.3.1.2) - Aggiornamento ridondanza costo_sal di StatoAvanzamento
-- -----------------------------------------------------

drop procedure if exists update_costo_sal;
delimiter $$
create procedure update_costo_sal (	)
begin
	 
    with 
    id_sal_to_update as (
		select sa.id_sal from StatoAvanzamento sa 
		where sa.data_fine_effettiva is null or sa.data_fine_effettiva >= now() - interval 25 hour
    ),
    costi_operai as (
		select l.id_sal, sum(i.ore_lavoro*o.costo_orario) costo_operai
		from Lavoro l
		inner join ImpiegoOperaio i on i.id_lavoro=l.id_lavoro
		inner join Operaio o on i.id_risorsa=o.id_risorsa
		where l.id_sal in (select id_sal from id_sal_to_update)
		group by l.id_sal ),
    costi_supervisori as (
		select l.id_sal , sum(i.ore_lavoro*o.costo_orario) costo_supervisori
		from Lavoro l
		inner join ImpiegoSupervisore i on i.id_lavoro=l.id_lavoro
		inner join Supervisore o on o.id_risorsa=i.id_risorsa
		where l.id_sal in (select id_sal from id_sal_to_update)
		group by l.id_sal ),
    costi_materiali as (
		select l.id_sal, sum(i.quantita*o.costo_unitario) costo_materiali
		from Lavoro l
		inner join UtilizzoMateriale i on i.id_lavoro=l.id_lavoro
		inner join Materiale o on o.fornitore=i.fornitore and o.codice_lotto=i.codice_lotto
		where l.id_sal in (select id_sal from id_sal_to_update)
		group by l.id_sal )
    update StatoAvanzamento 
    left join costi_operai on costi_operai.id_sal = StatoAvanzamento.id_sal
    left join costi_supervisori on costi_supervisori.id_sal = StatoAvanzamento.id_sal
    left join costi_materiali on costi_materiali.id_sal = StatoAvanzamento.id_sal
    set StatoAvanzamento.costo_sal = ifnull(costo_operai,0) + ifnull(costo_supervisori,0) + ifnull(costo_materiali,0)
    where StatoAvanzamento.id_sal in (select id_sal from id_sal_to_update)
    ;

end $$
delimiter ;
;

drop event if exists event_update_costo_sal ;
create event event_update_costo_sal
on schedule at timestamp(current_date() + interval 1 day ) + interval 2 hour
ON COMPLETION PRESERVE
do call update_costo_sal()
;


-- -----------------------------------------------------
-- Evento 2 (par 4.3.2.2) - Aggiornamento ridondanza data_fine_effettiva di StatoAvanzamento
-- -----------------------------------------------------

drop procedure if exists update_data_fine_effettiva;
delimiter $$
create procedure update_data_fine_effettiva (	)
begin
	 
    with 
    id_sal_to_update as (
		select sa.id_sal from StatoAvanzamento sa 
		where sa.data_fine_effettiva is null or sa.data_fine_effettiva >= now() - interval 25 hour
    ),
    date_fine as (
		select id_sal, DATE(max(i.dataora + interval i.ore_lavoro/60 minute)) data_fine
		from Lavoro l
		natural join ImpiegoSupervisore i
		where l.id_sal in (select id_sal from id_sal_to_update)
		group by l.id_sal )
    update StatoAvanzamento 
    left join date_fine on date_fine.id_sal = StatoAvanzamento.id_sal
    set StatoAvanzamento.data_fine_effettiva = date_fine.data_fine
    where StatoAvanzamento.id_sal in (select id_sal from id_sal_to_update)
    ;

end $$
delimiter ;
;

drop event if exists event_update_data_fine_effettiva ;
create event event_update_data_fine_effettiva
on schedule every 1 hour
starts timestamp(current_date()) + interval 8 hour
ends timestamp(current_date()) + interval 17 hour
ON COMPLETION PRESERVE
do call update_data_fine_effettiva()
;

-- -----------------------------------------------------
-- Evento 3 (par 4.1.3) - Cancellazione misure a bassa frequenza
-- -----------------------------------------------------
drop procedure if exists delete_misure_bassa_freq ;
delimiter $$
create procedure delete_misure_bassa_freq (	)
begin
	with
    sensori_bf as (
    select id_sensore from Misura m group by id_sensore
    having (to_seconds(max(dataora))-to_seconds(min(dataora)))/60/count(*) < 15
    )    
    delete from Misura m
	where id_sensore in (select id_sensore from sensori_bf) 
    and dataora < now() - interval 1 hour
    ;

end $$
delimiter ;
;

drop event if exists event_delete_misure_bassa_freq ;
create event event_delete_misure_bassa_freq 
on schedule every 1 hour
do call delete_misure_bassa_freq() 
;


-- -----------------------------------------------------
-- Evento 4 (par 4.1.3) - Cancellazione misure ad alta frequenza
-- -----------------------------------------------------

drop procedure if exists delete_misure_alta_freq;
delimiter $$
create procedure delete_misure_alta_freq (	)
begin
	with
    sensori_af as (
    select id_sensore from Misura m group by id_sensore
    having (to_seconds(max(dataora))-to_seconds(min(dataora)))/60/count(*) >= 15
    )    
    delete from Misura m
	where id_sensore in (select id_sensore from sensori_af) 
    and dataora < now() - interval 5 year
    ;

end $$
delimiter ;
;

drop event if exists event_delete_misure_alta_freq ;
create event event_delete_misure_alta_freq
on schedule every 5 year
do call delete_misure_alta_freq() 
;

-- -----------------------------------------------------
-- Evento 5 - Creo misure a bassa frequenza
-- -----------------------------------------------------

drop procedure if exists insert_misure_bassa_freq;
delimiter $$
create procedure insert_misure_bassa_freq (	)
begin
	
    declare _istante datetime(5);
    declare _acc_max float;
    set _istante = current_timestamp(5);
    set _acc_max = 2;
	
    drop temporary table if exists misure_dummy ;
    create temporary table misure_dummy (id int);
    insert into misure_dummy(id)
    values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
    (21),(22),(23),(24),(25),(26),(27),(28),(29),(30),(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
    (41),(42),(43),(44),(45),(46),(47),(48),(49),(50),(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),
    (61),(62),(63),(64),(65),(66),(67),(68),(69),(70),(71),(72),(73),(74),(75),(76),(77),(78),(79),(80),
    (81),(82),(83),(84),(85),(86),(87),(88),(89),(90),(91),(92),(93),(94),(95),(96),(97),(98),(99),(100),
    (101),(102),(103),(104),(105),(106),(107),(108),(109),(110),(111),(112),(113),(114),(115),(116),(117),(118),(119),(120),
    (121),(122),(123),(124),(125),(126),(127),(128),(129),(130),(131),(132),(133),(134),(135),(136),(137),(138),(139),(140),
    (141),(142),(143),(144),(145),(146),(147),(148),(149),(150),(151),(152),(153),(154),(155),(156),(157),(158),(159),(160),
    (161),(162),(163),(164),(165),(166),(167),(168),(169),(170),(171),(172),(173),(174),(175),(176),(177),(178),(179),(180),
    (181),(182),(183),(184),(185),(186),(187),(188),(189),(190),(191),(192),(193),(194),(195),(196),(197),(198),(199),(200)
    ;
	
    insert into Misura(id_sensore, valore_x, valore_y, valore_z, dataora)
    select 	s.id_sensore, 
			(_acc_max*rand()-_acc_max/2)*sin(microsecond(_istante - interval id*1000 MICROSECOND)),
			(_acc_max*rand()-_acc_max/2)*sin(microsecond(_istante - interval id*1000 MICROSECOND)),
            (_acc_max*rand()-_acc_max/2)*sin(microsecond(_istante - interval id*1000 MICROSECOND)),
			_istante - interval id*1000 MICROSECOND
    from Sensore s
    left join misure_dummy on 1=1
    where tipo_sensore = 'ACCELEROMETRO'
    ;
    
    insert into Alert(id_sensore, valore_x, valore_y, valore_z, dataora)
    select m.id_sensore, m.valore_x, m.valore_y, m.valore_z, m.dataora
    from Misura m
    inner join Sensore s on s.id_sensore=m.id_sensore
    where 
    m.dataora > _istante - interval 1 second
    and (m.valore_x > s.valore_soglia or m.valore_y > s.valore_soglia or m.valore_z > s.valore_soglia )
    ;

end $$
delimiter ;
;

/*
drop event if exists event_insert_misure_bassa_freq ;
create event event_insert_misure_bassa_freq
on schedule every 5 second
do call insert_misure_bassa_freq() 
;
*/
