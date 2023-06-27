#include <iostream>
#include <cstring>
using namespace std;

const int MAXLEN = 31;

struct elem{
    char parola[MAXLEN];
    int occ;
    elem *pun;

};

class Occorrenze {
    elem *p0;

    // FUNZIONI DI UTILITA'
    void inserisci(const char par[]); // funzione di utilità
    void dealloca(elem *);

public:
    // PRIMA PARTE
    Occorrenze(const char frase[]);
    friend ostream& operator<<(ostream&, const Occorrenze&);
    int operator%(int)const;

    // SECONDA PARTE
    Occorrenze& operator+=(const char[]);
    int operator[](const char par[])const;
    Occorrenze& operator-=(char);
    ~Occorrenze(){dealloca(p0);}
};

