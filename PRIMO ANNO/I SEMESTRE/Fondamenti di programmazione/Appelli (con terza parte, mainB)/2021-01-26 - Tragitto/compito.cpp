#include "compito.h"

Tragitto::Tragitto(){
	elem *p = new elem;
    strcpy(p->nome, "");
    p->pun = nullptr;
	
    testa = new elem;
    strcpy(testa->nome, "");
    testa->pun = p;
}

ostream& operator<<(ostream& os, const Tragitto& perc){
    Tragitto::elem* p = perc.testa;
    int i = 1;
    while(p!=nullptr){
        os<<"["<<i<<"] ";
        if(strcmp(p->nome, "") != 0){
            os<<p->nome<<endl;
        }
        else{
            os<<"/////"<<endl;
        }
        p = p->pun;
        i++;
    }
    return os;
}


bool Tragitto::inserisci(const char* n){
    if (strlen(n) > 19) 
        return false;
    //controllo la prima postazione
    if(strcmp(testa->nome, "") != 0){
        return false;
    }
    //controllo se esiste una persona con lo stesso nome nel Tragitto
    elem* p = testa;
    while( p!=nullptr ){
        if(strcmp(p->nome, n) == 0)
                return false;
        p = p->pun;
    }
    //posso inserire in prima posizione
    strcpy(testa->nome, n);
    return true;
}


bool Tragitto::avanza(int j){
    if ( j < 1) 
        return false;
    //identifico la i-esima postazione
    elem* p = testa;
    int i = 1;
    while( p != nullptr && i < j ){
        p = p->pun;
        i++;
    }
    //se essa non esiste o e' vuota, non faccio niente
    if ( (p == nullptr) || (strcmp(p->nome, "") == 0)) 
        return false;
    
    //se essa è l'ultima postazione, faccio uscire l'eventuale persona
    if ( p->pun == nullptr ){
        strcpy(p->nome, "");
        return true;
    }
    //se la postazione successiva e' vuota, faccio avanzare la persona
    if( strcmp(p->pun->nome, "") == 0 ) {
        strcpy(p->pun->nome, p->nome);
        strcpy(p->nome, "");
        return true;
    }
    //altrimenti non faccio niente
    return false;
}

// --- SECONDA PARTE ---

Tragitto& Tragitto::operator+=(int k){
    if( k <= 0 ){
        return *this;
    }
    //cerco la coda della lista
    //(qui assumo che esista almeno una postazione)
    elem* p = testa;
    while( p->pun != nullptr )
        p = p->pun;
    //aggiungo alla lista k nuove postazioni
    for( int i = 0; i < k; i++ ){
        p->pun = new elem;
        p = p->pun;
        strcpy(p->nome, "");
    }
    //chiudo la lista
    p->pun = nullptr;
    return *this;
}

Tragitto::Tragitto(const Tragitto& perc){
    //(qui assumo che esista almeno una postazione)
    testa = new elem;
    strcpy(testa->nome, perc.testa->nome);
    //copio restanti postazioni, se presenti
    elem* p = testa;
    elem* q = perc.testa->pun;
    while( q != nullptr ){
        p->pun = new elem;
        p = p->pun;
        strcpy(p->nome, q->nome);
        q = q->pun;
    }
    //chiudo la lista
    p->pun = nullptr;
}

Tragitto::~Tragitto(){
    elem* p = testa;
    while( testa != nullptr ){
        testa = testa->pun;
        delete p;
        p = testa;
    }
}
