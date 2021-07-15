# MySQL
## Indice
- [MySQL](#mysql)
  - [Basic](#basic)
    - [SELECT Statement](#select-statement)
    - [INSERT Statement](#insert-statement)
    - [UPDATE Statement](#update-statement)
    - [DELETE Statement](#delete-statement)
  - [Logical Operators](#logical-operators)
    - [ALL](#all)
    - [AND](#and)
    - [ANY/SOME](#anysome)
    - [BETWEEN](#between)
    - [EXISTS](#exists)
    - [IN](#in)
    - [LIKE](#like)
    - [NOT](#not)
    - [OR](#or)
  - [MySQL Joins](#mysql-joins)
    - [INNER JOIN](#inner-join)
    - [NATURAL JOIN](#natural-join)
    - [CROSS JOIN](#cross-join)
    - [LEFT JOIN](#left-join)
    - [RIGHT JOIN](#right-join)
    - [SELF JOIN](#self-join)
  - [Raggruppamento](#raggruppamento)
    - [GROUP BY](#group-by)
    - [HAVING](#having)
  - [Window functions](#window-functions)
    - [WITH ROLLUP](#with-rollup)
    - [OVER](#over)
    - [FRAME](#frame)
  - [Subquery](#subquery)
    - [Noncorrelated subquery](#noncorrelated-subquery)
    - [Correlated subquery](#correlated-subquery)
  - [Other](#other)
    - [SELECT DISTINCT](#select-distinct)
    - [NULL Values](#null-values)
    - [[CTE] Common Table Expression](#cte-common-table-expression)
- [MySQL Functions](#mysql-functions)
  - [Date Functions](#date-functions)
    - [CURRENT_DATE()](#current_date)
    - [DATE_FORMAT(_date, format_)](#date_formatdate-format)
    - [DAY/MONTH/YEAR(_date_)](#daymonthyeardate)
    - [DATEDIFF(_date1, date2_)](#datediffdate1-date2)
    - [DATE_ADD/DATE_SUB(_date, INTERVAL value interval_)](#date_adddate_subdate-interval-value-interval)
  - [Aggregate Functions](#aggregate-functions)
    - [COUNT(_expression_)](#countexpression)
    - [SUM/AVG/MAX/MIN(_expression_)](#sumavgmaxminexpression)
  - [Non-Aggregate Functions](#non-aggregate-functions)
    - [RANK/DENSE_RANK/PERCENT_RANK()](#rankdense_rankpercent_rank)
    - [ROW_NUMBER()](#row_number)
    - [LAG/LEAD(_expression_,  _value_)](#lagleadexpression-value)
    - [FIRST_VALUE/LAST_VALUE(  _expression_)](#first_valuelast_value-expression)
- [MySQL dichiarativo-procedurale](#mysql-dichiarativo-procedurale) 
  - [Stored procedure](#stored-procedure)
  - [Stored function](#stored-function)
    - [Variabili](#variabili)
      - [Variabili locali](#variabili-locali)
      - [Variabili user-defined](#variabili-user-defined)
    - [TEMPORARY TABLE](#temporary-table)
    - [MATERIALIZED VIEW](#materialized-view)
    - [Istruzioni procedurali](#istruzioni-procedurali)
      - [Istruzione IF](#istruzione-if)
      - [Istruzione CASE](#istruzione-case)
      - [Istruzione WHILE](#istruzione-while)
      - [Istruzione REPEAT](#istruzione-repeat)
      - [Istruzione LOOP](#istruzione-loop)
    - [CURSOR](#cursor)
      - [Dichiarazione](#dichiarazione)
      - [Apertura, Fetch e Chiusura](#apertura-fetch-e-chiusura)
      - [Handler](#handler)
    - [SIGNAL](#signal)
    - [Database attivi](#database-attivi)
      - [TRIGGER](#trigger)
      - [EVENT](#event)

## Basic
### SELECT Statement 
> Viene usato per selezionare dei dati da un database
```sql
SELECT column1, column2, ... -- Proiezione
FROM table_name -- Fonte dei dati
WHERE condition; -- Condizione
```

### INSERT Statement
> Considerata una tabella, permette di inserire un nuovo record i cui valori degli attributi possono essere sia statici che ricavati
```sql
INSERT INTO Tabella [(Attributo1, Attributo2,...,AttributoN)] -- Attributi da impostare (opzionali se sono tutti)
VALUES (Valore1, Valore2, ..., ValoreN); -- Valori da assegnare agli attributi

INSERT INTO Tabella [(Attributo1, Attributo2,...,AttributoN)] 
SELECT Attributo1, Attributo2,...,AttributoN -- La query di selezione deve avere una proiezione coerente con lo schema della tabella target.
FROM Tabella2
```

### UPDATE Statement
> Permette di modificare il valore di uno o più attributi di uno o più record con valori statici oppure ricavati
```sql
UPDATE Tabella 
SET Attributo1 = Valore1, Attributo2 = Valore2, ..., AttributoN = ValoreN 
WHERE Condizione
```

### DELETE Statement
> Permette di cancellare uno o più record dipendentemente dalla veridicità di una condizione, anche articolata
```sql
DELETE FROM Tabella WHERE Condizione
```

## Logical Operators

### ALL
> `TRUE` se tutti i valori della subquery soddisfano la condizione
```sql
SELECT * 
FROM Products
WHERE Price > ALL (
	SELECT Price FROM Products WHERE Price > 500
);
```

### AND
> `TRUE` se tutte le condizioni separate da `AND` sono vere
```sql
SELECT * 
FROM Customers
WHERE City = "London" AND Country = "UK";
```

### ANY/SOME
> `TRUE` se uno qualsiasi dei valori della subquery soddisfa la condizione
```sql
SELECT * 
FROM Products
WHERE Price > ANY (
	SELECT Price FROM Products WHERE Price > 50
);
```

### BETWEEN
> `TRUE` se il valore rientra nell'intervallo di confronto
```sql
SELECT * 
FROM Products
WHERE Price BETWEEN 50 AND 60;
```

### EXISTS
> `TRUE` se la subquery restituisce uno o più record
```sql
SELECT * 
FROM Products
WHERE EXISTS (
	SELECT Price FROM Products WHERE Price > 50
);
```

### IN
> `TRUE` se il valore è uguale ad almeno uno degli di una subquery/lista
```sql
SELECT * 
FROM Customers
WHERE City IN ('Paris','London');
```

### LIKE
> `TRUE` se il valore corrisponde ad un pattern
```sql
SELECT * 
FROM Customers
WHERE City LIKE 's%';
```

### NOT
> `TRUE` se la condizione non è vera
```sql
SELECT *
FROM table_name
WHERE NOT condition
```

### OR
> `TRUE` se una delle condizioni separate da `OR` sono vere
```sql
SELECT * 
FROM Customers
WHERE City = "London" OR Country = "UK";
```

## MySQL Joins
### INNER JOIN
> Date due tabelle, combina ogni record della prima con tutti i record della seconda che verificano una determinata condizione
```sql
SELECT column_name
FROM table1 t1 INNER JOIN table2 t2 ON t1.column_name = t2.column_name;
```

### NATURAL JOIN
> Combina i record della prima tabella con i record della seconda tabella aventi valori uguali sugli attributi omonimi
```sql
 SELECT column_name
 FROM table1 NATURAL JOIN table2
```
    
### CROSS JOIN
> Restituisce tutte le possibili combinazioni di ciascun record della prima tabella con tutti i record della seconda tabella
```sql
SELECT column_name
FROM table1 CROSS JOIN table2
```

### LEFT JOIN
> Combina ogni record della tabella sinistra con i record della tabella destra che soddisfano una condizione, **mantenendo tutti i record della tabella di sinistra**
```sql
SELECT column_name
FROM table1 LEFT JOIN table2 ON table1.column_name = table2.column_name;
```

### RIGHT JOIN
> Combina ogni record della tabella destra con i record della tabella sinistra che soddisfano una condizione, **mantenendo tutti i record della tabella di destra**
```sql
SELECT column_name
FROM table1 RIGHT JOIN table2 ON table1.column_name = table2.column_name;
```

### SELF JOIN
> Combina i record di una tabella con i record **della stessa tabella** che rispettano una determinata condizione
```sql
SELECT column_name
FROM  table1 T1, table1 T2
WHERE  condition;

SELECT column_name
FROM  table1 T1 INNER JOIN table1 T2 ON condition;
```

## Raggruppamento
### GROUP BY
> Suddivide un insieme di record in **gruppi di record**, all’interno di ognuno dei quali il valore di uno o più attributi è costante record per record
```sql
SELECT column_name
FROM table_name
WHERE condition
GROUP BY column_name, ... -- possono esserci più valori
```
> L'istruzione viene spesso utilizzata con funzioni di aggregazione (`COUNT`, `MAX`, `MIN`, `SUM`, `AVG`)

### HAVING
> Sono espresse esclusivamente tramite operatori di aggregazione e permettono di scartare gruppi, qualora non siano soddisfatte
```sql
SELECT Specializzazione
FROM Medico 
GROUP BY Specializzazione 
HAVING COUNT(*) > 2;
```

## Window functions
> Affiancano a ogni **record r** un valore ottenuto da un’operazione eseguita su **un insieme di record logicamente connessi a r**

### WITH ROLLUP
> Il modificatore `WITH ROLLUP` crea un'ultima riga con un valore complessivo applicato a tutto il result set

> Ad esempio questa query conta per ogni Specializzazione il numero di medici e poi crea un'ultima riga che ha come Specializzazione  `NULL` e `COUNT(*)` il numero totale di medici
```sql
SELECT m.Specializzazione, COUNT(*)
FROM Medico m
GROUP BY m.Specializzazione WITH ROLLUP;
```
> Se ci sono più attributi di raggruppamento allora ci saranno più righe di `ROLLUP`

### OVER
> Applica una funzione di tipo aggregate o non-aggregate a **un insieme di record associati a un record di un result set** (*partition*)
```sql
SELECT m.Matricola,m.Specializzazione , COUNT(*) OVER(
	PARTITION BY m.Specializzazione
)
FROM Medico m
```
> Se over non ha contenuto, la partition è sempre la stessa per ogni OVER( ) record

> Si possono applicare più di una Window function
```sql
SELECT m.Matricola,m.Specializzazione, 
	RANK() OVER(ORDER BY m.Parcella), 
	RANK() OVER(PARTITION BY m.Specializzazione, ORDER BY m.Parcella)
FROM Medico m
```

### FRAME
> In assenza di specifica di frame, se over() contiene order by, le window functions non aggregate che lavorano su frame considerano i record dall’inizio della partition fino alla current row. Se over() non contiene order by, tali funzioni considerano tutta la partition

> Si possono dichiarare dei frame basati sul numero di righe. La parola `UNBOUNDED PRECEDING` indica dalla prima riga della partition mentre `UNBOUNDED FOLLOWING` all'ultima. Se vogliamo solo arrivare alla riga corrente si deve scrivere `CURRENT ROW`
```sql
WINDOWS w AS (
	ORDER BY something
	ROWS BETWEEN [numero | UNBOUNDED] PRECEDING AND [numero | UNBOUNDED] FOLLOWING -- FRAME basato sul numero di righe 
);
```
> Ci sono anche dei frame dichiarati in base ad intervalli di valori numerici, date o timestamp, e utilizzano la keyword `range`.
```sql
WINDOWS w AS (
	PARTITION BY v.Paziente
	ORDER BY v.`Data`
	RANGE BETWEEN 
		INTERVAL 6 MONTH PRECEDING
		AND CURRENT ROW
);
```
> Se si usano frame dichiarati su range, si limita la partition solo usando lassi temporali, non si possono usare anche limitazioni della partition basate sul numero di rows preceding e following

## Subquery
### Noncorrelated subquery
> Si incapsulano nel WHERE per ottenere risultati usati dalla outer query per determinare il result set finale, **i record ottenuti dalla subquery non dipendono dalla outer query**
```sql
SELECT M.Nome, M.Cognome, M.Parcella 
FROM Medico M 
WHERE M.Specializzazione = 'Ortopedia' AND M.Matricola IN (
	SELECT V.Medico FROM Visita V WHERE YEAR(V.Data) = 2013
);
```

### Correlated subquery
> Il loro risultato **dipende** da ciascun record della query esterna
```sql
SELECT *
FROM table1 t1
where t1.value1 IN (
	SELECT t2.value1
	FROM table2 t2
	WHERE t2.value2 = t1.value2
);
```

## Other

### SELECT DISTINCT
> La parola DISTINCT elimina i duplicati (tutte le righe del result set saranno diverse)
```sql
SELECT DISTINCT column1
FROM table_name
```

### NULL Values

> Un campo con un valore NULL è un campo senza valore.

> IS NULL (elimina tutti i record che assumono valore diverso da NULL su tale attributo)
```sql
...
WHERE column_name IS NULL;
```

> IS NOT NULL (elimina tutti i record che assumono valore NULL su tale attributo)
```sql
...
WHERE column_name IS NOT NULL;
```

### [CTE] Common Table Expression
*[CTE]: Common Table Expression
> Sono result set dotati di identificatore che possono essere usati prima di una query per costruire risultati intermedi
```sql
WITH
	nome1 AS (query1),
	nome2 AS (query2),
	...

query_finale; -- usa le CTEs nome1, nome2,... nel from, anche più volte
```

# MySQL Functions

## Date Functions

###  CURRENT_DATE()
> Variabile di sistema che esprime la data odierna
```sql
SELECT CURRENT_DATE();
```

### DATE_FORMAT(*date, format*)
> Formatta una data come specificato
```sql
SELECT DATE_FORMAT("2017-06-15", "%M %d %Y");
```
        
### DAY/MONTH/YEAR(*date*)
> Prendono come argomento una data e ne restituiscono, rispettivamente, giorno, mese e anno (come numeri interi)
```sql
SELECT DAY("2017-06-15 09:34:21");
```
        
### DATEDIFF(*date1, date2*)
> Restituisce il numero di giorni tra due valori di data.
```sql
SELECT DATEDIFF("2017-06-25", "2017-06-15");
```

### DATE_ADD/DATE_SUB(*date, INTERVAL value interval*)
> Aggiunge/Sottrae un intervallo di ora/data a una data, quindi restituisce una data.
```sql
SELECT DATE_ADD("2017-06-15", INTERVAL 10 DAY);
```
> Possibili intervalli: [`MICROSECOND`, `SECOND`, `MINUTE`, `HOUR`, `DAY`, `WEEK`, `MONTH`, `QUARTER`, `YEAR`...]

> È possibile usare i simboli `+` e `-` al posto della funzione `DATE_ADD`/`DATE_SUB`
```sql
SELECT "2017-06-15" - INTERVAL 10 DAY
```

## Aggregate Functions
### COUNT(*expression*)
> Restituisce il numero di righe che corrisponde a un criterio specificato.
```sql
SELECT COUNT(*) -- Conta tutte le righe
SELECT COUNT(column_name) -- Conta tutt i valori di una colonna
SELECT COUNT(DISTINCT column_name) -- Conta tutti i valori diversi di una colonna
```
> I valori NULL non vengono conteggiati.
        
### SUM/AVG/MAX/MIN(*expression*)
> Calcola la somma/media/massimo/minimo di un insieme di valori.
```sql
SELECT SUM(Reddito) AS RedditoTotale
FROM Paziente;
```
> I valori `NULL` vengono ignorati.

> Se ci sono solo valori `NULL` restituisce `NULL`

## Non-Aggregate Functions
### RANK/DENSE_RANK/PERCENT_RANK()
> Serve per stilare una classifica dipendentemente da un criterio (è spesso un attributo su cui si fa un sort), il criterio permette di associare uno score a ogni record, più è alto lo score, migliore è il rank
```sql
SELECT RANK() OVER(ORDER BY something)
FROM table_name
```
>  RANK ⇨ rank della riga corrente con gap
>  DENSE_RANK ⇨ rank della riga corrente senza gap
>  PERCENT_RANK  ⇨ rank della riga corrente in percentuale

### ROW_NUMBER()
> Assegnare un numero ad ogni riga della partition
```sql
SELECT ROW_NUMBER() OVER(PARTITION BY something)
FROM table_name
```

### LAG/LEAD(*expression*, *value*)
> Ricavano il valore di un attributo di una row **posta k posizioni prima (`lag`) o dopo (`lead`)** la current row
```sql
SELECT LEAD(v.`Data`, 1) OVER(PARTITION BY v.Paziente ORDER BY v.`Data`)
FROM Visita v
```

### FIRST_VALUE/LAST_VALUE( *expression*)
> Seleziona la prima/ultima riga del frame
```sql
SELECT LAST_VALUE(v.`Data`) OVER(
	PARTITION BY v.Paziente 
	ORDER BY v.`Data`
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING -- se non ci fosse stato sarebbe stato utilizzato il default frame
)
FROM Visita v
```

# MySQL dichiarativo-procedurale

## Stored procedure
> Sono procedure dichiarativo-procedurali memorizzate nel DBMS
```sql
DROP PROCEDURE IF EXISTS procedure1; 
DELIMITER $$ 
CREATE PROCEDURE procedure1(
	IN _var1, IN _var2,
	OUT var1_, OUT var2_
) 
BEGIN -- inizio del body
	SELECT MAX(t1.value1) INTO var2_
	FROM table1 t1
	WHERE t1.value2 = _var1; 
END $$ -- fine del body
DELIMITER ;
```
> La chiamata esegue la stored procedure e ottiene il risultato restituito dall’esecuzione del body
```sql
CALL procedure1('abcde', 1234, @MyVar, @MyVar2); -- chiamata funzione
```

## Stored function
> Restituiscono un solo valore e sono richiamabili anche da statement SQL
```sql
CREATE FUNCTION function_name(parametro1, ..., parametroN)
RETURNS datatype DETERMINISTIC | NOT DETERMINISTIC
```
> Una function è **deterministica** se restituisce un **risultato invariante** a fronte delle chiamate effettuate con gli stessi valori per i parametri d’ingresso altrimenti é **non deterministica**

> Una function può essere chiamata dalle query SQL, dalle stored procedure, dai trigger e dagli event

## Variabili
### Variabili locali
*Dichiarazione*
> Sono usate all’interno di una stored procedure, per memorizzare informazioni intermedie di ausilio, **devono essere dichiarate tutte insieme all’inizio del body!**
```sql
DECLARE nome_variabile tipo(size) DEFAULT valore_default;
```
> Le variabili non si possono dichiarare senza specificare un tipo (`INT`, `DOUBLE`, `CHAR`, `VARCHAR`, `DATE`, `DATETIME`)

> Il valore `size` indica la capacità della variabile, se non settata viene inizializzata con il valore di default del tipo

> Il valore `valore_default` indica il valore che ha la variabile appena inizializzata, senza il default value il valore iniziale è NULL

*Assegamento*
> È possibile assegnare un valore a una variabile in due modalità: istruzione SET oppure SELECT+INTO
```sql
SET nome_variabile = value1;

SELECT value1 INTO nome_variabile;
```
> **Una variabile non può contenere un result set**

### Variabili user-defined
> Sono inizializzate dall’utente senza necessità di dichiarazione, e il loro ciclo di vita equivale alla durata della connection a MySQL server

> Il contenuto è visibile ovunque, ma solo all’utente che le ha inizializzate, sono case insensitive e il loro identificatore deve iniziare con '@'

> Una variabile locale o user-defined (@) è sempre scalare, non può contenere un result set

## TEMPORARY TABLE
> Sono tabelle **temporanee** che mantiene risultati utili all’interno di una sessione, sono cancellate alla fine della sessione
```sql
-- Esempio TEMPORARY TABLE
CREATE TEMPORARY TABLE IF NOT EXISTS mytable(
	Username VARCHAR(20) NOT NULL,
	Email VARCHAR(50) NOT NULL
	Password VARCHAR(25) NOT NULL
	Pin INT,
	PRIMARY KEY (Username)
);

TRUNCATE TABLE mytable; -- svuota la tabella
```

## MATERIALIZED VIEW
> Una materialized view è a tutti gli effetti **una tabella persistente**, al logout non viene distrutta come avviene per le **temporary table**

> Una materialized view può essere aggiornata secondo due modalità: **full refresh** (aggiorna la materialized view da zero) oppure **incremental refresh** (aggiornamento della parte non più aggiornata)

> Ci sono tre possibili politiche di refresh:
> - Immediate ⇨ **Trigger**
> - Deferred ⇨ **Event**
> - On Demand ⇨ **Stored Procedure**

## Istruzioni procedurali
### Istruzione IF
```sql
IF if_condition THEN 
	-- blocco istruzioni if true 
ELSEIF elseif_1_condition THEN 
	-- blocco istruzioni elseif_1
ELSE 
	-- blocco istruzioni else 
END IF ;
```

### Istruzione CASE
```sql
CASE 
WHEN condition_1 THEN 
	-- blocco istruzioni_1 
WHEN condition_2 THEN 
-- blocco istruzioni_2
END CASE ;
```

### Istruzione WHILE
> La condizione è controllata prima di ogni iterazione e il blocco di istruzioni viene ripetuto fintantoché è vera
```sql
WHILE condition DO 
	-- blocco istruzioni 
END WHILE;
```

### Istruzione REPEAT
> La condizione è controllata dopo ogni iterazione  e il blocco di istruzioni viene ripetuto fintantoché non è vera
```sql
REPEAT 
	-- blocco istruzioni 
UNTIL condition 
END REPEAT;
```

### Istruzione LOOP
> `loop_label` indica il nome del loop, può essere qualsiasi cosa
```sql
loop_label: LOOP 
	-- blocco istruzioni e check di condizioni 
	IF codition1 THEN
		LEAVE loop_label; -- interrompe il ciclo
	END IF:

	IF codition2 THEN
		ITERATE loop_label; -- passa all'iterazione successiva
	END IF:
		
END LOOP;
```
> Le istruzioni `LEAVE` e `ITERATE` permettono di interrompere un ciclo o passare all’iterazione successiva, rispettivamente

## CURSOR
> I cursori **scorrono i record di un result set**, solo in avanti, per effettuare delle azioni all’interno di istruzioni iterative

### Dichiarazione
```sql
DECLARE NomeCursore CURSOR FOR 
SQL_query ;
```
> **I cursori si possono dichiarare solo immediatamente dopo la dichiarazione di tutte le variabili**

### Apertura, Fetch e Chiusura
> Per usare un cursore lo si deve **aprire** (`OPEN`), poi è possibile **effettuare il prelievo** (`FETCH`) riga per riga, infine lo si deve **chiudere** (`CLOSE`)
```sql
OPEN NomeCursore; -- apertura

FETCH NomeCursore INTO var1, var2,...; -- prelievo

CLOSE NomeCursore; -- chiusura
```

### Handler
> È un gestore di situazioni, utile nei cursori per riconoscere quando esso è giunto alla fine del result set
```sql
DECLARE CONTINUE HANDLER -- Segnala la fine del result set per il cursore
FOR NOT FOUND SET finito = 1; -- e imposta ad 1 la variabile `finito`
```
> **Possono essere definiti dall’utente dopo le definizioni delle variabili e dei cursori**

## SIGNAL
> È possibile restituire un errore o un warning al chiamante di una stored procedure
```sql
SIGNAL SQLSTATE '4500' -- solleva un errore generico
SET MESSAGE_TEXT = 'Errore generioco'
```

## Database attivi
### TRIGGER
> Un trigger è capace di **gestire vincoli** (*business rule*), oppure è usato per **aggiornare ridondanze** presenti nel database

> Ci sono 2 tipi di Trigger, con **`BEFORE`** si indica un'azione di **preprocessing**, mentre **`AFTER`** denota un'azione **a posteriori**, o comunque "collaterale"
```sql
DROP TRIGGER IF EXISTS nome_trigger; 
DELIMITER $$
CREATE TRIGGER nome_trigger 
[BEFORE | AFTER] [INSERT | UPDATE | DELETE] ON TabellaTarget FOR EACH ROW 
BEGIN
	-- istruzioni
END $$
DELIMITER ;
```

### EVENT
> Sono stored programs eseguiti in base a **condizioni dettate dal tempo**, possono anche essere ricorrenti
```sql
CREATE EVENT nome_event
ON SCHEDULE EVERY periodicità [DAY | MONTH | YEAR | SECOND | MINUTE | HOUR]
STARTS 'data_ora' ENDS 'data_ora'
DO
	-- istruzioni
```
> `STARTS` e `ENDS` sono opzionali, stabiliscono un istante di **inizio** e un istante di **fine**

> È possibile fare un event a singolo scatto. L'event **è eseguito una sola volta** poi viene mantenuto o viene distrutto. Se è presente `ON COMPLETION PRESERVE` il codice viene mantenuto altrimenti viene ditrutto.
```sql
ON SCHEDULE AT 'data_ora' + INTERVAL numero DAY | MONTH | YEAR | SECOND | MINUTE | HOUR 
[ON COMPLETION PRESERVE] -- se pesente mantiene il codice altrimenti viene perso
```
> Settando questa variabile di sistema, parte la schedulazione degli event
```sql
SET GLOBAL event_scheduler = ON;
```
