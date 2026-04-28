### 1º Compitino Basi di dati 2026 





**Domanda 1**

La scelta degli identificatori esterni non è una delle attività di ristrutturazione.

* a. Vero.

* b. Falso.





**Domanda 2**

Dato uno schema logico di base di dati relazionale ottenuto dalla traduzione di uno schema E-R, quale delle seguenti affermazioni è falsa?

* a. Ciascun attributo di una tabella deriva da un attributo di un'entità o di una relazione del diagramma E-R.

* b. Ogni tabella deriva dalla traduzione di un'entità.

* c. La chiave primaria di ogni tabella contiene attributi dell'entità o dell'associazione che ha generato la tabella, insieme a eventuali attributi di altre entità.

* d. Almeno una delle altre alternative è falsa.







**Domanda 3**

Quale delle seguenti equivalenze è sempre vera **per ogni schema** di relazione R, S, e T, e **per ogni formula** F?

* a. Nessuna delle altre alternative è corretta.

* b. $R-(S\\cap T)\\equiv(R-S)-T$

* c. $\\pi\_{X}(R-S)\\equiv\\pi\_{X}(R)-\\pi\_{X}(S)$

* d. $\\sigma\_{F}(R\\cap S)\\equiv\\sigma\_{F}(R)\\cap\\sigma\_{F}(S)$







**Domanda 4**

In un diagramma E-R, se $F\_{1}$ ed $F\_{2}$ sono due entità figlie di una generalizzazione parziale dell'entità E, quale delle seguenti affermazioni è vera?

* a. Può esistere un'istanza di $F\_{1}$ o $F\_{2}$ che non è anche istanza di E.

* b. Non esiste alcuna istanza di $F\_{1}$ o $F\_{2}$ che non sia anche istanza di E.

* c. Nessuna delle altre alternative è corretta.

* d. Non esiste alcuna istanza di E che non sia anche istanza di $F\_{1}$ o $F\_{2}.$







**Domanda 5**

Dato il diagramma E-R in figura, quanti vincoli di integrità referenziale si generano durante la sua traduzione nel modello logico relazionale?

!\[\[./immagini/schema1.png]]

* a. Nessuna delle altre alternative è corretta

* b. 3

* c. 2

* d. 4







**Domanda 6**

Sia dato lo schema di base di dati (valori null non ammessi):

* **Studente**(<u>Matricola</u>, Nome, CorsoDiLaurea)

* **Esame**(<u>Matricola</u>, <u>CodCorso</u>, Voto)

* **Corso**(<u>CodCorso</u>, NomeCorso, Docente)

con i seguenti vincoli di integrità referenziale:

* da Matricola di Esame a(lla chiave di) Studente;

* da CodCorso di Esame a(lla chiave di) Corso.



Nella relazione Esame sono registrati sia i voti sufficienti (superiori o uguali a 18) che i voti non sufficienti (inferiori a 18).

Quale interrogazione descrive correttamente l'espressione $\\pi\_\\text{Nome}$(Studente) - $\\pi\_\\text{Nome}$(Studente $\\bowtie\\pi\_\\text{Matricola}$ ($\\sigma\_\\text{Voto < 18}$ (Esame)))?

* a. I nomi degli studenti che non hanno mai preso voti insufficienti o non hanno sostenuto alcun esame.

* b. I nomi degli studenti che hanno preso almeno un voto sufficiente e hanno sostenuto almeno un esame.

* c. I nomi degli studenti che hanno preso almeno un voto insufficiente.

* d. Nessuna delle altre alternative è corretta.







**Domanda 7**

Sia dato lo schema di base di dati (valori null non ammessi):

* **Studente**(<u>Matricola</u>, Nome, CorsoDiLaurea)

* **Esame**(<u>Matricola</u>, <u>CodCorso</u>, Voto)

* **Corso**(<u>CodCorso</u>, NomeCorso, Docente)

con i seguenti vincoli di integrità referenziale:

* da Matricola di Esame a(lla chiave di) Studente;

* da CodCorso di Esame a(lla chiave di) Corso.



Nella relazione Esame sono registrati sia i voti sufficienti (superiori o uguali a 18) che i voti non sufficienti (inferiori a 18).

Quale espressione restituisce i nomi degli studenti che hanno sostenuto un esame (con qualsiasi voto) di tutti i corsi tenuti da Rossi?

