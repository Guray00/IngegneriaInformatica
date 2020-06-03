#include "compito.h"

Smistacasse::Smistacasse(int N) {

  ( N < 1 ) ? _N = 4: _N = N;
  _casse = new elem*[_N];
  _stato = new stato[_N];
  for (int i = 0; i < _N; i++) {
    _casse[i] = NULL;
    _stato[i] = APERTA;
  }

}

int Smistacasse::trovaCassa(){
  
    int min=-1;
    int cassaTrovata; 
    
    // trova la prima cassa non CHIUSA per inizializzare min e cassaTrovata
    for(int i = 0; i < _N; i++) 
    { 
       if ( _stato[i] == APERTA )
       {
	   int totArticoli = 0;
	   elem *p = _casse[i];
	   while (p!= NULL) {
	       totArticoli += p->articoli;
	       p = p->pun;
	   }
	   min = totArticoli;
           cassaTrovata = i;  
	   break;
       }
    }
    if ( min < 0 )
       return min;
    
    for(int i = 0; i < _N; i++) 
    { 
        if ( _stato[i] == CHIUSA )   // escludi casse bloccate
	  continue;
        
	// conta totale articoli in questa cassa
	int totArticoli = 0;
	elem *p = _casse[i];
	while (p!= NULL) {
	    totArticoli += p->articoli;
	    p = p->pun;
	}
	      
        if (totArticoli < min) {
	   // trovata una cassa migliore
	   min = totArticoli;
	   cassaTrovata = i;
	}
    }

    return (cassaTrovata + 1);
}

void Smistacasse::aggiungi(int id, int articoli){
  
  if (id == 0 || articoli <= 0)
    return;
  
  int numCassa = trovaCassa();

  if ( numCassa < 0 )
     return;

  if (_stato[numCassa-1] == CHIUSA)
    return;
  
  elem* r = new elem;
  r->id = id;
  r->articoli = articoli;
  r->pun = NULL;
  
  elem* p = _casse[numCassa-1];
  elem* q = NULL;

  while (p!=NULL) {
      q = p;
      p = p->pun;
  }
  
  if (q==NULL)     // caso lista vuota
      _casse[numCassa-1] = r;
  else 
      q->pun = r;
}

void Smistacasse::servi(int numCassa){
  
  if ( numCassa <= 0 || numCassa > _N )
    return;
  
  elem *p = _casse[ numCassa-1 ];
  elem *q;
  if (p!=NULL) {
      q = p;
      _casse[ numCassa-1 ] = p->pun;  // aggiorna la testa
      delete q;
  }  
}

	
ostream& operator<<(ostream& os, const Smistacasse& s){  
    for( int i = 0; i < s._N; i++ ){
	os <<i+1<<": ";
	if ( s._stato[i]==CHIUSA ) {
	    os <<"<chiusa>"<<endl;
	}
        else {
	    if (s._casse[i]==NULL)
		os <<"<vuota>"<<endl;
	    else {		  
	        elem* q;
		for( q = s._casse[i]; q != NULL; q = q->pun){
		    os << "(ID=" << q->id << ", ARTICOLI=" << q->articoli << ")";
		}
		os << "."<<endl;
	     }
        }
    }
    return os;
}

// --- SECONDA PARTE ---

Smistacasse& Smistacasse::operator-=(int n){  
  
  if (n <= 0 || n > _N)
      return *this;
    
  // blocca la cassa
  _stato[n-1] = CHIUSA;
  
  // ri-distribuisci clienti
  elem* p = _casse[n-1];
  elem* r;
  while( p != NULL ){
    r = p;
    aggiungi(r->id, r->articoli);
    p = p->pun;
    delete r;
  }
  _casse[n-1] = NULL;
  
  return *this;
}


Smistacasse::~Smistacasse(){
   elem* r;
   elem* p;
   for(int i = 0; i < _N; i++){
	p = _casse[i];
	while( p != NULL ){
	   r = p;
	   p = p->pun;
	   delete r;
	}
   }
   delete[] _casse;
   delete[] _stato;
}

