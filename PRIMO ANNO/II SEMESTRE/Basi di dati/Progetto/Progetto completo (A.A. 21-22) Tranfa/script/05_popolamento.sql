use SmartBuildings_CT;
-- SET FOREIGN_KEY_CHECKS=0;

-- AREA GENERALE
-- truncate table Area;
INSERT INTO Area (id_area, nome_area)
VALUES 	(55033001, 'Carrara'),
		(55033002, 'Marina di Carrara'),
        (54045001, 'Pietrasanta'),
		(54045002, 'Marina di Pietrasanta')
;

-- truncate table Rischio;
INSERT INTO Rischio (id_area,rischio,dataora,coeff_rischio)
VALUES 	(54045002, 'SISMICO', now()-interval 2 year, rand()/100),
		(54045002, 'IDRAULICO', now()-interval 2 year, rand()/100),
		(55033002, 'SISMICO', now()-interval 2 year, rand()/100),
        (54045002, 'SISMICO', now()-interval 1 year, rand()/100),
		(54045002, 'IDRAULICO', now()-interval 6 month, rand()/100),
		(55033002, 'SISMICO', now()-interval 8 month, rand()/100),
        (54045001, 'SISMICO', now()-interval 2 year, rand()/100),
		(54045001, 'IDRAULICO', now()-interval 2 year, rand()/100),
		(55033001, 'SISMICO', now()-interval 2 year, rand()/100),
        (54045001, 'SISMICO', now()-interval 1 year, rand()/100),
		(54045001, 'IDRAULICO', now()-interval 6 month, rand()/100),
		(55033001, 'SISMICO', now()-interval 8 month, rand()/100)
;

-- truncate table Edificio;
INSERT INTO Edificio (id_edificio,tipo_edificio,id_area)
VALUES	(10, 'Villetta monofamiliare', 54045002 ),
		(20, 'Condominio', 55033002 ),
        (30, 'Villetta bifamiliare', 54045001 ),
        (40, 'Villetta trifamiliare', 55033001 )
;

-- truncate table Piano;
INSERT INTO Piano (id_edificio,piano)
VALUES 	(10, 0), (10, 1),
        (20, 0), (20, 1), (20, 2), (20, 3), (20, 4), (20, 5), (20, 6), (20, 7)
;

INSERT INTO Piano (id_edificio,piano)
select 30, piano from Piano where id_edificio = 20 and piano <= 2 
;

INSERT INTO Piano (id_edificio,piano)
select 40, piano from Piano where id_edificio = 20 and piano <= 3
;

-- truncate table Vano;
INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
VALUES 	(101, 10, 0, 'cucina', 5, 3, 3 ),
		(102, 10, 0, 'soggiorno', 3, 2, 3 ),
		(103, 10, 0, 'sala', 5, 3, 3 ),
        (104, 10, 0, 'bagno', 2, 2, 3 ),
        (111, 10, 1, 'camera', 5, 3, 3 ),
		(112, 10, 1, 'corridoio', 3, 2, 3 ),
		(113, 10, 1, 'camera', 5, 3, 3 ),
        (114, 10, 1, 'bagno', 2, 2, 3 ),
        (115, 10, 1, 'balcone', 2, 1, null )
;

INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
select id_vano + 100, 20, piano, funzione, lunghezza, larghezza, altezza
from Vano v where v.id_edificio=10 
;

INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
select id_vano + 110, 20, 2, funzione, lunghezza, larghezza, altezza
from Vano v where v.id_edificio=10 and v.piano=1 
;

INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
select id_vano + 120, 20, 3, funzione, lunghezza, larghezza, altezza
from Vano v where v.id_edificio=10 and v.piano=1 
;

INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
select id_vano + 130, 20, 4, funzione, lunghezza, larghezza, altezza
from Vano v where v.id_edificio=10 and v.piano=1 
;

INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
select id_vano + 140, 20, 5, funzione, lunghezza, larghezza, altezza
from Vano v where v.id_edificio=10 and v.piano=1 
;

INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
select id_vano + 150, 20, 6, funzione, lunghezza, larghezza, altezza
from Vano v where v.id_edificio=10 and v.piano=1 
;

INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
select id_vano + 160, 20, 7, funzione, lunghezza, larghezza, altezza
from Vano v where v.id_edificio=10 and v.piano=1 
;

INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
select v.id_vano + 100, v.id_edificio + 10, v.piano, v.funzione, v.lunghezza, v.larghezza, v.altezza
from Vano v where v.id_edificio = 20 and v.piano <= 2
;

INSERT INTO Vano (id_vano,id_edificio,piano,funzione,lunghezza,larghezza,altezza)
select v.id_vano + 200, v.id_edificio + 20, v.piano, v.funzione, v.lunghezza, v.larghezza, v.altezza
from Vano v where v.id_edificio = 20 and v.piano <= 3
;

