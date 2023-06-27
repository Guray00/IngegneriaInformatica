#include <iostream>
#include "compito.h"
using namespace std;

int main() {
    cout << "--- PRIMA PARTE ---" << endl<<endl;

    cout<<"b"<<endl;
    Bit16  b(0b1010010000100101);
    cout<<b<<endl;

    cout<<"b2"<<endl;
    Bit16  b2(0b0111111111111110);
    cout<<b2<<endl;

    cout<<"m1"<<endl;
    Mask16 m1(0b00000000000111100,true);
    cout<<m1<<endl;

    cout<<"m0"<<endl;
    Mask16 m0(0b00000000000111100,false);
    cout<<m0<<endl;

    cout<<"b | m1 (mette ad 1 i bit di b specificati dalla 1-maschera m1)"<<endl;
    cout << (b | m1) <<endl;

    cout<<"b & m0 (mette ad 0 i bit di b specificati dalla 0-maschera m0)"<<endl;
    cout << (b & m0) <<endl;

    cout<<"b & m1 (mascheramento inutile: stampa copia di b)"<<endl;
    cout << (b & m1) <<endl;
    cout<<"b | m0 (mascheramento inutile: stampa copia di b)"<<endl;
    cout << (b | m0) <<endl;

    cout << "--- SECONDA PARTE ---" << endl<<endl;

    cout<<"b ^ m1 (inverte i bit di b specificati dalla 1-maschera m1)"<<endl;
    cout << (b ^ m1) <<endl;

    cout<<"b ^ m0 (mascheramento inutile: stampa copia di b)"<<endl;
    cout << (b ^ m0) <<endl;

    cout<<"Il numero di bit mascherati dalla maschera m0 e' (deve stampare 12)"<<endl;
    cout<<m0.quantiMascherati()<<endl;

    cout<<"Il numero di bit mascherati dalla maschera m1 e' (deve stampare 12)"<<endl;
    cout<<m1.quantiMascherati()<<endl;

    cout<<endl<<"Ruoto a destra la maschera m1 di 4 (deve visualizzare 11############11)"<<endl;
    Mask16 mr = m1.ruotaADestra(4);
    cout<<mr<<endl;

    cout<<endl<<"Test della funzione mascheraConvertitrice()"<<endl;
    Bit16 bArrivo(0b1111111100000000);
    Mask16 m1_convertitrice = b.mascheraConvertitrice(bArrivo);
    cout<< m1_convertitrice<<endl;


    cout<<"--- TERZA PARTE ---"<<endl<<endl;
    cout<<"m1 ^ b (inverte i bit di b specificati dalla 1-maschera m1)"<<endl;
    cout << (m1 ^ b) <<endl;

    const Bit16 b3(7u);
    cout<<b3<<endl;

    cout<<"b3 | m1; b3 & m1; b3 ^ m1; m1 ^ b3 (b3 e' const)"<<endl;
    cout << (b3 | m1) <<endl;
    cout << (b3 & m1) <<endl;
    cout << (b3 ^ m1) <<endl;
    cout << (m1 ^ b3) <<endl;

    const Bit16 b4((1u<<16)-1u);
    cout<<b4<<endl;

    cout<<"Altra 1-maschera, associata al naturale 10";
    const Mask16 m1_a(10, true);
    cout<<m1_a<<endl;
    cout<<"Altra 1-maschera, associata al naturale 21";
    const Mask16 m0_a(21, false);
    cout<<m0_a<<endl;

    cout<<"b4 | m1_a; b4 & m0_a; b4 ^ m1_a; m1_a ^ b4 (b4, m1_a, m0_a sono const)"<<endl;
    cout << (b4 | m1_a) <<endl;
    cout << (b4 & m0_a) <<endl;
    cout << (b4 ^ m1_a) <<endl;
    cout << (m1_a ^ b4) <<endl;

    cout<<"Numero bit mascherati in m1_a: "<<m1_a.quantiMascherati()<<endl;
    cout<<"Numero bit mascherati in m0_a: "<<m0_a.quantiMascherati()<<endl;

    cout<<endl<<"Test della funzione mascheraConvertitrice() con argomenti const"<<endl;
    Mask16 m1_convertitrice_a = b3.mascheraConvertitrice(b4);
    cout<< m1_convertitrice_a<<endl;

    return 0;
}