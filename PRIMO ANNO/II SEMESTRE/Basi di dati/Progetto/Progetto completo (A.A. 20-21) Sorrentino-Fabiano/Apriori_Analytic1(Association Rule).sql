SET SQL_SAFE_UPDATES = 0;
set @@group_concat_max_len=20000;

drop procedure if exists Apriori;
delimiter $$
create procedure Apriori()
begin

-- VARIABILI DI APPOGGIO  
declare loca varchar(30); -- loca indica il singolo dispositivo (item) considerato
declare finito tinyint default 0; -- variabile handler
declare step integer default 2; -- indica a che step siamo nel loop delle regole (cioè la lunghezza dell'itemset della regola) 
declare k integer default 0; -- indica il numero di item totali
declare fre_select integer default 0; -- è un contatore che mi serve in Sql dinamico per contare il numero di attributi nella select 

-- VARIABILI FONDAMENTALI
declare _supp double default 0.01; -- supporto stabilito
declare _conf double default 0.3; -- confidenza stabilita

-- CURSORE PER ESTRARRE I NOMI DEI DISPOSITIVI (gli item)
declare farm cursor for   -- permette di estrarre i nomi dei dispositivi
select NomeDisp
from Dispositivo;
declare continue handler for not found set finito=1;


#-----------------------------------------------------------------------------------
-- TABELLA PIVOT delle TRANSAZIONI da cui ricavare le regole
set @inc=0; -- questa variabile è una specie di auto_increment
drop table if exists riferimento_pivot;
create table riferimento_pivot as (
select @inc:=@inc+1 as TID,ITEMLIST
from (select group_concat( distinct NomeDisp) as ITEMLIST 
from interazione natural join dispositivo
group by NomeUtente,hour(inizio), date(inizio)) as d);

select* from riferimento_pivot; -- mostro la tabella
#--------------------------------------------------------------------------------------




-- TABELLA DI RIFERIMENTO delle TRANSAZIONI (questa parte di codice è intervallata da un loop di utility)-----------------------------------------------------------------

set @tab_riferimento=null; -- inizializzo la variabile che potrebbe essere sporca

-- questa parte gestisce gli squash che collidono su un'unica transazione 
-- (bisogna trasformare la tabella interazione in una più compatta)

with dispositivi as ( 
select NomeDisp 
from Dispositivo
)
select group_concat( 
concat('sum(if(NomeDisp= ''',f.NomeDisp,''',1,0)) as ''', f.NomeDisp, '''' -- calcolo di una parte della select
) 
)
from dispositivi f 
into @tab_riferimento; 


set @tab_riferimento=concat(
'select NomeUtente, ',
@tab_riferimento,
' from interazione natural join dispositivo group by NomeUtente,hour(inizio), date(inizio)'  -- fino a questo passo la tabella non è completa (possiede un conteggio per elemento)
);

-- inizializzazione variabili possibilmente sporche --> completano delle query
set @ifstat=null; -- questa variabile contiene una serie di if utili
set @union_=null; -- questa variabile contiene una serie di union 
set @uni=null; -- questa variabile contiene una serie di union (diverse da @union)

-- LOOP DI UTILITY -> serve per gestire la parte propedeutica all'algoritmo
open farm;
scan:loop
fetch farm into loca;
if(finito=1) then leave scan;
end if;

if(@ifstat is null) then  set @ifstat=concat(' if(d.',loca,'<>0,"',loca,'",0) as ',loca); -- prima iterazione non ha la virgola davanti (sennò non funziona la select)
else
set @ifstat=concat(@ifstat,', if(d.',loca,'<>0,"',loca,'",0) as ',loca);
end if;

if(@union_ is null) then set @union_=concat('select "',loca,'" as ITEM, sum(if(',loca,'="',loca,'",1,0)) as OCCORRENZE, COUNT(*) as TOTALE from riferimento'); -- prima iterazione non necessita union all davanti
else
set @union_=concat_ws(' Union all ',@union_,concat('select "',loca,'" as ITEM, sum(if(',loca,'="',loca,'",1,0)) as OCCORRENZE, COUNT(*) as TOTALE from riferimento'));
end if;


if(@uni is null) then set @uni=concat('select TID, "',loca,'" as ITEM from riferimento where ',loca,'<> "0"'); -- prima iterazione non necessita union all davanti
else
set @uni =concat_ws(' Union all ',@uni,concat('select TID, "',loca,'" as ITEM from riferimento where ',loca,'<> "0"'));
end if;


end loop;
close farm;

-- aggiunta del if che aggiusta la tabella nel risultato desiderato
set @ghost=0;
set @tab_riferimento=concat(
' select @ghost:=@ghost+1 as TID, z.* 
  from (select ',@ifstat,
'       from (',@tab_riferimento,') as d) as z;'
);


-- creazione effettiva tabella di riferimento
drop table if exists riferimento; 
set @tab_rifer=null; -- inizializzo variabile che potrebbe essere sporca
set @tab_rifer=concat(
'create table riferimento as ',
@tab_riferimento
);


prepare sql_statement from @tab_rifer; 
execute sql_statement;


select* from riferimento; -- mostro la tabella
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- calcolo ITEM CANDIDATI per le regole (è lo step 1. Inizialmente è solo la lista degli elementi affiancati alle occorenze e al totale delle transazioni)----------------
set @C_creation='';	
drop table if exists C1;
set @C_creation=concat('
create table C1 as 
Select ITEM as ITEM_1, OCCORRENZE, TOTALE from ( 
',@union_,') as d;'); -- ogni item viene estratto dalla tab di riferimento da cui si fanno i conti e viene unito all'item successivo
prepare sql_statement from @C_creation; 
execute sql_statement;
/*
-- mostra la tabella
select*
from C1;
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- calcolo del supporto step 1 ------------------------------------------------------------------------------------------------------------------------------------
drop table if exists F1; 
create table F1 AS
SELECT ITEM_1, SUPPORTO, OCCORRENZE FROM (
    SELECT ITEM_1, OCCORRENZE/TOTALE as SUPPORTO, OCCORRENZE 
    FROM C1
) as D
WHERE SUPPORTO >= _supp; -- PRUNING
/*
-- mostra la tabella
select *
from F1;
*/
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------


# UTILITY per APRIORI------------------------------------------------------------------------------------------------------------------------------------------------
-- tabella che verticalizza gli elementi (necessaria per il passo di join) -> in pratica è una colonna di utility per fare i cross join
set @vertical='';	
drop table if exists Vertical;
set @vertical=concat('
create table Vertical as '
,@uni,';');
prepare sql_statement from @Vertical; 
execute sql_statement;
 
-- calcolo la lunghezza dell'itemset più grande (indica il numero massimo di loop da fare)
select max( length(ITEMLIST) - length(replace(ITEMLIST,',',''))+1) into k -- contando il numero di virgole = numero di elementi -1
from riferimento_pivot;
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------











#LOOP CHE MI CALCOLA TUTTE LE REGOLE FORTI (2 passi: 1)calcolo delle regole forti parziali 2) calcolo delle regole forti rimanenti)
# ATTENZIONE: alta densità di codice dinamico e tabelle non temporanee (dal momento che non sono concessi multi-statment nelle prepare e che non sono usabili temporary table)


large:loop

if(step>k) then leave large; -- se arrivo qui ho guardato la regola più lunga
end if;


-- VARIABILI per SQL DINAMICO
set @name_frequenza=concat('frequenza',step); -- indica la tabella FREQUENZA che si vuole considerare
set @name_regolestrong=concat('F',step-1); -- indica la tabella regoleforti che si vuole considerare (che è sempre quella del passo precedente)

-- TABELLA FREQUENZA : è una tabella di supporto che fa il passo di join (quindi calcola le possibili combinazioni) e determina gli elementi di frequenza

-- DROP
set @drop_freq=concat('drop table if exists ',@name_frequenza,';');
prepare sql_statement from @drop_freq; 
execute sql_statement;
-- SELECT
set fre_select=1;
set @fre_select=null;
set @fre_spaz=step-1; -- variabile d'appoggio che mi fa inserire particolari valori (l'ultimo prende l'indice del penultimo)
while fre_select<=step do
	if(fre_select=step) then  
		begin
        set @letter_select_freq='B'; -- l'ultima colonna
        end;
    else set @letter_select_freq='A'; -- le altre colonne
	end if;
    
	if (fre_select=1) then set @fre_select=concat(@letter_select_freq,'.ITEM_',fre_select,' as ITEM_',fre_select);-- in questo caso non ci va la virgola 
    else
		begin
		if(fre_select=step) then set @fre_select=concat(@fre_select,', ',@letter_select_freq,'.ITEM_',@fre_spaz,' as ITEM_',fre_select); -- qui si usa fre_spaz
        else
        set @fre_select=concat(@fre_select,', ',@letter_select_freq,'.ITEM_',fre_select,' as ITEM_',fre_select); -- questi sono gli item consecutivi nella select
		end if;
        end;
    end if;
    
	
    set fre_select=fre_select+1;
end while;
-- WHERE
set fre_select=1;
set @fre_where=null;

while fre_select<step do
-- i < confrontano in ordine alfabetico gli elementi
	if(fre_select=step-1) then  
        begin
			if(@fre_where is null) then set @fre_where=concat('A.ITEM_1 < B.ITEM_1'); -- caso speciale (vale solo per frequenza1)
			else
			  set @fre_where=concat(@fre_where,' and A.ITEM_',fre_select,'< B.ITEM_',fre_select);
			end if;
        end;
        else
			begin
			if(@fre_where is null) then set @fre_where=concat('A.ITEM_1 = B.ITEM_1'); -- caso speciale (vale solo per il primo elemento del where)
			else
			  set @fre_where=concat(@fre_where,' and A.ITEM_',fre_select,'= B.ITEM_',fre_select);
			  end if;
			end;
	end if;
set fre_select=fre_select+1;
end while;
-- CREATE
set @create_freq=concat('
CREATE TABLE ',@name_frequenza,' AS 
SELECT ',@fre_select,' 
FROM ',@name_regolestrong,' A CROSS JOIN ',@name_regolestrong,' B
WHERE ',@fre_where,';
');

prepare sql_statement from @create_freq; 
execute sql_statement;
-- MOSTRA la tabella
/*
set @mostra_freq=concat('select* from ',@name_frequenza,';');
prepare sql_statement from @mostra_freq; 
execute sql_statement;
*/

-- preparo la condizione di USCITA ANTICIPATA
set @fre_co=0;
set @fre_count=concat(
'select count(*) into @fre_co
 from ',@name_frequenza,';');
prepare sql_statement from @fre_count; 
execute sql_statement;

if (@fre_co=0) then leave large; -- in questo caso non ci sono più itemset frequenti (si può abbandonare prima il loop)
end if;




#TABELLA REGOLE CANDIDATE------------------------------------
set @name_C=concat('C',step);

-- DROP
set @drop_C=concat('drop table if exists ',@name_C,';');
prepare sql_statement from @drop_C; 
execute sql_statement;

-- SELECT e FROM
set fre_select=1; set @select1_C=''; set @select2_C=''; set @select3_C=''; set @select4_C=''; set @from1_C=''; set @from2_C=''; set @where1_C='';
set @where3_C=''; set @where4_C=''; set @on1_C=''; set @group1_C=''; set @group2_C=''; set @on2_C='';
sele:while fre_select <= step do
		set @select1_C=concat(@select1_C,' Z.ITEM_',fre_select,' as ITEM_',fre_select,', ');
		set @select2_C=concat(@select2_C,' C.ITEM_',fre_select,' as ITEM_',fre_select,', ');
		set @select3_C=concat(@select3_C,', A',fre_select,'.ITEM as ITEM_',fre_select);
        
        
        if(fre_select=1) then 
			begin
				set @from1_C=concat(' Vertical A',fre_select);
                set @on1_C=concat(' X.ITEM_',fre_select,'= C.ITEM_',fre_select);
                set @group1_C=concat(' C.ITEM_',fre_select);
			end ;
        else 
			begin
				set @from1_C=concat(@from1_C,' Cross join Vertical A',fre_select);
                set @on1_C=concat(@on1_C,' and X.ITEM_',fre_select,'= C.ITEM_',fre_select);
                set @group1_C=concat(@group1_C,', C.ITEM_',fre_select);
            end ;
        end if;
        
        if(fre_select>2) then -- questo va bene solo dall' itemset lungo 3 in poi
				set @where1_C=concat(@where1_C,' and A1.TID=A',fre_select,'.TID'); 
        end if;
        
        if(step>2 and fre_select>1 and fre_select<step) then 
				begin
					set @where3_C=concat(@where3_C,' and A.ITEM_',fre_select,'=B',fre_select,'.ITEM');
					set @where4_C=concat(@where4_C,' and B',fre_select-1,'.TID=B',fre_select,'.TID');
				end ;
		end if;
        
        if(fre_select<>step) then 
		  begin
			set @select4_C=concat(@select4_C,' A.ITEM_',fre_select,','); -- l'ultimo step non ci deve essere
            
            if(fre_select=1) then 
				begin
					set @group2_C=concat(' A.ITEM_',fre_select);
                    set @on2_C=concat(' Z.ITEM_',fre_select,'= E.ITEM_',fre_select);
				end;
            else 
				begin
					set @group2_C=concat(@group2_C,', A.ITEM_',fre_select);
                    set @on2_C=concat(@on2_C,' and Z.ITEM_',fre_select,'= E.ITEM_',fre_select);
				end ;
            end if;
			
            set @from2_C=concat(@from2_C,' cross join Vertical B',fre_select);
		  end;
        end if;
		
	set fre_select=fre_select+1;
	end while sele;
set @select1_C=concat(@select1_C,'Occorrenze, Elementi_Freq as Totale, Tot_Transazioni ');
set @select2_C=concat(@select2_C,'Count(Distinct C.TID) as Occorrenze ');


-- WHERE
set @where2_C='';
set fre_select=1;
while fre_select<step do

set @fr=fre_select+1;
while @fr<=step do
set @where2_C=concat(@where2_C,' and A',fre_select,'.ITEM<A',@fr,'.ITEM');
set @fr=@fr+1;
end while;

set fre_select=fre_select+1;
end while;

set @where1_C=concat(@where1_C,@where2_C);
set @where3_C=concat(@where3_C,@where4_C);

-- Create
set @create_C=concat('
CREATE TABLE ',@name_C,' AS
SELECT ',@select1_C,'
FROM
(
    SELECT ',@select2_C,'
    FROM (SELECT * FROM ',@name_frequenza,') as X
    INNER JOIN 
    (
        SELECT A1.TID',@select3_C,'
        FROM ',@from1_C,'
        WHERE A1.TID = A2.TID ',@where1_C,'
    ) as C 
    ON ',@on1_C,'
    GROUP BY ',@group1_C,'
) as Z

CROSS JOIN 
(
    SELECT COUNT(*) as Elementi_Freq 
    FROM ',@name_frequenza,'
) as D
INNER JOIN 
(
    SELECT ',@select4_C,' COUNT(DISTINCT B1.TID) as Tot_transazioni
    FROM ',@name_frequenza,' A ',@from2_C,'
	WHERE A.ITEM_1 = B1.ITEM ',@where3_C,'
    GROUP BY ',@group2_C,'
) as E ON ',@on2_C,' 
where OCCORRENZE< Elementi_Freq;
');
prepare sql_statement from @create_C; 
execute sql_statement;


-- preparo la condizione di USCITA ANTICIPATA
set @C_co=0;
set @C_count=concat(
'select count(*) into @C_co
 from ',@name_C,';');
prepare sql_statement from @C_count; 
execute sql_statement;

if (@C_co=0) then 
	begin
    prepare sql_statement from @drop_C; -- drop della tabella vuota 
	execute sql_statement;
    leave large; -- in questo caso non ci sono regole candidate (si può abbandonare prima il loop)
	end;
end if;
/*
-- MOSTRA la tabella
set @mostra_C=concat('select* from ',@name_C,';');
prepare sql_statement from @mostra_C; 
execute sql_statement;
*/

-- TABELLA REGOLE FORTI (Iniziali, poichè mancano alcune combinazioni della confidenza)--------------------------
-- Vengono proiettate solo le regole che raggiungono un certo supporto e di cui la confidenza dei primi k-1 elementi è raggiunta

set @name_F=concat('F',step);

-- DROP
set @drop_F=concat('drop table if exists ',@name_F,';');
prepare sql_statement from @drop_F; 
execute sql_statement;

-- SELECT
set fre_select=1;
set @select1_F='';
while fre_select<=step do
	set @select1_F=concat(@select1_F,'ITEM_',fre_select,',');
set fre_select=fre_select+1;
end while;

-- CREATE
set @create_F=concat('
CREATE TABLE ',@name_F,' AS
SELECT ',@select1_F,' SUPPORTO, CONFIDENZA, OCCORRENZE FROM (
    SELECT ',@select1_F,' TRUNCATE(OCCORRENZE / TOTALE,2) as SUPPORTO, TRUNCATE(OCCORRENZE / Tot_Transazioni,2) as CONFIDENZA, OCCORRENZE FROM ',@name_C,' 
) as D
WHERE SUPPORTO >= ',_supp,'
AND CONFIDENZA >= ',_conf,';
');
prepare sql_statement from @create_F; 
execute sql_statement;
-- MOSTRA la tabella
set @mostra_F=concat('select* from ',@name_F,';');
prepare sql_statement from @mostra_F; 
execute sql_statement;
set @ghostrider= fre_select; -- è necessario sapere l'ultimo F creata


set step=step+1; -- incremento step per il passo successivo

end loop;

-- ALTRE REGOLE FORTI: si ottengono combinando le C precedenti con la F che si vuole partizionare 
		-- creo una tabella Ri_j per ogni partizionamento (i si riferisce alla F considerata, j è il numero di colonne che fanno parte di X)

if(step>2) then
	begin
		set fre_select=3; -- il partizionamento si fa solo dallo step 3 in poi

		while fre_select<@ghostrider do
        
		set @inner_count=1; -- si parte dalla colonna singola
		set @max_partiz=fre_select-2; -- poichè la regola con k-1 determinati è quella descritta da F
		set @R_selection=''; set @item_count=1;
		
        
            -- WHILE DI SELECT
            while @item_count<=fre_select do
				set @R_selection=concat(@R_selection,'ITEM_',@item_count,',');
				set @item_count=@item_count+1;
			end while;
            
        
			-- WHILE PARTIZIONAMENTI
            
            while @inner_count<=@max_partiz do
				set @R_drop=concat('drop table if exists R',fre_select,'_',@inner_count,';');
				prepare sql_statement from @R_drop; 
				execute sql_statement;

				set @R_Create=concat(
				'create table R',fre_select,'_',@inner_count,' as
				select f.*,TRUNCATE(f.Occorrenze_/c',@inner_count,'.Occorrenze,2) as Confidenza
				from (select ',@R_selection,' Supporto,Occorrenze as Occorrenze_ 
					  from F',fre_select,') as f 
                      natural join C',@inner_count,' c',@inner_count,' ;
				');
                
				prepare sql_statement from @R_Create; 
				execute sql_statement;

			set @inner_count=@inner_count+1;
			end while;

		set fre_select=fre_select+1;
		end while;
	end;
end if;
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# in questa parte di codice si genera una TABELLA PIVOT che riassume le REGOLE FORTI --------------------------------------------------------
drop table if exists REGOLE_FORTI;
create TABLE REGOLE_FORTI (
 `X` varchar(1000) default '',
 `Y` varchar(1000) default '',
 `SUPPORTO` double default 0,
 `CONFIDENZA` double default 0,
 primary key (`X`,`Y`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

#POPOLAMENTO Regole Base ---------------------------------------------------------------
set @pewds=2; set @minecraft=1; set @regolo=''; set @conca=''; set fre_select=fre_select-2;

while @pewds<=fre_select do

	while @minecraft<fre_select do -- Concateno per X (in questo caso Y non è necessario perchè l'ultimo item: le regole Forti iniziali sono quelle con k-1 determinanti)
		
			set @conca=concat(@conca,',ITEM_',@minecraft);
		
		set @minecraft=@minecraft+1;
	end while;


	set @regolo=concat('
	insert into REGOLE_FORTI
	select concat_ws(","',@conca,') as X, ITEM_',@pewds,' as Y,SUPPORTO,CONFIDENZA
	from F',@pewds,';');
	prepare sql_statement from @regolo; 
	execute sql_statement;

set @pewds=@pewds+1;
end while;

-- Popolamento Regole partizionate -----------------------------------------------------------------
if(step>2) then 
begin
	set @pewds=3; 

	while @pewds<@ghostrider do
    
        set @inner_count=1; -- si parte dalla colonna singola
		set @max_partiz=@pewds-2; -- poichè la regola con k-1 determinati è quella descritta da F
        
        while @inner_count<=@max_partiz do -- inserisce tutte le tabelle partizionate Ri
			set @minecraft=1; set @regolo=''; set @conca='';
			
            -- CONCATENO per X
			while @minecraft<=@max_partiz do 
				
					set @conca=concat(@conca,',ITEM_',@minecraft);
				
				set @minecraft=@minecraft+1;
			end while;
			
            -- CONCATENO per Y
			set @minecraft=@max_partiz+1; set @conca2='';
			while @minecraft<=@pewds do -- Concateno per Y
				
					set @conca2=concat(@conca2,',ITEM_',@minecraft);
				
				set @minecraft=@minecraft+1;
			end while;


			set @regolo=concat('
			insert into REGOLE_FORTI
			select concat_ws(","',@conca,') as X, concat_ws(","',@conca2,') as Y ,SUPPORTO,CONFIDENZA
			from R',@pewds,'_',@inner_count,';');
			prepare sql_statement from @regolo; 
			execute sql_statement;
				
                
		set @inner_count=@inner_count+1;
		end while;

	set @pewds=@pewds+1;
	end while;

end;
end if;
#----------------------------------------------------------------------------------------------------------------------------------------------------
select*
from REGOLE_FORTI;


#DROP di tutte le tabelle che non mi servono più
set @drop_count=1; set @drop_name_freq='frequenza'; set @drop_name_C='C'; set @drop_name_F='F'; set @drop_name_R='R';
while @drop_count<=step do
	-- drop tabelle frequenti
    set @drop_name=concat(@drop_name_freq,@drop_count);
	set @dropper=concat('drop table if exists ',@drop_name,';');
	prepare sql_statement from @dropper; 
	execute sql_statement;
    -- drop tabelle regole candidate
    set @drop_name=concat(@drop_name_C,@drop_count);
	set @dropper=concat('drop table if exists ',@drop_name,';');
	prepare sql_statement from @dropper; 
	execute sql_statement;
    -- drop tabelle regole forti F
    set @drop_name=concat(@drop_name_F,@drop_count);
	set @dropper=concat('drop table if exists ',@drop_name,';');
	prepare sql_statement from @dropper; 
	execute sql_statement;
    -- drop tabelle regole forti R
    if (@drop_count>2) then
    begin
		set @inner_count=1; set @max_partiz=@drop_count -2; 
		while @inner_count<= @max_partiz do
			set @drop_name=concat(@drop_name_R,@drop_count,'_',@inner_count);
			set @dropper=concat('drop table if exists ',@drop_name,';');
			prepare sql_statement from @dropper; 
			execute sql_statement;
		set @inner_count=@inner_count+1;
		end while;
    end ;
    end if;
set @drop_count=@drop_count+1;
end while;
drop table if exists vertical;

end $$
delimiter ;
call Apriori();