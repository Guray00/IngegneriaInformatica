#include <iostream>
using namespace std;

class Mensa{
private:
    char** v;
    int nSedie;
    friend ostream& operator<<(ostream&, const Mensa&);

    // mascheramento operatore di assegnamento
    Mensa& operator=(const Mensa&);

public:
    Mensa(int);
    bool occupa(const char[]);
    void libera(int);
    // --- SECONDA PARTE ---
    Mensa(const Mensa&);
    bool occupaGruppo(const char[], int);
    void ordina();
    ~Mensa();
};