// compito.h
#include <iostream>
using namespace std;

class AlberoDiNatale
{
    int numPiani;
    char** alb;
    
    // funzione di utilità che dealloca l'albero
    void dealloca();
    
    // mascheramento costruttore di copia e op. di assegnamento
    AlberoDiNatale(const AlberoDiNatale& a);
    AlberoDiNatale& operator=(const AlberoDiNatale& a);
    
public:
    
    // --- PRIMA PARTE --- //
    AlberoDiNatale(int n);
    void aggiungiPallina(char c, int p, int r);
    friend ostream& operator<<(ostream& os, const AlberoDiNatale& a);
    
    // --- SECONDA PARTE --- //
    AlberoDiNatale& operator+=(int k);
    char coloreMassimo()const;
    ~AlberoDiNatale() { dealloca(); }
};

