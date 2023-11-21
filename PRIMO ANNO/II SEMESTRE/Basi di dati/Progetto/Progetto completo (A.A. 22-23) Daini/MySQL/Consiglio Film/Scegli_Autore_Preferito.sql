DROP PROCEDURE IF EXISTS Stampa_Film_Attore_Preferiti;
DELIMITER $$
CREATE PROCEDURE Stampa_Film_Attore_Preferiti(IN Id INT,IN Genere VARCHAR(100),IN Id_Attore INT)
BEGIN

        --variabili utili per la stampa

        -- variabili per calcolare il peso dell'autore da restituire con una function

        SELECT  F.Id_Film,F.Titolo,I.Id_Artista,A.Nome,A.Cognome,PA.Peso,PA.Nome,PA.Istituzione
        FROM    Film F NATURAL JOIN Interpretazione I NATURAL JOIN Attore A NATURAL JOIN Premiazione_Attore PAT NATURAL JOIN Premio_Attore PA 
        WHERE   F.Id_Film = Id AND F.Genere = Genere AND A.Id_Artista = Id_Attore;

END $$

DELIMITER ;