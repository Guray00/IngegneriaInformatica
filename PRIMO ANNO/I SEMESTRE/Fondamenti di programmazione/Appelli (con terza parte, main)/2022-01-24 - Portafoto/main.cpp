#include <iostream>
#include "compito.h"

int main() {
    cout<<"--- PRIMA PARTE ---"<<endl<<endl;
    cout<<"Test del costruttore"<<endl;
    Portafoto p(3);
    cout<<p<<endl;

    cout<<"Test della aggiungi"<<endl;
    cout<<p.aggiungi(1,1)<<endl;
    cout<<p.aggiungi(3,0)<<endl<<endl;

    p.aggiungi(1,1);
    p.aggiungi(2,1);
    p.aggiungi(2,2);
    p.aggiungi(2,3);
    p.aggiungi(3,1);
    cout<<p<<endl;

    cout<<"Test della associa"<<endl;
    cout<<p.associa(1,1,3,1)<<endl;
    cout<<p.associa(1,3,2,2)<<endl<<endl;

    p.associa(2,2,1,2);
    p.associa(2,3,1,1);
    cout<<p<<endl;

    cout<<"Test dell'aggiornamento delle associazioni dopo aggiunta"<<endl;
    p.aggiungi(3,2);
    p.aggiungi(3,1);
    cout<<p<<endl;

    cout<<"--- SECONDA PARTE ---"<<endl<<endl;
    cout<<"Test della elimina"<<endl;
    cout<<p.elimina(3,3)<<endl;
    cout<<p.elimina(3,3)<<endl<<endl;
    cout<<p<<endl;

    cout<<"Test dell'aggiornamento delle associazioni dopo eliminazioni"<<endl;
    p.elimina(1,2);
    p.elimina(2,2);
    cout<<p<<endl;

    {
        cout<<"Operatore di assegnamento"<<endl;
        Portafoto p2(5);
        p2.aggiungi(1,1);
        p2.aggiungi(4,1);
        p2.aggiungi(4,2);
        p2.aggiungi(5,1);
        p2.aggiungi(5,1);
        p2.aggiungi(5,1);
        p2.aggiungi(5,1);

        p2.associa(4,2,5,2);
        p2.associa(4,1,1,1);
        p2.associa(5,3,5,2);

        p = p2;
        cout<<p<<endl;

        cout<<"Test del distruttore"<<endl;
    }

    cout<<"Oggetto distrutto"<<endl<<endl;


    cout<<"--- TERZA PARTE ---"<<endl<<endl;

    Portafoto p2(4);
    cout<<"Aggiunta foto con posizione non positiva: ";
    cout<<p2.aggiungi(-1, 3)<<endl;

    cout<<"Aggiungi foto con indice di colonna troppo grande: ";
    cout<<p2.aggiungi(1,5)<<endl;

    cout<<"Aggiunta di foto nel mezzo di una colonna"<<endl;
    p2.aggiungi(3,1);
    p2.aggiungi(3,2);
    p2.aggiungi(3,2);
    p2.aggiungi(3,3);
    cout<<p2<<endl;

    cout<<"Associazione di una foto non esistente: ";
    cout<<p2.associa(1,1,3,3)<<endl;
    cout<<"Associazione di una foto con una fuori limiti: ";
    cout<<p2.associa(3,3,5,2)<<endl<<endl;
    cout<<"Associazione di una foto con se' stessa: ";
    cout<<p2.associa(3,3,3,3)<<endl<<endl;

    cout<<"Eliminazione in testa"<<endl;
    p2.elimina(3,1);
    cout<<p2<<endl;

    cout<<"Sovrascrittura di associazione"<<endl;
    p2.associa(3,2,3,4);
    p2.associa(3,2,3,1);
    cout<<p<<endl;

    cout<<"Varie aggiungi e associazioni"<<endl;
    p2.aggiungi(1,1);
    p2.aggiungi(2,1);
    p2.aggiungi(4,1);
    p2.aggiungi(2,2);
    p2.aggiungi(1,1);
    p2.aggiungi(4,2);
    p2.aggiungi(4,3);

    p2.associa(4,1,3,1);
    p2.associa(1,1,3,1);
    p2.associa(4,2,3,3);
    p2.associa(3,3,4,2);
    p2.associa(2,2,4,3);
    p2.associa(4,3,1,1);
    p2.associa(2,1,3,3);
    cout<<p2<<endl;

    cout<<"Varie aggiungi"<<endl;
    p2.aggiungi(1,1);
    p2.aggiungi(2,1);
    p2.aggiungi(3,1);
    p2.aggiungi(4,1);
    p2.aggiungi(1,3);
    p2.aggiungi(2,3);
    p2.aggiungi(3,3);
    p2.aggiungi(4,3);
    cout<<p2<<endl;

    cout<<"Varie eliminazioni"<<endl;
    p2.elimina(3,2);
    p2.elimina(3,2);
    p2.elimina(4,4);
    cout<<p2<<endl;

    cout<<"Test aliasing"<<endl;
    p2 = p2;
    cout<<p2;

    return 0;
}