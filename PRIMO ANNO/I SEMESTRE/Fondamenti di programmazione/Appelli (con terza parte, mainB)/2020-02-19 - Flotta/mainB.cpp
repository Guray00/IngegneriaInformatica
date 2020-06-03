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
   cout << "--- SECONDA PARTE ---" << endl;
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
   cout << f << endl;

   // TERZA PARTE:
   cout << "--- TERZA PARTE ---" << endl;
   cout << "Test operatore int con nessuna fila formata" << endl;
   Flotta f3(3);
   cout << "Larghezza: " << int(f3) << endl;

   cout << "Test funzione forma_fila con input non validi" << endl;
   f3.forma_fila(0, 2);
   f3.forma_fila(-2, 5); // indice non valido
   f3.forma_fila(3, 4);  // indice non valido
   f3.forma_fila(2, -4); // numero aerei non valido
   f3.forma_fila(0, 6);  // fila gia' formata
   cout << f3 << endl;

   cout << "Test operatore -= con flotte di numero di file diverso o con file non formate" << endl;
   f3.forma_fila(1, 3);
   f3.forma_fila(2, 4);
   f -= f3; // numero di file diverso
   cout << f << endl;
   Flotta f4(3);
   f4.forma_fila(0, 1);
   f4.forma_fila(1, 5);
   f3 -= f4; // flotta attaccante non completamente formata
   cout << f3 << endl;
   f4 -= f3; // flotta difenditrice non completamente formata
   cout << f4 << endl;

   cout << "test operatore += con input non validi o con file non formate" << endl;
   const int v2[] = {1, 2, -1}; // input non valido
   f3 += v2;
   cout << f3 << endl;
   f4 += v; // file non formate
   cout << f4 << endl;

   return 0;
}
