use SmartBuildings_CT;

-- -----------------------------------------------------
-- Operazione 1 (par. 4.2.1) - InserimentoMisura
-- -----------------------------------------------------
-- -------- id sensore, valore x, valore y, valore z
call InserimentoMisura(10001, 10, 10, 10, 
						null) ; -- < -- inserimento corretto

call InserimentoMisura(10001, 10, 10, 10, 
						timestamp(current_date()) + interval 10 hour) ; -- < -- inserimento corretto

call InserimentoMisura(10001, 10, 10, 10, 
						timestamp(current_date()) + interval 10 hour) ; -- < -- inserimento duplicato

call InserimentoMisura(0, 10, 10, 10, 
						null) ; -- < -- inserimento di un sensore che non esiste

select count(*) from Misura;
select count(*) from Alert;

-- -----------------------------------------------------
-- Operazione 2 (par. 4.2.2) - InserimentoTurnoOperaio
-- -----------------------------------------------------
-- -------- id lavoro, id risorsa, data inizio, ore di lavoro
call InserimentoTurnoOperaio(100001, 'SGLWPD11E46Z733B', 
								timestamp(current_date()) + interval 9 hour, 2) ;  -- < -- inserimento corretto

call InserimentoTurnoOperaio(100001, 'SGLWPD11E46Z733B', 
								timestamp(current_date()) + interval 9 hour, 2) ; -- < -- inserimento dello stesso turno precedente

call InserimentoTurnoOperaio(100001, 'SGLWPD11E46Z733B', 
								timestamp(current_date()) + interval 10 hour, 2) ;  -- < -- inserimento di un turno che si sovrappone al precedente

call InserimentoTurnoOperaio(100001, 'SGLWPD11E46Z733B', 
								timestamp(current_date()) + interval 11 hour, 1) ;  -- < -- inserimento corretto

call InserimentoTurnoOperaio(100001, 'SGLWPD11E46Z733B', 
								timestamp(current_date()) + interval 10 hour + interval 59 minute, 1) ; -- < -- inserimento di un turno che si sovrappone al precedente

call InserimentoTurnoOperaio(100001, 'SGLWPD11E46Z733B', 
								timestamp(current_date()) + interval 12 hour , 1) ; -- < -- inserimento di un turno che non ha il supervisore disponibile

call InserimentoTurnoOperaio(100001, 'SGLWPD11E46Z733B', 
								timestamp(current_date()) + interval 8 hour , 0.015) ; -- < -- inserimento di un turno con durata inferiore al minuto

call InserimentoTurnoOperaio(100001, 'FMLZLZ15R07A383F', 
								timestamp(current_date()) + interval 8 hour, 1) ; -- < -- inserimento corretto

call InserimentoTurnoOperaio(100001, 'DNRSBL41R41C294A', 
								timestamp(current_date()) + interval 8 hour, 1) ; -- < -- inserimento che supera le max_operai del supervisore

call InserimentoTurnoOperaio(100001, 'SGLWPD11E46Z733B', 
								timestamp(current_date()) + interval 8 hour, 1) ; -- < -- inserimento corretto

call InserimentoTurnoOperaio(100001, 'MNHJVU74M05D950N', 
								timestamp(current_date()) + interval 8 hour, 1) ; -- < -- inserimento corretto

call InserimentoTurnoOperaio(100001, 'ZJRKHY85B42B757I', 
								timestamp(current_date()) + interval 8 hour, 1) ; -- < -- inserimento che supera il numero di risorse che può lavorare contemporaneamente

select l.id_supervisore, 
		l.max_operai as max_operai_lavoro,
        s.max_operai as max_operai_supervisore
from Lavoro l inner join Supervisore s on s.id_risorsa=l.id_supervisore
where l.id_lavoro = 100001 ; -- > -- valori limite di max_operai da rispettare

select * from ImpiegoSupervisore
where id_risorsa = 'XZSJKL04D46F088S' 
and date(dataora) = current_date() ; -- > -- turni del supervisore nel giorno

select distinct id_risorsa from ImpiegoOperaio 
where id_lavoro = 100001 
and date(dataora)=current_date() ; -- > -- risorse distinte che partecipano al lavoro nel giorno

select * from ImpiegoOperaio 
where id_lavoro = 100001 and date(dataora)=current_date()
order by dataora ; -- > -- turni delle risorse che partecipano al lavoro nel giorno

-- -----------------------------------------------------
-- Operazione 3 (par. 4.2.3) - InstallazioneSensore
-- -----------------------------------------------------
-- -------- id vano, tipo sensore, valore soglia, 
-- -------- x, y, z
call InstallazioneSensore(	101, 'ACCELEROMETRO', 1, 
							2, 1, 0) ; -- <-- inserimento corretto

