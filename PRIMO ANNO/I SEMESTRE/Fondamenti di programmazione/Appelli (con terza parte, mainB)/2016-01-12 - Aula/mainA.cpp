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
  
  /*
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
  */
    
  return 0;
}
