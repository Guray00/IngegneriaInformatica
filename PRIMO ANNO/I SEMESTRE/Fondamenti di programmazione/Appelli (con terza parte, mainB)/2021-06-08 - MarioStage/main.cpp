#include <iostream>
#include "compito.h"

using namespace std;

int main(){
    cout<<"--- PRIMA PARTE ---"<<endl;

    cout<<"Test del costruttore, di drawBlocks, di play e di operator<<"<<endl;
    MarioStage stage1;
    stage1.drawBlocks(0, 0, 0, 31);
    stage1.play(1, 1);
    cout << stage1;
/* DISEGNO DI stage1:
7
6
5
4
3
2
1 M
0================================
 01234567890123456789012345678901
*/
    cout<<"Test di walkMario"<<endl;
    stage1.walkMario(30); // Mario vince
    cout << stage1;

    cout<<"Test di play (ancora)"<<endl;
    stage1.play(1, 1);
    cout << stage1;

    cout<<"Test di uno schema con cadute"<<endl;
    MarioStage stage2;
    stage2.drawBlocks(0, 0, 3, 7).drawBlocks(0, 8, 2, 18).drawBlocks(0, 19, 0, 31);
    stage2.play(4, 1);
    cout << stage2;
/* DISEGNO DI stage2:
7
6
5
4 M
3========
2===================
1===================
0================================
 01234567890123456789012345678901
*/
    stage2.walkMario(10).walkMario(20); // Mario vince
    cout << stage2;

    cout<<"Test di uno schema complesso con pareti, cadute e lava"<<endl;
    MarioStage stage3;
    stage3.drawBlocks(0, 0, 2, 7).drawBlocks(0, 11, 0, 31).drawBlocks(0, 11, 2, 14).drawBlocks(1, 17, 2, 19).drawBlocks(1, 25, 1, 28).drawBlocks(1, 29, 2, 31);
    stage3.play(3, 1);
    cout << stage3;
/* DISEGNO DI stage3:
7
6
5
4
3
2========   ====  ===         ===
1========   ====  ===     =======
0========   =====================
 01234567890123456789012345678901
*/
    stage3.walkMario(10); // Mario cade nella lava
    cout << stage3;

    cout<<"--- SECONDA PARTE ---"<<endl;

    cout<<"Test di jumpMario"<<endl;
    stage3.play(3, 1);
    stage3.walkMario(5).jumpMario(2); // Mario cade ancora nella lava
    cout << stage3;

    stage3.play(3, 1);
    stage3.walkMario(5).jumpMario(3).walkMario(6); // Mario smette di camminare a causa di un muro
    cout << stage3;

    stage3.jumpMario(4);
    cout << stage3;
    stage3.jumpMario(4).walkMario(6); // Mario vince
    cout << stage3;
/* DISEGNO DELLA TRAIETTORIA CHE HA SEGUITO MARIO
7
6         .
5        . .        .       .
4       .   .      . .     . .
3 M.....     .... .   .   .   ...
2========   ====..===  . .    ===
1========   ====..===   . =======
0========   =====================
 01234567890123456789012345678901
*/

    cout<<"Test dello schema 1 con la Koopa"<<endl;
    stage1.walkMario(30); // termino il gioco facendo vincere Mario
    stage1.setKoopa(1, 14);
    stage1.play(1, 1);
    cout << stage1;
    stage1.walkMario(30); // Mario viene ucciso dalla Koopa
    cout << stage1;

    cout<<"Test dello schema 2 con la Koopa"<<endl;
    stage2.setKoopa(1, 19);
    stage2.play(4, 1);
    cout << stage2;
    stage2.walkMario(30); // Mario uccide la Koopa e vince
    cout << stage2;

    cout<<"Test dello schema 3 con la Koopa"<<endl;
    stage3.setKoopa(5, 9);
    stage3.play(3, 1);
    cout << stage3;
    stage3.walkMario(6).jumpMario(3); // Mario viene ucciso dalla Koopa
    cout << stage3;
/* DISEGNO DELLA TRAIETTORIA CHE HA SEGUITO MARIO
7
6
5         K
4        .
3 M......
2========   ====  ===         ===
1========   ====  ===     =======
0========   =====================
 01234567890123456789012345678901
*/
    stage3.play(3, 1);
    stage3.walkMario(4).jumpMario(3); // Mario uccide la Koopa
    cout << stage3;
    stage3.walkMario(3).jumpMario(4).jumpMario(5); // Mario vince
    cout << stage3;
/* DISEGNO DELLA TRAIETTORIA CHE HA SEGUITO MARIO
7                  .
6        .        . .         .
5       . K      .   .       . .
4      .   .    .     .     .   .
3 M....     ....       .   .
2========   ====  ===   . .   ===
1========   ====  ===    .=======
0========   =====================
 01234567890123456789012345678901
*/

    cout<<"--- TERZA PARTE ---"<<endl;

    cout<<"Test di jumpMario"<<endl;
    stage3.drawBlocks(5, 16, 5, 18).drawBlocks(3, 21, 3, 24);
    stage3.play(3, 1);
    stage3.walkMario(4).jumpMario(3); // Mario uccide la Koopa
    cout << stage3;
    stage3.walkMario(3).jumpMario(4);
    cout << stage3;
    stage3.jumpMario(5); // Mario colpisce un blocco con la testa
    cout << stage3;
    stage3.jumpMario(7); // Mario colpisce il limite superiore del livello con la testa, poi vince
    cout << stage3;
/* DISEGNO DELLA TRAIETTORIA CHE HA SEGUITO MARIO
7                 .            .
6        .       . .          . .
5       . K     .===.        .   .
4      .   .    .    .      .
3 M....     ....     .==== .
2========   ====  === . . .   ===
1========   ====  ===  . .=======
0========   =====================
 01234567890123456789012345678901
*/
    return 0;
}
