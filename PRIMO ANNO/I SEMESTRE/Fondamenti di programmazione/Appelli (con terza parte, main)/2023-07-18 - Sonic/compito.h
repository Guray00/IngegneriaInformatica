#include <iostream>
using namespace std;

class SonicLevel{

    static const int maxrighe = 8;
    static const int maxcolo = 32;
    char schema[maxrighe][maxcolo];
    int i_sonic;
    int j_sonic;
    int anelli_racc;
    bool gioco_fermo;

public:
    // --- PRIMA PARTE ---
    SonicLevel();
    friend ostream& operator<<(ostream&, const SonicLevel&);
    SonicLevel& blocchi(int, int, int, int);
    SonicLevel& anello(int, int);
    void avvia(int, int);
    SonicLevel& operator+=(int);

    // --- SECONDA PARTE ---
    SonicLevel& spuntone(int, int);
    SonicLevel& operator*=(int);
};