* a. $\\pi\_{Nome}(Studente\\bowtie\\pi\_{Matricola}(Esame\\bowtie\\sigma\_{Docente='Rossi'}(Corso)))$

* b. $\\pi\_{Nome}(Studente\\bowtie\\pi\_{Matricola}(\\pi\_{CodCorso}(\\sigma\_{Docente='Rossi'}(Corso))-\\pi\_{CodCorso}(Esame)))$

* c. $\\pi\_{Nome}(Studente)-\\pi\_{Nome}((Studente\\bowtie Esame)-\\sigma\_{Docente='Rossi'}(Corso)))$

* d. Nessuna delle altre alternative è corretta.





**Domanda 8**

Sia dato lo schema di base di dati (valori null non ammessi):

* **Studente**(<u>Matricola</u>, Nome, CorsoDiLaurea)

* **Esame**(<u>Matricola</u>, <u>CodCorso</u>, Voto)

* **Corso**(<u>CodCorso</u>, NomeCorso, Docente)

con i seguenti vincoli di integrità referenziale:

* da Matricola di Esame a(lla chiave di) Studente;

* da CodCorso di Esame a(lla chiave di) Corso.



Nella relazione Esame sono registrati sia i voti sufficienti (superiori o uguali a 18) che i voti non sufficienti (inferiori a 18).

Quale espressione restituisce i codici dei corsi per cui esiste almeno uno studente bocciato e almeno uno promosso?

* a. Nessuna delle altre alternative è corretta.

* b. $\\pi\_\\text{CodCorso}$($\\sigma\_\\text{Voto<18}$(Esame)) $\\cap$ $\\pi\_\\text{CodCorso}$($\\sigma\_{\\text{Voto}\\ge18}$(Esame))

* c. $\\pi\_\\text{CodCorso}$($\\sigma\_\\text{Voto<18}$(Esame) $\\cup$ $\\sigma\_{\\text{Voto}\\ge18}$(Esame))

* d. $\\pi\_\\text{CodCorso}$($\\sigma\_\\text{Voto<18}$(Esame)) - $\\pi\_\\text{CodCorso}$($\\sigma\_{\\text{Voto}\\ge18}$(Esame))





**Domanda 9**

Nel modello relazionale, un'istanza di relazione è definita come:

* a. Un insieme non ordinato di tuple.

* b. Una sequenza ordinata di tuple.

* c. Un nome e una lista di attributi.

* d. Nessuna delle altre alternative è corretta.







**Domanda 10**

Nel modello relazionale, quale delle seguenti affermazioni sugli attributi di una data relazione è vera?

* a. Due attributi diversi possono avere lo stesso nome, se hanno domini diversi.

* b. Gli attributi parte di una chiave non possono far parte di altre chiavi.

* c. Nessuna delle altre alternative è corretta.

* d. Un attributo parte di una chiave primaria non può far parte di altre chiavi.







**Domanda 11**

Date due entità $E\_{1}$ ed $E\_{2}$ collegate da un'associazione A \_molti-a-molti\_, se si considerano due diverse occorrenze di A, in qualsiasi modo si scelgano, quale delle seguenti alternative è vera?

* a. Nessuna delle altre alternative è corretta.

* b. Le due occorrenze di A non collegano mai coppie diverse di occorrenze di $E\_{1}$ ed $E\_{2}.$

* c. Le due occorrenze di A collegano sempre coppie diverse di occorrenze di $E\_{1}$ ed $E\_{2}$.

* d. Le due occorrenze di A possono collegare la stessa coppia di occorrenze di $E\_{1}$ ed $E\_{2}.$







**Domanda 12**

Siano date due relazioni $R(\\underline{A},B)$ e $S(\\underline{C},D)$, con cardinalità $|R|=5$ e $|S|=8$. Si consideri il theta-join R $\\bowtie\_{\\theta}$ S.

Quale delle seguenti affermazioni è **sempre vera** sulla cardinalità del risultato del theta-join?

* a. $|R\\bowtie\_{\\theta}S|\\le40$

* b. $|R\\bowtie\_{\\theta}S|=40$

* c. $|R\\bowtie\_{\\theta}S|\\le8$

* d. Nessuna delle altre alternative è corretta.







**Domanda 13**

Siano date le relazioni R(<u>A</u>, B) e S(<u>C</u>,D), con vincolo di integrità referenziale da B a(lla chiave di) S.

Assumendo assenza di valori null, quale delle seguenti affermazioni è **sempre vera**?

