#[5.2.1]CREAZIONE di un ACCOUNT ----------------------------------------------------------------------------------

drop procedure if exists CreazioneAccount; 
delimiter $$
create procedure CreazioneAccount 	(
									in codfiscale varchar(40), --
									in nome varchar(40), --
                                    in cognome varchar(40), --
                                    in datanascita date, --
									in telefono double, --
                                    in nomeutente varchar(40), 
                                    in pswrd varchar(40), 
                                    in domanda varchar(255), 
                                    in risposta varchar(255), 
									in privilegio varchar(255), 
                                    in tipoDoc varchar(40), 
                                    in scadenza date, 
                                    in enteRilascio varchar(40), 
                                    in num varchar(10) -- 
									)
begin 
    
    if datediff(current_date, scadenza) < 0 && (length(pswrd) > 7 && length(nomeutente) > 3) then 
		begin 
			insert into nuovoUtente values (codfiscale, nome, cognome, datanascita, telefono);
            insert into registroIscrizioni values (codfiscale, num, nomeutente, current_date); 
            insert into documento values (num, tipodoc, scadenza, enteRilascio); 
            insert into account values (nomeutente, pswrd, privilegio, domanda, risposta); 
        end ; 
	else 
    signal sqlstate '45000'
    set message_text='Errore, dati non corretti. Indicare un documento non scaduto e/o una password lunga almeno 8 caratteri e/o un nome utente lungo 4';
	end if;

end $$
delimiter ; 
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------





#[5.2.2]"CONSUMO DISPOSITIVO"-------------------------------------------------------------------------------------------------------------------------------

drop trigger if exists calcoloConsumo; 
delimiter $$
create trigger calcoloConsumo after update on Interazione for each row -- il consuno viene calcolato ogni volta che lo stato di fine interazione viene settato con update  
begin 
	
    declare ValConsumo double default 0; 
    declare TipoD varchar(40) default ''; 
    declare tempoD integer default 0; 
    declare F varchar(3) default ''; 
    declare H integer default 0; 
    declare TempCondiz integer default 0; 
    declare TempInterna integer default 0; 
    declare TempExt integer default 0; 
    declare Diss double default 0; 
    
    declare finito integer default 0; 
    
    select	tipoconsumo into TipoD
    from 	Dispositivo 
    where	coddisp = new.coddisp; 
    
	if TipoD = 'Fisso' then 				
		begin 
			select	l.CLVL 	into ValConsumo 
			from 	Livello l
			where	l.codr = new.codr
			and 	l.coddisp = new.coddisp; 
			
			set ValConsumo = ValConsumo * ((time_to_sec(timediff(new.fine, new.inizio)))/3600);
            
			select	distinct last_value(FasciaOraria) over() into F
			from 	contatorebidirezionale
			where	RangeF <= hour(new.Inizio);
			
			set H = hour(new.inizio);
		
			insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
		end; 
	end if; 
	
    if TipoD = 'Variabile' then 
		if new.coddisp in 	(						-- Illuminazione
							select  i.coddisp 
                            from 	illuminazione i
							) then 
			begin 
				select	i1.cspecifico into ValConsumo
                from 	illuminazione i1
                where	i1.coddisp = new.coddisp;
					
				set ValConsumo = ValConsumo * ((time_to_sec(timediff(new.fine, new.inizio)))/3600);
                
                select	distinct last_value(FasciaOraria) over() into F
				from 	contatorebidirezionale
				where	RangeF <= hour(new.Inizio);
				
				set H = hour(new.inizio);
			
				insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
                
                set finito = 1; 
			end;
		end if; 
        if new.coddisp in 	(						-- Condizionamento 
							select 	c.coddisp
                            from	condizionatore c
							) then 
                begin
					select	im.EUnitaria, im.Dissipamento, im.Temp, im.Tiniziale into ValConsumo, Diss, TempCondiz, TempInterna
                    from 	ImpCondiz im
                    where	im.coddisp =new.coddisp
                    and 	im.codr = new.codr;
					
					set ValConsumo = ValConsumo * abs(TempCondiz-TempInterna) + (Diss * ((time_to_sec(timediff(new.fine, new.inizio)))/3600));
			
					select	distinct last_value(FasciaOraria) over() into F
					from 	contatorebidirezionale
					where	RangeF <= hour(new.Inizio);
					
					set H = hour(new.inizio);
				
					insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
					
                    set finito = 1; 
				end; 
		end if; 
        if finito = 0 then 							-- Dispositivi Variabili al di fuori di Illuminazione e Condizinamento 
			begin	
				select	l1.CLVL into ValConsumo
				from 	livello l1
				where	l1.codr = new.codr
				and 	l1.coddisp = new.coddisp; 
				
				set ValConsumo = ValConsumo * ((time_to_sec(timediff(new.fine, new.inizio)))/3600);
				
				select	distinct last_value(FasciaOraria) over() into F
				from 	contatorebidirezionale
				where	RangeF <= hour(new.Inizio);
				
				set H = hour(new.inizio);
			
				insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
			end; 
		end if; 
    end if; 
    
    if tipoD = 'Interrompibile' then 
		begin 
			select	CMedio, Durata into ValConsumo, TempoD
            from 	programma	
            where 	codr = new.codr
            and 	coddisp = new.coddisp;
            
            set ValConsumo = ValConsumo * (TempoD/60); 
            			
			select	distinct last_value(FasciaOraria) over() into F
			from 	contatorebidirezionale
			where	RangeF <= hour(new.Inizio);
			
			set H = hour(new.inizio);
		
			insert into Consumo values (new.nomeutente, new.inizio, new.codr, new.coddisp, ValConsumo, F, H);
        end; 
	end if; 
