-- Active: 1647365195286@@127.0.0.1@3306@mydb
DROP TRIGGER IF EXISTS Trigger_Inserimento_Carta;
DELIMITER $$
CREATE TRIGGER Trigger_Inserimento_Carta BEFORE INSERT ON Carta
FOR EACH ROW
BEGIN

DECLARE PAN_test VARCHAR(19) DEFAULT '';
DECLARE lunghezza_PAN INT DEFAULT 0;

SET PAN_test = NEW.Pan;
SET lunghezza_PAN = LENGTH(PAN_test);

IF lunghezza_PAN < 16 THEN

    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lunghezza del carattere PAN inferiore a 16. Inserire un PAN con lunghezza compresa fra 16 e 19';

END IF;

END $$

DELIMITER ;