#include <iostream>
#include "compito.h"

using namespace std;

int main()
{
   cout << "---PRIMA PARTE---\n\n";

   cout << "test del costruttore\n";
   Pianoforte p(3);
   cout << p << endl << endl;
   cout << "test di accordo\n";
   p.accordo('s', 0);
   cout << p << endl;
   // cerca di premere con la destra alcuni tasti che sono premuti con la sinistra.
   p.accordo('d', 2);
   cout << p << endl;
   p.accordo('d', 11);
   cout << p << endl << endl;
   
   cout << "test dell'operatore -= per rilascio mano\n";
   p -= 'd';
   cout << p << endl << endl;

//    cout << "---SECONDA PARTE---\n\n";
//    cout << "test dell'operatore -= per rilascio dito\n";
//    p -= 2;
//    p -= 4;
//    cout << p << endl << endl;
//    
//    cout << "test di nota\n";
//    // cerco di premere con la sinistra un tasto troppo lontano.
//    p.nota('s', 13);
//    cout << p << endl;
//    p.nota('d', 17);
//    p.nota('d', 23);
//    p.nota('d', 24);
//    cout << p << endl;
//    // cerco di premere con la destra un tasto troppo lontano.
//    p.nota('d', 3);
//    cout << p << endl << endl;
//    
//    cout << "test del distruttore\n";
//    {
//        Pianoforte p2(2);
//        p2.accordo('s', 10);
//        cout << p2 << endl;
//    }
//    cout << "distruttore invocato\n";
   
   return 0;
}