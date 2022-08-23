# Domande orali Comunicazioni numeriche
### IMPORTANTE: è noto che la materia si presta ad una grande quantità di domande ed è appurato che ogni singola dimostrazione svolta durante il corso potrebbe essere una papabile  domanda d'orale. Pertanto questa lista [che raccoglie domande d'orale proposte a partire dal 2018] non è da ritenersi completa ma unicamente come strumento di supporto [non esclusivo] durante la preparazione di tale esame   
# Segnali 
## Introduzione e Concetti generali
- Relazioni Potenza media-Energia
- Potenza istantanea nulla -> valor medio nullo
- Formule di Poisson
- Dimostrare che l'energia di un segnale periodico è infinita
- Potenza media di seganle periodico equivale alla potenza sul periodo

## TSF
- Proprietà TSF
- Biunivocità della TSF
- Linearità della TSF
- Simmetria hermitiana della TSF
- Trasformata di segnale Reale e Pari
- Trasformata di segnale Reale e Dispari
- Th di Parseval [segnali periodici]
- Segnale alternativo

## TCF
- Biunivocità TCF
- Trasformata di segnale Reale e Pari
- Trasformata di segnale Reale e Dispari
- Th del ritardo
- Th della dualità
- Th della derivazione
- Th della derivazione in frequenza
- Th dell'integrazione
- Th dell'integrazione completa
- Th del prodotto
- Th della modulazione [tutti]
- Relazione TSF-TCF
- TCF di un segnle periodico
- TCF di un segnale periodicizzato 
- Dimostrare la correttezza dell'ATCF
- Th di Parseval [segnali continui]

## Convoluzione
- Th della convoluzione
- Proprietà della convoluzione
- Convoluzione nel tempo <-> Prodotto in frequenza
- Prodotto nel tempo <-> Convoluzione in frequenza
- Relazione tra correlazione e convoluzione

## Delta di Dirac
- Definizione e proprietà della funzione
- TCF di un treno di Delta

## TFS
- CS per l'esistenza di TFS
- Biunivocità TFS
- Periodicità TFS
- Th del campionamento [dimostrazion grafica]
- Come si ricava la formla Y(F) = Xbarra(F)*P(F) usata nel th Teorema del campionamento?
- Relazione TCF-TFS
- Th di Parseval [per le sequenze]



# Probabilità
- Definizioni di probabilità
- Definizione e proprietà di un evento
- Definizioni di spazio campione
- Indipendenza completa tra due eventi [P(AB) = P(A)*P(B)]
- Th di Bayes
- Th della probabilità totale
- Proprietà della Distribuzione di probabiità
- Proprietà della Densità di probabilità
- Valor medio di una ddp esponenziale monolatera
- Th fondamentale per la trasformazione di Variabili Aleatorie
- Relazione tra Varianza, Valore quadratico medio e Valor medio [σ^2 = m^2 – η^2]
- Valor medio e varianza di una VA Gaussiana
- Relazione tra Covarianza, correlazione e valor medio [Cxy = rxy - ηxηy]
- VA indipendenti -> VA incorrelate
- Indici statistici di I e II ordine
- Relazione fra autocovarianza e varianza
- Dato un processo in ingresso e una h(t), dimostrare la formula del valor medio del processo in uscita
- Definizione di processo SSL e SSS
- Dimostrare che un sistema SSL è definito da x(t)⊗h(t)
- Indici statistici per sistemi SLS
- Proprietà della correazione per processi SSL
- Verificare che un processo sia SSL
- Dimostrare  chex(t) SSL entrante in SLS ->uscita y(t) SSL
- Risposta a gradino di un SLS
- Proprietà dell'autocorrelazione
- Autocorrelazione dela realizzazione di un processo SSL SLS [Ry(t1,t2) = Rx(t1,t2)⊗h(t1)⊗h(t2)]
- Proprietà della Densità spettrale di Energia
- Risposta al gradino e relazione con risposta impulsiva
- Risposta in frequenza [le tre definizioni]

# Sistemi di comunicazione
- Schema di un sistema di comunicazione numerico generico
- Dimostrare che la risposta di un filtro lineare tempo inviariante è la convoluzione tra l ingresso e la risposta impulsiva
- Definizione di replica fedele, specificare quando un filtro non introduce distorsioni lineari
- Da criterio MAX SNR -> MIN PE a criterio di minima distanza
- Condizione di Nyquist in tempo e in frequenza
- Risposta dell'interpolatore equivalente
- PEB in banda base
- Canale di comunicazione in banda passante
- Autocorrelazione in uscita da un filtro in banda base con ingresso un rumore in banda passante

## PAM banda base
- Proprietà 
- Schema PAM in banda base
- Densità spettrale di potenza di una PAM banda base
- Energia media per simbolo trasmesso PAM banda base
- Partendo da s(t), scrivere l'espressione di y[n] di una PAM banda base

## PAM banda passante
- Schema PAM in banda passante
- Energia media per simbolo trasmesso PAM banda passante
- Calcolare la DSP in uscita dal filtro di ricezione di una PAM in banda passante con modulazione in fase
- Autocorrelazione del processo in uscita al filtro in ricezione di un ricevitore PAM in banda passante [con rumore]
- Calcolare Es di una PAM in banda passante
- Modello del segnale ricevuto in una PAM in banda passante


## QAM
- Schema QAM [ricevitore e trasmettitore]
- Schema modulatore QAM
- Densità spettrale di potenza del segnale trasmesso per una QAM
- Ricavare il segnale ottenuto all'uscita del filtro in ricezione in una QAM, partendo dallo schema e dalla definizione del segnale trasmesso
- Probabilità di errore nella QAM  e cosa influisce per il calcolo

