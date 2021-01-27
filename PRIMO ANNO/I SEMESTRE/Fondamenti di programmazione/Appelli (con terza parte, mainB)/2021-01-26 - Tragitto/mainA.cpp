#include<iostream>
#include "compito.h"

using namespace std;

int main(){
	cout<<"--- PRIMA PARTE ---"<<endl;
	
	cout<<"Test del costruttore"<<endl;
	Tragitto t;
	cout << t << endl;
	
	cout<<"Test della inserisci"<<endl;
	t.inserisci("Verdi");
	cout<<t<<endl;
		
	t.inserisci("Rossi");    // deve fallire, terchè la trima postazione è occupata
	cout<<t<<endl;
	
	cout<<"Test della avanza"<<endl;
	t.avanza(1);
	cout<<t<<endl;    
	
	cout<<"Altro test della inserisci"<<endl;	
	t.inserisci("Rossi"); 
	cout<<t<<endl;	
	
	/*
	cout<<"--- SECONDA PARTE ---"<<endl;
	
	cout<<"Test dell'operatore +="<<endl;
	t += 3;		
	cout<<t<<endl;	
	
	cout<<"Altri test della avanza"<<endl;
	t.avanza(2);
	t.avanza(3);
	cout<<t<<endl;	
	t.avanza(1);
	cout<<t<<endl;
		
	cout<<"Provo ad inserire di nuovo Verdi (l'inserimento deve fallire')"<<endl;
    t.inserisci("Verdi");	// deve fallire perchè un Verdi esiste già	
	cout<<t<<endl;

	{
		cout<<"Test del costruttore di copia"<<endl;
	    Tragitto t1(t);
        cout<<t1<<endl;
	}
	
	cout<<"Test del distruttore (e' appena stato distrutto l'oggetto t1)"<<endl;
	
	
	cout << "--- TERZA PARTE ---"<<endl;
	t.avanza(2);
	t.avanza(2);
	t.avanza(2);
	cout<<t<<endl;
	
	t.avanza(5);
	t.avanza(5);
	cout<<t<<endl;
	t.avanza(4);
	cout<<t<<endl;
	t.avanza(4);
	cout<<t<<endl;
	t.avanza(5);
	cout<<t<<endl;
	*/
	
}
