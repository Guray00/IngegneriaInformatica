#include <iostream>

using namespace std;

class Scrabble
{
    unsigned int _dim;
    char* _tab;
    
public:
    
    // --- PRIMA PARTE --- 
    Scrabble(int);
    bool aggiungi(const char*, int, int, char);
    Scrabble& operator=(const Scrabble&);
    friend ostream& operator<<(ostream&, const Scrabble&);
    
    // --- SECONDA PARTE --- 
    
    bool esiste(const char*) const;  
    int operator!() const;           
    ~Scrabble();                     
};
