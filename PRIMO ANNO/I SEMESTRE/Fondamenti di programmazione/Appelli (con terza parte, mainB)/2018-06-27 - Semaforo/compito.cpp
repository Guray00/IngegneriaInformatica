// compito.cpp
#include "compito.h"
#include <cstring>

Semaforo::Semaforo()
{
    // inizializzazione stato semaforo
    st = R;
    
    // inizializzazione testa delle code
    codaDx = codaSx = NULL;
    
    // inizializzazione lunghezza code
    lenDx = lenSx = 0;
}

// funzione di utilita' che restituisce true se l'elemento e' gia' presente nella lista
bool Semaforo::controllaSePresente(elem* l, const char* t)
{
    while (l!=NULL) 
    {
        if (strcmp(l->targa, t) == 0)
            return true; 
        l=l->pun;
    }
    return false;
}

// funzione di utilita' che inserisce un elemento in una lista
void Semaforo::inserisciInCoda(elem*& l, const char* t)
{    
    // creazione elemento
    elem* r = new elem;
    strcpy(r->targa, t);
    r->pun = NULL;
    
    elem* p = l;
    elem* q = p;
    while (p!=NULL)
    {
        q=p;
        p=p->pun;
    }
      
    if (l == NULL)  // ins. in testa
        l = r;
    else            // ins. in fondo
        q->pun = r;
}

// funzione di utilita' che elimina una lista
void Semaforo::eliminaCoda(elem*& l)
{
    while(l!=NULL)
    {
        elem* p = l;
        l = l->pun;
        delete p;
    }
}

void Semaforo::arrivo(const char* t, char dir)
{
    // controlla validita' targa
    if (t == NULL || strlen(t) != MAX_CHAR)
        return;
    
    // controllo validita' direzione
    if (dir != 'D' && dir != 'S')
        return;
       
    // controlla se targa e' gia' presente nelle due code
    if (controllaSePresente(codaDx, t) || controllaSePresente(codaSx, t))
        return;

    // inserimento nella coda corretta
    if (dir == 'D' && st != VD)
    {
        inserisciInCoda(codaDx, t);
        lenDx++;
    }
    else if (dir == 'S' && st != VS)
    {
        inserisciInCoda(codaSx, t);
        lenSx++;
    }   
}

void Semaforo::cambiaStato()
{
    // cambia lo stato del semaforo
    st = (stato)((st + 1) % NUM_STATI);
    
    // se semaforo verde, le auto attraversano l'incrocio
    if (st == VD)
    {
        eliminaCoda(codaDx);
        lenDx = 0;
    }
    else if (st == VS)
    {
        eliminaCoda(codaSx);
        lenSx = 0; 
    }
}

ostream& operator<<(ostream& os, const Semaforo& s)
{
    // stampa stato del semaforo
    os << '<';
    switch(s.st)
    {
        case R:  os << "Rosso"; break;
        case VD: os << "Verde Destra"; break;
        case VS: os << "Verde Sinistra"; break;
    }
    os << '>' << endl;
    
    // stampa auto in coda verso destra
    os << '[';
    elem* p=s.codaDx;
    while (p!=NULL) 
    {
        os << p->targa;
        if (p->pun != NULL)
            os << ',';           
        p=p->pun;
    }
    os << endl;
    
    // stampa auto in coda verso sinistra
    os << '[';
    p=s.codaSx;
    while (p!=NULL) 
    {
        os << p->targa;
        if (p->pun != NULL)
            os << ',';

        p=p->pun;
    }
    os << endl; 
    return os;
}


bool Semaforo::cambiaCorsia(char dir)
{
    bool cambio = false;
    if (dir == 'D' && lenDx > lenSx)
    {
        elem* p = codaDx;
        elem* q;
        for (; p->pun != NULL; p = p->pun)
            q = p;
        
        // rimozione dalla coda precedente
        lenDx--;
        if (p == codaDx)  // un solo elemento in lista
            codaDx = NULL;
        else
            q->pun = NULL;
        
        // inserimento nell'altra coda
        arrivo(p->targa, 'S');          
        delete p;
        
        cambio = true;
    }
    else if (dir == 'S' && lenSx > lenDx)
    {
        elem* p = codaSx;
        elem* q;
        for (; p->pun != NULL; p = p->pun)
            q = p;
        
        // rimozione dalla coda
        lenSx--;
        if (p == codaSx)  // un solo elemento in lista
            codaSx = NULL;
        else
            q->pun = NULL;
        
        // inserimento nell'altra coda
        arrivo(p->targa, 'D');  
        delete p;
        
        cambio = true;
    }
    return cambio;
}

Semaforo::operator int() const
{
    return lenSx + lenDx;
}

Semaforo::~Semaforo()
{
    eliminaCoda(codaDx);
    eliminaCoda(codaSx);    
}
