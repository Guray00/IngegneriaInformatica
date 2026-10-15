# Domanda 1
> Quale delle seguenti affermazioni riguardo all'uso di subquery scalari in MySQL è falsa?

1. Una subquery scalare restituisce sempre un unico valore numerico
2. Se una subquery scalare restituisce più di un record, MySQL genera un errore
3. Nessuna delle altre alternative è falsa
4. Una subquery scalare può essere usata in una clausola WHERE, purché restituisca al più un record

---

# Domanda 2
> Dato lo schema di database usato a lezione:
> PAZIENTE (<u>CodFiscale</u>, Nome, Cognome, Sesso, DataNascita, Citta, Reddito)
> MEDICO (<u>Matricola</u>, Nome, Cognome, Specializzazione, Citta, Parcella)
> VISITA (<u>Paziente, Medico, Data</u>, Mutuata)
> 
> Considerata la query q a sinistra, quale delle query a destra è una versione join-equivalente?
> 
> **Query q:**
> ```mysql
> SELECT P.Nome, P.Cognome
> FROM Paziente P
> WHERE P.CodFiscale NOT IN (
>     SELECT Paziente
>     FROM Visita
>     WHERE Mutuata = 1
> );
> ```
> 
> **1)**
> ```mysql
> SELECT DISTINCT P.Nome, P.Cognome
> FROM Paziente P
> INNER JOIN
> Visita V ON P.CodFiscale = V.Paziente
> WHERE V.Mutuata = 0;
> ```
> 
> **2)**
> ```mysql
> SELECT DISTINCT P.Nome, P.Cognome
> FROM Paziente P
> LEFT OUTER JOIN
> Visita V ON P.CodFiscale = V.Paziente
> WHERE V.Mutuata = 0;
> ```
> 
> **3)**
> ```mysql
> SELECT DISTINCT P.Nome, P.Cognome
> FROM Paziente P
> LEFT OUTER JOIN
> Visita V ON P.CodFiscale = V.Paziente
> WHERE V.Mutuata = 0
> OR V.Paziente IS NULL;
> ```

1. Nessuna delle altre alternative è corretta
2. La query 1) è join-equivalente alla query q
3. La query 2) è join-equivalente alla query q
4. La query 3) è join-equivalente alla query q

---

# Domanda 3
> Sia T(<u>a</u>,b,c,d) una tabella usata nel FROM di una query q. Affinché q non generi record duplicati, è sufficiente che il SELECT di q contenga l'attributo 'a' oppure, se q fa uso di GROUP BY, un sottoinsieme proprio degli attributi di raggruppamento.

1. Vero
2. Falso

---

# Domanda 4
> Dato lo schema di database usato a lezione:
> PAZIENTE (<u>CodFiscale</u>, Nome, Cognome, Sesso, DataNascita, Citta, Reddito)
> MEDICO (<u>Matricola</u>, Nome, Cognome, Specializzazione, Citta, Parcella)
> VISITA (<u>Paziente, Medico, Data</u>, Mutuata)
> 
> che cosa restituisce la seguente query?
> ```mysql
> WITH Conti AS (
>     SELECT Paziente, Medico,
>     COUNT(*) AS C
>     FROM Visita
>     GROUP BY Paziente, Medico
> )
> SELECT Paziente, Medico,
> RANK() OVER(
>     PARTITION BY Paziente
>     ORDER BY C DESC
> ) AS Pos
> FROM Conti;
> ```

1. Nessuna delle altre alternative è corretta
2. Genera una classifica in cui, per ogni paziente p, un medico m è tanto più in alto in classifica quante più volte p è stato visitato da m
3. Genera una classifica in cui, per ogni paziente p, un medico m è tanto più in alto in classifica quanto più è piccolo il numero di visite che p ha effettuato con m
4. Genera una classifica in cui, per ogni medico m, un paziente p è tanto più in alto in classifica quante meno volte m ha visitato p

---

