#include "compito.h"
#include <cstring>
#include <iostream>
using namespace std;

// --- PRIMA PARTE ------------------------------

ToDoList::ToDoList(){
   p0 = NULL;
}

void ToDoList::aggiungi(const char* descr, int prio){
   // gestisco input non valido
   if(descr == NULL || strlen(descr) > 40 || prio < 1)
      return;

   // inserisco in ordine di priorita', e secondariamente in ordine temporale di aggiunta
   elem* p, *q;
   for(p = p0; p != NULL && p->prio <= prio; p = p->pun)
      q = p;
   elem* r = new elem;
   strcpy(r->descr, descr);
   r->prio = prio;
   r->fatto = false;
   r->pun = p;
   if(p == p0)
      p0 = r; // inserisco in testa
   else
      q->pun = r; // inserisco in mezzo o in fondo
}

ostream& operator<<(ostream& os, const ToDoList& tdl){
   elem *p;
   for(p = tdl.p0; p != NULL; p = p->pun){
      if(p->fatto)
         os << "V ";
      else
         os << "  ";
      os << p->prio << " - " << p->descr << endl;
   }
   return os;
}

ToDoList::~ToDoList(){
   elem *p = p0, *q;
   while(p != NULL){
      q = p->pun;
      delete p;
      p = q;
   }
}

// --- SECONDA PARTE ------------------------------

ToDoList& ToDoList::operator+=(const ToDoList& tdl){
   // nel caso A+=A non faccio niente
   if(&tdl == this)
      return *this;

   // inserisco tutti gli elementi della seconda lista
   elem* p;
   for(p = tdl.p0; p != NULL; p = p->pun)
      aggiungi(p->descr, p->prio);

   return *this;
}

void ToDoList::fai(const char* descr){
   // gestisco input non valido
   if(descr == NULL || strlen(descr) > 40)
      return;

   // segno come fatto il primo elemento con quella descrizione
   elem *p;
   for(p = p0; p != NULL; p = p->pun){
      if(strcmp(p->descr, descr) == 0 && !p->fatto){
         p->fatto = true;
         return;
      }
   }
}

void ToDoList::cancella_fatti(){
   elem *p, *q, *r;
   for(p = p0; p != NULL; p = p->pun){
      if(p->fatto){
         if(p == p0){ // estrazione in testa
            r = p0->pun;
            delete p0;
            p0 = r;
         }
         else{ // estrazione in mezzo o in fondo
            r = p->pun;
            delete p;
            q->pun = r;
         }
      }
      q = p;
   }
}
