// compito.cpp
#include "compito.h"
using namespace std;

int main()
{
    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test del costruttore:" << endl;
    Semaforo s;
    cout << s << endl;
    
    cout << "Test della arrivo:" << endl;
    s.arrivo("AB123CD", 'D');
    s.arrivo("BE456MH", 'S');
    s.arrivo("CT789ZF", 'D');
    s.arrivo("AB123CD", 'S');   // fallisce
    s.arrivo("DG934TR", 'C');   // fallisce
    s.arrivo("FV826XYZ", 'D');  // fallisce
    cout << s << endl;
    
    cout << "Test della cambiaStato:" << endl;
    s.cambiaStato();  // diventa verde a destra
    cout << s << endl;
    
    cout << "Ulteriori test di arrivo e cambiaStato:" << endl;
    s.arrivo("AK371BN",'D');   
    s.cambiaStato();           
    s.arrivo("BL452MT",'D');   
    cout << s << endl;
    
    s.cambiaStato();           
    s.arrivo("AR271SD",'S');
    s.arrivo("BV175TR",'D');
    cout << s << endl;
    
    // --- SECONDA PARTE --- //
    cout << "--- SECONDA PARTE ---" << endl;
    cout << "Test della cambiaCorsia:" << endl;
    cout << s.cambiaCorsia('D') << endl;
    cout << s.cambiaCorsia('D') << endl;  // fallisce
    cout << s << endl;
    
    cout << "Test di operator int:" << endl;
    cout << "Sono presenti " << int(s) << " auto in coda" << endl << endl;
    
    cout << "Test del distruttore:" << endl;
    {
        Semaforo s1;
        s1.arrivo("CY379PN", 'D');
        s1.arrivo("FB478KG", 'D');
        s1.arrivo("AV170MN", 'S');
        cout << s1 << endl;
    }
    cout << "(s1 e' stato distrutto)" << endl;

    // --- TERZA PARTE --- //
    cout << endl << "--- TERZA PARTE ---" << endl;
    
    s.cambiaStato();
    cout << s << endl;
    
    cout << "Test aggiuntivi della arrivo:" << endl;
    s.arrivo(NULL, 'D');
    s.arrivo("FV826X", 'D');  // fallisce (targa troppo corta)
    cout << s << endl;
    
    cout << "Test aggiuntivi della cambiaCorsia:" << endl;
    s.cambiaCorsia('C');    // fallisce (direzione non valida)
    s.cambiaCorsia('D');    // fallisce (coda destra vuota)
    s.cambiaCorsia('S');
    cout << s << endl;
    
    s.cambiaCorsia('S');    // eliminazione in testa
    cout << s << endl;
        
    {
        cout << "Test aggiuntivi di operator int:" << endl;
        const Semaforo s2; 
        cout << "Sono presenti " << int(s2) << " auto in coda " << endl << endl;   // test attributo const per operator int
        
        // chiamata distruttore su code vuote
    }   
    
    cout << "(s2 e' stato distrutto)" << endl << endl;
    
    cout << "Test aggiuntivi della cambiaStato:" << endl;
    Semaforo s3;
    s3.cambiaStato();    // test cambiaStato su code vuote
    s3.cambiaStato();
    cout << s3 << endl;
    
    return 0;
}
