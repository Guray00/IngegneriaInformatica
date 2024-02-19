#include <iostream>
using namespace std;
#include "compito.h"

int main(){
    cout<<"--- PRIMA PARTE ---"<<endl;
    cout << "Test del costruttore e dell'operatore di uscita" << endl;
    Mensa m1(4);
    cout << m1 << endl;

    cout << "Test della occupa" << endl;
    m1.occupa("Pranzante1");
    cout << m1 << endl;
    m1.occupa("Pranzante2");
    m1.occupa("Pranzante3");
    m1.occupa("Pranzante4");
    m1.occupa("Pranzante5"); // non c'e' posto
    cout << m1 << endl;

    cout << "Test della libera (viene liberata la seconda sedia)" << endl;
    m1.libera(2);
    cout << m1 << endl;

    cout<<endl<<"--- SECONDA PARTE ---"<<endl;
    {
        cout << "Test del costruttore di copia" << endl;
        Mensa m2 = m1;
        cout << m2 << endl;
    }
    cout << "Test dell'eventuale distruttore (m2 e' stata appena distrutta)" << endl;

    cout << "Test della ordina()" << endl;
    m1.libera(4);
    m1.occupa("Pranzante0");
    cout << "(prima dell'ordinamento)" << endl << m1;
    m1.ordina();
    cout << "(dopo l'ordinamento)" << endl << m1;

    cout << "Test della occupaGruppo()" << endl;
    m1.libera(3);
    m1.libera(4);
    m1.occupaGruppo("GruppoDiPranzo1", 2);
    cout << m1 << endl;

    cout<<endl<<"--- TERZA PARTE ---"<<endl;
    cout << "Test intensivo della libera()" << endl;
    m1.libera(0); // sedia non esiste
    m1.libera(5); // sedia non esiste
    cout << m1 << endl;

    cout << "Test intensivo della occupa()" << endl;
    m1.libera(1);
    m1.occupa("PranzanteConDietaDavveroSpecialissimaDiVerdure1"); // pranzante con nome lungo, deve essere gestito
    cout << m1 << endl;
    m1.libera(1);
    m1.occupa(""); // pranzante con nome nullo, deve essere gestito
    cout << m1 << endl;
    m1.libera(1);
    m1.occupa("Pranzante0"); // pranzante/gruppo gia' presente
    m1.occupa("GruppoDiPranzo1"); // pranzante/gruppo gia' presente
    cout << m1 << endl;

    cout << "Test intensivo della occupaGruppo()" << endl;
    m1.libera(1);
    m1.libera(2);
    m1.occupaGruppo("GruppoDiPranzo1", 2); // pranzante/gruppo gia' presente
    cout << m1 << endl;
    m1.libera(3);
    m1.libera(4);
    m1.occupaGruppo("GruppoDiPranzo2", 2);
    cout << m1 << endl;
    m1.occupaGruppo("GruppoDiPranzo3", 3); // non c'e' posto
    cout << m1 << endl;

    cout << "Test intensivo della ordina()" << endl;
    m1.occupa("aaaa");
    m1.occupa("aaab");
    m1.libera(2);
    m1.ordina();
    cout << m1 << endl;

    return 0;
}