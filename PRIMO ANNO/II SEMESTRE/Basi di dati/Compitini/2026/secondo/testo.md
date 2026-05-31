# Domanda 1

> Sia R(X) uno schema di relazione e siano Y, Z $\subseteq$ X e non vuoti. Quale delle seguenti affermazioni descrive correttamente il significato di Y $\to$ Z?

1. Per ogni coppia di tuple t1, t2 di ogni istanza valida di R, se t1\[Z] = t2\[Z], allora t1\[Y] = t2\[Y]
2. Nessuna delle altre alternative è corretta.
3. Per ogni coppia di tuple t1, t2 di ogni istanza valida di R, se t1\[Y] = t2\[Y], allora t1\[Z] = t2\[Z]
4. Y $\to$ Z vale se, in almeno una particolare istanza osservata di R, ogni valore di Y compare una sola volta

<details><summary>Risposta corretta</summary>3</details>

# Domanda 2

> Si consideri lo schedule S = r1(x) w2(x) w1(x) w3(x) r4(z) r3(z) w4(z). Quale delle seguenti affermazioni è corretta?

1. S è conflict-serializzabile
2. Nessuna delle altre alternative è corretta
3. S non è view-serializzabile
4. S è view-serializzabile, ma non è conflict-serializzabile

<details><summary>Risposta corretta</summary>4</details>

# Domanda 3

> Data la query sotto a sinistra, eseguita sulla tabella sotto a destra, quale delle seguenti affermazioni è vera?

```MYSQL
SELECT *
FROM T T1
	NATURAL JOIN
	T T2;
```

| **A** | **B** | **C** | **D**      |
| ----- | ----- | ----- | ---------- |
| 1     | b1    | c1    | 2023-03-15 |
| 2     | b2    | c2    | 2023-07-22 |
| 3     | b1    | c3    | 2024-01-10 |
| 4     | b3    | c1    | *(NULL)*   |
| 5     | b1    | c2    | 2024-05-01 |
| 6     | b2    | c3    | *(NULL)*   |
1. Restituisce lo stesso result set del prodotto cartesiano di T con se stessa
2. Restituisce un result set la cui cardinalità è inferiore a quella di T
3. Nessuna delle altre alternative è corretta
4. Restituisce un result set la cui cardinalità è superiore a quella di T

<details><summary>Risposta corretta</summary>2</details>

# Domanda 4

> Sia dato lo schema di relazione R(ABCD, F) con insieme di dipendenze funzionali F = {A $\to$ B, C $\to$ D, B $\to$ C}. Quale delle seguenti dipendenze funzionali è logicamente implicata da F?

1. Nessuna delle altre alternative è corretta
2. A $\to$ D
3. D $\to$ A
4. C $\to$ A

<details><summary>Risposta corretta</summary>2</details>

# Domanda 5

> Considerate le tabelle T(<u>A</u>,B,C,D) ed S(<u>E</u>,F,G) delle quali, a titolo di esempio, è mostrata un'istanza sotto a destra, qual è la versione join-equivalente della query sotto a sinistra?

Query:
```MYSQL
WITH T1 AS (
	SELECT A,D
	FROM T
	WHERE B <> 'b2'
)
SELECT A
FROM T1
WHERE NOT EXISTS (
	SELECT *
	FROM S
	WHERE S.G = T1.D
);
```

Tabella T

| **A** | **B**    | **C**    | **D**      |
| ----- | -------- | -------- | ---------- |
| 1     | b1       | c1       | 2023-03-15 |
| 2     | b2       | c3       | 2023-07-22 |
| 3     | b1       | *(NULL)* | 2024-01-10 |
| 4     | b3       | c2       | *(NULL)*   |
| 5     | *(NULL)* | c4       | 2024-05-01 |
| 6     | b2       | c1       | *(NULL)*   |

Tabella S

| **E** | **F**    | **G**      |
| ----- | -------- | ---------- |
| 1     | f1       | 2023-03-15 |
| 2     | f2       | *(NULL)*   |
| 3     | *(NULL)* | 2024-01-10 |
1. ```MYSQL
   SELECT T.A
   FROM T LEFT OUTER JOIN S ON T.D = S.G
   WHERE T.B <> 'b2' AND S.F IS NOT NULL;
   ```
2. Nessuna delle altre alternative contiene una versione join-equivalente della query *q*
3. ```MYSQL
	SELECT DISTINCT T.A
    FROM T INNER JOIN S ON T.D <> S.G
    WHERE T.B <> 'b2';
    ```
4. ```MYSQL
	SELECT T.A
	FROM T LEFT OUTER JOIN S ON T.D = S.G
	WHERE T.B <> 'b2' AND S.G IS NULL;
	```

<details><summary>Risposta corretta</summary>4</details>

# Domanda 6

> Considerato il seguente database:
> MEDICO(<u>Matricola</u>, Cognome, Nome, Citta, Specializzazione, Parcella)
> PAZIENTE(<u>CodFiscale</u>, Cognome, Nome, Citta, Reddito)
> VISITA(<u>Medico, Paziente, Data</u>, Mutuata)
> Quale delle seguenti query contiene la divisione insiemistica?

