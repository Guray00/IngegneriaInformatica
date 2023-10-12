use SmartBuildings_CT;

-- -----------------------------------------------------
-- Trigger 1 (par 5.2.1.2) - Vincolo di tupla su data_acquisto di Materiale
-- -----------------------------------------------------

drop trigger if exists chk_Materiale_data_acquisto;
delimiter $$
create trigger chk_Materiale_data_acquisto
before insert on Materiale
for each row
begin

	if (new.data_acquisto > now() ) then
		signal sqlstate '45000'
		set message_text='Data inserita non valida: non si possono registrare materiali non ancora acquistati' ;
	end if;    

end $$
delimiter ;


-- -----------------------------------------------------
-- Trigger 2 (par 5.2.1.2) - Vincolo di tupla su data_presentazione di Progetto
-- -----------------------------------------------------

drop trigger if exists chk_Progetto_data_presentazione;
delimiter $$
create trigger chk_Progetto_data_presentazione
before insert on Progetto
for each row
begin

	if (new.data_presentazione > CURRENT_DATE ) then
		signal sqlstate '45000'
		set message_text='Data inserita non valida: non si possono registrare progetti non ancora presentati' ;
	end if;    

end $$
delimiter ;






