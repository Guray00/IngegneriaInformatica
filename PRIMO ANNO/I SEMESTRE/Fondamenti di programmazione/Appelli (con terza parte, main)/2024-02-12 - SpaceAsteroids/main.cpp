#include <iostream>
#include "compito.h"

using namespace std;

int main() {

    cout<<endl<<"--- PRIMA PARTE ---" <<endl<<endl;

    cout<<"Test del costruttore:" << endl;
    SpaceAsteroids s(6, 7, 3);
    cout << s << endl;

    cout << "Test della colloca_asteroide:" << endl;
    cout << s.colloca_asteroide(1);
    cout << s.colloca_asteroide(4);
    cout << s.colloca_asteroide(7);
    cout << endl << endl;
    cout << s << endl;

    cout << "Test della avanzamento_asteroidi:" << endl;
    s.avanza();
    cout << s << endl;


    cout<<endl<<"--- SECONDA PARTE ---" <<endl<<endl;

    cout << "Test operatore <<=:" << endl;
    s <<= 5;
    cout << s << endl;

    cout << "Test operatore |=:" << endl;
    s |= 2;
    cout << s << endl;

    cout << "Test della avanza:" << endl;
    s.avanza();
    cout << s << endl;

    cout << "Altro test della avanza:" << endl;
    s.avanza();
    cout << s << endl;


    cout<<endl<<"--- TERZA PARTE ---" <<endl<<endl;

    cout << "Test costruttore con dimensioni scorrette:" << endl;
    SpaceAsteroids s1(2, 6, 8);
    cout << s1 << endl;

    cout << "Test costruttore con energia scorretta:" << endl;
    SpaceAsteroids s2(5, 5, -1);
    cout << s2 << endl;

    cout << "Test colloca_asteroide scorretta:" << endl;
    cout << s1.colloca_asteroide(0);
    cout << s1.colloca_asteroide(7);
    cout << s1.colloca_asteroide(9);
    cout << s1.colloca_asteroide(9);
    cout << s1.colloca_asteroide(10);
    cout << endl << endl;

    cout << "Test avanza_asteroidi con uscita da schermo:" << endl;
    s2.colloca_asteroide(1);
    s2.colloca_asteroide(2);
    for(unsigned i = 0; i < 4; ++i)
        s2.avanza();
    s2.colloca_asteroide(3);
    cout << s2 << endl;
    s2.avanza();
    cout << s2 << endl;

    cout << "Test avanza_asteroidi con sconfitta e aggiornamento record:" << endl;
    for(unsigned i = 0; i < 3; ++i)
        s2.avanza();
    cout << s2 << endl;

    cout << "Test operatore >>= con spostamento fuori schermo:" << endl;
    s1.colloca_asteroide(5);
    s1 >>= 10;
    cout << s1 << endl;

    cout << "Test operatore <<= e >>= prima della avanza:" << endl;
    s1 <<= 6;
    s1 >>= 2;
    cout << s1 << endl;

    cout << "Test operatore >>= e sconfitta:" << endl;
    s1.avanza();
    s1 <<= 7;
    for(unsigned i = 0; i < 5; ++i)
        s1.avanza();
    s1 >>= 4;
    cout << s1 << endl;

    cout << "Test laser su asteroide con scomparsa e laser che distrugge asteroide a due righe di distanza:" << endl;
    s.colloca_asteroide(1);
    for(unsigned i = 3; i <= 8; ++i)
        s.colloca_asteroide(i);
    s >>= 3;
    s.avanza();
    s |= 1;
    cout << s << endl;

    cout << "Test utilizzo laser prima della avanza e laser avente meno energia di quella richiesta:" << endl;
    for(unsigned i = 3; i <= 8; ++i)
        s.colloca_asteroide(i);
    s |= 3;
    s >>= 2;
    s.avanza();
    for(unsigned i = 1; i <= 8; ++i)
        s.colloca_asteroide(i);
    s.avanza();
    s |= 4;
    cout << s << endl;

    cout << "Test laser che distrugge due asteroidi consecutivamente e lancio di due laser consecutivi:" << endl;
    for(unsigned i = 1; i <= 8; ++i)
        s.colloca_asteroide(i);
    s.avanza();
    s |= 2;
    s <<= 4;
    cout << s << endl;

    cout << "Test laser senza energia:" << endl;
    for(unsigned i = 1; i <= 5; ++i)
        s.colloca_asteroide(i);
    s.avanza();
    s |= 0;
    s <<= 1;
    s |= 1;
    s.avanza();
    cout << s << endl;

    cout << "Test uscita laser dallo schermo:" << endl;
    for(unsigned i = 1; i <= 9; ++i)
        s1.colloca_asteroide(i);
    s1 |= 5;
    s1.avanza();
    for(unsigned i = 1; i <= 9; ++i)
        s1.colloca_asteroide(i);
    s1 >>= 3;
    s1 |= 2;
    s1.avanza();
    for(unsigned i = 1; i <= 9; ++i)
        s1.colloca_asteroide(i);
    s1 <<= 7;
    s1 |= 2;
    s1.avanza();
    for(unsigned i = 1; i <= 9; ++i)
        s1.colloca_asteroide(i);
    s1 >>= 2;
    s1 |= 2;
    s1.avanza();
    for(unsigned i = 1; i <= 3; ++i)
        s1.colloca_asteroide(i);
    s1 <<= 1;
    s1 |= 1;
    s1.avanza();
    for(unsigned i = 1; i <= 3; ++i)
        s1.colloca_asteroide(i);
    s1 <<= 1;
    s1 |= 1;
    s1.avanza();
    cout << s1 << endl;

    cout << "Test avanza con sconfitta che prima aggiorna il record per gli asteroidi distrutti" << endl;
    for(unsigned i = 6; i <= 9; ++i)
        s1.colloca_asteroide(i);
    s1 |= 1;
    s1 >>= 1;
    s1.avanza();
    cout << s1 << endl;

    return 0;
}