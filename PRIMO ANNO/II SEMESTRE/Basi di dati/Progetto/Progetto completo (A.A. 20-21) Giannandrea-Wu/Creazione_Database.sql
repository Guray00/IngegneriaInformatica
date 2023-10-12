# SET FOREIGN_KEY_CHECKS = 0;
drop database if exists Smarthome;
create database Smarthome;
use Smarthome;

create table Abitante ( 
    CodFiscale varchar(16) primary key,  
    Nome varchar(50) not null, 
    Cognome varchar(50) not null, 
    DataNascita date not null, 
    Telefono varchar(10) 
)engine = InnoDB default charset = latin1; 

create table DomandaSicurezza ( 
    IDDomanda int auto_increment primary key, 
    Domanda varchar(50) not null 
)engine = InnoDB default charset = latin1; 

create table Account ( 
    Username varchar (50) primary key,  
    Hash varchar(50) not null, 
    Salt varchar(50) not null, 
    DataIscrizione date not null, 
    Domanda int  not null,  
    Risposta varchar(50) not null,  
    foreign key (Domanda) references DomandaSicurezza(IDDomanda) 
)engine = InnoDB default charset = latin1; 

CREATE TABLE DocumentoIdentita ( 
	Tipologia VARCHAR(50), 
    Numero	int, 
    EnteRilascio VARCHAR(50) NOT NULL, 
    Scadenza DATE NOT NULL,  
    Account varchar(50) not null, 
    CodFiscale varchar(16) not null, 
    primary key(Tipologia, Numero), 
    foreign key (Account) references Account(Username), 
    foreign key (CodFiscale) references Abitante(CodFiscale) 
)ENGINE = InnoDB DEFAULT CHARSET = latin1; 

create table Stanza ( 
    IDStanza int auto_increment primary key, 
    Nome varchar(50) not null, 
    Lunghezza double not null, 
    Larghezza double not null, 
    Altezza double not null, 
    Piano tinyint not null, 
	LivelloEfficienza double not null,
    LivelloDispersione double not null
)engine = InnoDB default charset = latin1; 

create table Porta ( 
    IDPorta int auto_increment primary key, 
    Stanza1 int not null, 
    Stanza2 int, 
    PuntoCardinale varchar(2)  check (PuntoCardinale in ('N', 'NE', 'NW', 'S', 'SE', 'SW', 'E', 'W')),  
    foreign key (Stanza1) references Stanza(IDStanza), 
    foreign key (Stanza2) references Stanza(IDStanza) 
)engine = InnoDB default charset = latin1; 

create table Finestra ( 
    IDFinestra int auto_increment primary key, 
    Stanza int not null, 
    PuntoCardinale varchar(2) check (PuntoCardinale in ('N', 'NE', 'NW', 'S', 'SE', 'SW', 'E', 'W')), 
    foreign key (Stanza) references Stanza(IDStanza) 
)engine = InnoDB default charset = latin1; 

