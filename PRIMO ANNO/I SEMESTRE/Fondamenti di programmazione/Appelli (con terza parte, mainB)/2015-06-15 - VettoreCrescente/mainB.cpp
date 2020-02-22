#include <iostream>
using namespace std;
#include "compito.h"

int main(){

  // --- PRIMA PARTE ---
  cout << "\nTest del costruttore. Deve stampare: < 0 0 0 0 >" << endl;
  VettoreCrescente v(4); // crea un VettoreCrescente di 4 elementi inizializzati a zero
  cout << v << endl;     // stampa a video il vettore crescente

  cout << "\nTest della set. Deve stampare: < 0 7 -3 6 >" << endl;
  v.set(1, 7);     // imposta a 7 il secondo elemento
  v.set(2, -3);    // imposta a -3 il terzo elemento
  v.set(3, 6);     // imposta a 6 il quarto elemento
  cout << v << endl;

  cout << "\nTest della set oltre l'attuale dimensione. Deve stampare: < 0 7 -3 6 0 7 >" << endl;
  v.set(5, 7);
  cout << v << endl;

  // --- SECONDA PARTE ---
  cout << "Conto il numero di minimi relativi. Deve stampare: 2\n";
  cout << int(v) << endl << endl;

  cout << "Testa della azzera. Deve stampare: Deve stampare: < 0 7 0 0 0 7 >\n";
  v.azzera();
  cout << v << endl;

  {
    VettoreCrescente v2(3);
    v2 = v;
    cout << "\nTest dell'operatore di assegnamento. Deve stampare: < 0 7 0 0 0 7 >\n";
    cout << v2 << endl;
    cout << "\nTest del distruttore (v2 sta per essere distrutto)\n";
  }
  // --- TERZA PARTE --- (ulteriori test)
  v.set(12, 7);
  v.azzera();
  cout<<v<<endl;
  v.set(14, 8);
  v.set(15, 4);
  v.set(16, 8);
  v.set(17, 6);
  cout<<endl<<int(v)<<endl;
  v.azzera();  
  cout<<v<<endl;
  VettoreCrescente v3(5);
  v3.set(5,2);
  v3.azzera();  
  cout<<v3<<endl;
  cout<<int(v3)<<endl;
  cout<<"Test di chiamata al costruttore con dimensione negativa"<<endl;
  /*
  VettoreCrescente v4(-5);
  cout<<v4<<endl;
  */  
  
  return 0;
}
