#include <iostream>
using namespace std;

struct elem{
   char descr[40+1];
   int prio;
   bool fatto;
   elem* pun;
};

class ToDoList{
   elem* p0;
public:
   // PRIMA PARTE:
   ToDoList();
   void aggiungi(const char*, int);
   friend ostream& operator<<(ostream&, const ToDoList&);
   ~ToDoList();
   // SECONDA PARTE:
   ToDoList& operator+=(const ToDoList&);
   void fai(const char*);
   void cancella_fatti();
};
