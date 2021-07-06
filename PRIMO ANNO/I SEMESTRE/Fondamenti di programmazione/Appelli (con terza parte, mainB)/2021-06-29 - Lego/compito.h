#include <iostream>
using namespace std;

const int MAXDESCR = 30;
const int MAXMATTCOMUNI = 100;

class LegoSet{
    struct elem{
        char descr[MAXDESCR+1];
        char colore;
        elem* pun;
    };
    elem* testa;
    struct mattoncinoComune{
        bool creato = false;
        char descr[MAXDESCR+1];
        char colore;
    };
    static mattoncinoComune mattonciniComuni[MAXMATTCOMUNI];

    LegoSet(const LegoSet&); // mascheramento costruttore di copia
    LegoSet& operator=(const LegoSet&); // mascheramento operatore di assegnamento
public:
    // --- PRIMA PARTE ---
    LegoSet();
    friend ostream& operator<<(ostream& os, const LegoSet& set);
    void aggiungiMattoncino(const char* descr, char colore);
    void eliminaMattoncino(const char* descr);
    friend int operator%(const LegoSet& set, char colore);
    // --- SECONDA PARTE ---
    void eliminaMattoncino(char colore);
    void aggiungiMattoncinoComune(int codice, const char* descr, char colore);
    void aggiungiMattoncinoComune(int codice);
    ~LegoSet();
};