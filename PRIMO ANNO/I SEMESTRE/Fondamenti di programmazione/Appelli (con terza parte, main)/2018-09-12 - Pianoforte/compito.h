#include <iostream>

using namespace std;

class Pianoforte
{
   int num_tasti;
   int premuti_s;
   int premuti_d;
   char* stato_tasti; // '-' = rilasciato, 's' = premuto con mano sinistra, 'd' = premuto con mano destra
public:
   Pianoforte(int num_ottave);
   bool accordo(char mano, int primo_tasto);
   Pianoforte& operator-=(char mano);
   bool nota(char mano, int tasto);
   Pianoforte& operator-=(int tasto);
   friend ostream& operator<<(ostream&, const Pianoforte&);
   ~Pianoforte();
};
