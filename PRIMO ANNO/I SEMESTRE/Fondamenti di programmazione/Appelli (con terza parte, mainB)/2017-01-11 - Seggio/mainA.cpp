#include <iostream>
using namespace std;
#include "compito.h"

int main(){
    
   cout<<"--- PRIMA PARTE ---" << endl;
   cout << "Test del costruttore e dell'operatore di uscita (caso coda seggio vuota)" << endl;
   Seggio s;
   cout << s << endl;

   cout << "Test della nuovoElettore: arrivo di tre elettori" << endl;
   s.nuovoElettore(34);
   s.nuovoElettore(63);
   s.nuovoElettore(29);
   cout << s << endl;
 
   /*
   
   cout << "--- SECONDA PARTE ---" << endl;

   cout << "Test della nuovoVoto: primo elettore" << endl;
   s.nuovoVoto(contrario);
   cout << s << endl;

   cout <<"Test dello spoglioDeiVoti"<<endl;
   s.spoglioDeiVoti();
   
   cout << "\nTest della nuovoVoto: altri due elettori" << endl;
   s.nuovoVoto(favorevole);
   s.nuovoVoto(contrario);
   cout << s << endl;
    
   cout <<"Test dello spoglioDeiVoti"<<endl;
   s.spoglioDeiVoti();
   
	
   cout << "\nTest del distruttore (s e' stato appena distrutto)\n" << endl;
 
   */
   return 0;
}
