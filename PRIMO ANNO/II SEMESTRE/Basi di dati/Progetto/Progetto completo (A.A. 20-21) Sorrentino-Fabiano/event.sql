
-- event che gestisce la creazione di interazione di IMPOSTAZIONI RICORRENTI per i CONDIZIONATORI
-- -----------------------------------------------------------------------------------------------

drop event if exists controlla_schedule;
delimiter $$
create event controlla_schedule
on schedule every 1 day 
starts '2021:11:03 05:00:00'  
do
begin 

-- variabili di valore
declare _nome varchar(30) default '';
declare _in timestamp default not null;
declare _disp integer default not null; 
declare _reg integer default not null;

-- variabili discriminanti
declare var tinyint default 0;
declare _ora timestamp default not null;

declare scheduling cursor for -- vengono presi solo i record schedulati che stanno nel range
select Utente,CodDisp,CodR,OraR
from schedule
where (month(current_date)>=MeseI and ((weekday(current_date) between GiornoI and GiornoF) or GiornoF is null) and MeseF is null) or -- quando è a mese indeterminato e giorno definito o indefinito
	  ((month(current_date) between MeseI and MeseF) and GiornoF is null) or -- quando è a giorno indeterminato e mese definito
      ((month(current_date) between MeseI and MeseF) and (weekday(current_date) between GiornoI and GiornoF)) -- quando sta nel range definito
;   

declare continue handler
for not found set var=1;

open scheduling;
scan:loop
fetch scheduling into _nome,_disp,_reg,_ora;

if(var=1)then leave scan;
end if;

set _in= timestamp(current_date,_ora); -- crea il timestamp di inizio interazione

insert into interazione -- inserimento della regolazione programmata (ricorrente)
values (_nome,_in,_disp,_reg,null,'Si');

end loop;
close scheduling;

end $$
delimiter ;
#------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- SPEGNE le impostazioni ricorrenti precedentemente impostate nello schedule -------------------------------------------------------------------------------------
drop event if exists spegni_schedule;
delimiter $$
create event spegni_schedule -- deve spegnere la regolazione nel momento stabilito da schedule
on schedule every 10 minute   
do
begin 

declare _nome varchar(30) default '';
declare _in timestamp default not null;
declare _fin timestamp default not null;
declare _disp integer default not null; 
declare _reg integer default not null;

declare var tinyint default 0;
declare _ora timestamp default not null;


declare scheduling cursor for -- vengono presi solo i record schedulati che hanno raggiunto la fine regolazione
select s.Utente,s.CodDisp,s.CodR,i.Inizio,timestampadd(minute,s.Durata,i.Inizio)
from interazione i inner join schedule s on (i.NomeUtente=s.Utente and i.CodDisp=s.CodDisp and i.CodR=s.CodR)
where i.Differita='Si' -- cerco solo le interazioni tra le interazioni in differita
	  and timestampadd(minute,s.Durata,i.Inizio)< now() -- devo prendere le interazioni terminate
;

declare continue handler
for not found set var=1;

open scheduling;
scan:loop
fetch scheduling into _nome,_disp,_reg,_in,_fin;

if(var=1)then leave scan;
end if;

update interazione
set Fine=_fin
where NomeUtente=_nome and Inizio=_in and CodDisp=_disp and CodR=_reg;

end loop;
close scheduling;


end $$
delimiter ;
#--------------------------------------------------------------------------------------------------------------------------------------------------
