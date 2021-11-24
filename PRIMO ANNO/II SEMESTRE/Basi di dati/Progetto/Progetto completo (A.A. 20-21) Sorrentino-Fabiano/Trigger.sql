
# TRIGGER PER APERTURA ------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------

drop trigger if exists Verifica_Apertura; -- verifica che in apertura St1 e St2 siano esistenti e che non si possa reinserire un'apertura equivalente
delimiter $$                              -- un'apertura è equivalente a un'altra se St1=St2' e St2=St1' (per questo vanno evitate) 
create trigger Verifica_Apertura
before insert on Apertura for each row 
begin 
	
    -- verifica su St1
    if not exists( 
					select* 
					from 	Stanza 
					where CodSt=new.St1
                  ) then
		signal sqlstate '45000'
        set message_text = 'Errore : Stanza 1 inserita NON Esistente'; 
	end if;
    
	-- verifica su st2
    if(new.St2 is not null) -- perchè in caso alternativo non c'è bisogno di verificarlo
	   then
    
			if not exists(
							select*
							from 	Stanza 
							where CodSt=new.St2
							  
						 )then 
				signal sqlstate '45000'
				set message_text = 'Errore : Stanza 2 inserita NON Esistente'; 
			end if;
    
    end if;
    
    -- verifica su porte equivalenti
    if exists ( select*
				from Apertura
                where St1=new.St2 and St2=new.St1
               ) then
                signal sqlstate '45000'
				set message_text = 'Errore : Stanza 2 inserita NON Esistente';
    end if;
    
end $$
delimiter ;  
#--------------------------------------------------------








# TRIGGER PER LE IMPOSTAZIONI-----------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------

drop trigger if exists VerificaNumImpostazioni_Luce; -- non si possono avere più di 5 impostazioni personalizzabili per dispositivo
delimiter $$
create trigger VerificaNumImpostazioni_Luce
before insert on impLuce for each row 
begin
    declare count integer default 0; 
    
    select	count(*) into count
    from 	impLuce
    where 	coddisp = new.coddisp;
    
    if count >= 5 then
		signal sqlstate '45000'
        set message_text = 'Errore : Impostazioni Disponibili Terminate'; 
	end if; 
    
end $$
delimiter ;  
#---------------------------------------------------------

drop trigger if exists DefaultImpostazioni_Luce; -- se si modifica un impostazione non può essere più default
delimiter $$
create trigger DefaultImpostazioni_Luce
after update on impLuce for each row 
begin 
	
    if(new._Default='Si') then
    update 	impLuce 
    set 	_Default = 'No'
    where  CodDisp=new.CodDisp and CodR=new.CodR;
    end if;
    
end $$
delimiter ; 
#---------------------------------------------------------

drop trigger if exists VerificaNumImpostazioni_Condizionatore; -- possono esserci al massimo 5 impostazioni per condizionatore
delimiter $$
create trigger VerificaNumImpostazioni_Condizionatore 
before insert on impCondiz for each row
begin 

	declare count integer default 0; 
    
    select	count(*) into count
    from 	impCondiz
    where 	coddisp = new.coddisp;
    
    if count = 5 then
		signal sqlstate '45000'
        set message_text = 'Errore : Impostazioni Disponibili Terminate'; 
	end if; 

end $$
delimiter ;
#---------------------------------------------------------

drop trigger if exists DefaultImpostazioni_Condizionatore; -- se si modifica un impostazione non può essere più default
delimiter $$
create trigger DefaultImpostazioni_Condizionatore 
before insert on impCondiz for each row
begin 

if(new._Default='Si') then
    update 	impCondiz 
    set 	_Default = 'No'
    where  CodDisp=new.CodDisp and CodR=new.CodR;
    end if;
        
end $$
delimiter ;

#---------------------------------------------------------









#TRIGGER PER SMARTPLUG---------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------
drop trigger if exists VerificaCodDispCodSt_SmartP_1; -- gestisce solo la creazione di smartplug 
delimiter $$
create trigger VerificaCodDispCodSt_SmartP_1
before insert on smartplug for each row
begin 
	
    if(new.CodDisp is not null) -- perchè la smartplug potrebbe non avere dispositivi connessi
    then 
    if not exists 	(
					select	*
                    from 	Dispositivo 
                    where 	CodDisp = new.CodDisp
					)	then 
						signal sqlstate '45000'
                        set message_text = 'Errore : Dispositivo NON Riconosciuto';
	end if; 
    end if;
    
    if not exists 	(
					select	*
                    from 	Stanza s
                    where 	s.CodSt = new.CodSt
					) 	then 
						signal sqlstate '45000'
                        set message_text = 'Errore : Stanza NON Riconosciuta';
	end if; 

