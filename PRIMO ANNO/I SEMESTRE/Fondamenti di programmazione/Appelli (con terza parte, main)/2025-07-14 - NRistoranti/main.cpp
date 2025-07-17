#include <iostream>
#include "compito.h"
using namespace std;

int main() {
    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test costruttore e operatore di stampa:" << endl << endl;

    NRistoranti nr(3);

    // Stampa iniziale
    cout << nr;

    cout << endl << "Test funzione aggiungiValutazione:" << endl << endl;

    // Aggiunte valide
    nr.aggiungiValutazione('A', 1, 7, 6, 7, 7);
    nr.aggiungiValutazione('A', 2, 5, 7, 5, 7);
    nr.aggiungiValutazione('A', 3, 8, 8, 8, 8);

    nr.aggiungiValutazione('B', 1, 7, 7, 8, 7);
    nr.aggiungiValutazione('B', 2, 7, 8, 7, 6);
    nr.aggiungiValutazione('B', 3, 8, 7, 8, 9);

    nr.aggiungiValutazione('C', 1, 10, 10, 10, 10);
    nr.aggiungiValutazione('C', 2, 9, 9, 9, 9);
    nr.aggiungiValutazione('C', 3, 9, 9, 9, 9);

    // Aggiunte non valida
    nr.aggiungiValutazione('A', 4, 1, 1, 1, 1); // Giudice invalido

    cout << nr;

    cout << endl << "Test funzione aggiungiBonus:" << endl << endl;

    // Bonus
    nr.aggiungiBonus('A', 3);

    // Errore
    nr.aggiungiBonus('A', 2); // giÃ  aggiunto

    cout << nr;

    cout << endl << "--- SECONDA PARTE ---" << endl;
    cout << "Test costruttore di copia:" << endl;

    NRistoranti nr2 = nr;
    cout << "Oggetto copiato:" << endl << endl;
    cout << nr2;

    cout << endl << "Test eventuale distruttore:" << endl << endl;

    {
        NRistoranti nr3(2);
    }

    cout << "Distruttore chiamato" << endl;

    cout << endl << "Test operatore ~ (ordinamento):" << endl << endl;

    cout << ~nr2;

    cout << endl << "Test operatore ! (filtro >= 100):" << endl << endl;

    NRistoranti nr3 = !nr2;
    cout << nr3;

    cout << endl << "--- TERZA PARTE ---" << endl;
    cout << "Test costruttore con N non valido:" << endl << endl;

    // Err deve avere N = 2
    NRistoranti err(0);

    cout << err;

    cout << endl << "Ulteriori test funzione aggiungiValutazione:" << endl << endl;

    // Aggiunte valide
    err.aggiungiValutazione('A', 1, 5, 5, 5, 5);
    err.aggiungiValutazione('A', 2, 3, 3, 3, 3);

    err.aggiungiValutazione('B', 1, 11, 1, 1, 1); // Aggiunta non valida per voto invalido
    err.aggiungiValutazione('B', 1, 1, 1, 1, 1);
    err.aggiungiValutazione('B', 2, 4, 4, 4, 4);

    // Aggiunte non valide
    err.aggiungiValutazione('?', 2, 4, 5, 6, 7); // Nome ristorante invalido
    err.aggiungiValutazione('C', 1, 5, 5, 5, 5); // Ristorante non presente
    err.aggiungiValutazione('A', 1, 10, 10, 10, 10); // Valutazione giÃ  presente

    cout << err;

    cout << endl << "Ulteriori test funzione aggiungiBonus:" << endl << endl;

    // Errori

    err.aggiungiBonus('!', 3); // Nome ristorante invalido
    err.aggiungiBonus('D', 4); // Ristorante non presente
    err.aggiungiBonus('A', 11); // Bonus invalido

    cout << err;

    cout << endl << "Ulteriore test operator ~ (non riordina):" << endl << endl;

    cout << ~err;

    cout << endl << "Ulteriore test operator ! (ritorna un oggetto senza ristoranti):" << endl << endl;

    NRistoranti filtrato_vuoto = !err;

    cout << filtrato_vuoto;

    return 0;
}
