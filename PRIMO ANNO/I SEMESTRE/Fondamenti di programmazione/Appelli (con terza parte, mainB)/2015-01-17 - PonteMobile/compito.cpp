#include "compito.h"

void PonteMobile::eliminaLista(){
  elem* p = testa;
  while (testa!=NULL) {
      testa = testa->pun;
      delete p;
      p=testa;
  }
}

bool PonteMobile::identificatoreValido(const char *s){
    int lun = strlen(s);
    if (lun > 6)
      return false;
    for(int i = 0; i < lun; i++)
     if ((s[i]<'A')||(s[i]>'Z'))
       return false;
    return true;
}

PonteMobile::PonteMobile(const char* s){
    st = APERTO;
    if (identificatoreValido(s)){
       testa = new elem;
       testa->pun = NULL;
       strcpy(testa->identificatore, s);
    }else
      testa=NULL;
}


void PonteMobile::cambiaStato(){
   switch(st){
    case APERTO: 
      st = CHIUSO;
      eliminaLista();
      break;
    case CHIUSO: 
      st = APERTO;
   }
 }


PonteMobile& PonteMobile::aggiungi(const char* s){
     if ((st == CHIUSO) || (!identificatoreValido(s)))
      return *this;
     elem *p, *q;
     for(q = testa; q!= NULL; q=q->pun) {
       if (!strcmp(q->identificatore, s))
             return *this;
       p=q;
     }    
     elem* r= new elem;
     strcpy(r->identificatore, s);
     r->pun = NULL;
     if (testa==NULL)
       testa = r;
     else 
       p->pun = r;
           
   return *this;
  }


PonteMobile& PonteMobile::operator-=(const char* s){
     elem* q, *prec;
     for(q=testa; q!=NULL && strcmp(q->identificatore, s); q=q->pun)
       prec = q;
     if (q == NULL)
      return *this;
      // eliminazione
     if(q==testa)
        testa = testa->pun;
     else
        prec->pun = q->pun;

     delete q;
   return *this;
}

// (esercizio per casa: provare ad implementare il prossimo operatore
// come funzione membro invece che come funzione globale)
int operator~(const PonteMobile &p){  
  elem* q;
  int conta=0;
  for(q = p.testa; q != NULL; q = q->pun)
  conta++;
  return conta;
}

ostream& operator<<(ostream& os, const PonteMobile& p){  
  switch(p.st) {
    case APERTO: 
      os << "PONTE APERTO";
      elem* q;
      for(q = p.testa; q != NULL; q = q->pun)
        os << "=>" << q->identificatore;
      os<<endl;
      break;
    case CHIUSO: os << "PONTE CHIUSO" << endl;
  }
  return os;
 }


