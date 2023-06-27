#include <iostream>
#include <cstring>
using namespace std;

class Aula{
  private:
    char** v;
    int totalePostazioni;
    int quanteOccupate;
    friend ostream& operator<<(ostream&, const Aula&);
  public:
    Aula(int);    
    bool aggiungi(const char[]);
    void elimina(int);
    // --- SECONDA PARTE ---
    Aula(const Aula&);    
    Aula& operator!();
    ~Aula();
};

