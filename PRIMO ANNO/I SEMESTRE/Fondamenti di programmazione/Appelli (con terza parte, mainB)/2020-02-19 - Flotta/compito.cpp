#include "compito.h"

// --- PRIMA PARTE ------------------------------

Flotta::Flotta(int n){
   // gestisco input non valido
   n_file = (n<=0)?1:n;

   lun_fila = new int[n_file];

   // non formo nessuna fila
   for(int i = 0; i < n_file; i++)
      lun_fila[i] = -1;
}

void Flotta::forma_fila(int i, int n){
   // gestisco input non valido
   if(i<0 || i >= n_file || n<0 || lun_fila[i] != -1)
      return;

   // formo la fila di aerei
   lun_fila[i] = n;
}

Flotta::operator int()const{
   int larg = 0;
   for(int i = 0; i < n_file; i++){
      if(lun_fila[i] != -1 && larg < lun_fila[i])
         larg = lun_fila[i];
   }
   return larg;
}

ostream& operator<<(ostream& os, const Flotta& f){
   int larg = int(f);
   for(int i = 0; i < f.n_file; i++){
      if(f.lun_fila[i] == -1){
          // fila non formata
          for(int j = 0; j < larg; j++)
             os << '?' << ' ';
      }
      else{
          // fila formata
          for(int j = 0; j < (larg - f.lun_fila[i])/2; j++)
             os << ' ' << ' ';
          if((larg - f.lun_fila[i])%2 == 1)
             os << ' ';
          for(int j = 0; j < f.lun_fila[i]; j++)
             os << 'A' << ' ';
      }
      os << endl;
   }
   return os;
}

Flotta::~Flotta(){
   delete[] lun_fila;
}

// --- SECONDA PARTE ------------------------------

Flotta::Flotta(const Flotta& f){
   n_file = f.n_file;
   lun_fila = new int[n_file];
   for(int i = 0; i < n_file; i++)
      lun_fila[i] = f.lun_fila[i];
}

Flotta operator+(const Flotta& f1, const Flotta& f2){
   Flotta ris(f1.n_file + f2.n_file);

   // aggiungo le file della prima flotta
   for(int i = 0; i < f1.n_file; i++)
      ris.lun_fila[i] = f1.lun_fila[i];

   // aggiungo le file della seconda flotta
   for(int i = 0; i < f2.n_file; i++)
      ris.lun_fila[f1.n_file + i] = f2.lun_fila[i];

   return ris;
}

Flotta& Flotta::operator-=(const Flotta& f){
   // NOTA: le seguente implementazione funziona correttamente anche in caso di aliasing a-=a:

   // se le flotte hanno un diverso numero di file, non faccio nulla
   if(n_file != f.n_file)
      return *this;

   // se una delle due flotte non e' pienamente formata, non faccio nulla
   for(int i = 0; i < n_file; i++){
      if(lun_fila[i] == -1)
         return *this;
      if(f.lun_fila[i] == -1)
         return *this;
   }

   for(int i = 0; i < n_file; i++){
      // se il numero di aerei nella fila e' uguale, distruggo meta' della fila
      if(lun_fila[i] == f.lun_fila[i])
         lun_fila[i] /= 2;

      // se il numero di aerei nella fila e' sfavore, distruggo tutta la fila
      else if(lun_fila[i] < f.lun_fila[i])
         lun_fila[i] = 0;
   }
   return *this;
}

Flotta& Flotta::operator+=(const int v[]){
   for(int i = 0; i <n_file; i++){
      if(lun_fila[i] == -1 || v[i] < 0)
         continue;
      lun_fila[i] += v[i];
   }
   return *this;
}
