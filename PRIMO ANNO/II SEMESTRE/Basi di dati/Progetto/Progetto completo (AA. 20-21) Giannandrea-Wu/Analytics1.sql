-- -----------------------------------------------
-- Data Analytics 1: Association Rule Learning 
-- -----------------------------------------------

-- Contesto: Dispositivi intelligenti del Smarthome

-- 1) Individuazione Items e Transazioni			riga 23
-- 2) Algoritmo Apriori								riga 86
-- 3) Tabella delle regole forti					riga 332
-- 4) Algoritmo Apriori: 							riga 343
-- 		codice per esteso fino all'iterazione 4

-- Parametri per Apriori:
set @Confidence = 0.1;
set @Support = 0.1;

-- Parametri per definire le transazioni:
set @transaction_min_length = 2;
set @left_range = 5;
set @right_range = 20;

-- ---------------------------------------------
-- 1) Individuazione Items e Transazioni 
-- ---------------------------------------------
-- Gli items sono semplicemente i Dispositivi della Smarthome

use Smarthome;
set session group_concat_max_len = 5000;
select group_concat(concat('`D', IDDispositivo, '`', ' int default 0')) 
from Dispositivo into @pivot_table;

set @pivot_table = concat('create table Transazione(',
						  ' ID int auto_increment primary key, ', 
                            @pivot_table, 
						  ' )engine = InnoDB default charset = latin1;');
                          
drop table if exists Transazione;
prepare create_Table_Transazione from @pivot_table;
execute create_Table_Transazione;

-- -----------------------------------------
-- 1.1)	 Popolamento Transazione
-- -----------------------------------------
/* Ogni transazione è un insieme di dispositivi "usati insieme":
per ogni Interazione I con un Dispositivo, 
la transazione è l'insieme dei Dispositivi interagiti 
nell'intervallo di tempo [I.Inizio - @left_range minuti, I.Inizio + @right_range minuti].

Il parametro @transaction_min_length seleziona le transazioni con almeno tot elementi
*/
with transazioni as (
	select 	I.Dispositivo, 
			I.Inizio, 
			count(distinct I2.Dispositivo) as list_length, 
			concat(group_concat(distinct I2.Dispositivo)) as list
	from 	Interazione I 
			left outer join Interazione I2 
			on (I2.Inizio between 
				I.Inizio - interval @left_range minute and I.Inizio + interval @right_range minute)
	group by I.Dispositivo, I.Inizio
),
transazioni_dispositivo as (
	select 	Dispositivo, Inizio, IDDispositivo,
            if(find_in_set(IDDispositivo, list) > 0, IDDispositivo, 0) as Tag
	from 	transazioni 
			cross join Dispositivo
    where 	list_length >= @transaction_min_length
),
rows_transazione as (
	select 	Dispositivo, 
			Inizio, 
            group_concat(Tag order by IDDispositivo) as row_transazione
	from 	transazioni_dispositivo 
    group by Inizio, Dispositivo
)
	select group_concat(concat('(null,', row_transazione, ')') ) 
	from rows_transazione into @insert_rows;

set @insert_rows = concat('insert into Transazione values ', @insert_rows);
prepare insert_into_Transazione from @insert_rows;
execute insert_into_Transazione;

table Transazione;

-- -----------------------------------------
-- 2) 	Script per l'Algoritmo Apriori
-- -----------------------------------------

-- --------------------------------------------------------------
-- 2.1)		Funzioni di utilità per l'algoritmo Apriori
-- --------------------------------------------------------------
-- Principalmente generano codice dinamico 
-- per creare le diverse tabelle ad ogni passo iterativo dell'algoritmo

