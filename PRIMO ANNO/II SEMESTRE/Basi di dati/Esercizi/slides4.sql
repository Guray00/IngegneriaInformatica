/*
 * Copyright 2017 Giuseppe Fabiano
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * 1. Indicare cognome e nome dei pazienti visitati almeno una volta da tutti i
 * cardiologi di Pisa nel primo trimestre del 2015.
 * [Risolvere in due modi diversi]
 */
SELECT P.Cognome,
    P.Nome
FROM Visita V
INNER JOIN Paziente P ON V.Paziente = P.CodFiscale
INNER JOIN Medico M ON V.Medico = M.Matricola
WHERE M.Specializzazione = 'Cardiologia'
    AND M.Citta = 'Pisa'
    AND year(V.Data) = 2015
    AND month(V.Data) BETWEEN 1
        AND 3
GROUP BY P.CodFiscale
HAVING count(DISTINCT M.Matricola) = (
        SELECT count(M1.Matricola)
        FROM Medico M1
        WHERE M1.Specializzazione = 'Cardiologia'
            AND M1.Citta = 'Pisa'
        );

/*
 * 2. Selezionare cognome e specializzazione dei medici la cui parcella è
 * superiore alla media delle parcelle della loro specializzazione e che,
 * nell’anno 2011, hanno visitato almeno un paziente che non avevano mai
 * visitato prima.
 */
SELECT DISTINCT M.Cognome,
    M.Specializzazione
FROM Medico M
INNER JOIN Visita V ON M.Matricola = V.Medico
WHERE M.Parcella > (
        SELECT avg(Parcella)
        FROM Medico M1
        WHERE M.Specializzazione = M1.Specializzazione
        )
    AND year(V.Data) = 2011
    AND 0 = (
        SELECT count(*)
        FROM Visita V1
        WHERE V1.Medico = V.Medico
            AND year(V1.Data) < year(V.Data)
        );

/*
 * 3. Impostare come mutuate (attributo omonimo pari a 1) tutte le visite
 * ortopediche che coinvolgono pazienti già visitati precedentemente almeno due
 * volte dallo stesso medico.
 */
UPDATE Visita V NATURAL JOIN (
    SELECT V1.*
    FROM Visita V1
    INNER JOIN Medico M ON V1.Medico = M.Matricola
    INNER JOIN Visita V2 ON (
            V1.Medico = V2.Medico
            AND V1.Paziente = V2.Paziente
            AND V1.Data > V2.Data
            )
    WHERE M.Specializzazione = 'Ortopedia'
    GROUP BY V1.Medico,
        V1.Paziente,
        V1.Data
    HAVING count(*) >= 2
    ) AS A
SET V.Mutuata = 1;

/* 4. Scrivere una query che restituisca nome e cognome del medico che,
 * al 31/12/2014, aveva visitato un numero di pazienti superiore a quelli 
 * visitati da ciascun medico della sua stessa specializzazione.
 */
SELECT M.Nome,
    M.Cognome
FROM Medico M
WHERE (
        SELECT COUNT(*)
        FROM Visita V
        WHERE V.Medico = M.Matricola
            AND V.Data <= '2014-12-31'
        ) >= ALL (
        SELECT COUNT(*)
        FROM Medico M1
        INNER JOIN Visita V1 ON M1.Matricola = V1.Medico
        WHERE V1.Data <= '2014-12-31'
            AND M1.Specializzazione = M.Specializzazione
        GROUP BY M1.Matricola
        );

/* 5. Scrivere una query che restituisca il codice fiscale dei pazienti che sono
 * stati visitati sempre dal medico avente la parcella più alta, in tutte le
 * specializzazioni. Se, anche per una sola specializzazione, non vi è un unico
 * medico avente la parcella più alta, la query non deve restituire alcun
 * risultato.
 */
CREATE OR REPLACE VIEW MediciParcelleMassime AS
SELECT M.Matricola,
    M.Specializzazione
FROM Medico M
WHERE M.Parcella = (
        SELECT MAX(Parcella)
        FROM Medico
        WHERE Specializzazione = M.Specializzazione
        )
GROUP BY M.Specializzazione,
    M.Parcella
HAVING count(*) = 1;

SELECT A.Paziente
FROM (
    SELECT V.*,
        count(*) AS NumeroVisite
    FROM Visita V
    WHERE (
            SELECT count(*)
            FROM MediciParcelleMassime
            ) = (
            SELECT count(DISTINCT Specializzazione)
            FROM Medico
            )
        AND V.Medico IN (
            SELECT Matricola
            FROM MediciParcelleMassime
            )
    GROUP BY V.Paziente
    ) AS A
WHERE A.NumeroVisite = (
        SELECT count(*)
        FROM Visita
        WHERE Paziente = A.Paziente
        );