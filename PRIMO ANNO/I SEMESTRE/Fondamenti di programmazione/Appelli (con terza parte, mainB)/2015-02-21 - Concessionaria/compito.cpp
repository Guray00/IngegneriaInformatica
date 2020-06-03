// compito.cpp
#include "compito.h"

Concessionaria& Concessionaria::operator+= (const char* nome){
  if ( strlen(nome) ){
  _quante++;
  elem *p, *q, *r;    
  for (p=_testa; p!=NULL && (strcmp(p->nome,nome)<=0); p=p->pun)
    q=p;
  r = new elem;
  r->nome = new char[strlen(nome)+1];
  strcpy(r->nome,nome);
  r->pun = p;
  if ( p == _testa )
    _testa = r;
  else
    q->pun = r;
  }
  return *this;
}

ostream& operator << (ostream& os,const Concessionaria& s){
  os<<s._quante<<':';
  for (Concessionaria::elem* p=s._testa; p!=NULL; p=p->pun)
    os<<"=>"<<p->nome;        
  return os;
}


// SECONDA PARTE
bool Concessionaria::contiene(const char *str, const char *substr)const{
  int len = strlen(substr);
  for (int k = 0; k <= strlen(str)-len; k++)
    if ( !strncmp(&str[k],substr,len) )
      return true;
  return false;
}

int Concessionaria::cerca(const char* substr)const{
  if (strlen(substr)){
    int aux = 0;
    for (elem* p =_testa; p != NULL; p=p->pun)
      if (contiene(p->nome, substr))
	aux++;
        return aux;
  }else
  return 0;
}

Concessionaria& Concessionaria::operator-= (int k){
  int j = 0;
  while ( j < k ){
    if (_testa == NULL)
      break;
    elem *p = _testa;
    _testa = _testa->pun;
    delete []p->nome;
    delete p;
    _quante--;
    j++;
  }
  return *this;
}

/* // A FINI DIDATTICI SI MOSTR ANCHE IL COSTRUTTORE DI COPIA

Concessionaria::Concessionaria (const Concessionaria& c){
  _testa = NULL;
  _quante = c._quante;
  elem *p = c._testa;
  if ( p != NULL){
    _testa = new elem;
    _testa->nome = new char[strlen(c._testa->nome)+1];
    strcpy(_testa->nome,c._testa->nome);
    elem *q = _testa;
    p = p->pun;
    while ( p != NULL){
      q->pun = new elem;
      q = q->pun;
      q->nome = new char [strlen(p->nome)+1];			
      strcpy(q->nome,p->nome);			
      p = p->pun;
    }
    q->pun = NULL;
  }
}
*/
