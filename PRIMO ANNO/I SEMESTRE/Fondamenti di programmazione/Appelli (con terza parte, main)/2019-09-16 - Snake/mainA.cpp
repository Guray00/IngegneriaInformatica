#include "compito.h"
#include <iostream>
using namespace std;

int main()
{
    cout << "--- PRIMA PARTE ---" << endl;
    
    cout << "Test costruttore:" << endl;
    Snake s(6, 8);
    cout << s << endl;
    
    cout << "Test muovi:" << endl;
    s.muovi('n').muovi('e').muovi('e');
    cout << s << endl;
    s.muovi('n').muovi('n'); // cerca di andare fuori schema
    cout << s << endl;
    s.muovi('o').muovi('s'); // cerca di "mangiarsi"
    cout << s << endl;
    s.muovi('e'); // prova a cambiare verso
    cout << s << endl;
    s.muovi('o');
    cout << s << endl;
    
//    cout << "--- SECONDA PARTE ---" << endl;
//    cout << "Test mela:" << endl;
//    s.mela(2,0).mela(3,0); // piazzo due mele
//    cout << s << endl;
//    s.muovi('s').muovi('s').muovi('s'); // mangia le mele
//    cout << s << endl;
//    
//    cout << "Test inverti: " << endl;
//    s.inverti();
//    cout << s << endl;
//    
//    cout << "Test operator--: " << endl;
//    --s; // accorcio il serpente
//    cout << s << endl;
//    
//    cout << "Test distruttore:" << endl;
//    {
//        Snake s1(9, 5);
//        s1.muovi('e').muovi('e').muovi('n');
//    }
//    cout << "(s1 e' stato distrutto)" << endl;
    
    return 0;
}