drop function if exists create_C;
delimiter ;;
create function create_C(k int)
returns text deterministic
begin
	declare i int default 1;
    declare Fk_select text default '';
    declare Fk_using text default '';
    declare combinazioni_select text default '';
    declare combinazioni_from text default '';
    declare result_items text default '';
    declare result_counts text default '';
    declare result_confidences text default '';
    declare result_join_using text default '';
    declare result text default '';

    while i < k do
		set Fk_select = concat(Fk_select, 'a.Item', i, ', ');
        set combinazioni_select = concat(combinazioni_select, 'I', i, '.Item as Item', i, ', ');
        set combinazioni_from = concat(combinazioni_from, 'inner join Items I', i+1, ' using(ID) \n');
        set result_items = concat(result_items, 'Item', i, ', ');
        set result_counts = concat(result_counts, 'Count', i, ', ');
        set result_confidences = concat(result_confidences, 'Count', k, ' / Count', i, ' as `Confidence', i, '`, \n\t\t');
	set i = i + 1;
    end while;
    
    set Fk_select = concat(Fk_select, 'b.Item', k-1, ' as Item', k);
    set combinazioni_select = concat('ID, ', combinazioni_select, 'I', i, '.Item as Item', i, ' ');
    set combinazioni_from = concat('Items I1 ', combinazioni_from);
    
    set result_join_using = result_items;
    set result_items = concat(result_items, 'Item', i);
    set result_counts = concat(result_counts, 'Count', i);
    set result_confidences = substring(result_confidences, 1, char_length(result_confidences) -5);
    set result_join_using = substring(result_join_using, 1, char_length(result_join_using) -2);
    
    set i = 1;
    while i < k-1 do
		set Fk_using = concat(Fk_using, 'Item', i, ', ');
        set i = i+1;
    end while;
    
    if k > 2 then 
		set Fk_using = substring(Fk_using, 1, char_length(Fk_using) -2);
		set Fk_using = concat('using(',Fk_using, ') ');
	else set Fk_using = '';
    end if;
    
    set result = concat(
'with F',k,' as (
	select 	',Fk_select,'
	from 	L',(k-1),' a inner join L',(k-1),' b ', Fk_using,'
	where 	a.Item',k-1,' <> b.Item',k-1,'    
),
combinazioni as (
	select 	',combinazioni_select,'
	from 	',combinazioni_from ,'
),
result as (
	select 	', result_items,',
			count(distinct ID) as Count', k,'
	from 	combinazioni natural join F',k,'
	group by ',result_items,'
)
select 	', result_items,',
		',result_counts,',
        Total,
        Count',k,' / Total as Support, 
        ',result_confidences,'
        
from 	result
		inner join L',k-1,' using(',result_join_using,')
;
'); -- fine concat
	return result;
end;;
delimiter ;

drop function if exists create_L;
delimiter ;;
create function create_L(k int)
returns text deterministic
begin
	return concat('select * from C', k,' where Support > @Support;');
end;;
delimiter ;


drop function if exists create_Large_Itemset;
delimiter ;;
create function create_Large_Itemset(k int)
returns text deterministic
begin
	declare i int default 1;
	declare items text default '';
    declare confidences text default '';
    declare result text default '';
    
    while i < k do
		set items = concat(items, 'Item', i, ', ');
        set confidences = concat(confidences, 'Confidence', i, ', ');
        set i = i + 1;
    end while;

    set result = concat('select ', items, ' Item', i, ', ', confidences, 'Support from L', k, ';');
    
    return result;
end;;
delimiter ;

drop procedure if exists get_Association_rules;
delimiter ;;
create procedure get_Association_rules(k int)
begin
	declare i int default 2;
	declare items text default 'Item1, ';
    declare confidences text default '';
    declare where_confidences text default '';
    declare result text default '';
    
	set @drop_Large = 'drop table if exists L;';
    set @create_Large = concat('create table L as ', create_Large_Itemset(k));
    
    prepare drop_large from @drop_Large;
    prepare create_large from @create_Large;
    execute drop_large;
    execute create_large;
    
    while i < k do
        set items = concat(items, 'Item', i, ', ');
        set confidences = concat(confidences, 'Confidence', i-1, ', ');
        set where_confidences = substring(confidences, 1, char_length(confidences) -2);
        set where_confidences = replace(where_confidences, ',', ' >= @Confidence or ');
        set where_confidences = concat(where_confidences, '>= @Confidence ');

        set @insert_Large = concat('insert into L (', items, confidences,
								'Support) \n select ', items, confidences, 'Support from L', i,
                                ' where ', where_confidences);
                                
        prepare insert_large from @insert_Large;
        execute insert_large;
        
        set i = i +1;
    end while;
end;;
delimiter ;


-- ---------------------------------------------------------------
-- 2.2) 	Stored Procedure Algoritmo Apriori
-- ---------------------------------------------------------------
-- La stored procedure esegue l'algoritmo iterativamente, al max fino
-- al parametro dato in ingresso, ma si ferma prima se un insieme dei itemset candidati C_k è vuota


