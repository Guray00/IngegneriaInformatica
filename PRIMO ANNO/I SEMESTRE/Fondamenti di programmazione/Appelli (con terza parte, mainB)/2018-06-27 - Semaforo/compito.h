// compito.h
#include <iostream>
using namespace std;

const int NUM_STATI = 3;
const int MAX_CHAR = 7;

// semaforo puo' essere in tre stati:
// - R = Rosso
// - VD = Verde per svolta a destra
// - VS = Verde per svolta a sinistra
enum stato {R=0, VD, VS};

struct elem
{
    char targa[MAX_CHAR+1];
    elem* pun;
};

class Semaforo
{
    // stato corrente del semaforo
    stato st;
    
    // una coda per ciascuna corsia
    elem* codaDx;
    elem* codaSx;
    
    // lunghezza corrente delle code
    unsigned int lenDx;
    unsigned int lenSx;
    
    // funzioni di utilita'
    void inserisciInCoda(elem*& l, const char* t);
    void eliminaCoda(elem*& l);
    bool controllaSePresente(elem* l, const char* t);
    
    // mascheramento costruttore di copia e op. di assegnamento
    Semaforo(const Semaforo& s);
    Semaforo& operator=(const Semaforo& s);
    
public:

    Semaforo();
    void arrivo(const char* t, char dir);
    void cambiaStato();
    friend ostream& operator<<(ostream& os, const Semaforo& s);
    bool cambiaCorsia(char dir);
    operator int() const;
    ~Semaforo();
};

