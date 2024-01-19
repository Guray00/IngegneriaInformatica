-- Progetto Basi di Dati A.A. 22-23 -- Federico Nardi-- Lorenzo Melani
-- Script per le 8 operazioni mySQL

USE FilmSphere;

-- ----------------------------------------------------
-- Analytics 1: Bilanciamento del carico                        
-- -----------------------------------------------------
-- procedura bilanciamento

drop procedure if exists bilanciamento ()
delimiter $$ 
create procedure bilanciamento ()
begin 
declare serverdestinazione int  default 0;
declare server_target int; -- id server da liberare
declare banda_d int ; -- banda disponibile
declare banda_tot int; -- banda totale
declare banda_liberare int; -- banda da liberare
declare cont int; -- contatore 
declare temp int; 
declare id_er int;
declare id_f int;
declare finito int default 0;

declare cursore1 cursor for
select f.BitrateTotale, e.IDErogazione, f.IDFile
from Erogazione e inner join File f on e.File=f.IDFile
where e.Server=server_target and e.OraFine is NULL;

declare cursore cursor for
select IDServer, BandaDisponibile, Banda
from Server
where (BandaDisponibile/ Banda <= 0.2);
declare continue handler for not found set finito = 1;

select IDServer into serverdestinazione
from Server
where BandaDisponibile/Banda=(
    select max(BandaDisponibile/Banda)
    from Server);

open cursore;
scan : loop
    set cont = 0;
	fetch cursore into server_target, banda_d, banda_tot;
	if finito  
	then leave scan;
	end if;

    open cursore1;
    scan1 : loop
            fetch cursore1 into temp, id_er, id_f;
            set cont=cont+temp;

            if (select count(*) from Presenza p where p.Server=serverdestinazione and p.File=id_f)=0
            then insert into Presenza(Server, File) values (serverdestinazione, id_f);
            end if; 

            update Server
            set BandaDisponibile=BandaDisponibile+temp
            where IDServer=server_target;

            update Server
            set BandaDisponibile=BandaDisponibile-temp
            where IDServer=serverdestinazione;

            update Erogazione
            set Server=serverdestinazione
            where IDErogazione=id_er;

            if cont>=banda_d - 0.2 * banda_tot
            then leave scan1;
            end if;
    end loop;
end loop ;
end $$

-- ----------------------------------------------------
-- Analytics 2: Classifiche
-- ----------------------------------------------------
drop procedure if exists classifiche;

delimiter $$
create procedure classifiche()
begin 
select film.titolo as film, u.abbonamento, f.formatovideo as formatovideo, f.formatoaudio as formatoaudio, count(*) as visualizzazioni
from Erogazione e inner join File f on f.IDFile = e.file 
inner join Connessione c on e.ipconnessione = c.ip and e.dispositivo = c.dispositivo 
inner join Dispositivo d on c.dispositivo= d.IDdispositivo
inner join Utente u on d.utente = u.codice
inner join Film on f.film = Film.id
group by u.abbonamento, f.film, f.formatovideo, f.formatoaudio
order by u.abbonamento, visualizzazioni desc;

end $$

-- ----------------------------------------------------
-- Operazione 1: Nuova_connessione
-- ----------------------------------------------------
drop procedure if exists nuova_connessione;

delimiter $$
create procedure nuova_connessione( in _dispositivo int, in _ip bigint, in _inizioconn datetime, in _fineconn datetime, out stato_ bool)
begin
declare temp int;
set temp = (select count(*) from connessione c where c.orainizio = _inizioconn and c.dispositivo = _dispositivo);
if temp = 1 then set stato_ = false;
else INSERT INTO Connessione(OraInizio, Dispositivo, IP, OraFine)
            VALUES (_inizioconn, _dispositivo, _ip, _fineconn);
	set stato_ = true;
end if;

end $$
delimiter $$;
-- -----------------------------------------------------
-- Operazione 2: Fine_Erogazione
-- -----------------------------------------------------
drop procedure if exists fine_erogazione;
delimiter $$
create procedure fine_erogazione(in _iderogazione int, out check_ bool)
begin   
declare controllo datetime;
declare bitrate int;
declare serv int;
select BitrateTotale, e.Server into bitrate, serv
from Erogazione e inner join File f on e.File= f.IDFile 
where e.IDErogazione= _iderogazione ;
set controllo =(select orafine from Erogazione e where e.IDErogazione = _iderogazione);
if controllo is null then update Erogazione set orafine= current_time where IDErogazione = _iderogazione; 
update Server set BandaDisponibile = BandaDisponibile-bitrate where IDServer = serv;
	set check_= true;