drop procedure if exists Apriori;
delimiter ;;
create procedure Apriori(tot int)
begin
	declare k int default 2;
	
    -- --------------------------------------------
	-- 			Tabella di supporto Items 
    -- --------------------------------------------
	-- Items contiene {T.ID, T.[D_i]} per ogni Transazione T,
	-- dove t.[D_i] è ogni Dispositivo i della transazione.
    -- esempio: Transazione T1{A,B,C} -->  Items: {T1, A}, {T1, B}, {T1, C}
    
	select group_concat( 
			concat('select ID, D',IDDispositivo,
				   ' as Item from Transazione',
				   ' where D', IDDispositivo, ' <>0') 
			separator ' union ')
	from Dispositivo
	into @vertical_Transazione;
	set @vertical_Transazione = concat('create table Items as ',
										@vertical_Transazione, ';');
	drop table if exists Items;
	prepare create_table_Items from @vertical_Transazione;
	execute create_table_Items;

	-- ----------------------------------------------------------
	-- Itemset Candidati C1
	drop table if exists C1;
	create table C1 as 
	select 	Item as Item1, 
			count(*) as Count1, 
			(select count(*) from Transazione) as Total 
	from 	Items 
	group by Item;

	alter table C1 add column Support double default (Count1/Total);
	alter table C1 modify Item1 int;

	-- Large 1-itemset
	drop table if exists L1;
	create table L1 as 
		select * from C1 where support > @Support;
    
	-- -----------------------------------------
	-- LOOP Candidati C_k, Large Itemset L_k
	-- -----------------------------------------
	apriori: loop
		if k > tot then leave apriori; end if;
		
		set @dropC = concat('drop table if exists C', k, ';');
		set @createC = concat('create table C',k,' as ', create_C(k));
		set @dropL = concat('drop table if exists L', k, ';');
		set @createL = concat('create table L',k,' as ',create_L(k));
		
		prepare dropC from @dropC;
		prepare createC from @createC;
		execute dropC;
		execute createC;
		
		prepare dropL from @dropL;
		prepare createL from @createL;
		execute dropL;
		execute createL;
		
		set @check_empty = concat('select exists (select 1 from C', k,') into @fine_apriori;');
		prepare check_empty from @check_empty;
		execute check_empty;
		if @fine_apriori = 0 then leave apriori; end if;
				
		set k = k + 1;
	end loop;
    
	select k as MaxIterazione, tot as IterazioniRichieste;
    
    call get_Association_rules(k);
end;;
delimiter ;

call Apriori((select count(*) from Dispositivo));

-- ------------------
-- 3) Regole forti
-- ------------------
-- Per semplificare il codice, i nomi delle colonne sono stati semplificati:
-- Confidence1 vuol dire Confidence(Item1 --> Item2, Item3, ..)
-- Confidence2 vuol dire Confidence(Item1, Item2 --> Item3, ..)
-- Confidence3 vuol dire Confidence(Item1, Item2, Item3 --> Item4, ..)
-- ...
-- Count1 vuol dire Cardinalità dell'insieme {Item1} in Transazione
-- Count2 vuol dire Cardinalità dell'insieme {Item1, Item2} in Transazione
-- Count3 vuol dire Cardinalità dell'insieme {Item1, Item2, Item3} in Transazione ...

table L;

-- -----------------------------------------------------------------
-- 4) Algoritmo Apriori: codice per esteso fino all'iterazione 4
-- -----------------------------------------------------------------

