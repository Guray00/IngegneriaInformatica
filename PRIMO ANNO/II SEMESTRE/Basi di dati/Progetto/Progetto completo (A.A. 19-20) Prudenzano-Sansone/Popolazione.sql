-- -------------------------------------------------
-- INSERIMENTO DI VALORI ALL'INTERNO DEL DATABASE --
-- -------------------------------------------------

-- -----------------
--     Test      --
-- -----------------
INSERT INTO Test
VALUES (1,'Controllo Generale',NULL,NULL),(11,'Accensione',NULL,1),(12,'Touch Screen',NULL,1),(13,'Speaker',NULL,1),(14,'Microfono',NULL,1),(111,'Pulsanti',NULL,11),(112,'Caricamento',NULL,11),(15,'Batteria',NULL,1),
	   (2,'Controllo Generale', NULL, NULL),(21,'Accensione',NULL,2),(22,'Elettronica',NULL,2),(23,"Resistenza Matriali",NULL,2),(221,"Funzionamento Centralina",NULL,22),(24,"Funzionamento Pompa",NULL,2);

-- --------------------
--     Prodotto      --
-- --------------------
INSERT INTO Prodotto(Nome, Marca, Modello,DataProduzione, Prezzo, Predisposizione, SdR, CodiceTestRoot)
VALUES ('IoTelefono','Mela','XS','2000-01-19',700,'Piccolo',100,1),
	   ('Lavatrice','Boscio','BCNF','2000-08-25',500,'Grande',1,2);

-- ---------------------
--     Variante       --
-- ---------------------
INSERT INTO Variante (Prezzo, Descrizione, IDProdotto)
VALUES(50,"256 GB",1),(100,"Batteria Maggiorata",1),(30,"Colore Rosso",1),(200,"Schermo XL",1),
	  (100,"Cestello Maggiorato",2);

-- -------------------------------
--     VarianteDiProdotto       --
-- -------------------------------
INSERT INTO VarianteDiProdotto (Ricondizionato, IDProdotto)
VALUES(0,1),(0,1),(1,1),(0,1),(1,1),(0,2),(0,2),(1,2),(1,2);

-- ---------------------
--     Modello        --
-- ---------------------
INSERT INTO Modello
VALUES(1,1),(3,2),(4,4),(1,4),(3,5),(5,6),(5,8);

-- -------------------
--     Parte        --
-- -------------------
INSERT INTO Parte(Nome, Prezzo, Peso, CdS, Intermedio, IDProdotto)
VALUES("Batteria",10,0.04,3,0,1),("Microfono",5,0.04,1,0,1),("Schermo",10,0.04,3,0,1),("Case Esterno",10,0.05,3,0,1),("Pulsante Accensione",0.5,0.01,3,0,1), ("Speaker",3,0.04,3,0,1),("Processore",4,0.01,2,0,1),
	  ("Intermedio1",NULL,NULL,NULL,1,1),("Intermedio2",NULL,NULL,NULL,1,1),("Intermedio3",NULL,NULL,NULL,1,1),("Intermedio4",NULL,NULL,NULL,1,1),("Intermedio5",NULL,NULL,NULL,1,1),("ProdottoConcluso",NULL,NULL,NULL,1,1),
      ("Pannello1",5,0.3,1,0,2),("Pannello2",5,0.3,1,0,2),("Pannello3",5,0.3,1,0,2),("Pannello4",5,0.3,1,0,2),("Motore",50,10,10,0,2),("Pompa",10,0.5,2,0,2),("Cestello",10,0.5,2,0,2),("Centralina",20,0.3,2,0,2),
      ("Intermedio1",NULL,NULL,NULL,1,2),("Intermedio2",NULL,NULL,NULL,1,2),("Intermedio3",NULL,NULL,NULL,1,2),("Intermedio4",NULL,NULL,NULL,1,2),("Intermedio5",NULL,NULL,NULL,1,2),("Intermedio6",NULL,NULL,NULL,1,2),("ProdottoConcluso",NULL,NULL,NULL,1,2);
      