-- truncate table Muro;
INSERT INTO Muro (id_muro,xi,yi,xf,yf)
VALUES	(1001, 0, 0, 3, 0), (1002, 3, 0, 3, 3), (1003, 3, 3, 3, 5), (1004, 3, 5, 0, 5), (1005, 0, 5, 0, 0), -- cucina pt
		(1011, 3, 0, 5, 0), (1012, 5, 0, 5, 3), (1013, 5, 3, 3, 3), -- soggiorno pt
        (1021, 5, 3, 5, 5), (1022, 5, 5, 3, 5), -- bagno pt
        (1031, 5, 0, 8, 0), (1032, 8, 0, 8, 5), (1033, 8, 5, 5, 5), -- salotto pt
		(1101, 0, 0, 3, 0), (1102, 3, 0, 3, 3), (1103, 3, 3, 3, 5), (1104, 3, 5, 0, 5), (1105, 0, 5, 0, 0), -- camera 1 p1
		(1111, 3, 0, 5, 0), (1112, 5, 0, 5, 3), (1113, 5, 3, 3, 3), -- camera 2 p1
        (1121, 5, 3, 5, 5), (1122, 5, 5, 3, 5), -- bagno p1
        (1131, 5, 0, 8, 0), (1132, 8, 0, 8, 5), (1133, 8, 5, 5, 5) -- corridoio p1
;

-- truncate table Perimetro;
INSERT INTO Perimetro (id_vano,id_muro)
VALUES 	(101, 1001), (101, 1002), (101, 1003), (101, 1004), (101, 1005),
		(102, 1002), (102, 1011), (102, 1012), (102, 1013),
        (103, 1012), (103, 1022), (103, 1031), (103, 1032), (103, 1033),
		(104, 1003), (104, 1013), (104, 1021), (104, 1022),
        (111, 1101), (111, 1102), (111, 1103), (111, 1104), (111, 1105),
		(112, 1102), (112, 1111), (112, 1112), (112, 1113),
        (113, 1112), (113, 1122), (113, 1131), (113, 1132), (113, 1133),
		(114, 1103), (114, 1113), (114, 1121), (114, 1122),
        (115, 1111)
;

INSERT INTO Muro (id_muro,xi,yi,xf,yf)
select m.id_muro+1000, xi, yi, xf, yf
from Muro m 
where m.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 ))
;

INSERT INTO Muro (id_muro,xi,yi,xf,yf)
select m.id_muro+1100, xi, yi, xf, yf
from Muro m 
where m.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1 ))
;

INSERT INTO Muro (id_muro,xi,yi,xf,yf)
select m.id_muro+1200, xi, yi, xf, yf
from Muro m 
where m.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1 ))
;

INSERT INTO Muro (id_muro,xi,yi,xf,yf)
select m.id_muro+1300, xi, yi, xf, yf
from Muro m 
where m.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1 ))
;

INSERT INTO Muro (id_muro,xi,yi,xf,yf)
select m.id_muro+1400, xi, yi, xf, yf
from Muro m 
where m.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1 ))
;

INSERT INTO Muro (id_muro,xi,yi,xf,yf)
select m.id_muro+1500, xi, yi, xf, yf
from Muro m 
where m.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1 ))
;

INSERT INTO Muro (id_muro,xi,yi,xf,yf)
select m.id_muro+1600, xi, yi, xf, yf
from Muro m 
where m.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1 ))
;

INSERT INTO Perimetro (id_vano,id_muro)
select p.id_vano+100, p.id_muro+1000
from Perimetro p 
where p.id_vano in (select v.id_vano from Vano v where v.id_edificio=10) 
;

INSERT INTO Perimetro (id_vano,id_muro)
select p.id_vano+110, p.id_muro+1100
from Perimetro p 
where p.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1) 
;

INSERT INTO Perimetro (id_vano,id_muro)
select p.id_vano+120, p.id_muro+1200
from Perimetro p 
where p.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1) 
;

INSERT INTO Perimetro (id_vano,id_muro)
select p.id_vano+130, p.id_muro+1300
from Perimetro p 
where p.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1) 
;

INSERT INTO Perimetro (id_vano,id_muro)
select p.id_vano+140, p.id_muro+1400
from Perimetro p 
where p.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1) 
;

INSERT INTO Perimetro (id_vano,id_muro)
select p.id_vano+150, p.id_muro+1500
from Perimetro p 
where p.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1) 
;

INSERT INTO Perimetro (id_vano,id_muro)
select p.id_vano+160, p.id_muro+1600
from Perimetro p 
where p.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1) 
;

INSERT INTO Muro (id_muro,xi,yi,xf,yf)
select m.id_muro + 1000, xi, yi, xf, yf
from Muro m 
where m.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=20 and v.piano <= 2 ))
;

