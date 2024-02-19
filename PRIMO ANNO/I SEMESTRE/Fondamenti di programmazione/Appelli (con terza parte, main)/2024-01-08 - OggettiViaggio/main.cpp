#include "compito.h"
#include <iostream>
using namespace std;

int main(){

    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test costruttore e funzione aggiungi" << endl;
    OggettiViaggio ov;
    ov.aggiungi("Caricatore");
    ov.aggiungi("Cuffie");
    ov.aggiungi("Macchina fotografica");
    ov.aggiungi("Documenti");
    ov.aggiungi("Biglietti aereo");
    ov.aggiungi("Vestiti");
    cout << ov << endl;

    cout << "Test funzione prendi" << endl;
    ov.prendi("Documenti");
    ov.prendi("Macchina fotografica");
    ov.prendi("Caricatore");
    cout << ov << endl;

    cout << "Test funzione viaggia" << endl;
    ov.viaggia();
    cout << ov << endl;

    cout << "Test costruttore di copia" << endl;
    OggettiViaggio ov2 = ov;
    ov2.aggiungi("Oggetto 1");
    ov2.aggiungi("Oggetto 2");
    ov2.aggiungi("Oggetto 3");
    cout << ov2 << endl;


    cout << "--- SECONDA PARTE ---" << endl;
    cout << "Test eventuale distruttore" << endl;
    {
        OggettiViaggio ov3;
        ov3.aggiungi("Oggetto 1");
        ov3.aggiungi("Oggetto 2");
        ov3.aggiungi("Oggetto 3");
    }
    cout << "Distruttore chiamato" << endl;

    cout << "Test operatore +=" << endl;
    ov.prendi("Cuffie");
    ov.prendi("Macchina fotografica");
    OggettiViaggio ov3;
    ov3.aggiungi("Spazzolino");
    ov3.aggiungi("Dentifricio");
    ov3.aggiungi("Occhiali da sole");
    ov3.prendi("Occhiali da sole");
    ov += ov3;
    cout << ov << endl;

    cout << "Test funzione rimuovi" << endl;
    ov.rimuovi("Cuffie");
    ov.rimuovi("Macchina fotografica");
    ov.rimuovi("Caricatore");
    cout << ov << endl;

    cout << "Test operatore di negazione logica" << endl;
    ov.prendi("Vestiti");
    ov.prendi("Documenti");
    cout << !ov << endl;


    cout << "--- TERZA PARTE ---" << endl;
    cout << "Test funzione aggiungi con input non validi" << endl;
    ov.aggiungi("Oggetto di lunghezza maggiore di quaranta caratteri"); // non aggiunge
    ov.aggiungi(""); // lo deve aggiungere
    ov.aggiungi("Spazzolino"); // gia' presente
    ov.aggiungi("Occhiali da sole"); // gia' presente
    cout << ov << endl;

    cout << "Test funzione prendi con input non validi" << endl;
    ov.prendi("Oggetto fuori lista"); // non prende
    ov.prendi("Occhiali da sole"); // oggetto gia' preso
    cout << ov << endl;

    cout << "Test funzione rimuovi" << endl;
    ov.rimuovi("Oggetto fuori lista"); // non rimuove
    ov.rimuovi("");
    cout << ov << endl;

    cout << "Test operatore negazione logica" << endl;
    ov.prendi("Biglietti aereo");
    ov.prendi("Spazzolino");
    ov.prendi("Dentifricio");
    const OggettiViaggio ov4 = ov;
    cout << ov4 << endl << !ov4 << endl;

    cout << "Test operatore +=" << endl;
    ov.viaggia();
    ov.prendi("Spazzolino");
    ov.prendi("Dentifricio");
    OggettiViaggio ov5;
    ov5.aggiungi("Documenti");
    ov5.aggiungi("Spazzolino");
    ov5.aggiungi("Biglietti aereo");
    ov5.prendi("Biglietti aereo");
    ov5.aggiungi("Phono");
    ov += ov5;
    cout << ov << endl;

    return 0;
}