end $$
delimiter ;
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------


#[5.2.3] Registrazione Consumo ImpCondiz---------------------------------------------------------------------------------------------------------------
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
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------



#[5.2.4] SINCRONIZZAZIONE LUCI----------------------------------------------------------------------------------------------------------
drop procedure if exists SincronizzazioneLuci; 
delimiter $$
create procedure SincronizzazioneLuci 	(
										in Luce integer, 
                                        in codreg integer, 
                                        in Utente varchar(40)
										)
begin 
	
    declare Disp integer default 0; 
    declare CSpecifico double default 0; 
    declare TempC double default 0; 
    declare Intense double default 0; 
    
    declare finito integer default 0; 
	declare LuciAccendere cursor for 
		select	i.coddisp, cspecifico
        from 	illuminazione i 
        where	i.posizione = 	(
								select	i1.posizione
                                from 	illuminazione i1
                                where	i1.coddisp = Luce
								); 
	declare continue handler for not found set finito = 1; 
    
    select	TempColore, Intensita into TempC, Intense
        from 	impluce	
        where	coddisp = Luce 
        and 	codr = codreg; 
    
    open LuciAccendere; 
    preleva : loop 
		fetch	LuciAccendere into Disp, CSpecifico; 
		
        update 	illuminazione 
        set 	accesa = 'ON'
        where	coddisp = Disp;
        
        update 	impluce 
        set 	tempcolore = TempC, intensita = Intense
        where	coddisp = Disp
        and 	codr = 1; 
		
		insert into Interazione values (Utente, current_time, Disp, codr, NULL, 'NO'); 
        
	end loop; 
    
end $$
delimiter ; 
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------







#[5.2.5]RIEPILOGO PRODUZIONE & CONSUMO--------------------------------------------------------------------------------------------------------------------------

drop event if exists RiepilogoPandC;
delimiter $$
create event RiepilogoPandC on schedule every 8 hour starts '2021-01-01 05:00:00' do -- il riepilogo viene fatto alla fine di ogni fascia oraria
begin 
	
	declare Prod double default 0; 
    declare Cons double default 0; 
    declare OraSuperiore integer default 0; 
    declare OraInferiore integer default 0; 
		
    select	RangeF into OraSuperiore
    from 	(
			select	distinct last_value(FasciaOraria) over() as FasciaOraria
			from 	contatorebidirezionale 
			where	rangeF <= hour(current_time)
			)as D natural join contatorebidirezionale;
    
    select 	RangeF into OraInferiore
	from	(
            select	distinct last_value(FasciaOraria) over() as FasciaOraria
			from 	contatorebidirezionale 
			where	RangeF < OraSuperiore
			)as D natural join contatorebidirezionale;
	
    if OraInferiore > 0 then 
		begin													-- per le fasce Orarie F2-F3
			select	sum(energia) into Prod
            from 	pannellifotovoltaici 
            where	hour(istante) >= OraInferiore
            and 	hour(istante) < OraSuperiore
            and 	day(istante) = day(current_date); 
            
            select	sum(energiaConsumata) into Cons
            from 	consumo 
            where	hour(inizio) >= OraInferiore
            and 	hour(inizio) < OraSuperiore
            and 	day(inizio) = day(current_date); 
            
            update 	contatoreBidirezionale 
            set 	produzione = prod
            where 	rangeF = OraInferiore;
            
            update 	contatoreBidirezionale 
            set 	consumo = cons
            where 	rangeF = OraInferiore;
        end;
	else 
		begin 													-- per la fasce Oraria F1
			select	distinct last_value(rangeF) over() into OraInferiore
            from 	contatorebidirezionale; 
            
            select	sum(energia) into Prod
            from 	pannellifotovoltaici 
            where	hour(istante) >= OraInferiore
            and 	hour(istante) < OraSuperiore
            and 	(
					day(istante) = day(current_date) 
                    or day(istante) = day(subdate(current_date, 1))
                    );
			
            select	sum(energiaConsumata) into Prod
            from 	consumo  
            where	hour(inizio) >= OraInferiore
            and 	hour(inizio) < OraSuperiore
            and 	(
					day(inizio) = day(current_date) 
                    or day(inizio) = day(subdate(current_date, 1))
                    );
			
            update 	contatoreBidirezionale 
            set 	produzione = prod, consumo = cons 
            where 	rangeF = OraInferiore;
            
            
		end; 
	end if; 
			
