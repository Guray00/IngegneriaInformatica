#include <iostream>
#include "compito.h"
using namespace std;

int main(){
  cout << "--- PRIMA PARTE ---" << endl;
  cout << "Test del costruttore e dell'operatore di uscita" << endl;
  Smistacasse s(3);
  cout << s << endl;
  
  cout << "Test della 'aggiungi'" << endl;
  s.aggiungi(68,11);
  s.aggiungi(74,7);
  cout << s << endl;
  
  s.aggiungi(76,8);
  s.aggiungi(52,9);
  cout << s << endl;
	
  cout << "Test della 'trovaCassa'" << endl;
  cout << s.trovaCassa() <<endl << endl;

  cout << "Test della 'servi' sulla seconda e terza cassa" << endl;
  s.servi(2);
  s.servi(3);
  cout << s << endl;
  
  cout << "--- SECONDA PARTE --- " << endl;

  cout << "Test dell'operatore -= sulla prima cassa" << endl;
  s -= 1;
  cout << s << endl;
      
  {
    cout << "Test del distruttore";
    Smistacasse s1(-2); 
    s1.aggiungi(28,10);
    s1.aggiungi(32,3);
  }
  cout << " (s1 e' stata appena distrutta)" << endl;
    

  cout<<"--- TERZA PARTE ---" <<endl;
  
  Smistacasse s2(1);
  s2.aggiungi(33,4);
  s2.aggiungi(44,8);
  s2.aggiungi(55,9);
  cout<<s2<<endl;
  s2-=1;
  cout<<s2<<endl;
  s2.aggiungi(66,1);
  cout<<s2<<endl;

 
  Smistacasse s3(2);
  cout << s3 << endl;
  
  cout << "Test della 'aggiungi'" << endl;
  s3.aggiungi(68,11);
  s3.aggiungi(74,7);
  cout << s3 << endl;
  
  s3.aggiungi(76,8);
  s3.aggiungi(52,9);
  cout << s3 << endl;

  cout << s3.trovaCassa() << endl;
  s3.servi(-2);

  s3.servi(0);
  s3.servi(1);
  s3.servi(1);
  s3.servi(1);
  s3.servi(1);
  s3.servi(1);
  cout << s3 << endl;
  s3-=2;
  cout<<s3<<endl;
  s3.aggiungi(99,9);
  cout << s3 << endl;
  s3-=1;
  cout<<s3<<endl;
  s3-=3;
  cout<<s3<<endl;
  
  return 0;

}
