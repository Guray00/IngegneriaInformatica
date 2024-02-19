#include <iostream>
using namespace std;

struct elem {
    char descr[40 + 1];
    bool preso;
    elem *pun;
};

class OggettiViaggio {
    elem *p0;

    // mascheramento operatore assegnamento
    OggettiViaggio &operator=(const OggettiViaggio &);

public:
    // PRIMA PARTE:
    OggettiViaggio();
    friend ostream &operator<<(ostream &, const OggettiViaggio &);
    bool aggiungi(const char *);
    bool prendi(const char *);
    void viaggia();
    OggettiViaggio(const OggettiViaggio &);

    // SECONDA PARTE:
    ~OggettiViaggio();
    OggettiViaggio &operator+=(const OggettiViaggio &);
    bool rimuovi(const char *);
    OggettiViaggio operator!() const;
};