end $$
delimiter ; 
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------




#[5.2.6]ENERGIA IN RISERVA------------------------------------------------------------------------------------------------------------------------
drop event if exists AccumuloBatteria; 
delimiter $$ 
create event AccumuloBatteria on schedule every 8 hour starts '2021-01-01 05:00:00' do 
begin 
	
    declare Fascia varchar(3) default ''; 
    declare Prod double default null; 
    
    select 	 FasciaOraria,RiepilogoP into Fascia,Prod
    from 	contatorebidirezionale 
    where	Preferenza = 'Riserva'
			and hour(now())=RangeF-8; -- si registra la fascia oraria precedente (perchè si stocca alla fine di ogni fascia oraria) 
    
    
    if(prod is not null) then -- prod vale null quando la query precedente è vuota (la fascia oraria analizzata non era destinata alla riserva)
	insert into Batteria values (current_date, fascia, prod); 
	end if;
    
end $$
delimiter ; 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------






#[5.2.7]VERIFICA di un 'ACCESSO' in una Stanza ---------------------------------------------------------------------------------------------

drop procedure if exists segnalazione; -- proietta un messaggio
delimiter $$
create procedure segnalazione(in _Stanza integer,in _Accesso integer ,in _Orario timestamp)
begin
select 'Intrusione rilevata in' as Messaggio, _Stanza as Stanza, _Accesso as Accesso, _Orario as Orario;
end $$
delimiter ;


drop trigger if exists VerificaIntrusione_ControlloAccessi; 
delimiter $$
create trigger VerificaIntrusione_ControlloAccessi
before insert on controlloAccessi for each row 
begin 
	
    if (Persona= 'Intruso') then 
    call segnalazione(new.CodSt, new.CodA,new.Entrata); 
    end if; 
    
end $$
delimiter ; 


#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------




#[5.2.8]CREAZIONE SUGGERIMENTO-------------------------------------------------------------------------------------------------------------------
-- è anche l'analytic 2

