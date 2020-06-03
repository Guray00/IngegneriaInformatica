#include <iostream>

using namespace std;

const int MAX_CHAR = 6;
const int MAX_CASELLI = 5;

struct Veicolo {
    char targa[MAX_CHAR+1];
    Veicolo* pun;
};

class Barriera {
    Veicolo* coda[MAX_CASELLI];
    int lun[MAX_CASELLI];
    
    // funzioni di utilità 
    double calcolaMedia();
    
public:
    
    // --- PRIMA PARTE --- //
    Barriera();
    void nuovoVeicolo(const char*);
    bool serviVeicolo(int);
    friend ostream& operator<<(ostream&, const Barriera&);
    
    // --- SECONDA PARTE --- //
    int apriOppureChiudi(double);
    operator int() const;
    ~Barriera();
};
