#include "compito.h"
#include <cstring>
using namespace std;

Supermercato::Supermercato() {
    prodotti = nullptr;
    for(int i = 0; i < NUM_CARRELLI; ++i)
        carrelli[i].cliente = 0; // codice speciale per il cliente non presente
}

Supermercato::~Supermercato(){
    prodotto* q;
    while(prodotti != nullptr){
        q = prodotti;
        delete[] prodotti->nome;
        prodotti = prodotti->next;
        delete q;
    }

    // deallocazione carrelli (relativo a seconda parte)
    for(int i = 0; i < NUM_CARRELLI; ++i){
        if(carrelli[i].cliente > 0) {
            carrello::elemento_carrello *cc;
            while (carrelli[i].contenuto != nullptr) {
                cc = carrelli[i].contenuto;
                carrelli[i].contenuto = carrelli[i].contenuto->next;
                delete cc;
            }
        }
    }
}

Supermercato::prodotto* Supermercato::cerca_prodotto(const char *nome_prodotto) const {
    prodotto* p = prodotti;
    while( p != nullptr && strcmp(nome_prodotto, p->nome) > 0)
        p = p->next;

    if(p == nullptr || strcmp(nome_prodotto, p->nome))
        return nullptr;

    return p;
}

Supermercato::prodotto* Supermercato::alloca_ed_inizializza_prodotto(const char *nome_prodotto,
                                                                     float prezzo_unitario, prodotto* next) {
    prodotto* p = new prodotto;
    p->nome = new char [strlen(nome_prodotto)+1];
    strcpy(p->nome, nome_prodotto);
    p->quantita = 0;
    p->prezzo_unitario = prezzo_unitario;
    p->next = next;

    return p;
}

void Supermercato::crea_prodotto(const char *nome_prodotto, float prezzo_unitario) {
    if(prezzo_unitario <= 0)
        return;

    if(cerca_prodotto(nome_prodotto) != nullptr) // prodotto presente
        return;

    if(prodotti == nullptr || strcmp(prodotti->nome, nome_prodotto) > 0) { // inserimento in testa / ordinato in testa
        prodotti = alloca_ed_inizializza_prodotto(nome_prodotto, prezzo_unitario, prodotti);
        return;
    }

    // inserimento nel mezzo
    prodotto* q = prodotti;
    while(q->next != nullptr && strcmp(q->next->nome, nome_prodotto) < 0) // cerco il punto da inserire
        q = q->next;

    q->next = alloca_ed_inizializza_prodotto(nome_prodotto, prezzo_unitario, q->next);
}

void Supermercato::aggiorna_prodotto(Supermercato::prodotto *p, int quantita, float prezzo_unitario) {
    p->quantita += quantita;
    p->prezzo_unitario = prezzo_unitario;
}

void Supermercato::esponi(const char *nome_prodotto, int quantita, float prezzo_unitario) {
    if(quantita < 0 || prezzo_unitario < 0.0) // caso input sicuramente erroneo
        return;

    prodotto* p = cerca_prodotto(nome_prodotto);

    if(p == nullptr) // caso prodotto assente
        return;

    prezzo_unitario = (prezzo_unitario == 0) ? p->prezzo_unitario : prezzo_unitario;
    aggiorna_prodotto(p, quantita, prezzo_unitario);
}

Supermercato::carrello* Supermercato::cerca_cliente(int codice_cliente) {
    for(int i = 0; i < NUM_CARRELLI; ++i)
        if(carrelli[i].cliente == codice_cliente)
            return &carrelli[i];

    return nullptr;
}

Supermercato::carrello* Supermercato::cerca_carrello_libero() {
    for(int i = 0; i < NUM_CARRELLI; ++i)
        if(carrelli[i].cliente == 0)
            return &carrelli[i];

    return nullptr;
}

void Supermercato::occupa_carrello(int codice_cliente, carrello *carrello_libero) {
    carrello_libero->cliente = codice_cliente;
    carrello_libero->contenuto = nullptr;
}

