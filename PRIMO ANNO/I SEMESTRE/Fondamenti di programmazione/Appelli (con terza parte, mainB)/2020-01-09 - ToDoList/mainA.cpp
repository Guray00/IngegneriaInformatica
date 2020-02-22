#include "compito.h"
#include <iostream>
using namespace std;

int main(){
   // PRIMA PARTE:
   cout << "--- PRIMA PARTE ---" << endl;
   cout << "Test costruttore e funzione aggiungi" << endl;
   ToDoList tdl;
   tdl.aggiungi("Task1", 2);
   tdl.aggiungi("Task2", 2);
   tdl.aggiungi("Task3", 1);
   tdl.aggiungi("Task4", 3);
   tdl.aggiungi("Task5", 2);
   cout << tdl << endl;

   cout << "Test distruttore" << endl;
   {
       ToDoList tdl2;
       tdl2.aggiungi("Task1", 1);
       tdl2.aggiungi("Task2", 2);
       tdl2.aggiungi("Task3", 3);
   }
   cout << "Distruttore chiamato" << endl;
   
   // SECONDA PARTE:
   /*cout << "--- SECONDA PARTE ---" << endl;
   cout << "Test operatore +=" << endl;
   ToDoList tdl3;
   tdl3.aggiungi("Task1", 1);
   tdl3.aggiungi("Task2", 2);
   tdl3.aggiungi("Task3", 3);
   tdl3.aggiungi("Task4", 4);
   tdl += tdl3;
   cout << tdl << endl;
   
   cout << "Test funzione fai" << endl;
   tdl.fai("Task1");
   tdl.fai("Task2");
   tdl.fai("Task2");
   cout << tdl << endl;
   
   cout << "Test funzione cancella_fatti" << endl;
   tdl.cancella_fatti();
   cout << tdl << endl;*/

   return 0;
}