#include "compito.h"
#include <cstring>

LegoSet::LegoSet(){
    testa = nullptr;
}

ostream& operator<<(ostream& os, const LegoSet& set){
    for(LegoSet::elem* p = set.testa; p != nullptr; p = p->pun){
        os << p->descr << ", ";
        switch(p->colore){
            case 'n':
                os << "nero";
                break;
            case 'b':
                os << "bianco";
                break;
            case 'r':
                os << "rosso";
                break;
            case 'v':
                os << "verde";
                break;
            case 'l':
                os << "blu";
                break;
        }
        os << endl;
    }
    return os;
}

void LegoSet::aggiungiMattoncino(const char* descr, char colore){
    if(strlen(descr) > MAXDESCR) return;
    if(colore != 'n' && colore != 'b' && colore != 'r' && colore != 'v' && colore != 'l') return;

    elem* p;
    elem* q;
    for(p = testa; p != nullptr; p = p->pun)
        q = p;

    elem* r = new elem;
    strcpy(r->descr, descr);
    r->colore = colore;
    if(p == testa)
        testa = r;
    else
        q->pun = r;

    r->pun = p;
}

void LegoSet::eliminaMattoncino(const char* descr){
    elem* p;
    elem* q;
    for(p = testa; p != nullptr && strcmp(p->descr, descr); p = p->pun)
        q = p;
    if(p == nullptr) // il mattoncino non esiste, non faccio nulla
        return;

    if( p == testa)
        testa = testa->pun;
    else
        q->pun = p->pun;

    delete p;
}

int operator%(const LegoSet& set, char colore){
    if(colore != 'n' && colore != 'b' && colore != 'r' && colore != 'v' && colore != 'l') return 0;
    int quanti = 0;
    LegoSet::elem* p;
    for(p = set.testa; p != nullptr; p = p->pun){
        if(p->colore == colore) quanti++;
    }
    return quanti;
}

LegoSet::mattoncinoComune LegoSet::mattonciniComuni[MAXMATTCOMUNI];

void LegoSet::eliminaMattoncino(char colore){
    if(colore != 'n' && colore != 'b' && colore != 'r' && colore != 'v' && colore != 'l') return;

    elem* p;
    elem* q;
    for(;;){
        for(p = testa; p != nullptr && p->colore != colore; p = p->pun)
            q = p;
        if(p == nullptr) // non esistono (piu') mattoncini del colore c, quindi smetto di eliminarli
            return;

        if(p == testa)
            testa = testa->pun;
        else
            q->pun = p->pun;

        delete p;
    }
}

void LegoSet::aggiungiMattoncinoComune(int codice, const char* descr, char colore){
    if(codice < 1 || codice > MAXMATTCOMUNI) return;
    if(strlen(descr) > MAXDESCR) return;
    if(colore != 'n' && colore != 'b' && colore != 'r' && colore != 'v' && colore != 'l') return;

    if(mattonciniComuni[codice-1].creato) return; // questo mattoncino comune e' gia' stato creato, quindi non lo ricreo e nemmeno lo aggiungo al set
    strcpy(mattonciniComuni[codice-1].descr, descr);
    mattonciniComuni[codice-1].colore = colore;
    mattonciniComuni[codice-1].creato = true;

    aggiungiMattoncinoComune(codice);
}

void LegoSet::aggiungiMattoncinoComune(int codice){
    if(codice < 1 || codice > MAXMATTCOMUNI) return;
    if(!mattonciniComuni[codice-1].creato) return; // questo mattoncino comune non e' ancora stato creato, quindi non posso aggiungerlo

    elem* p;
    elem* q;
    for(p = testa; p != nullptr; p = p->pun)
        q = p;
    if(p != nullptr) // il mattoncino esiste gia', non faccio nulla
        return;

    elem* r = new elem;
    strcpy(r->descr, mattonciniComuni[codice-1].descr);
    r->colore = mattonciniComuni[codice-1].colore;
    if(p == testa)
        testa = r;
    else
        q->pun = r;

    r->pun = p;
}

LegoSet::~LegoSet(){
    elem* p = testa;
    while(testa != nullptr) {
        testa = testa->pun;
        delete p;
        p = testa;
    }
}