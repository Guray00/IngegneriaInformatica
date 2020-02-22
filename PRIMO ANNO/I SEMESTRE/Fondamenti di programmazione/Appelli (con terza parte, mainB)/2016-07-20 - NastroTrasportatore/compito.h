#include <iostream>
using namespace std;

struct pezzo{
    char* id;
    bool controllato;
    pezzo* pun;
};

class NastroTrasportatore{
    pezzo* _testa;    
public:
    // --- PRIMA PARTE --- //   // 20 pt
    NastroTrasportatore();
    void aggiungi(const char*);
    void rimuovi();
    friend ostream& operator<<(ostream&, const NastroTrasportatore&);
	NastroTrasportatore(const NastroTrasportatore&);

    // --- SECONDA PARTE --- //
	operator int() const;    // 2 pt
    void controlla(unsigned int);   // 5 pt
	~NastroTrasportatore(); // 3 pt
};