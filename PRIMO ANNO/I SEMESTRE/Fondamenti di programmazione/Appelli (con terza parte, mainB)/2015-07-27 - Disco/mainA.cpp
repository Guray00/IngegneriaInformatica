#include <iostream>
using namespace std;
#include "compito.h"

int main(){
  // --- PRIMA PARTE ---
  cout << "Test del costr., della 'riserva' e dell'op. <<. Deve stampare: '11000000' ";
  Disco d(8);
  d.riserva(1900);
  cout << endl << d << endl;

  cout << "Altri test della 'riserva'. Deve stampare: '11222300' ";
  int file2 = d.riserva(2500);
  d.riserva(700);
  cout << endl << d << endl;

  cout << "Test della 'cancella' del file con id==2. Deve stampare: '11000300'";
  d.cancella(file2);
  cout << endl << d << endl;

  cout << "Altro test della 'riserva'. Deve stampare: '11444340'";
  d.riserva(4000);
  cout << endl << d << endl;
  /*
  // --- SECONDA PARTE ---
  cout << "Test della 'deframmenta'. Deve stampare '44443110'" << endl;
  d.riserva(1025); // questa riserva deve fallire
  d.deframmenta();
  cout << d << endl;

  cout << "Test dell'operatore ! di formattazione. Deve stampare '11111200'" << endl;
  !d;
  d.riserva(5000);
  d.riserva(300);
  cout << d << endl;

  cout << "Test distruttore e 'getQuantiDischi'. Deve stampare 2 (d2 viene distrutto)";
  { 
    Disco d2(7);   
  }
  Disco d3(5);
  cout << endl << Disco::getQuantiDischi()<<endl;
  */
  return 0;  
}
