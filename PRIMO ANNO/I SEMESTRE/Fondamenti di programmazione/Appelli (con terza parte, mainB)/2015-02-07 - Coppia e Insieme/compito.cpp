#include "compito.h"

ostream& operator <<(ostream &os, const Coppia &c){
 os<<'<'<<c._p<<",-"<<c._q<<'>';
 return os;
}

void Coppia::operator-(){
  unsigned long int aux = _p;
  _p = _q;
  _q = aux;
}  

Insieme::Insieme(int d){
    ( d <= 0 ) ? _d = 3: _d = d;
    _vett = new Coppia[_d];
}

ostream& operator <<(ostream &os, const Insieme &i){
  for ( int k = 0; k < i._d; k++ )
     os<<i._vett[k];
  return os;
}

// SECONDA PARTE
Insieme& Insieme::operator=(const Insieme&i2){
  if (this != &i2){
    if (_d != i2._d){
      delete [] _vett;            
      _vett = new Coppia[i2._d];
      _d = i2._d;
    }        
    for (int k = 0; k < _d; k++)
      _vett[k] = i2._vett[k]; // (chiama op. = predefinito di Coppia)
  }
  return *this;
};

Insieme& Insieme::operator-(){
  for (int k=0; k < _d; k++)
    -_vett[k];
  return *this;
}