INSERT INTO Muro (id_muro,xi,yi,xf,yf)
select m.id_muro + 2000, xi, yi, xf, yf
from Muro m 
where m.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=20 and v.piano <= 3 ))
;

INSERT INTO Perimetro (id_vano,id_muro)
select p.id_vano + 100, p.id_muro + 1000
from Perimetro p 
where p.id_vano in (select v.id_vano from Vano v where v.id_edificio=20 and v.piano <= 2 )
;

INSERT INTO Perimetro (id_vano,id_muro)
select p.id_vano + 200, p.id_muro + 2000
from Perimetro p 
where p.id_vano in (select v.id_vano from Vano v where v.id_edificio=20 and v.piano <= 3 )
;


-- truncate table Apertura;
INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
VALUES	(1002, 1001, null, 0.9, 2.1, 1.5, 0), -- porta cucina
		(1011, 1002, 'S', 1.1, 2.1, 0.5, 0), -- porta ingresso
        (1013, 1003, null, 0.9, 2.1, 0.5, 0), -- porta bagno pt
        (1012, 1004, null, 0.9, 2.1, 1.5, 0), -- porta sala
        (1005, 1005, 'O', 1.6, 1.2, 2, 1.2), -- finestra cucina
        (1022, 1006, 'N', 0.6, 1.2, 0.5, 1.2), -- finestra bagno pt
        (1033, 1007, 'N', 1.6, 1.2, 0.5, 1.2), -- finestra 1 salotto
        (1032, 1008, 'E', 1.6, 1.2, 1.5, 1.2), -- finestra 2 salotto
        (1031, 1009, 'S', 1.6, 1.2, 0.5, 1.2), -- finestra 3 salotto
		(1102, 1101, null, 0.9, 2.1, 1.5, 0), -- porta camera 1
		(1111, 1102, 'S', 1.1, 2.1, 0.5, 0), -- portafinestra balcone
        (1113, 1103, null, 0.9, 2.1, 0.5, 0), -- porta bagno p1
        (1112, 1104, null, 0.9, 2.1, 1.5, 0), -- porta camera 2
        (1105, 1105, 'O', 1.6, 1.2, 2, 1.2), -- finestra cucina
        (1122, 1106, 'N', 0.6, 1.2, 0.5, 1.2), -- finestra bagno p1
        (1132, 1108, 'E', 1.6, 1.2, 1.5, 1.2), -- finestra 1 camera 2
        (1131, 1109, 'S', 1.6, 1.2, 0.5, 1.2) -- finestra 2 camera 2
;

INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
select id_muro+1000, n_apertura+1000, orientazione, larghezza, altezza, distanza_spigolo, altezza_terra
from Apertura a 
where a.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10))
;

INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
select id_muro+1100, n_apertura+1100, orientazione, larghezza, altezza, distanza_spigolo, altezza_terra
from Apertura a 
where a.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1))
;

INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
select id_muro+1200, n_apertura+1200, orientazione, larghezza, altezza, distanza_spigolo, altezza_terra
from Apertura a 
where a.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1))
;

INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
select id_muro+1300, n_apertura+1300, orientazione, larghezza, altezza, distanza_spigolo, altezza_terra
from Apertura a 
where a.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1))
;

INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
select id_muro+1400, n_apertura+1400, orientazione, larghezza, altezza, distanza_spigolo, altezza_terra
from Apertura a 
where a.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1))
;

INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
select id_muro+1500, n_apertura+1500, orientazione, larghezza, altezza, distanza_spigolo, altezza_terra
from Apertura a 
where a.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1))
;

INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
select id_muro+1600, n_apertura+1600, orientazione, larghezza, altezza, distanza_spigolo, altezza_terra
from Apertura a 
where a.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1))
;

INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
select id_muro+1000, n_apertura+1000, orientazione, larghezza, altezza, distanza_spigolo, altezza_terra
from Apertura a 
where a.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=20 and v.piano <= 2))
;

INSERT INTO Apertura (id_muro,n_apertura,orientazione,larghezza,altezza,distanza_spigolo,altezza_terra)
select id_muro+2000, n_apertura+2000, orientazione, larghezza, altezza, distanza_spigolo, altezza_terra
from Apertura a 
where a.id_muro in (
	select p.id_muro from Perimetro p where p.id_vano in (
		select v.id_vano from Vano v where v.id_edificio=20 and v.piano <= 3))
;

-- AREA COSTRUZIONE

-- truncate table Operaio;
INSERT INTO Operaio (id_risorsa,costo_orario)
VALUES	('SNXYYP64C07D438G', 23.78 ),
		('MNHJVU74M05D950N', 18.32 ),
        ('ZJRKHY85B42B757I', 19.21 ),
        ('FMLZLZ15R07A383F', 26.30 ),
        ('DNRSBL41R41C294A', 18.60 ),
        ('MMHCNW66T02L124X', 16.15 ),
        ('SGLWPD11E46Z733B', 21.06 )
