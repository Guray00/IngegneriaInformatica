#include "compito.h"
#include <iostream>
using namespace std;

int main(){
   // PRIMA PARTE:
   cout << "--- PRIMA PARTE ---" << endl;
   cout << "Test costruttore" << endl;
   Flotta f(4);
   cout << f << endl;

   cout << "Test funzione forma_fila" << endl;
   f.forma_fila(0, 3);
   f.forma_fila(1, 6);
   f.forma_fila(2, 4);
   cout << f << endl;

   cout << "Test operatore int" << endl;
   cout << "Larghezza: " << int(f) << endl;

   cout << "Test distruttore" << endl;
   {
      Flotta f2(3);
      f2.forma_fila(0, 2);
      f2.forma_fila(1, 3);
      f2.forma_fila(2, 4);
   }
   cout << "Distruttore chiamato" << endl;
   
   // SECONDA PARTE:
   /*cout << "--- SECONDA PARTE ---" << endl;
   cout << "Test costruttore di copia" << endl;
   Flotta f2 = f;
   f.forma_fila(3, 8);
   cout << f2 << f << endl;
   
   cout << "Test operatore +" << endl;
   cout << f+f2 << endl;
   
   cout << "Test operatore -=" << endl;
   f2.forma_fila(3, 5);
   f -= f2;
   cout << f << endl;

   cout << "test operatore +=" << endl;
   const int v[] = {2, 4, 0, 1};
   f += v;
   cout << f << endl;*/

   return 0;
}