1. Selezionare la data delle visite effettuate da tutti i pazienti di Roma
2. Nessuna delle altre alternative è corretta
3. Selezionare la matricola dei medici che hanno visitato pazienti tutti provenienti da Roma
4. Restituire il reddito medio di tutti i medici della clinica

<details><summary>Risposta corretta</summary>2</details>

# Domanda 7

> In MySQL, un trigger definito come `BEFORE INSERT` su una tabella viene eseguito:

1. Nessuna delle altre alternative è corretta
2. Dopo che la riga è stata inserita fisicamente nella tabella; può leggere `NEW` ma non modificarne i valori
3. Prima che la riga venga inserita nella tabella; può modificare i valori di `NEW` prima che vengano scritti e può sollevare un errore con `SIGNAL` per annullare l'operazione
4. Prima che la riga venga inserita nella tabella; può modificare i valori di `NEW` prima che vengano scritti, ma non può impedire l'inserimento con `SIGNAL`

<details><summary>Risposta corretta</summary>3</details>

# Domanda 8

\[DOMANDA MANCANTE\]

# Domanda 9

> Quale tra le seguenti rappresenta una differenza tra `EXISTS` e `IN`, quando si usa una subquery?

1. `EXISTS` valuta se un valore specifico è contenuto nell'insieme restituito dalla subquery; `IN` valuta solo se la subquery restituisce almeno un record, indipendentemente dai valori
2. Possono precedere entrambi una subquery correlata o non correlata
3. `EXIST` precede sempre una subquery correlata che viene eseguita per ogni record della subquery, restituendo vero se produce almeno una record. Quando si usa `IN`, la subquery viene eseguita una volta sola
4. Nessuna delle altre alternative è corretta

<details><summary>Risposta corretta</summary>2,4</details>

# Domanda 10

> Sia dato lo schema di relazione R(ABC, F) con insieme di dipendenze funzionali F = \{AB $\to$ C, C $\to$ B\}. Quale delle seguenti affermazioni è corretta?

1. R è in BCNF
2. R è in 3NF
3. R non è in 3NF
4. Nessuna delle altre alternative è corretta

<details><summary>Risposta corretta</summary>2</details>

# Domanda 11

> Si consideri lo schedule S = r1(x) r2(z) w1(z) w2(x) r3(x) w3(z). Quale delle seguenti affermazioni è corretta?

1. S è seriale
2. Nessuna delle altre alternative è corretta
3. S non è conflict-serializzabile
4. S è conflict-serializzabile

<details><summary>Risposta corretta</summary>3</details>

# Domanda 12

> Dato lo schema di base di dati usato a lezione:
> PAZIENTE(<u>CodFiscale</u>, Cognome, Nome, Citta, Reddito)
> MEDICO(<u>Matricola</u>, Cognome, Nome, Specializzazione, Citta, Parcella)
> VISITA(<u>Medico, Paziente, Data</u>, Mutuata)
> considerare la stored procedure creata eseguendo il codice riportato di seguito. Cosa contiene la variabile `@res` dopo la chiamata `CALL proc('Pisa', @res)`?

```MYSQL
DELIMITER $$
CREATE PROCEDURE proc(IN _citta CHAR(100), OUT tot INTEGER)
BEGIN
	DECLARE paz CHAR(100) DEFAULT '';
	DECLARE finito INTEGER DEFAULT 0;
	DECLARE s INTEGER DEFAULT 0;
	DECLARE cur CURSOR FOR
	SELECT DISTINCT V.Paziente
	FROM Visita V INNER JOIN Medico M
		ON V.Medico = M.Matricola
	WHERE M.CItta = _citta;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND
	SET finito = 1;
	
	OPEN cur;
	
	scan: LOOP
		FETCH cur INTO paz;
		IF finito = 1 THEN
			LEAVE scan;
		END IF;
		SET s = s+1;
	END LOOP scan;
	
	CLOSE cur;
	
	SET tot = s;
END $$
DELIMITER ;
```

<details><summary>Risposta corretta</summary>Numero pazienti visitati da almeno un medico di Pisa<br><i>Altre risposte non disponibili</i></details>

# Domanda 13

> Nel pattern di utilizzo di un cursore MySQL visto a lezione per scorrere i record del result set a esso associato, qual è il ruolo dell'handler `NOT FOUND`?

1. Settare una variabile di controllo a 1 quando, dopo l'esecuzione dell'istruzione `FETCH`, non c'è alcun record da processare, e interrompere il ciclo di lettura
2. Settare una variabile di controllo a 1 quando, dopo l'esecuzione dell'istruzione `FETCH`, non c'è alcun record da processare
3. Monitorare una variabile di controllo ad ogni iterazione, e uscire dal ciclo quando il suo valore è 1
4. Nessuna delle altre alternative è corretta

