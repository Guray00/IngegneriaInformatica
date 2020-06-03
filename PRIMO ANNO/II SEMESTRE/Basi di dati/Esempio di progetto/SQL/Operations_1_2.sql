/*1- Registrazione di un nuovo Cliente*/
INSERT INTO Cliente VALUES
('BNCGCM94E22H531I', 'Giacomo', 'Bianchi', 3492467399, 'Roma');

/*2- Modifica dati di un Cliente*/
UPDATE Cliente
SET Indirizzo = 'Milano'
WHERE Nome ='Giacomo' AND Cognome = 'Bianchi';

/*3- Creazione di un Modulo Riaparazione*/
INSERT INTO Modulo_Riparazione (ID_Riparazione, Difetto, Data_E, Cliente_CF, Stato) VALUES 
(30600, 'controllo', '2015-06-12', 'BNCGCM94E22H531I', 'Repair');

/*4- Creazione di un Modulo Vendita*/
INSERT INTO Modulo_Vendita (ID_Vendita, Data, Cliente_CF) VALUES
(20500, '2015-06-11', 'BNCGCM94E22H531I');

/*5- Creazione di un Modulo Ordine*/
INSERT INTO Ordine (ID_Ordine, Data, Dipendente_CF) VALUES
(40400, '2015-06-11', 'RSISMN94E12H501I');

/*6- Modifica Indice Riparazioni*/
INSERT INTO Lista_Riparazioni (Dipendente_CF, Modulo_Riparazione_ID_Riparazione) VALUES
('BNCCRL94E12H501I', 30600);

/*7- Modifica Indice Vendite*/
INSERT INTO Lista_Vendite (Modulo_Vendita_ID_Vendita, Dipendente_CF) VALUES
(20500, 'RSSMRI94E12H501I');

/*8- Modifica Indice Ordine*/
INSERT INTO Lista_Ordine (Prodotto_ID_prod, Ordine_ID_Ordine, Quantità) VALUES
(10300, 40400, 2),
(10200, 40400, 1);

/*-9 Modifica Indice lista prodotti vendita*/
INSERT INTO Lista_Prodotti_Vendita (Modulo_Vendita_ID_Vendita, Prodotto_ID_prod, Quantità) VALUES
(20500, 10300, 1),
(20500, 10200, 1);

/*10- Modifica Indice lista Prodotti in riparazione*/
INSERT INTO Lista_Prodotti_Riparazione (Prodotto_ID_prod, Modulo_Riparazione_ID_Riparazione) VALUES
(10200, 30600);

/*11- Registrazione di un nuovo Dipendente*/
INSERT INTO Dipendente VALUES
('ABBFRN94E12H501I', 'Franco', 'Abbatecola', '2015-06-15', 'Vendita');

/*12- Modifica Indice Dipendenti*/
INSERT INTO Lista_Dipendenti VALUES
('ABBFRN94E12H501I', 1000);

/*13- Registrazione di un nuovo Prodotto*/
INSERT INTO Prodotto (ID_Prod, Marca, Modello, Costo, Prezzo) VALUES
(10800, 'LG', 'PLEX2', 'Smartphone', 200.00, 399.99);

/*14- Visualizzazione delle riparazioni effettuate da un determinato Tecnico*/
SELECT T1.Modulo_Riparazione_ID_Riparazione, T2.Nome, T2.Cognome
FROM Lista_Riparazioni T1, Dipendente T2
WHERE T1.Dipendente_CF=T2.CF AND T2.Nome='Carlo' AND T2.Cognome='Bianchi';

/*15- Visualizza le vendite effettuate da un determinato Commesso*/
SELECT T1.Modulo_Vendita_ID_Vendita, T2.Nome, T2.Cognome
FROM Lista_Vendite T1, Dipendente T2
WHERE T1.Dipendente_CF = T2.CF AND T2.Nome='Mario' AND T2.Cognome='Rossi';

