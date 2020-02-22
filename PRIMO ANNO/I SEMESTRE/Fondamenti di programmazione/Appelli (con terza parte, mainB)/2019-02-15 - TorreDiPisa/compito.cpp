#include "compito.h"

using namespace std;

// Costruttore di copia privato, da appoggio all'operatore di post-incremento
TorreDiPisa::TorreDiPisa(const TorreDiPisa& t2) {
   // crea una torre con lo stesso numero di loggiati
   max_loggiati = t2.max_loggiati;
   pendenze = new int[max_loggiati];
   loggiati = t2.loggiati;
   
   // copia le pendenze dei loggiati
   for(int i = 0; i < loggiati; i++)
      pendenze[i] = t2.pendenze[i];
}

TorreDiPisa::TorreDiPisa(int n) {
   if(n < 1)   // sanitizza l'input
       n = 1; 
   
   // crea una torre senza loggiati
   max_loggiati = n;
   pendenze = new int[max_loggiati];
   loggiati = 0;
}

TorreDiPisa& TorreDiPisa::operator+=(int pen){
   if(pen < 0) 
       return *this;
   
   // non superare il massimale dei loggiati
   if(loggiati == max_loggiati) 
       return *this;
   
   // non superare il limite di pendenza relativa, e non avere pendenza relativa negativa
   if(loggiati == 0 && pen > 4) 
       return *this;
   
   if(loggiati > 0 && (pen < pendenze[loggiati-1] || pen > pendenze[loggiati-1] + 4)) 
       return *this;
   
   // costruisci un nuovo loggiato
   pendenze[loggiati] = pen;
   loggiati++;
}

ostream& operator<<(ostream& os, const TorreDiPisa& t) {
   // disegna la sommita', che ha la stessa pendenza dell'ultimo loggiato
   if(t.loggiati > 0) {
      for(int j = 0; j < t.pendenze[t.loggiati-1]; j++)
         os << ' ';
   }
   for(int j = 0; j < 8; j++)
      os << '=';
   os << endl;
   
   // disegna i loggiati
   for(int i = t.loggiati-1; i >= 0; i--){
      for(int j = 0; j < t.pendenze[i]; j++)
         os << ' ';
      for(int j = 0; j < 8; j++)
         os << '|';
      os << endl;
   }
   
   // disegna la base
   for(int j = 0; j < 8; j++)
      os << '=';
   os << endl;
   
   return os;
}

TorreDiPisa::operator int()const {
   if(loggiati == 0) 
       return 0;
   
   // somma tutte le pendenze (assolute)
   int somma_pen = pendenze[0];
   for(int i = 1; i < loggiati; i++)
      somma_pen += pendenze[i];
   
   // restituisci la pendenza media
   return somma_pen / loggiati;
}

TorreDiPisa TorreDiPisa::operator++(int) {
   if(loggiati == 0) 
       return *this;
   
   // non superare il limite di pendenza relativa
   if(pendenze[0] == 4) 
       return *this;
   for(int i = 1; i < loggiati; i++){
      if(pendenze[i] == pendenze[i-1] + 4)
         return *this;
   }
   
   // salva una copia della torre prima dell'incremento, per restituirla
   TorreDiPisa ret(*this);
   
   // incrementa le pendenze relative di tutti i loggiati
   for(int i = 0; i < loggiati; i++)
      pendenze[i] += (i+1);
   
   return ret;
}

void TorreDiPisa::stabilizza() {
   if(loggiati == 0) 
       return;
   
   // calcola la pendenza relativa massima
   int max_pen = pendenze[0];
   for(int i = 1; i < loggiati; i++) {
      if(pendenze[i] - pendenze[i-1] > max_pen)
         max_pen = pendenze[i] - pendenze[i-1];
   }
   int riduz_pen = 0;
   // riduci (eventualmente) le pendenze relative dei loggiati
   if(pendenze[0] == max_pen){
      // riduci la pendenza relativa del primo loggiato
      riduz_pen++;
      pendenze[0]--;
   }
   for(int i = 1; i < loggiati; i++){
      // mantieni invariata la pendenza relativa del loggiato
      pendenze[i] -= riduz_pen;
      if(pendenze[i] - pendenze[i-1] == max_pen) {
         // riduci la pendenza relativa del loggiato
         riduz_pen++;
         pendenze[i]--;
      }
   }
}

TorreDiPisa::~TorreDiPisa(){
   delete[] pendenze;
}
