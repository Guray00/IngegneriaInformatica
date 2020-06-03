#include "compito.h"
#include <cstring>

/*
 * Funzioni di utilità
 */

void ProntoSoccorso::inserisci(Lista& testa, const char* nome)
{
    if (testa == NULL)
    {
        testa = new elem;
        strcpy(testa->nome,nome);
        testa->pun = NULL;
    }
    else
        inserisci(testa->pun, nome);
}

int ProntoSoccorso::estrai(Lista& testa, char* nome)
{
    if ( testa != NULL )
    {
        Lista p = testa;
        testa = testa->pun;
        strcpy(nome,p->nome);
        delete p;
        
        return 1;
    }
    else
        return 0;
}

void ProntoSoccorso::copia(Lista src, Lista& dst)
{
    if (src == NULL)
        dst = NULL;
    else
    {
        // si copia testa della lista
        dst = new elem;
        strcpy(dst->nome, src->nome);
        dst->pun = NULL;

        // si copia il resto della lista
        Lista p = src->pun;
        Lista q = dst;
        while (p != NULL)
        {
            q->pun = new elem;
            q = q->pun;
            strcpy(q->nome, p->nome);
            q->pun = NULL;
            p = p->pun;
        }
    }
}

void ProntoSoccorso::distruggi(Lista& testa)
{
    if (testa != NULL)
    {
        distruggi( testa->pun );
        delete testa;
        testa = NULL;
    }
}

/*
 * Operazioni su Pronto Soccorso
 */

ProntoSoccorso::ProntoSoccorso()
{
    p[0] = p[1] = p[2] = p[3] = NULL;
    numPazienti = 0;
}

void ProntoSoccorso::ricovero(const char* nome, Priorita liv)
{
    if (nome == NULL)
        return;
    if (strlen(nome) < 1 || strlen(nome) > MAXCHAR)
        return;
    
    // si inserisce il paziente nella lista corrispondente al livello di priorita'
    inserisci(p[liv], nome);
    numPazienti++;
}

int ProntoSoccorso::prossimo(char* nome)
{
    if (nome == NULL)
        return 0;
    
    // si scorrono le liste in ordine di priorita'
    for (int i = 0; i < 4; i++)
    {
        if (p[i] != NULL)
        {
            numPazienti--;
            return estrai(p[i], nome);
        }
    }
    return 0;
}


ostream& operator<<(ostream& os, const ProntoSoccorso& ps)
{
    os << "Numero pazienti: " << ps.numPazienti << endl;
    
    Lista testa;
    for (int i = 0; i < 4; i++)
    {
        os << "[CODICE ";
        switch(i)
        {
            case 0: os << "ROSSO"; break;
            case 1: os << "GIALLO"; break;
            case 2: os << "VERDE"; break;
            case 3: os << "BIANCO";
        }
        os << "]" << endl;
                
        // scorro la lista corrispondente a questo livello
        testa = ps.p[i];
        while ( testa != NULL )
        {
            os << "->" << testa->nome << endl;
            testa = testa->pun;
        }
    }
    return os;
}


ProntoSoccorso::ProntoSoccorso(const ProntoSoccorso& src)
{
    numPazienti = src.numPazienti;
    for (int i = 0; i < 4; i++ )
        copia(src.p[i], p[i]);
}

ProntoSoccorso& ProntoSoccorso::operator=(const ProntoSoccorso& src)
{
    if (this != &src)
    {
        numPazienti = src.numPazienti;
        for (int i = 0; i < 4; i++)
        {
            distruggi(p[i]);
            copia(src.p[i], p[i]);
        } 
    }
    return *this;
}

ProntoSoccorso::~ProntoSoccorso()
{
    for (int i = 0; i < 4; i++)
        distruggi(p[i]);
}
