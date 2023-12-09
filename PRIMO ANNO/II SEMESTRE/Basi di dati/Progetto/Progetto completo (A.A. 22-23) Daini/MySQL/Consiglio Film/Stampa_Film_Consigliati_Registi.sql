-- Active: 1647365195286@@127.0.0.1@3306@mydb
DROP PROCEDURE IF EXISTS Stampa_Film_Consigliati_Registi;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Consigliati_Registi(IN Id_Utente INT)
BEGIN

        CALL Crea_Lista_Caratterizzazioni(Id_Utente);
        -- ora possiamo a seconda della scelta, classificare in base ai premi del film, in base all'attore e regista preferito
        CALL Stampa_Film_Registi_Preferiti();
        DROP TABLE Lista_Id_Genere;
        DROP TABLE Lista_Caratterizzazioni;
        DROP TABLE Lista_Id_Genere_Appoggio;
END $$

DELIMITER ;