/*
-- Tabella di supporto Items 
-- Items contiene {T.ID, T.[D_i]} per ogni Transazione T,
-- t.[D_i] è ogni Dispositivo i che compare nella transazione

select group_concat( 
		concat('select ID, D',IDDispositivo,
			   ' as Item from Transazione',
               ' where D', IDDispositivo, ' <>0') 
		separator ' union ')
from Dispositivo
into @vertical_Transazione;
set @vertical_Transazione = concat('create table Items as ',
									@vertical_Transazione, ';');
drop table if exists Items;
prepare create_table_Items from @vertical_Transazione;
execute create_table_Items;

table Items;


-- 2.1) Itemset Candidati C1
drop table if exists C1;
create table C1 as 
select 	Item as Item1, 
		count(*) as Count1, 
        (select count(*) from Transazione) as Total 
from 	Items 
group by Item;

alter table C1 add column Support double default (Count1/Total);
alter table C1 modify Item1 int;
table C1;

-- Large 1-itemset
drop table if exists L1;
create table L1 as 
	select * from C1 where support > @Support;
table L1;

-- -----------------------------------------
-- LOOP Candidati C_k, Large Itemset L_k
-- -----------------------------------------
-- candidati itemset C2
drop table if exists C2;
create table C2 as
with F2 as (
	select 	a.Item1, 
			b.Item1 as Item2
	from 	L1 a inner join L1 b
    where 	a.Item1 <> b.Item1    
),
combinazioni as (
	select 	ID, 
			a.Item as Item1, 
            b.Item as Item2
	from 	Items a 
			inner join Items b using(ID)
),
result as (
	select 	Item1, Item2, 
			count(distinct ID) as Count2
	from 	combinazioni natural join F2
	group by Item1, Item2
)
select 	Item1, Item2,
		Count2,
		Count1, 
        Total,
        truncate(Count2/Total, 4) as Support, 
        truncate(Count2/Count1, 4) as 'Confidence1'
from 	result 
		inner join L1 using(Item1)
;
table C2;

-- Large 2-itemset
drop table if exists L2;
create table L2 as 
	select * from C2 where Support > @Support;
table L2;


drop table if exists C3;
create table C3 as
with F3 as (
	select 	a.Item1, 
			a.Item2, 
            b.Item2 as Item3
	from 	L2 a inner join L2 b using(Item1)
	where 	a.Item2 <> b.Item2
),
 combinazioni as (
	select  ID, 
			a.Item as Item1, 
			b.Item as Item2, 
            c.Item as Item3
	from 	Items a 
			inner join Items b using(ID) 
			inner join Items c using(ID)
),
result as (
	select  Item1, Item2, Item3, 
			count(distinct ID) as Count3
	from 	combinazioni natural join F3 
	group by Item1, Item2, Item3
)
select 	Item1, Item2, Item3, 
		Count3,
        Count2,
		Count1,
        Total,
        truncate(Count3 / Total, 4) as Support,
        truncate(Count3 / Count1, 4) as 'Confidence1',
        truncate(Count3 / Count2, 4) as 'Confidence2'
from 	result 
        inner join L2 using(Item1, Item2);
        

-- Large 3-itemset
drop table if exists L3;
create table L3 as select * from C3 where Support > @Support; #and Confidence > 0.7;
table L3;

drop table if exists C4;
create table C4 as
with F4 as (
	select 	Item1, Item2,
            a.Item3,
            b.Item3 as Item4
	from 	L3 a inner join L3 b using(Item1, Item2)
	where 	a.Item3 <> b.Item3
),
 combinazioni as (
	select  ID, 
			a.Item as Item1, 
			b.Item as Item2, 
            c.Item as Item3, 
            d.Item as Item4
	from 	Items a 
			inner join Items b using(ID) 
			inner join Items c using(ID)
			inner join Items d using(ID)
),
result as (
	select  Item1, Item2, Item3, Item4,
			count(distinct ID) as Count4 
	from 	combinazioni natural join F4 
	group by Item1, Item2, Item3, Item4
)
select 	Item1, Item2, Item3, Item4,
		Count4,
        Count3,
        Count2,
        Count1,
        Total,
        truncate(Count4 / Total, 4) as Support,
        truncate(Count4 / Count1, 4) as 'Confidence1',
        truncate(Count4 / Count2, 4) as 'Confidence2',
        truncate(Count4 / Count3, 4) as 'Confidence3'
from 	result 
        inner join L3 using(Item1, Item2, Item3);


-- Large 4-itemset
drop table if exists L4;
create table L4 as select * from C4 where Support > @Support; #and Confidence > 0.7;
table L4;

-- ----------------------------------------------
-- Estrazione delle regole associative forti
-- ----------------------------------------------
drop table if exists L;
create table L as
	select Item1, Item2, Item3, Item4, Support, `Confidence1`, `Confidence2`, `Confidence3`  
	from L4;

Insert into L (Item1, Item2, Support, `Confidence1`) 
		select Item1, Item2, Support, `Confidence1` from L2;
Insert into L (Item1, Item2, Item3, Support, `Confidence1`, `Confidence2`) 
		select Item1, Item2, Item3, Support, `Confidence1`, `Confidence2` from L3;

select * from L 
where  (`Confidence1` >= @Confidence or 
		`Confidence2` >= @Confidence or 
		`Confidence3` >= @Confidence);

select 	d1.Nome as d1,
        d2.Nome as d2,
        d3.Nome as d3,
        d4.Nome as d4,
        L.*
from 	L 
		left join Dispositivo d1 on Item1 = d1.IDDispositivo         
        left join Dispositivo d2 on Item2 = d2.IDDispositivo         
        left join Dispositivo d3 on Item3 = d3.IDDispositivo   
        left join Dispositivo d4 on Item4 = d4.IDDispositivo         
;
-- */