-- -----------------------
--     Riguarda         --
-- -----------------------
INSERT INTO Riguarda
VALUES (1,13),(11,5),(111,3),(13,6),(14,2),(111,5),(15,1),(15,5);
      
-- -----------------------
--     Materiale        --
-- -----------------------
INSERT INTO Materiale(Nome,VKG)
VALUES ("Vetro",20),("Plastica",5),("Rame",4),("Ferro",6);

-- --------------------------
--     Composizione        --
-- --------------------------
INSERT INTO Composizione
VALUES (1,2,0.01),(2,4,0.03),(3,1,0.01),(4,2,0.02),(7,4,0.03),(7,3,0.04);

-- --------------------
--     Faccia        --
-- --------------------
INSERT INTO Faccia(IDProdotto)
VALUES (1),(1),(2),(2),(2),(2);

-- -----------------------
--     Giunzione        --
-- -----------------------
INSERT INTO Giunzione
VALUES (1,"Saldatura"),(2,"Nastro"),(3,"Fascetta"),(4,"Vite");

-- ----------------------------
--     Caratteristica        --
-- ----------------------------
INSERT INTO Caratteristica(Descrizione, UDM, Valore, IDGiunzione)
VALUES ("Passo","mm",0.9,4),("Lunghezza","m",0.2,3);

-- ----------------------
--     Utensile        --
-- ----------------------
INSERT INTO Utensile
VALUES (1,"Trapano"),(2,"Cacciavite"),(3,"Saldatore"), (4,"Saldatore di precisione");

-- ------------------------
--     Operazione        --
-- ------------------------
INSERT INTO Operazione(Nome, Priorita, ParteA, ParteB, IDGiunzione, IDFaccia)
VALUES ("O1",1,1,2,1,1),("O2",1,3,4,1,2),("O3",1,5,6,1,2),("O4",2,7,10,1,1),("O5",2,8,9,1,2),("O6",3,12,11,1,1),
       ("O1",1,14,15,4,3),("O2", 1,17,18,2, 3),("O3", 1,19 ,20,2, 4),("O4", 2,22 ,16,3, 5),("O5", 2,24 ,21,3, 5),("O6", 3,25 ,23,1, 3),("O7", 4,27 ,26,1, 6);

-- -----------------
--     Uso        --
-- -----------------
INSERT INTO Uso
VALUES (1,4),(2,3),(3,4),(4,4),(5,3),(6,2),(7,2),(8,3),(9,3),(10,2),(11,1),(12,3),(13,3);

-- -----------------------
--     Operatore        --
-- -----------------------
INSERT INTO Operatore(Nome, Cognome)
VALUES ("Giacomo","Sansone"),("Aleandro","Prudenzano"),("Inquisizione","Spagnola"),("Marco","Lampis"),("Francesca","Battilana"),("Giuliana","D'Alessandro"),("Mamadou","Ndyae"),("Paolo","Atzeni");

-- --------------------------------
--     OperazioneCampione        --
-- --------------------------------
INSERT INTO OperazioneCampione
VALUES ("Disaccoppiare un pannello"),("Svitare 10 viti"),("Flessioni");

-- ----------------------
--     Capacita        --
-- ----------------------
INSERT INTO Capacita
VALUES (1,"Disaccoppiare un pannello",8,4),(1,"Svitare 10 viti",4,3),(1,"Flessioni",1,2),(2,"Disaccoppiare un pannello",5,3),(2,"Svitare 10 viti",4,4),(2,"Flessioni",1,0),(3,"Disaccoppiare un pannello",3,2),(3,"Svitare 10 viti",8,3),(3,"Flessioni",8,4),(4,"Disaccoppiare un pannello",1,2),(4,"Svitare 10 viti",4,4),(4,"Flessioni",10,2),(5,"Disaccoppiare un pannello",1,3),(5,"Svitare 10 viti",10,3),(5,"Flessioni",7,0),(6,"Disaccoppiare un pannello",8,1),(6,"Svitare 10 viti",3,2),(6,"Flessioni",1,3),(7,"Disaccoppiare un pannello",10,4),(7,"Svitare 10 viti",10,1),(7,"Flessioni",8,2),(8,"Disaccoppiare un pannello",4,1),(8,"Svitare 10 viti",6,0),(8,"Flessioni",9,1);

