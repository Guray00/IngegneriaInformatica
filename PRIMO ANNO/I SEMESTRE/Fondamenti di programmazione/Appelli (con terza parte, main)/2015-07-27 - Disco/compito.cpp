#include "compito.h"

int Disco::_quantiDischi = 0; // inizializzazione della variabile statica 'quantiDischi'

// --- PRIMA PARTE ---
Disco::Disco(int set){
  if ( set <= 0 )
    set = 10;
  _quantiSettori = set;  
  _vett = new unsigned int[_quantiSettori];
  for (int i = 0; i < _quantiSettori; i++)
    _vett[i] = 0;
  _quantiFile = 0;
  _quantiLiberi = _quantiSettori;
  Disco::_quantiDischi++;
}

int Disco::riserva(int dim)
{
   int quantiNecessari = (dim / SIZE); // calcolo il numero di settori necessari
  if (quantiNecessari*SIZE < dim)
    quantiNecessari++;

  if (quantiNecessari > _quantiLiberi) // non ci sono settori sufficienti da riservare al file
    return 0;
  
  _quantiLiberi -= quantiNecessari;
  _quantiFile++;
  for (int i = 0, k=0; i < _quantiSettori && k < quantiNecessari; i++)
    if (_vett[i] == 0){
      _vett[i] = _quantiFile;
      k++;
    }
    return _quantiFile;
}

Disco& Disco::cancella(int id)
{
  for (int i = 0; i < _quantiSettori; i++)
  if (_vett[i] == id){
    _vett[i] = 0;
    _quantiLiberi++;
  }
  return *this;
}

ostream& operator<<(ostream& os, const Disco&d){
  for (int i = 0; i < d._quantiSettori; i++)
    os << d._vett[i];
  os << endl;
  return os;
}


// --- SECONDA PARTE ---
void Disco::deframmenta(){ // bubble sort  
  
  for (int i = 0; i < _quantiSettori - 1; i++){
    bool flag = true;  
    for (int j = _quantiSettori - 1; j > i; j--){
      if ( _vett[j - 1] < _vett[j] ){
        flag = false;
        int aux = _vett[j];
        _vett[j] = _vett[j - 1];
        _vett[j-1] = aux;
      }      
    }    
    if (flag)      
      break;    
  }
}

Disco& Disco::operator!(){
  for (int i = 0; i < _quantiSettori; i++)
    _vett[i] = 0;  
  _quantiFile = 0;
  _quantiLiberi = _quantiSettori;
  return *this;
}
