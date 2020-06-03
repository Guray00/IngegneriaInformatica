#include <iostream>
using namespace std;

class VettoreCrescente{

  int *vett;
  long dim;
  // mascheramento costruttore di copia
  VettoreCrescente(const VettoreCrescente &);

public:
  // --- PRIMA PARTE ---
  VettoreCrescente(int);
  void set(int, int);
  friend ostream & operator <<(ostream &, const VettoreCrescente &);

  // --- SECONDA PARTE ---    
  VettoreCrescente& operator=(const VettoreCrescente&); // 4pt
  operator int()const; // 3pt
  void azzera();       // 4pt
  ~VettoreCrescente(){ delete[]vett; }; // 1pt
};
