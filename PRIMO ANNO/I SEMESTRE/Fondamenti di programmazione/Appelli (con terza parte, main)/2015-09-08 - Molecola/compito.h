#include <iostream>
#include <cstring>
using namespace std;

class Molecola{
private:
  struct atomo{
    char sigla[3];
    int quanti;
  };
  struct elem{
    atomo at;
    elem* pun;
  };
  elem* testa;

  // mascheramento costruttore di copia
  Molecola(const Molecola&);

  // funzione di utilità
  void dealloca();
public:
  // --- PRIMA PARTE ---
  Molecola(){ testa = NULL; };  
  void aggiungi(const char*, int);
  friend ostream& operator<<(ostream& os, const Molecola&);
  bool elimina(const char*);
  // --- SECONDA PARTE ---  
  Molecola& operator+=(const Molecola&);
  Molecola& operator=(const Molecola&);
  ~Molecola(){ dealloca(); };
};