drop event if exists CreazioneSuggerimento; 
delimiter $$
create event CreazioneSuggerimento on schedule every 1 day starts '2021-01-01 23:00:00' do 
begin 
    
    declare H integer default 0; 
    declare Resp varchar(4) default ''; 
    declare HDispHot integer default 0;
    declare DispHot integer default 0; 
    declare CodRegHot integer default 0; 
    
    declare Sugg varchar(255) default '';
    declare OraConsigliata integer default 0; 
    declare DataConsigliata timestamp default '0000-00-00 00:00:00'; 
    
    declare UscitaWhile integer default 0; 
    declare Ranking integer default 0; 
    declare OraFreq integer default 0; 
    
	declare nSugg integer default 3; 
    declare nRank integer default 0;
    
    declare finito integer default 0; 
	declare OreProduttive cursor for													#Classifica delle Ore più Produttive degli Ultimi 3 Giorni
		select 	hour(Ora) as Ora, RankingProduzione
		from 	(        
				select	*, rank() over(order by MediaProduzioneOraria desc) as RankingProduzione 
				from 	(
						select	istante as Ora, avg(energia) as MediaProduzioneOraria
						from 	pannellifotovoltaici 
                        where	day(istante) between (day(subdate(/*current_date()*/'2021-11-04', 3))) and day(/*current_date()*/'2021-11-04')
						and		month(istante) between month(subdate(/*current_date()*/'2021-11-04', 3)) and month(/*current_date()*/'2021-11-04')	
						group 	by hour(istante)
						) as D
				where	MediaProduzioneOraria <> 0
				) as D1;
    declare continue handler for not found set finito = 1; 
    
    set sql_safe_updates = 0;
    delete from Suggerimento;
    
    replace 	into HotTable 																																						#Creazione HotTable (Ore con Prod>Cons = 'Cold' & Ore con Prod<Cons 'Hot'); I Dati considerati sono quelli degli Ultimi 3 Giorni 
		select	hour(inizio) as Ora, if(avg(energiaconsumata) < avg(energia), "COLD", "HOT") as Responso 
		from 	consumo c
				inner join pannellifotovoltaici p on hour(p.istante) = hour(c.inizio)
		where	day(inizio) between (day(subdate('2021-11-04' /*current_date()*/, 3))) and day('2021-11-04' /*current_date()*/)
		and		month(inizio) between month(subdate('2021-11-04' /*current_date()*/, 3)) and month('2021-11-04' /*current_date()*/)
		and		timediff(inizio, istante) > 0
		and 	timediff(inizio, istante) <= '00:15:00'
		group	by hour(inizio), hour(istante);
		
    while uscitawhile = 0 do
		
        begin 
			select 	distinct first_value(D.coddisp) over(), 
					first_value(D.codr) over(), 
					first_value(rankingorder) over() into DispHot, CodRegHot, Ranking																								#Identificazione del Dispositivo che ha Consumato di più mediamente negli ultimi 3 giorni
			from	(
					select 	c.coddisp, c.codr, rank() over (order by avg(energiaConsumata) desc) as RankingOrder 
					from	consumo c
					where	day(c.inizio) between (day(subdate('2021-11-04' /*current_date()*/, 3))) and day('2021-11-04' /*current_date()*/)
					and		month(c.inizio) between month(subdate('2021-11-04' /*current_date()*/, 3)) and month('2021-11-04' /*current_date()*/)
					group 	by c.coddisp
					) as D
			where 	rankingorder > Ranking; 
			-- select 	DispHot, Ranking; 

			select 	distinct first_value(Ora) over() into OraFreq
			from 	(
					select 	coddisp, 
							hour(inizio) as Ora, 
							count(*) as VolteUsatoinQuestOra, 
							avg(energiaconsumata) as MedioConsumo, 
							rank() over(order by count(*) desc) as RankingUsage, 
							rank() over(order by avg(energiaconsumata) desc) as RankingEn
					from 	consumo c
					where	coddisp = DispHot
                    and		day(c.inizio) between (day(subdate('2021-11-04' /*current_date()*/, 3))) and day('2021-11-04' /*current_date()*/)
					and		month(c.inizio) between month(subdate('2021-11-04' /*current_date()*/, 3)) and month('2021-11-04' /*current_date()*/) 	
					group 	by hour(inizio)
					) as D	
			where 	RankingUsage = 1
			and 	RankingEn = 1; 
			-- select	OraFreq;

			if 	OraFreq not in		(																#Se l'Ora in cui è stato utilizzato il Dispositivo più Dispendioso NON si trova nelle Ore 'Cold' (Prod>Cons)
									select	ora
									from 	hottable 
									where	responso = 'COLD'
									) 	then 
				set UscitaWhile = 1; 
			end if; 
		end; 
        
	end while;         
        
        begin																																									#Si Creano un MAX di 3 Suggerimenti per il solito Disp e Regolazione nelle Ore più Produttive degli ultimi 3 giorni 
			open OreProduttive; 
			preleva : loop 
				fetch OreProduttive into OraConsigliata, nRank;
				
				if finito = 1 then 
					leave preleva; 
				end if; 
		
				if nSugg = 0 then 
					leave preleva; 
				end if; 
                
				if  OraConsigliata not in	(																																	#Sempre Verificando che l'Ora più Produttiva coincida con una delle Ore 'Cold' 
											select	Ora	
											from	hottable
											where	responso = 'COLD'
											) then 
												iterate preleva; 
				else 
					set nSugg = nSugg - 1; 
                    
                    select timestamp(current_date(), sec_to_time(OraConsigliata*3600)) into DataConsigliata;
                    
					if nRank = 1 then 
						set Sugg = concat('Suggerimento : E`*Fortemente* Consigliato di Usare il Dispositivo ', DispHot, ' alle Ore ', OraConsigliata, ' di Domani'); 
                    else
						set Sugg = concat('Suggerimento : E`Anche Consigliato di Usare il Dispositivo ', DispHot, ' alle Ore ', OraConsigliata, ' di Domani'); 
                    end if; 
					
                    set DataConsigliata = adddate(DataConsigliata, 1);
                    replace into Suggerimento values (OraConsigliata, DispHot, Sugg, 'NO', 'Gestore', DataConsigliata, CodRegHot);
				end if; 
                
			end loop;
            close OreProduttive; 
		end; 

	select 	*
    from 	Suggerimento;

end $$
delimiter ; 
 
 
 
 
 