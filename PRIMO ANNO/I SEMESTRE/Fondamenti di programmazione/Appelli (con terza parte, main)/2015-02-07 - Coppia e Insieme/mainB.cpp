#include <iostream>
#include "compito.h"
using namespace std;

int main(){
  // --- PRIMA PARTE ---
  cout<<"Test 1: costruttore e op. di uscita - classe Coppia (deve stampare <6,-4>)"<<endl;
  Coppia c(6,4);
  cout<<c<<endl;
  cout<<endl<<"Test 2: costruttore e op. di uscita - classe Insieme ";
  cout<<"(deve stampare <5,-9><5,-9><5,-9>)"<<endl;
  Insieme i(3);
  cout<<i<<endl;

  // --- SECONDA PARTE ---  
  { 
    Insieme i2(2);
    cout<<endl<<"Test 3: operatore di assegnamento (deve stampare <5,-9><5,-9>)"<<endl;
    i = i2;
    cout<<i<<endl;
    cout<<endl<<"Test 4: del distruttore (non deve stampare nulla)"<<endl;
  }

  Insieme i3(2);
  cout<<endl<<"Test 5: operator - unario (deve stampare <9,-5><9,-5>)"<<endl;
  cout<<-i3<<endl;

  // TERZA PARTE (DI TEST)
  Coppia c2(0xFFFFFFFF,0xFFFFFFFF);
  cout<<c2<<endl;
  Insieme i4(-4);
  cout<<i4<<endl;
  Insieme i5(5);
  i = i5;
  cout<<i<<endl;
  Insieme i6(5);
  i6=i6;

  return 0;
}
