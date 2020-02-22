#include <iostream>
#include "compito.h"

using namespace std;

int main()
{
    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test del costruttore:" << endl;
    Timeline tl;
    cout << tl << endl;
    
    cout << "Test della pubblica:" << endl;
    tl.pubblica("gatto.png", 0);
    tl.pubblica("famiglia.jpg", 0);
    tl.pubblica("mare.jpg", 1);
    tl.pubblica("cane.png", 0);
    tl.pubblica("montagna.png", 1);
    tl.pubblica("gatto.png", 0);
    cout << tl << endl;
    
    cout << "Test della cancella:" << endl;
    tl.cancella("mare.jpg");
    tl.cancella("gatto.png");
    tl.cancella("sole.png");   // non presente
    cout << tl << endl;
    
    
//     // SECONDA PARTE
//     cout << "--- SECONDA PARTE ---" << endl;
//     cout << "Test della mettiInEvidenza:" << endl;
//     tl.mettiInEvidenza("famiglia.jpg");
//     tl.mettiInEvidenza("paesaggio.png");  // non presente
//     tl.mettiInEvidenza("montagna.png");
//     cout << tl << endl;
// 
//     cout << "Test di operator!:" << endl;
//     cout << !tl << endl;
//     cout << tl << endl;
//     
//     cout << "Test del distruttore:" << endl;
//     {
//         Timeline tl1;
//         tl1.pubblica("sport.png", 0);
//         tl1.pubblica("vacanza.jpg", 1);
//         tl1.pubblica("ufficio.png", 0);
//     }
//     cout << "(tl1 distrutto)" << endl;
    
    return 0;
}
