//
// Created by alex on 01/07/2020.
//

#include "compito.h"

Occorrenze::Occorrenze(const char* frase) {
    if(frase == NULL) exit(1); //check input (si può inizializzare vuota)

    p0 = NULL; //lista inizialmente vuota

    int len = strlen(frase); //lunghezza della frase
    char c[MAX_CHAR+1]; //variabile di appoggio per la copia della parola
    int j = 0; //lunghezza della parola singola
    bool trovato = false; //variabile di check di esistenza della parola

    //puntatori di appoggio per ciclo lista
    parola* p;
    parola* q;
    parola* r; //parola da creare
    for(int i = 0; i < len; i++) //ciclo tutta la frase
    {
        if((i != 0 && frase[i] == ' ' && frase[i-1] != ' ') || i == len-1) //se trovo una parola o sono nell'ultima itrazione
        {
            if(i == len-1) //se sono nell'ultima iterazione
            {
                if(frase[i] == ' ') break;
                c[j] = frase[i]; //copio l'ultimo carattere
                j++; //incremento la lunghezza
            }

            //check lunghezza parola
            if(j >= MAX_CHAR){ //se la parola trovata è di caratteri maggiori di quelli previsti
                j = 0; //resetto la lunghezza della stringa
                c[0] = '\0'; //resetto la stringa stessa
                continue; //vado avanti
                //quindi ignoro la parola e vado avanti
            }

            c[j] = '\0'; //metto carattere di fine stringa

            q = p0; //prendo la testa della lista
            while(q != NULL) //scandisco la lista per trovare una occorrenza
            {
                if(strcmp(q->c, c) == 0) //se trovo l'occorrenza
                {
                    q->o++; //incremento
                    trovato = true; //segno che l'ho trovata
                }
                q = q->next; //vado al prossimo
            }

            if(!trovato) { //se non ho trovato la parola nella lista
                r = new parola; //la alloco
                strcpy(r->c, c); //la copio
                r->o = 1;

                for(q = p0; q != NULL && strcmp(q->c, c) < 0; q = q->next) p = q; //ciclo alfabeticamente

                r->next = q; //punta all'elemento dopo di lei

                if(q == p0) p0 = r; //se è il primo elemento la testa punta a lei
                else p->next = r; //altrimenti l'elemento prima punta a lei
            }
            else trovato = false; //cambio variabile per l'iterazione successiva

            j = 0; //resetto lunghezza stringa
            c[0] = '\0'; //resetto la stringa stessa
        }
        else { //altrimenti sono dentro una parola, quindi
            if(frase[i] == ' ') continue;
            c[j] = frase[i]; //copio il carattere nella stringa di appoggio
            j++; //aumento la lunghezza della stringa
        }
    }
}

ostream& operator<<(ostream& os, const Occorrenze& o) {
    parola* p = o.p0; //prendo la testa
    while(p != NULL) //scandisco la lista fino alla fine
    {
        os << p->c << ":" << p->o << endl; //stampo parola con occorrenza
        p = p->next; //vado al prossimo
    }
    return os;
}

int Occorrenze::operator%(int val)const {
    if(val <= 0) return -1; //check input

    parola* q = p0; //prendo la testa
    int count = 0; //dichiaro e inizializzo a zero variabile contatore

    while(q != NULL) //ciclo la lista completa
    {
        if(q->o >= val) //quando l'occorrenza è almeno val
        {
            count++; //incremento il contatore
        }
        q = q->next; //vado al prossimo
    }
    return count;
}

Occorrenze& Occorrenze::operator+=(const char* p) {
    if(p == NULL) return *this; //check input

    int len = strlen(p); //lunghezza della parola
    if(len >= MAX_CHAR) return *this; //check input

    //puntatori di appoggio
    parola* r;
    parola* q = p0;
    parola* z; //parola da creare

    while(q != NULL) //ciclo l'intera lista
    {
        if(strcmp(q->c, p) == 0) //se trovo l'occorrenza
        {
            q->o++; //incremento
            return *this;
        }
        q = q->next; //vado al prossimo
    }

    //se arrivo a questo punto devo inserire la nuova parola
    r = new parola; //alloco nuova parola
    r->o = 1;

    strcpy(r->c, p); //copio i caratteri
    r->c[len] = '\0';
    for(q = p0; q != NULL && strcmp(q->c, p) < 0; q = q->next) z = q; //ciclo alfabeticamente

    r->next = q; //punta all'elemento dopo di lei

    if(q == p0) p0 = r; //se è il primo elemento la testa punta a lei
    else z->next = r; //altrimenti l'elemento prima punta a lei

    return *this;
}

Occorrenze::~Occorrenze() {
    while(p0 != NULL) //ciclo fino alla fine della lista
    {
        parola* p = p0;
        p0 = p0->next; //vado al prossimo
        delete p; //dealloco la parola intera
    }
}

int Occorrenze::operator[](const char* p)const {
    if(p == NULL || strlen(p) < 1 || strlen(p) >= MAX_CHAR) return -1; //check input

    parola* q = p0; //prendo la testa della lista
    while(q != NULL) //scandisco l'intera lista
    {
        if(strcmp(q->c, p) == 0) //se trovo l'occorrenza
        {
            return q->o; //ritorno le occorrenze
        }
        q = q->next; //vado al prossimo
    }

    return 0;
}

Occorrenze& Occorrenze::operator-=(const char C) {
    if(p0 == NULL || C == '\0') return *this; //check input

    if(C >= 'A' && C <= 'Z') { //check carattere

        //variabili di appoggio per la rimozione
        parola* p = NULL;
        parola* q;

        while (true) { //ciclo l'intera lista finché non trovo occorrenze
            for (q = p0; q != NULL && q->c[0] != C; q = q->next) p = q; //scandisco la lista fino a trovarlo

            if (q == NULL || q->c[0] != C) return *this; //se non trovo occorrenze esco

            if (q == p0) p0 = q->next; //se è il primo elemento la testa punta a lei
            else p->next = q->next; //altrimenti l'elemento prima punta a lei

            delete q; //dealloco q

            //se a questo punto non sono uscito ricliclo la lista per trovare occorrenze di q->c[0] == C
        }
    }
}

// fine file