#include "compito.h"
#include <cstring>

GestoreApp::GestoreApp(){
   testa = NULL;
}

GestoreApp& GestoreApp::operator+=(const char* nome){
   elem* curr;
   for(curr = testa; curr != NULL; curr = curr->pun){
      if(strcmp(curr->nome, nome) == 0)
         return *this;
   }
   elem* app = new elem;
   strcpy(app->nome, nome);
   app->pun = testa;
   testa = app;
   return *this;
}

GestoreApp& GestoreApp::operator-=(const char* nome){
   elem* curr;
   elem* prev = NULL;
   for(curr = testa; curr != NULL; curr = curr->pun){
      if(strcmp(curr->nome, nome) == 0)
         break;
      prev = curr;
   }
   if(curr == NULL)
      return *this;
   
   if(curr == testa)
      testa = testa->pun;
   else
      prev->pun = curr->pun;
      
   delete curr;
   return *this;
}

bool GestoreApp::foreground(const char* nome){
   elem* curr;
   elem* prev = NULL;
   for(curr = testa; curr != NULL; curr = curr->pun){
      if(strcmp(curr->nome, nome) == 0)
         break;
      prev = curr;
   }
   if(curr == NULL)
      return false;
   
   if(curr == testa)
      return true;

   prev->pun = curr->pun;
   curr->pun = testa;
   testa = curr;
   return true;
}
   
ostream& operator<<(ostream& os, const GestoreApp& g){
   if(g.testa == NULL){
      os << "[]";
      return os;
   }
   
   os << '[' << g.testa->nome << ']';
   
   const elem* curr;
   for(curr = g.testa->pun; curr != NULL; curr = curr->pun){
      os << ", " << curr->nome;
   }
   return os;
}

void GestoreApp::chiudi_tutte(){
   elem* curr = testa;
   elem* next;
   while(curr != NULL){
      next = curr->pun;
      delete curr;
      curr = next;
   }
   testa = NULL;
}

GestoreApp::~GestoreApp(){
   chiudi_tutte();
}