-- -----------------------------
--    SequenzaDiOperazioni    --
-- -----------------------------
INSERT INTO SequenzaDiOperazioni
VALUES (DEFAULT, "Generico", 2, 1),(DEFAULT, "Generico", 2, 2);

-- -----------------
--    Stazione    --
-- -----------------
INSERT INTO Stazione
VALUES  (DEFAULT,1,1,1),(DEFAULT,2,2,1),(DEFAULT,3,3,1),(DEFAULT,4,4,1),(DEFAULT,5,5,1),
	(DEFAULT,1,4,2),(DEFAULT,2,5,2),(DEFAULT,3,6,2),(DEFAULT,4,7,2),(DEFAULT,5,8,2);
                            
-- -------------
--    Fase    --
-- -------------
INSERT INTO Fase
VALUES  (1,1),(2,2),(2,3),(3,4),(4,5),(5,6),
        (6,7),(6,8),(7,9),(8,10),(8,11),(9,12),(10,13);

-- -----------------------
--     Magazzino        --
-- -----------------------
INSERT INTO Magazzino(Capienza,Predisposizione)
VALUES (10,"Medio"),(10,"Grande");

-- ------------------------
--     Ubicazione        --
-- ------------------------
INSERT INTO Ubicazione(Piano, Stanza, Scaffale, CodiceMagazzino)
VALUES (1,2,49,1),(1,3,58,1),(1,0,72,1),(1,4,78,1),(1,3,9,1),(1,0,65,1),(1,2,42,1),(1,2,3,1),(1,2,29,1),(1,0,12,1),(1,3,69,2),(1,4,57,2),(1,0,33,2),(1,4,78,2),(1,1,35,2),(1,2,26,2),(1,2,67,2),(1,0,33,2),(1,4,49,2),(1,4,21,2);


-- ---------------------------
--     AggiuntaLotti        --
-- ---------------------------
CALL AggiuntaLotto(1,1,'2020-01-19',"Pontedera",1,1);
CALL FineProduzioneLotto(1);
CALL AggiuntaLotto(2,1,'2020-01-19',"Vicopisano",1,1);
CALL FineProduzioneLotto(2);
CALL AggiuntaLotto(3,1,'2020-01-19',"Lari",NULL,1);
CALL FineProduzioneLotto(3);
CALL AggiuntaLotto(4,50,'2020-01-19',"Peccioli",1,1);
CALL FineProduzioneLotto(4);
CALL AggiuntaLotto(5,1,'2020-01-19',"San Miniato",NULL,1);
CALL FineProduzioneLotto(5);
CALL AggiuntaLotto(6,1,'2020-01-19',"Cascina",2,2);
CALL FineProduzioneLotto(6);
CALL AggiuntaLotto(7,1,'2020-01-19',"Orciano",2,2);
CALL FineProduzioneLotto(7);
CALL AggiuntaLotto(8,1,'2020-01-19',"Volterra",NULL,2);
CALL FineProduzioneLotto(8);
CALL AggiuntaLotto(9,1,'2020-01-19',"Terricciola",NULL,2);
CALL FineProduzioneLotto(9);

-- -------------------
--    UnitaPerse    --
-- -------------------
INSERT INTO UnitaPerse
VALUES  (1, 1, 1),
        (1, 2, 1),
        (1, 4, 1),
        (2, 4, 2),
        (3, 4, 1),
        (4, 4, 1),
        (5, 4, 1);

-- -------------------------
--    DomandaSicurezza    --
-- -------------------------
INSERT INTO DomandaSicurezza
VALUES  (DEFAULT, 'Cognome da nubile di tua madre'),
        (DEFAULT, 'Nome del primo animale domestico'),
        (DEFAULT, 'Modello della tua prima auto'),
        (DEFAULT, 'Nome della tua scuola elementare'),
        (DEFAULT, 'Primo lavoro');

