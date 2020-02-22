#include "compito.h"
// --- PRIMA PARTE ---
void Molecola::aggiungi(const char *s, int n){
  if (n <= 0 || strlen(s) == 0 || strlen(s) > 2)
    return;
  if (testa == NULL){
    testa = new elem;
    strcpy(testa->at.sigla, s);
    testa->at.quanti = n;
    testa->pun = NULL;
  }
  else{
    elem* p = testa;
    while (p != NULL){
      if (strcmp(p->at.sigla, s) == 0){
        p->at.quanti += n;
        return;
      }
      p = p->pun;
    }
    //atomo non presente nella Molecola: inserisco in testa
    p = testa;
    testa = new elem;
    strcpy(testa->at.sigla, s);
    testa->at.quanti = n;
    testa->pun = p;
  }
}

ostream& operator<<(ostream& os, const Molecola& f){
  Molecola::elem* p = f.testa;
  os << '<';
  while (p != NULL){
    os << p->at.sigla << p->at.quanti;
    if (p->pun != NULL)
      os << '-';
    p = p->pun;
  }
  os << '>' << endl;
  return os;
}

bool Molecola::elimina(const char *s){
  if (testa != NULL){
    elem* p = testa;
    elem* q = p;
    while (q != NULL && strcmp(q->at.sigla, s) != 0){
      p = q;
      q = q->pun;
    }
    if (q != NULL){ //trovato elemento da eliminare
      if (q == testa) testa = testa->pun; //eliminazione in testa
      else p->pun = q->pun;
      delete q;
      return true;
    }
  }
  return false;
}

// --- SECONDA PARTE ---
// funzione di utilità
void Molecola::dealloca(){
  while (testa != NULL){
    elem* p = testa;
    testa = testa->pun;
    delete p;
  }
}

Molecola& Molecola::operator=(const Molecola& m1){
  if (this != &m1){
    dealloca();
    if (m1.testa == NULL) testa = NULL;
    else{
      testa = new elem;
      testa->at = m1.testa->at;
      elem* p = testa;
      elem* q = m1.testa->pun;
      while (q != NULL){
        p->pun = new elem;
        p = p->pun;
        p->at = q->at;
        q = q->pun;
      }
      p->pun = NULL;
    }
  }
  return *this;
}

Molecola& Molecola::operator+=(const Molecola& m1){
  elem* p = m1.testa;
  while (p != NULL){
    aggiungi(p->at.sigla, p->at.quanti);
    p = p->pun;
  }
  return *this;
}

