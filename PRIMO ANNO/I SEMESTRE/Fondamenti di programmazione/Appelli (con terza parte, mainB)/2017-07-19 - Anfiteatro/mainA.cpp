#include "compito.h"
#include <iostream>
using namespace std;

int main()
{       
   cout << endl << "--- PRIMA PARTE ---" << endl;

   cout<<"\nChiamata al costruttore"<<endl;
   Anfiteatro a(4);
   cout<<a<<endl;

   cout << "Chiamata alla funzione aggiungiMattonelle()" << endl;
   a.aggiungiMattonelle(7);
   cout << a << endl;

   cout << "Altra chiamata alla funzione aggiungiMattonelle()" << endl;
   a.aggiungiMattonelle(12);
   cout << a << endl;
   
   cout << "\nChiamata alla funzione aggiungiColonna()" << endl;
   a.aggiungiColonna(8);
   cout << a << endl;   

   /*
   cout << endl << "--- SECONDA PARTE ---" << endl;

   cout << endl << "Chiamata alla funzione togliColonna()" << endl;
   a.togliColonna(1);
   cout << a << endl;

   {
       cout << endl << "Test dell'operatore assegnamento " << endl;
	   Anfiteatro a1(2);
	   cout << "a1 ( *prima* dell'assegnamento ) " << a1 << endl;		
	   a1 = a;
	   cout << "a1 ( *dopo* l'assegnamento ) " << a1 << endl;		
	   cout << endl;
	   cout << "Test del distruttore (a1 sta per essere distrutto)" << endl;		
   }
   */

   return 0;
}

