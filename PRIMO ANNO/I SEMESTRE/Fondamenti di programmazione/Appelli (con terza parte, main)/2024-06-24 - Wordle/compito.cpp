#include "compito.h"
#include <cstring>

Wordle::Wordle(int n, int max_t){
    if(n <= 0)
        n = lunghezza_default;

    if(max_t <= 0)
        max_t = tentativi_default;

    lunghezza = n;
    gioco_avviato = false;
    sequenza_segreta = new char[lunghezza+1];
    tentativi_rimanenti = max_t;
    storico = nullptr;
}

void Wordle::distruggi_tentativo(tentativo* t){
    delete[] t->sequenza;
    delete[] t->risultato;
    delete t;
}

void Wordle::distruggi_storico() {
    tentativo* t;
    while(storico != nullptr) {
        t = storico;
        storico = storico->prossimo;
        distruggi_tentativo(t);
    }
}

Wordle::~Wordle(){
    distruggi_storico();
    delete[] sequenza_segreta;
}

bool Wordle::corretta_formattazione(const char *sequenza) const {
    if(strlen(sequenza) < lunghezza)
        return false;

    for(unsigned i = 0; i < lunghezza; ++i)
        if(sequenza[i] < 'A' || sequenza[i] > 'Z')
            return false;

    return true;
}

bool Wordle::avvia_gioco(const char *sequenza) {
    if(gioco_avviato)
        return false;

    if(!corretta_formattazione(sequenza))
        return false;

    strncpy(sequenza_segreta, sequenza, lunghezza);
    sequenza_segreta[lunghezza] = '\0';

    gioco_avviato = true;

    // comando necessario per quando una partita termina e se ne vuole avviare un'altra
    distruggi_storico();

    return true;
}

bool Wordle::inizializza_risultato(const char *sequenza_tentata, char *risultato) const {
    // caso di sequenza indovinata. Non sarebbe necessario inizializzare il risultato
    // ma lo si fa per coerenza
    if(strcmp(sequenza_tentata, sequenza_segreta) == 0){
        for(unsigned i = 0; i < lunghezza; ++i)
            risultato[i] = 'S';
        return true;
    }

    // casi sequenza non indovinata
    // pre-inizializzazione del risultato a tutti 'N'
    for(unsigned i = 0; i < lunghezza; ++i)
        risultato[i] = 'N';

    // inserimento delle 'S'
    for(unsigned i = 0; i < lunghezza; ++i)
        if(sequenza_tentata[i] == sequenza_segreta[i])
            risultato[i] = 'S';

    // inserimento degli '?'
    for(unsigned i = 0; i < lunghezza; ++i)
        if(risultato[i] != 'S')
            for(unsigned j = 0; j < lunghezza; ++j)
                // esiste il carattere altrove e non Ã¨ stato indovinato
                if(sequenza_tentata[i] == sequenza_segreta[j] && risultato[j] != 'S') {
                    risultato[i] = '?';
                    break;
                }

    return false;
}

// inizializza il nuovo tentativo tranne per il puntatore
Wordle::tentativo* Wordle::inizializza_tentativo(const char *sequenza_tentata) const {
    tentativo* nuovo_tentativo = new tentativo;
    nuovo_tentativo->sequenza = new char[lunghezza+1];
    nuovo_tentativo->risultato = new char[lunghezza+1];
    nuovo_tentativo->risultato[lunghezza] = '\0';
    strncpy(nuovo_tentativo->sequenza, sequenza_tentata, lunghezza);
    nuovo_tentativo->sequenza[lunghezza] = '\0';

    return nuovo_tentativo;
}

void Wordle::inserisci_tentativo(tentativo* nuovo_tentativo){
    // inserimento in testa
    if(storico == nullptr)
        nuovo_tentativo->prossimo = nullptr;
    else
        nuovo_tentativo->prossimo = storico;

    storico = nuovo_tentativo;
}

void Wordle::indovina(const char *sequenza_tentata) {
    if(!gioco_avviato)
        return;

    if(!corretta_formattazione(sequenza_tentata))
        return;

    tentativo* nuovo_tentativo = inizializza_tentativo(sequenza_tentata);
    bool vittoria = inizializza_risultato(sequenza_tentata, nuovo_tentativo->risultato);

    inserisci_tentativo(nuovo_tentativo);

    tentativi_rimanenti--;
    if(tentativi_rimanenti == 0 || vittoria)
        gioco_avviato = false;
}

