#include <iostream>
#include "compito.h"

using namespace std;

int main() {

    cout<<endl<<"--- PRIMA PARTE ---" <<endl<<endl;

    cout<<"Test del costruttore:"<<endl;
    Wordle w(4, 7);
    cout << w << endl;

    cout<<"Test delLa avvia_gioco:"<<endl;
    cout << w.avvia_gioco("ALTO") << endl << endl;
    cout << w << endl;

    cout<<"Test della indovina:"<<endl;
    w.indovina("ORLI");
    w.indovina("ALBE");
    cout << endl << w << endl;

    cout<<endl<<"--- SECONDA PARTE ---" <<endl<<endl;

    cout<<"Test della stampa_storico:"<<endl;
    w.stampa_storico(cout);

    cout<<"Test dell'operatore -=:"<<endl;
    w -= "RL";
    w.stampa_storico(cout);

    cout<<"Test dell'operatore =:"<<endl;
    Wordle w1(6, 9);
    w1.avvia_gioco("JNSKDR");
    w1.indovina("GERJNZ");

    w1 = w;

    cout << w1 << endl;
    w1.stampa_storico(cout);

    cout<<endl<<"--- TERZA PARTE ---" <<endl<<endl;

    cout << "Test avvia_gioco su gioco avviato:" << endl;
    cout << w.avvia_gioco("ALLA") << endl << endl;

    // test costruttore argomento scorretti
    cout << "Test indovina su gioco non avviato:" << endl;
    Wordle w2(-2, -6);
    w2.indovina("BALLA");
    cout << w2 << endl;

    cout << "Test avvia_gioco con sequenza mal formattata:" << endl;
    cout << w2.avvia_gioco("AorO") << endl << endl;

    cout << "Test avvia_gioco con sequenza lunga ben formattata:" << endl;
    cout << w2.avvia_gioco("BALLA39o") << endl << endl;

    cout << "Test indovina con sequenza corta:" << endl;
    w2.indovina("MAL");
    cout << w2 << endl;

    cout << "Test indovina su sequenza non ben formattata:" << endl;
    w2.indovina("MALT0");
    cout << w2 << endl;

    cout << "Test indovina su stringa lunga:" << endl;
    w2.indovina("PARCHI");
    cout << w2 << endl;

    cout << "Test indovina su stringa lunga ma non ben formattata:" << endl;
    w2.indovina("PAR-HI");
    cout << w2 << endl;

    cout << "Test indovina su stringa lunga ben formattata:" << endl;
    w2.indovina("VOLTI-");
    cout << w2 << endl;

    cout << "Test \'?\' nel risultato:" << endl;
    w2.indovina("LALAA");
    cout << w2 << endl;

    cout << "Test dello storico dopo inserimenti multipli:" << endl;
    w2.stampa_storico(cout);

    cout << "Test stampa a video dopo vittoria:" << endl;
    w2.indovina("BALLA");
    cout << w2 << endl;

    cout << "Test rimozione storico su gioco non avviato:" << endl;
    w2 -= "LA";
    w2.stampa_storico(cout);

    cout << "Test avvia_gioco su gioco a fine partita:" << endl;
    cout << w2.avvia_gioco("GONNA") << endl << endl;

    cout << "Test stampa di storico vuoto:" << endl;
    w2.stampa_storico(cout);

    cout << "Test diversita' dopo l'assegnamento:" << endl;
    w.indovina("TANE");
    w.indovina("VUOI");
    w.indovina("ANEL");
    w.indovina("ANTE");
    w1.stampa_storico(cout);

    cout << "Test assegnamento con storico lungo:" << endl;
    w1 = w;
    w1.stampa_storico(cout);

    cout << "Test rimozione multipla nel mezzo dello storico:" << endl;
    w -= "ANE";
    w.stampa_storico(cout);

    cout << "Test rimozione dalla testa dello storico:" << endl;
    w -= "TE";
    w.stampa_storico(cout);

    cout << "Test correttezza stato del gioco dopo assegnamento:" << endl;
    w1 = w2;
    cout << w1.avvia_gioco("ALLUA") << endl << endl;

    cout << "Test aliasing assegnamento:" << endl;
    w = w;
    w.stampa_storico(cout);

    cout << "Test su storico svuotato:" << endl;
    w -= "";
    w.stampa_storico(cout);

    return 0;
}