#include "compito.h"
#include <iostream>
using namespace std;

int main()
{
    // PRIMA PARTE:
    cout << "---PRIMA PARTE---" << endl;
    cout << "Test costruttore e operatore di uscita:" << endl;
    SongPlaylist sp;
    cout << sp << endl;

    cout << "Test aggiungi():" << endl;
    sp.aggiungi("titolo1", "album1", "artista1", 300);
    sp.aggiungi("titolo2", "album2", "artista2", 240);
    sp.aggiungi("titolo3", "album3", "artista3", 301);
    cout << sp << endl;
    
    cout << "Test play():" << endl;
    sp.play(365);
    cout << sp << endl;
    
    sp.play(200);
    sp.play(300);
    sp.play(841);
    cout << sp << endl;
    
//     // SECONDA PARTE:
//     cout << "---SECONDA PARTE---" << endl;
//     cout << "Test somma e assegnamento:" << endl;
//     SongPlaylist sp2;
//     sp2.aggiungi("titolo4", "album4", "artista4", 400);
//     sp2.aggiungi("titolo5", "album5", "artista5", 200);
//     cout << "sp2=" << endl << sp2;
//     
//     sp += sp2;
//     cout << "sp=" << endl << sp << endl;
// 
//     cout << "Test int():" << endl;
//     cout << "Sono stati riprodotti " << int(sp) << " secondi" << endl;
//     sp.play(400);
//     cout << "Sono stati riprodotti " << int(sp) << " secondi" << endl;
//     sp.play(1500);
//     cout << "Sono stati riprodotti " << int(sp) << " secondi" << endl << endl;
//     
//     cout << "Test elimina():" << endl;
//     sp.elimina("titolo4", "album4", "artista4");
//     sp.elimina("titolo1", "album1", "artista1");
//     cout << "sp=" << endl << sp << endl;
// 
//     cout << "Test distruttore:" << endl;
//     {
//         SongPlaylist sp3;
//         sp3.aggiungi("titolo4", "album4", "artista4", 400);
//         sp3.aggiungi("titolo5", "album5", "artista5", 200);
//     }
//     cout << "(distruttore chiamato)" << endl;

    return 0;
}
