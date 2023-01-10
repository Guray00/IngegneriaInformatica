#include <iostream>
#include "compito.h"

using namespace std;

int main(){
    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test del costruttore:" << endl;
    LivelloPacman p;
    cout << p << endl;
	p.corr('o', 2, 2, 7).corr('v', 2, 2, 5).corr('v', 2, 4, 4).corr('o', 5, 4, 5).corr('v', 2, 8, 5).corr('o', 4, 8, 3);
    cout << p << endl;
    p.corr('o', 6, 1, 2); // corridoio per effetto pacman

    p.pacman(6, 8);
    cout << p << endl;
    p.muovi('b', 2).muovi('s', 4).muovi('b', 3).muovi('s', 2).muovi('a', 4);
    cout << p << endl;
    p.muovi('s', 3); // pacman effect;
    cout << p << endl;

    // SECONDA PARTE
    cout << endl << "--- SECONDA PARTE ---" << endl;
    cout << "Spazio a destra: " << p.spazio('d') << endl;
    cout << "Spazio a sinistra: " << p.spazio('s') << endl;
    cout << "Spazio in basso: " << p.spazio('b') << endl;
    cout << "Spazio in alto: " << p.spazio('a') << endl;
    p.fantasma(2, 2);
    cout << p << endl;
    p.muovi('b', 4).muovi('s', 6).muovi('a', 2).muovi('s', 4);
    cout << p << endl;
    p.fermo(); // mi faccio acchiappare dal fantasma
    cout << p << endl;

    // TERZA PARTE
    cout << endl << "--- TERZA PARTE ---" << endl;
    LivelloPacman p2;
    p2.corr('x', 2, 2, 7).corr('V', 3, 3, 7).corr('v', 0, 2, 5).corr('v', 2, 0, 4).corr('o', 5, 4, 0).corr('v', 2, 8, -5).corr('o', -2, 8, 3); // nessuna di queste dovrebbe fare effetto
    cout << p2 << endl;
    p2.corr('o', 5, 20, 2).corr('v', 10, 2, 4); // nemmeno queste, i corridoi escono dallo schema
    cout << p2 << endl;
    p2.corr('v', 7, 3, 5).corr('o', 1, 13, 6); // le coordinate dei corridoi non sono del quadrante in alto a destra
    cout << p2 << endl;
    // dovrebbero ritornare -1 perche' pacman ancora non c'e':
    cout << "Spazi non validi: " << p2.spazio('d') << " " << p2.spazio('s') << " " << p2.spazio('a') << " " << p2.spazio('b') << endl;
    // dovrebbero ritornare -1 perche' pacman non c'e' piu':
    cout << "Spazi non validi: " << p.spazio('d') << " " << p.spazio('s') << " " << p.spazio('a') << " " << p.spazio('b') << endl;
    p2.pacman(0, 4).pacman(6, 30).pacman(-2, 3); // input non validi
    p2.pacman(4, 4).pacman(6, 6).pacman(2, 8); // c'e' il muro
    cout << p2 << endl;
    p2.pacman(1, 3);
    cout << p2 << endl;
    p2.pacman(3, 3); // pacman gia' presente
    cout << p2 << endl;
    p2.muovi('s', 3); // non si muove: c'e' il muro
    cout << p2 << endl;
    p2.muovi('b', 6); // si ferma al muro
    cout << p2 << endl;
    p2.muovi('a', 11); // effetto pacman e poi si ferma al muro
    cout << p2 << endl;
    cout << "Spazio in basso: " << p2.spazio('b') << endl; // fino a fine schema
    // dovrebbe ritornare -1 per input non valido:
    cout << "Spazio con input non valido: " << p2.spazio('x') << endl;
    p2.corr('o', 14, 12, 5);
    cout << p2 << endl; // creo un altro corridoio che comprende pacman

    const LivelloPacman const_p;
    cout << "Prova su oggetto costante: " << const_p.spazio('d') << endl; // prova su oggetto costante

    p2.fantasma(0, 4).fantasma(6, 30).fantasma(-2, 3); // input non validi
    p2.fantasma(4, 4).fantasma(6, 6).fantasma(2, 8); // c'e' il muro
    cout << p2 << endl;
    p2.fantasma(12, 8);
    cout << p2 << endl;
    p2.muovi('s', 10); // dopo una casella c'e' il muro, quindi il fantasma si deve muovere solo di 1 casella
    cout << p2 << endl;
    p2.muovi('d', 1).muovi('s', 1).muovi('d', 1).muovi('s', 1); // il fantasma va in stallo (vorrebbe andare in alto ma c'e' muro)
    cout << p2 << endl;
    p2.muovi('d', 1).muovi('b', 6); // il fantasma acchiappa pacman a meta' del movimento verso il basso
    cout << p2 << endl;
    p2.fermo().fermo().fermo(); // non fa niente (non c'e' piu' il pacman)
    cout << p2 << endl;
	p2.muovi('a',1); // pacman non presente
	cout << p2 << endl; 
	p2.pacman(1,3); // inserisce un nuovo pacman
	cout << p2 << endl;

    return 0;
}