;

-- truncate table Supervisore;
INSERT INTO Supervisore (id_risorsa,max_operai,costo_orario)
VALUES	('XZSJKL04D46F088S', 5, 31.42), -- opere strutturali
		('RMBGWC60H07L613D', 3, 32.56), -- opere di rifinitura - rivestimenti e pavimentazioni
        ('DVKGYZ86B07B721R', 2, 29.12) -- opere impianti elettrico e idraulico
;

-- truncate table Progetto;
INSERT INTO Progetto (id_progetto,tipo_progetto,id_edificio,data_presentazione,data_approvazione,data_inizio,data_fine_stimata)
VALUES (1001, 'ristrutturazione', 10, 
		DATE(now() - interval 6 month + interval rand()*10 day), DATE(now() - interval 5 month + interval rand()*10 day), 
		DATE(now() - interval 3 month + interval rand()*10 day), DATE(now() + interval 6 month + interval rand()*10 day) 
        ),
		(3001, 'ristrutturazione', 30, 
		DATE(now() - interval 6 month + interval rand()*10 day), DATE(now() - interval 5 month + interval rand()*10 day), 
		DATE(now() - interval 3 month + interval rand()*10 day), DATE(now() + interval 6 month + interval rand()*10 day) 
        ),
		(4001, 'ristrutturazione', 40, 
		DATE(now() - interval 6 month + interval rand()*10 day), DATE(now() - interval 5 month + interval rand()*10 day), 
		DATE(now() - interval 3 month + interval rand()*10 day), DATE(now() + interval 6 month + interval rand()*10 day) 
        )
;

-- truncate table StatoAvanzamento;
INSERT INTO StatoAvanzamento (id_sal,data_inizio,data_fine_stimata,data_fine_effettiva,costo_sal,id_progetto)
VALUES	(10001, -- ristrutturazione piano terra
		DATE(now() - interval 1 month + interval rand()*10 day), 
		DATE(now() + interval 1 month + interval rand()*10 day), 
		null, 0, 1001),
		(10002, -- ristrutturazione piano 1
		DATE(now() + interval 2 month + interval rand()*10 day), 
		DATE(now() + interval 4 month + interval rand()*10 day), 
		null, 0, 1001),
		(10099, -- ristrutturazione tetto
		DATE(now() + interval 5 month + interval rand()*10 day), 
		DATE(now() + interval 8 month + interval rand()*10 day), 
		null, 0, 1001),
		(30001,
		DATE(now() - interval 6 month + interval rand()*10 day), 
		DATE(now() - interval 3 month + interval rand()*10 day), 
		null, 0, 3001),
		(30002,
		DATE(now() - interval 2 month + interval rand()*10 day), 
		DATE(now() + interval 1 month + interval rand()*10 day), 
		null, 0, 3001),
        (30003,
		DATE(now() + interval 2 month + interval rand()*10 day), 
		DATE(now() + interval 4 month + interval rand()*10 day), 
		null, 0, 3001),
		(30099,
		DATE(now() + interval 5 month + interval rand()*10 day), 
		DATE(now() + interval 8 month + interval rand()*10 day), 
		null, 0, 3001),
		(40001,
		DATE(now() - interval 6 month + interval rand()*10 day), 
		DATE(now() - interval 3 month + interval rand()*10 day), 
		null, 0, 4001),
		(40002,
		DATE(now() - interval 2 month + interval rand()*10 day), 
		DATE(now() + interval 1 month + interval rand()*10 day), 
		null, 0, 4001),
        (40003,
		DATE(now() + interval 2 month + interval rand()*10 day), 
		DATE(now() + interval 4 month + interval rand()*10 day), 
		null, 0, 4001),
        (40004,
		DATE(now() + interval 5 month + interval rand()*10 day), 
		DATE(now() + interval 7 month + interval rand()*10 day), 
		null, 0, 4001),
		(40099,
		DATE(now() + interval 8 month + interval rand()*10 day), 
		DATE(now() + interval 11 month + interval rand()*10 day), 
		null, 0, 4001)
;

-- truncate table Lavoro;
INSERT INTO Lavoro (id_lavoro, id_sal, tipo_lavoro, id_supervisore, max_operai)
VALUES	(100001, 10001, 'rinforzo struttuale solaio', 'XZSJKL04D46F088S', 4 ),
		(100002, 10001, 'installazione impianti bagno', 'DVKGYZ86B07B721R', 3 ),
        (100003, 10001, 'rinforzo muratura sala con intonaco armato', 'XZSJKL04D46F088S', 5 ),
        (100004, 10001, 'posa pavimenti e rivestimenti bagno', 'RMBGWC60H07L613D', 4 ),
        (100011, 10002, 'rinforzo struttuale solaio', 'XZSJKL04D46F088S', 4 ),
		(100012, 10002, 'installazione impianti bagno', 'DVKGYZ86B07B721R', 3 ),
        (100013, 10002, 'rinforzo muratura camera 1 con intonaco armato', 'XZSJKL04D46F088S', 5 ),
        (100014, 10002, 'posa pavimenti e rivestimenti bagno', 'RMBGWC60H07L613D', 4 ),
        (100091, 10099, 'rinforzo struttuale solaio - copertura', 'XZSJKL04D46F088S', 6 ),
        (100092, 10099, 'isolamento solaio - copertura', 'DVKGYZ86B07B721R', 3 ),
        (100093, 10099, 'rifinitura con tegole e coppi - copertura', 'RMBGWC60H07L613D', 6 )
