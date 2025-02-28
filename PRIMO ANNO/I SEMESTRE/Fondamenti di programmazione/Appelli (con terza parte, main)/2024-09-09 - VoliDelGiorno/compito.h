#include <iostream>
#include <cstring>
using namespace std;

const int DIM_ORARIO = 5;
const int MAX_NOME = 20;

struct elem{
    char orario[DIM_ORARIO + 1];
    char destinazione[MAX_NOME + 1];
    bool annullato;
    elem* pun;
};

class VoliDelGiorno{
    elem* testa;
    VoliDelGiorno& operator=(const VoliDelGiorno&); //mascheramento operatore di assegnamento
  public:
    // --- PRIMA PARTE ---
    VoliDelGiorno();
    friend ostream& operator<<(ostream&, const VoliDelGiorno&);
    bool aggiungi(const char*, const char*);
    bool annulla(const char*);
    VoliDelGiorno(const VoliDelGiorno&);
    // --- SECONDA PARTE ---
    ~VoliDelGiorno();
    VoliDelGiorno nonAnnullati() const;
    VoliDelGiorno& operator~();
    VoliDelGiorno operator+(const VoliDelGiorno&) const;
};
