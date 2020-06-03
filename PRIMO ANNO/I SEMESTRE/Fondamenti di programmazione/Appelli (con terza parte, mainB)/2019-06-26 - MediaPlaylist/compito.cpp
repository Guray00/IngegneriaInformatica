#include "compito.h"

const char* msg[] = {"Audio", "Video"};

// Operazioni di utilità

void MediaPlaylist::inserisciInTesta(const char* tit, Tipo tip)
{
    if (tit == NULL)
        return;
    
    int len = strlen(tit);
    
    // gestire il caso in cui la stringa e' piu' lunga della massima dimensione
    int i;
    char str[TITLEN+1];
    for (i = 0; (i < TITLEN) && (i < len); i++)
        str[i] = tit[i];
    str[i] = '\0';
    
    // controllo se (tit, tip) è già presente
    elem* p = head;
    while (p!=NULL)
    {
        if ((p->info.tipo == tip) && strcmp(p->info.titolo, str) == 0)
            return; // (tit, tip) è già presente
        p = p->next;
    }

    // (tit, tip) non è già presente e perciò lo inserisco
    p = new elem;
    p->info.tipo = tip;
    strcpy(p->info.titolo, str);
    p->next = head;
    head = p;
}

// Costruttori e distruttore

MediaPlaylist::MediaPlaylist() 
{ 
    head = NULL; 
}
    
// Costruisce una MediaPlaylist a partire dal vettore vett[n] di item
MediaPlaylist::MediaPlaylist(item* vett, int n)
{
    head = NULL;
    // si scorre il vettore dal fondo e si inserisce in testa alla lista
    for (int i = n - 1; i >= 0; i--)
        inserisciInTesta(vett[i].titolo, vett[i].tipo);  // l'elemento vett[i] viene inserito in testa
}

// costruttore di copia
MediaPlaylist::MediaPlaylist(const MediaPlaylist& pl)
{
    elem *p, *q, *r;

    head = NULL;

    if (pl.head == NULL) return; // r-value è vuoto

    // inserisco il primo elemento
    p = new elem;
    p->info = pl.head->info;
    p->next = head;
    head = p;
    
    // inserisco tutti gli altri, se ci sono
    // q punta alla sotto-lista src, r a quella dst
    q = pl.head->next;
    r = head;

    while( q != NULL)
    {
        p = new elem;
        p->info = q->info;
        p->next = r->next;
        r->next = p;
        r = r->next;
        q = q->next;
    }
}

MediaPlaylist::~MediaPlaylist()
{
    elem* p;
    // distruggo il contenuto di questa MediaPlaylist (l-value)
    while (head != NULL)
    {
        p = head;
        head = head->next;
        delete p;
    }
}

// Membri operazione

// inserisce un item di titolo tit e di tipo tip nella MediaPlaylist
// Se la MediaPlaylist contiene già un item (tit, tip), l'operazione non fa niente
void MediaPlaylist::inserisci(const char* tit, Tipo tip)
{
    // invoca funzione di utilita'
    inserisciInTesta(tit, tip);
}

// Rimuove dalla MediaPlaylist l'item (tit, tip). Se la MediaPlaylist non contiene tale item
// l'operazione non fa niente
void MediaPlaylist::elimina (const char* tit, Tipo tip)
{
    if (head == NULL) return; // la MediaPlaylist è vuota;

    elem* p = head;

    // l'elemento da rimuovere è in testa alla MediaPlaylist
    if ((p->info.tipo == tip) && strcmp(p->info.titolo, tit) == 0) {
        head = p->next;
        delete p;
        return;
    }

    // l'elemento da rimuovere è successivo al primo
    elem* q = p;
    p = p->next;
    while (p!=NULL)
    {
        if ((p->info.tipo == tip) && strcmp(p->info.titolo, tit) == 0) {
            q->next = p->next;
            delete p;
            return;
        }
        q = p;
        p = p->next;
    }
}

int MediaPlaylist::riproduci (const char* tit, Tipo& tip) const {
    if (head == NULL) 
        return 0; // la MediaPlaylist è vuota;
        
    elem* p = head;
    while (p!=NULL)
    {
        if (strcmp(p->info.titolo, tit) == 0) {
            tip = p->info.tipo;
            return 1;
        }
        p = p->next;
    }
    return 0;
}


// Operatori sovrapposti

// Operatore di uscita <<
ostream& operator<<(ostream& os, const MediaPlaylist& pl)
{
    if ( pl.head == NULL )
        os << "[-]" << endl;
    else
    {
        elem *p = pl.head;
        int cnt = 1;
        while ( p != NULL )
        {
            os << '['<< cnt << ']'; 
            os << '<' << p->info.titolo << ", " << msg[p->info.tipo] << '>' << endl;
            cnt++;
            p = p->next;
        }
    }
    return os;
}