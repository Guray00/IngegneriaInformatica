-- Inserimento Elementi
INSERT INTO Element (Nome, PathImmagine, PathImmaginePG, ModificatoreFor, ModificatoreDES, RecuperoVita) VALUES
('Acqua',	'images/pics/acqua.svg', 	'images/characters/acqua.svg',	 -3, +2, +5),
('Fuoco',	'images/pics/fuoco.svg', 	'images/characters/fuoco.svg',	 +4, +3, -3),
('Terra',	'images/pics/terra.svg', 	'images/characters/terra.svg',	 +0, -2, +6),
('Elettro',	'images/pics/elettro.svg', 	'images/characters/elettro.svg', +6, +0, -2),
('Aria'	,	'images/pics/aria.svg', 	'images/characters/aria.svg',	 -1, +6, -1);

UPDATE Element SET PrevaleSu = 'Fuoco',   PrevalsaDa = 'Elettro' WHERE Nome = 'Acqua';
UPDATE Element SET PrevaleSu = 'Aria',    PrevalsaDa = 'Acqua' WHERE Nome = 'Fuoco';
UPDATE Element SET PrevaleSu = 'Elettro', PrevalsaDa = 'Aria' WHERE Nome = 'Terra';
UPDATE Element SET PrevaleSu = 'Acqua',   PrevalsaDa = 'Terra' WHERE Nome = 'Elettro';
UPDATE Element SET PrevaleSu = 'Terra',   PrevalsaDa = 'Fuoco' WHERE Nome = 'Aria';

-- Inserimento Tipologie
INSERT INTO ItemType (Nome) VALUES ('arma'), ('armatura'), ('box'), ('pozione');

-- Inserimento Armi
INSERT INTO Item (Nome, Descrizione, Elemento, PathImmagine, Tipologia, Costo, Danno, ModificatoreFor, ModificatoreDes) VALUES
("Spada d'Acqua", 		"Una spada affilata e leggera.",		"Acqua",	"images/items/weapons/acqua.svg",	"arma", 20, 6, 2, 1),
("Spada di Fuoco", 		"Una spada infuocata.", 				"Fuoco",	"images/items/weapons/fuoco.svg",	"arma", 30, 8, 0, 1),
("Mazza di Terra", 		"Una mazza pesante e robusta.", 		"Terra",	"images/items/weapons/terra.svg", 	"arma", 30, 8, 1, 0),
("Bastone Elettrico", 	"Un bastone che emette elettricità.", 	"Elettro",	"images/items/weapons/elettro.svg",	"arma", 25, 7, 1, 1),
("Pugnale d'Aria", 		"Un pugnale leggero e veloce.", 		"Aria",		"images/items/weapons/aria.svg", 	"arma", 20, 6, 1, 2);

-- Inserimento Armature
INSERT INTO Item (Nome, Descrizione, Elemento, PathImmagine, Tipologia, Costo, Armatura, ModificatoreFor, ModificatoreDes) VALUES
("Armatura d'Acqua", 	"Leggera e impermeabile.", 	"Acqua", 	"images/items/armors/acqua.svg",	"armatura", 40, 4, -1, 0),
("Armatura di Fuoco", 	"Resistente al calore.", 	"Fuoco", 	"images/items/armors/fuoco.svg",	"armatura", 40, 4, 0, -1),
("Armatura di Terra", 	"Robusta e pesante.", 		"Terra", 	"images/items/armors/terra.svg",	"armatura", 45, 5, -1, -2),
("Armatura Elettrica", 	"Robusta e conduttiva.", 	"Elettro", 	"images/items/armors/elettro.svg",	"armatura", 45, 5, -2, -1),
("Armatura d'Aria",		"Leggera e flessibile.", 	"Aria", 	"images/items/armors/aria.svg",	"armatura", 35, 3, 0, 0);

-- Inserimento Pozioni
INSERT INTO Item (Nome, Descrizione, Elemento, PathImmagine, Tipologia, Costo, RecuperoVita, ModificatoreFor, ModificatoreDes) VALUES
("Pozione di Vita", 	"Ripristina 20 PF.", 								NULL, "images/items/potions/vita.svg",		"pozione", 15, 20, 0, 0),
("Pozione di Energia", 	"Ripristina 10 PF.", 								NULL, "images/items/potions/energia.svg",	"pozione", 10, 10, 0, 0),
("Pozione di Forza", 	"Aumenta la forza temporaneamente di 3 punti.", 	NULL, "images/items/potions/forza.svg",		"pozione", 8, 0, 3, 0),
("Pozione di Destrezza","Aumenta la destrezza temporaneamente di 3 punti.", NULL, "images/items/potions/destrezza.svg",	"pozione", 8, 0, 0, 3);

-- Inserimento Box
INSERT INTO Item (Nome, Descrizione, Elemento, PathImmagine, Tipologia, Costo) VALUES
("Box Comune", 	"Contiene monete, pozione, 2 oggetti (armi e/o armature).", NULL, "images/items/box/comune.svg",	"box", 50),
("Box Rara", 	"Contiene monete, 2 pozioni, 2 armi e 2 armature.", 		NULL, "images/items/box/raro.svg",		"box", 100);