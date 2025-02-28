#include <iostream>
#include <cstring>
using namespace std;

const int lunghezza_nick = 20;
const int lunghezza_messaggio = 29;
const int capienza_casella = 5;


class GestoreMessaggi{
    
    class Utente{

    public:

        struct Messaggio{   
            char mittente[lunghezza_nick+1];
            char messaggio[lunghezza_messaggio+1];
        };

        int primo;
        int numero_messaggi;

        char nick[lunghezza_nick+1];
        Messaggio casella[capienza_casella];

        Utente():primo(0),numero_messaggi(0){};
    };

    int numero_utenti_presenti;
    int capienza_utenti;

    Utente* utenti;

    char* pulisci_nick(const char*);
    Utente* utente_presente(const char*);

public:
    // --- PRIMA PARTE ---
    GestoreMessaggi(int n);
    bool registra_utente(const char*);
    void invia_messaggio(const char*, const char*, const char*);
    friend ostream& operator<<(ostream&, const GestoreMessaggi& g);

    // --- SECONDA PARTE ---
    ~GestoreMessaggi();
    const char* leggi_messaggio(const char*, char*);
    GestoreMessaggi(const GestoreMessaggi&);
    friend GestoreMessaggi operator+(int, const GestoreMessaggi&);
};