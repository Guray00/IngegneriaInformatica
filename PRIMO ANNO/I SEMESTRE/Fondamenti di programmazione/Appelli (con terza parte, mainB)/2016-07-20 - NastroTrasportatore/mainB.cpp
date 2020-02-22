#include "compito.h"

using namespace std;

int main()
{
    // --- PRIMA PARTE --- //
    cout << "--- PRIMA PARTE ---" << endl;
    
    cout << "Test del costruttore" << endl;
    NastroTrasportatore n;
    cout << n << endl;
    
    cout << endl << "Test della aggiungi()" << endl;
    n.aggiungi("F024");
    cout << n << endl;
    
    n.aggiungi("B42");
    cout << n << endl;
    
    n.aggiungi("A1625");
    cout << n << endl;
    
    n.aggiungi("C878");
    cout << n << endl;
    
    cout << endl << "Test della rimuovi()" << endl;
    n.rimuovi();
    cout << n << endl;
    
    cout << endl << "Test del costruttore di copia" << endl;
    NastroTrasportatore n1(n);
    cout << n1 << endl;
    

    // --- SECONDA PARTE --- //
    cout << "--- SECONDA PARTE ---" << endl;
    
    cout << endl << "Test della controlla()" << endl;
    n.controlla(2);
    cout << n << endl;
    
    n.controlla(3);
    cout << n << endl;
    
    cout << endl << "Test di int()" << endl << int(n) << endl;
    {
      NastroTrasportatore n2(n1);
	    cout << endl << "Test del distruttore" << endl;
    }
    cout << "(n2 e' stato distrutto)" << endl;
    
    
    // --- TERZA PARTE --- //
    cout << "--- TERZA PARTE ---" << endl;
    
    // controllo validita' identificatore
    n1.aggiungi("4B");  // fallisce
    cout << n1 << endl;
    
    // controllo accesso fuori dalla lista
    n1.controlla(100);  // fallisce
    cout << n1 << endl;
    
    // caso particolare: controllo primo elemento
    n1.controlla(1);
    cout << n1 << endl;
    
    // controllo attributo const 
    const NastroTrasportatore n3(n1);
    cout << int(n3) << endl;
    
    return 0;
}