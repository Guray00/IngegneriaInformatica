#include <iostream>
using namespace std;

enum Colore {ROSSO, VERDE, GIALLO};

struct elem{
    Colore col;
	double x;
	double y;
    elem* pun;
};

class Mappa{	
    elem* testa;

public:
    // --- PRIMA PARTE ---      [20pt]
    Mappa() {testa = NULL;}
	void aggiungi(Colore c, double x, double y);
    void elimina(double x, double y);
	friend ostream& operator<<(ostream& os, const Mappa& m);
	
	// --- SECONDA PARTE ---    [10pt]
	void riduci(int k);      // [4pt]
    Mappa(const Mappa& m);   // [4pt]
    ~Mappa();                // [2pt]
};

