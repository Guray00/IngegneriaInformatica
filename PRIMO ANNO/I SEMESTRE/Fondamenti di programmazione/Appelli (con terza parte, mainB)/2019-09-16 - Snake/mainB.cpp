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

    cout << "--- SECONDA PARTE ---" << endl;
    cout << "Test mela:" << endl;
    s.mela(2,0).mela(3,0); // piazzo due mele
    cout << s << endl;
    s.muovi('s').muovi('s').muovi('s'); // mangia le mele
    cout << s << endl;
 
    cout << "Test inverti: " << endl;
    s.inverti();
    cout << s << endl;

    cout << "Test operator--: " << endl;
    --s; // accorcio il serpente
    cout << s << endl;

    cout << "Test distruttore:" << endl;
    {
        Snake s1(9, 5);
        s1.muovi('e').muovi('e').muovi('n');
    }
    cout << "(s1 e' stato distrutto)" << endl;
    
    cout << endl << "--- TERZA PARTE ---" << endl;
   
    // test parametri non validi
    s.muovi('x');
    s.mela(6, 1).mela(1, 9).mela(-1, 3);   // mele fuori da schema
    s.mela(2, 0); // mela in casella occupata da serpente
    s.mela(4, 0);
    s.mela(4, 0); // mela in casella occupata da altra mela
    cout << s << endl;
    
    // cerco di far crescere il serpente fino a 10 caselle
    s.inverti();
    s.mela(5, 0).mela(5, 1).mela(5, 2).mela(5, 3);
    cout << s << endl;
    s.muovi('s').muovi('s').muovi('s').muovi('e').muovi('e').muovi('e');
    cout << s << endl;
    
    // cerco di accorciare il serpente fino a 3 caselle
    --s; --s; --s; --s; --s; --s;
    cout << s << endl;
    
    return 0;
}
