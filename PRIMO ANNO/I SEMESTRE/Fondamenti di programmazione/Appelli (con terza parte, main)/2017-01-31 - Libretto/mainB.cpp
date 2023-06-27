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
  
  cout<<"---TERZA PARTE---"<<endl;
  
  Libretto l3(5);
  l3.aggiungi("I0070",28,9);
  l3.aggiungi("I0071",29,12);
  l3.aggiungi("I0072",27,9);
  cout<<l3<<endl;
  
  cout<<"media"<<endl;
  cout << l3.media() << endl<<endl;
  
  cout<<"Ulteriore test operatore di assegnamento"<<endl;
  Libretto l4(7);
  l4 = l3;  
  cout<<l4<<endl;
  
  cout<<"Ulteriori test della aggiungi su l4"<<endl;
  l4.aggiungi("I0073",25,9);
  l4.aggiungi("I0074",24,5); // deve fallire causa numero crediti errato
  l4.aggiungi("I0075",24,12); // deve avere successo
  l4.aggiungi("I0076",23,9); // deve fallire causa libretto pieno
  
  cout << l4 << endl;
  
  cout<<"Test calcolo voto di partenza di laurea"<<endl<<"Il voto di partenza e': ";  
  cout<<l4.laurea()<<endl<<endl;
    
  
  return 0;
  
}
