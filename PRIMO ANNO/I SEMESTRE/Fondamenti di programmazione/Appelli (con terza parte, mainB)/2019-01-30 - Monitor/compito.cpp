#include "compito.h"

Monitor::Monitor(int N)
{
    // se N non e' valido, si crea una coda di tre elementi
    if (N<=0)
        N = 3;
    
    // si aggiunge 1, altrimenti non sarebbe possibile discriminare tra coda vuota e piena
    dim = N+1;
    mntr = new char*[dim];
    back = front = 0; // back == front => monitor vuoto
}

void Monitor::inserisci(const char* msg)
{
    // controlla se stringa e' un puntatore nullo (evita seg. fault)
    if (msg == NULL)
        return;
    
    // controlla la lunghezza del messaggio
    int len = strlen(msg) > MAXLEN? MAXLEN: strlen(msg);
    
    // allocazione della memoria necessaria per il messaggio
    char* mymsg = new char[len+1];
    
    strncpy(mymsg, msg, len); // copia len caratteri in mymsg
    mymsg[len] = '\0';        // aggiunge il carattere di fine stringa
    
    mntr[back] = mymsg;
    back = (back + 1)%dim;
    
    // se la coda era piena, avanzo l'indice di testa
    if (front == back)
        front = (front + 1)%dim;
}

ostream& operator <<(ostream& os, const Monitor& m)
{
    // mostra capienza
    os << "[" << m.dim-1 << "]" << endl;
    
    // visualizza gli elementi della coda a partire dal piu' recente (back)
    int i = m.back;
    while (i != m.front )
    {
        // gestione circolare dell'indice (decremento)
        i = ( (i-1) == -1 ) ? m.dim - 1: (i-1);
        os << m.mntr[i] << endl;
    }
    return os;
}

Monitor operator+(const Monitor& m1, const Monitor& m2)
{
    // crea un nuovo monitor
    Monitor m(m1.dim + m2.dim - 2);
    m.front = m.back = 0;
    
    // copia tutti gli elementi di m1, partendo dal piu' vecchio
    int i = m1.front;
    while (i != m1.back)
    {
        m.inserisci(m1.mntr[i]);
        i = (i+1) % m1.dim;
    }
    
    // concatena tutti gli elementi di m2, partendo dal piu' vecchio
    i = m2.front;
    while (i != m2.back)
    {
        m.inserisci(m2.mntr[i]);
        i = (i+1) % m2.dim;
    }
    
    return m;
}




Monitor::Monitor(const Monitor& m)
{
    dim = m.dim;
    mntr = new char*[dim];
    front = back = m.front;
    
    // inserisci tutti gli elementi di m nel nuovo Monitor
    int i = front;
    while (i != m.back)
    {
        inserisci(m.mntr[i]);
        i = (i+1) % dim;
    }
}

Monitor::~Monitor()
{
    // dealloca le singole stringhe
    int i = front;
    while (i != back)
    {
        delete[] mntr[i];
        i = (i+1) % dim;
    }
    
    // dealloca l'array
    delete [] mntr;
}


