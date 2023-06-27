#include "compito.h"
#include <cstring>

Log::prio_t Log::char2prio(char prio){
   switch(prio){
      case 'i':
         return INFO;
      case 'w':
         return WARN;
      case 'e':
         return ERRO;
      case 'c':
         return CRIT;
      default:
         return INVALID;
   }
}

bool Log::data_valida(data_t data){
   if (data.anno < 1970 || data.anno > 9999 || data.mese < 1 || data.mese > 12 || data.giorno < 1 || data.giorno > 30)
      return false;
   else
      return true;
}

bool Log::ora_valida(ora_t ora){
   if (ora.ore < 0 || ora.ore > 23 || ora.minuti < 0 || ora.minuti > 59)
      return false;
   else
      return true;
}

void Log::output_su_2_car(ostream& os, int n){
   if (n < 10)
      os << 0 << n;
   else
      os << n;
}

int Log::confronta_data_ora(data_t data_a, ora_t ora_a, data_t data_b, ora_t ora_b){
   if(data_a.anno < data_b.anno)
      return -1;
   if(data_a.anno > data_b.anno)
      return +1;
   // allora gli anni sono uguali
   if(data_a.mese < data_b.mese)
      return -1;
   if(data_a.mese > data_b.mese)
      return +1;
   // allora anche i mesi sono uguali
   if(data_a.giorno < data_b.giorno)
      return -1;
   if(data_a.giorno > data_b.giorno)
      return +1;
   // allora anche i giorni sono uguali
   if(ora_a.ore < ora_b.ore)
      return -1;
   if(ora_a.ore > ora_b.ore)
      return +1;
   // allora anche le ore sono uguali
   if(ora_a.minuti < ora_b.minuti)
      return -1;
   if(ora_a.minuti > ora_b.minuti)
      return +1;
   // allora le date/ore sono uguali
   return 0;
}

// PRIMA PARTE
Log::Log(){
   testa = nullptr;
}

void Log::registra(char prio, data_t data, ora_t ora, const char* msg)
{
   if (char2prio(prio) == INVALID || !data_valida(data) || !ora_valida(ora) || strlen(msg) < 1 || strlen(msg) > max_car)
      return;

   // creazione del nuovo elemento da inserire
   elem* r = new elem;
   r->prio = char2prio(prio);
   r->data = data;
   r->ora = ora;
   strcpy(r->msg, msg);
   r->canc = false;

   // inserimento in ordine di data, o di ora in caso di parità, o di inserimento in caso di parità
   elem* p;
   elem* q;
   for(q = testa; q != nullptr && confronta_data_ora(q->data, q->ora, data, ora) <= 0; q = q->pross)
      p = q;
   if(q == testa)
   {
      // inserimento in testa:
      testa = r;
      r->pross = q;
   }
   else
   {
      // inserimento dopo la testa:
      p->pross = r;
      r->pross = q;
   }
}

void Log::cancella(const char* msg)
{
   elem* q;
   for(q = testa; q != nullptr && (q->canc || strcmp(q->msg, msg) != 0); q = q->pross);
   if(q == nullptr) // evento non presente o gia' cancellato:
      return;
   q->canc = true;
}

ostream& operator<<(ostream& os, const Log& l)
{
   os << "--- LOG ---" << endl;
   for(Log::elem* p = l.testa; p != nullptr; p = p->pross)
   {
      switch(p->prio){
         case Log::INFO:
            os << "INFO,";
            break;
         case Log::WARN:
            os << "WARN,";
            break;
         case Log::ERRO:
            os << "ERRO,";
            break;
         case Log::CRIT:
            os << "CRIT,";
      }
      os << p->data.anno << '-';
      Log::output_su_2_car(os, p->data.mese);
      os << '-';
      Log::output_su_2_car(os, p->data.giorno);
      os << ',';
      Log::output_su_2_car(os, p->ora.ore);
      os << ':';
      Log::output_su_2_car(os, p->ora.minuti);
      os << ',';
      if (p->canc)
         os << "(cancellato)";
      else
         os << p->msg;
      os << endl;
   }
   os << "--- FINE LOG ---" << endl;
   return os;
}

// SECONDA PARTE
Log::~Log()
{
   // partendo dalla testa, eliminazione di tutti gli elementi
   while (testa != nullptr)
   {
      elem* p = testa;
      testa = testa->pross;
      delete p;
   }
}

void Log::cancella(data_t da_data, ora_t da_ora, data_t a_data, ora_t a_ora)
{
   elem* p;
   elem* q;
   // posizionamento di q sul primo evento da cancellare, o su nullptr se tale evento non esiste:
   for(q = testa; q != nullptr; q = q->pross){
      if(confronta_data_ora(q->data, q->ora, da_data, da_ora) >= 0 &&
         confronta_data_ora(q->data, q->ora, a_data, a_ora) <= 0){
         q->canc = true;
      }
   }
}

Log* Log::filtra(char prio) const
{
   prio_t _prio = char2prio(prio);
   if (_prio == INVALID)
      return nullptr;
   Log* ret = new Log;
   elem* p_ret = nullptr;
   elem* q;
   for(q = testa; q != nullptr; q = q->pross){
      if(!q->canc && q->prio == _prio){
         elem* r = new elem;
         // copia membro-a-membro funziona perche' msg e' stringa statica:
         *r = *q;
         r->pross = nullptr;
         if(p_ret == nullptr) // inserimento in testa:
            ret->testa = r;
         else // inserimento dopo la testa:
            p_ret->pross = r;
         p_ret = r;
      }
   }
   return ret;
}

Log* Log::biforca(data_t data, ora_t ora, const Log& l2) const
{
   Log* ret = new Log;
   elem* p_ret = nullptr;
   // copia degli eventi <= data/ora da *this a ret:
   for(elem* p1 = testa; p1 != nullptr && confronta_data_ora(p1->data, p1->ora, data, ora) <= 0; p1 = p1->pross)
   {
      elem* r = new elem;
      *r = *p1;
      r->pross = nullptr;
      if(p_ret == nullptr) // inserimento in testa:
         ret->testa = r;
      else // inserimento dopo la testa:
         p_ret->pross = r;
      p_ret = r;
   }
   // copia degli eventi > fork_year da l2 a ret:
   for(elem* p2 = l2.testa; p2 != nullptr; p2 = p2->pross)
   {
      if(confronta_data_ora(p2->data, p2->ora, data, ora) > 0)
      {
         elem* r = new elem;
         *r = *p2;
         r->pross = nullptr;
         if(p_ret == nullptr) // inserimento in testa:
            ret->testa = r;
         else // inserimento dopo la testa:
            p_ret->pross = r;
         p_ret = r;
      }
   }
   return ret;
}
