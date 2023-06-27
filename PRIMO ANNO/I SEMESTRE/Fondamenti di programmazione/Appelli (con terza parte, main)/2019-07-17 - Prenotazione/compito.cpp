#include <iostream>
#include "compito.h"

using namespace std;

// funzioni di utilita' per le liste - DICHIARAZIONE

static void distruggi(Lista&);
static void inserisci(Lista&, cliente);
static void estrai(Lista&, int);
static bool presente(Lista&, int);

// Funzione amica

ostream& operator<<(ostream& s, const Prenotazione& x) {
    Lista q = x.gold;

    // stampo i prenotati gold
    s << "GOLD" << endl;
    q = x.gold;
    while (q != NULL) {
        s << q->info.id << endl;
        q = q->next;
    }

    // stampo i prenotati silver
    s << "SILVER" << endl;
    q = x.silver;
    while (q != NULL) {
        s << q->info.id << endl;
        q = q->next;
    }
    return s;
}

// operazioni membro di Prenotazione

Prenotazione::Prenotazione() {
    aperta = true;
    gold = NULL;
    silver = NULL;
}

Prenotazione::~Prenotazione() {
    distruggi(gold);
    distruggi(silver);
}

void Prenotazione::prenota(int cli, tipo ti) {
    if (cli <= 0 || !aperta) return; // codice cliente non valido o prenotazione chiusa

    if (presente(gold, cli) || presente(silver, cli) ) return; // prenotazione gia' presente

    // registro la prenotazione
    cliente c = {cli, ti};
    if (ti == GOLD)
        inserisci(gold, c);
    else
        inserisci(silver, c);
}

void Prenotazione::cancella(int cli, tipo ti) {
    if (cli <= 0 || !aperta) return; // codice cliente non valido o prenotazione chiusa

    // ritiro la prenotazione, se esiste
    if (ti == GOLD)
        estrai(gold, cli);
    else
        estrai(silver, cli);
}

Prenotazione::operator int() const{

    // conto i prenotati gold
    int conta_gold = 0;
    Lista q = gold;
    while (q != NULL) {
       conta_gold++;
       q = q->next;
    }
    if (conta_gold >= N)
       return 0; // non c'e' spazio per i prenotati silver

    // conto i prenotati silver
    int conta_silver = 0;
    q = silver;
    while (q != NULL) {
       conta_silver++;
       q = q->next;
    }
    if (conta_silver >= N - conta_gold)
       return N - conta_gold; // c'e' spazio per i prenotati silver fino ad esaurimento posti
    return conta_silver; // c'è spazio per tutti i prenotati silver
}

Ammessi Prenotazione::chiudi() {
    Ammessi risu;
    int conta = 0;

    // chiudo le prenotazioni
    aperta = false;

    // confermo tutti i gold (o fino ad esaurimento posti)
    Lista q = gold;
    while (q != NULL && conta < N) {
        risu.elenco[conta] = q->info;
        conta++;
        q = q->next;
    }
    // confermo tutti i silver (o fino ad esaurimento posti)
    q = silver;
    while (q != NULL && conta < N) {
        risu.elenco[conta] = q->info;
        conta++;
        q = q->next;
    }
    risu.quanti = conta;
    return risu;
}

// funzioni di utilita' per le liste - DEFINIZIONE

static void distruggi(Lista& s) {
    Lista q;

    if (s == NULL) return;
    q = s;
    s = s->next;
    delete q;
    distruggi(s);
}
static void inserisci(Lista& s, cliente cli) {
    Lista q = new elem;
    q->info = cli;
    if (s == NULL) {
        q->next = s;
        s = q;
        return;
    }
    else inserisci(s->next, cli);
}
static void estrai(Lista& s, int id) {
    if (s == NULL) return;
    if (s->info.id == id) {
        Lista q = s;
        s = s->next;
        delete q;
        return;
    }
    estrai(s->next, id);
}
static bool presente(Lista& s, int id) {
    if (s == NULL) return false;
    if (s->info.id == id) return true;
    return presente(s->next, id);
}

