#include <iostream>
using namespace std;

class Insieme;

// PRIMA PARTE
class Coppia{
  unsigned long int _p; 
 // si sceglie di memorizzare la parte positiva come
 // unsigned long int per avere un 
 // range di rappresentabilita' piu' ampio

  unsigned long int _q; 
// si sceglie di memorizzare il valore 
// assoluto della parte negativa, al posto della 
// parte negativa vera e propria,
// per lo stesso motivo di cui sopra

// funzione di utilita'
  inline void operator-();
  friend class Insieme; 
// va dichiarata friend per permetterle di chiamare 
// la funzione precedente
public:
  Coppia (unsigned long int p = 5, 
    unsigned long int q = 9){ _p = p; _q = q; };
  friend ostream& operator <<(ostream &os,
    const Coppia&);  
};

class Insieme{
  Coppia *_vett;
  int _d;

  // mascheramento costruttore di copia
  Insieme(const Insieme&);

public:
  Insieme(int);
  friend ostream& operator <<(ostream&, 
    const Insieme&);

  // SECONDA PARTE
  Insieme& operator=(const Insieme&);  
  Insieme& operator-();
  ~Insieme(){delete[] _vett;}
};