else 
	set check_= false;
end if;
end $$
delimiter $$;

-- ----------------------------------------------------
-- Operazione 3: Registrazione_Utente
-- -----------------------------------------------------
drop procedure if exists registrazione_utente;
delimiter $$
create procedure registrazione_utente (in _codice int, in _nome varchar(50), in _cognome varchar(50), in _password varchar(20), in _email varchar(100), in _abbonamento varchar(100) ,out check_ bool)
begin   
declare temp int;
set temp = (select codice from Utente where codice = _codice); 
if temp =1 then set check_ = false;
else  INSERT INTO Utente(Codice,Nome, Cognome,Password,Email,Abbonamento)
            VALUES (_codice, _nome, _cognome , _password , _email , _abbonamento);
	set check_ = true;
end if;
end $$
delimiter $$;

-- ----------------------------------------------------
-- Operazione 4: Emissione_nuova_fattura
-- -----------------------------------------------------
drop procedure if exists emissione_nuova_fattura;
delimiter $$
create procedure emissione_nuova_fattura (in _idfattura int, in _intestatario int, in _importo double ,out check_ bool)
begin   
declare temp int;
set temp = (select IDFattura from Fattura where IDFattura = _idfattura);
if temp = 1 then set check_ = false;
else INSERT INTO Fattura (IDFattura, DataEmissione,Scadenza, Intestatario,  Importo, CartaPagamento)
            VALUES ( _idfattura , current_date(), current_date()+interval 14 day, _importo, null);
	set check_ = true;
    end if;
end $$
delimiter $$;
-- ----------------------------------------------------
-- Operazione 5: Pagamento_fattura
-- -----------------------------------------------------
drop procedure if exists pagamento_fattura;
delimiter $$
create procedure pagamento_fattura (in _idfattura int, in _cartapagamento bigint, out check_ bool)
begin   
declare temp bigint;
set temp = (select CartaPagamento from Fattura where IDFattura = _idfattura);
if temp  is not null then set check_ = false;
else update Fattura set CartaPagamento = _cartapagamento where  IDFattura = _idfattura;
	set check_ = true;
    end if;
end $$
delimiter $$;
-- ----------------------------------------------------
-- Operazione 6a: stampa_premi_attore 
-- -----------------------------------------------------
drop procedure if exists stampa_premi_attore;
delimiter $$
create procedure stampa_premi_attore (in _attore int)
begin   
select a.Nome as Nome, a.Cognome as Cognome, p.Nome as Lista_Premi 
from PremiazioneAttore pa INNER JOIN Attore a ON pa.attore = a.IDAttore INNER JOIN Premio p ON pa.Premio = p.IDPremio
where Attore = _attore ;
end $$
delimiter $$;
-- call stampa_premi_attore (5);

-- ----------------------------------------------------
-- Operazione 6b: Stampa_premi_regista
-- -----------------------------------------------------
drop procedure if exists stampa_premi_regista;
delimiter $$
create procedure stampa_premi_regista (in _regista int)
begin   
select r.Nome as Nome, r.Cognome as Cognome, p.Nome as Lista_Premi 
from PremiazioneRegista pr INNER JOIN Regista r ON pr.Regista = r.IDRegista INNER JOIN Premio p ON pr.Premio = p.IDPremio
where Regista = _regista ;
end $$
delimiter $$;
-- call stampa_premi_regista(2);
-- ----------------------------------------------------
-- Operazione 6c: Stampa_premi_film
-- -----------------------------------------------------
drop procedure if exists stampa_premi_film;
delimiter $$
create procedure stampa_premi_film (in _film int)
begin   
select f.Titolo as Titolo, p.Nome as Lista_Premi 
from PremiazioneFilm pf INNER JOIN Film f ON pf.Film = f.ID INNER JOIN Premio p ON pf.Premio = p.IDPremio
where ID = _film;
end $$
delimiter $$;
-- call stampa_premi_film(6);
