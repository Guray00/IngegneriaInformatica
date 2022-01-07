#include <iostream>
using namespace std;

const int num_tipi = 5;

class Memory {

    int punteggio;
    int dimensione;
    char* caselle;


    // funzioni di utilitÃ 
    static const char* indice2char(int);
    static int char2indice(char);
    void ruota_90();

    //mascheramento costruttore operatore assegnamento
    Memory& operator=(const Memory&);
public:
    Memory(int);
    friend ostream& operator<<(ostream&, const Memory&);
    void inserisci(char, int, int, int, int);
    void riassumi() const;
    bool flip(int, int, int, int);
    Memory(const Memory&);
    Memory operator+(const Memory&) const;
    Memory& operator>>(int);
    ~Memory(){delete[] caselle;};
};