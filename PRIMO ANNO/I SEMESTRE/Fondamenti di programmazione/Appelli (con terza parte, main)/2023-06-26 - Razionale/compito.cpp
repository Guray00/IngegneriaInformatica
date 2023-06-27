#include "compito.h"

void Razionale::sempl() {
   if(num == 0){
      den = 1;
      return;
   }
   // calcola il massimo comun divisore tra numeratore e denominatore
   int a = num>0?num:-num;
   int b = den;
   while(a != b){
      if (a > b) a -= b;
      else b -= a;
   }
   int mcd = a;

   num /= mcd;
   den /= mcd;
}

Razionale::Razionale() : num(0), den(1) {}

Razionale::Razionale(int n, int d) {
   if (d == 0) exit(1);
   if (d < 0){
      // denominatore dev'essere positivo
      n = -n;
      d = -d;
   }
   num = n;
   den = d;
   sempl();
}

ostream& operator<<(ostream& os, const Razionale& a){
   if (a.num == 0)
      os << 0;
   else if (a.den == 1)
      os << a.num;
   else
      os << a.num << "/" << a.den;
   return os;
}

Razionale Razionale::operator+(const Razionale& b) const {
   int numr = num * b.den + b.num * den;
   int denr = den * b.den;
   Razionale r(numr, denr);
   r.sempl();
   return r;
}

Razionale Razionale::operator-(const Razionale& b) const {
   int numr = num * b.den - b.num * den;
   int denr = den * b.den;
   Razionale r(numr, denr);
   r.sempl();
   return r;
}

Razionale Razionale::operator-() const {
   return Razionale(-num, den);
}

Razionale Razionale::operator*(const Razionale& b) const {
   int numr = num * b.num;
   int denr = den * b.den;
   Razionale r(numr, denr);
   r.sempl();
   return r;
}

Razionale Razionale::operator/(const Razionale& b) const {
   if (b.num == 0) exit(1);
   int numr = num * b.den;
   int denr = den * b.num;
   if (denr < 0){
      // denominatore dev'essere positivo
      numr = -numr;
      denr = -denr;
   }
   Razionale r(numr, denr);
   r.sempl();
   return r;
}

bool Razionale::operator<(const Razionale& b) const {
   // funziona perche' ho imposto denominatori sempre positivi
   return num * b.den < den * b.num;
}

void ordina(Razionale* v, int n){
   if (n <= 0) return;
   for (int i = 0; i < n-1; i++){
      int i_max = 0;
      for (int j = 1; j < n-i; j++) {
         if (v[i_max] < v[j]) i_max = j;
      }
      Razionale a = v[i_max];
      v[i_max] = v[n-1-i];
      v[n-1-i] = a;
   }
}

Razionale max_occhio(const Razionale* v, int n){
   if (n <= 0) exit(1);
   Razionale max = v[0];
   for (int i = 1; i < n; i++){
      if(max.num <= 0 && v[i].num > 0)
         max = v[i];
      if (max.num > 0 && v[i].num > 0 && max.den > v[i].den)
         max = v[i];
      if (max.num > 0 && v[i].num > 0 && max.den == v[i].den && max.num < v[i].num)
         max = v[i];
   }
   return max;
}

void div_int(const Razionale& a, const Razionale& b, Razionale& q, Razionale& r) {
   if (b.num == 0) exit(1);
   q.num = (a.num*b.den) / (a.den*b.num);
   q.den = 1;
   r.num = a.num*b.den - q.num*a.den*b.num;
   r.den = a.den*b.den;
   r.sempl();
}