#include <iostream>
#include "compito.h"
using namespace std;

int main() {

    cout<<"--- PRIMA PARTE ---"<<endl<<endl;
    cout<<"Test del costruttore"<<endl;
    Metropolitana m;
    cout<<m<<endl;

    cout<<"Test della aggiungi_connessione"<<endl;
    m.aggiungi_connessione(1,2);
    m.aggiungi_connessione(1,4);
    m.aggiungi_connessione(5,4);
    m.aggiungi_connessione(3,4);
    cout<<m<<endl;

    cout<<"Test della aggiungi_utenti"<<endl;
    cout<<m.aggiungi_utenti(15, 1)<<' '<<m.aggiungi_utenti(-5, 2)<<' '<<m.aggiungi_utenti(7, 9)<<endl<<endl;
    m.aggiungi_utenti(7, 1);
    m.aggiungi_utenti(13, 2);
    cout<<m<<endl;

    cout<<"Test della aggiungi_treno"<<endl;
    cout<<m.aggiungi_treno(30, 1)<<' '<<m.aggiungi_treno(130, 2)<<' '<<m.aggiungi_treno(30, 1)<<endl<<endl;
    cout<<m<<endl;

    m.aggiungi_treno(20, 3);
    cout<<m<<endl;


    cout<<"--- SECONDA PARTE ---"<<endl<<endl;

    cout<<"Test della muovi_treno"<<endl;
    m.muovi_treno(10, 1, 2);
    cout<<m<<endl;
    m.muovi_treno(0, 2, 1);
    m.muovi_treno(-2, 1, 4);
    cout<<m<<endl;
    m.muovi_treno(3, 4, 3);
    cout<<m<<endl;

    cout<<"Test della rimuovi_treno"<<endl;
    m.rimuovi_treno(4);
    cout<<m<<endl;


    cout<<"Test dell'operatore !"<<endl;
    cout<<!m<<endl<<endl;

    cout<<"Test dell'operatore ++"<<endl;
    ++m;
    cout<<m<<endl;


    cout<<endl<<"--- TERZA PARTE ---"<<endl<<endl;

    Metropolitana mm;

    // CASI LIMITE

    cout<<"aggiungi_connessione concatenata"<<endl;
    cout<<"aggiungi connessione con input decrescenti (scambiati)"<<endl;
    cout<<"aggiungi_connessione con input erronei"<<endl;

    // aggiunge                  non fa nulla               non fa nulla              aggiunge
    mm.aggiungi_connessione(3,5).aggiungi_connessione(-1,4).aggiungi_connessione(3,6).aggiungi_connessione(4,2);
    // non fa nulla              non fa nulla               aggiunge                 aggiunge
    mm.aggiungi_connessione(5,3).aggiungi_connessione(0,1).aggiungi_connessione(5,2).aggiungi_connessione(1,2);
    // aggiunge
    mm.aggiungi_connessione(3,1);

    cout<<mm<<endl;

    cout<<"aggiungi utenti con treno libero presente ma un numero > 50"<<endl;
    mm.aggiungi_treno(30, 1);
    mm.aggiungi_utenti(2, 1);
    cout<<mm.aggiungi_utenti(70, 1)<<endl<<endl;
    cout<<mm<<endl;

    cout<<"aggiungi utenti con treno libero presente ma un numero > 50 e che non entrano tutti in fila"<<endl;
    mm.aggiungi_treno(30, 4);
    cout<<mm.aggiungi_utenti(100, 4)<<endl<<endl;
    cout<<mm<<endl;

    cout<<"aggiungi_utenti con stazione negativa"<<endl;
    cout<<mm.aggiungi_utenti(40, -2)<<endl<<endl;
    cout<<mm<<endl;

    cout<<"aggiungi_treno con capienza <=0: ";
    cout<<mm.aggiungi_treno(0, 2)<<endl;

    cout<<"aggiungi_treno con stazione fuori bound: ";
    cout<<mm.aggiungi_treno(10, 6)<<endl;

    cout<<"aggiungi_treno con stazione <=0: ";
    cout<<mm.aggiungi_treno(10, 0)<<endl<<endl;
    cout<<mm<<endl;

    cout<<"aggiungi_treno con numero persone in fila maggiore della capienza"<<endl;
    mm.aggiungi_utenti(50, 5);
    mm.aggiungi_treno(20, 5);
    cout<<mm<<endl;

    cout<<"rimuovi_treno con troppi in fila per farlo"<<endl;
    mm.aggiungi_treno(20, 3);
    mm.aggiungi_utenti(30, 3);
    mm.aggiungi_utenti(30, 3);
    mm.rimuovi_treno(3);
    cout<<mm<<endl;

    cout<<"modifiche alla Metropolitana non rilevanti"<<endl;
    mm.muovi_treno(3, 4, 2);
    mm.rimuovi_treno(2);
    cout<<mm<<endl;

    cout<<"muovi_treno con treno non presente: ";
    cout<<mm.muovi_treno(4, 3, 4)<<endl;

    cout<<"muovi_treno con connessione non presente: ";
    cout<<mm.muovi_treno(4, 3, 2)<<endl<<endl;

    cout<<"muovi_treno con piu' persone che scendono dei posti occupati"<<endl;
    mm.muovi_treno(40, 1, 2);
    cout<<mm<<endl;

    cout<<"modifiche alla struttura dati non rilevanti"<<endl;
    mm.aggiungi_treno(90, 1);
    cout<<mm<<endl;

    cout<<"operatore ! con stazione con gente in fila e treno pieno"<<endl;
    cout<<!mm;

    cout<<"operatore ++ con una stazione piena"<<endl;
    ++mm;
    cout<<mm<<endl;


    return 0;
}