#include iostream
using namespace std;

struct Valutazione {
    int location, servizio, menu, conto;
    bool inserita;
    bool bonusAggiunto;
    int totaleValutazione;
};

class NRistoranti {
    int N; numero dei giudici
    int M; numero di ristoranti
    Valutazione matrice;
    char nomi;
    serve per gestire il caso in cui la matrice non sia quadrata,
    come puo' essere una matrice prodotta da operator!
    NRistoranti(int m, int n);

public
    PRIMA PARTE
    NRistoranti(int n);
    void aggiungiValutazione(char nome, int giudice, int loc, int serv, int men, int cont);
    void aggiungiBonus(char nome, int bonus);
    friend ostream& operator(ostream&, const NRistoranti&);

    SECONDA PARTE
    NRistoranti(const NRistoranti&);
    ~NRistoranti();
    NRistoranti& operator~();
    NRistoranti operator!() const;
};