-- Active: 1647365195286@@127.0.0.1@3306@mydb

INSERT INTO Attore VALUES
(1,'Vivien', 'Leigh','Scarlett O Hara', 0), -- Via Col Vento
(2,'Clark', 'Gable','Rhett Butler', 0), -- Via Col Vento
(3,'Humphrey', 'Bogart', NULL, 0),-- Casablanca
(4,'Ingrid', 'Bergman', NULL, 0), -- Casablanca
(5,'Tyrone', 'Power', NULL, 0), -- Testimone d'accusa 
(6,'Marlene', 'Dietrich', NULL, 0), -- Testimone d'accusa
(7,'Marcello', 'Mastroianni', NULL, 0), -- La Dolce Vita
(8,'Anita', 'Ekberg', NULL, 0), -- La Dolce Vita
(9,'Marlon', 'Brando', NULL, 0), -- Il Padrino
(10,'Al', 'Pacino', NULL, 0), -- Il Padrino
(11,'Mark', 'Hamill', NULL, 0), -- Guerre Stellari
(12,'Harrison', 'Ford', NULL,0), -- Guerre Stellari
(13,'Tom', 'Hanks', NULL,0), -- Titanic
(14,'Robin', 'Wright', NULL, 0), -- Titanic
(15,'Leonardo', 'Di Caprio', NULL, 0), -- Sesto Senso
(16,'Kate', 'Winslet', NULL, 0), -- Sesto Senso
(17,'Bruce', 'Willis', NULL, 0), -- Il Signore degli Anelli: Il Ritorno del Re
(18,'Haley', 'Joel Osment', NULL, 0), -- Il Signore degli Anelli: Il Ritorno del Re
(19,'Elijah','Wood',NULL,0),
(20,'Ian','McKellen',NULL,0);


INSERT INTO Regista VALUES
(1,'Victor', 'Fleming', NULL,0), -- Via Col Vento
(2,'Michael', 'Curtiz', 'Miska',0), -- Casablanca
(3,'Samuel Billy', 'Wilder', 'Billie Wilder',0), -- Testimone d'accusa
(4,'Federico', 'Fellini', NULL,0), -- La Dolce Vita
(5,'Francis Ford', 'Coppola', NULL,0), -- Il Padrino
(6,'George', 'Lucas', NULL,0), -- Guerre Stellari
(7,'Bruce', 'Willis', NULL,0), -- Forrest Gump
(8,'M. Night', 'Shyamalan', NULL,0), -- Titanic
(9,'Peter', 'Jackson', NULL,0), --  Sesto Senso
(10,'Haley Joel', 'Osment', NULL,0); -- Il Signore degli Anelli: Il Ritorno del Re


INSERT INTO Film VALUES
    (1,1939, 'Via col Vento', 238, 'Stati Uniti', 0, 'Drammatico/Romantico', 0, 'Il film segue la vita di Scarlett O Hara durante la Guerra Civile.'),
    (2,1942, 'Casablanca', 102, 'Stati Uniti', 0, 'Drammatico/Romantico', 0, 'La storia da amore tra Rick Blaine e Ilsa Lund durante la Seconda Guerra Mondiale.'),
    (3,1957, 'Testimone da accusa', 116, 'Stati Uniti', 0, 'Drammatico/Thriller', 0, 'Un avvocato difende un uomo accusato di omicidio, ma la verità è sfuggente.'),
    (4,1960, 'La dolce vita', 174, 'Italia', 0, 'Drammatico', 0, 'La vita di un giornalista a Roma, tra vita mondana e vuoto esistenziale.'),
    (5,1972, 'Il Padrino', 175, 'Stati Uniti', 0, 'Drammatico/Crimine', 0, 'La saga di una famiglia mafiosa italo-americana, guidata da Don Vito Corleone.'),
    (6,1977, 'Guerre stellari (Star Wars)', 121, 'Stati Uniti', 0, 'Fantascienza/Azione', 0, 'La lotta tra le forze ribelli e lo Impero Galattico, con Luke Skywalker.'),
    (7,1994, 'Forrest Gump', 142, 'Stati Uniti', 0, 'Drammatico/Commedia', 0, 'La vita straordinaria di Forrest Gump, attraverso gli eventi degli anni 60 e 70.'),
    (8,1997, 'Titanic', 195, 'Stati Uniti', 0, 'Drammatico/Romantico', 0, 'La tragica storia da amore tra Jack e Rose a bordo del transatlantico Titanic.'),
    (9,1999, 'Il sesto senso', 107, 'Stati Uniti', 0, 'Thriller/Supernaturale', 0, 'Un psicologo cerca di aiutare un giovane che afferma di vedere i morti.'),
    (10,2003, 'Il Signore degli Anelli: Il Ritorno del Re', 201, 'Stati Uniti/Nuova Zelanda', 0, 'Fantasia/Azione', 0, 'La conclusione epica della trilogia, con la battaglia per il dominio della Anello.');

INSERT INTO Direzione VALUES  
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10);

INSERT INTO Interpretazione VALUES
(1,1),
(1,2),
(2,3),
(2,4),
(3,5),
(3,6),
(4,7),
(4,8),
(5,9),
(5,10),
(6,11),
(6,12),
(7,13),
(7,14),
(8,15),
(8,16),
(9,17),
(9,18),
(10,19),
(10,20);