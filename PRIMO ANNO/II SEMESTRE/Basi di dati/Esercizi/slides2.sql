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
 * 1) Indicare l’incasso totale degli ultimi due anni, realizzato grazie alle
 * visite dei medici cardiologi della clinica.
 */
SELECT sum(Parcella)
FROM Medico AS M
INNER JOIN Visita AS V ON M.Matricola = V.Medico
WHERE M.Specializzazione = 'Cardiologia'
    AND CURRENT_DATE - INTERVAL 2 year <= V.Data;

/*
 * 2) Indicare il numero di pazienti di sesso femminile che, nel quindicesimo
 * anno d’età, sono stati visitati, una o più volte, sempre dallo
 * stesso ginecologo.
 */
SELECT count(DISTINCT V.Paziente)
FROM Visita V
INNER JOIN Paziente P ON V.Paziente = P.CodFiscale
INNER JOIN Medico M ON M.Matricola = V.Medico
WHERE P.sesso = 'F'
    AND V.Data >= P.DataNascita + INTERVAL 14 year
    AND V.Data <= P.DataNascita + INTERVAL 15 year
    AND M.Specializzazione = 'Ginecologia'
    AND P.CodFiscale NOT IN (
        SELECT V1.Paziente
        FROM Visita V1
        INNER JOIN Medico M1 ON M1.Matricola = V1.Medico
        WHERE V.Paziente = V1.Paziente
            AND M.Specializzazione = M1.Specializzazione
            AND M.Matricola <> M1.Matricola
        );

-- Soluzione con raggruppamento, potresti ancora non averlo affrontato a lezione
SELECT COUNT(A.Paziente)
FROM (
    SELECT V.Paziente
    FROM Visita V
    INNER JOIN Paziente P ON V.Paziente = P.CodFiscale
    INNER JOIN Medico M ON M.Matricola = V.Medico
    WHERE P.sesso = 'F'
        AND V.Data >= P.DataNascita + INTERVAL 14 year
        AND V.Data <= P.DataNascita + INTERVAL 15 year
        AND M.Specializzazione = 'Ginecologia'
    GROUP BY V.Paziente
    HAVING COUNT(DISTINCT V.Medico) = 1
) as A;

/*
 * 3) Indicare codice fiscale, nome e cognome ed età del paziente più anziano
 * della clinica, e il numero di medici dai quali è stato Visitato.
 */
SELECT P.Nome, P.Cognome, count(DISTINCT V.Medico)
FROM Paziente P
INNER JOIN Visita V ON P.CodFiscale = V.Paziente
WHERE P.DataNascita = (
        SELECT min(DataNascita)
        FROM Paziente
        );

/*
 * 4) Indicare nome e cognome dei pazienti che sono stati visitati non meno
 * di due volte dalla dottoressa Gialli Rita.
 */
SELECT DISTINCT P.Nome, P.Cognome
FROM Paziente P
INNER JOIN Visita V ON P.CodFiscale = V.Paziente
INNER JOIN Medico M ON V.Medico = M.Matricola
WHERE M.Nome = 'Rita'
    AND M.Cognome = 'Gialli'
    AND P.CodFiscale IN (
        SELECT V1.Paziente
        FROM Visita V1
        INNER JOIN Medico M1 ON V1.Medico = M1.Matricola
        WHERE V1.Paziente = P.CodFiscale
            AND M.Matricola = M1.Matricola
            AND V.Data <> V1.Data
        );

/*
 * 5) Indicare il reddito medio dei pazienti che sono stati visitati solo da
 * medici con Parcella superiore a 100 euro, negli ultimi sei mesi.
 * [Risolvere solo con noncorrelated subquery e scrivere
 *  la versione join-equivalente].
 */
-- noncorrelated subquery
SELECT avg(Reddito)
FROM (
    SELECT DISTINCT P.CodFiscale, P.reddito
    FROM Paziente P
    INNER JOIN Visita V ON P.CodFiscale = V.Paziente
    WHERE V.Data > CURRENT_DATE - INTERVAL 6 MONTH
        AND P.CodFiscale NOT IN (
            SELECT V1.Paziente
            FROM Visita V1
            INNER JOIN Medico M ON V1.Medico = M.Matricola
            WHERE V1.Data > CURRENT_DATE - INTERVAL 6 MONTH
                AND M.Matricola IN (
                    SELECT M1.Matricola
                    FROM Medico M1
                    WHERE M1.Parcella <= 100
                    )
            )
    ) AS A;

-- join equivalente
SELECT avg(Reddito)
FROM (
    SELECT DISTINCT P.CodFiscale, P.reddito, C.Paziente as Flag
    FROM Paziente P
    INNER JOIN Visita V ON P.CodFiscale = V.Paziente
    LEFT OUTER JOIN (
            SELECT V1.Paziente
            FROM Visita V1
            INNER JOIN Medico M ON V1.Medico = M.Matricola and
            V1.Data > CURRENT_DATE - INTERVAL 6 MONTH
            AND M.Parcella <= 100
        ) AS C ON V.Paziente = C.Paziente
    WHERE V.Data > CURRENT_DATE - INTERVAL 6 MONTH
        /* A causa di un bug di mysql il controllo commentato va spostato fuori
         * dalla derived table, l'ho chiamato Flag per comodità :( */
        -- AND C.Paziente IS NULL
    ) AS D
WHERE Flag IS NULL;
