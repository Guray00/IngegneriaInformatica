#include "compito.h"

// funzione di utilita'


// --- PRIMA PARTE ---
MatQuad::MatQuad(int size){  
  _size = size < 1 ? 3 : size;
  _vett = new int[_size*_size];
  for (int i = 0; i < _size*_size; i++)
    _vett[i] = 0;
}

ostream& operator<<(ostream& os, const MatQuad& s){
  for (int i = 0; i < s._size; i++){
    for (int j = 0; j < s._size; j++)
      os<<s._vett[i*s._size+j]<<' ';
    os<<endl;
  }
  return os;
}    

MatQuad& MatQuad::aggiorna(int *vett, int size){
  int s = ( size < _size*_size ? size : _size*_size );
  for ( int i = 0; i < s; i++ )
    _vett[i] = vett[i];
  return *this;
}

bool MatQuad::trova()const{
  if (_size < 3)
    return false;
  for ( int i = 0; i < _size; i++ )
    for ( int j = 0; j < _size - 2; j++ )
      if ( ( _vett[i*_size + j] == _vett[i*_size + j + 1] ) && ( _vett[i*_size + j] == _vett[i*_size + j + 2] ) )
        return true;
  return false;
}

// --- SECONDA PARTE ---  
MatQuad& MatQuad::raddoppia(){
  int size2 = _size * 2;
  int* vett2 = new int[size2*size2];

  for (int i = 0; i < _size; i++)
    for (int j = 0; j < _size; j++){
      vett2[i*size2 + j] = 8;
      vett2[i*size2 + (j + _size)] = _vett[i*_size + j];
      vett2[(i + _size)*size2 + j] = _vett[i*_size + j];
      vett2[(i+_size)*size2 + (j +_size)] = 9;
    }

  delete[] _vett;
  _vett = vett2;
  _size = size2;
  return *this;
}

MatQuad::~MatQuad(){
  delete[] _vett;
}
