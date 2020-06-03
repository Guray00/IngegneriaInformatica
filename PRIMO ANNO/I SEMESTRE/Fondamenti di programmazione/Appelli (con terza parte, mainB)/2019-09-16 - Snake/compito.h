#include <iostream>
using namespace std;

class Snake{
    int* schema;    // 0 = vuota, 1-9 = corpo del serpente, -1 = mela
    int righe;      // numero righe dello schema
    int col;        // numero colonne dello schema
    
    int testa_i;    // mantiene l'indice di riga della testa
    int testa_j;    // mantiene l'indice di colonna della testa
    int lungh;      // mantiene lunghezza del serpente
    char direzione; // mentiene direzione del serpente

public:
    Snake(int, int);
    friend ostream& operator<<(ostream&, const Snake&);
    Snake& muovi(char);
    Snake& mela(int, int);
    void inverti();
    Snake& operator--();
    ~Snake();
};
