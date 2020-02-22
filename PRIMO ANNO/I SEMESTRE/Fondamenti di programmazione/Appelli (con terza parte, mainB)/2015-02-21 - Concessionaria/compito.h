//compito.h
#include <iostream>
#include <cstring>
using namespace std;

class Concessionaria {
  struct elem {
    char *nome;
    elem *pun;
  };
  elem* _testa;
  int _quante;
  // funzione di utilità	
  bool contiene(const char*, const char*)const;
  // mascheramento costruttore di copia e op. di assegnamento
  Concessionaria(const Concessionaria&);
  Concessionaria& operator=(const Concessionaria&);
public:
  Concessionaria(){ _testa = NULL; _quante = 0;};
  Concessionaria& operator+=(const char*);
  friend ostream& operator << (ostream&,const Concessionaria&);    
  operator int()const {return _quante;};
  // SECONDA PARTE
  Concessionaria& operator -=(int);
  int cerca(const char*)const;
  ~Concessionaria(){ *this-=_quante; };
};
