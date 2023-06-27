#include <iostream>
#include <cstring>
using namespace std;

const int DIM = 3;
struct elem{
  int info;
  elem* pun;
};

class Schedario{
  
  elem* p0[DIM];
  
  // funzioni di utilita'
  void svuota(elem*&);
 
  // mascheramento costruttore di copia e op. di assegnamento
  Schedario(const Schedario&);  
  Schedario& operator=(const Schedario&);

public:
  // --- PRIMA PARTE ---   // 20 pt
  Schedario();    
  void aggiungi(int, int);
  Schedario& operator-=(int);
  friend ostream& operator<<(ostream&, const Schedario&);
  
  // --- SECONDA PARTE --- // 10 pt
  void promuovi(int,int);  //  7pt
  ~Schedario();            //  3pt
};