# Domanda 5
> Siano dati lo schema di relazione $R(A,B,C,D,E,F,G,H,I,J)$ ed il relativo insieme di dipendenze funzionali $F=\{ABD\rightarrow E, AB\rightarrow G, B\rightarrow F, C\rightarrow H, C\rightarrow I, G\rightarrow J\}$.
> Quale delle seguenti affermazioni è vera?

1. F è una copertura minimale.
2. A è un attributo estraneo in almeno una dipendenza funzionale.
3. Nessuna delle altre alternative è vera.
4. F contiene almeno una dipendenza ridondante.

---

# Domanda 6
> Quale delle seguenti alternative descrive una differenza tra COUNT(*) e COUNT(DISTINCT col) in MySQL, dove col è il nome di una colonna della tabella espressa nel FROM?

1. COUNT(*) esclude le righe in cui almeno una colonna è NULL, mentre COUNT(DISTINCT col) le include tutte
2. COUNT(*) conta tutte le righe, anche se contengono valori NULL, mentre COUNT(DISTINCT col) conta i valori diversi di col ad esclusione dei valori NULL
3. COUNT(DISTINCT col) restituisce sempre un valore minore o uguale a quello di COUNT(*)
4. Nessuna delle altre alternative è corretta

---

# Domanda 7
> Quale delle seguenti affermazioni sulla clausola GROUP BY è corretta?

1. Ogni colonna nella clausola SELECT deve essere aggregata
2. Nessuna delle altre alternative è corretta
3. La clausola GROUP BY può essere usata solo insieme alla clausola HAVING
4. Data una query con GROUP BY, questa restituisce un insieme di record rappresentativi per ciascun gruppo

---

# Domanda 8
> Sia $R(A,B,C,D)$ uno schema di relazione. Usando le regole di inferenza di Armstrong, quale delle seguenti derivazioni è falsa?

1. $\{AB\rightarrow D\}\models ABC\rightarrow D$
2. $\{C\rightarrow B, A\rightarrow D\}\models AC\rightarrow B$
3. Nessuna delle altre alternative è falsa
4. $\{AB\rightarrow D, B\rightarrow C\}\models AC\rightarrow D$

---

# Domanda 9
> Dato lo schema di database usato a lezione:
> PAZIENTE (<u>CodFiscale</u>, Nome, Cognome, Sesso, DataNascita, Citta, Reddito)
> MEDICO (<u>Matricola</u>, Nome, Cognome, Specializzazione, Citta, Parcella)
> VISITA (<u>Paziente, Medico, Data</u>, Mutuata)
> 
> cosa restituisce la seguente query?
> ```mysql
> SELECT DISTINCT P.Nome, P.Cognome
> FROM Paziente P
> INNER JOIN
> Visita V ON P.CodFiscale = V.Paziente
> WHERE V.Mutuata = 0;
> ```

1. Nessuna delle altre alternative è corretta
2. Nome e cognome dei pazienti che hanno almeno una visita non mutuata
3. Nome e cognome dei pazienti che non hanno effettuato visite non mutuate
4. Nome e cognome dei pazienti che non hanno mai effettuato visite mutuate

---

# Domanda 10
> In MySQL, quale delle seguenti alternative descrive una differenza tra LEFT OUTER JOIN e INNER JOIN?

1. LEFT OUTER JOIN può restituire record in cui tutte le colonne della tabella di destra assumono valore NULL, mentre ciò non può mai accadere con INNER JOIN.
2. LEFT OUTER JOIN restituisce solo i record della tabella di sinistra per i quali esiste almeno un record della tabella di destra che soddisfa il predicato di join, mentre INNER JOIN restituisce tutti i record da entrambe le tabelle
3. Nessuna delle altre alternative è corretta
4. INNER JOIN ottiene lo stesso risultato di un LEFT OUTER JOIN seguito da un'opportuna clausola WHERE sulle colonne della tabella di sinistra, volta a eliminare i record di troppo che LEFT OUTER JOIN preserva