call InstallazioneSensore(	101, 'ACCELEROMETRO', 1, 
							5, 1, 0) ; -- <-- inserimento fuori dal vano

call InstallazioneSensore(	101, 'ACCELEROMETRO', 1, 
							3, 0, 1.7 ) ; -- < -- inserimento su un muro di un sensore di tipo ACCELEROMETRO

call InstallazioneSensore(	101, 'ESTENSIMETRO', 10, 
							3, 0, 1.7) ; -- < -- inserimento corretto

call InstallazioneSensore(	101, 'ESTENSIMETRO', 10, 
							3, 0, 1.7) ; -- < -- inserimento di un sensore della stessa tipologia nella stessa posizione

call InstallazioneSensore(	101, 'TEMPERATURA', null, 
							3, 0, 1.7) ; -- < -- inserimento corretto

call InstallazioneSensore(	101, 'SCONOSCIUTO', 10, 
							2, 1, 0) ; -- < -- inserimento di un tipo di sensore non conosciuto

select * from Sensore where id_vano=101 and id_sensore>10100 ; -- > -- check sensori inseriti
select * from Vano where id_vano=101 ; -- > -- caratteristiche del vano
select * from Muro where 
id_muro in (select id_muro from Perimetro 
			where id_vano=101) ;-- > -- coordinate dei muri del vano

-- -----------------------------------------------------
-- Operazione 4 (par. 4.2.4) - CostoSAL
-- -----------------------------------------------------
-- -------- id sal da stampare
call update_costo_sal() ;
select CostoSAL(10001) ; 

call InserimentoTurnoOperaio(100001, 'SGLWPD11E46Z733B', 
								timestamp(current_date()) + interval 32 hour, 1) ;
                                
select * from Operaio where id_risorsa='SGLWPD11E46Z733B';

call update_costo_sal() ;
select CostoSAL(10001) ;

-- -----------------------------------------------------
-- Operazione 5 (par. 4.2.5) - InserimentoAltroMateriale
-- -----------------------------------------------------
-- -------- _codice_lotto, _fornitore, _nome_materiale, _data_acquisto, 
-- -------- _costo_unitario, _unita_misura, _peso_medio, _disegno,
-- -------- _tipo_materiale, _spessore, _larghezza, _lunghezza
call InserimentoAltroMateriale(	10101010, 'Mapei', 'guaina tetto', now(),
								120, 'MQ', 1.2, 'nessuno', 
                                'guaina bituminosa', 0.03, 1, 1) ; -- < -- inserimento corretto

call InserimentoAltroMateriale(	9999999, 'Mapei', 'guaina tetto', now(),
								120, 'NO', 1.2, 'nessuno', 
                                'guaina bituminosa', 0.03, 1, 1) ; -- < -- inserimento con unità di misura sbagliata

call InserimentoAltroMateriale(	9999999, 'Mapei', 'guaina tetto', now(),
								120, 'MQ', -10, 'nessuno', 
                                'guaina bituminosa', 0.03, 1, 1) ; -- < -- inserimento con peso minore di 0

select * from Materiale 
where codice_lotto in (10101010, 9999999) ; -- < -- controllo che gli inserimenti precedenti non siano andati a buon fine

-- -----------------------------------------------------
-- Operazione 6 (par. 4.2.6) - ListaProgettiInCorso
-- -----------------------------------------------------
-- --------  null
call ListaProgettiInCorso() ;

-- -----------------------------------------------------
-- Operazione 7 (par. 4.2.7) - Impegno2SettimaneOperaio
-- -----------------------------------------------------
-- --------  id risorsa (operaio)
call Impegno2SettimaneOperaio('SNXYYP64C07D438G') ;

select * from ImpiegoOperaio where id_risorsa='SNXYYP64C07D438G' ; -- controllo risultato

-- -----------------------------------------------------
-- Operazione 8 (par. 4.2.8) - DatiEdificio
-- -----------------------------------------------------
-- --------  id edificio
call DatiEdificio(20) ;

-- -----------------------------------------------------
-- ---- (par. 7) - AREA ANALYTICS ---------------------
-- -----------------------------------------------------
call stato_edifici() ;

call consigli_intervento_edificio(20);

/*
select table_name, rows_inserted-rows_deleted as num
from sys.schema_table_statistics
where table_schema = 'smartbuildings_ct' ;

set profiling=1;
call stato_edifici() ;
show profiles;
*/