end $$
delimiter ;
#---------------------------------------------------------

drop trigger if exists VerificaCodDispCodSt_SmartP_1; -- gestisce l'update di smartplug 
delimiter $$
create trigger VerificaCodDispCodSt_SmartP_1
before update on smartplug for each row
begin 
	
    if(new.CodDisp is not null) -- perchè la smartplug potrebbe non avere dispositivi connessi
    then 
    if not exists 	(
					select	*
                    from 	Dispositivo 
                    where 	CodDisp = new.CodDisp
					)	then 
						signal sqlstate '45000'
                        set message_text = 'Errore : Dispositivo NON Riconosciuto';
	end if; 
    end if;
    
    if not exists 	( -- sta in una precisa stanza
					select	*
                    from 	Stanza s
                    where 	s.CodSt = new.CodSt
					) 	then 
						signal sqlstate '45000'
                        set message_text = 'Errore : Stanza NON Riconosciuta';
	end if; 

end $$
delimiter ;

#---------------------------------------------------------



#AGGIORNAMENTO RIDONDANZE IMPCondiz-----------------------------------------------------------------------------------------------------

-- aggiorna la tabella efficienza energetica per ogni record su termometro creato
-- aggiorna le ridondanze Tiniziale e Eunitaria in impcondiz
DROP TRIGGER IF EXISTS Calcola_Enecessaria;
delimiter $$
CREATE TRIGGER Calcola_Enecessaria
AFTER INSERT ON termometro
FOR EACH ROW
BEGIN
-- variabili per il calcolo
DECLARE _lung double DEFAULT 1; -- lunghezza
DECLARE _larg double DEFAULT 1; -- larghezza
DECLARE _alt double DEFAULT 1; -- altezza
DECLARE _p double DEFAULT 1.29; -- densità
DECLARE _Cp integer DEFAULT 1; -- calore specifico
DECLARE _DT double DEFAULT 0; -- (Testerna - Tinterna)
DECLARE Eff double DEFAULT 0; -- Energia necessaria
declare _k integer default 3; -- coefficiente conduzione mattone
declare _sp double default 0.2; -- spessore di un muro
declare _dissip double default 0; -- dissipamento istantaneo

-- calcolo effettivo
SELECT Altezza,Larghezza,Lunghezza INTO _alt,_larg,_lung -- ricavo i dati volumetrici della stanza
FROM stanza
WHERE CodSt=new.CodSt;

SET _DT=new.Testerna - new.Tinterna;
-- gestisco il valore assoluto di DT
if(_DT<0) then SET _DT=_DT*(-1);
end if;

SET Eff=_alt*_larg*_lung*_p*_Cp; -- è unitaria (1 grado)

-- aggiornamento Efficienza energetica
UPDATE efficienzaEnergetica
SET Testerna=new.Testerna, Tinterna=new.Tinterna, Enecessaria=Eff 
WHERE CodSt=new.CodSt;

-- calcolo dissipamento (istantaneo)

set _dissip=(_k/_sp)*_DT*_alt*(_lung+_larg); -- dove l'area esposta corrisponde a due pareti (alt*(lung+larg))

-- aggiornamento ridondanza impCondiz
UPDATE impcondiz
SET Tiniziale=new.Tinterna, Eunitaria=Eff, Dissipamento=_dissip
WHERE CodDisp in (Select CodDisp  -- aggiorno le ridondanze nei condizionatori della stanza dove la temperatura è variata
				  from condizionatore 
                  where Stanza=new.CodSt);



END $$
delimiter ;
#---------------------------------------------------------------------------------------------------------------------------------------








#TRIGGER PER SCHEDULE---------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------
-- nel caso venga eliminato uno schedule tutte le impostazioni programmate devono essere cancellate se non hanno il corrispettivo record in consumo 
-- (quindi se ancora non è stato calcolato, anche perchè il calcolo del consumo è relativo anche ai dati di schedule, che non ci sono più!)

drop trigger if exists distruggiSchedule;
delimiter $$
create trigger distruggiSchedule
before delete on schedule
for each row
begin

