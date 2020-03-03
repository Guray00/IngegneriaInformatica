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
 * 1) Indicare matricola e da quanti giorni risultavano iscritti gli studenti,
 * che non si erano ancora laureati il 15 Luglio 2005.
 */

SELECT Matricola,
       DATEDIFF('2005-07-15', DataIscrizione)
FROM studente
WHERE DataIscrizione < '2005-07-15'
    AND (DataLaurea IS NULL
         OR DataLaurea > '2005-07-15');

/* 
 * 2) Indicare matricola e cognome degli studenti il cui percorso di studi è
 * durato (o dura da) oltre sei anni.
 * [Risolvere con e senza l’uso di INTERVAL]
 */

-- Soluzione con INTERVAL
SELECT Matricola,
       Cognome
FROM studente
WHERE (DataLaurea IS NULL
       AND DataIscrizione + INTERVAL 6 YEAR < current_date())
    OR (DataIscrizione + INTERVAL 6 YEAR < DataLaurea);

-- Soluzione senza INTERVAL
SELECT Matricola,
       Cognome
FROM studente
WHERE (DataLaurea IS NULL
        AND period_diff(date_format(current_date(), '%Y%m'),
                        date_format(DataIscrizione, '%Y%m')
                        ) > 72
      )
    OR period_diff(date_format(DataLaurea, '%Y%m'),
                   date_format(DataIscrizione, '%Y%m')
                   ) > 72;

/*
 * 3) Indicare il numero medio di esami sostenuti dagli studenti nati nel 1987,
 * iscritti con un anno di anticipo all’università, ad oggi non ancora laureati.
 */

SELECT AVG(NumeroEsamiSostenuti)
FROM studente
WHERE (DATE_FORMAT(DataNascita, "%Y") = 1987)
    AND DataLaurea IS NULL
    AND YEAR(DataIscrizione)-YEAR(DataNascita) = 18;

/*
 * 4) Indicare nome, cognome ed età degli studenti laureati quest’anno in
 * Lettere (durata standard 5 anni a ciclo unico), non fuori corso e come minimo
 * con un anticipo di sei mesi rispetto alla durata standard
 */

SELECT *
FROM studente
WHERE Facolta = "Lettere"
    AND YEAR(DataLaurea) = YEAR(current_date())
    AND YEAR(DataIscrizione) + 5 = YEAR(DataLaurea)
    AND MONTH(DataLaurea) <= 6;

/*
 * 5) Indicare il numero di studenti che si sono laureati nel 2005, dopo
 * il compimento del ventisettesimo anno d’età, e la loro età media al momento
 * della laurea.
 * [Risolvere l’esercizio con e senza l’uso di INTERVAL]
 */

-- Soluzione con INTERVAL
SELECT COUNT(*),
       AVG(YEAR(DataLaurea) - YEAR(DataNascita))
FROM studente
WHERE YEAR(DataLaurea) = 2005
    AND DataNascita + INTERVAL 27 YEAR < DataLaurea;

-- Soluzione senza INTERVAL
SELECT COUNT(*),
       AVG(YEAR(DataLaurea) - YEAR(DataNascita))
FROM studente
WHERE YEAR(DataLaurea) = 2005 AND
      YEAR(DataNascita) + 27 <= YEAR(DataLaurea)
    AND ( YEAR(DataNascita) + 27 < YEAR(DataLaurea)
          OR (MONTH(DataNascita) <= MONTH(DataLaurea)
              AND (
                    MONTH(DataNascita) < MONTH(DataLaurea)
                    OR DAY(DataNascita) < DAY(DataLaurea)
                    )
              )
        )
    ;

/*
 * 6) Indicare il numero di mesi impiegati per laurearsi dallo studente 
 * più veloce fra quelli laureati in pari, iscritti nel 2001. (Laureati in pari
 * significa non oltre il mese di Aprile del 6° anno dall’iscrizione.)
 */

SELECT MIN(PERIOD_DIFF
            (
              DATE_FORMAT(DataLaurea, "%Y%m"),
              DATE_FORMAT(DataIscrizione, "%Y%m")
            )
          ) as ANS
FROM studente
WHERE Facolta = "Ingegneria Meccanica"
    AND DATE_FORMAT(DataIscrizione, "%Y") = 2001
    AND DataIscrizione + INTERVAL 6 YEAR + INTERVAL 4 MONTH >= DataLaurea;

/*
 * 7) Indicare matricola e durata in mesi del percorso di studi degli studenti
 * laureati fuori corso, cioè oltre il mese di Aprile del 6° anno,
 * nell’anno accademico 2009-2010.
 */

SELECT Matricola,
       PERIOD_DIFF(
                    DATE_FORMAT(DataLaurea, "%Y%m"),
                    DATE_FORMAT(DataIscrizione, "%Y%m")
                  ) as ANS
FROM studente
WHERE DataLaurea IS NOT NULL
    AND (
          (
            YEAR(DataLaurea) = 2009
            AND MONTH(DataLaurea) >= 9
          )
          OR 
          (
            YEAR(DataLaurea) = 2010
            AND MONTH(DataLaurea) <= 8
          )
        )
    AND DataIscrizione + INTERVAL 6 YEAR + INTERVAL 4 MONTH < DataLaurea;
