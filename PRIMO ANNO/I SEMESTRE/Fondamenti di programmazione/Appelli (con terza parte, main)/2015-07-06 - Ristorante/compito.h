#include <cstring>
#include <iostream>
using namespace std;

const int DIM = 31;

class Ristorante
{
  struct gruppo{
    char cognome[DIM];
    int num;
    gruppo* succ;
  };

  int liberi;
  gruppo* testa;
  gruppo* coda;
  friend ostream& operator<< (ostream&, const Ristorante&);
  
  // funzione di utilità
  void estraiDallaTesta();

  // mascheramento operatore di assegnamento
  Ristorante& operator =(const Ristorante&);

public:
  // --- PRIMA PARTE ---
  Ristorante(int);
  void aggiungi(const char[], int);
  Ristorante& operator-=(int);

  // --- SECONDA PARTE ---  
  bool rinuncia(const char[]);
  Ristorante(const Ristorante&);
  ~Ristorante();
};
