#include <iostream>
#include "compito.h"

using namespace std;

int main() {

    cout << "--- PRIMA PARTE ---" << endl<<endl;

    cout<<"Test del costruttore:"<<endl;
    Supermercato s;
    cout<<s<<endl;

    cout<<"Test della crea_prodotto:"<<endl;
    s.crea_prodotto("pere", 2.3);
    s.crea_prodotto("sale", 1.3);
    s.crea_prodotto("ananas", 2.1);
    cout<<s<<endl;

    cout<<"Test della esponi:"<<endl;
    s.esponi("pere", 10);
    s.esponi("sale", 4);
    s.esponi("ananas", 3);
    cout<<s<<endl;

    {
        cout<<"Test dell'eventuale distruttore"<<endl<<endl;

        Supermercato ss;
        ss.crea_prodotto("pere", 2.3);
        ss.crea_prodotto("sale", 1.3);
        ss.crea_prodotto("ananas", 2.1);
        ss.esponi("pere", 10);
        ss.esponi("sale", 4);
        ss.esponi("ananas", 4);
    }

    

    cout << endl << "--- SECONDA PARTE ---" << endl<<endl;

    cout<<"Test dell'operatore +=:"<<endl;
    s += 42940;
    s += 42950;
    s += 42951;
    cout<<s<<endl;

    cout<<"Test della metti_nel_carrello:"<<endl;
    s.metti_nel_carrello(42950, "pere", 2);
    s.metti_nel_carrello(42950, "sale", 1);
    s.metti_nel_carrello(42950, "ananas", 1);
    cout<<s<<endl;

    cout<<"Altro test della esponi:"<<endl;
    s.esponi("ananas", 2);
    s.esponi("pere", 1);
    cout<<s<<endl;

    cout<<"Altro test della metti_nel_carrello:"<<endl;
    s.metti_nel_carrello(42940, "ananas", 2);
    s.metti_nel_carrello(42950, "ananas", 1);
    s.metti_nel_carrello(42950, "sale", 1);
    s.metti_nel_carrello(42951, "sale", 1);
    cout<<s<<endl;

    cout<<"Test della acquista:"<<endl;
    cout<<"Spesa sostenuta: "<<s.acquista(42950)<<endl<<endl;
    cout<<s<<endl;

    {
        cout<<"Altro test dell'eventuale distruttore"<<endl<<endl;

        Supermercato ss;
        ss.crea_prodotto("pere", 2.3);
        ss.crea_prodotto("sale", 1.3);
        ss.crea_prodotto("ananas", 2.1);
        ss += 42950;
        ss += 42951;
        ss += 42940;
        ss.esponi("pere", 10);
        ss.esponi("sale", 4);
        ss.esponi("ananas", 4);
        ss.metti_nel_carrello(42950, "pere", 2);
        ss.metti_nel_carrello(42950, "sale", 1);
        ss.metti_nel_carrello(42950, "ananas", 1);
    }

    

    cout << endl << "--- TERZA PARTE ---" << endl<<endl;

    cout<<"Altro test della crea_prodotto"<<endl;
    s.crea_prodotto("uva", -1.3); // fallisce: prezzo unitario negativo
    s.crea_prodotto("ananas", 1.2); // fallisce: prodotto giÃ  presente
    s.crea_prodotto("mela", 0.0); // fallisce: prezzo unitario nullo
    s.crea_prodotto("banane", 4.3);
    s.crea_prodotto("zucchero", 3.9);
    cout<<s<<endl;


    cout<<"Altro test della esponi:"<<endl;
    s.esponi("banane", 3);
    s.esponi("zucchero", 2);
    cout<<s<<endl;

    cout<<"Altro test dell'operatore +=:"<<endl;
    s += 42944;
    s += 42943;
    cout<<s<<endl;

    cout<<"Altro test della metti_nel_carrello:"<<endl;
    s.metti_nel_carrello(42943, "uva", 3); // fallisce: prodotto assente
    s.metti_nel_carrello(42943, "banane", -2); // fallisce: quantita negativa
    s.metti_nel_carrello(42942, "banane", 2); // fallisce: cliente assente
    s.metti_nel_carrello(42943, "banane", 2);
    s.metti_nel_carrello(42943, "sale", 4); // esegue ma il sale Ã¨ insufficiente
    s.metti_nel_carrello(42944, "sale", 3); // fallisce: prodotto presente in quantitÃ  nulla
    s.metti_nel_carrello(42943, "pere", 1);
    s.metti_nel_carrello(42943, "zucchero", 1);
    cout<<s<<endl;

    cout<<"Altro test della esponi:"<<endl;
    s.esponi("mele", 5, 1.9); // fallisce: prodotto assente
    s.esponi("ananas", -5, 1.9); // fallisce: quantita negativa
    s.esponi("banane", 5, -1.9); // fallisce: prezzo unitario negativo
    s.esponi("ananas", 5, 0.0); // esegue ma non modifica il prezzo unitario
    s.esponi("pere", 5, 1.9); // sconto sulle pere
    cout<<s<<endl;

    cout << "Altro test dell'operatore +=" << endl;
    s += 31313;
    s += 21212; // non deve essere inserito perchÃ© i carrelli a disposizione sono finiti
    cout << s << endl;

    cout<<"Altro test della acquista:"<<endl;
    cout<<"Spesa sostenuta: "<<s.acquista(42943)<<endl<<endl; // la spesa risente dello sconto sulle pere
    cout<<s<<endl;

    cout<<"Altro test della acquista:"<<endl;
    cout<<"Spesa sostenuta: "<<s.acquista(42953)<<endl; // cliente assente
    cout<<"Spesa sostenuta: "<<s.acquista(42951)<<endl; 
    cout<<"Spesa sostenuta: "<<s.acquista(42944)<<endl<<endl; // il cliente non compra niente
    cout<<s<<endl;

    cout << "Altro test della esponi:" << endl;
    s.esponi("ananas", 0, 0.1);
    cout<<s<<endl;

    return 0;
}