---

# Domanda 11
> Si consideri lo schedule $S=w2(x)r1(x)w1(x)r2(x)$ composto dalle transazioni T1 e T2. Quale delle seguenti affermazioni è vera?

1. S è view-equivalente allo schedule seriale T1T2.
2. Nessuna delle altre affermazioni è vera.
3. S è view-equivalente allo schedule seriale T2T1.
4. S non è view-serializzabile.

---

# Domanda 12
> Quale delle seguenti affermazioni sulla forma normale di Boyce-Codd (BCNF) è vera?

1. Se uno schema di relazione è in BCNF allora ha un'unica chiave.
2. Determinare se uno schema di relazione in BCNF preserva le dipendenze funzionali ha complessità polinomiale.
3. Se uno schema di relazione è in 3NF allora è in BCNF.
4. Nessuna delle altre affermazioni è vera.

---

# Domanda 13
> Sia $R(A,B,C,D)$ uno schema di relazione con $F=\{A\rightarrow B, B\rightarrow C, C\rightarrow D, D\rightarrow A\}$.
> Data la decomposizione di R in $R1(A,B)$, $R2(B,C)$, $R3(C,D)$, quale delle seguenti affermazioni è vera?

1. La decomposizione preserva i dati ma non le dipendenze funzionali.
2. Nessuna delle altre alternative è vera.
3. La decomposizione preserva le dipendenze funzionali ma non i dati.
4. La decomposizione preserva i dati e le dipendenze funzionali.

---

# Domanda 14
> Dato lo schema di database usato a lezione:
> PAZIENTE (<u>CodFiscale</u>, Nome, Cognome, Sesso, DataNascita, Citta, Reddito)
> MEDICO (<u>Matricola</u>, Nome, Cognome, Specializzazione, Citta, Parcella)
> VISITA (<u>Paziente, Medico, Data</u>, Mutuata)
> 
> e la richiesta:
> Selezionare il codice fiscale dei pazienti che, quest'anno, hanno speso più di 500 Euro per visite effettuate da medici di ciascuna di almeno due città diverse, e qual è stato il numero di medici che hanno visitato questi pazienti in ogni specializzazione, considerando tutte le città nel complesso.
> 
> Quale delle seguenti alternative contiene una query che esprime la richiesta in MySQL?

1. Nessuna delle altre alternative è corretta
2. 
```mysql
WITH PazientiValidi AS (
    SELECT V.Paziente
    FROM Visita V
    INNER JOIN
    Medico M ON V.Medico = M.Matricola
    WHERE YEAR(V.Data) = YEAR(CURRENT_DATE)
    GROUP BY V.Paziente, M.Citta
    HAVING SUM(M.Parcella) > 500
)
SELECT V.Paziente,
M.Specializzazione,
COUNT(DISTINCT M.Matricola)
FROM Visita V
INNER JOIN
Medico M ON V.Medico = M.Matricola
WHERE YEAR(V.Data) = YEAR(CURRENT_DATE)
AND V.Paziente IN (
    SELECT Paziente
    FROM PazientiValidi
    GROUP BY Paziente
    HAVING COUNT(*) >= 2
)
GROUP BY V.Paziente, M.Specializzazione, M.Citta;
```
3. 
```mysql
WITH PazientiValidi AS (
    SELECT V.Paziente
    FROM Visita V
    INNER JOIN
    Medico M ON V.Medico = M.Matricola
    WHERE YEAR(V.Data) = YEAR(CURRENT_DATE)
    GROUP BY V.Paziente, M.Citta
    HAVING SUM(M.Parcella) > 500
)
SELECT V.Paziente,
M.Specializzazione,
COUNT(DISTINCT M.Matricola)
FROM Visita V
INNER JOIN
Medico M ON V.Medico = M.Matricola
WHERE YEAR(V.Data) = YEAR(CURRENT_DATE)
AND V.Paziente IN (
    SELECT Paziente
    FROM PazientiValidi
    GROUP BY Paziente
    HAVING COUNT(*) >= 2
)
GROUP BY V.Paziente, M.Specializzazione;

```
4. 
```mysql
WITH PazientiValidi AS (
    SELECT DISTINCT V1.Paziente
    FROM Visita V1
    INNER JOIN
    Medico M1 ON V1.Medico = M1.Matricola
    INNER JOIN
    Visita V2 ON V1.Paziente = V2.Paziente
    INNER JOIN
    Medico M2 ON V2.Medico = M2.Matricola
    WHERE YEAR(V1.Data) = YEAR(CURRENT_DATE)
    AND YEAR(V2.Data) = YEAR(CURRENT_DATE)
    AND M1.Citta <> M2.Citta
    GROUP BY V1.Paziente
    HAVING SUM(M1.Parcella) > 500
    AND SUM(M2.Parcella) > 500
)
SELECT V.Paziente,
M.Specializzazione,
COUNT(DISTINCT M.Matricola)
FROM Visita V
INNER JOIN
Medico M ON V.Medico = M.Matricola
NATURAL JOIN
PazientiValidi PV
WHERE YEAR(V.Data) = YEAR(CURRENT_DATE)
GROUP BY V.Paziente, M.Specializzazione;

```

