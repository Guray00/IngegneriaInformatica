#include "compito.h"

// --- PRIMA PARTE ------------------------------

VettoreCrescente::VettoreCrescente(int d){
  (d < 1) ? dim = 1 : dim = d;
  vett = new int[dim];
  for (int i = 0; i < dim; i++)
    vett[i] = 0;
};

void VettoreCrescente::set(int ind, int val){

  if (ind < 0)
    ind = -ind;

  if (ind >= dim){
    int newDim = ind + 1;
    int *newVett = new int[newDim];
    for (int i = 0; i < dim; i++)
      newVett[i] = vett[i];
    for (int i = dim; i < newDim; i++)
      (i == ind) ? newVett[i] = val : newVett[i] = 0;
    delete[]vett;
    vett = newVett;
    dim = newDim;
  }
  else
    vett[ind] = val;

}

ostream & operator <<(ostream &os, const VettoreCrescente &v){
  os << "< ";
  for (int i = 0; i < v.dim; i++)
    os << v.vett[i] << ' ';
  os << '>' << endl;
  return os;
}


// --- SECONDA PARTE ------------------------------

void VettoreCrescente::azzera(){
  int massimo = vett[0];
  int posi = 0;
  int posf = 0;
  for (int i = 1; i < dim; i++){
    if (vett[i] >= massimo){
      if (vett[i] == massimo)
        posf = i;
      else{
        massimo = vett[i];
        posi = posf = i;
      }
    }
  }
  for (int i = posi + 1; i < posf ; i++)
    vett[i] = 0;
}


VettoreCrescente::operator int()const{
  int n = 0;
  for (int i = 0; i < dim - 2; i++)
  if ((vett[i] > vett[i + 1]) && (vett[i + 1] < vett[i + 2]))
    n++;
  return n;
}


VettoreCrescente& VettoreCrescente::operator =(const VettoreCrescente& vr){
  if (this != &vr){
    if (dim != vr.dim){
      delete[] vett;
      dim = vr.dim;
      vett = new int[dim];
    }
    for (int i = 0; i < dim; i++)
      vett[i] = vr.vett[i];
  }
  return *this;
}
