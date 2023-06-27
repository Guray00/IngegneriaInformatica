#include <iostream>
#include "compito.h"
using namespace std;

int main(){
	  
  cout<<"--- PRIMA PARTE ---" << endl;
  Battaglia b(4,5); // battaglia 4x4 con 5 giocatori
        
  b.aggiungi(1, 1, 2, 3, 2); // successo
  b.aggiungi(0, 0, 0, 1, 1); // successo
  b.aggiungi(2, 0, 3, 0, 1); // successo
  cout << b << endl;

  b.aggiungi(0, 3, 3, 3, 1); // fallimento
  b.aggiungi(3, 0, 3, 4, 2); // fallimento
  b.aggiungi(3, 2, 3, 3, 5); // successo
  cout << b << endl;
        
                
  if(b.fuoco(1,3))
    cout << "Nave colpita" << endl;
  else
    cout << "Colpo a vuoto" << endl;

  if (b.fuoco(0, 2))
	  cout << "Nave colpita" << endl;
  else
	  cout << "Colpo a vuoto" << endl;

  if (b.fuoco(3, 3))
	  cout << "Nave colpita" << endl;
  else
	  cout << "Colpo a vuoto" << endl;
          
  cout<< endl << b << endl;
  /*
  {
    cout<<"--- SECONDA PARTE ---" << endl;
    Battaglia b2(6,3);
    b2.aggiungi(0, 0, 0, 3, 1);
    cout << b2 << endl;    
                
    Battaglia b3(6,3);
    b3.aggiungi(4, 0, 4, 3, 2);
    b3.aggiungi(5, 0, 5, 3, 1);
    cout<<b3 << endl;

    if(!(b2+=b3))
      cout << "Conflitto rilevato" << endl;
    else 
      cout << "Unione avvenuta" << endl;
    cout<<b2 << endl;
                
    b2.fuoco(4,0);
    b2.fuoco(4,1);
    b2.fuoco(4,2);
    b2.fuoco(4,3);
       
    cout << b2 << endl;
    if(b2==1)
      cout << "Giocatore 1 ancora in gioco" << endl;               
	  else 
		  cout << "Giocatore 1 eliminato" << endl;
                
    if( b2==2 )
      cout << "Giocatore 2 ancora in gioco" << endl;                          
	  else
	    cout << "Giocatore 2 eliminato" << endl;
  }
  */
  return 0;
}