;

INSERT INTO Lavoro (id_lavoro, id_sal, tipo_lavoro, id_supervisore, max_operai)
select id_lavoro+200000, id_sal+20000, tipo_lavoro, id_supervisore, max_operai
from Lavoro l where id_sal in (10001,10002,10099)
union
select id_lavoro+200010, id_sal+20001, tipo_lavoro, id_supervisore, max_operai
from Lavoro l where id_sal = 10002
;

INSERT INTO Lavoro (id_lavoro, id_sal, tipo_lavoro, id_supervisore, max_operai)
select id_lavoro+300000, id_sal+30000, tipo_lavoro, id_supervisore, max_operai
from Lavoro l where id_sal in (10001,10002,10099)
union
select id_lavoro+300010, id_sal+30001, tipo_lavoro, id_supervisore, max_operai
from Lavoro l where id_sal = 10002
union
select id_lavoro+300020, id_sal+30002, tipo_lavoro, id_supervisore, max_operai
from Lavoro l where id_sal = 10002
;

-- truncate table ImpiegoSupervisore;
INSERT INTO ImpiegoSupervisore (id_risorsa, dataora, ore_lavoro, id_lavoro)
VALUES	('XZSJKL04D46F088S', timestamp(current_date()) + interval 8 hour, 4, 100001),
		('XZSJKL04D46F088S', timestamp(current_date()) + interval 13 hour, 4, 100001),
        ('XZSJKL04D46F088S', timestamp(current_date()) + interval 1 day + interval 8 hour, 4, 100001),
		('XZSJKL04D46F088S', timestamp(current_date()) + interval 1 day + interval 13 hour, 4, 100001),
		('XZSJKL04D46F088S', timestamp(current_date()) + interval 2 day + interval 8 hour, 4, 100001),
		('XZSJKL04D46F088S', timestamp(current_date()) + interval 2 day + interval 13 hour, 4, 100001),
		('XZSJKL04D46F088S', timestamp(current_date()) + interval 3 day + interval 8 hour, 4, 100001),
		('XZSJKL04D46F088S', timestamp(current_date()) + interval 3 day + interval 13 hour, 4, 100001)
;

INSERT INTO ImpiegoSupervisore (id_risorsa, dataora, ore_lavoro, id_lavoro)
select l.id_supervisore, 
        si.dataora + interval (row_number() over(order by l.id_lavoro, l.id_supervisore))*4 day,
		si.ore_lavoro, l.id_lavoro
from Lavoro l
cross join ImpiegoSupervisore si
where si.id_lavoro = 100001 and l.id_lavoro != si.id_lavoro
;

-- truncate table ImpiegoOperaio;
INSERT INTO ImpiegoOperaio (id_risorsa, dataora, ore_lavoro, id_lavoro)
VALUES	('SNXYYP64C07D438G', timestamp(current_date()) + interval 8 hour, 2, 100001),
		('SNXYYP64C07D438G', timestamp(current_date()) + interval 13 hour, 3, 100001),
        ('SNXYYP64C07D438G', timestamp(current_date()) + interval 1 day + interval 8 hour, 2, 100001),
		('SNXYYP64C07D438G', timestamp(current_date()) + interval 1 day + interval 13 hour, 3, 100001),
		('SNXYYP64C07D438G', timestamp(current_date()) + interval 2 day + interval 8 hour, 2, 100001),
		('SNXYYP64C07D438G', timestamp(current_date()) + interval 2 day + interval 13 hour, 3, 100001),
		('SNXYYP64C07D438G', timestamp(current_date()) + interval 3 day + interval 8 hour, 2, 100001),
		('SNXYYP64C07D438G', timestamp(current_date()) + interval 3 day + interval 13 hour, 3, 100001),
        -- ------------
		('MNHJVU74M05D950N', timestamp(current_date()) + interval 9 hour, 2, 100001),
		('MNHJVU74M05D950N', timestamp(current_date()) + interval 14 hour, 3, 100001),
        ('MNHJVU74M05D950N', timestamp(current_date()) + interval 1 day + interval 9 hour, 2, 100001),
		('MNHJVU74M05D950N', timestamp(current_date()) + interval 1 day + interval 14 hour, 3, 100001),
		('MNHJVU74M05D950N', timestamp(current_date()) + interval 2 day + interval 9 hour, 2, 100001),
		('MNHJVU74M05D950N', timestamp(current_date()) + interval 2 day + interval 14 hour, 3, 100001),
		('MNHJVU74M05D950N', timestamp(current_date()) + interval 3 day + interval 9 hour, 2, 100001),
		('MNHJVU74M05D950N', timestamp(current_date()) + interval 3 day + interval 14 hour, 3, 100001),
        -- ------------
		('ZJRKHY85B42B757I', timestamp(current_date()) + interval 9 hour, 3, 100001),
		('ZJRKHY85B42B757I', timestamp(current_date()) + interval 14 hour, 3, 100001),
        ('ZJRKHY85B42B757I', timestamp(current_date()) + interval 1 day + interval 9 hour, 3, 100001),
		('ZJRKHY85B42B757I', timestamp(current_date()) + interval 1 day + interval 14 hour, 3, 100001),
		('ZJRKHY85B42B757I', timestamp(current_date()) + interval 2 day + interval 9 hour, 3, 100001),
		('ZJRKHY85B42B757I', timestamp(current_date()) + interval 2 day + interval 14 hour, 3, 100001),
		('ZJRKHY85B42B757I', timestamp(current_date()) + interval 3 day + interval 9 hour, 3, 100001),
		('ZJRKHY85B42B757I', timestamp(current_date()) + interval 3 day + interval 14 hour, 3, 100001)
