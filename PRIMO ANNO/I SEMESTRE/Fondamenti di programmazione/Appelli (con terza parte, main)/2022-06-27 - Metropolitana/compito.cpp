#include "compito.h"

// l'informazione di presenza o meno del treno puÃ² essere rappresentata da capienza==0
// questo rende ridondante l'attributo presenza_treno
// tuttavia questa ottimizzazione non Ã¨ stata realizzata al fine di una migliore comprensibilitÃ  del codice
// da parte dello studente

Metropolitana::Metropolitana() {
    for(int i=0; i<num_stazioni; ++i){
        for (int j = 0; j < num_stazioni; ++j)
            grafo[i][j] = false;
        stazioni[i].utenti = 0;
        stazioni[i].presenza_treno = false;
    }
}

ostream& operator<<(ostream& os, const Metropolitana& m) {
    for (int i = 0; i < num_stazioni; ++i){
        if(m.stazioni[i].utenti<10)
            os<<' ';
        os << m.stazioni[i].utenti<<' ';
        if (m.stazioni[i].presenza_treno) {
            if (m.stazioni[i].capienza<10)
                os << ' ';
            os << m.stazioni[i].capienza << ' ';
            if (m.stazioni[i].posti_liberi<10)
                os << ' ';
            os << m.stazioni[i].posti_liberi;
        }
        else
            os << " X  X";
        os<<endl;
    }

    os<<endl;
    for(int i=1; i<=num_stazioni; ++i)
        for(int j=i+1; j<=num_stazioni; ++j)
            if(m.grafo[i-1][j-1])
                os<<i<<" <-> "<<j<<"  ";

    os<<endl;
    return os;
}

int Metropolitana::aggiungi_utenti(int quanti, int staz) {
    if(quanti<=0 || staz<=0 || staz > num_stazioni)
        return 0;

    stazione* s = &stazioni[--staz];

    int rimanenti = quanti;
	// in caso di treno presente carico quanti piÃ¹ utenti possibili
    if(s->presenza_treno) {
        if (s->posti_liberi >= quanti) {
            s->posti_liberi -= quanti;
            return quanti;
        }
        rimanenti -= s->posti_liberi;
        s->posti_liberi = 0;
    }

	// in caso vi siano ulteriori utenti rimanenti
	// controllo se riescono a mettersi tutti in fila
    int eccesso = s->utenti+rimanenti-max_utenti;
	
    if(eccesso<=0){
        s->utenti += rimanenti;
        return quanti;
    }

    s->utenti = max_utenti;
    return quanti-eccesso;
}

//indici a base 0
// dÃ  per scontato ci sia un treno di quella linea
void Metropolitana::scarica_treno(int quanti, stazione* s) {
    // sto attento che il numero di utenti da far scendere non sia negativo
	if(quanti<=0)
        return;

	// sto attento che il numero di utenti da far scendere non ecceda i presenti
    if(quanti>s->capienza-s->posti_liberi)
        s->posti_liberi = s->capienza;
    else
        s->posti_liberi += quanti;
}

// indici a base 0
// dÃ  per scontato ci sia un treno di quella linea
void Metropolitana::carica_treno(stazione* s) {
    int quanti = s->utenti;
    if(quanti > s->posti_liberi)
        quanti = s->posti_liberi;

    s->utenti -= quanti;
    s->posti_liberi -= quanti;
}

// indici a base 0
bool Metropolitana::arrivo_treno(int quanti_scendono, int posti_liberi, int capienza, stazione* s){
	// controllo che alla stazione di arrivo non sia giÃ  presente un treno
    if(s->presenza_treno)
        return false;

	// aggiorno la stazione con i dati del treno
    s->presenza_treno = true;
    s->capienza = capienza;
    s->posti_liberi = posti_liberi;
	
	// faccio scendere gli utenti che lo desiderano
    scarica_treno(quanti_scendono, s);
	
	// faccio salire quanti piÃ¹ utenti in fila possibile
    carica_treno(s);

    return true;
}

bool Metropolitana::aggiungi_treno(int posti, int staz) {
    if(posti<=0 || posti > max_capienza || staz<=0 || staz>num_stazioni)
        return false;
	
	// se gli input sono corretti, questo scenario puÃ² essere trattato come un particolare
	// caso di treno in arrivo in una determinata stazione
    return arrivo_treno(0, posti, posti, &stazioni[--staz]);
}

Metropolitana& Metropolitana::aggiungi_connessione(int stazione1, int stazione2) {
    if(stazione1<=0 || stazione2<=0 || stazione1>num_stazioni || stazione2>num_stazioni)
        return *this;

    if(stazione1 == stazione2 || grafo[--stazione1][--stazione2])
        return *this;

    grafo[stazione1][stazione2] = true;
    grafo[stazione2][stazione1] = true;

    return *this;
}

// --- SECONDA PARTE ---

bool Metropolitana::rimuovi_treno(int staz){
    if(staz<=0 || staz > num_stazioni)
        return false;

    stazione* s = &stazioni[--staz];

    if(!s->presenza_treno)
        return false;

    int nuovi_utenti = s->utenti+s->capienza-s->posti_liberi;
    if(nuovi_utenti>max_utenti)
        return false;

    s->utenti = nuovi_utenti;
    s->presenza_treno = false;

    return true;
}

bool Metropolitana::muovi_treno(int quanti_scendono, int stazione1, int stazione2) {
    if(stazione1<=0 || stazione2<=0 || stazione1>num_stazioni || stazione2>num_stazioni)
        return false;

    if(!grafo[--stazione1][--stazione2])
        return false;

    stazione* s = &stazioni[stazione1];
    if(!s->presenza_treno)
        return false;

    if(!arrivo_treno(quanti_scendono, s->posti_liberi, s->capienza, &stazioni[stazione2]))
        return false;

    s->presenza_treno = false;

    return true;
}


int Metropolitana::operator!() const {

    int delta = 0;
    for(int i=0; i<num_stazioni; ++i) {
        if (stazioni[i].presenza_treno)
            delta -= stazioni[i].posti_liberi;
        delta += stazioni[i].utenti;
    }

    return delta;
}

Metropolitana& Metropolitana::operator++() {
    for(int i=0; i<num_stazioni; ++i)
        if(stazioni[i].utenti<max_utenti){
            if(!stazioni[i].presenza_treno || stazioni[i].posti_liberi==0)
                stazioni[i].utenti++;
            else
                stazioni[i].posti_liberi--;
        }

    return *this;
}