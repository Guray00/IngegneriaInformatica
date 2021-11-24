set @tempo='2021-08-31 12:59';

drop procedure if exists analytics_2;
DELIMITER $$
create procedure analytics_2()
begin
	declare consumo_dispositivi double default 0;
	declare consumo_condizionamento double default 0;
	declare consumo_illuminazione double default 0;
	declare consumo_totale double default 0;
    
	declare potenza_pannello double default 0;
	declare ultimo_irraggiamento integer default 0;
	declare irraggiamento_previsto double default 0;
    
	declare programma_da_attivare integer default 0;
	declare consumo_programma double default 0;
    declare durata_programma integer default 0;
	declare energia_disponibile double default 0;
	declare energia_mancante double default 0;
	declare energia_batteria double default 0;

	# Calcolo le potenza totale richiesta dai Dispositivi accesi
	with Interazioni_attive as (
		select * from Interazione 
        where @tempo between Inizio and ifnull(Fine,now())
	),
	consumi_attivi as (
		select 	pt.Consumo as ConsumoPotenza,
				pg.Potenza as ConsumoProgramma,
				d.Potenza  as ConsumoFisso
		from Interazioni_attive i
		left outer join Potenza pt on Potenza = IDPotenza
		left outer join Programma pg on Programma = IDProgramma
		left outer join Dispositivo d on i.Dispositivo = IDDispositivo
	)
	select ifnull(sum(ConsumoPotenza),0) + ifnull(sum(ConsumoProgramma),0) + ifnull(sum(ConsumoFisso),0) 
	from consumi_attivi
    into consumo_dispositivi;

	#Potenza totale richiesta dai Condizionatori accesi
    select sum(PotenzaMedia) into consumo_condizionamento
	from Condizionamento 
			inner join Condizionatore on Condizionatore = IDCondizionatore
	where @tempo between Inizio and ifnull(Fine,now());
	
    #Potenza totale richiesta dalle Luci accese
	select sum(it.Potenza) into consumo_illuminazione
    from Illuminazione i
			inner join Intensita it on (i.Intensita = it.Livello and i.Luce = it.Luce)
    where @tempo between Inizio and ifnull(Fine,now());
     
	
    set consumo_totale = ifnull(consumo_dispositivi,0) + 
						 ifnull(consumo_condizionamento,0) + 
                         ifnull(consumo_illuminazione,0);
	 			
    select  avg(Irraggiamento), avg(Irraggiamento*PF.Superficie*PF.Rendimento) as potenza -- per semplicità il nostro database ha delle rilevazioni ogni ora
    from EnergiaProdotta EP
			inner join
			PannelloFotovoltaico PF on EP.Pannello=IDPannello
    where Timestamp <= @tempo and Timestamp = (select max(Timestamp)
											  from EnergiaProdotta
											  where Timestamp <= @tempo)
	into ultimo_irraggiamento, potenza_pannello;
    set potenza_pannello = potenza_pannello/1000;
    
	 with giorni_target as (
		select 	day(EP.Timestamp) as giorno, 
				time(EP.Timestamp) as ora, 
				EP.Irraggiamento , 
				(	
					select ep2.Irraggiamento between ultimo_irraggiamento - 50 and ultimo_irraggiamento + 50
					from EnergiaProdotta ep2
					where hour(@tempo) = hour(ep2.Timestamp) and EP.Timestamp = ep2.Timestamp
				) as giorno_simile
					   
		from EnergiaProdotta EP
		where EP.Timestamp >= @tempo - interval 1 month 
			and hour(EP.Timestamp) between hour(@tempo) and hour(@tempo) + 2
	), 
	media_giorni_simili as (
		select Giorno, avg(Irraggiamento) as media_3_ore
		from giorni_target
		group by giorno
		having sum(giorno_simile) is true
	)
		select avg(media_3_ore) into irraggiamento_previsto
		from media_giorni_simili;								  

	/*
	select 	irraggiamento_previsto,
			ultimo_irraggiamento,
            potenza_pannello,
            consumo_totale,
            consumo_dispositivi,
            consumo_condizionamento,
            consumo_illuminazione; */            

	if irraggiamento_previsto >= ultimo_irraggiamento and potenza_pannello > consumo_totale then
		# ho la possibilità di anticipare l'accensione di un dispositivo quindi invio un suggerimento sull'app,
		# in quanto il livello di irraggiamento mi permette di fronteggiare il nuovo consumo
		 
		set energia_disponibile = (potenza_pannello - consumo_totale);
																															  
		# trovo il programma che si 'avvicina' di piu' al valore di energia disponibile
		select P.IDProgramma,P.Potenza, P.Durata
		into programma_da_attivare,consumo_programma, durata_programma
		from Programma P
		order by abs(P.Potenza-energia_disponibile)
		limit 1;
		 
		if  energia_disponibile>=consumo_programma then -- invio il suggerimento sull'app tranquillamente,
														 --  se maggiore il resto dell'energia verrà venduta
			insert into Suggerimento (Inizio,Programma)
			values (@tempo,programma_da_attivare); 
		end if;

		if consumo_programma > energia_disponibile then -- controllo in batteria se ho energia sufficiente per l'accensione del dispositivo con quel programma
			set energia_mancante = (consumo_programma - energia_disponibile) * durata_programma*60 / 3600;
			set energia_batteria =  (select EnergiaRimanente from batteria);
			
			if energia_batteria > energia_mancante then -- in batteria ho il rimanente per fronteggiare il consumo del programma da attivare, 
														-- posso inviare il suggerimento tranquillamente
				insert into Suggerimento (Inizio,Programma)
				values (@tempo,programma_da_attivare);
			end if;
		end if;
	end if;
 
end $$
DELIMITER ;
