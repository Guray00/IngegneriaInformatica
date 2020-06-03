#include <iostream>
#include <cstring>
using namespace std;

struct elem {
    int id;
    int articoli;
    elem* pun;
};

enum stato {
    APERTA, CHIUSA
};

class Smistacasse { 
    int _N;
    elem** _casse;
    stato* _stato;
    
    friend ostream& operator<<(ostream&, const Smistacasse&);
    
  public:	  
    Smistacasse(int);
    int trovaCassa();
    void aggiungi(int, int);
    void servi(int);
    
    // --- SECONDA PARTE ---
    Smistacasse& operator-=(int);
    ~Smistacasse();
};

