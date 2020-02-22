#include <iostream>
using namespace std;
#include "compito.h"

int main(){
  // --- PRIMA PARTE ---
  cout << "Test del costruttore e dell'operatore di uscita" << endl;
  Aula a(4);
  cout << a << endl;
  
  cout << "Test della aggiungi" << endl;
  a.aggiungi("Utente1");
  cout << a << endl;
  a.aggiungi("Utente2"); 
  a.aggiungi("Utente3");
  
  cout << a << endl;
  
  cout << "Test della elimina (viene liberata la seconda postazione)" << endl;
  a.elimina(2);
  cout << a << endl;
  
  // --- SECONDA PARTE ---
  {
    cout << "Test del costruttore di copia" << endl;
    Aula a2(a);
    cout << a2 << endl;
  }
  cout<<"Test del distruttore (a2 e' stata appena distrutta)\n"<<endl;
  
  cout<<"Test dell'operatore di negazione logica"<<endl;
  a.aggiungi("Zenone");
  a.aggiungi("Achille");
  cout<<"(prima dell'ordinamento)"<< endl <<a;
  cout<<"(dopo l'ordinamento)"<< endl <<!a;
  
  cout<<"\n --- TERZA PARTE --- ( TEST AGGIUNTIVI )\n" << endl;
  {
    Aula a3(-2);
    a3.aggiungi("Tartaruga");
  }
  Aula a4(6);
  a4.aggiungi("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  a4.aggiungi("cccccccccccccccccccccccccccccccccccccccccccccccccccc");
  a4.aggiungi("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
  cout << !a4 << endl;
  a4.aggiungi("ddd");
  a4.aggiungi("fff");
  a4.aggiungi("eee");
  cout<< a4 << endl;  
  cout<< !a4 << endl;
  a4.elimina(0);
  a4.elimina(3);
  a4.elimina(7);
  cout<< a4 << endl;
  Aula a5(a4);
  cout<< a5 << endl;
  a5.elimina(2);
  a5.aggiungi("ddd");
  a5.aggiungi("ciao");
  a5.aggiungi("ciao");
  cout<< a5 << endl;
  
  return 0;
  
}


