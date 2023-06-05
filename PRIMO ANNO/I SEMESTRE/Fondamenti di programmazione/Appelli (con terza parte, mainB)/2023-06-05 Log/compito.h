#include <iostream>
using namespace std;

class Log {
   static const int max_car = 80;
public:
   struct data_t {
      int anno;
      int mese;
      int giorno;
   };
   struct ora_t {
      int ore;
      int minuti;
   };
private:
   enum prio_t { INVALID, INFO, WARN, ERRO, CRIT };
   struct elem {
      prio_t prio;
      data_t data;
      ora_t ora;
      char msg[max_car+1];
      bool canc;
      elem* pross;
   };
   elem* testa;
   // funzioni e operatori di utilita':
   static prio_t char2prio(char);
   static bool prio_valida(char);
   static bool data_valida(data_t);
   static bool ora_valida(ora_t);
   static void output_su_2_car(ostream&, int);
   static int confronta_data_ora(data_t, ora_t, data_t, ora_t);
   // mascheramento costruttore copia e assegnamento:
   Log(const Log&);
   Log& operator=(const Log&);
public:
   Log();
   void registra(char, data_t, ora_t, const char*);
   void cancella(const char*);
   friend ostream& operator<<(ostream&, const Log&);

   // SECONDA PARTE
   ~Log();
   void cancella(data_t, ora_t, data_t, ora_t);
   Log* filtra(char) const;
   Log* biforca(data_t, ora_t, const Log&) const;
};