
# DOMANDE ORALE ELETTRONICA DIGITALE (9 CFU)

Raccolta di domande dell’orale di Elettronica Digitale del prof. Piotto (dal 2019 in poi), ovviamente la lista non è completa, ma include le domande e gli argomenti chiesti più di frequente.

**Come utilizzare questo materiale:** Il consiglio è di utilizzare la lista come indicazione e verifica degli argomenti da ripetere durante la preparazione.

---

## INTRODUZIONE

- Corrente di diffusione, con relazione di Einstein e formule
- Ricavare unità di misura della costante di diffusione (partendo da un modello), formula, verso
- Corrente di drift, velocità di drift e calcolo dell'espressione della densità di corrente di drift
- Drogaggio
- Modello di Drude
- Influenza della temperatura nel silicio intrinseco e drogato
- Relazione di Einstein

---

## DIODO PN

- Perché il potenziale di built-in della giunzione non può essere misurato
- Metodo della Retta di Carico
- Fenomeno di breakdown: effetto zener, effetto valanga ed influenza della temperatura
- Diodo Zener
- Raddrizzatore a doppia semionda
- Raddrizzatore a ponte di Graetz
- rilevatore di picco e perché il condensatore non ha effetto
- Regolatore di tensione con Zener: cosa accade se il carico è molto grande, normale, nullo
- Modello per piccoli segnali: condizioni di applicabilità
- Problemi della logica a diodi

---

## TRANSISTOR BJT

- Perché l’emettitore è molto più drogato della base
- Effetto Early
- Modello di Ebers-Moll per PNP: trovare IB in funzione di IE in zona attiva inversa
- Modello di Ebers-Moll in Zona Attiva Diretta
- Modello di Ebers-Moll per NPN: come cambiano le equazioni se il BJT è saturo
- Modello per ampi segnali
- Modello per piccoli segnali: con calcoli e limiti
- bjt valutazione di hre
  
---

## TRANSISTOR MOSFET

- Effetto di modulazione di canale
- Effetto Early e perchè la corrente aumenta al variare di Vds
- Modello per piccoli segnali

---

## AMPLIFICATORI

- Teoria della reazione: le tre ipotesi semplificative, come varia l'impedenza di uscita se eseguo un prelievo di tensione
- Amplificatori operazionali
- Amplificare la differenza di due segnali con un amplificatore operazionale
- Perché non posso usare direttamente un amplificatore operazionale ideale per fare la differenza?
- Ricavare guadagno differenziale e a modo comune
- Amplificatore differenziale con 4 resistenze: calcolo resistenze viste
- Integratore di Miller: entrambi i metodi per il calcolo di Vo (sia tempo che Laplace), perché l’uscita è instabile, come viene usato nei circuiti ADC
- Sommatore con amplificatore invertente
- Buffer, perchè è utile
- Amplificatore invertente e non invertente

---

## REGOLATORI DI TENSIONE

- Calcolo della resistenza vista in reazione
- Regolatore lineare serie: perché si usa un doppio condensatore, come ottenere Vo = 5 V se hai Vz = 4.7 V _(solo ragionamento)_
- 78xx e 79xx
- Regolatore di corrente con regolatore di tensione monolitico 75xx: limite della R di carico
- Regolatore di corrente con un regolatore di tensione monolitico
- Regolatore switch base
- Regolatore switching forward: tensione su L,R,C con interruttore aperto e chiuso
- Alimentatore Switching Flyback
- Alimentatore con regolatore switching forward, tensione su L, R e C con interruttore aperto e chiuso, differenze con il lineare serie

---

## ELETTRONICA DIGITALE

- Pass-gate con NMOS
- PMOS e NMOS: carica e scarica condensatore
- Dimostrare che un nmos non è un interruttore ideale
- Potenza (statica e dinamica) dissipata da un inverter CMOS
- Margini di rumore nell'inverter CMOS
- Potenza dinamica dissipata
- Circuito di protezione dalle scariche elettriche CMOS
- Logica Pass-Trasistor
- Rigenerazione dei livelli logici
  
---

## LOGICA SEQUENZIALE

- Latch, stato metastabile e soglia di $\frac{V_{DD}}{2}$
- Flip-Flop SR: lettura, le 2 possibili realizzazioni
- Flip-Flop D Edge Triggered (master/slave): quale capacità mantiene il dato
- ~~TTL con totem-pole~~
- ~~Inverter con logica TTL, come si può generalizzare per ottenere porte logiche (NAND)~~

---

## MULTIVIBRATORI

- ~~Monostabile CMOS~~
- Oscillatore ad Anello: utilizzo per il calcolo della tp, perchè si chiama guadagno ad anello, è sempre valida la formula 2\*n\*t?
- Multivibratore astabile: calcolo del periodo

---

## MEMORIE

- Architettura generale
- Cella di memoria DRAM
- DRAM, lettura e scrittura
- SRAM, lettura e scrittura
- Sense Amplifier: funzionamento e perchè usare un pmos collegato a vdd e un nmos collegato a ground, perchè è importante lo stato metastabile e perchè funziona, temporizzazione di una lettura
- Circuito di precarica
- Temporizzazione di una lettura
- Decoder degli indirizzi di riga: come modificarlo per avere un decoder degli indirizzi di colonna e perché bisogna modificarlo
- Memoria EPROM e perché si utilizza la luce UV per la programmazione
- Trattazione sul Gate Flottante e FLOTOX
- Memoria EEPROM

---

## CONVERTITORI

- Convertitore D/A
- A/D singola rampa (calcoli e circuito)
- A/D Doppia rampa (andamento grafico e risultato finale)
- ADC Flash: numero di componenti per bit, vantaggi e svantaggi e come migliorarlo, perchè si usa un amplificatore