-- ------------------------
--    FormulaGaranzia    --
-- ------------------------
INSERT INTO FormulaGaranzia
VALUES (DEFAULT, 24, 120, 0),
        (DEFAULT, 36, 150, 0),
        (DEFAULT, 12, 80, 1),
        (DEFAULT, 3, 25, 1),
        (DEFAULT, 6, 40, 1);

-- --------------------
--    Applicabile    --
-- --------------------
INSERT INTO Applicabile
VALUES (1, 1),
        (1, 2),
        (2, 1),
        (2, 2),
        (4, 1),
        (5, 1),
        (3, 2);

-- ---------------
--    Utente    --
-- ---------------
INSERT INTO Utente
VALUES ('PRDLDR', 'Aleandro', 'Prudenzano', '333333333', 'Via diotisalvi veramente', '1', 'Carta di identità', '2022-10-08', 'Comune'),
        ('SNSGCM', 'Giacomo', 'Sansone', '3775084186', 'Via Bachelete, 32', '99361', 'Carta di identità', '2023-6-20', 'Provincia'),
        ('GYUZR', 'Mariano', 'Milano', '7494891371', 'Piazza Pilastri, 98', '26079', 'Passaporto', '2022-2-13', 'Comune'),
        ('KLGIF', 'Marilena', 'Cocci', '5726681344', 'Via Catullo, 42', '35968', 'Carta di identità', '2022-8-20', 'Questura');

-- ----------------
--    Account    --
-- ----------------
INSERT INTO Account
VALUES ('drw0if', 'a.prudenzano@studenti.unipi.it', '2020-06-14', 10, 'jf3Jz', '329ab41d1c7b4fd9267c77a753d347f7', 'PRDLDR', 5, 'Sviluppatore backend Django'),
        ('pcineverdies', 'g.sansone2@studenti.unipi.it', '2017-1-14', '10', 'OEOOS', '253afed6f2969a6813a159ad224aaa76', 'SNSGCM', '3', 'Francesco Petrarca'),
        ('Lowdethe', 'Lowdethe@gmail.com', '2014-01-16', '1000', 'WHJIL', '8f1835bef91d6dd7fcf81b38618c876d', 'GYUZR', '4', 'Panettiere'),
        ('Sant1951', 'Sant1951@libero.it', '2011-01-4', '10', 'QJQLK', 'd4e8e6a0a2f96384e11a678362a267fa', 'KLGIF', '4', 'Segretaria');

-- ---------------
--    Ordine    --
-- ---------------
INSERT INTO Ordine
VALUES (DEFAULT, 'Via Porta Pia, 2', CURRENT_TIMESTAMP, NULL, NULL, 'processazione', 'drw0if'),
    (DEFAULT, 'Via Porta Pia, 2', CURRENT_TIMESTAMP, NULL, NULL, 'processazione', 'drw0if'),
    (DEFAULT, 'Via Porta Pia, 2', CURRENT_TIMESTAMP, NULL, NULL, 'processazione', 'drw0if'),
    (DEFAULT, 'Via Licola Patria, 81', CURRENT_TIMESTAMP, NULL, NULL, 'processazione', 'pcineverdies'),
    (DEFAULT, 'Via Licola Patria, 81', CURRENT_TIMESTAMP, null, NULL, 'processazione', 'pcineverdies'),
    (DEFAULT, 'Piazza Pilastri, 98', CURRENT_TIMESTAMP, NULL, NULL, 'processazione', 'Lowdethe'),
    (DEFAULT, 'Piazza Pilastri, 98', CURRENT_TIMESTAMP, NULL, NULL, 'processazione', 'Lowdethe'),
    (DEFAULT, NULL, CURRENT_TIMESTAMP, NULL, NULL, 'processazione', 'Sant1951'),
    (DEFAULT, NULL, CURRENT_TIMESTAMP, NULL, NULL, 'processazione', 'Sant1951');

