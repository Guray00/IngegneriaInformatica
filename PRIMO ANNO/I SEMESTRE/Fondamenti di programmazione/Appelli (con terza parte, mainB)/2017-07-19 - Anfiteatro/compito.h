
#include <iostream>
using namespace std;

class Anfiteatro{
	
   struct elemento{      
      int numMatt;
      elemento * succ;
   };

   elemento* testa;
      
   // mascheramento contruttore di copia
   Anfiteatro(const Anfiteatro &);

   // funzioni di utilita'   
   void elimina();

public:
    // PRIMA PARTE 18pt
    Anfiteatro(int);
	bool aggiungiMattonelle(int);
	void aggiungiColonna(int);
    friend ostream& operator<<(ostream&, const Anfiteatro&);

    // SECONDA PARTE  
	bool togliColonna(int); // 5pt
    Anfiteatro& operator= (const Anfiteatro&);  // 5pt
    ~Anfiteatro(){elimina();} // 2pt
};