/*16-Visualizzazione degli Ordini effettuati da un determinato Gestore */
SELECT T1.ID_Ordine, T1.Data, T2.Nome, T2.Congome
FROM Ordine T1, Dipendente T2
WHERE T1.Dipendente_CF = T2.CF AND T2.Nome='Franco' AND T2.Cognome='Verdi';

/*17- Visualizzazione della quantita disponibile di un prodotto in un determinato  P.Vendita*/
SELECT T1.Marca, T1.Modello, T2.Quantità, T3.Indirizzo
FROM Prodotto T1, Magazzino T2, Punto_Vendita T3
WHERE T1.ID_Prod=T2.Prodotto_ID_prod AND T2.Punto_Vendita_ID_Store=T3.ID_Store AND T1.Marca='Apple' AND T1.Modello='iPhone4' AND T3.Indirizzo='Milano';

/*18- Visualizzazione degli acquisti effettuati da un determinato cliente*/
SELECT T1.Nome, T1.Cognome,T2.ID_Vendita, T2.Data, T2.Prezzo
FROM Cliente T1, Modulo_Vendita T2
WHERE T1.CF=T2.Cliente_CF AND T1.Nome='Mario' AND T1.Cognome='Neri';

/*19-Visualizzazione delle riparazioni richieste da un determinato cliente*/
SELECT T1.Nome, T1.Cognome, T2.ID_Riparazione, T2.Data_E, T2.Difetto
FROM Cliente T1, Modulo_Riparazione T2
WHERE T1.CF=T2.Cliente_CF AND T1.Nome='Carlo' AND T1.Cognome='Rossi';

/*20-Visualizzazione dei Prodotti con quantià Ridotta*/
SELECT T1.Marca, T1.Modello, T2.Quantità
FROM Magazzino T2, Prodotto T1
WHERE T1.ID_Prod=T2.PRodotto_ID_Prod AND T2.Quantità<3;

/*21- Visualizzazione di una lista di prodotti appartenenti ad una marca specificata e quantità nei rispettivi store*/
SELECT T1.Marca, T1.Modello, T2.Quantità, T3.Indirizzo
FROM Prodotto T1, Magazzino T2, Punto_Vendita T3
WHERE T1.ID_Prod=T2.Prodotto_ID_prod AND T2.Punto_Vendita_ID_Store=T3.ID_Store AND T1.Marca='Samsung';

/*22- Visualizzazione di una lista di prodotti appartenenti ad una marca specifica e con un prezzo pari a €400*/
SELECT Marca, Modello, Prezzo
FROM Prodotto
WHERE Marca='Samsung' AND Prezzo<480;

/*23- Modifica del quantitativo*/
UPDATE Magazzino
SET Quantità =+ 2
WHERE Prodotto_ID_prod=10400 AND Punto_Vendita_ID_Store='2000';

/*24- Visualizzazione dello status di una riparazione di un cliente specificato*/
SELECT T1.Nome, T1.Cognome, T2.ID_Riparazione, T2.Data_E, T2.Stato
FROM Cliente T1, Modulo_Riparazione T2
WHERE T1.CF=T2.Cliente_CF AND T1.Nome='Giacomo' AND T1.Cognome='Bianchi';

/*25- Visualizza una lista di riparazioni con status "Repair" */
SELECT ID_Riparazione, Difetto, Data_E, Stato
FROM Modulo_Riparazione
WHERE Stato='Repair';

/*26- Visualizzazione di una lista di riparazioni “Completo"*/
SELECT ID_Riparazione, Difetto, Data_E, Stato
FROM Modulo_Riparazione
WHERE Stato='Completo';

/*27- Visualizzazione di una lista di riparazioni “Consegnato"*/
SELECT ID_Riparazione, Difetto, Data_E, Stato
FROM Modulo_Riparazione
WHERE Stato='Consegnato';

/*28- Modifica dello Status di una riparazione*/
UPDATE Modulo_Riparazione
SET Stato='Completo'
WHERE ID_Riparazione=30200;