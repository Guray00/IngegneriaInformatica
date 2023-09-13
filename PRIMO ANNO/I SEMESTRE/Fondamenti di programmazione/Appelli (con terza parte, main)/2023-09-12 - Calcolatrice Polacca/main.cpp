#include <iostream>
#include "compito.h"
using namespace std;


int main() {
	
    cout<<endl<<"--- PRIMA PARTE ---" <<endl<<endl;
	
    CalcolatricePolacca c;
    // supponiamo di voler calcolare l'espressione 5*3 + 4
	// in notazione polacca postfissa, l'espressione diventa: 5 3 * 4 +
    c.ins(5);
    c.ins(3);    
    cout<<c<<endl;
		
    c.moltiplica();
    cout<<c<<endl;
	
	
    c.ins(4);
    cout<<c<<endl;
    c.somma();
    cout<<c<<endl; // deve mostrare un unico operando: "Op1: 19"
 
	
    // verificare che si ottiene lo stesso risultato, anche seguendo questo seconda sequenza 
    // di operazioni, ossia: 4 5 3 * +
    c.ins(4);    
    c.ins(5);
    c.ins(3); 
    cout<<c<<endl;
    c.moltiplica();	
    cout<<c<<endl;
    c.somma();
    cout<<c<<endl;     // deve mostrare due operandi: "Op1: 19" e "Op2: 19"
	
	
    cout<<endl<<"--- SECONDA PARTE ---" <<endl<<endl;
	
    cout<<endl<<"Test della funzione 'duplica' e della funzione 'opposto' (deve mostrare 'Op1: -49')" <<endl;
    CalcolatricePolacca c2;
    c2.ins(7);
    c2.duplica();
    c2.opposto();
    c2.moltiplica();
    cout<<c2<<endl;    // deve mostrare -49 in cima alla CalcolatricePolacca
	
	
    cout<<endl<<"Test operatore di assegnamento" <<endl;
    CalcolatricePolacca c3;
    c3.ins(11);
    c3.ins(22);
    cout<<"Contenuto di c3 prima dell'ass. (deve mostrare gli operandi: 'Op1: 22' e 'Op2: 11')"<<endl;
    cout<<c3<<endl;
    c3 = c2;
    cout<<"Contenuto di c3 dopo avergli assegnato c2 (ora dovra' contenere solo 'Op1: -49')"<<endl;
    cout<<c3<<endl;
	
	
    cout<<endl<<"Test della funzione 'rimuoviNegativi'" <<endl;
    c3.ins(-19);
    c3.ins(13);
    c3.ins(-23);
    c3.ins(88);
    cout<<"Situazione PRIMA della 'rimuoviNegativi'"<<endl;
    cout<<c3;    // ora c3 deve contenere solo operandi positivi o nulli
    c3.rimuoviNegativi();
    cout<<"Situazione DOPO la 'rimuoviNegativi'"<<endl;
    cout<<c3<<endl;    // ora c3 deve contenere solo operandi positivi o nulli
	
    cout<<endl<<"--- TERZA PARTE ---" <<endl<<endl;
    CalcolatricePolacca c4;
    c4.duplica();   
    cout<<c4<<endl;    // deve lasciare la CalcolatricePolacca invariata, poichÃ¨ non c'era nessun operando
	
    c4.ins(7); 
    c4.somma();
    cout<<c4<<endl;    // deve lasciare la CalcolatricePolacca invariata, con il solo operando 7, 
	               // perchÃ¨ manca un argomento
    
    return 0;

}