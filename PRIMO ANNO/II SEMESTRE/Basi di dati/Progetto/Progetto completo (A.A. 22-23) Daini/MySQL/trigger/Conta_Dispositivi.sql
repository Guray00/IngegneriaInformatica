-- Active: 1647365195286@@127.0.0.1@3306@mydb
-- contare il numero di dispositivi diversi in cui si è connesso l'utente finora

DROP TRIGGER IF EXISTS Trigger_Conta_Dispositivi_Diversi;
DELIMITER $$
CREATE TRIGGER Trigger_Conta_Dispositivi_Diversi AFTER INSERT ON Connessione
FOR EACH ROW
BEGIN

UPDATE Utente
SET Quanti_Dispositivi = Quanti_Dispositivi + 1
WHERE Id_Cliente = NEW.Id_Cliente;

END $$