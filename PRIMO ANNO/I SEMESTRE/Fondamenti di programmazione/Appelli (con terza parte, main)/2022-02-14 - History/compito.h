#include <iostream>
using namespace std;

#define MAX_CHARS 30

struct elem {
    int year;
    char descr[MAX_CHARS+1];
    elem* next;
};

class History {
    elem* head;
    // mascheramento costruttore copia e assegnamento:
    History(const History&);
    History& operator=(const History&);
public:
    History();
    void record(int, const char*);
    void forget(const char*);
    friend ostream& operator<<(ostream&, const History&);
    ~History();
    
    // SECONDA PARTE
    int longest_period()const;
    void forget(int, int);
    friend History* create_alternative(const History&, int, const History&);
};