delete 
from interazione 
where Differita='Si' -- cerco solo le interazioni tra le interazioni in differita
	 and (NomeUtente,CodDisp,CodR) in (
									select Utente, CodDisp, CodR
                                    from schedule
                                    where Utente=old.Utente and CodDisp=old.CodDisp and CodR=old.CodR and OraR=old.OraR and GiornoI=old.GiornoI and MeseI=old.MeseI
                                    )
	  and Fine is null; -- quando ancora il trigger di spegnimento non è ancora partito
	  

end $$
delimiter ;

#----------------------------------------------------












#TRIGGER LEGATI AL TEMPO----------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------

-- trigger che impedisce di inserire una data futura (non si può usare il check)
drop trigger if exists controllo_batteria;
delimiter $$
create trigger controllo_batteria
before insert on batteria
for each row
begin

if (new.Data>current_date) then
	signal sqlstate '45000'
    set message_text='Data inserita non valida: non si possono programmare accumuli di energia in batteria' ;
end if;    

end $$
delimiter ;


-- trigger che impedisce di inserire una data futura (non si può usare il check)
drop trigger if exists controllo_documento;
delimiter $$
create trigger controllo_documento
before insert on documento
for each row
begin

if (new.Scadenza>current_date) then
	signal sqlstate '45000'
    set message_text='Data inserita non valida: non si possono inserire documenti scaduti' ;
end if;    

end $$
delimiter ;

-- trigger che impedisce di inserire una data futura (non si può usare il check)
drop trigger if exists controllo_nuovoutente; 
delimiter $$
create trigger controllo_nuovoutente
before insert on nuovoutente
for each row
begin

if (new.DataNascita>current_date) then
	signal sqlstate '45000'
    set message_text='Data inserita non valida' ;
end if;    

end $$
delimiter ;


-- trigger che impedisce di inserire una data futura (non si può usare il check)
drop trigger if exists controllo_registroiscrizione; 
delimiter $$
create trigger controllo_registroiscrizione
before insert on registroiscrizione
for each row
begin
	
if (new.DataIscrizione>current_date) then
	signal sqlstate '45000'
    set message_text='Data inserita non valida' ;
end if;    

end $$
delimiter ;













#TRIGGER SULLE STANZE-----------------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------------------------------------

-- controllo che la luce abbia una stanza

drop trigger if exists controllo_insert_stanza_luce;
delimiter $$
create trigger controllo_insert_stanza_luce
before insert on illuminazione
for each row
begin

if not exists (
			   select*
               from stanza
               where CodSt=new.Posizione
) then
	signal sqlstate '45000'
    set message_text='Stanza inserita non esistente' ;
end if;    

end $$
delimiter ;


drop trigger if exists controllo_update_stanza_luce; -- si potrebbe cambiare la posizione di una luce
delimiter $$
create trigger controllo_update_stanza_luce
before update on illuminazione
for each row
begin

if not exists (
			   select*
               from stanza
               where CodSt=new.Posizione
) then
	signal sqlstate '45000'
    set message_text='Stanza inserita non esistente' ;
end if;    

end $$
delimiter ;

-- controllo che il condizionatore abbia una stanza

drop trigger if exists controllo_insert_stanza_condiz;
delimiter $$
create trigger controllo_insert_stanza_condiz
before insert on condizionatore
for each row
begin

if not exists (
			   select*
               from stanza
               where CodSt=new.Stanza
) then
	signal sqlstate '45000'
    set message_text='Stanza inserita non esistente' ;
end if;    

end $$
delimiter ;





#TRIGGER su INTERAZIONE-----------------------------------------------------------------------------------------------------------------------------
-- accettato il suggerimento viene programmata l'interazione indicata


drop trigger if exists InterazioneDaSugg; 
delimiter $$
create trigger InterazioneDaSugg 
after update on Suggerimento for each row 
begin 
	
    declare H integer default 0; 
    declare Utente varchar(50) default ''; 
    declare I timestamp default '0000-00-00 00:00:00'; 
    declare F timestamp default NULL; 
    declare Reg integer default 0; 
    declare Disp integer default 0; 
    
    declare finito integer default 0; 
    declare SceltaPositiva cursor for
		select	Ora, NomeUtente, Inizio, CodR, CodDisp 
        from 	Suggerimento 
        where	Scelta = 'SI';
	declare continue handler for not found set finito = 1; 
    
    open SceltaPositiva; 
    preleva : loop 
		fetch SceltaPositiva into H, Utente, I, Reg, Disp; 
        if finito = 1 then 
			leave preleva; 
		end if; 
        
        call CreazioneInterazione(Utente, I, F, Disp, Reg); 
    end loop; 
    
end $$
delimiter ; 

