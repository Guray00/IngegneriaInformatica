#include "compito.h"
#include <iostream>
using namespace std;

int main()
{
    // --- PRIMA PARTE --- //
    
    cout << "Test del costruttore" << endl;
    Scrabble s(7);
    cout << s << endl;
    
    cout << "Test s.aggiungi" << endl;
    s.aggiungi("auto",5,0,'O');
    s.aggiungi("treno",0,4,'V');
    s.aggiungi("aereo",1,2,'O');
    s.aggiungi("moto",3,2,'V');
    s.aggiungi("nave",3,3,'O');   // fallisce (!)
    cout << s << endl;
    
    // creazione Scrabble s1
    cout << "Test s1.aggiungi" << endl;
    Scrabble s1(6);
    s1.aggiungi("gatto",1,0,'O');
    s1.aggiungi("cane",0,1,'V');
    s1.aggiungi("mucca",5,1,'O');
    cout << s1 << endl;
    
    cout << "Test dell'operatore di assegnamento s1 = s" << endl;
    s1 = s;
    cout << s1 << endl;
    
    // --- SECONDA PARTE --- //
    
    cout << "Primo test s1.esiste" << endl;
    if (s1.esiste("auto"))
        cout << "La parola cercata esiste! :)" << endl;
    else
        cout << "La parola cercata non esiste! :(" << endl;
    
    cout << endl << "Secondo test s1.esiste" << endl;
    if (s1.esiste("nave"))
        cout << "La parola cercata esiste! :)" << endl;
    else
        cout << "La parola cercata non esiste! :(" << endl;
    
    cout << endl << "Test operator!" << endl;
    cout << !s1 << endl;
    
    {
        Scrabble s2(15);
        cout << endl << "Test del distruttore" << endl;
    }
    cout << "(s2 e' stato distrutto)" << endl;

    // --- TERZA PARTE --- //
    cout<< endl << "Ulteriori test - TERZA PARTE - " << endl;

    Scrabble s3(3);
    cout << s3 << endl;
    s3.aggiungi("tre",0,0,'O');
    s3.aggiungi("tre",0,0,'V');
    cout << s3 << endl;

    Scrabble s4(4);
    s4.aggiungi("otto",0,0,'O');
    s4.aggiungi("otto",0,0,'V');
    s4.aggiungi("otto",3,0,'O');
    s4.aggiungi("otto",0,3,'V');
    cout << s4 << endl;
    cout << !s4 << endl;

    Scrabble s5(5);
    s5.aggiungi("tre",2,0,'O'); // deve riuscire
    s5.aggiungi("tre",0,2,'V'); // deve riuscire
    s5.aggiungi("si",4,3,'O');  // deve riuscire
    s5.aggiungi("si",3,4,'V');  // deve riuscire
    cout << s5 << endl;
    cout << !s5 << endl;
    s5.aggiungi("cinque",3,0,'O'); // deve fallire
    s5.aggiungi("cinque",0,3,'V'); // deve fallire
    s5.aggiungi("otto",3,0,'O');   // deve riuscire
    s5.aggiungi("otto",0,3,'V');   // deve riuscire
    cout << s5 << endl;
    cout << !s5 << endl;
    s5.aggiungi("tre",0,0,'O'); // deve fallire
    s5.aggiungi("tre",0,0,'V'); // deve fallire
    s5.aggiungi("no",0,0,'O');  // deve riuscire
    s5.aggiungi("no",0,0,'V');  // deve riuscire
    s5.aggiungi("no",1,4,'V');  // deve riuscire
    cout << s5 << endl;
    cout << !s5 << endl;

  cout << s << endl;
  if (s.esiste("reo"))
    cout << "La parola cercata esiste! :)" << endl; 
    // risp. esatta
  else
    cout << "La parola cercata non esiste! :(" << endl;
    
  if (s.esiste("oto"))
    cout << "La parola cercata esiste! :)" << endl; 
    // risp. esatta
  else
    cout << "La parola cercata non esiste! :(" << endl;

  if (s.esiste("aut"))
    cout << "La parola cercata esiste! :)" << endl; 
    // risp. esatta
  else
    cout << "La parola cercata non esiste! :(" << endl;

  if (s.esiste("en"))
    cout << "La parola cercata esiste! :)" << endl; 
    // risp. esatta
  else
    cout << "La parola cercata non esiste! :(" << endl;

  return 0;

}
