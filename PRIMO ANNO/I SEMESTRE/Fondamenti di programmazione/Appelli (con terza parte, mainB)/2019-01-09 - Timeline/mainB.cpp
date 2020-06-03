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
    
    
    // SECONDA PARTE
    cout << "--- SECONDA PARTE ---" << endl;
    cout << "Test della mettiInEvidenza:" << endl;
    tl.mettiInEvidenza("famiglia.jpg");
    tl.mettiInEvidenza("paesaggio.png");  // non presente
    tl.mettiInEvidenza("montagna.png");
    cout << tl << endl;

    cout << "Test di operator!:" << endl;
    cout << !tl << endl;
    cout << tl << endl;
    
    cout << "Test del distruttore:" << endl;
    {
        Timeline tl1;
        tl1.pubblica("sport.png", 0);
        tl1.pubblica("vacanza.jpg", 1);
        tl1.pubblica("ufficio.png", 0);
    }
    cout << "(tl1 distrutto)" << endl;
    
    // TERZA PARTE
    cout << endl << "--- TERZA PARTE ---" << endl;
    
    // test inserimento dopo cancellazione
    cout << "Test aggiuntivi della pubblica:" << endl; 
    tl.cancella("cane.jpg");
    tl.pubblica("cucciolo.jpg", 0);
    cout << tl << endl;
    
    // test stringa vuota e nulla
    tl.pubblica("", 0);
    tl.pubblica(NULL, 0);
    cout << tl << endl;
    
    Timeline tl2;
    
    // test cancellazione su lista vuota
    cout << "Test aggiuntivi della cancella:" << endl; 
    tl2.cancella("sole.png");
    cout << tl2 << endl;
    
    // test inserimento in evidenza su lista vuota
    cout << "Altri test aggiuntivi della pubblica:" << endl; 
    tl2.pubblica("sole.png", 1);   
    tl2.pubblica("sole.png", 0);
    tl2.pubblica("luna.png", 0);
    cout << tl2 << endl;
    
    // test mettiInEvidenza su elemento gia' in evidenza
    cout << "Test aggiuntivi della mettiInEvidenza:" << endl; 
    tl2.mettiInEvidenza("sole.png");
    cout << tl2 << endl;
    
    // test operator! su lista senza elementi in evidenza
    cout << "Test aggiuntivi di operator!:" << endl; 
    tl2.cancella("sole.png");
    cout << !tl2 << endl;
    cout << tl2 << endl;
    
    // test distruttore su lista vuota
    cout << "Test aggiuntivi del distruttore:" << endl; 
    {
        Timeline tl3;
        cout << tl3 << endl;
    }
    cout << "(tl3 distrutto)" << endl;
    
    return 0;
}
