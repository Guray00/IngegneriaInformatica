#include <iostream>
using namespace std;

const int RIG = 12;
const int COL = 20;

class LivelloPacman{
    int pacman_r;
    int pacman_c;
    int fantasma_r;
    int fantasma_c;
    char schema[RIG][COL];
    void scava(int, int);
    void muovi_fantasma();
public:
    // --- PRIMA PARTE ---
    LivelloPacman();
    friend ostream& operator<<(ostream&, const LivelloPacman&);
    LivelloPacman& corr(char, int, int, int);
    LivelloPacman& pacman(int, int);
    LivelloPacman& muovi(char, int);
    // --- SECONDA PARTE ---
    int spazio(char)const;
    LivelloPacman& fantasma(int, int);
    LivelloPacman& fermo();
};
