#include <iostream>
#include "compito.h"
using namespace std;

int main() {
    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test costruttore, aggiungiScaffale e aggiungiLibro" << endl;

    LibreriaDigitale ld;

    ld.aggiungiScaffale("Nome lunghissimo e improbabile per uno scaffale", 2); //non aggiunge perchÃ© nome troppo lungo
    ld.aggiungiScaffale("Narrativa", 10);
    ld.aggiungiScaffale("Narrativa", 3); //non aggiunge perchÃ© nome giÃ  presente
    ld.aggiungiScaffale("Informatica", 5);
    ld.aggiungiScaffale("Saggi", 1);

    ld.aggiungiLibro("Narrativa", "Il nome della rosa", false);
    ld.aggiungiLibro("Narrativa", "1984", true);
    ld.aggiungiLibro("Narrativa", "", true); //non aggiunge perche' titolo e' una stringa vuota
    ld.aggiungiLibro("Informatica", "Introduzione a C++", false);
    ld.aggiungiLibro("Saggi", "Il taccuino del carcere", true);
    ld.aggiungiLibro("Saggi", "Il mestiere di vivere", false); //non aggiunge perchÃ© lo scaffale ha esaurito la sua capacitÃ 

    cout << endl << ld;

    cout << endl << "--- SECONDA PARTE ---" << endl;

    cout << "Test costruttore di copia" << endl;

    LibreriaDigitale ld2 = ld;
    ld2.aggiungiScaffale("Filosofia", 7);
    cout << endl << ld2;

    cout << endl << "Test eventuale distruttore" << endl;
    {
        LibreriaDigitale ld1;
    }
    cout << "Distruttore chiamato" << endl;

    cout << endl << "Test rimuoviLibro" << endl;

    ld.rimuoviLibro("Narrativa", "Il nome della rosa");
    ld.rimuoviLibro("Narrativa", "I pilastri della Terra"); //non rimuove perche' libro non trovato
    cout << endl << ld;

    cout << endl << "Test operatore complemento" << endl;

    LibreriaDigitale ld3 = ~ld;
    cout << endl << ld3;

    cout << endl << "Test operatore negazione" << endl;

    !ld;
    cout << endl << ld;

    cout << endl << "--- TERZA PARTE ---" << endl;

    LibreriaDigitale ld4;
    cout << "Test libreria vuota:" << endl;
    cout << endl << ld4;

    ld4.aggiungiScaffale("", 2); //non aggiunge perche' scaffale e' stringa vuota
    ld4.aggiungiScaffale("Narrativa", 0); //non aggiunge perchÃ© capacitÃ  non positiva
    ld4.aggiungiScaffale("Test", 1);
    ld4.aggiungiLibro("Test", "Libro 1", true);
    ld4.aggiungiLibro("Test", "Libro 1", false); //non aggiunge perchÃ© libro gia' presente
    ld4.aggiungiLibro("Test", "Libro libro libro libro libro libro", true); //non aggiunge perche' titolo troppo lungo
    cout << endl << "Dopo inserimenti su libreria" << endl;
    cout << endl << ld4;

    ld4.rimuoviLibro("Prova", "Libro 1"); //non rimuove perchÃ© scaffale e' insesistente
    cout << endl << "Dopo il tentativo di rimozione:" << endl;
    cout << endl << ld4;

    return 0;
}