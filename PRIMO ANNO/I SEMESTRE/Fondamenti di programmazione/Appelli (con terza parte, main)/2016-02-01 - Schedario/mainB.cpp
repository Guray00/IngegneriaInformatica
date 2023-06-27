#include <iostream>
using namespace std;
#include "compito.h"

int main(){
  {
    cout<<"--- PRIMA PARTE ---" << endl;
    cout << "\nTest del costruttore e dell'operatore di uscita" << endl;
    Schedario s;
    cout << s << endl;
    
    cout << "\nTest della aggiungi" << endl;
    s.aggiungi(3, 12);
    s.aggiungi(3, 10);
    s.aggiungi(2, 21);
    s.aggiungi(2, 48);
    s.aggiungi(2, 35);    
    s.aggiungi(1, 6);  
    cout << s << endl;

    cout << "\nTest dell'operatore -=" << endl;
    s-=2;
    cout << s << endl;
  
    cout << "\n--- SECONDA PARTE ---" << endl;
          
    s.aggiungi(2, 5);
    s.aggiungi(2, 3);    
    s.aggiungi(2, 5);
    s.aggiungi(2, 5);       
    s.aggiungi(2, 8);
    s.aggiungi(2, 5);
    
    cout <<"\nTest della promuovi"<<endl;
    cout << "  [s prima della promuovi]" << endl;
    cout << s << endl;
    s.promuovi(2,5);    
    cout << "  [s dopo la promuovi]" << endl;
    cout << s << endl;
    
    cout<<"\n---TERZA PARTE---"<< endl;
    s.aggiungi(1, 6);
    s.aggiungi(1, 3);
    s.aggiungi(1, 6);
    cout << s << endl;
    cout << "  [s dopo la promuovi(1,6)]" << endl; 
    s.promuovi(1,6);
    cout << s << endl;
    s.promuovi(3,5);
    s.promuovi(2,6);
    s.promuovi(2,3);
    cout << "  [s dopo varie altre promuovi]" << endl; 
    cout << s << endl;
  }
  cout << "\nTest del distruttore (s e' stato appena distrutto)\n" << endl;  
  return 0;
}
