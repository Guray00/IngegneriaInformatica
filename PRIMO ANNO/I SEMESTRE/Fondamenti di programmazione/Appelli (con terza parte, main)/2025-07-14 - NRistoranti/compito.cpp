#include <cstring>
#include "compito.h"

const int soglia_voto_complessivo = 100;

// Costruttore
NRistoranti::NRistoranti(int n) {
    if (n <= 1 || n >= 27)
        N = 2;
    else
        N = n;

    nomi = new char[N];
    char base = 'A';
    for (int i = 0; i < N; i++)
        nomi[i] = base + i;

    matrice = new Valutazione*[N];
    for (int i = 0; i < N; i++) {
        matrice[i] = new Valutazione[N];
        for (int j = 0; j < N; j++) {
            matrice[i][j].location = 0;
            matrice[i][j].servizio = 0;
            matrice[i][j].menu = 0;
            matrice[i][j].conto = 0;
            matrice[i][j].inserita = false;
            matrice[i][j].bonusAggiunto = false;
            matrice[i][j].totaleValutazione = 0;
        }
    }
    M = N;
}

// Aggiunta valutazione
void NRistoranti::aggiungiValutazione(char n, int g, int l, int s, int m, int c) {
    if (n < 'A' || n > 'Z' || g < 1 || g > N || l < 0 || l > 10 || s < 0 || s > 10 || m < 0 || m > 10 || c < 0 || c > 10)
        return;

    int id_ristorante = -1;
    for (int i = 0; i < M; i++)
        if (nomi[i] == n) {
            id_ristorante = i;
            break;
        }

    if (id_ristorante == -1) return;

    Valutazione& v = matrice[id_ristorante][g - 1];
    if (v.inserita) return;

    v.location = l;
    v.servizio = s;
    v.menu = m;
    v.conto = c;
    v.inserita = true;
    v.bonusAggiunto = false;
    v.totaleValutazione = l + s + m + c;
}

// Aggiunta bonus
void NRistoranti::aggiungiBonus(char n, int bonus) {
    if (n < 'A' || n > 'Z' || bonus <= 0 || bonus > 10) return;

    int id_ristorante = -1;
    for (int i = 0; i < M; i++)
        if (nomi[i] == n) {
            id_ristorante = i;
            break;
        }

    if (id_ristorante == -1) return;

    for (int j = 0; j < N; j++)
        if (!matrice[id_ristorante][j].inserita || matrice[id_ristorante][j].bonusAggiunto)
            return;

    for (int j = 0; j < N; j++) {
        Valutazione& v = matrice[id_ristorante][j];
        int* voti[4] = { &v.location, &v.servizio, &v.menu, &v.conto };
        int min = 0;
        for (int i = 1; i < 4; i++)
            if (*voti[i] < *voti[min]) min = i;

        if (*voti[min] + bonus <= 10) {
            *voti[min] += bonus;
            v.totaleValutazione += bonus;
        }
        v.bonusAggiunto = true;
    }
}

// Stampa
ostream& operator<<(ostream& os, const NRistoranti& nr) {
    os << nr.M << " ristoranti e " << nr.N << " giudici" << endl;
    for (int i = 0; i < nr.M; i++) {
        int voto_complessivo = 0;
        for (int j = 0; j < nr.N; j++)
            voto_complessivo += nr.matrice[i][j].totaleValutazione;

        os << "- Ristorante " << nr.nomi[i] <<", voto complessivo: " << voto_complessivo << endl;
        for (int j = 0; j < nr.N; j++) {
            const Valutazione& v = nr.matrice[i][j];
            os << "  Giudice " << j + 1 << ":" << endl;
            os << "    Location - " << v.location << endl;
            os << "    Servizio - " << v.servizio << endl;
            os << "    Menu - " << v.menu << endl;
            os << "    Conto - " << v.conto << endl;
        }
    }
    return os;
}

// --------------- SECONDA PARTE ---------------------

// Costruttore di copia
NRistoranti::NRistoranti(const NRistoranti& other) {
    N = other.N;
    M = other.M;

    nomi = new char[M];
    for (int i = 0; i < M; i++) {
        nomi[i] = other.nomi[i];
    }

    matrice = new Valutazione*[M];
    for (int i = 0; i < M; i++) {
        matrice[i] = new Valutazione[N];
        for (int j = 0; j < N; j++)
            matrice[i][j] = other.matrice[i][j];
    }
}

// Distruttore
NRistoranti::~NRistoranti() {
    delete[] nomi;

    for (int i = 0; i < M; i++) delete[] matrice[i];
    delete[] matrice;
}

// Ordinamento (complemento)
NRistoranti& NRistoranti::operator~() {
    for (int i = 0; i < M - 1; i++) {
        for (int j = i + 1; j < M; j++) {
            int tot_i = 0, tot_j = 0;
            for (int k = 0; k < N; k++) {
                tot_i += matrice[i][k].totaleValutazione;
                tot_j += matrice[j][k].totaleValutazione;
            }

            bool scambio = false;
            if (tot_j > tot_i || (tot_j == tot_i && nomi[j] > nomi[i]))
                scambio = true;

            if (scambio) {
                // scambia i nomi
                char temp = nomi[i];
                nomi[i] = nomi[j];
                nomi[j] = temp;

                // scambia righe della matrice
                Valutazione* riga_temp = matrice[i];
                matrice[i] = matrice[j];
                matrice[j] = riga_temp;
            }
        }
    }
    return *this;
}

// Costruttore alternativo, utilizzato da operator!
NRistoranti::NRistoranti(int numRistoranti, int numGiudici) {
    M = numRistoranti;
    N = numGiudici;

    nomi = new char[M];

    matrice = new Valutazione*[M];
    for (int i = 0; i < M; i++) {
        matrice[i] = new Valutazione[N];
    }
}

// Filtro (!)
NRistoranti NRistoranti::operator!() const {
    int count = 0;
    for (int i = 0; i < M; i++) {
        int somma = 0;
        for (int j = 0; j < N; j++)
            somma += matrice[i][j].totaleValutazione;
        if (somma >= soglia_voto_complessivo) count++;
    }

    NRistoranti risultato(count, N);
    int dest = 0;
    for (int i = 0; i < M; i++) {
        int somma = 0;
        for (int j = 0; j < N; j++)
            somma += matrice[i][j].totaleValutazione;

        if (somma >= soglia_voto_complessivo) {
            risultato.nomi[dest] = nomi[i];
            for (int j = 0; j < N; j++)
                risultato.matrice[dest][j] = matrice[i][j];
            dest++;
        }
    }
    return risultato;
}
