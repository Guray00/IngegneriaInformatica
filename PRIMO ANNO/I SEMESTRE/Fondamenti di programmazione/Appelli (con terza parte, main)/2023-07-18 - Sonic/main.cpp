#include <iostream>
#include "compito.h"

using namespace std;

int main(){
    cout<<"--- PRIMA PARTE ---"<<endl;

    cout<<"Test del costruttore, di avvia e di operator<<"<<endl;
    SonicLevel level1;
    level1.avvia(1, 1);
    cout << level1;
/* DISEGNO DI level1:
7
6
5
4
3
2
1 S
0================================
 01234567890123456789012345678901
*/
    cout<<"Test di operatore +="<<endl;
    level1 += 30; // Sonic vince
    cout << level1;

    cout<<"Test di blocchi, anello, e avvia (ancora)"<<endl;
    level1.blocchi(1,2,3,5).anello(4,5).anello(2,7).anello(1,7).anello(1,9).blocchi(1,12,1,3);
    level1.avvia(4,2);
    cout << level1;
/* DISEGNO DI level1:
7
6
5
4  S  o
3  =====
2  =====o
1  =====o o  ===
0================================
 01234567890123456789012345678901
*/
    cout<<"Test di raccolta anelli, caduta e camminata fermata da muro"<<endl;
    level1 += 14;

    cout<<"Test di riavvio"<<endl;
    level1.avvia(4,2);
    cout << level1;

    cout<<"Test di uno schema con buche"<<endl;
    SonicLevel level2;
    level2.blocchi(1,0,3,8).blocchi(1,8,2,6).blocchi(1,14,1,11).blocchi(2,15,1,2).blocchi(2,18,1,1).blocchi(2,21,1,4);
    level2.avvia(4,1);
    cout << level2;
/* DISEGNO DI level2:
7
6
5
4 S
3========
2============== == =  ====
1=========================
0================================
 01234567890123456789012345678901
*/
    level2 += 27; // Sonic salta due buche piccole ma si bocca su una buca larga
    cout << level2;

    cout<<"Test di uno schema con buche in cui Sonic non fa in tempo a correre"<<endl;
    SonicLevel level3;
    level3.blocchi(1,0,2,8).blocchi(3,0,1,6).blocchi(3,7,1,1).blocchi(1,8,2,6).blocchi(1,14,1,11).blocchi(2,15,1,2).blocchi(2,18,1,1).blocchi(2,21,1,4);
    level3.avvia(4,1);
    cout << level3;
/* DISEGNO DI level3:
7
6
5
4 S
3====== =
2============== == =  ====
1=========================
0================================
 01234567890123456789012345678901
*/
    (level3 += 2) += 12; // Sonic si blocca sulla buca piccola
    cout << level3;

    cout<<"--- SECONDA PARTE ---"<<endl;

    cout<<"Test di operatore *="<<endl;
    ((((level3 += 6) *= 3) *= 5) += 10) *= 6; // termino il gioco facendo vincere Sonic
    level3.blocchi(5,13,2,4);
    level3.avvia(4,1);
    ((level3 *= 5) *= 2) *= 3; // Sonic sbatte la testa sulla fine dello schema e poi su dei blocchi
    cout << level3;
/* DISEGNO DI level3 con traiettoria di Sonic (caratteri ·):
7    ·
6   · ·   ·   ====
5  ·   · · ·  ====
4 S     ·   · ·
3====== =    · ·
2==============S== =  ====
1=========================
0================================
 01234567890123456789012345678901
*/
    level3.avvia(4,1);
    ((level3 += 4) *= 1) += 3;
    cout << level3;
    ((level3 *= 3) *= 2) *= 4;
    cout << level3;
    level3 += 7; // Sonic vince
    cout << level3;
/* DISEGNO DI level3 con traiettoria di Sonic (caratteri ·):
7
6            ·====    ·
5      ·     ·====   · ·
4 S···· ··  · ·  ·  ·   ·
3====== =··S   ·· ··     S
2==============·==·=  ====
1=========================
0================================
 01234567890123456789012345678901
*/
    cout<<"Test dello schema 1 con degli spuntoni"<<endl;
    ((level1 += 10) *= 3) += 20; // termino il gioco facendo vincere Sonic
    level1.spuntone(3,4).spuntone(0,15).spuntone(0,18).spuntone(2,23);
    level1.avvia(4,2);
    level1 += 8; // Sonic viene ucciso dallo spuntone perche' non ha anelli
    cout << level1;
/* DISEGNO DI level1 con traiettoria di Sonic (caratteri ·):
7
6
5
4  S·S
3  ==^==
2  =====                ^
1  =====     ===
0===============^==^=============
 01234567890123456789012345678901
*/
    level1.avvia(4,2);
    (((level1 *= 2) += 4) *= 2) += 3; // Sonic viene ucciso dallo spuntone cadendo da una camminata
    cout << level1;
/* DISEGNO DI level1 con traiettoria di Sonic (caratteri ·):
7
6    ·
5   · ·
4  S   ··
3  ==^==·    ·
2  =====·   · ···       ^
1  =====···· ===S
0===============^==^=============
 01234567890123456789012345678901
*/
    level1.avvia(4,2);
    ((((level1 *= 2) += 4) *= 2) += 1) *= 5; // Sonic viene ucciso dallo spuntone cadendo dal salto
    cout << level1;
/* DISEGNO DI level1 con traiettoria di Sonic (caratteri ·):
7                   ·
6    ·             · ·
5   · ·           ·   ·
4  S   ··        ·     ·
3  ==^==·    ·  ·       S
2  =====·   · ··        ^
1  =====···· ===
0===============^==^=============
 01234567890123456789012345678901
*/
    cout<<"Test dello schema 1 con degli spuntoni e degli anelli"<<endl;
    level1.anello(4,3).anello(2,11).anello(4,22);
    level1.avvia(4,2);
    cout << level1;
    ((((level1 += 8) *= 2) += 4) *= 4); // Sonic sopravvive a tre spuntoni grazie ad altrettanti anelli
    cout << level1;
    level1 += 8; // Sonic vince
    cout << level1;
/* DISEGNO DI level1 con traiettoria di Sonic (caratteri ·):
7
6
5                     ·
4  So····            · o
3  ==^==·    ·      ·   S·
2  =====·   o ···  ·    ^·
1  =====···· ===···      ·······S
0===============^==^=============
 01234567890123456789012345678901
*/

    cout<<"--- TERZA PARTE ---"<<endl;

    cout<<"Test di operatori += e *= a gioco fermo"<<endl;
    level1 += 5;
    level1 *= 3;
    cout << level1;

    cout<<"Test di blocchi, anello e spuntone con input non validi"<<endl;
    level1.blocchi(0,32,1,1);
    level1.blocchi(-1,2,1,1);
    level1.blocchi(1,2,7,1);
    level1.blocchi(1,2,1,35);
    level1.anello(-1,0);
    level1.anello(0,32);
    level1.spuntone(-2,1);
    level1.spuntone(10,34);
    cout << level1;

    cout<<"Test di avvia con input non validi"<<endl;
    level1.avvia(-1,2);
    level1.avvia(8,2);
    level1.avvia(4,-10);
    level1.avvia(4,7);
    cout << level1;
    level1.avvia(2,3); // Sonic non puo' partire dentro un blocco
    cout << level1;
    level1.avvia(3,4); // ... nemmeno dentro uno spuntone
    cout << level1;
    level1.avvia(5,2); // ... ne' sospeso a mezz'aria

    cout<<"Test di blocchi, anello e spuntone a gioco avviato"<<endl;
    level1.avvia(4,2);
    level1.blocchi(5,16,2,2);
    level1.anello(3,12);
    level1.spuntone(3,20);
    cout << level1;

    cout<<"Test di operatori += e *= con input non validi"<<endl;
    level1 += -5;
    level1 += 0;
    level1 *= -3;
    level1 *= 0;
    cout << level1;

    return 0;
}