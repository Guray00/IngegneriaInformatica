# CREAZIONE di un'INTERAZIONE ------------------------------------------------------------------------------------------------------------------

drop procedure if exists CreazioneInterazione; 
delimiter $$
create procedure CreazioneInterazione 	(
										in Utente varchar(50), 
										in TempI timestamp, 
                                        in TempF timestamp, 
                                        in CodD integer, 
                                        in Reg integer
                                        )
begin 
		
	declare I timestamp default '0000-00-00 00:00:00'; 
    declare F timestamp default '0000-00-00 00:00:00'; 
    
    declare Dur integer default 0; 
	
	if TempI is NULL then 								# Interazione : *SPEGNIMENTO DIFFERITA o NO*
		begin 
        
			select 	Inizio, Fine into I,F 																								#[1]
            from 	(
					select 	coddisp, last_value(Inizio) over () as Inizio, last_value(Fine) over() as Fine
					from 	(
							select	coddisp, Inizio, Fine 
							from 	interazione i 
							where 	i.coddisp = codD 
							and 	i.codr = reg 
							and 	(day(inizio) = day(current_date()) and day(fine) = day(current_date())) 
							order 	by Inizio, Fine 
							) as D 
					) as D1 
			group 	by coddisp; 
			
            if I <> '0000-00-00 00:00:00' and codD in 	(																				#[2]					
														select 	distinct CodDisp 
														from 	programma 
														) then 
				begin 																				
					if F > current_timestamp() then  																						#[2.1]
						update 	interazione i 
						set 	i.Fine = TempF
						where	codDisp = CodDisp
						and 	CodR = Reg
						and 	Inizio = I;
					else 
						signal sqlstate '45000' set message_text = 'Inserimento Invalido : Il Dispositivo con Programma è già Spento'; 		
					end if;
                end; 
            end if; 
            
            if I <> '0000-00-00 00:00:00' and F = '0000-00-00 00:00:00' then 															#[3]	
				begin 
					update 	interazione i
					set 	i.Fine = TempF
					where	i.CodDisp = codD
					and 	i.CodR = reg
					and 	i.Inizio = I;
				end; 
			else 
				signal sqlstate '45000' set message_text = 'Inserimento Invalido : Il Dispositivo è già Spento'; 							
			end if; 
            
        end; 
    end if; 
    #-----------------------------------------------------------------------------------------------------------------------------------------------
    if TempF is NULL then 									# Interazione : ACCENSIONE o CAMBIO REGOLAZINE DIFFERITA o NO
		begin
        
			select 	Inizio, Fine, codr into I,F, @CodReg 			#[1]
            from 	(
					select 	coddisp, codr, last_value(Inizio) over () as Inizio, last_value(Fine) over() as Fine
					from 	(
							select	coddisp,codr, Inizio, Fine 
							from 	interazione i
							where 	i.coddisp = 9 -- codD
							and 	(day(inizio) = day('2021-11-03'/*current_date()*/) and day(fine) = day('2021-11-03'/*current_date()*/))
							order 	by Inizio, Fine
							) as D
					) as D1
			group 	by coddisp; 
			
			if I = '0000-00-00 00:00:00' or (I <> '0000-00-00 00:00:00' and F <> '0000-00-00 00:00:00') then 						#[2]
				begin 
					if codD in (																										#[2.1]
							   select 	distinct coddisp 
							   from 	programma	
							   ) then 
						begin 
							select	durata	into Dur 
                            from 	programma 
                            where	coddisp = CodD 
                            and 	codr = reg;
							
                            set TempF = timestampadd(minute, Dur, TempI);																
                
                            if TempI = Current_time() then 								 	# Se il Tempo d'Inizio Inserito è lo stesso di quello Corrente, allora NON è Differita (Differita = 'NO')
								insert into interazione values (Utente, TempI, TempF, CodD, Reg, 'NO'); 
							else 						 									# Altrimenti è Differita (Differita = 'SI')
								insert into interazione values (Utente, TempI, TempF, CodD, Reg, 'SI'); 
							end if; 
                        end; 
					else 
							if TempI = Current_time() then  								# Se il Tempo d'Inizio Inserito è lo stesso di quello Corrente, allora NON è Differita (Differita = 'NO')
								insert into interazione values (Utente, TempI, NULL, CodD, Reg, 'NO'); 
							else 	 														# Altrimenti è Differita (Differita = 'SI')
								insert into interazione values (Utente, TempI, NULL, CodD, Reg, 'SI'); 
							end if; 
					end if; 
				end; 
			else 
				signal sqlstate '45000' set message_text = 'Inserimento Invalido : Il Dispositivo è già Acceso'; 						#[2.3]
			end if; 
            
            if (I <> '0000-00-00 00:00:00' and F = '0000-00-00 00:00:00' and @CodReg <> Reg) then 									#[3]
				begin
					
                    if TempI = Current_time() then  								# Se il Tempo d'Inizio Inserito è lo stesso di quello Corrente, allora NON è Differita (Differita = 'NO')
						insert into interazione values (Utente, TempI, NULL, CodD, Reg, 'NO'); 
					else 	 														# Altrimenti è Differita (Differita = 'SI')
						insert into interazione values (Utente, TempI, NULL, CodD, Reg, 'SI'); 
					end if; 
                    
                end; 
			end if; 
            
        end; 
    end if; 
    #-----------------------------------------------------------------------------------------------------------------------------------------------
    if TempI is NOT NULL and TempF is NOT NULL then 		-- Interazione : ACCENSIONE PROGRAMMATA 
		begin 
			select 	Inizio, Fine into I,F 																							#[1]
            from 	( 	
					select 	coddisp, last_value(Inizio) over () as Inizio, last_value(Fine) over() as Fine 
					from 	( 
							select	coddisp, Inizio, Fine 
							from 	interazione i 
							where 	i.coddisp = codD 
							and 	i.codr = reg 
							and 	(day(inizio) = day(current_date()) and day(fine) = day(current_date())) 
							order 	by Inizio, Fine 
							) as D 
					) as D1 
			group 	by coddisp; 
					
			if I = '0000-00-00 00:00:00' or  I < TempI then 																		#[2]
				begin 
					if codD in (																										#[2.1]
							   select 	distinct coddisp 
							   from 	programma	
							   ) then 
						begin 
							select	durata	into Dur 
                            from 	programma 
                            where	coddisp = CodD 
                            and 	codr = reg;
							
                            set TempF = timestampadd(minute, Dur, TempI);
							insert into interazione values (Utente, TempI, TempF, CodD, Reg, 'SI'); 					
                        end; 
					else 
						insert into interazione values (Utente, TempI, TempF, CodD, Reg, 'SI'); 
					end if; 
				end; 
			else 
				signal sqlstate '45000' set message_text = 'Inserimento Invalido : Il Dispositivo è già Attivo o Programmato'; 			
			end if; 
            
		end; 
	end if; 

