#include <iostream>

using namespace std;

class SpaceAsteroids{

    const static unsigned max_altezza = 7;
    const static unsigned max_larghezza = 9;
    const static unsigned min_altezza = 3;
    const static unsigned min_larghezza = 3;
    const static unsigned energia_default = 5;

    static unsigned record;
    unsigned punteggio;

    const unsigned altezza;
    const unsigned larghezza;
    const unsigned energia_massima;

    unsigned posizione_astronave;

    int schermo[max_altezza + 1][max_larghezza];

    unsigned energia_rimanente;

    bool spostamento_permesso;
    bool laser_permesso;


    void carica_nuova_partita();
    void avanzamento_asteroidi();

public:

    SpaceAsteroids(int altezza, int larghezza, int energia);
    bool colloca_asteroide(int col);
    void avanza();
    friend ostream& operator<<(ostream& os, const SpaceAsteroids& a);
    void operator<<=(int n);
    void operator>>=(int n);
    SpaceAsteroids& operator|=(int n);
};
