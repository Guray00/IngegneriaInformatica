#include "compito.h"

VoliDelGiorno::VoliDelGiorno() {
    testa = nullptr;
}

ostream& operator<<(ostream& os, const VoliDelGiorno& vg){
    
    for(elem* p = vg.testa; p != nullptr; p = p->pun){
        os << "- Orario: " << p->orario << endl;
        os << "  Destinazione: " << p->destinazione << endl;
        if (p->annullato)
            os << "  Annullato: Si" << endl;
        else
            os << "  Annullato: No" << endl;
    }

    return os;
}

bool VoliDelGiorno::aggiungi(const char* orario, const char* destinazione) {

    //controllo formato orario
    if(strlen(orario) != 5 || orario[0] < '0' || orario[0] > '2' || orario[1] < '0' ||
    orario[1] > '9' || orario[2] != '.' || orario[3] < '0' || orario[3] > '5' ||
    orario[4] < '0' || orario[4] > '9')
        return false; //non aggiunge se orario non valido

    //controllo formato destinazione: vuote e lunghezza
    if(strlen(destinazione) == 0 || strlen(destinazione) > 20)
        return false; //non aggiunge stringa vuota o troppo lunga

    //controllo formato destinazione: carattere per carattere
    for(int i = 0; i < strlen(destinazione); i++){
        if(destinazione[i] != ' ' && (destinazione[i] < 'a' || destinazione[i] > 'z'))
            return false;
    }

    elem *p, *q, *r;
    for(p = testa; p != nullptr && strcmp(p->orario, orario) < 0; p = p->pun)
        q = p;
    if(p != nullptr && strcmp(p->orario, orario) == 0)
        return false; //orario giÃ  presente in lista

    r = new elem;
    strcpy(r->orario, orario);
    strcpy(r->destinazione, destinazione);
    r->annullato = false;

    r->pun = p;
    if(p == testa)
        testa = r;
    else
        q->pun = r;

    return true;
}

bool VoliDelGiorno::annulla(const char* orario) {

    for(elem* p = testa; p != nullptr; p = p->pun){
        if(strcmp(p->orario, orario) == 0 && !p->annullato) {
            p->annullato = true;
            return true;
        }
    }

    return false; //lista vuota o elemento non trovato o gia' annullato
}

VoliDelGiorno::VoliDelGiorno(const VoliDelGiorno& vg) {

    testa = nullptr;

    for(elem* p = vg.testa; p != nullptr; p = p->pun){
        aggiungi(p->orario, p->destinazione);
        if (p->annullato)
            annulla(p->orario);
    }
}

VoliDelGiorno::~VoliDelGiorno(){

    elem* p;
    while(testa != nullptr){
        p = testa->pun;
        delete testa;
        testa = p;
    }
}

VoliDelGiorno VoliDelGiorno::nonAnnullati() const {
    VoliDelGiorno vg;
    for(elem* p = testa; p != nullptr; p = p->pun){
        if(!p->annullato)
            vg.aggiungi(p->orario, p->destinazione);
    }

    return vg;
}

VoliDelGiorno& VoliDelGiorno::operator~() {
    for(elem* p = testa; p != nullptr; p = p->pun){
        p->annullato = !p->annullato;
    }

    return *this;
}

VoliDelGiorno VoliDelGiorno::operator+(const VoliDelGiorno& vg) const {
    VoliDelGiorno vg_somma = *this;

    for(elem* p = vg.testa; p != nullptr; p = p->pun){
        vg_somma.aggiungi(p->orario, p->destinazione);
        if(p->annullato)
            vg_somma.annulla(p->orario);
    }

    return vg_somma;
}