-- ------------------------
--    UnitaAcquistata    --
-- ------------------------
INSERT INTO UnitaAcquistata
VALUES (DEFAULT, 1, 1),
    (DEFAULT, 1, 2),
    (DEFAULT, 2, 3),
    (DEFAULT, 5, 4),
    (DEFAULT, 9, 4),
    (DEFAULT, 3, 5),
    (DEFAULT, 4, 5),
    (DEFAULT, 1, 6),
    (DEFAULT, 2, 6),
    (DEFAULT, 6, 7),
    (DEFAULT, 6, 7),
    (DEFAULT, 3, 8),
    (DEFAULT, 4, 8),
    (DEFAULT, 7, 9),
    (DEFAULT, 4, 9);

-- -------------------
--    Estensione    --
-- -------------------
INSERT INTO Estensione
VALUES  (1, 1),
        (1, 4),
        (1, 5);

-- ------------
--    Hub    --
-- ------------
INSERT INTO Hub
VALUES  (DEFAULT, 'Pisa'),
        (DEFAULT, 'Firenze'),
        (DEFAULT, 'Bologna'),
        (DEFAULT, 'Viareggio'),
        (DEFAULT, 'Sava'),
        (DEFAULT, 'Roma'),
        (DEFAULT, 'Matera');

-- -------------------
--    Spedizione    --
-- -------------------
INSERT INTO Spedizione
VALUES  (DEFAULT, '2020-06-20' - INTERVAL 1 DAY, '2020-06-20' + INTERVAL 5 DAY, NULL, 'inconsegna', 2),
        (DEFAULT, '2020-06-20' - INTERVAL 2 DAY, '2020-06-20' + INTERVAL 2 DAY, '2020-06-20' + INTERVAL 1 DAY, 'consegnato', 4);

-- ------------------
--    Passaggio    --
-- ------------------
INSERT INTO Passaggio
VALUES  (1, 1, '2020-06-20', '09:10'),
        (2, 1, '2020-06-20' - INTERVAL 2 DAY, '10:30'),
        (2, 3, '2020-06-20' - INTERVAL 1 DAY, '17:20'),
        (2, 6, '2020-06-20', '04:30'),
        (2, 5, '2020-06-20', '19:10');

-- -----------------
--    Giudizio    --
-- -----------------
INSERT INTO Giudizio
VALUES (DEFAULT, 'Estetica'),
        (DEFAULT, 'Spedizione'),
        (DEFAULT, 'Assistenza'),
        (DEFAULT, 'Prezzo');

-- --------------------
--    Motivazione    --
-- --------------------
INSERT INTO Motivazione
VALUES (DEFAULT, 'Diritto di recesso', '', 1),
        (DEFAULT, 'Arrivato danneggiato', 'Alla consegna del pacco il dispositivo era non funzionante', 0),
        (DEFAULT, 'Prodotto sbagliato', 'Ho sbagliato a comprare questo prodotto', 0),
        (DEFAULT, 'Non mi serve più', 'Lo avevo comprato ma ora non ne necessito più', 0);

-- ---------------
--    Guasto    --
-- ---------------
INSERT INTO Guasto
VALUES (DEFAULT, 'Schermo rotto', 'Schermo non funzionante correttamente'),
       (DEFAULT, 'Batteria', 'La durata della batteria è calata notevolmente'),
       (DEFAULT, 'Centralina', 'Rottura della centralina'),
       (DEFAULT, 'Perdita di acqua', 'Perde acqua dalle pareti'),
       (DEFAULT, 'Cestello bloccato', 'Il cestello non si muove');

-- ------------------
--    Specifica    --
-- ------------------
INSERT INTO Specifica
VALUES  (2, 4),
        (2, 5);

-- ---------------------
--    CodiceErrore    --
-- ---------------------
INSERT INTO CodiceErrore
VALUES  (123, 1, 1),
        (100, 1, 2),
        (34, 2, 3),
        (234, 2, 4);

