#include <iostream>
using namespace std;

struct elem{
	int inf;
	elem* pun;
};

class CalcolatricePolacca{
	
    elem* p0;

    // funzioni di utilita'
    bool estrai( int& );
    void dealloca();		
	
public:
    // --- PRIMA PARTE ---
    CalcolatricePolacca(){ p0 = nullptr;}	
    friend ostream& operator<<(ostream&, const CalcolatricePolacca&);
    void ins(int);
    void moltiplica();
    void somma();
	
    // --- SECONDA PARTE ---
    ~CalcolatricePolacca(){dealloca();}
    void duplica();
    void opposto();	
    CalcolatricePolacca& operator=(const CalcolatricePolacca&);
    void rimuoviNegativi();	
};


