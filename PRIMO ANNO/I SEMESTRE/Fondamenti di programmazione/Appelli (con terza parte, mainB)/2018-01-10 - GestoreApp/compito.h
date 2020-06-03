#include <iostream>

using namespace std;

struct elem{
   char nome[21];
   elem* pun;
};

class GestoreApp{
   elem* testa;
public:
   GestoreApp();
   GestoreApp& operator+=(const char*);
   friend ostream& operator<<(ostream&, const GestoreApp&);
   
   // --- SECONDA PARTE ---
   bool foreground(const char*); 
   GestoreApp& operator-=(const char*);
   void chiudi_tutte();
   ~GestoreApp();
};
