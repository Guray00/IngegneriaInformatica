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
    
/*
    // --- SECONDA PARTE --- //
    cout << endl << "--- SECONDA PARTE ---" << endl;
    
    cout << "Test della controlla()" << endl;
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
*/    
    return 0;
}