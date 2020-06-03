#include <cstring>
#include <iostream>
using namespace std;

const int SIZE = 1024; // numero di byte che possono essere memorizzati in ciascun settore

class Disco
{
  unsigned int* _vett;  // vettore di settori
  int _quantiSettori;         // numero di settori nel Disco
  int _quantiLiberi;          // numero di settori attualmente liberi
  int _quantiFile;            // numero di file memorizzati fino ad ora
  static int _quantiDischi;    // numero di Dischi presenti in memoria
  
  // mascheramento costruttore di copia e dell'op. di assegnamento
  Disco(const Disco&);
  Disco& operator=(const Disco&);

public:
  // --- PRIMA PARTE ---
  Disco(int);
  int riserva(int);
  friend ostream& operator<< (ostream&, const Disco&);
  Disco& cancella(int);

  // --- SECONDA PARTE ---  
  Disco& operator!();  // 2 pt
  void deframmenta();  // 5 pt 
  static int getQuantiDischi(){ return Disco::_quantiDischi; }; // 4pt
  ~Disco(){ delete[] _vett; Disco::_quantiDischi--;}; // 1 pt
};
