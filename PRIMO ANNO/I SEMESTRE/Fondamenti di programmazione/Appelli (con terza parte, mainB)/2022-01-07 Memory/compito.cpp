#include "compito.h"
//#include <iostream>
//using namespace std;

Memory::Memory(int dim) {

    // sanitizzazione degli input
    if(dim<=0)
        dim = 3;

    punteggio = 0;
    dimensione = dim;
    caselle = new char[dim*dim];
    for(int i=0; i<dim*dim; ++i)
        caselle[i] = '-';
}

ostream& operator<<(ostream &os, const Memory &m) {

    for(int i=0; i<m.dimensione; ++i) {
        for (int j=0; j<m.dimensione-1; ++j)
            os<<m.caselle[i*m.dimensione+j]<<' ';

        os<<m.caselle[(i+1)*m.dimensione-1]<<endl;
    }

    os<<endl<<"Punteggio: "<<m.punteggio<<endl;

    return os;
}

void Memory::inserisci(char tipo, int r1, int c1, int r2, int c2) {

    // caso tipo inserito non esistente
    if(tipo!='G' && tipo!='C' && tipo!='S' && tipo!='P' && tipo!='T')
        return;

    // caso di caselle nel tabellone inesistenti
    if(r1<0 || r1>=dimensione || c1<0 || c1>=dimensione || r2<0 || r2>=dimensione || c2<0 || c2>=dimensione)
        return;

    // caso di medesima casella
    if(r1==r2 && c1==c2)
        return;

    // caso di caselle nel tabellone piene
    if(caselle[r1*dimensione+c1] != '-' || caselle[r2*dimensione+c2] != '-')
        return;

    // caso corretto
    caselle[r1*dimensione+c1] = caselle[r2*dimensione+c2] = tipo;
}

int Memory::char2indice(char c) {
    switch (c) {
        case 'G': return 0;
        case 'C': return 1;
        case 'S': return 2;
        case 'P': return 3;
        default:  return 4; // 'T' (non si possono verificare scenari di input non corretto)
    }
}

const char* Memory::indice2char(int indice) {
    switch (indice) {
        case 0: return "Gatto: ";
        case 1: return "Cane: ";
        case 2: return "Serpente: ";
        case 3: return "Pavone: ";
        default:  return "Tigre: "; // 4 (non si possono verificare scenari di input non corretto)
    }
}

void Memory::riassumi() const {

    // vettore contenente il numero di tessere di ogni tipo
    // l'indice del vettore a cui ciascun tipo Ã¨ associato si puÃ² dedurre dalle funzioni indice2char/char2indice
    int presenze[num_tipi];
    for(int i=0; i<num_tipi; ++i)
        presenze[i] = 0;

    // conteggio
    for(int i=0; i<dimensione*dimensione; ++i)
        if(caselle[i]!='-')
            presenze[char2indice(caselle[i])]++;

    // verifico che non ci siano coppie rimaste
    bool nessuna_coppia = true;
    for(int i=0; i<num_tipi; ++i)
        if(presenze[i]>1){
            // trovato almeno un tipo di tessera che presenta una coppia nel tabellone
            nessuna_coppia = false;
            break;
        }

    // caso con nessuna coppia rimasta
    if(nessuna_coppia){
        cout<<"VITTORIA!"<<endl;
        return;
    }

    // caso in cui vi sia almeno una coppia (notare l'operazione di divisione intera per 2 fatta attraverso shift)
    for(int i=0; i<num_tipi; ++i)
        cout<<indice2char(i)<<(presenze[i]>>1)<<endl;
}

bool Memory::flip(int r1, int c1, int r2, int c2) {
    // caso input erronei
    if(r1<0 || r1>=dimensione || c1<0 || c1>=dimensione || r2<0 || r2>=dimensione || c2<0 || c2>=dimensione)
        return false;

    // caso in cui le due tessere sono la stessa
    if(r1==r2 && c1==c2)
        return false;

    // caso in cui le caselle siano vuote
    if(caselle[r1*dimensione+c1] == '-' || caselle[r2*dimensione+c2] == '-')
        return false;

    // caso coppia di tessere uguale
    if(caselle[r1*dimensione+c1] == caselle[r2*dimensione+c2]){
        punteggio++;
        caselle[r1*dimensione+c1] = caselle[r2*dimensione+c2] = '-';
        return true;
    }

    // caso coppia di tessere diverse
    punteggio--;
    return false;
}

Memory::Memory(const Memory &m){

    punteggio = 0;
    dimensione=m.dimensione;
    caselle = new char[dimensione*dimensione];
    for(int i=0; i<dimensione*dimensione; ++i)
        caselle[i] = m.caselle[i];
}

Memory Memory::operator+(const Memory &m) const {
    // istanzio il Memory risultato come copia dell'operando sinistro
    Memory m1(*this);

    // calcolo la dimensione del sotto-tabellone da considerare
    int dim = (m.dimensione>dimensione)? dimensione : m.dimensione;
    // calcolo l'offset di cui spostarmi lungo le colonne quando restringo la copia al sotto-tabellone
    // N.B. uno dei due offset Ã¨ sempre zero
    int offset_m1 = dimensione-dim;
    int offset_m = m.dimensione-dim;

    // copio
    for(int i=0; i<dim; ++i)
        for(int j=0; j<dim; ++j)
            if(m1.caselle[i*dimensione+offset_m1+j]=='-')
                m1.caselle[i*dimensione+offset_m1+j] = m.caselle[i*m.dimensione+offset_m+j];

    return m1;

}

void Memory::ruota_90() {

    // creo una copia dell'attuale tabellone
    char copia[dimensione*dimensione];
    for(int i=0; i<dimensione*dimensione; ++i)
        copia[i] = caselle[i];

    // colloco il contenuto della casella (i,j) in quella di arrivo dopo la rotazione
    // ovvero (j, dimensione-1-i)
    for(int i=0; i<dimensione; ++i)
        for(int j=0; j<dimensione; ++j)
            caselle[(j+1)*dimensione-i-1] = copia[i*dimensione+j];
}

Memory& Memory::operator>>(int angolo) {

    // Idea: ruoto il tabellone di 90Â° angolo volte
    // il numero di rotazioni Ã¨ un numero da 0 a 3
    angolo %= 4;
    // se negativo lo converto al corrispondente valore da 0 a 3 (es. -1 -> 3)
    if(angolo<0)
        angolo += 4;

    for(int i=0; i<angolo; ++i)
        ruota_90();

    return *this;
}