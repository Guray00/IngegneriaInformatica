#include "compito.h"
#include <cstring>

Barriera::Barriera() {
    for (int i=0; i<MAX_CASELLI; i++) {
        coda[i] = NULL;
        lun[i] = ( i < 3 ) ? 0 : -1;
    }
}

void Barriera::nuovoVeicolo(const char* s) {
   
    // controllo validita'  ingresso
    if (strlen(s) != MAX_CHAR)
        return;
	
    for (int i = 0; i < MAX_CHAR; i++) {
        if ( (s[i] < 'A' || s[i] > 'Z') )
		   return;
	}
    
    // trova coda piu' corta
	int i = 0;
	while (i < MAX_CASELLI && lun[i] == -1)
		i++;
		
	if (i >= MAX_CASELLI)
		return;

    int min = lun[i];
    int indice_min = i;
    for (int j=i+1; j < MAX_CASELLI; j++) {
        if (lun[j] != -1) { // se non è chiusa        
            indice_min = (lun[j] < min)? j : indice_min;
            min = (lun[j] < min)? lun[j] : min;
        }
    }

    // inserimento in fondo
    Veicolo* r = new Veicolo;
    strcpy(r->targa, s);
    r->pun = NULL;

    // scorro la lista fino in fondo
    Veicolo *p, *q;
    for (p=coda[indice_min]; p!=NULL; p=p->pun)
        q=p;
    
    if (coda[indice_min]==NULL)  // caso lista vuota
        coda[indice_min] = r;
    else
        q->pun = r;
    
    lun[indice_min]++;
}

bool Barriera::serviVeicolo(int i) {
    i--;
    if (i>=0 && i< MAX_CASELLI) 
        if (lun[i]>0) {
            Veicolo *p = coda[i];
            coda[i] = coda[i]->pun;
            delete p;
            lun[i]--;
            return true;       
        }             
    return false;
}


ostream& operator<<(ostream& os, const Barriera& b) {
    for (unsigned int i=0; i<MAX_CASELLI; i++) {
        os << '[' << i+1 << "] ";
        if (b.lun[i] == -1)
            os << "(chiuso)";
        else if (b.lun[i] == 0)
            os << "(libero)";
        else {
            Veicolo *p;
            for (p=b.coda[i]; p!=NULL; p=p->pun) {
                os << p->targa;
                if (p->pun != NULL)
                    os << "=>";
            }
        }
        os << endl;
    }
    return os;
}

double Barriera::calcolaMedia() {
    int numAperti = 0;
    int sommaVeicoli = 0;
    for (int i=0; i<MAX_CASELLI; i++) {
        if (lun[i] != -1) {
            sommaVeicoli += lun[i];
            numAperti++;
        }
    }
    return (double)sommaVeicoli/numAperti;
}

int Barriera::apriOppureChiudi(double mediaIdeale) {
    if ( mediaIdeale < 0 )
        return 0;
    int ret = 0;
    double media = calcolaMedia();
    if ( media < mediaIdeale ) {
        // cerca il  casello da chiudere a partire dall'inizio (se ne esiste uno aperto e senza auto in coda)
        int i = 0;
        while( i < MAX_CASELLI && lun[i] != 0 )
            i++;
            
        if (i < MAX_CASELLI) {
            lun[i] = -1;  // chiudi casello i
            ret = -1;
        }
    }else if ( media > mediaIdeale ) {
            // cerca un casello da aprire a partire dalla fine, se non sono gia' tutti aperti
            int i = MAX_CASELLI-1;
            while ( i >= 0 && lun[i] != -1)
                i--;
            
            if ( i >= 0 ) {
                lun[i] = 0;  // apre il casello
                ret = 1;
            }
        }    
    return ret;
}



Barriera::operator int() const {
    int somma = 0;
    for (int i=0; i<MAX_CASELLI; i++) {
        if (lun[i] != -1)
            somma += lun[i];
    }
    return somma;
}

Barriera::~Barriera() {
    Veicolo* p;
    for (int i=0; i<MAX_CASELLI; i++) {
        while(coda[i]!=NULL) {
            p = coda[i];
            coda[i]=coda[i]->pun;
            delete p; 
        }
    }
}
