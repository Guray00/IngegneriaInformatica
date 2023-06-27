#include <iostream>
#include <cstring>

using namespace std;

enum stato{APERTO,CHIUSO};

struct elem {
  char identificatore[7];
  elem* pun;
};
  
class PonteMobile{
  // membri dato
  stato st;
  elem* testa;
  
  // funzioni di utilita'
  void eliminaLista();
  bool identificatoreValido(const char*);
  
  // mascheramento costruttore di copia
  PonteMobile(const PonteMobile&);  

public:
  // PRIMA PARTE
  PonteMobile(const char*);
  friend ostream& operator<<(ostream&, const PonteMobile&);  
  PonteMobile& aggiungi(const char*);
  
  // SECONDA PARTE
  void cambiaStato();
  friend int operator~(const PonteMobile&); // implementazione come operatore globale
  PonteMobile& operator-=(const char*);  
  ~PonteMobile(){eliminaLista();}
};
