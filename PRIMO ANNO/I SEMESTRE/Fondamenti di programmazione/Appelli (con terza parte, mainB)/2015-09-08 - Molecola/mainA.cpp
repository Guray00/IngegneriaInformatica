#include <iostream>
using namespace std;
#include "compito.h"

int main(){
  // --- PRIMA PARTE ---
  cout << "Test del costruttore e della aggiungi. Deve stampare <H2-Si5-C1-Fe3>" << endl;
  Molecola m;  
  m.aggiungi("Fe",3);
  m.aggiungi("C",1);
  m.aggiungi("Si", 5);
  m.aggiungi("H",2);
  cout << m << endl;

  cout << "Altro test della aggiungi. Deve stampare <H5-Si5-C1-Fe3>" << endl;
  m.aggiungi("H",3); // H era gia' presente: sommo le quantita'  
  cout << m << endl;

  cout << "Test della elimina. Deve stampare <Si5-C1>" << endl;
  m.elimina("H");
  m.elimina("Fe");
  m.elimina("N"); // elemento non presente, Molecola inalterata
  cout << m << endl;

/*
  // --- SECONDA PARTE ---    
  {        
    // creazione della molecola m1
    Molecola m1;
    m1.aggiungi("Li", 2);
    m1.aggiungi("C", 3);
    // cout << m1 << endl;

    cout << "Test operatore +=. Deve stampare <Li2-Si5-C4>" << endl;
    m += m1;
    cout << m << endl;
    
    cout << "Test dell'op. di assegnamento. Deve stampare <Li2-Si5-C4>" << endl;
    m1 = m;
    cout << m << endl;    
  }
  cout << "Test del distruttore: m1 e' stato distrutto (non deve stampare nulla)" << endl;
*/
  return 0;
}
