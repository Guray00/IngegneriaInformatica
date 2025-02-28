#include "compito.h"

unsigned SpaceAsteroids::record = 0;

// funzione ausiliaria per il caricamento di una nuova partita
// utilizzata sia dal costruttore che dalla avanzamento_asteroidi e dagli operatori << e >>
void SpaceAsteroids::carica_nuova_partita() {

    for(unsigned i = 0; i < this->altezza; ++i)
        for(unsigned j = 0; j < this->larghezza; ++j)
            schermo[i][j] = 0;

    posizione_astronave = larghezza >> 1;
    energia_rimanente = energia_massima;
    punteggio = 0;
    spostamento_permesso = true;
    laser_permesso = true;
}

// Notare che il costruttore alloca lo schermo con una riga iniziale fittizia e mai stampata che semplifica
// di molto l'implementazione perchÃ© non servirÃ  gestire la prima riga (visibile) in maniera diversa dalle altre
SpaceAsteroids::SpaceAsteroids(int altezza, int larghezza, int energia) :
    altezza( (altezza >= min_altezza && altezza <= max_altezza) ? altezza + 1 : max_altezza + 1),
    larghezza( (larghezza >= min_larghezza && larghezza <= max_larghezza && (larghezza & 1u) == 1u) ? larghezza : max_larghezza),
    energia_massima( (energia > 0) ? energia : energia_default) {

    carica_nuova_partita();
}

bool SpaceAsteroids::colloca_asteroide(int col) {
    if(col <= 0 || col > larghezza || schermo[1][col-1] != 0)
        return false;

    schermo[1][col-1]++;

    return true;
}

void SpaceAsteroids::avanzamento_asteroidi() {
    // controllo se avviene una sconfitta
    if (schermo[altezza - 2][posizione_astronave] == 1) {
        carica_nuova_partita();
        return;
    }

    // Altrimenti traslo ogni colonna di una riga in basso
    // Notare che questo traslerÃ  anche i laser, dunque dovremo tenerne di conto nella avanza
    for (unsigned j = 0; j < larghezza; ++j) {
        for (unsigned i = altezza - 1; i > 0; --i)
            schermo[i][j] = schermo[i - 1][j];

        schermo[0][j] = 0;
    }

    // aggiornamento del punteggio e del record
    punteggio++;
    if(punteggio > record)
        record = punteggio;
}

ostream& operator<<(ostream& os, const SpaceAsteroids& s) {
    cout << "Punteggio: " << s.punteggio << endl;
    cout << "Record: " << SpaceAsteroids::record << endl;
    cout << "Energia: " << s.energia_rimanente << endl;

    for(unsigned j = 0; j < s.larghezza; ++j)
        os << "_";
    os << endl;

    for(unsigned i = 1; i < s.altezza; ++i) {
        for (unsigned j = 0; j < s.larghezza; ++j) {
            if (s.schermo[i][j] < 0)
                os << "|";
            else if (s.schermo[i][j] > 0)
                os << "X";
            else if (i == s.altezza-1)
                    if(j == s.posizione_astronave)
                        os << "A";
                    else
                        os << "_";
            else
                os << " ";
        }
        os << endl;
    }

    os << endl;

    return os;
}

void SpaceAsteroids::operator<<=(int n){
    if(n<0 || !spostamento_permesso)
        return;

    n = (posizione_astronave > n) ? n : posizione_astronave;

    // controllo della  possibile sconfitta
    for(unsigned j = 1; j <= n; ++j)
        if(schermo[altezza-1][posizione_astronave - j] == 1){
            carica_nuova_partita();
            return;
        }

    posizione_astronave -= n;
    spostamento_permesso = false;
}

void SpaceAsteroids::operator>>=(int n) {
    if(n<0 || !spostamento_permesso)
        return;

    n = (larghezza - posizione_astronave -1 > n) ? n : larghezza - posizione_astronave -1;

    // controllo della  possibile sconfitta
    for(unsigned j = 1; j <= n; ++j)
        if(schermo[altezza-1][posizione_astronave + j] == 1){
            carica_nuova_partita();
            return;
        }

    posizione_astronave += n;
    spostamento_permesso = false;
}

SpaceAsteroids& SpaceAsteroids::operator|=(int n){
    if(n <= 0 || !laser_permesso)
        return *this;

    n = (n > energia_rimanente) ? energia_rimanente : n;

    // Il caso di presenza di asteroide Ã¨ gestito implcitamente dal += e -=
    punteggio += schermo[altezza-2][posizione_astronave];
    schermo[altezza-2][posizione_astronave] -= n;
    energia_rimanente -= n;
    laser_permesso = false;

    return *this;
}

void SpaceAsteroids::avanza() {
    // traslazione verso l'alto di due di tutti i laser
    // la scelta di muoversi di due Ã¨ per compensare la discesa di uno della avanza_asteoridi
    // quindi qui dobbiamo tenere conto dell'impatto con asteroidi non solo dovuto alla salita dei laser
    // ma anche alla discesa degli asteoridi (da cui derivano le due righe di spostamento verticale)
    for(unsigned j = 0; j < larghezza; ++j) {
        // pulizia prima riga
        if (schermo[1][j] < 0)
            schermo[1][j] = 0;

        for (unsigned i = 2; i < altezza; ++i)
            if (schermo[i][j] < 0){
                // l'aggiornamento del punteggio deve tenere contro del caso limite
                // schermo[i][j] == -1 && schermo[i-1][j] == schermo[i-2][j] == 1
                // unico dove il punteggio non viene aggiornato di schermo[i-1][j] + schermo[i-2][j]
                punteggio += (schermo[i-1][j] + schermo[i][j] == 0) ? 1 : schermo[i-1][j] + schermo[i-2][j];
                schermo[i-2][j] += schermo[i-1][j] + schermo[i][j];
                schermo[i][j] = 0;
                schermo[i-1][j] = 0;
            }
    }

    spostamento_permesso = true;
    laser_permesso = true;
    energia_rimanente += (energia_rimanente < energia_massima) ? 1 : 0;

    if(punteggio > record)
        record = punteggio;

    avanzamento_asteroidi();
}