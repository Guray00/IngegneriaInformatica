#include "compito.h"

//funzione di utilita' che inserisce un nuovo elemento in fondo alla lista
void Gantt::insFondo(int vincolata, int vincolante){
    if( p0 == nullptr ){ // la lista e' vuota
        p0 = new elem;
        p0->vincolata = vincolata;
        p0->vincolante = vincolante;
        p0->pun = nullptr;
        return;
    }
    if( p0->pun == nullptr ){ // esiste un solo elemento
        p0->pun = new elem;
        p0->pun->vincolata = vincolata;
        p0->pun->vincolante = vincolante;
        p0->pun->pun  = nullptr;
        return;
    }
    elem *q = p0, *p;
    while( q != nullptr ){
        p = q;
        q = q->pun;
    }
    p->pun = new elem;
    p->pun->vincolata = vincolata;
    p->pun->vincolante = vincolante;
    p->pun->pun  = nullptr;    
    return;
}

// funzione di utilita' 2: rimuove tutte le dipendenze aventi attivita' vincolata pari a prog
void Gantt::rimuoviVincolata(int prog){
    // eliminazione in testa
    elem *p;
    while( p0 != nullptr && p0->vincolata == prog ){
        p = p0;
        p0 = p0->pun;
        delete p;
    }
    // eliminazione in mezzo o in coda
    if( p0 != nullptr ){
        p = p0;
        while( p->pun != nullptr ){
            if ( p->pun->vincolata == prog ){
                elem*q = p->pun;
                p->pun = q->pun;
                delete q;
            }else{
                p = p->pun;
            }
        }
    }
}
// funzione di utilita' 3: rimuove tutte le dipendenze aventi attivita' vincolante pari a prog
void Gantt::rimuoviVincolante(int prog){
    // eliminazione in testa
    elem *p;
    while( p0 != nullptr && p0->vincolante == prog ){
        p = p0;
        p0 = p0->pun;
        delete p;
    }
    // eliminazione in mezzo o in coda
    if( p0 != nullptr ){
        p = p0;
        while( p->pun != nullptr ){
            if ( p->pun->vincolante == prog ){
                elem*q = p->pun;
                p->pun = q->pun;
                delete q;
            }else{
                p = p->pun;
            }
        }
    }
}

ostream& operator<<(ostream &os, const Gantt&g){
    os<<"--+-------------------------------------------------+"<<endl;    
    os<<"  |M-       M1-       M2-       M3-       M4-       |"<<endl;
    os<<"  +-------------------------------------------------+"<<endl;
    os<<"  |1234567890123456789012345678901234567890123456789|"<<endl;
    os<<"--+-------------------------------------------------+"<<endl;    
    for (int i = 0; i < g.quanteAtt; i++){
        os<<'A'<<(i+1)<<'|';
        int j;
        for ( j = 0; j < g.vettAtt[i].inizio-1; j++)
            os<<' ';

        for ( j = g.vettAtt[i].inizio; j < g.vettAtt[i].inizio+ g.vettAtt[i].durata; j++)
            os<<'#';
        while ( j <= MAXMESI ){
            os<<' ';
            j++;
        }
        os<<"| "<< g.vettAtt[i].descr<<endl;
    }
    os<<"--+-------------------------------------------------+"<<endl;    
    os<<"Dip: ";
    elem*p = g.p0;
    while( p!= nullptr ){
        os<<p->vincolata<<"=>"<<p->vincolante<<' ';
        p = p->pun;
    }
    os<<endl<<"--+-------------------------------------------------+"<<endl;        
    return os;
}

Gantt& Gantt::aggiungiAtt(const char *descr, int inizio, int durata){
    if ( strlen(descr) > MAXCHAR || inizio < 1 || durata > MAXMESI || inizio+durata-1 > MAXMESI || quanteAtt >= MAXATT)
        return *this;

    strcpy(vettAtt[quanteAtt].descr, descr);
    vettAtt[quanteAtt].inizio = inizio;
    vettAtt[quanteAtt].durata = durata;
    quanteAtt++;
    return *this;
}

Gantt& Gantt::aggiungiDip(int a, int b){
    if ( a < 1 || b < 1 || a > quanteAtt || b > quanteAtt || a == b )
        return *this;
        
    if ( vettAtt[a-1].inizio < vettAtt[b-1].inizio + vettAtt[b-1].durata )
        return *this;
    
    insFondo(a,b);
	quanteDip++;
    return *this;
}


// SECONDA PARTE

Gantt& Gantt::rimuoviAtt(int prog){
    
    if ( prog < 1 || prog > quanteAtt)
        return *this;
        
    int i;
    for ( i = prog; i < quanteAtt; i++){
        strcpy(vettAtt[i-1].descr, vettAtt[i].descr);
        vettAtt[i-1].inizio = vettAtt[i].inizio;
        vettAtt[i-1].durata = vettAtt[i].durata;
    }
    quanteAtt--;

    rimuoviVincolata(prog);
    rimuoviVincolante(prog);

    // ora aggiorno i numeri delle attivita'
    elem* p = p0;
    while( p != nullptr ){
        if( p->vincolata >= prog )
            p->vincolata--;
        if( p->vincolante > prog )
            p->vincolante--;
        p = p->pun;
    }

    return *this;
}

Gantt& Gantt::anticipaAtt(int prog, int mesi){
    
    if ( prog < 1 || prog > quanteAtt)
        return *this;
    int max_anticipabile = mesi;
    elem *p = p0;
    while( p!= nullptr){
        if (p->vincolata == prog){
            int delta = vettAtt[prog-1].inizio - ( vettAtt[p->vincolante-1].inizio + vettAtt[p->vincolante-1].durata);
            if ( max_anticipabile > delta)
                max_anticipabile = delta;
        }
        p=p->pun;
    }
    vettAtt[prog-1].inizio -= max_anticipabile;
    if ( vettAtt[prog-1].inizio <= 0 )
        vettAtt[prog-1].inizio = 1;
    return *this;
}


Gantt::~Gantt(){
    elem *p = p0;
    while ( p0 != nullptr ){
        p  = p0;
        p0 = p0->pun;
        delete p;
    }
}
