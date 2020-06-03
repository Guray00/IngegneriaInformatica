#include <iostream>
using namespace std;
#include "compito.h"

int main(){
  // --- PRIMA PARTE ---
  cout << "Test costruttore e op. uscita. Deve stampare: 'Posti liberi 14, in attesa nessuno' ";
  Ristorante r(14);
  cout << endl << r << endl;

  cout << "Test della 'aggiungi'. Deve stampare: 'Posti liberi 2, in attesa  Verdi(4) Bianchi(6) Neri(2) Rossini(5)' ";  
  r.aggiungi("Rossi", 5); 
  r.aggiungi("Viola", 7);
  r.aggiungi("Verdi", 4);
  r.aggiungi("Bianchi", 6);
  r.aggiungi("Neri", 2); 
  r.aggiungi("Rossini", 5);
  cout << endl << r << endl;

  cout << "Testa dell'op. -= (7). Deve stampare: 'Posti liberi 5, in attesa Bianchi(6) Neri(2) Rossini(5)'";
  r -= 7;   
  cout << endl << r << endl;

  /*
  // --- SECONDA PARTE ---
  {    
    cout << "Test del costruttore di copia. Deve stampare 'Posti liberi 5, in attesa Bianchi(6) Neri(2) Rossini(5)'";
    Ristorante r2(r);
    cout << endl << r2 << endl;

    cout << "Test del distruttore (r2 sta per essere distrutto): non deve stampare nulla" << endl << endl;
  }

  cout << "Test della 'rinuncia'. Deve stampare: 'Bianchi ha rinunciato. Verdini non trovato'";
  if (r.rinuncia("Bianchi"))
    cout << endl << "Bianchi ha rinunciato. "; // risp. corretta
  else
    cout << endl << "Bianchi non trovato. ";   // risp. errata

  if (r.rinuncia("Verdini"))
    cout << "Verdini ha rinunciato" << endl;  // risp. errata
  else
    cout << "Verdini non trovato" << endl;    // risp. corretta

  cout << "\nAltra verifica della 'rinuncia'. Deve stampare: 'Posti liberi 3, in attesa Rossini(5)'";
  // avendo i Sign. Bianchi rinunciato, la 'rinuncia' deve fare accomodare i Sign. Neri
  cout << endl << r << endl;  
  */
  
  return 0;  
}