---

# Domanda 15

> In una stored procedure MySQL, a cosa serve la clausola DECLARE CONTINUE HANDLER FOR NOT FOUND?

1. A gestire gli errori generici che causano l'interruzione immediata della procedura, come divisioni per zero o violazioni di vincoli
2. Nessuna delle altre alternative è corretta
3. È tipicamente usata per intercettare la situazione in cui un'istruzione FETCH non restituisce record
4. A indicare che, in caso di assenza di corrispondenza in una SELECT INTO, la procedura deve saltare il blocco corrente e terminare senza errore

---

# Domanda 16

> Quale delle seguenti affermazioni riguardo alle stored procedure in MySQL è corretta?

1. Una stored procedure può essere caratterizzata da più parametri IN e al più un parametro OUT
2. Una variabile dichiarata con DECLARE all'interno di una stored procedure può essere usata anche all'esterno della procedura
3. Un parametro OUT deve essere sempre oggetto di un assegnamento eseguito tramite un'istruzione SET o SELECT INTO
4. Nessuna delle altre alternative è corretta

---

# Domanda 17

> Quale delle seguenti caratteristiche deve essere posseduta da uno scheduler?

1. Deve poter verificare la proprietà di view-serializzabilità di uno schedule in modo efficiente.
2. Nessuna delle altre alternative è corretta.
3. Deve poter verificare la proprietà di conflict-serializzabilità di uno schedule in modo efficiente.
4. Deve poter risolvere tutte le anomalie di uno schedule in modo efficiente.

---

# Domanda 18

> Dato il seguente schema di relazione $R(A,B,C,D,E,H)$ e il seguente insieme di dipendenze funzionali $F=\{AB\rightarrow CD, C\rightarrow E, ABC\rightarrow D\}$. Quale delle seguenti decomposizioni di R è in 3NF?

1. $R(A,B,C,D,E,H)$
2. $R1(A,B,C,D), R2(C,E), R3(A,B,H)$
3. $R1(A,B,C,D,E), R2(C,H)$
4. Nessuna delle decomposizioni indicate è in 3NF.

---

# Domanda 19

> Quale delle seguenti alternative riguardo all'aggiornamento (UPDATE) di una tabella T in MySQL è falsa?

1. MySQL impedisce di fare riferimento direttamente alla tabella target T in una UPDATE se tale riferimento è nel FROM
2. Nessuna delle altre alternative è falsa
3. Non è possibile aggiornare la tabella T in base a una condizione che coinvolge record della stessa tabella T
4. È possibile aggiornare la tabella T in base a una condizione che coinvolge record della stessa tabella T usando una derived table che legge da T
