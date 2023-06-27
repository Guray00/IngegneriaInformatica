#include <iostream>
#include <iomanip>
using namespace std;

class Tartaglia{
    unsigned int **T;
    int ord;

    // funzione di utilita'
    void dealloca();
public:
    // PRIMA PARTE
    Tartaglia(int);
    friend ostream& operator<<(ostream&, const Tartaglia&);
    int fibonacci(int)const;

    // SECONDA PARTE
    void espandi(int)const;
    Tartaglia& operator=(const Tartaglia&);
    ~Tartaglia(){dealloca();};
};