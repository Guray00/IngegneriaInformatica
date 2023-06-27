#include "compito.h"

ParteFraz::ParteFraz(double pf){
    if ( ( pf < 0 ) || ( pf >= 1 ) )
        exit(1);

    pFraz = 0u;
    unsigned short int mask = 0x8000;
    int i = 1;
    while ( i <= PRECISION ) {
        // valuta l'i-esimo bit dopo la virgola:
        double doppio = 2 * pf;
        int a_m_i = int(doppio);
        // lo memorizza nel corrispondente bit di pFraz:
        if ( a_m_i )
            pFraz |= mask;

        double f_m_i = doppio - a_m_i;

       // cout<<"f-"<<i<<":"<<f_m_i<<" ";
       // cout<<"a-"<<i<<":"<<a_m_i<<endl;

        if ( f_m_i == 0 )
            break;

        mask>>=1u;
        pf = f_m_i;
        i++;
    }
}


ostream& operator<<(ostream&os, const ParteFraz &p){
    unsigned short int mask = 0x8000;
    for (int i = 1; i<= PRECISION; i++){
        if ( p.pFraz & mask )
           os<<'1';
        else
           os<<'0';
        mask>>=1u;
    }
    os<<'b'<<endl;
    return os;
}



// Funzione di utilita', aggiunta per implementare in maniera piu'
// semplice la funzione raddoppia di VirgolaFissa. 
// Restituisce true se il raddoppio fa diventare il numero >=1.
bool ParteFraz::radd(){
    bool aux;
    if ( pFraz & 0x8000u )
        aux = true;
    else
        aux = false;
    pFraz<<=1u;
    return aux;
}


// classe VirgolaFissa
ostream& operator<<(ostream&os, const VirgolaFissa &v){
    os<<'('<<dec<<v.pI<<','<<double(v.pF)<<')'<<endl;
    return os;
}

VirgolaFissa& VirgolaFissa::raddoppia() {
    pI*=2;
    bool aux = pF.radd();
    if (aux)
        pI++;
    return *this;
}