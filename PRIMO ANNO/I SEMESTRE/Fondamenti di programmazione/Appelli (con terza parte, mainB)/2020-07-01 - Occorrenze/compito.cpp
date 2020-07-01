//
// Created by utente on 2020-05-12.
//

#include "compito.h"

// Funzioni di utilità
void Occorrenze::dealloca(elem *p){
    if ( p == NULL )
        return;
    dealloca( p->pun );
    delete p; // deallocazione mediante ricorsione in coda
}

void Occorrenze::inserisci(const char par[]) {
    elem *q, *p;
    for (q = p0; q != NULL && strcmp(q->parola,par) <= 0; q=q->pun)
        p = q;
    if ( q == p0 ){ // caso inserimento ordinato in testa
        p0 = new elem;
        strcpy(p0->parola, par);
        p0->occ = 1;
        p0->pun = q;
    }else{
        if ( strcmp( p->parola, par) == 0){ // parola già esistente. Basta incrementare
            p->occ++;
        }else{ // caso inserimento ordinato in mezzo o in coda
            elem *n = new elem;
            strcpy(n->parola, par);
            n->occ = 1;
            n->pun = q;
            p->pun = n;
        }
    }
}


Occorrenze::Occorrenze(const char *frase) {
    p0 = NULL;
    char aux[MAXLEN];
    int i, h;
    i = h = 0;
    while ( 1 ) {
        // leggo una parola e la aggiungo tra le occorrenze
        while (frase[i] != '\0' && frase[i] != ' ')
            aux[h++] = frase[i++];
        aux[h] = '\0';
        inserisci(aux);
        h = 0;
        // salto gli eventuali spazi tra una parola e l'altra
        while ( frase[i] == ' ' )
            i++;
        // termino se sono arrivato a fine frase
        if ( frase[i] == '\0' )
            break;
    }
}


ostream& operator<<(ostream &os, const Occorrenze &o){
    elem *q=o.p0;
    while( q != NULL ){
        os<<q->parola<<':'<<q->occ<<endl;
        q = q->pun;
    }
    return os;
}


int Occorrenze::operator%(int val)const{
    int quante = 0;
    elem *q = p0;
    while ( q != NULL ){
        if ( q->occ >= val )
            quante++;
        q = q->pun;
    }
    return quante;
}




// SECONDA PARTE

Occorrenze& Occorrenze::operator+=(const char *parola){
    if ( strlen(parola) <= MAXLEN-1 )
        inserisci(parola);
    return *this;
}


int Occorrenze::operator[](const char par[])const{
    elem *q = p0;
    while ( q!=NULL ){
        if (strcmp(q->parola,par)==0)
            return q->occ; // ritorna il numero di occorrenze, se la parola è presente
        q = q->pun;
    }
    return 0; // ritorna 0 nel caso la parola non sia presente
}


Occorrenze& Occorrenze::operator-=(char C) {

    // cancello le eventuali occorrenze in testa alla lista
    while (p0 != NULL && p0->parola[0] == C){
        elem *aux = p0;
        p0 = p0->pun;
        delete aux;
    }

    // cancello le eventuali occorrenze in mezzo alla lista
    elem *p = p0;
    while ( p!= NULL && p->pun != NULL){
        if ( p->pun->parola[0] == C){
            elem *aux = p->pun;
            p->pun = p->pun->pun;
            delete aux;
        }
        else
            p = p->pun;
    }
    return *this;
}

