#include "compito.h"

Pianoforte::Pianoforte(int num_ottave){
   num_tasti = num_ottave*12;
   stato_tasti = new char[num_tasti];
   for(int i = 0; i < num_tasti; i++)
      stato_tasti[i] = '-';
   premuti_s = 0;
   premuti_d = 0;
}

bool Pianoforte::accordo(char mano, int primo_tasto){
   if(mano != 's' && mano != 'd')
      return false;
   if(primo_tasto < 0 || primo_tasto + 10 > num_tasti)
      return false;
   for(int i = primo_tasto; i < primo_tasto+10; i+=2)
      if(stato_tasti[i] != '-')
         return false;
   for(int i = primo_tasto; i < primo_tasto+10; i+=2)
      stato_tasti[i] = mano;
   if(mano == 's')
      premuti_s = 5;
   else
      premuti_d = 5;
   return true;
}

Pianoforte& Pianoforte::operator-=(char mano){
   if(mano != 's' && mano != 'd')
      return *this;
   for(int i = 0; i < num_tasti; i++)
      if(stato_tasti[i] == mano)
         stato_tasti[i] = '-';
   if(mano == 's')
      premuti_s = 0;
   else
      premuti_d = 0;
   return *this;
}

bool Pianoforte::nota(char mano, int tasto){
   if(mano != 's' && mano != 'd')
      return false;
   if(tasto < 0 || tasto >= num_tasti)
      return false;

   if(stato_tasti[tasto] != '-')
      return false;

   // non ci possono essere piu' di 5 tasti premuti con la stessa mano.
   if(mano == 's' && premuti_s == 5)
      return false;
   if(mano == 'd' && premuti_d == 5)
      return false;

   // dal primo all'ultimo tasto premuto con la stessa mano non puo' esserci piu' di un'ottava.
   if((mano == 's' && premuti_s > 0) || (mano == 'd' && premuti_d > 0)){
      int min_premuto = -1;
      int max_premuto = -1;
      for(int i = 0; i < num_tasti; i++){
         if(stato_tasti[i] == mano){
            if(min_premuto == -1)
               min_premuto = i;
            max_premuto = i;
         }
      }
      if(tasto < max_premuto - 12)
         return false;
      if(tasto > min_premuto + 12)
         return false;
   }

   // preme il tasto:
   stato_tasti[tasto] = mano;
   if(mano == 's')
      premuti_s++;
   else
      premuti_d++;
   return true;
}

Pianoforte& Pianoforte::operator-=(int tasto){
   if(tasto < 0 || tasto >= num_tasti)
      return *this;

   if(stato_tasti[tasto] == 'd')
      premuti_d--;
   else if(stato_tasti[tasto] == 's')
      premuti_s--;

   stato_tasti[tasto] = '-';
   return *this;
}

ostream& operator<<(ostream& os, const Pianoforte& p){
   
   for(int i = 0; i < p.num_tasti; i++)
      os << p.stato_tasti[i];
   return os;
}

Pianoforte::~Pianoforte(){
   delete[] stato_tasti;
}