end $$ 
delimiter ; 
#-----------------------------------------------------------------------------------------------------------------------------------------------------




#RIEPILOGO SMART PLUG : mostra i dati di consumo di una smartplug fino a un certo istante---------------------------------------------

drop procedure if exists RiepilogoSmartPlug; 
delimiter $$ 
create procedure RiepilogoSmartPlug ( 
									in SP integer, 
									out SemiRiepilogo varchar(255) 
                                    ) 
begin 
	
    declare Disp integer default 0; 	
    declare Fascia varchar(3) default ''; 
    declare Consumo double default 0; 
    declare NomeDisp varchar(50) default ''; 
    
    select 	CodDisp into Disp 
    from 	SmartPlug 
    where	CodSp = SP; 
    
    select 	NomeDisp into NomeDisp 
    from 	Dispositivo 
    where	coddisp = Disp; 
    
    select	distinct last_value(FasciaOraria) over() into Fascia 
    from 	ContatoreBidirezionale 
    where	hour(current_time) >= RangeF; 
    
    select 	sum(energiaConsumata) into Consumo 
    from 	Consumo 
    where	coddisp = disp 
    and 	fasciaoraria = fascia 
    and 	day(inizio) = day(current_date); 
    
    set SemiRiepilogo = concat('Dalla SmartPlug ', SP, ' è stato Consumato ', Consumo, ' a cui vi è collegato il Dispostivo ', NomeDisp); 
	select SemiRiepilogo as MessaggioDiRiepilogoSmartPlug; 
    
end $$ 
delimiter ; 