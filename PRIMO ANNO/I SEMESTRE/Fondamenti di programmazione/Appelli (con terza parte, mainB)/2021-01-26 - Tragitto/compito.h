#include <iostream>
#include <cstring>
using namespace std;

class Tragitto{    
    struct elem{  
        char nome[20]; // "" indica postazione libera
        elem* pun;
    };
    elem* testa;
    Tragitto& operator=(const Tragitto&); // mascheramento operatore assegnamento
public:
    // --- PRIMA PARTE ---
    Tragitto();
    friend ostream& operator<<(ostream& os, const Tragitto&);
    bool inserisci(const char* n);
    bool avanza(int j);

    // --- SECONDA PARTE ---	
    Tragitto& operator+=(int k); // 5pt
    Tragitto(const Tragitto&);   // 4pt
    ~Tragitto();                 // 2pt
};

