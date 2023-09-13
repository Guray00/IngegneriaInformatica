#include "compito.h"

// --- PRIMA PARTE ---

// funzione di utilita'
 bool CalcolatricePolacca::estrai(int& opInCima){
    if ( p0 == nullptr )
        return false;        

    opInCima = p0->inf;
    elem* tmp = p0;
    p0 = p0->pun;
    delete tmp;        
    return true;
}

ostream& operator<<(ostream&os, const CalcolatricePolacca&c){	
    cout<<"########"<<endl;
    int h = 1;
    elem* p = c.p0;
    while( p!= nullptr ){
        cout << "Op" << h << ": " << p->inf << endl;
        p = p->pun;
	h++;
    }
    cout<<"########"<<endl;
    os<<endl;
    return os;
}

void CalcolatricePolacca::ins(int operando){
    elem* n = new elem;
    n->inf = operando;
    n->pun = p0;
    p0 = n;
}

void CalcolatricePolacca::moltiplica(){
    int opInCima, opSotto;
    if ( p0 != nullptr && p0->pun != nullptr ){
       estrai(opInCima);
       estrai(opSotto);
       ins(opInCima * opSotto);
    }
}

void CalcolatricePolacca::somma(){
    int opInCima, opSotto;
    if ( p0 != nullptr && p0->pun != nullptr ){
       estrai(opInCima);
       estrai(opSotto);
       ins(opInCima + opSotto);
    }
}




	 
// --- SECONDA PARTE ---

	
// altra funzione di utilita', che viene usata dal distruttore e dall'op. di ass.
void CalcolatricePolacca::dealloca(){
    elem* p = p0;
    while (p != nullptr){
        elem* tmp = p;
        p = p->pun;
        delete tmp;
    }	
}

void CalcolatricePolacca::duplica(){
    if ( p0 != nullptr ){
        elem *n = new elem;
        n->inf = p0->inf;
        n->pun = p0;
        p0 = n;    
    }			
}
	
void CalcolatricePolacca::opposto() {
    int opInCima;
    if (estrai(opInCima))
        ins(-opInCima);
}

	
CalcolatricePolacca& CalcolatricePolacca::operator=(const CalcolatricePolacca&dx){	
    if ( this != &dx ){
        dealloca();
        p0 = nullptr;
        elem* q = dx.p0;
		
        if ( q != nullptr ){
            p0 = new elem;
            p0->inf = q->inf;
            p0->pun = nullptr;
        }
        q = q->pun;
        elem* p = p0;
        while( q != nullptr ){			
            p->pun = new elem;
            p->pun->inf = q->inf;
            p->pun->pun = nullptr;
            q = q->pun;
            p = p->pun;
        }	    
    }
    return *this;
}


void CalcolatricePolacca::rimuoviNegativi(){
    elem* p = p0;
	
    // elimino tutte le occorrenze in testa
    while ( p != nullptr && p->inf < 0 ){
        p0 = p0->pun;
        delete p;
        p = p0;		
    }
	
    // controllo se la lista e' vuota
    if (p == nullptr)
        return;
	
    // se arrivo qui e' perche' c'e' almeno un elemento non negativo
    elem *q;
    while ( p != nullptr ){
        while ( p->pun != nullptr && p->pun->inf < 0 ){
            q = p->pun->pun;			 
            delete p->pun;
            p->pun = q;			 
        }
        p = p->pun;		
    }
}
	