// funzione ausiliaria che permette di utilizzare lo stesso codice sia per
// l'operatore di usicta per il tipo Wordle che per la funzione stampa_storico
void Wordle::stampa_tentativo(ostream& os, const tentativo* t, bool stampa_storico = false,
                              unsigned posizione_storico = 0) const{
    if(t == nullptr) {
        os << "NESSUN TENTATIVO ANCORA ESEGUITO" << endl;
        return;
    }

    os << "Ultima sequenza tentata: " << t->sequenza << endl;
    if(!stampa_storico && !gioco_avviato){
        if(strcmp(t->sequenza, sequenza_segreta) == 0)
            os << "VITTORIA";
        else
            os << "SCONFITTA";
        os << endl;

        return;
    }

    os << "Risultato: ";

    //for(unsigned i = 0; i < lunghezza; ++i)
    //    os << t->risultato[i];
    os << t->risultato;

    os << endl;
    os << "Tentativi rimanenti: " << tentativi_rimanenti + posizione_storico << endl;
}

ostream& operator<<(ostream &os, const Wordle &w){
    w.stampa_tentativo(os, w.storico);
    return os;
}

// --- SECONDA PARTE ---

void Wordle::stampa_storico(ostream &os) const {
    stampa_tentativo(os, storico);
    os << endl;

    if(storico == nullptr)
        return;

    unsigned contatore = 1;
    for(tentativo *t = storico->prossimo; t != nullptr; t = t->prossimo){
        stampa_tentativo(os,  t, true, contatore++);
        os << endl;
    }
}

Wordle& Wordle::operator-=(const char *s) {
    if(corretta_formattazione(s) || strlen(s) > lunghezza || !gioco_avviato)
        return *this;

    int lunghezza_s = strlen(s);
    bool trovata = false;

    // scorrimento dello storico
    tentativo *q = nullptr, *t = storico;
    while(t != nullptr){
        // scorrimento della i-esima sequenza tentata
        for (unsigned i = 0; i < lunghezza - lunghezza_s + 1; ++i) {
            // se la sottosequenza coincide
            if (strncmp(s, t->sequenza+i, lunghezza_s) == 0) {
                // eliminazione in testa
                if(t == storico){
                    storico = storico->prossimo;
                    distruggi_tentativo(t);
                    t = storico;
                }
                // eliminazione nel mezzo
                else {
                    q->prossimo = t->prossimo;
                    distruggi_tentativo(t);
                    t = q->prossimo;
                }
                // parametro per il corretto scorrimento della lista in caso di eliminazione
                trovata = true;
                tentativi_rimanenti++;
                break;
            }
        }
        if(!trovata) {
            q = t;
            t = t->prossimo;
        }

        trovata = false;
    }

    return *this;
}

// funzione ausiliaria che copia il tentativo t1 in t fatta eccezione per il puntatore
// al prossimo elemento che viene per sicurezza inizializzato a nullptr
void Wordle::copia_tentativo(tentativo* t, const tentativo *t1) const{
    t->sequenza = new char[lunghezza+1];
    t->risultato = new char[lunghezza+1];
    strncpy(t->sequenza, t1->sequenza, lunghezza);
    t->sequenza[lunghezza] = '\0';

    strcpy(t->risultato, t1->risultato);
    //for(unsigned i = 0; i < lunghezza; ++i)
    //    t->risultato[i] = t1->risultato[i];

    t->prossimo = nullptr;
}

Wordle& Wordle::operator=(const Wordle &w){
    // controllo aliasing
    if(this == &w)
        return *this;

    // pulizia del corrente storico
    distruggi_storico();
    storico = nullptr;

    // aggiornamento della lunghezza della parola da indovinare se necessario
    if(lunghezza != w.lunghezza) {
        delete[] sequenza_segreta;
        lunghezza = w.lunghezza;
        sequenza_segreta = new char[lunghezza+1];
    }

    // copia di w nel corrente Wordle
    strcpy(sequenza_segreta, w.sequenza_segreta);
    tentativi_rimanenti = w.tentativi_rimanenti;

    if(w.storico == nullptr)
        return *this;

    storico = new tentativo;
    copia_tentativo(storico, w.storico);

    tentativo* t1 = w.storico->prossimo;
    tentativo* t = storico;

    while(t1 != nullptr){
        t->prossimo = new tentativo;
        copia_tentativo(t->prossimo, t1);
        t1 = t1->prossimo;
        t = t->prossimo;
    }

    gioco_avviato = w.gioco_avviato;

    return *this;
}