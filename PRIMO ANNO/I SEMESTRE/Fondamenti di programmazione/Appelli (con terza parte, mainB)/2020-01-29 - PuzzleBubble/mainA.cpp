#include "compito.h"
#include <iostream>
using namespace std;

int main(){
   // PRIMA PARTE:
   cout << "--- PRIMA PARTE ---" << endl;
   cout << "Test costruttore" << endl;
   PuzzleBobble pb;
   cout << pb;
   
   cout << "Test funzione fire" << endl;
   pb.fire(0,'R').fire(1,'R').fire(0,'B').fire(2,'Y');
   pb.fire(3,'Y').fire(3,'Y').fire(0,'B').fire(3,'G');
   cout << pb;
   
   cout << "Test operatore int" << endl;
   cout << "Altezza: " << int(pb) << endl;

   // SECONDA PARTE:
/*   cout << "--- SECONDA PARTE ---" << endl;
   cout << "Test funzionalita' scoppio bolle" << endl;
   pb.fire(0,'B'); // scoppio verticale di 3 bolle
   pb.fire(0,'R'); // no scoppio
   pb.fire(5,'Y').fire(4,'Y'); // scoppio orizzontale di 4 bolle
   pb.fire(3,'G'); // no scoppio
   cout << pb;
   
   cout << "Test funzione scroll" << endl;
   pb.scroll().scroll();
   cout << pb;

   cout << "Test funzione compact" << endl;
   pb.compact();
   cout << pb;*/

   return 0;
}