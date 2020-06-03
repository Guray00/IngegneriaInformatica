#include <iostream>
#include "compito.h"
using namespace std;

int main(){
    
  // --- PRIMA PARTE ---
  cout<<"Test 1: costruttore, op. += ed op. << (deve stampare '1:=>FERRARI F150' )"<<endl;
  Concessionaria c;
  c+="FERRARI F150";
  cout<<c<<endl;
	
  cout<<"\nTest 2: ulteriori test (deve st. '3:=>BUGATTI...=>FERRARI...=>MCLAREN...' )"<<endl;
  c+="MCLAREN F1";
  c+="BUGATTI VEYRON";	
  cout<<c<<endl;

  cout<<"\nTest 3: conversione ad intero (deve stampare 3)"<<endl; 
  cout<<int(c)<<endl;
	/*
  // --- SECONDA PARTE ---
  cout<<"\nTest 4: funzione 'cerca' (deve st. '2', per via di FERR(AR)I e MCL(AR)EN )"<<endl;	
  cout<<c.cerca("AR")<<endl;
	
  cout<<"\nTest 5: op. -= (deve stampare '1:=>MCLAREN F1' )"<<endl;
  c-=2;
  cout<<c<<endl;
		
  cout<<"\nTest 6: distruttore (non deve stampare nulla)"<<endl;
	*/  
  return 0;
}
