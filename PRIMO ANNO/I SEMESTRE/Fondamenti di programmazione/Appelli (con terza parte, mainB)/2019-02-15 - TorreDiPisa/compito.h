#include <iostream>
using namespace std;

class TorreDiPisa {
    
    int max_loggiati;   // numero massimo di loggiati
    int loggiati;       // numero di loggiati presenti
    int* pendenze;      // rappresenta la pendenza di ogni loggiato
    
    // costruttore di copia (utile per operator++)
    TorreDiPisa(const TorreDiPisa&);
    
public:
    TorreDiPisa(int);
    TorreDiPisa& operator+=(int);
    friend ostream& operator<<(ostream&, const TorreDiPisa&);
    TorreDiPisa operator++(int);
    operator int()const;
    void stabilizza();
    ~TorreDiPisa();
};