-- ----------------
--    Rimedio    --
-- ----------------
INSERT INTO Rimedio
VALUES  (DEFAULT, 'Sostituzione della batteria'),
        (DEFAULT, 'Sostituzione dello schermo'),
        (DEFAULT, 'Sostituzione della centralina'),
        (DEFAULT, 'Sostituzione della guarnizione'),
        (DEFAULT, 'Diminuisci la luminosità'),
        (DEFAULT, 'Disinstalla quelle applicazioni'),
        (DEFAULT, 'Disattiva il gps'),
        (DEFAULT, 'Cambia la batteria'),
        (DEFAULT, 'Aumenta la luminosità'),
        (DEFAULT, 'Modificare le impostazioni dello schermo'),
        (DEFAULT, 'Inserire la spina'),
        (DEFAULT, 'Pulizia con prodotti anticalcare'),
        (DEFAULT, 'Attaccare cinghia di trasmissione');

-- ----------------
--    Domanda    --
-- ----------------
INSERT INTO Domanda
VALUES  (9, 'La cinghia di trasmissione è attaccata?', NULL, 1, NULL, NULL),
        (8, 'C\'è del calcare?', 0, 1, 9, NULL),
		(7, 'Hai inserito la spina?', 0, 1, 8, NULL),
		(6, 'I colori ti sembrano distorti?', 1, NULL, NULL, NULL),
        (5, 'Hai aumentato la luminosità?', 0, 1, 6, NULL),
        (4, 'Hai cambiato la batteria di recente?', NULL, 1, NULL, NULL),
		(3, 'Hai disattivato il GPS?', 0, 1, 4, NULL),
		(2, 'Hai delle applicazioni che consumano molto la batteria?', 1, 0, NULL, 3),
		(1, 'Hai la lumiosità al massimo?', 1, 0, NULL, 2);

-- ---------------
--    EndYes    --
-- ---------------
INSERT INTO EndYes
VALUES (1,5),
       (2,6);

-- ---------------
--    EndNo    --
-- ---------------
INSERT INTO EndNo
VALUES (3,7),
       (4,8),
       (5,9),
       (6,10),
       (7,11),
       (8,12),
       (9,13);

-- ---------------------------
--    AssistenzaVirtuale    --
-- ---------------------------
INSERT INTO AssistenzaVirtuale
VALUES (1,2,1),
       (1,1,5),
       (2,5,7);

-- ------------------
--    Soluzione    --
-- ------------------
INSERT INTO Soluzione
VALUES (123, 1, 2),
        (100, 1, 1),
        (34, 2, 3),
        (234, 2, 4);

-- ----------------
--    Tecnico    --
-- ----------------
INSERT INTO Tecnico
VALUES  (DEFAULT, 'Giovanni', 'Esposito', 20),
        (DEFAULT, 'Taddeo', 'Moscaverde', 20),
        (DEFAULT, 'Giannamaria', 'Gondrano', 2),
        (DEFAULT, 'Maddalena', 'Cirani', 20);

-- -------------------------
--    AssistenzaFisica    --
-- -------------------------
INSERT INTO AssistenzaFisica
VALUES (DEFAULT, 10, TRUE, 1),
        (DEFAULT, 10, TRUE, 2),
        (DEFAULT, 10, TRUE, 3);

-- -------------------
--    Intervento    --
-- -------------------
INSERT INTO Intervento
VALUES (DEFAULT, DEFAULT, DEFAULT, '2020-06-18', 1, 269, 76, 1, DEFAULT, 1),
        (DEFAULT, DEFAULT, DEFAULT, '2020-06-19', 2, 78, 458, 1, DEFAULT, 2),
        (DEFAULT, DEFAULT, DEFAULT, '2020-06-20', 4, 99, 35, 1, DEFAULT, 3),
        (DEFAULT, DEFAULT, DEFAULT, '2020-06-20', 3, 151, 282, 1, DEFAULT, 1),
        (DEFAULT, DEFAULT, DEFAULT, '2020-06-22', 3, 389, 141, 1, DEFAULT, 2),
        (DEFAULT, DEFAULT, DEFAULT, '2020-06-25', 4, 263, 272, 1, DEFAULT, 3),
        (DEFAULT, DEFAULT, DEFAULT, '2020-06-29', 2, 307, 150, 1, DEFAULT, 1),
        (DEFAULT, DEFAULT, DEFAULT, '2020-06-29', 1, 276, 478, 1, DEFAULT, 2);