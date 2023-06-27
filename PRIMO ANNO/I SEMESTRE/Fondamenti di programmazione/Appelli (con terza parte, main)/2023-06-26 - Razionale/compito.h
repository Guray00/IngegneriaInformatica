#include <iostream>
using namespace std;

class Razionale {
private:
   void sempl();
   int num;
   int den;

public:

   // PRIMA PARTE
   Razionale();
   Razionale(int, int);
   friend ostream& operator<<(ostream&, const Razionale&);
   Razionale operator+(const Razionale&) const;
   Razionale operator-(const Razionale&) const;
   Razionale operator-() const;
   Razionale operator*(const Razionale&) const;
   Razionale operator/(const Razionale&) const;
   bool operator<(const Razionale&) const;

   // SECONDA PARTE
   friend void ordina(Razionale*, int);
   friend void div_int(const Razionale&, const Razionale&, Razionale&, Razionale&);
   friend Razionale max_occhio(const Razionale* v, int n);
};