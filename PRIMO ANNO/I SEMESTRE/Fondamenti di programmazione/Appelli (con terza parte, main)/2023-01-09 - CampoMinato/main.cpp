#include <iostream>
#include "compito.h"
using namespace std;

int main() {

    cout << "--- PRIMA PARTE ---" << endl<<endl;

    cout<<"Test del costruttore:"<<endl;
    CampoMinato c(3);
    cout << c << endl;

    cout<<"Test della aggiungi_mina:"<<endl;
    c.aggiungi_mina(1, 2);
    c.aggiungi_mina(2, 1);
    cout << c << endl;

    cout<<"Test della scopri:"<<endl;
    c.scopri(2, 2);
    cout << c << endl;

    c.scopri(0, 1);
    cout << c << endl;

    c.scopri(1,2);
    cout << c << endl;


    cout << endl << "--- SECONDA PARTE ---" << endl<<endl;

    cout<<"Test del costruttore di copia:"<<endl;
    CampoMinato c2(c);
    cout << c2 << endl;

    cout<<"Altri Test della scopri:"<<endl;
    c2.scopri(2, 2);
    c2.scopri(0, 0);
	cout << c2 << endl;
    c2.scopri(2, 0);
    c2.scopri(0, 2);
    cout << c2 << endl;

    cout<<"Test dell'operatore +:"<<endl;
    CampoMinato c6 = c + c2;
    c6.scopri(5, 5);
    c6.scopri(2, 2);
    cout << c6 << endl;

    {
        cout<<"Test del distruttore:"<<endl;
        CampoMinato c7(9);
    }


    cout << endl << "--- TERZA PARTE ---" << endl<<endl;

    cout<<"Altro test della scopri:"<<endl;
    CampoMinato c4(4);
    c4.scopri(3,1); // scopri su gioco non avviabile, non deve cambiare nulla
    cout << c4 << endl;

    cout <<"Altri test della aggiungi_mina:"<<endl;
    cout << c4.aggiungi_mina(0, 1) << ' ';          // queste mine devono essere aggiunte perchÃ© la
    cout << c4.aggiungi_mina(1, 1) << ' ';          // precedente scopri Ã¨ stata invocata su un gioco
    cout << c4.aggiungi_mina(2, 3) << endl << endl; // non avviabile

    cout<<"Altro test operatore +:"<<endl;
    CampoMinato c5 = c2 + c4;
    cout << c5 << endl;

    cout <<"Altri test della aggiungi_mina:"<<endl;
    cout << c5.aggiungi_mina(2, 4) << ' ';
    cout << c5.aggiungi_mina(2, 2) << endl << endl;

    cout<<"Altri test della scopri:"<<endl;
    c5.scopri(0, 6);
    c5.scopri(5, 1); // parecchie celle vengono scoperte
    cout << c5 << endl;

    cout<<"Altri test della scopri:"<<endl;
    CampoMinato c3(c2);
    c3.scopri(-1, 2);
    c3.scopri(0, 3); // le scopri devono fallire perchÃ© fuori bound
    cout << c3 << endl;

    cout <<"Altri test della aggiungi_mina:"<<endl;
    cout << c3.aggiungi_mina(2, 2) << ' '; // La mina deve comunque esser piazzata perchÃ© le scopri hanno fallito

    cout << c3.aggiungi_mina(2, -1) << ' '; // queste aggiungi_mina sono fuori bound
    cout << c3.aggiungi_mina(3, 1) << ' ';
    cout << c3.aggiungi_mina(1, 2) << endl << endl;
    cout << c3 << endl;

    cout<<"Altri test della scopri:"<<endl;
    c3.scopri(2, 0); // Test di vittoria per ricorsione
    c3.scopri(0, 2);
    c3.scopri(0, 0);
    cout << c2 << endl;

    // Test di continuazione su un gioco perso che permetterebbe di vincere
    c.scopri(2, 0);
    c.scopri(0, 2);
    cout << c << endl;

    // Test di continuazione su gioco vinto che porterebbe a perdere
    c3.scopri(2, 2);
    cout << c3 << endl;

    return 0;
}