// compito.cpp
#include "compito.h"

AlberoDiNatale::AlberoDiNatale(int n)
{
    // controllo parametri di ingresso
    if (n<=0)
        n = 4;
    
    numPiani = n;
    
    // allocazione memoria per numero piani
    alb = new char*[numPiani];
    for (int p=0; p<numPiani; p++)
    {
        // si alloca memoria per il singolo piano
        alb[p]=new char[numPiani-p];
        
        // inizializzazione dei rami (inizialmente vuoti)
        for (int r=0; r<numPiani-p; r++)
            alb[p][r] = '-';
    }
}

void AlberoDiNatale::aggiungiPallina(char c, int p, int r)
{
    // controllo parametri di ingresso
    if (c!='R' && c!='V' && c!='B')
        return;
    if (p<0 || p>=numPiani)
        return;
    if (r<0 || r>=numPiani-p)
        return;
    
    // controllo se ramo gia' occupato
    if (alb[p][r] != '-')
        return;
        
    // controllo ramo a sinistra, se presente
    if (r>0 && alb[p][r-1] == c)
        return;
    
    // controllo ramo a destra, se presente
    if (r<numPiani-p-1 && alb[p][r+1] == c)
        return;
        
    // aggiungo pallina   
    alb[p][r] = c;
}

ostream& operator<<(ostream& os, const AlberoDiNatale& a)
{
    for (int p=a.numPiani-1; p>=0; p--)
    {
        // stampo spazi bianchi
        for (int i=0; i<p; i++)
            os << ' ';
        // stampo stato dei rami del piano corrente
        for (int r=0; r<a.numPiani-p; r++)
            os << a.alb[p][r] << ' ';
        os << endl;
    }
    
    // stampo tronco dell'albero
    for (int i=0; i<a.numPiani-1; i++)
        os << ' ';
    os << '|' << endl;
    
    return os;
}

// --- SECONDA PARTE --- //
void AlberoDiNatale::dealloca()
{
    // dealloco vecchio albero
    for (int p=0; p<numPiani; p++)
        delete[] alb[p];
    delete[] alb;
}

AlberoDiNatale& AlberoDiNatale::operator+=(int k)
{
    // controllo parametri di ingresso
    if (k <= 0)
        return *this;

    int newNumPiani = numPiani + k;

    // creo un albero di appoggio
    char** temp;
    
    // allocazione memoria per albero di appoggio
    temp = new char*[newNumPiani];
    for (int p=0; p<newNumPiani; p++)
    {
        temp[p] = new char[newNumPiani-p];
        
        // si riempie l'albero di appoggio
        if (p<k)
        {
            // i nuovi piani sono inizialmente vuoti
            for (int r=0; r<newNumPiani-p; r++)
                temp[p][r] = '-';
        }
        else
        {
            // copio i restanti piani dal vecchio albero
            for (int r=0; r<newNumPiani-p; r++)
                temp[p][r] = alb[p-k][r];
        }
    }
    
    // dealloco vecchio albero
    dealloca();
    
    // aggiorno albero
    numPiani = newNumPiani;
    alb = temp;
    
    return *this;
}

char AlberoDiNatale::coloreMassimo()const
{
    unsigned int contaR, contaV, contaB;
    contaR = contaV = contaB = 0;
    
    for (int p=0; p<numPiani; p++)
    {
        for (int r=0; r<numPiani-p; r++)
        {
            switch(alb[p][r])
            {
                case 'R': contaR++; break;
                case 'V': contaV++; break;
                case 'B': contaB++; break;
            }
        }
    }
    
    if (contaR >= contaV)
    {
        if (contaR >= contaB)
            return 'R';
        return 'B';
    }
    if (contaV >= contaB)
        return 'V';
    return 'B';
}

