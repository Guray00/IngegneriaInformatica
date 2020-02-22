#include <iostream>
#include "compito.h"
using namespace std;

int main(){

    cout<<"\n\n---PRIMA PARTE---\n";

	cout<<endl<<"Test del costruttore, delle aggiungi e dell'operatore di uscita"<<endl;
    ContenitoreDVD d;
    d.aggiungi();
    d.aggiungi();		
    d.aggiungi('V');
    d.aggiungi('D');
    d.aggiungi();
    cout<<"(Deve stampare [--VD-])"<<endl;
    cout<<d<<endl;
    d.masterizza('D');
    cout<<"(Deve stampare [D-VD-])"<<endl;
    cout<<d<<endl;

											
    cout<<"\n\n---SECONDA PARTE---\n";

	cout<<endl<<"Test della elimina (Deve stampare [DVD-])"<<endl;
    d.elimina();    
    cout<<d<<endl;

	cout<<endl<<"Altro test della masterizza (deve stampare [DVDV])"<<endl;
    d.masterizza('V');		
    cout<<d<<endl;
    if (!d.masterizza('D'))
        cout<<"Impossibile masterizzare un ulteriore DVD dati: DVD vergini esauriti"<<endl;		
		
    cout<<endl<<"Test degli operatori di complemento e modulo :"<<endl;

    cout<<"Il numero di DVD vergini rimasti e' "<<~d<<endl;	
    cout<<"Il numero di DVD dati presenti e' "<<d%'D'<<endl;
				    
	cout<<endl<<"Test del distruttore"<<endl;
	{   
		ContenitoreDVD d2;
		d2.aggiungi();			
		cout<<"d2 sta per essere distrutto"<<endl;
	}

	cout<<endl<<"Test del costruttore di copia"<<endl;
    ContenitoreDVD d1(d);
    cout<<d1<<endl;

    return 0;
}
