#include <iostream>
#include "compito.h"
using namespace std;

int main(){
  cout<<"---PRIMA PARTE---"<<endl;
  
  cout << "Test del costruttore e dell'operatore di uscita" << endl;
  Libretto l(4);
  cout << l << endl;
  
  cout << "Test della aggiungi" << endl;
  l.aggiungi("I0051",25,9);
  cout << l << endl;
  l.aggiungi("I0054",21,6);
  cout << l << endl;
  
  cout << "Test della media aritmetica:" << endl;
  double media = l.media();
  cout << media << endl<<endl;
  
  /*
  cout<<"---SECONDA PARTE---"<<endl;
  
  {
    cout << "Test dell'operatore di assegnamento" << endl;
    Libretto l2(3);
	l2.aggiungi("I0058",30,12);
	l2 = l;
    cout << l2 << endl;
  }
  
  cout<<"Test del distruttore (l2 e' stato appena distrutto)\n"<<endl;
  
  cout << "Ulteriori test della aggiungi" << endl;
  l.aggiungi("I0062",28,9);
  l.aggiungi("I0051",24,12);
  l.aggiungi("I0067",24,12);
  cout << l << endl;
  
  cout<<"Test calcolo voto di partenza di laurea"<<endl<<"Il voto di partenza e': ";
  double laurea = l.laurea();
  cout<<laurea<<endl<<endl;
  
  */
 
  return 0;
  
}
