/*TRIGGER 1- Imposta il prezzo della nuova tupla in modulo vendita calcolando la sommatoria della moltiplicazione tra il prezzo e la rispettiva quantità di ogni singolo prodotto  */
CREATE TRIGGER Prezzo_Totale
AFTER INSERT ON Lista_Prodotti_Vendita
FOR EACH ROW
UPDATE Modulo_Vendita
SET Prezzo =(SELECT SUM(Prezzo_Totale)
			 FROM (SELECT Prezzo * Quantità AS Prezzo_Totale
				   FROM (SELECT T1.Prezzo, T2.Quantità, T2.Prodotto_ID_prod
						 FROM Prodotto T1, Lista_Prodotti_Vendita T2
						 WHERE T1.ID_prod=T2.Prodotto_ID_prod AND Modulo_Vendita_ID_Vendita=(SELECT MAX(Modulo_Vendita_ID_Vendita)
																		                     FROM Lista_Prodotti_Vendita AS Max_Modulo))AS Tab_Prezzo)AS Tab_Prezzo_Unito)
WHERE ID_Vendita=NEW.Modulo_Vendita_ID_Vendita;
												
/*Test della funzionalità*/

SELECT * FROM Modulo_Vendita; /*Ultimo ID=20500*/

INSERT INTO Modulo_Vendita (ID_Vendita, Data, Cliente_CF) VALUES
(20600, '2015-06-12', 'BNCLCA94E22H531I');							/*Creo un nuovo modulo per testare*/

SELECT * FROM Lista_PRodotti_Vendita;  /* Controllo la tabella, il prezzo è NULL*/

INSERT INTO Lista_Prodotti_Vendita VALUES			
(20600, 10300, 1);							/*inserisco un prodotto*/

SELECT * FROM Modulo_Vendita WHERE ID_Vendita=20600; /*Il prezzo corrente è 499.99*/

INSERT INTO Lista_Prodotti_Vendita VALUES
(20600, 10200, 2);							/*inserisco un altro prodotto*/

SELECT * FROM Modulo_Vendita WHERE ID_Vendita=20600; /*Il prezzo corrente è 1399.95€ (499.99+449.98*2)

Il Trigger funziona correttamente*/