create table Dispositivo (
    IDDispositivo INT AUTO_INCREMENT PRIMARY KEY,
    Nome varchar(50) not null,
    Stato tinyint not null check (Stato in (0 , 1)),
    Tipo enum('fisso', 'variabile') not null,
    Potenza double
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table SmartPlug (
    IDPlug INT AUTO_INCREMENT PRIMARY KEY,
    Stato tinyint not null check (Stato in (0 , 1)),
    Dispositivo int not null,
    foreign key (Dispositivo)
        references Dispositivo (IDDispositivo)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Potenza (
    IDPotenza INT AUTO_INCREMENT PRIMARY KEY,
    Dispositivo int not null,
    Consumo double not null,
    Livello tinyint not null,
    foreign key (Dispositivo)
        references Dispositivo (IDDispositivo)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Programma (
    IDProgramma INT AUTO_INCREMENT PRIMARY KEY,
    Dispositivo int not null,
    Durata int not null,
    Potenza double not null,
    foreign key (Dispositivo)
        references Dispositivo (IDDispositivo)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Caratteristica (
    Nome varchar(50),
    Valore varchar(50),
    Programma int,
    primary key (Nome , Valore , Programma),
    foreign key (Programma)
        references Programma (IDProgramma)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Interazione (
    Dispositivo int,
    Inizio timestamp,
    Fine timestamp,
    Consumo double,
    Account varchar(50) not null,
    Potenza int,
    Programma int,
    primary key (Dispositivo , Inizio),
    foreign key (Dispositivo)
        references Dispositivo (IDDispositivo),
    foreign key (Account)
        references Account (Username),
    foreign key (Potenza)
        references Potenza (IDPotenza),
    foreign key (Programma)
        references Programma (IDProgramma)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table RegistroTemperatura (
    Timestamp timestamp not null primary key,
    temperaturaEsterna double not null
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Stato (
    Stanza int,
    Timestamp timestamp,
    temperaturaInterna double not null,
    primary key (Stanza , Timestamp),
    foreign key (Stanza)
        references Stanza (IDStanza),
    foreign key (Timestamp)
        references RegistroTemperatura (Timestamp)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Condizionatore (
    IDCondizionatore int auto_increment primary key,
    Stanza int not null,
    Classe varchar(5) not null,
    PotenzaMedia double not null,
    foreign key (Stanza)
        references Stanza (IDStanza)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Condizionamento (
    Condizionatore int,
    Inizio timestamp,
    Account varchar(50) not null,
    Temperatura double check (Temperatura between 16 and 30),
    Umidita double,
    Fine timestamp,
    Consumo double,
    primary key (Condizionatore , Inizio),
    foreign key (Condizionatore)
        references Condizionatore (IDCondizionatore),
    foreign key (Account)
        references Account (Username)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table RicorrenzaGiorno (
    Condizionatore int,
    Inizio timestamp,
    Giorno tinyint check (Giorno between 1 and 7),
    primary key (Condizionatore , Inizio , Giorno),
    foreign key (Condizionatore , Inizio)
        references Condizionamento (Condizionatore , Inizio)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table RicorrenzaMese (
    Condizionatore int,
    Inizio timestamp,
    Mese tinyint check (Mese between 1 and 12),
    primary key (Condizionatore , Inizio , Mese),
    foreign key (Condizionatore , Inizio)
        references Condizionamento (Condizionatore , Inizio)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table ElementoIlluminazione (
    IDLuce int auto_increment primary key,
    Stato tinyint not null,
    check (Stato in (0 , 1)),
    Nome varchar(50) not null,
    Stanza int not null,
    foreign key (Stanza)
        references Stanza (IDStanza)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;


create table TemperaturaColore (
    Luce int,
    Valore double,
    primary key (Luce , Valore),
    foreign key (Luce)
        references ElementoIlluminazione (IDLuce)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Intensita (
    Luce int,
    Livello tinyint,
    Potenza double not null,
    primary key (Luce , Livello),
    foreign key (Luce)
        references ElementoIlluminazione (IDLuce)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Illuminazione (
    Luce int,
    Inizio timestamp,
    Fine timestamp,
    TemperaturaColore double,
    Intensita tinyint,
    Consumo double,
    Account varchar(50) not null,
    primary key (Luce , Inizio),
    foreign key (Account)
        references Account (Username),
    foreign key (Luce , TemperaturaColore)
        references TemperaturaColore (Luce , Valore),
    foreign key (Luce , Intensita)
        references Intensita (Luce , Livello)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Suggerimento (
    IDSuggerimento int auto_increment primary key,
    Inizio timestamp not null,
    Account varchar(50),
    Scelta tinyint check (Scelta in (0, 1)),
    Programma int not null,
    foreign key (Account)
        references Account (Username),
    foreign key (Programma)
        references Programma (IDProgramma)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;


create table PannelloFotovoltaico (
    IDPannello int auto_increment primary key,
    Superficie double not null,
    Rendimento double not null
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table FasciaOraria( 
	IDFascia int auto_increment primary key,
    Nome varchar(10) not null,
	Inizio time not null, 
    Fine time not null, 
    SceltaConsumo tinyint not null, 
    Costo double not null 
)  ENGINE=InnoDB DEFAULT CHARSET=latin1; 

create table EnergiaProdotta (
    Timestamp timestamp,
    Pannello int,
    Quantita double not null,
    Irraggiamento int not null,
    Fascia int not null,
    primary key (Timestamp , Pannello),
    foreign key (Pannello)
        references PannelloFotovoltaico (IDPannello),
    foreign key (Fascia)
        references FasciaOraria (IDFascia)
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

create table Batteria( 
	IDBatteria int auto_increment primary key, 
	Capacita double not null,
    EnergiaRimanente double default 0
)  ENGINE=InnoDB DEFAULT CHARSET=latin1; 

create table Stoccaggio ( 
    Timestamp timestamp, 
    Pannello int, 
    Batteria int,
    primary key (Timestamp , Pannello , Batteria), 
    foreign key (Timestamp , Pannello) 
        references EnergiaProdotta (Timestamp , Pannello), 
    foreign key (Batteria) 
        references Batteria (IDBatteria) 
)  ENGINE=InnoDB DEFAULT CHARSET=latin1; 

create table RegistroFlusso( 
	Timestamp timestamp primary key, 
    Immissione double not null default (RAND()), 
    Prelevamento double not null default (RAND()), 
    Fascia int, 
    foreign key(Fascia) references FasciaOraria(IDFascia) 
)  ENGINE=InnoDB DEFAULT CHARSET=latin1; 


-- ---------------------------------------------------------------------------
# il trigger seguente permette di inserire il consumo ogni qualvolta venga 
# aggiornata una row di Interazione con la relativa fine dell'Interazione.
drop trigger if exists aggiorna_consumo;
DELIMITER $$
create trigger aggiorna_consumo
before update on Interazione
for each row
begin
	declare _potenza double default 0;
	declare minuti double default 0;
    
    if new.Fine is not null then
		set minuti=(timestampdiff(MINUTE,new.Inizio,new.Fine));
        case
			when new.Potenza is not null then 
				set _potenza=(	select P.Consumo
								from Potenza P
								where P.IDPotenza=new.Potenza);
			when new.Programma is not null then
				set _potenza=(	select P.Potenza
								from Programma P
								where P.IDProgramma=new.Programma);       
			else set _potenza=(	select Potenza 
								from Dispositivo 
								where IDDispositivo=new.Dispositivo);
		end case;
		
		set new.Consumo = (minuti*60*_potenza) / (3.6*1000);
    end if;
end $$
DELIMITER ;

# il trigger seguente permette di inserire il consumo ogni qualvolta venga inserita una row in Interazione
# dove l'attributo Fine ha un valore diverso dal valore nullo.
drop trigger if exists calcola_consumo;
DELIMITER $$
create trigger calcola_consumo
before insert on Interazione
for each row
begin
	declare _potenza double default 0;
	declare minuti double default 0;
    
    if new.Fine is not null then
		set minuti=(timestampdiff(MINUTE,new.Inizio,new.Fine));
        case
			when new.Potenza is not null then 
				set _potenza=(	select P.Consumo
								from Potenza P
								where P.IDPotenza=new.Potenza);
			when new.Programma is not null then
				set _potenza=(	select P.Potenza
								from Programma P
								where P.IDProgramma=new.Programma);       
			else set _potenza=(	select Potenza 
								from Dispositivo 
								where IDDispositivo=new.Dispositivo);
		end case;
		
		set new.Consumo = (minuti*60*_potenza) / (3.6*1000); #il risultato è in kWh
    end if;
end $$
DELIMITER ;

-- --------------------------------------------------------------------------
# Il trigger seguente ha la funzione di controllare che i dati inseriti siano coerenti.
# Analizza le interazioni che si vogliono inserire nel database, controllando che la potenza o il programma appartenga
# realmente a quel dispositivo. Nel caso di un dispositivo a consumo fisso, esso non può avere regolazioni di nessun tipo.
drop trigger if exists controllo_interazioni;
DELIMITER $$
create trigger controllo_interazioni
before insert on Interazione
for each row
begin
	
	if not exists ( select 1 from Dispositivo 
					where IDDispositivo = new.Dispositivo) then
		signal sqlstate '45000' 
        set message_text = 'Dispositivo inesistente';
	end if;
    
	if new.Potenza is not null or new.Programma is not null then
		if 'fisso' = (	select Tipo from Dispositivo 
						where IDDispositivo = new.Dispositivo) then
			signal sqlstate '45000' 
            set message_text = 'Il Dispositivo è fisso, non possiede regolazioni o programmi!';
		end if;
        
        if (new.Potenza is not null and 
			new.Potenza not in (select P.IDPotenza from Potenza P
								where P.Dispositivo = new.Dispositivo) 
			)
			or 
            (new.Programma is not null and 
			new.Programma not in (select P.IDProgramma from Programma P
									 where P.Dispositivo=new.Dispositivo)  
			)     
			then
				signal sqlstate '45000' 
                set message_text = 'Inserimento fallito!';
		end if;
    end if;
end $$
DELIMITER ;

-- -------------------------------------------------------------------------
#il trigger permette di inserire il consumo relativo all'intensità coinvolta
drop trigger if exists controllo_luci;
DELIMITER $$
create trigger controllo_luci
before insert on Illuminazione
for each row
begin
	if new.Fine is not null then
		set new.Consumo=(select I.Potenza from Intensita I
						 where I.Luce = new.Luce and I.Livello = new.Intensita)
                         *
                         timestampdiff(minute,new.Inizio,new.Fine) *60 /(3.6*1000);
		
        set new.Consumo=truncate(new.Consumo,5);              
	end if;
end $$
DELIMITER ;

-- ------------------------------------------------------------------------------
drop trigger if exists InsertConsumoCondizionamento;
drop trigger if exists UpdateConsumoCondizionamento;

delimiter ;;
create trigger InsertConsumoCondizionamento
before insert on Condizionamento for each row
begin
	if new.Fine is not null then
		set new.Consumo = calcolaConsumoCondizionamento(new.Condizionatore, new.Inizio, new.Fine, new.Temperatura);
    end if;
end;;

create trigger UpdateConsumoCondizionamento
before update on Condizionamento for each row
begin
	if new.Fine is not null then
		set new.Consumo = calcolaConsumoCondizionamento(new.Condizionatore, new.Inizio, new.Fine, new.Temperatura);
    end if;
end;;
delimiter ; 

# La funzione calcola approssitivamente il consumo del Condizionamento, usando i dati delle temperature.
# Il processo è iterativo, scorre dall'inizio fino alla fine del condizionamento.
# il risultato è in kWh
drop function if exists calcolaConsumoCondizionamento;
delimiter ;;
create function calcolaConsumoCondizionamento (condizionatore int, inizio timestamp, fine timestamp, temp_obiettivo double)
returns double deterministic 
# in verità sarebbe not deterministic poiché dipende dai dati delle tabelle di Temperatura interna ed esterna,
# che potrebbero variare. In questo caso si assume che non varino
begin 
    if not exists ( select 1 from Condizionatore where IDCondizionatore = condizionatore) then
		# signal sqlstate '45000' set message_text = 'Condizionatore inesistente';
        return null; 
	end if;
    
	begin
		declare _stanza int;
		declare efficienza double default 0;
		declare dispersione double default 0;
		declare temp_int double default 0;		-- temperatura interna ed esterna
		declare temp_ext double default 0;	
        declare result double default 0;
        
        -- variabili di utilità
		declare scan_time timestamp default inizio;
		declare scan_step int default 10; 	-- minore è lo step, maggiore è la precisione del calcolo
        declare time_range int default 0;
        declare time_range2 int default 0;
		

		set _stanza = (select Stanza from Condizionatore where IDCondizionatore = condizionatore);
		select LivelloEfficienza, LivelloDispersione from Stanza where IDStanza = _stanza
			into efficienza, dispersione;
		
		scan: loop
			if scan_time >= fine then leave scan; end if;
			
            -- Recupero la distanza dalla rilevazione più vicina e se supera 60 minuti, viene lanciato l'errore / ritornato null
            set time_range = (select min(abs(timestampdiff(minute, Timestamp, scan_time))) from RegistroTemperatura);
            set time_range2 = (select min(abs(timestampdiff(minute, Timestamp, scan_time))) from Stato where Stanza = _stanza);
            
            if time_range > 30 then 
				# signal sqlstate '45000' set message_text = 'Rilevazioni di temperatura esterna troppo distanti';
                return null;
            elseif time_range2 > 30 then 
				# signal sqlstate '45000' set message_text = 'Rilevazioni di temperatura della stanza troppo distanti'; 
                return null;
			end if;
            
            -- Recupero le rilevazioni di temperatura più vicine
            set temp_ext = (select temperaturaEsterna from RegistroTemperatura 
							where abs(timestampdiff(minute, Timestamp, scan_time)) = time_range
                            order by Timestamp limit 1);  
			set temp_int = (select TemperaturaInterna from Stato 
							where abs(timestampdiff(minute, Timestamp, scan_time)) = time_range2 and Stanza = _stanza
                            order by Timestamp limit 1);
            
			if temp_int != temp_obiettivo then
				 set result = result + abs(temp_int - temp_ext) * efficienza * scan_step *60;
			else set result = result + abs(temp_int - temp_ext) * dispersione * scan_step *60;
			end if;
            
			set scan_time = scan_time + interval scan_step minute;
		end loop;
		return result / 3600000;
	end;
end;;
delimiter ;

-- ----------------------------------------------------------------------------------
-- il trigger inserisce la fascia oraria corrispondente al timestamp per ogni insert di energia prodotta.
drop trigger if exists fascia_idonea;
DELIMITER $$
create trigger fascia_idonea
before insert on EnergiaProdotta
for each row
begin
	set new.Fascia = 
		(select IDFascia 
		 from FasciaOraria
		 where time(new.Timestamp) between Inizio and Fine);
end $$
DELIMITER ;


-- il trigger inserisce la fascia oraria corrispondente al timestamp per ogni insert di RegistroFlusso.
drop trigger if exists fascia_idonea2;
DELIMITER $$
create trigger fascia_idonea2
before insert on RegistroFlusso
for each row
begin
	set new.Fascia = 
		(select IDFascia 
		 from FasciaOraria
		 where time(new.Timestamp) between Inizio and Fine);
end $$
DELIMITER ;


-- ------------------------------------------------------------------------------------
-- il trigger permette di aggiornare il valore di 'energiaAttuale' nella tabella Batteria ogni qualvolta venga inserito una nuova riga in stoccaggio.
drop trigger if exists aggiorna_batteria;
DELIMITER $$
create trigger aggiorna_batteria
after insert on Stoccaggio
for each row
begin
	declare energia_inserita double default 0;
	set energia_inserita=(select EP.Quantita
						  from EnergiaProdotta EP
						  where EP.Pannello=new.Pannello and EP.Timestamp=new.Timestamp);
	
	update Batteria
	set EnergiaRimanente = least(EnergiaRimanente + energia_inserita, Capacita)
	where IDBatteria=new.Batteria;
    
end $$
DELIMITER ;

