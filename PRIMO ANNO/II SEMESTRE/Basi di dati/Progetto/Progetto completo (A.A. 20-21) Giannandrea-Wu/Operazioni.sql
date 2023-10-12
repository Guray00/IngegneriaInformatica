use Smarthome;

# OPERAZIONE 1

# vedere i dispositivi accesi
drop procedure if exists dispositivi_accesi;
delimiter $$
create procedure dispositivi_accesi()
begin
	select IDDispositivo,Nome
	from Dispositivo
	where Stato='1';
end $$
delimiter ;

-- call dispositivi_accesi();

-- -----------------------------------------------------------

# OPERAZIONE 2

#  Calcolo consumo di una impostazione dispositivo
drop procedure if exists consumo_dispositivo;
delimiter $$
create procedure consumo_dispositivo(in _inizio timestamp, in _dispositivo int, out consumo_ double)
begin
	set consumo_ = (select Consumo 
					from Interazione
					where Inizio=_inizio and Dispositivo=_dispositivo);
end $$
delimiter ;

/*call consumo_dispositivo('2021-08-05 18:19','1',@result);
select @result;*/


-- -----------------------------------------------------------

# OPERAZIONE 3
# Ottenere il consumo di una impostazione relativa al condizionamento
drop procedure if exists consumo_condizionamento;
delimiter $$
create procedure consumo_condizionamento(in _condizionatore int , in _inizio timestamp, out consumo_ double)
begin
	set consumo_ = (select Consumo 
					from Condizionamento
					where Inizio=_inizio and Condizionatore=_condizionatore);
end $$
delimiter ;

/*call consumo_condizionamento("1","2021-10-28 19",@result);
select @result;*/ #consumo in kwh

-- -----------------------------------------------------------

# OPERAZIONE 4
# Vedere l'impostazione più frequente di un dispositivo
# In caso di pari merito, viene mostrato uno casuale.
drop procedure if exists impostazione_frequente;
delimiter $$
create procedure impostazione_frequente(in _dispositivo int , out potenza_ int, out programma_ int)
begin
	select Potenza into potenza_
    from Interazione 
    where Potenza is not null and Dispositivo = _dispositivo
    group by Potenza
    having count(*) >= all (select count(*)
							from Interazione 
							where Potenza is not null and Dispositivo = _dispositivo
							group by Potenza)
	limit 1;
    
    select Programma into programma_
    from Interazione 
    where Programma is not null and Dispositivo = _dispositivo
    group by Programma
    having count(*) >= all (select count(*)
							from Interazione 
							where Programma is not null and Dispositivo = _dispositivo
							group by Programma)
    limit 1;
end $$
delimiter ;

/*call impostazione_frequente("6",@potenza,@programma);
select @potenza,@programma;*/

-- -----------------------------------------------------------

# OPERAZIONE 5

# inserimento della produzione dei pannelli fotovoltaici
drop procedure if exists inserimento_energia;
delimiter $$
create procedure inserimento_energia(in _pannello int , in _tempo timestamp,in _energia double,in _irraggiamento int)
begin
	/* -- non serve perché c'è già il trigger
    declare _fascia int;
    
	set _fascia = (	select IDFascia
					from FasciaOraria
					where _tempo between Inizio and Fine);
	*/
	insert into EnergiaProdotta(Timestamp,Pannello,Quantita,Irraggiamento)
		values (_tempo,_pannello,_energia,_irraggiamento);
end $$
delimiter ;

# call inserimento_energia(1,now(),0.98,600);

-- -----------------------------------------------------------

# OPERAZIONE 6

# energia consumata nell'ultima settimana
# ipotizziamo che venga invocata al giorno 2021-08-29
drop procedure if exists energia_settimana;
delimiter $$
create procedure energia_settimana(in _data date, out energia double)
begin
	declare consumo double default 0;
    
	set energia = 0;
    
    #consumo relativo alle interazioni dei dispositivi
	set consumo = ( select sum(I.Consumo)
					from Interazione I
					where I.Inizio between _data - interval 7 day and _data
						and I.Consumo is not null ); 
	
    set energia = energia + ifnull(consumo,0);
	
    #conusmo relativo alle interazioni di condizionamento
	set consumo = (	select sum(C.Consumo) 
					from Condizionamento C
					where C.Inizio between _data - interval 7 day and _data
						and C.Consumo is not null); 
	
    set energia = energia + ifnull(consumo,0);

	#conusmo relativo alle interazioni delle luci
	set consumo = (	select sum(I.Consumo) as ConsumoTotale
					from Illuminazione I
					where I.Inizio between _data - interval 7 day and _data 
						and I.Consumo is not null); 
	
    set energia = energia + ifnull(consumo,0);

end $$
delimiter ;

 /*
call energia_settimana('2021-08-29',@consumo);
select @consumo; -- */

-- -----------------------------------------------------------

# OPERAZIONE 7

#inserimento in registro flusso
drop procedure if exists inserimento_flusso;
delimiter $$
create procedure inserimento_flusso (in _tempo timestamp , in _immissione double, in _prelevamento double)
begin
	/* -- non serve perché c'è già il trigger
    declare _fascia int;
	set _fascia= (   select IDFascia
					 from FasciaOraria
					 where _tempo between Inizio and Fine); */

	insert into RegistroFlusso(Timestamp,Immissione,Prelevamento)
		values (_tempo,_immissione,_prelevamento);
end $$
delimiter ;

# call inserimento_flusso(now(),0.010,0.040);

-- -----------------------------------------------------------

# OPERAZIONE 8

# Classifica uso energia da parte degli utenti nell'ulitmo mese,
# ipotizziamo che vanga invocata al 2021-08-29
drop procedure if exists classifica_mensile;
delimiter $$
create procedure classifica_mensile( in _data date)
begin

	select D.Account, sum(D.consumoTotale) as consumoTOT
	from (
		select I.Account, sum(I.Consumo) as consumoTotale
		from Interazione I
		where I.Inizio between _data - interval 1 month and _data 
			and I.Consumo is not null
		group by I.Account

		union all

		select C.Account, sum(C.Consumo) as consumoTotale
		from Condizionamento C
		where C.Inizio between _data - interval 1 month and _data 
			and C.Consumo is not null
		group by C.Account

		union all

		select I.Account, sum(I.Consumo) as consumoTotale
		from Illuminazione I
		where I.Inizio between _data - interval 1 month and _data 
			and I.Consumo is not null
		group by I.Account 
        
        ) as D
	group by D.Account
	order by consumoTOT DESC;

end $$
delimiter ;


# call classifica_mensile('2021-08-29');