;

INSERT INTO ImpiegoOperaio (id_risorsa, dataora, ore_lavoro, id_lavoro)
select	oi.id_risorsa, 
        oi.dataora + interval (row_number() over(order by l.id_lavoro))*4 day,
		oi.ore_lavoro, l.id_lavoro
from Lavoro l
cross join ImpiegoOperaio oi
where oi.id_lavoro = 100001 and l.id_lavoro != oi.id_lavoro
;

-- truncate table OperaGenerale;
INSERT INTO OperaGenerale (id_lavoro, id_edificio)
VALUES (100091, 10), (100092, 10), (100093, 10)
;

INSERT INTO OperaGenerale (id_lavoro, id_edificio)
select id_lavoro+200000, id_edificio+20
from OperaGenerale where id_edificio=10
union
select id_lavoro+300000, id_edificio+30
from OperaGenerale where id_edificio=10
;

-- truncate table OperaImpalcato;
INSERT INTO OperaImpalcato (id_lavoro, id_vano)
VALUES (100001, 104), (100002, 104), (100004, 104), (100011, 114), (100012, 114), (100014, 114)
;

INSERT INTO OperaImpalcato (id_lavoro, id_vano)
select id_lavoro+200000, id_vano+200
from OperaImpalcato where id_vano in (104,114)
union
select id_lavoro+200020, id_vano+220
from OperaImpalcato where id_vano = 104
union
select id_lavoro+300000, id_vano+300
from OperaImpalcato where id_vano in (104,114)
union
select id_lavoro+300020, id_vano+320
from OperaImpalcato where id_vano in (104,114)
;

-- truncate table OperaMuraria;
INSERT INTO OperaMuraria (id_lavoro,id_muro,lato_applicazione,spessore,n_strato)
VALUES (100003, 1002, 'SX', 5, 1), (100013, 1102, 'SX', 5, 1)
;

INSERT INTO OperaMuraria (id_lavoro, id_muro, lato_applicazione,spessore,n_strato)
select id_lavoro+200000, id_muro+2000, lato_applicazione, spessore, n_strato
from OperaMuraria where id_muro in (1002,1102)
union
select id_lavoro+200020, id_muro+2200, lato_applicazione, spessore, n_strato
from OperaMuraria where id_muro = 1002
union
select id_lavoro+300000, id_muro+3000, lato_applicazione, spessore, n_strato
from OperaMuraria where id_muro in (1002,1102)
union
select id_lavoro+300020, id_muro+3200, lato_applicazione, spessore, n_strato
from OperaMuraria where id_muro in (1002,1102)
;

-- truncate table Materiale;
INSERT INTO Materiale (codice_lotto,fornitore,nome_materiale,data_acquisto,unita_misura,costo_unitario)
VALUES	(120927521, 'Fassa Bortolo', 'intonaco per rinforzo strutturale', 
			now()- interval 3 month + interval rand()*10 day, 'KG', round(rand()*40,2) ),
		(241624192, 'Fassa Bortolo', 'rete in fibra di vetro per rinforzo strutturale', 
			now()- interval 3 month + interval rand()*10 day, 'MQ', round(rand()*50,2) ),
		(116616, 'Ceramiche Campochiaro', 'piastrella effetto metallo - platino', 
			now()- interval 2 month + interval rand()*10 day, 'MQ', round(rand()*100,2) ),
		(5463537, 'Ceramiche Campochiaro', 'piastrella decorata a mosaico', 
			now()- interval 1 month + interval rand()*10 day, 'MQ', round(rand()*100,2) ),
		(46642647427476, 'Poroton', 'Mattone strutturale Poroton P800', 
			now()- interval 12 month + interval rand()*10 day, 'Q', round(rand()*500,2) ),
		(7374254, 'Leca', 'CLS leggero strutturale', 
			now()- interval 12 month + interval rand()*10 day, 'KG', round(rand()*30,2) ),
		(1324, 'Borghini', 'Marmo bianco qualità Calacatta', 
			now()- interval 12 month + interval rand()*10 day, 'MQ', round(rand()*300,2) )
