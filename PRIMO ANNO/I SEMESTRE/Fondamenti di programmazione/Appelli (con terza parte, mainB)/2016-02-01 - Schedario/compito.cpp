#include "compito.h"

// funzione di utilita'
void Schedario::svuota(elem*&p){  
  while( p != NULL ){
    elem*r = p;
    p = p->pun;
    delete r;
  }
}

// --- PRIMA PARTE ---
Schedario::Schedario(){
  for (int i = 0; i < DIM; i++)
    p0[i] = NULL;
}

ostream& operator<<(ostream& os, const Schedario& p){  
  for(int i = 0; i < DIM; i++){
    elem* q;
    os << 'L'<<i+1<<'(';
    for( q = p.p0[i]; q != NULL; q = q->pun)
      if (q->pun != NULL)
        os << q->info<<',';
      else
        os << q->info<<')';
    if ( q == p.p0[i] )
      os << ')';
  }
  return os;
}

void Schedario::aggiungi(int liv, int tip){
  if ( liv >= 1 && liv <= DIM ) {
    elem* r = new elem;
    r->info = tip;
    r->pun = p0[liv-1];
    p0[liv-1] = r;
    }
}
  
Schedario& Schedario::operator-=(int liv){
  if ( liv >= 1 && liv <= DIM )
    svuota(p0[liv-1]);
  return *this;
}


// --- SECONDA PARTE ---  
void Schedario::promuovi(int liv, int tip){
  if ( liv < 1 || liv > 2 )
    return;
               
  elem* q = p0[liv-1];
  elem* prec; 
  while (q!= NULL) {
    if (q->info == tip) {
      if(q == p0[liv-1]) { // elemento in testa di p0[liv-1]
         p0[liv-1] = p0[liv-1]->pun;                       
         //  sposto elem puntato da q in testa nella lista p0[liv]
         q->pun = p0[liv];
         p0[liv] = q;
         // aggiorno q in  p0[liv-1]
         q = p0[liv-1];                 
      }
      else{ // elemento in  mezzo/fondo di p0[liv-1]
        prec->pun = q->pun ; 
        //  sposto elem puntato da q in testa nella lista p0[liv]
        q->pun = p0[liv];
        p0[liv] = q;
        // aggiorno q in  p0[liv-1]
        q = prec->pun;
      }                 
    }
    // scorro la lista  p0[liv-1]  
    else {
      prec = q;
      q = q->pun;             
    }
  }// fine while
}

Schedario::~Schedario(){
  for (int i = 0; i < DIM; i++)
    svuota(p0[i]);
}
