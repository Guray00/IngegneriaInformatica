#include "compito.h"
#include <cstring>

Timeline::Timeline()
{
    testa = NULL;
}

void Timeline::pubblica(const char* str, int ev)
{
    if (str == NULL || strlen(str) < 1)
        return;
    
    // creazione del nuovo elemento da inserire
    elem* r = new elem;
    r->nome = new char[strlen(str)+1];
    strcpy(r->nome, str);

    // se in evidenza, inserimento in testa
    if (ev)
    {
        r->ev = 1;
        r->pun = testa;
        testa = r;
    }
    else
    {
        // altrimenti, inserimento dopo gli elementi in evidenza
        r->ev = 0;
        
        // si scorrono tutti gli elementi in evidenza, se esistono
        elem* p = testa;
        elem* q = p;
        while (p!=NULL && p->ev)
        {
            q = p;
            p = p->pun;
        }
        
        // se non ci sono elementi in evidenza, gestione inserimento in testa
        if (p==testa)
        {
            r->pun = testa;
            testa = r;
        }
        else // altrimenti inserimento come primo elemento dopo quelli in evidenza
        {
            r->pun = p;
            q->pun = r;
        }
    }
}

void Timeline::cancella(const char* str)
{
    if (str == NULL || strlen(str) < 1)
        return;
    
    // scorrimento della lista fino a che non si trova l'elemento, se esiste
    elem* p = testa;
    elem* q = p;
    while (p!=NULL)
    {
        if (strcmp(p->nome,str) == 0)
        {
            // elemento trovato, cancella
            if (p == testa)  // caso eliminazione in testa
                testa = testa->pun;
            else             // caso eliminazione in mezzo
                q->pun = p->pun;
            
            // deallocazione della memoria dinamica
            delete[] p->nome;
            delete p;
            break;
        }
        else
        {
            q = p;
            p = p->pun;
        }
    }
}

ostream& operator<<(ostream& os, const Timeline& tl)
{
    os << "-----" << endl;
    
    // scorrimento della lista e stampa di ogni singolo elemento
    elem* p = tl.testa;
    while (p!=NULL)
    {
        if (p->ev) // se elemento in evidenza, stampa dell'asterisco
            os << "(*)";
        os << p->nome << endl;
        p = p->pun;
    }
    os << "-----" << endl;
    return os;
}

int Timeline::operator!()
{
    int ret = 0;
    
    // partendo dalla testa, eliminazione di tutti gli elementi 
    // fino a che non si incontra un elemento non in evidenza
    while (testa != NULL && testa->ev)
    {
        elem* p = testa;
        testa = testa->pun;
        delete[] p->nome;
        delete p;
        ret = 1;
    }
    return ret;
}

void Timeline::mettiInEvidenza(const char* str)
{
    if (str == NULL || strlen(str) < 1)
        return;
    
    // scorrimento della lista fino a che non si trova l'elemento, se esiste
    elem* p = testa;
    elem* q = p;
    while (p != NULL)
    {
        if (strcmp(p->nome, str) == 0)
        {
            if (p->ev) // se gia' in evidenza, non si deve far niente
                return;
            
            // se e' gia' il primo della lista, basta impostare ev=1
            if (p == testa)
            {
                p->ev = 1;
                return;
            }
            
            // creazione di una copia dell'elemento 
            elem* r = new elem;
            r->nome = new char[strlen(p->nome)+1];
            strcpy(r->nome, p->nome);
            r->ev = 1;
            
            // inserimento in testa
            r->pun = testa;
            testa = r;
            
            // eliminazione vecchia copia dell'elemento
            q->pun = p->pun;
            delete[] p->nome;
            delete p;
        }
        else
        {
            q = p;
            p = p->pun;
        }
    }
}

Timeline::~Timeline()
{
    // partendo dalla testa, eliminazione di tutti gli elementi 
    while (testa != NULL)
    {
        elem* p = testa;
        testa = testa->pun;
        delete[] p->nome;
        delete p;
    }
}