;

-- truncate table AltroMateriale;
INSERT INTO AltroMateriale (codice_lotto,fornitore,tipo_materiale,disegno,larghezza,lunghezza,spessore,peso_medio)
VALUES	(241624192, 'Fassa Bortolo', 'fibra di vetro', 'intrecciatura a rombo', 2000, 2000, 0.2, 0.6),
		(7374254, 'Leca', 'calcestruzzo', 'nessuno', 1, 1, 0.05, 25)
;

-- truncate table Intonaco;
INSERT INTO Intonaco (codice_lotto,fornitore,tipo_materiale,tipo_intonaco,colore)
VALUES	(120927521, 'Fassa Bortolo', 'malta cementizia fibro-rinforzata', 'rinforzo strutturale', 'grigio')
;

-- truncate table Mattone;
INSERT INTO Mattone (codice_lotto,fornitore,tipo_materiale,larghezza,lunghezza,altezza,alveolatura)
VALUES	(46642647427476, 'Poroton', 'muratura portante', 300, 250, 300, 35)
;

-- truncate table Pietra;
INSERT INTO Pietra (codice_lotto,fornitore,tipo_pietra,disposizione,superficie_media,peso_medio)
VALUES	(1324, 'Borghini', 'marmo statuario', 'regolare', 6, 230)
;

-- truncate table Rivestimento;
INSERT INTO Rivestimento (codice_lotto,fornitore,tipo_materiale,disegno,spessore_fuga,spessore,larghezza,lunghezza)
VALUES	(116616, 'Ceramiche Campochiaro', 'ceramica', 'effetto metallo', 0.5, 9, 1000, 1000),
		(5463537, 'Ceramiche Campochiaro', 'ceramica', 'mosaico cangiante', 0.3, 8, 80, 300)
;

-- truncate table UtilizzoMateriale;
INSERT INTO UtilizzoMateriale (id_lavoro,codice_lotto,fornitore,quantita)
VALUES	(100001, 7374254, 'Leca', 1000),
		(100002, 7374254, 'Leca', 1000),
		(100003, 120927521, 'Fassa Bortolo', 200),
        (100003, 241624192, 'Fassa Bortolo', 50),
        (100004, 116616, 'Ceramiche Campochiaro', 5),
        (100004, 5463537, 'Ceramiche Campochiaro', 8),
        (100011, 7374254, 'Leca', 1000),
		(100012, 7374254, 'Leca', 1000),
		(100013, 120927521, 'Fassa Bortolo', 200),
        (100013, 241624192, 'Fassa Bortolo', 50),
        (100014, 116616, 'Ceramiche Campochiaro', 5),
        (100014, 5463537, 'Ceramiche Campochiaro', 8),
        (100091, 7374254, 'Leca', 1000),
        (100092, 7374254, 'Leca', 1000),
        (100093, 7374254, 'Leca', 1000)
;

INSERT INTO UtilizzoMateriale (id_lavoro,codice_lotto,fornitore,quantita)
select id_lavoro+200000, codice_lotto, fornitore, quantita
from UtilizzoMateriale
where id_lavoro in (select id_lavoro from Lavoro where id_sal in (select id_sal from Progetto where id_edificio = 10))
union
select id_lavoro+200020, codice_lotto, fornitore, quantita
from UtilizzoMateriale
where id_lavoro in (select id_lavoro from Lavoro where id_sal = 10001)
union
select id_lavoro+300000, codice_lotto, fornitore, quantita
from UtilizzoMateriale
where id_lavoro in (select id_lavoro from Lavoro where id_sal in (select id_sal from Progetto where id_edificio = 10))
union
select id_lavoro+300020, codice_lotto, fornitore, quantita
from UtilizzoMateriale
where id_lavoro in (select id_lavoro from Lavoro where id_sal = 10001)
union
select id_lavoro+300030, codice_lotto, fornitore, quantita
from UtilizzoMateriale
where id_lavoro in (select id_lavoro from Lavoro where id_sal = 10001)
;

-- AREA MONITORAGGIO