Supermercato& Supermercato::operator+=(int codice_cliente) {
    if(codice_cliente <= 0)
        return *this;

    if(cerca_cliente(codice_cliente) != nullptr) // cliente giÃ  presente
        return *this;

    carrello* carrello_libero = cerca_carrello_libero();

    if(carrello_libero == nullptr)
        return *this;

    // occupazione del primo carrello libero da parte del cliente
    occupa_carrello(codice_cliente, carrello_libero);

    return *this;
}

Supermercato::carrello::elemento_carrello* Supermercato::alloca_ed_inizializza_elemento_carrello(
        Supermercato::prodotto *p, int quantita, carrello::elemento_carrello* next) {
    carrello::elemento_carrello *e = new carrello::elemento_carrello;
    e->merce = p;
    e->quantita = quantita;
    e->next = next;

    return e;
}

void Supermercato::prendi_prodotto(carrello::elemento_carrello *&carrello_cliente, prodotto *p, int quantita) {
    // caso inserimento in testa / ordinato in testa
    if(carrello_cliente == nullptr || strcmp(carrello_cliente->merce->nome, p->nome) > 0) {
        carrello_cliente = alloca_ed_inizializza_elemento_carrello(p, quantita, carrello_cliente);
        return;
    }

    if(carrello_cliente->merce == p){
        carrello_cliente->quantita += quantita;
        return;
    }

    carrello::elemento_carrello* q = carrello_cliente;
    while(q->next != nullptr && strcmp(q->next->merce->nome, p->nome) < 0) // sappiamo giÃ  che q != nullptr
        q = q->next;

    if(q->next!= nullptr && q->next->merce == p){ // il prodotto era giÃ  presente nel carrello
        q->next->quantita += quantita;
        return;
    }

    // il prodotto non era giÃ  nel carrello
    q->next = alloca_ed_inizializza_elemento_carrello(p, quantita, q->next);
}

void Supermercato::metti_nel_carrello(int codice_cliente, const char *nome_prodotto, int quantita) {
    if(quantita <= 0)
        return;

    prodotto* p = cerca_prodotto(nome_prodotto);
    if(p == nullptr || p->quantita == 0) // prodotto assente
        return;

    carrello* c = cerca_cliente(codice_cliente);
    if(c == nullptr) // cliente assente
        return;

    quantita = (quantita > p->quantita) ? p->quantita : quantita; // da ora in poi la quantita non crea problemi
    p->quantita -= quantita; // rimuoviamo immediatamente il prodotto dal magazzino

    //cliente giÃ  presente
    prendi_prodotto(c->contenuto, p, quantita);
}

float Supermercato::acquista(int codice_cliente) {
    carrello* c = cerca_cliente(codice_cliente);

    if(c == nullptr)
        return -1.0;

    float spesa = 0;
    carrello::elemento_carrello *ee;
    while(c->contenuto != nullptr) {
        ee = c->contenuto;
        spesa += c->contenuto->quantita * c->contenuto->merce->prezzo_unitario;
        c->contenuto = c->contenuto->next;
        delete ee;
    }

    c->cliente = 0;
    return spesa;
}

ostream& operator<<(ostream& os, const Supermercato& s){
    os<<"prodotti:"<<endl;
    for(Supermercato::prodotto* p = s.prodotti; p != nullptr; p = p->next)
        os << p->nome << ' ' << p->quantita << ' ' << p->prezzo_unitario << endl;

    os << endl << "clienti:" << endl;
    bool nessun_cliente = true;


    for(int i = 0; i < Supermercato::NUM_CARRELLI; ++i)
        if(s.carrelli[i].cliente != 0){
            nessun_cliente = false;

            os << '[' << i+1 << '-' << s.carrelli[i].cliente << "]:";

            for(Supermercato::carrello::elemento_carrello* e = s.carrelli[i].contenuto; e != nullptr; e = e->next)
                os << ' ' << e->merce->nome << " (" << e->quantita << ") |";

            os << endl;
        }

    if(nessun_cliente)
        os << "nessun cliente presente." << endl;

    return os;
}