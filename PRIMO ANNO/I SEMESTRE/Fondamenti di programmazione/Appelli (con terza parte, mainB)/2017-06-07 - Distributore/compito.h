#include <iostream>

using namespace std;

const int MAX_SLOT = 5;
const int MAX_PEZZI = 5;

class Distributore {
    int numRipiani;
    int* mat;
    
public:
    
    // --- PRIMA PARTE --- //
    Distributore(int);
    bool acquista(int);
    void aggiungi(int, int);
    friend ostream& operator<<(ostream&, const Distributore&);
    
    // --- SECONDA PARTE --- //
    Distributore operator+(int);
    Distributore(const Distributore&);
    ~Distributore();
};
