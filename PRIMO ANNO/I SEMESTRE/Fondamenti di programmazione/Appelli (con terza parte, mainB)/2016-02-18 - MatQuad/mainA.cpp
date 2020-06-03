#include <iostream>
using namespace std;
#include "compito.h"

int main(){
  
  cout<<"--- PRIMA PARTE ---" << endl;
  cout << "\nTest del costruttore e dell'operatore di uscita" << endl;
  MatQuad m(4);
  cout << m << endl;

  cout << "Test della 'aggiorna'" << endl;
  const int dim = 7;
  int vett[dim] = {5, 5, 5, 6, 4, 4, 3};
  m.aggiorna(vett, dim);
  cout << m << endl;

  cout << "Test della 'trova':" << endl;
  if ( m.trova() )
    cout << "trovata una riga con almeno tre valori consecutivi uguali fra loro"<<endl;
  else 
    cout << "nessuna riga con almeno tre valori consecutivi uguali fra loro"<<endl;
    
/*
  cout << "\n--- SECONDA PARTE ---" << endl;

  cout << "\nTest della 'raddoppia'"<<endl;
  m.raddoppia();    
  cout << m << endl;
    
  {
    MatQuad m2(3);
  }
  cout << "Test del distruttore (m2 e' stata appena distrutta)\n" << endl;     
  
  cout << "\n--- TERZA PARTE (test aggiuntivi) ---\n" << endl;
  
  MatQuad m3(4);
  const int dim2 = 14;
  int vett2[dim2] = {5, 2, 5, 6, 4, 4, 3, 1, 2, 3, 4, 2 ,1, 8};
  m3.aggiorna(vett2,dim2);
  if ( m3.trova() )
    cout << "trovata una riga con almeno tre valori consecutivi uguali fra loro"<<endl;
  else 
    cout << "nessuna riga con almeno tre valori consecutivi uguali fra loro"<<endl;
    
  MatQuad m4(2);
  if ( m4.trova() )
    cout << "trovata una riga con almeno tre valori consecutivi uguali fra loro"<<endl;
  else 
    cout << "nessuna riga con almeno tre valori consecutivi uguali fra loro"<<endl;
  
  MatQuad m5(1);
  m5.aggiorna(vett2,dim2);
  m5.raddoppia();
  cout << m5 << endl;
  
  MatQuad m6(-4);
  cout << m6 << endl;
*/
  
  return 0;
}