-- truncate table Sensore;
INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
VALUES	(10001, 101, 'ACCELEROMETRO', 1, 1.5, 2.5, 0),
		(10002, 103, 'ACCELEROMETRO', 1, 6.5, 2.5, 0),
        (10003, 101, 'ESTENSIMETRO', 10, 1.5, 0, 0),
        (10004, 103, 'ESTENSIMETRO', 10, 6.5, 0, 0),
        (10101, 111, 'ACCELEROMETRO', 1, 1.5, 2.5, 0),
		(10102, 113, 'ACCELEROMETRO', 1, 6.5, 2.5, 0),
        (10103, 111, 'ESTENSIMETRO', 10, 1.5, 0, 0),
        (10104, 113, 'ESTENSIMETRO', 10, 6.5, 0, 0),
        (10105, 115, 'TEMPERATURA', null, 4, 0, 1.5)
;

INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
select id_sensore+10000, id_vano+100, tipo_sensore, valore_soglia, x, y, z
from Sensore s
where s.id_vano in (select v.id_vano from Vano v where v.id_edificio=10);

INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
select id_sensore+10100, id_vano+110, tipo_sensore, valore_soglia, x, y, z
from Sensore s
where s.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1);

INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
select id_sensore+10200, id_vano+120, tipo_sensore, valore_soglia, x, y, z
from Sensore s
where s.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1);

INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
select id_sensore+10300, id_vano+130, tipo_sensore, valore_soglia, x, y, z
from Sensore s
where s.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1);

INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
select id_sensore+10400, id_vano+140, tipo_sensore, valore_soglia, x, y, z
from Sensore s
where s.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1);

INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
select id_sensore+10500, id_vano+150, tipo_sensore, valore_soglia, x, y, z
from Sensore s
where s.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1);

INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
select id_sensore+10600, id_vano+160, tipo_sensore, valore_soglia, x, y, z
from Sensore s
where s.id_vano in (select v.id_vano from Vano v where v.id_edificio=10 and v.piano=1);

INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
select id_sensore+10000, id_vano+100, tipo_sensore, valore_soglia, x, y, z
from Sensore s
where s.id_vano in (select v.id_vano from Vano v where v.id_edificio=20 and v.piano <= 2);

INSERT INTO Sensore (id_sensore,id_vano,tipo_sensore,valore_soglia,x,y,z)
select id_sensore+20000, id_vano+200, tipo_sensore, valore_soglia, x, y, z
from Sensore s
where s.id_vano in (select v.id_vano from Vano v where v.id_edificio=20 and v.piano <= 3);

-- truncate table Misura;
set @acc_max = 4 ;
set @est_max = 10 ;
set @temp_max = 15 ;

INSERT INTO Misura (id_sensore,dataora,valore_x,valore_y,valore_z)
select 	id_sensore, current_timestamp()-interval 3 second, 
		@acc_max*rand()-@acc_max/2, @acc_max*rand()-@acc_max/2, @acc_max*rand()-@acc_max/2
from Sensore s
where s.tipo_sensore='ACCELEROMETRO' ;

INSERT INTO Misura (id_sensore,dataora,valore_x,valore_y,valore_z)
select 	id_sensore, current_timestamp()-interval 3 second, 
		@temp_max*rand(), null, null
from Sensore s
where s.tipo_sensore='TEMPERATURA' ;

INSERT INTO Misura (id_sensore,dataora,valore_x,valore_y,valore_z)
select 	id_sensore, current_timestamp()-interval 1 year, 
		@est_max*rand(), null, null
from Sensore s
where s.tipo_sensore='ESTENSIMETRO' ;

INSERT INTO Misura (id_sensore,dataora,valore_x,valore_y,valore_z)
select 	m.id_sensore, current_timestamp()-interval 4 month, 
		max(m.valore_x) + @est_max*rand(), null, null
from Misura m
inner join Sensore s on s.id_sensore=m.id_sensore
where s.tipo_sensore='ESTENSIMETRO' 
group by m.id_sensore ;

INSERT INTO Misura (id_sensore,dataora,valore_x,valore_y,valore_z)
select 	m.id_sensore, current_timestamp()-interval 1 month, 
		max(m.valore_x) + @est_max*rand(), null, null
from Misura m
inner join Sensore s on s.id_sensore=m.id_sensore
where s.tipo_sensore='ESTENSIMETRO' 
group by m.id_sensore ;


-- truncate table Alert;
INSERT INTO Alert (id_sensore,dataora,valore_x,valore_y,valore_z)
select m.id_sensore, m.dataora, m.valore_x, m.valore_y, m.valore_z
from Misura m
inner join Sensore s on s.id_sensore=m.id_sensore
where
(m.valore_x > s.valore_soglia or m.valore_y > s.valore_soglia or m.valore_z > s.valore_soglia )
;

call insert_misure_bassa_freq() ;

call update_costo_sal() ;

call update_data_fine_effettiva() ;

-- SET FOREIGN_KEY_CHECKS=1;
