#include <iostream>
using namespace std;


#include "compito.h"


int main() {

    cout<<"--- PRIMA PARTE ---"<<endl;

    Calendario c("Mio calendario");

    cout << "Test del costruttore e stampa a video:" << endl << endl;
    cout << c;


    cout << "\nTest della aggiungiEvento (deve stampare 1101000):" << endl;
    cout << c.aggiungiEvento("Meeting", "Discussione con team", 10, 9, 2024);
    cout << c.aggiungiEvento("Compleanno", "Compleanno Gojo", 7, 12, 1989);
    cout << c.aggiungiEvento("Conferenza", "Conferenza a Shibuya", 32, 9, 2024); // deve fallire
    cout << c.aggiungiEvento("Dentista", "Appuntamento dentista", 8, 9, 2024);
    cout << c.aggiungiEvento("Vacanza", "Vacanza", 10, 9, 2024); // deve fallire perchÃ© data giÃ  presente
    cout << c.aggiungiEvento("Workshop", "Coding workshop.", 22, 13, 2024); // deve fallire
    cout << c.aggiungiEvento("     ", "Evento con tutti spazi", 22, 10, 2024) << endl; // deve fallire


    cout << "\nTest stampa calendario:" << endl << endl;
    cout << c;

    cout << "\nTest della rimuoviEvento (deve stampare 10):" << endl;
    cout << c.rimuoviEvento(10, 9, 2024);
    cout << c.rimuoviEvento(32, 13, 2025) << endl << endl;
    cout << c << endl;;


    cout<<"--- SECONDA PARTE ---"<<endl;

    cout << "Test ulteriore della aggiungiEvento (deve stampare 11111):" << endl;

    Calendario c2("Eventi progetto");
    cout << c2.aggiungiEvento("Meeting", "Meeting con il team.", 10, 1, 2025);
    cout << c2.aggiungiEvento("Presentazione", "Presentazione risultati", 10, 2, 2025);
    cout << c2.aggiungiEvento("Meeting", "Meeting con revisori", 11, 2, 2025);
    cout << c2.aggiungiEvento("Revisione", "Meeting per correzione bozze", 18, 4, 2025);
    cout << c2.aggiungiEvento("Consegna", "Consegna progetto", 22, 5, 2025) << endl;


    cout << "\nTest ricerca eventi che hanno keyword 'Meeting':" << endl << endl;
    Calendario projectEvents = c2.cercaEventi("Meeting");
    cout << projectEvents;

    cout << "\nAltro test rimuoviEvento:" << endl;
    int numeroRimossi = projectEvents.rimuoviEventiSuccessiviA(28, 2, 2025);
    cout << "Rimosso/i " << numeroRimossi << " evento/i" << endl;


    cout << "Calendario dopo la rimozione:" << endl << endl;
    cout << projectEvents;

    {
        cout << "\nTest costruttore di copia:" << endl << endl;
        Calendario c3(c2);
        cout << c3;
    }


    cout << endl << "-- TERZA PARTE --" << endl;

    // Test: Test keyword che non esiste
    cout << "Test keyword che non esiste:" << endl << endl;
    Calendario noMatchEvents = c.cercaEventi("Vacanza");
    cout << noMatchEvents << endl;

    // Test: Rimozione tutti eventi
    Calendario c4(c2);
    cout << "Rimozione degli eventi dopo il 31/12/2024 da Eventi progetto" << endl;
    c4.rimuoviEventiSuccessiviA(31, 12, 2024);
    cout << c4;

    // Test: Rimozione tutti eventi dopo ultima data
    Calendario c5(c2);
    cout << endl << "Rimozione degli eventi dopo il 1/10/2025 da Eventi progetto: " << endl << endl;
    c5.rimuoviEventiSuccessiviA(1, 10, 2025);
    cout << c5 << endl;

    // Tutte le chiamate su calendario vuoto
    cout << "Test su calendario vuoto: " << endl << endl;
    Calendario empty("");
    cout << empty << endl;
    empty.rimuoviEvento(1, 1, 2000);
    cout << "Rimossi: " << empty.rimuoviEventiSuccessiviA(1, 1, 2000) << endl << endl;
    Calendario empty2(empty);
    Calendario tmp = empty2.cercaEventi("parolachiave");
    cout << tmp << endl;

    // Test con fuzzy degli input stringa
    Calendario nullStr(nullptr);
    Calendario vuota("     ");
    Calendario lunghezzanulla("");
    cout << nullStr << endl << vuota << endl << lunghezzanulla << endl;
    cout << nullStr.aggiungiEvento("","descrizione", 1, 1, 2001);
    cout << nullStr.aggiungiEvento("titolo","    ", 1, 1, 2001);
    cout << nullStr.aggiungiEvento("xurxmjferjhwuurabgqcsjyyouuojmdqosekepjrmaipqsezgqb","descrizione",1, 1, 2000);
    cout << nullStr.aggiungiEvento("titolo","vcnqkzfwdaectpmczrprtlgobyycmwszpelfxkvosvczdlzulvyqbkqednfnlcsqujwlllilddzujiuswfduymkzleemefuynbamb",1, 1, 2000);
    cout << nullStr.aggiungiEvento("xurxmjferjhwuurabgqcsjyyouuojmdqosekepjrmaipqsezgq","descrizione",1, 2, 2000);
    cout << nullStr.aggiungiEvento(nullptr, nullptr, 1, 1, 2001) << endl;
    Calendario tmp2 = nullStr.cercaEventi("    ");
    cout << endl << tmp2 << endl;

    // Altri test
    Calendario ccc("prova");
    cout << ccc.aggiungiEvento("Meeting", "Discussione con team", 10, 9, 2024);
    cout << ccc.aggiungiEvento("Meeting", "Discussione con team", 10, 9, 2024);
    cout << ccc.aggiungiEvento("Meeting", "Discussione con team", 10, 10, 2024);
    cout << ccc.aggiungiEvento("Meeting", "Discussione con team", 10, 10, 2024) << endl;

    return 0;
}