* a. Ogni valore di B deve comparire in C.

* b. B non può contenere valori duplicati.

* c. Ogni valore di C deve comparire in B.

* d. B deve essere una chiave candidata di R.







**Domanda 14**

In un diagramma E-R, che cos'è un'associazione?

* a. Un collegamento fra entità che può avere attributi.

* b. Un attributo a comune fra due entità.

* c. Nessuna delle altre alternative è corretta.

* d. Una chiave primaria a comune fra più entità.







**Domanda 15**

Nel modello relazionale, quale tra le seguenti affermazioni sugli attributi è corretta?

* a. Ogni attributo è definito su un dominio.

* b. Due attributi della stessa relazione possono avere lo stesso nome.

* c. Ogni attributo deve appartenere a una chiave candidata.

* d. Nessuna delle altre alternative è corretta.







**Domanda 16**

Uno studente ha un cognome e un nome, ed è identificato da una matricola. Un esame è identificato da un codice, e ha un nome. Uno studente può sostenere un esame in uno o più appelli, ciascuno dei quali si tiene in una specifica data. Se lo studente supera un esame in un appello, consegue un voto che viene registrato; l'assenza del voto indica che l'esame non è stato superato in quell'appello. Il seguente diagramma E-R è una possibile rappresentazione concettuale della realtà descritta?

!\[\[./immagini/schema2.png]]

* a. Sì.

* b. No.







**Domanda 17**

Nelle proprietà ACID, la lettera A indica:

* a. Atomicità.

* b. ACID.

* c. Accessibilità.

* d. Affidabilità.







**Domanda 18**

Una transazione, in un DBMS, è:

* a. Un vincolo definito sullo schema di una relazione.

* b. Una sequenza di operazioni che deve essere eseguita come un'unità logica di lavoro.

* c. Una qualsiasi interrogazione di sola lettura.

* d. Un insieme di relazioni memorizzate su disco.







**Domanda 19**

Dato il diagramma E-R in figura, qual è la sua traduzione nel modello logico relazionale?

!\[\[./immagini/schema3.png]]

* a. AUTOBUS(<u>Targa</u>, Modello, Capienza, Linea, OraFermata); LINEA(<u>Autobus, Nome</u>, Lunghezza)

* b. Nessuna delle altre alternative è corretta.

* c. AUTOBUS(<u>Targa</u>, Modello, Capienza); LINEA(<u>Autobus, Nome</u>, Lunghezza); TRATTA(<u>Autobus, Linea</u>, OraFermata)

* d. AUTOBUS(<u>Targa</u>, Modello, Capienza); LINEA(<u>Autobus, Nome</u>, Lunghezza, OraFermata)







**Domanda 20**

Sia dato lo schema di base di dati (valori null non ammessi):

* **Studente**(<u>Matricola</u>, Nome, CorsoDiLaurea)

* **Esame**(<u>Matricola</u>, <u>CodCorso</u>, Voto)

* **Corso**(<u>CodCorso</u>, NomeCorso, Docente)

con i seguenti vincoli di integrità referenziale:

* da Matricola di Esame a(lla chiave di) Studente;

* da CodCorso di Esame a(lla chiave di) Corso.



Nella relazione Esame sono registrati sia i voti sufficienti (superiori o uguali a 18) che i voti non sufficienti (inferiori a 18).

Quale interrogazione descrive correttamente l'espressione: 

$\\pi\_\\text{Nome}$(Studente $\\bowtie$ $\\pi\_\\text{Matricola}$($\\sigma\_{\\text{Voto} < 18}$(Esame))) $\\cap$ $\\pi\_\\text{Nome}$(Studente $\\bowtie$ $\\pi\_\\text{Matricola}$($\\sigma\_{\\text{Voto} \\ge 18}$(Esame)))?

* a. I nomi degli studenti che hanno preso solo voti sufficienti.

* b. I nomi degli studenti che non hanno preso almeno un voto insufficiente e almeno un voto sufficiente solo in esami relativi allo stesso corso.

* c. Nessuna delle altre alternative è corretta.

* d. I nomi degli studenti che hanno preso almeno un voto insufficiente e almeno un voto sufficiente.



# Soluzioni

1\. a

2\. b

3\. a

4\. b

5\. d

6\. a

7\. d

8\. b

9\. a

10\. c

11\. c

12\. a

13\. a

14\. a

15\. a

16\. b

17\. a

18\. b

19\. b

20\. d

