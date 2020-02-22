#include <iostream>
#include <cstring>
using namespace std;

class MatQuad{
  
  int* _vett;
  int _size;
  
  // funzioni di utilita'
   
  // mascheramento costruttore di copia e op. di assegnamento
  MatQuad(const MatQuad&);  
  MatQuad& operator=(const MatQuad&);

public:
  // --- PRIMA PARTE ---
  MatQuad(int);    
  MatQuad& aggiorna(int*, int);
  friend ostream& operator<<(ostream&, const MatQuad&);
  bool trova()const;
  
  // --- SECONDA PARTE ---
  MatQuad& raddoppia();
  ~MatQuad();
};


