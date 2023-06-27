#include <iostream>
#include "compito.h"
using namespace std;

int main() {
    {
        cout <<"--- PRIMA PARTE ---" << endl;

        cout << "Test del costruttore e dell'operatore di uscita" << endl;
        Occorrenze o("CHE FAI TU LUNA IN CIEL DIMMI CHE FAI SILENZIOSA LUNA");
        cout << o << endl;

        cout << "Test dell'operatore di modulo: (deve stampare 3)" << endl;
        cout << o % 2 << endl << endl;


       cout <<"--- SECONDA PARTE ---" << endl;

       cout << "Test dell'operatore di somma ed assegnamento: (LUNA:3, DAMMI:1)" << endl;
       o += "LUNA";
       o += "DAMMI";
       cout << o << endl;

       cout << "Test dell'operatore parentesi quadra:" << endl;
       cout << "-> numero di occorrenze della parola LUNA (deve stampare 3): " << o["LUNA"] << endl;
       cout << "-> numero di occorrenze della parola CHE  (deve stampare 2): " << o["CHE"] << endl <<endl;

       cout << "Test dell'operatore di sottrazione e assegnamento (rimuove DAMMI e DIMMI):" << endl;
       o -= 'D';
       cout << o << endl;

       cout << "Test del distruttore ('o' sta per essere distrutto)" << endl;
    }


    cout <<"--- TERZA PARTE ---" << endl;
    cout << "Test costruttore con spazi bianchi multipli:" << endl;
    Occorrenze o2("CHE FAI TU      LUNA IN CIEL DIMMI   CHE FAI     SILENZIOSA LUNA          ");
    cout << o2 << endl << endl;

    cout << "Test dell'operatore di somma e assegnamento (aggiunge in testa e in fondo alla lista):" << endl;
    o2 += "ZORRO";
    o2 += "ZUCCA";
    o2 += "AMACA";
    cout << o2 << endl << endl;

    cout << "Test dell'operatore di sottrazione e assegnamento (rimuove in testa e in fondo alla lista):" << endl;
    o2 -= 'A';
    o2 -= 'Z';
	o2 -= 'T';
    cout << o2 << endl << endl;

    cout << "Test dell'operatore di sottrazione e assegnamento (svuota la lista e rimuove da lista vuota):" << endl;
    Occorrenze o3("AMACA AMICO AMENO");
    cout << o3 << endl;
    o3 -= 'A';
    cout << "(non deve stampare nulla:)" << endl;
    cout << o3 << endl;
    o3 -= 'C';
    cout << "(non deve stampare nulla:)" << endl;
    cout << o3 << endl << endl;

	cout<< "Ulteriore test dell'operatore di modulo" <<endl;
	cout<< o2 % 1 << endl <<endl;
}
