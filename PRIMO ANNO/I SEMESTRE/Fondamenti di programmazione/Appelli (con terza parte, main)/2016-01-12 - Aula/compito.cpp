#include "compito.h"

Aula::Aula(int N){
  totalePostazioni = ( N <= 0) ? 1: N;
  v = new char* [totalePostazioni];
  for (int i = 0; i < totalePostazioni; i++)
    v[i] = NULL;
  quanteOccupate = 0;
}

ostream& operator<<(ostream& os, const Aula& p){  
  for(int i = 0; i< p.totalePostazioni; i++){
    if ( p.v[i] != NULL )
      os << "POSTAZIONE" << (i+1) << ":"<<p.v[i]<<endl;
    else
      os << "POSTAZIONE" << (i+1) << ":<libera>"<<endl;
  }
  return os;
}

bool Aula::aggiungi(const char id[]){
  
  if (quanteOccupate == totalePostazioni)
    return false;
    
  for (int i = 0; i < totalePostazioni; i++)
    if ( v[i] != NULL )
      if ( strcmp(v[i], id) == 0 )
        return false;
    
  for (int j = 0; j < totalePostazioni; j++)
    if ( v[j] == NULL ){
      v[j] = new char[strlen(id)+1];
      strcpy(v[j], id);
      quanteOccupate++;
      return true;
    }
}
  
void Aula::elimina(int k){
  k--;
  if ( k < 0 || k >= totalePostazioni )
    return;
    if (v[k] != NULL){
      delete []v[k];
      v[k] = NULL;
      quanteOccupate--;
    }
}



// --- SECONDA PARTE ---
  
Aula::Aula(const Aula& p){
  totalePostazioni = p.totalePostazioni;
  quanteOccupate = p.quanteOccupate;
  v = new char* [totalePostazioni];
  for(int i = 0; i < totalePostazioni; i++) {
    if ( p.v[i] == NULL )
      v[i] = NULL;
    else{
      v[i] = new char[strlen(p.v[i])+1];
      strcpy(v[i], p.v[i]);
    }
  }
}

Aula::~Aula(){
  for(int i = 0; i < totalePostazioni; i++)
    if ( v[i] != NULL )
      delete []v[i];
  delete []v;
}

Aula& Aula::operator!(){
  if ( quanteOccupate == totalePostazioni ){
    for( int i = 0; i < totalePostazioni; i++)
      for( int j = totalePostazioni-1; j > i; j--)
        if ( strcmp(v[j], v[i]) < 0 ){
          char *aux = v[i];
          v[i] = v[j];
          v[j] = aux;
        }      
  }
  return *this;
}
