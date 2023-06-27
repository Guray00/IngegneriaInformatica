#include <iostream>
using namespace std;

struct elem {
    char* nome;
    int ev;
    elem* pun;
};

class Timeline {
    elem* testa;
    
public:
    Timeline();
    void pubblica(const char* str, int ev);
    void cancella(const char* str);
    friend ostream& operator<<(ostream& os, const Timeline& tl);
    
    // SECONDA PARTE
    int operator!();
    void mettiInEvidenza(const char* str);
    ~Timeline();
    
};
