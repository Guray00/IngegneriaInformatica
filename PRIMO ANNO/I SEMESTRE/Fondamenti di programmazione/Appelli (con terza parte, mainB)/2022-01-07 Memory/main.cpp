#include <iostream>
#include "compito.h"
using namespace std;

int main() {

    cout<<"--- PRIMA PARTE ---"<<endl<<endl;
    cout<<"Test del costruttore"<<endl;
    Memory m(3);
    cout<<m<<endl;

    cout<<"Test della inserisci"<<endl;
    m.inserisci('U', 2,0,2,2); // inserimento scorretto
    m.inserisci('X', 2,0,2,2); // inserimento scorretto
    m.inserisci('S', 2,0,2,2); // inserimento corretto
    cout<<m<<endl;

    cout<<"Test della riassumi"<<endl;
    m.riassumi();
    cout<<endl;

    cout<<"Test della flip: ";
    cout<<m.flip(2,2,2,0)<<endl;
    cout<<"Altro test della flip: ";
    cout<<m.flip(0,0,0,1)<<endl;
    cout<<m<<endl;

    cout<<"Altro test della riassumi"<<endl;
    m.riassumi();
    cout<<endl;

    cout<<"Inserimenti leciti"<<endl;
    m.inserisci('T',0,1,2,1);
    m.inserisci('P',1,0,0,0);
    m.inserisci('C',0,2,1,2);
    m.inserisci('S',2,0,2,2);

    cout<<"Altro test della flip: ";
    cout<<m.flip(0,0,0,0)<<endl;
    cout<<m<<endl;

    {
        Memory m1(4);
        cout<<"Test del distruttore"<<endl<<endl;
    }


    cout<<"--- SECONDA PARTE ---"<<endl<<endl;
    {
        cout<<"Test del costruttore di copia"<<endl;
        Memory m1(m);
        cout<<m1<<endl;

        cout<<"Altro test del distruttore"<<endl;
    }

    cout<<"Distruzione avvenuta"<<endl<<endl;

    cout<<"Costruzione di un Memory 2x2"<<endl;
    Memory m1(2);
    m1.inserisci('S',0,0,0,1);
    cout<<"Altro test della flip: ";
    cout<<m1.flip(0,0,1,0)<<endl;
    cout<<m1<<endl;

    cout<<"Test operatore +"<<endl;
    Memory m2 =m1+m;
    cout<<m2<<endl;
    cout<<m+m1<<endl;

    cout<<"Test operatore >> con i=1"<<endl;
    cout<<(m>>1)<<endl;

    cout<<"Test operatore >> con i=-2"<<endl;
    m1>>-2;
    cout<<m1<<endl;

    cout<<"--- TERZA PARTE ---"<<endl<<endl;

    cout<<"Inserimento in caselle fuori dal tabellone"<<endl;
    m.inserisci('C',1,1,3,2);
    cout<<m<<endl;

    cout<<"Inserimento con casella occupata"<<endl;
    m.inserisci('C',1,1,2,2);
    cout<<m<<endl;

    cout<<"Inserimento nella stessa casella"<<endl;
    m1.inserisci('G',1,0,1,0);
    cout<<m1<<endl;

    cout<<"Test della flip con una tessera inesistente: ";
    cout<<m2.flip(0,0,2,2)<<endl;
    cout<<"Flip corretta: ";
    cout<<m2.flip(0,0,0,1)<<endl;
    cout<<m2<<endl;

    cout<<"Riassumi con tabellone non vuoto ma nessuna coppia"<<endl;
    m2.riassumi();
    cout<<endl;

    cout<<"Concatenazione dell'operatore >>"<<endl;
    Memory m3(4);
    m3.inserisci('T',2,1,3,0);
    m3.inserisci('G',3,1,1,2);
    m3.inserisci('S',2,2,1,0);
    m3>>2>>-2;
    cout<<m3<<endl;

    cout<<"Rotazione con i>3"<<endl;
    m3>>9; //equivalente a m3>>1;
    cout<<m3<<endl;

    cout<<"Rotazione con i<-3"<<endl;
    m3>>-9; // equivalente a m3>>3;
    cout<<m3;

    return 0;
}