DROP PROCEDURE IF EXISTS Stampa_Film_Consigliati_Attori;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Consigliati_Attori(IN Id_Utente INT)
BEGIN
        CALL Crea_Lista_Caratterizzazioni(Id_Utente);
        -- ora possiamo a seconda della scelta, classificare in base ai premi del film, in base all'attore e regista preferito
        CALL Stampa_Film_Attori_Preferiti();
        DROP TABLE Lista_Id_Genere;
        DROP TABLE Lista_Caratterizzazioni;
        DROP TABLE Lista_Id_Genere_Appoggio;
END $$

DELIMITER ;