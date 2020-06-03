#include "compito.h"

// ---PRIMA PARTE---

void Mappa::aggiungi(Colore c, double x, double y) {
	if (x >= 0 && y >= 0) {
		elem * q = testa;
		while (q != NULL && (q->x != x || q->y != y)) {
			q = q->pun;
		}
		if (q == NULL) {
			q = new elem;
			q->col = c;
			q->x = x;
			q->y = y;
			q->pun = testa;
			testa = q;
		}
	}
}


void Mappa::elimina(double x, double y) {
	if (x >= 0 && y >= 0) {
		elem * q = testa;
		elem * p = NULL;
		while (q != NULL && (q->x != x || q->y != y)) {
			p = q;
			q = q->pun;
		}

		if (q != NULL) { // q punta elelemnto da eliminare
			if (q == testa)
				testa = testa->pun;
			else
				p->pun = q->pun;
			delete q;
		}
	}
}


ostream& operator<<(ostream& os, const Mappa& m) {
	int quanti[3] = { 0, 0, 0 };  // quanti[col] numero di elelmenti di colore col
	elem* q = m.testa;
	while (q != NULL) {
		quanti[q->col]++;
		q = q->pun;
	}

	os << "Numero di segnali: " << quanti[0] + quanti[1] + quanti[2] << endl;
	for (int i = 0; i < 3; i++)
		if (quanti[i] != 0) {
			os << '[' << quanti[i] << "] ";
			switch (i) {
			case 0: os << "ROSSO" << endl;
				break;
			case 1: os << "VERDE" << endl;
				break;
			case 2: os << "GIALLO" << endl;
			}
		}
	return os;
}

// ---SECONDA PARTE---

void Mappa::riduci(int k) {
	elem * q;
	while (testa != NULL && k > 0) {
		q = testa;
		testa = testa->pun;
		delete q;
		k--;
	}
}

Mappa::Mappa(const Mappa& m){
        testa = NULL;
        if (m.testa != NULL) {
                testa = new elem;
                testa->col = m.testa->col;
                testa->x = m.testa->x;
                testa->y = m.testa->y;
                
                elem* q = m.testa->pun;
                elem* p = testa;
                while(q!=NULL){
                 p->pun = new elem;
                 p = p->pun;
                 p->col = q->col;
                 p->x = q->x;
                 p->y = q->y;
                 q = q->pun;                
                 }    
                p->pun = NULL;
        }
}


Mappa::~Mappa(){
    elem* p = testa;
    while(p!=NULL){
        testa = testa->pun;
        delete p;
        p = testa;
    }
} 

                    


 

