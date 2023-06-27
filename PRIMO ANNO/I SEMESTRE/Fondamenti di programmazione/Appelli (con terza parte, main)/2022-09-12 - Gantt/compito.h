#include <iostream>
#include <cstring>
using namespace std;

const int MAXCHAR = 20;
const int MAXMESI = 49;
const int MAXATT  = 9;

struct attivita{
    char descr[MAXCHAR+1];
    int inizio;
    int durata;
};

struct elem{
    int vincolata;  // attivita' corrente
    int vincolante;  // attivita' vincolante (finche' non termina vinc, corr non puo' iniziare)
    elem* pun;
};

class Gantt{
    attivita vettAtt[MAXATT];
    int quanteAtt;
    int quanteDip;
    elem* p0;
    
    // funzioni di utilita'
    void insFondo(int, int);
    void rimuoviVincolata(int);
    void rimuoviVincolante(int);

    // mascheramenti
    Gantt(const Gantt&);
    Gantt& operator=(const Gantt&);

public:
    Gantt(){quanteAtt = 0; quanteDip = 0; p0 = nullptr;};
    friend ostream& operator<<(ostream &os, const Gantt&);
    Gantt& aggiungiAtt(const char [], int, int);
    Gantt& aggiungiDip(int, int);
    
    Gantt& rimuoviAtt(int);
    Gantt& anticipaAtt(int,int);
    ~Gantt();
};
