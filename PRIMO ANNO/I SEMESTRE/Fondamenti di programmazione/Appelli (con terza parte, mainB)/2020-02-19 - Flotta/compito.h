#include <iostream>
using namespace std;

class Flotta{
   int n_file;
   int* lun_fila;

public:
   // PRIMA PARTE
   Flotta(int);
   void forma_fila(int, int);
   operator int()const;
   friend ostream& operator<<(ostream&, const Flotta&);
   ~Flotta();

   // SECONDA PARTE
   Flotta(const Flotta&);
   friend Flotta operator+(const Flotta&, const Flotta&);
   Flotta& operator-=(const Flotta&);
   Flotta& operator+=(const int[]);
};
