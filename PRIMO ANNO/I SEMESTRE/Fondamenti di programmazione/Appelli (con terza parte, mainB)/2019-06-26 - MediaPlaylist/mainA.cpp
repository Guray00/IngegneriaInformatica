#include "compito.h"
#include <iostream>
using namespace std;

int main()
{
    cout << "--- PRIMA PARTE---" << endl;
    
    cout << "Test del costruttore di default:" << endl;
    MediaPlaylist mp;
    cout << "mp" << endl << mp << endl;

    cout << "Test inserisci:" << endl;
    mp.inserisci("We are the champions", AUDIO);
    mp.inserisci("Another brick in the wall", VIDEO);
    mp.inserisci("Stairway to heaven", AUDIO);
    mp.inserisci("We are the champions", VIDEO);
    mp.inserisci("We are the champions", AUDIO);
    cout << "mp" << endl << mp << endl;

    cout << "Test elimina:" << endl;
    mp.elimina("We are the champions", VIDEO);
    mp.elimina("Stairway to heaven", VIDEO);
    mp.elimina("Bohemian rhapsody", VIDEO);
    cout << "mp" << endl << mp << endl; 
    
    return 0;
}
