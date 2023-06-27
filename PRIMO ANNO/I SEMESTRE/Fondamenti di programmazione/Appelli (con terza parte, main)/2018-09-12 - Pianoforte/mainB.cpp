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

   cout << "---SECONDA PARTE---\n\n";
   cout << "test dell'operatore -= per rilascio dito\n";
   p -= 2;
   p -= 4;
   cout << p << endl << endl;
   
   cout << "test di nota\n";
   // cerco di premere con la sinistra un tasto troppo lontano.
   p.nota('s', 13);
   cout << p << endl;
   p.nota('d', 17);
   p.nota('d', 23);
   p.nota('d', 24);
   cout << p << endl;
   // cerco di premere con la destra un tasto troppo lontano.
   p.nota('d', 3);
   cout << p << endl << endl;

   cout << "test del distruttore\n";
   {
       Pianoforte p2(2);
       // chiamata valida ad accordo:
       p2.accordo('s', 10);
       cout << p2 << endl << endl;
       
       cout << "---TERZA PARTE---\n\n";
       // chiamate non valide ad accordo:
       p2.accordo('z', 3);
       cout << p2 << endl;
       p2.accordo('d', -1);
       cout << p2 << endl;
       p2.accordo('s', 19);
       cout << p2 << endl;
       
       // chiamata non valida ad accordo:
       p2.accordo('s', 11);
       cout << p2 << endl;
       // chiamate non valide a operatore -= per rilascio mano:
       p2 -= 'z';
       cout << p2 << endl;
       p2 -= 'd';
       cout << p2 << endl;
       // chiamate non valide a operatore -= per rilascio dito:
       p2 -= -2;
       cout << p2 << endl;
       p2 -= 24;
       cout << p2 << endl;
       p2 -= 11;
       cout << p2 << endl;
       // chiamata valida a operatore -= per rilascio dito:
       p2 -= 10;
       cout << p2 << endl;
       // chiamate non valide a nota:
       p2.nota('z', 2);
       cout << p2 << endl;
       p2.nota('s', -3);
       cout << p2 << endl;
       // chiamata valida a nota:
       p2.nota('d', 2);
       cout << p2 << endl << endl;
   }
   cout << "distruttore invocato" << endl;
   return 0;
}