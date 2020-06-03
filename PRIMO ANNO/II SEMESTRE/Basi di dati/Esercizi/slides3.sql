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
 * 1) Indicare le specializzazioni che hanno solo medici della stessa città.
 * [Risolvere con e senza subquery].
 */
-- subquery
SELECT M.Specializzazione
FROM Medico M
WHERE M.Specializzazione NOT IN (
        SELECT M1.Specializzazione
        FROM Medico M1
        WHERE M1.Specializzazione = M.Specializzazione
            AND M.Citta <> M1.Citta
        )
GROUP BY M.Specializzazione;

SELECT M.Specializzazione
FROM Medico M
GROUP BY M.Specializzazione
HAVING count(DISTINCT M.Citta) = 1;

/* 
 * 2. Considerando pazienti della stessa città, indicare il numero di medici di
 * città diversa dalla loro, dai quali sono stati visitati.
 */
SELECT P.Citta,
    count(DISTINCT M.Matricola)
FROM Paziente P
INNER JOIN Visita V ON P.CodFiscale = V.Paziente
INNER JOIN Medico M ON V.Medico = M.Matricola
WHERE P.Citta <> M.Citta
GROUP BY P.Citta;

/* 
 * 3. Indicare la specializzazione più redditizia per la clinica, e il medico
 * che, con le sue visite, ha contribuito maggiormente agli incassi realizzati
 * da tale specializzazione, nel corso degli ultimi dieci anni.
 * In caso di pari merito, restituire tutti gli ex aequo.
 */
CREATE OR replace VIEW IncassoMedico AS
SELECT M.Specializzazione,
    M.Matricola,
    sum(Parcella) AS Incasso
FROM Medico M
INNER JOIN Visita V ON M.Matricola = V.Medico
WHERE CURRENT_DATE () - interval 10 year <= V.Data
GROUP BY M.Specializzazione,
    M.Matricola;

-- select * from IncassoMedico;
SELECT Specializzazione,
    Matricola
FROM IncassoMedico IM
WHERE IM.Specializzazione IN (
        SELECT IM1.Specializzazione
        FROM IncassoMedico IM1
        GROUP BY IM1.Specializzazione
        HAVING sum(IM1.Incasso) = (
                SELECT max(Incasso)
                FROM (
                    SELECT sum(IM2.Incasso) AS Incasso
                    FROM IncassoMedico IM2
                    GROUP BY IM2.Specializzazione
                    ) AS A
                )
        )
    AND IM.Matricola IN (
        SELECT IM1.Matricola
        FROM IncassoMedico IM1
        WHERE IM1.Specializzazione = IM.Specializzazione
            AND IM1.Incasso = (
                SELECT max(Incasso)
                FROM IncassoMedico IM2
                WHERE IM2.Specializzazione = IM1.Specializzazione
                )
        );

/*
 * 4. Indicare La specializzazione avente più medici di tutte le altre e quanti
 * medici ha. In caso di pari merito, restituire tutti gli ex aequo.
 * [Risolvere con e senza subquery].
 */
CREATE OR replace VIEW NumMediciSpecializzazione AS
SELECT M.Specializzazione,
    count(M.Matricola) AS NMedici
FROM Medico M
GROUP BY M.Specializzazione;

-- con subquery
SELECT NMS.Specializzazione,
    NMS.NMedici
FROM NumMediciSpecializzazione NMS
WHERE NMS.NMedici = (
        SELECT max(NMedici)
        FROM NumMediciSpecializzazione
        );

-- no subquery [derived table]
SELECT NMS.Specializzazione,
    NMS.NMedici
FROM NumMediciSpecializzazione NMS
INNER JOIN (
    SELECT max(NMedici) AS max
    FROM NumMediciSpecializzazione
    ) AS L ON NMS.NMedici = L.max

/*
 * 5. Considerate le sole visite otorinolaringoiatriche, scrivere una query che
 * restituisca il numero di pazienti, ad oggi maggiorenni, che sono stati
 * visitati solo da otorini di Firenze durante il primo trimestre del 2015.
 */
CREATE OR REPLACE VIEW MaggiorenniVisitatiDaOtorini2015Q1 AS
SELECT V.Paziente,
    V.Medico,
    M.Citta
FROM Visita V
INNER JOIN Medico M ON V.Medico = M.Matricola
INNER JOIN Paziente P ON V.Paziente = P.CodFiscale
WHERE M.Specializzazione = 'Otorinolaringoiatria'
    AND P.DataNascita + INTERVAL 18 YEAR <= CURRENT_DATE
    AND YEAR(Data) = 2015
    AND MONTH(Data) BETWEEN 1 AND 3;

SELECT COUNT(DISTINCT MVDO.Paziente)
FROM MaggiorenniVisitatiDaOtorini2015Q1 MVDO
WHERE MVDO.Paziente NOT IN (
        SELECT Paziente
        FROM MaggiorenniVisitatiDaOtorini2015Q1 MVDO1
        WHERE MVDO1.Citta <> 'Firenze'
        );
