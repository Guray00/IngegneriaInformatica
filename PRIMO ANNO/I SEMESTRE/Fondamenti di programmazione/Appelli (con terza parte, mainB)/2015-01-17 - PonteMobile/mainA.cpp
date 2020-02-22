#include <iostream>
#include "compito.h"

using namespace std;

int main(){

  // PRIMA PARTE
  cout<<"Test costruttore e op. di uscita (deve stampare 'PONTE APERTO=>AAA')"<<endl;
  PonteMobile p("AAA");
  cout<<p<<endl;
  
  cout<<"Test della aggiungi (deve stampare 'PONTE APERTO=>AAA=>BB=>C')"<<endl;
  p.aggiungi("BB");
  p.aggiungi("C");
  cout<<p<<endl;
  
  /*
  // SECONDA PARTE  
  
  cout<<"Altro test della aggiungi e dell'op. di compl. bit a bit (deve stampare 3)"<<endl;
  p.aggiungi("DDDDDDDD"); // questo inserimento deve fallire (ident. troppo lungo)
  cout<<~p<<endl<<endl;
  
  cout<<"Test operatore -= (deve stampare 'PONTE APERTO=>AAA=>C')"<<endl;
  p-= "BB";
  cout<<p<<endl;
    
  cout<<"Test della cambiaStato (deve stampare 'PONTE CHIUSO')"<<endl;
  p.cambiaStato();
  cout<<p<<endl;   
      
  { 
    cout<<"(Test del distruttore)"<<endl;
    PonteMobile p2("WXYZ");
    // qui viene chiamato implicitamente il distruttore per l'oggetto p2
  }
  */
  return 0;
}

