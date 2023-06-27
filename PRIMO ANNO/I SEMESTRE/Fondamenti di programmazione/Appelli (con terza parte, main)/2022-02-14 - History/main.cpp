#include <iostream>
#include "compito.h"

using namespace std;

int main()
{
    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test del costruttore:" << endl;
    History hist;
    cout << hist << endl;

    cout << "Test della record:" << endl;
    hist.record(503, "aaa");
    hist.record(599, "bbb");
    hist.record(-107, "ccc");
    hist.record(405, "ddd");
    hist.record(711, "eee");
    hist.record(902, "fff");
    cout << hist << endl;

    cout << "Test della forget:" << endl;
    hist.forget("aaa");
    hist.forget("ccc");
    cout << hist << endl;

    cout << "Test del distruttore:" << endl;
    {
        History hist2;
        hist2.record(500, "aaa");
        hist2.record(400, "bbb");
        hist2.record(600, "ccc");
    }
    cout << "(oggetto distrutto)" << endl;

    // SECONDA PARTE
    cout << endl << "--- SECONDA PARTE ---" << endl;
    cout << "Test longest_period:" << endl;
    cout << hist.longest_period() << endl;

    cout << "Test forget overloaded:" << endl;
    hist.forget(500, 750);
    cout << hist << endl;

    cout << "Test create_alternative:" << endl;
    History hist3;
    hist3.record(-75, "ggg");
    hist3.record(507, "hhh");
    hist3.record(753, "iii");
    hist3.record(821, "jjj");
    History *p_hist4 = create_alternative(hist, 450, hist3);
    cout << *p_hist4 << endl;
    delete p_hist4;

    // TERZA PARTE
    cout << endl << "--- TERZA PARTE ---" << endl;
    cout << "Test aggiuntivi della record:" << endl;
    History hist5;
    hist5.record(599, ""); // descrizione vuota (deve lasciare inalterato)
    hist5.record(200, "Descrizione decisamente troppo lunga per essere registrata correttamente."); // descrizione troppo lunga (dee lasciare inalterato)
    hist5.record(0, "aaa"); // stampa corretta anno 1 AD
    hist5.record(300, "bbb");
    hist5.record(400, "ccc");
    hist5.record(300, "ddd"); // anno gia' presente
    hist5.record(0, "eee"); // anno gia' presente in testa
    cout << hist5 << endl;

    cout << "Test aggiuntivi della forget:" << endl;
    hist5.forget("evento inesistente"); // evento inesistente (deve lasciare inalterato)
    hist5.forget(""); // descrizione vuota (deve lasciare inalterato)
    hist5.record(600, "bbb");
    hist5.forget("bbb"); // due eventi con stessa descrizione (deve cancellare il primo)
    cout << hist5 << endl;

    // test distruttore su lista vuota
    cout << "Test aggiuntivi del distruttore:" << endl;
    {
        History hist4;
        cout << hist4 << endl;
    }
    cout << "(oggetto distrutto)" << endl;

    cout << "Test aggiuntivi della longest_period:" << endl;
    History hist6;
    cout << hist6.longest_period() << endl; // nessun evento (deve restituire -1)
    hist6.record(-50, "aaa");
    cout << hist6.longest_period() << endl; // un solo evento (deve restituire -1)
    hist6.record(100, "bbb");
    cout << hist6.longest_period() << endl; // due eventi (deve restituire 150)

    cout << "Test aggiuntivi della forget overloaded:" << endl;
    hist5.forget(100, 0); // input non validi (deve lasciare inalterato)
    cout << hist5 << endl;
    hist5.forget(0, 100); // cancella anche gli eventi di testa, il cui anno coincide con from_year
    cout << hist5 << endl;
    hist5.forget(500, 600); // cancella un evento il cui anno coincide con to_year
    cout << hist5 << endl;
    hist5.forget(-100, 1000); // cancella tutta la lista
    cout << hist5 << endl;

    cout << "Test aggiuntivi della create_alternative:" << endl;
    hist5.record(-25, "aaa");
    hist5.record(0, "bbb");
    hist5.record(100, "ccc");
    hist5.record(200, "ddd");
    hist5.record(300, "eee");
    hist5.record(400, "fff");
    //hist6.record(-50, "aaa"); // gia' aggiunto prima
    //hist6.record(100, "bbb"); // gia' aggiunto prima
    hist6.record(150, "ccc");
    hist6.record(300, "ddd"); // anno presente anche in hist5
    hist6.record(350, "eee");
    hist6.record(450, "fff");
    hist6.record(550, "ggg");
    p_hist4 = create_alternative(hist5, 600, hist6); // solo hist5
    cout << *p_hist4 << endl;
    delete p_hist4;
    p_hist4 = create_alternative(hist5, -60, hist6); // solo hist6
    cout << *p_hist4 << endl;
    delete p_hist4;
    p_hist4 = create_alternative(hist5, 300, hist6); // fork in una anno presente in entrambe le History (deve prendere quella di hist5)
    cout << *p_hist4 << endl;
    delete p_hist4;

    return 0;
}