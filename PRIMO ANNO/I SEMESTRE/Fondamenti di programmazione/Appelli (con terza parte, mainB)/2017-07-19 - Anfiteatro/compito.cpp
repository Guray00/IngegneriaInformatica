#include "compito.h"

// funzione di utilita'
void Anfiteatro::elimina(){    
    elemento* p=testa;
    while(testa!=0){   
	   testa=p->succ;
       delete p;
       p=testa;
    }
}

// --- PRIMA PARTE ---
Anfiteatro::Anfiteatro(int n){
   if (n < 0) 
	   n=0;
   testa = 0;
   elemento* q;
   for (int i=0; i<n; i++){  
       q = new elemento;
       q->numMatt = 0;
	   q->succ = testa;
       testa = q;
   }
}

bool Anfiteatro::aggiungiMattonelle(int k) {
	if (k < 0)
		k = 0;
	elemento* pmin = testa;
	if (testa == 0)
		return false;
	for (elemento* p = testa; p != 0; p = p->succ)
		if ( p->numMatt < pmin->numMatt )
			pmin = p;
	pmin->numMatt += k;
	return true;
}

void Anfiteatro::aggiungiColonna(int k) {
	if (k <0)
		k = 0;
	elemento *p, *q;
	for (p = testa; p != 0; p = p->succ)
		q = p;
	p = new elemento;
	p->succ = 0;
	p->numMatt = k;
	if (testa == 0)
		testa = p;
	else
		q->succ = p;
}


ostream& operator<<(ostream& os, const Anfiteatro& a){   
    os<<'<';
    for (Anfiteatro::elemento* p=a.testa; p!=0;p=p->succ){   
		os<<'['<<p->numMatt<<']';
        if (p->succ!=0)
           os<<',';
    }
    os<<'>';     
    return os;
}


// --- SECONDA PARTE ---


bool Anfiteatro::togliColonna(int n) {
	elemento* p, *q;
	int cont = 1;
	if (n <= 0)
		return false;

	for (p = testa; p != 0 && cont<n; p = p->succ) {
		q = p;
		cont++;
	}
	if (p == 0)
		return false;
	if (p == testa)
		testa = p->succ;
	else
		q->succ = p->succ;
	delete p;
	return true;
}

Anfiteatro& Anfiteatro::operator=(const Anfiteatro& a){    
    if ( this != &a){  
		elimina();
        testa=0;
        elemento *q;
        for (elemento* p=a.testa; p!=0;p=p->succ){   
			elemento* r=new elemento;
            r->numMatt = p->numMatt;
            r->succ=0;
            if (testa==0)
               testa=r;
            else
               q->succ=r;
            q=r;
        }
    }
	return *this;
}




 