<details><summary>Risposta corretta</summary>2</details>

# Domanda 14

> Quale delle seguenti affermazioni è corretta?

1. Uno schedule prodotto da uno scheduler 2PL può non essere conflict-serializzabile
2. Ogni schedule view-serializzabile è generabile da uno scheduler 2PL
3. Nessuna delle altre alternative è corretta
4. Ogni schedule conflict-serializzabile non è view-serializzabile

<details><summary>Risposta corretta</summary>3</details>

# Domanda 15

> Data la query sotto a sinistra, eseguita sulla tabella R(<u>A</u>,B,C,D) sotto a destra, quale delle seguenti affermazioni è vera circa il result set generato dalla query?

Query:
```MYSQL
SELECT R.A, R.B,
	RANK() OVER(PARTITION BY R.B
				ORDER BY R.C) AS r1,
	RANK() OVER(ORDER BY R.C) AS r2
FROM R;
```
Tabella R:

| **A** | **B** | **C** | **D**      |
| ----- | ----- | ----- | ---------- |
| 1     | b1    | 1     | 2026-05-15 |
| 2     | b2    | 2     | 2026-05-01 |
| 3     | b1    | 2     | 2026-05-19 |
| 4     | b3    | 1     | 2026-05-19 |
| 5     | b1    | 1     | 2026-05-20 |
| 6     | b2    | 2     | 2026-05-23 |
1. Il valore di *r1* è diverso da quello di *r2*, per tutti i record del result set
2. Il valore di *r1* è uguale a quello di *r2*, per tutti i record del result set
3. Nessuna delle altre alternative è vera
4. I valori di *r1* dei record che assumono un dato valore di B sono tutti diversi fra loro, qualsiasi sia il valore di B

<details><summary>Risposta corretta</summary>3</details>

# Domanda 16

> Considerare la tabella T(<u>A</u>,D), in cui il dominio di D è `DATE`, tutti i record hanno T.d anteriore al 1° Giugno 2026 prima della creazione dell'event *report_update*, e solo tale event modifica T. Quale delle seguenti affermazioni relative all'event *report_update* è vera, dopo ogni sua esecuzione?

```MYSQL
CREATE EVENT report_update
ON SCHEDULE EVERY 1 WEEK
STARTS '2026-06-01'
DO
	DELETE FROM T
	WHERE T.D < CURRENT_DATE - INTERVAL 1 WEEK;
	
SET @@GLOBAL.event_scheduler = ON;
```

1. La tabella T resta invariata perché l'istruzione `CREATE` è sintatticamente errata: l'event non viene creato
2. Nessuna delle altre alternative è corretta
3. L'event mantiene in T i soli record il cui valore di T.d è una data appartenente alla settimana che precede il giorno di esecuzione
4. L'event mantiene in T i soli record il cui valore di T.d è una data appartenente alla settimana antecedente a quella che precede il giorno di esecuzione

<details><summary>Risposta corretta</summary>2,3</details>

# Domanda 17

\[DOMANDA MANCANTE\]

# Domanda 18

> Sia dato lo schema di relazione R(ABCDEF, G) con insieme di dipendenze funzionali G = {AB $\to$ C, A $\to$ C, C $\to$ D, D $\to$ E, C $\to$ E, E $\to$ F, AD $\to$ F, BF $\to$ A, B $\to$ A}. Quale delle seguenti affermazioni è corretta?

1. R non è in 3NF
2. R è in 3NF, ma non è in BCNF
3. R è in BCNF
4. Nessuna delle altre alternative è corretta

<details><summary>Risposta corretta</summary>1</details>

# Domanda 19

> In una query con `GROUP BY`, quale delle seguenti affermazioni è vera?

1. `WHERE` filtra le righe prima del raggruppamento e non può usare funzioni aggregate; `HAVING` filtra i gruppi dopo l'aggregazioni e può usare funzioni aggregate
2. `WHERE` filtra le righe prima del raggruppamento; `HAVING` filtra i gruppi dopo l'aggregazione. Entrambe possono usare funzioni aggregate
3. `WHERE` e `HAVING` sono intercambiabili quando non si usano funzioni aggregate; `HAVING` è obbligatorio in presenza di `GROUP BY`
4. Nessuna delle altre alternative è corretta

<details><summary>Risposta corretta</summary>1</details>

# Domanda 20

> Considerata la tabella T(<u>A</u>, B, C, D), quale delle seguenti query è sintatticamente corretta?

1. Nessuna delle altre alternative è corretta
2. ```MYSQL
   SELECT A, C, COUNT(*)
   FROM T
   GROUP BY C
   HAVING COUNT(*) > 5;
   ```
3. ```MYSQL
   SELECT COUNT(*)
   FROM T
   GROUP BY C
   HAVING COUNT(DISTINCT B) = 1;
   ```
4. ```MYSQL
   SELECT C, B, COUNT(*)
   FROM T
   GROUP BY C;
   ```

<details><summary>Risposta corretta</summary>3</details>
