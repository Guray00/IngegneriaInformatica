#include <iostream>
#include "compito.h"

using namespace std;

int main() {

   cout << "--- PRIMA PARTE ---" << endl;

   cout << "Test dei costruttori ed operatore di uscita:" << endl;
   Razionale a; // zero
   Razionale b(1,2);
   Razionale c(6,12); // equivale a "b"
   Razionale d(5,8);

   cout << a << " " << b << " " << c << " " << d << endl;

   cout << "Test delle operazioni aritmetiche" << endl;
   cout << a+b << " " << b+a << " " << b+c << " " << c+d << endl;
   cout << a-b << " " << b-a << " " << b-c << " " << c-b << " " << d-b << endl;
   cout << -a << " " << -b << " " << endl;
   cout << a*b << " " << b*a << " " << b*c << " " << (c+d)*c << endl;
   cout << a/b << " " << c/b << " " << d/b+c << endl;

   cout << "Test con razionali negativi" << endl;
   Razionale e(-2, 13);
   Razionale f(4, -12);
   Razionale g(-30, 30); // meno uno
   cout << e << " " << f << " " << g << endl;
   cout << -b*e << " " << e-d << " " << (b+e-f)*g << endl;

   cout << "Test con operatore <" << endl;
   cout << (a < b) << (b < c) << (c < b) << (c < d) << (f < e) << (g < a) << endl;

   cout << endl << "--- SECONDA PARTE ---" << endl;

   {
      Razionale tmp(13, 7);
      cout << "Test dell'(eventuale) distruttore" << endl;
   }
   cout << "(distruttore invocato)" << endl;

   cout << "Test con max_occhio" << endl;
   Razionale* v = new Razionale[10] {
      Razionale(3,4),
      Razionale(-5,2),
      Razionale(2,2),
      Razionale(21,7),
      Razionale(-7,-8),
      Razionale(-5,2),
      Razionale(12,5),
      Razionale(0,2),
      Razionale(21,8),
      Razionale(10,23)
   };
   cout << max_occhio(v, 10) << endl;

   cout << "Test di div_int" << endl;
   Razionale q, r;
   div_int(c, b, q, r);
   cout << q << " " << r << endl;
   div_int(d, -e, q, r);
   cout << q << " " << r << endl;
   div_int(d, e, q, r);
   cout << q << " " << r << endl;
   div_int(-c, e, q, r);
   cout << q << " " << r << endl;
   div_int(-d, -f, q, r);
   cout << q << " " << r << endl;

   cout << "Test di ordina" << endl;
   ordina(v, 10);
   for (int i = 0; i < 10; i++)
      cout << v[i] << " ";
   cout << endl;
   delete[] v;

   cout << endl << "--- TERZA PARTE ---" << endl;
   cout << "Test intensivo di max_occhio" << endl;
   Razionale* v2 = new Razionale[4]{
      Razionale(1, 7),
      Razionale(5, 8),
      Razionale(-6, 7),
      Razionale(2, 7)
   };
   cout << max_occhio(v2, 4) << endl;

   cout << "Test intensivo di ordina" << endl;
   ordina(v2, 0);
   ordina(v2, -10);
   delete[] v2;

   return 0;
}
