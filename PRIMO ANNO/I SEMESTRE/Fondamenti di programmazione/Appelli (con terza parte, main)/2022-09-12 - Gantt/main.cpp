#include <iostream>
#include "compito.h"
using namespace std;

int main() {

    cout << "--- PRIMA PARTE ---" << endl<<endl;

    cout<<"Test del costruttore:"<<endl;
    Gantt g;
    cout<<g<<endl;

    cout<<"Test della aggiungiAtt:"<<endl;
    g.aggiungiAtt("Progettazione",1,5);
    cout<<g<<endl;
    g.aggiungiAtt("Implementazione",4,6);
    cout<<g<<endl;
    g.aggiungiAtt("Debug",7,10);
    g.aggiungiAtt("Produzione",10,22);
    cout<<g<<endl;

    cout<<endl<<"Test della aggiungiDip 3=>1 e 4=>2:"<<endl;
    g.aggiungiDip(3,1); // att. 3 deve iniziare dopo completamento. att 1
    g.aggiungiDip(4,2); // att. 4 deve iniziare dopo completamento. att 2
    cout<<g<<endl;

    cout<<endl<<"Altro test della aggiungiDip (queste debbono fallire entrambe):"<<endl;
    g.aggiungiDip(2,1);
    g.aggiungiDip(3,2);
    cout<<g<<endl;


    cout << "--- SECONDA PARTE ---" << endl;

    cout<<endl<<"Test della rimuoviAtt:"<<endl;
    g.aggiungiAtt("Verifica",40,8);
    g.aggiungiDip(5,3);
    cout<<g<<endl;
    g.rimuoviAtt(2);
    cout<<g<<endl;

    cout<<endl<<"Test della anticipaAtt:"<<endl;
    g.anticipaAtt(2,5);  // prova ad anticipare l'attivita' 2 di 5 mesi
    g.anticipaAtt(4,30); // prova ad anticipare l'attivita' 4 di 30 mesi
    cout<<g<<endl;


    cout<<"--- TERZA PARTE ---"<<endl<<endl;

    Gantt g2;
    g2.aggiungiAtt("Att1",1,49);
    cout<<g2<<endl;

    g2.aggiungiAtt("Att2",1,50); // deve fallire
    cout<<g2<<endl;

    g2.aggiungiAtt("Att2",2,48); // deve avere successo
    cout<<g2<<endl;
	
	
	g2.aggiungiAtt("Att3",30,10); // deve avere successo
	g2.aggiungiDip(3,1); // deve fallire
	g2.aggiungiDip(3,2); // deve fallire
	cout<<g2<<endl;
	
	g2.aggiungiAtt("Att4",20,5); // deve avere successo
	g2.aggiungiDip(3,4); // deve avere successo
    cout<<g2<<endl;
	
	g2.aggiungiAtt("Att5",49,1); // deve avere successo
	cout<<g2<<endl;
	
    return 0;

}