#include "compito.h"

ostream& operator<<(ostream &os, const Bit16 &b){
    unsigned int maschera = 1 << (LEN-1);
    os<<"+----------------+"<<endl;
    os<<"|FEDCBA9876543210|"<<endl;
    os<<"+----------------+"<<endl<<'|';
    for (int i=0; i < LEN; i++){
        (b.stato & maschera) != 0u ? os<<'1' : os<<'0';
        maschera >>= 1;
    }
    os<<'|'<<endl;
    os<<"+----------------+"<<endl;
    os<<endl;
    return os;
}


ostream& operator<<(ostream &os, const Mask16 &b){
    unsigned int maschera = 1 << (LEN-1);
    os<<"+----------------+"<<endl;
    os<<"|FEDCBA9876543210|"<<endl;
    os<<"+----------------+"<<endl<<'|';
    for (int i=0; i < LEN; i++){
        (b.stato & maschera) == 0u ? os<<'#' : os<<b.valore;
        maschera >>= 1;
    }
    os<<'|'<<endl;
    os<<"+----------------+"<<endl;
    os<<endl;
    return os;
}

Bit16 operator|(const Bit16 &b, const Mask16 &m){
    if (m.valore)
        return b.stato | m.stato;
    else
        return b.stato;
}

Bit16 operator&(const Bit16 &b, const Mask16 &m){
    if (m.valore)
        return b.stato;
    else
        return b.stato & (~m.stato);
}


Bit16 operator^(const Bit16 &b, const Mask16 &m){
    if (m.valore)
        return b.stato ^ m.stato;
    else
        return b.stato;

}

int Mask16::quantiMascherati()const{
    unsigned int maschera = 1u;
    int counter = 0;
    for(int i = 0; i < LEN; i++){
        if ( (stato & maschera) == 0u)
            counter++;
        maschera <<= 1u;
    }
    return counter;
}


Mask16 Mask16::ruotaADestra(int d)const{
    unsigned int s = stato;
    s = (s >> d) | (s << (LEN - d));
    Mask16 m(s,valore);
    return m;
}


Mask16 Bit16::mascheraConvertitrice(const Bit16 &ba)const{
    Mask16 ris(stato^ba.stato,true);
    return ris;
}