#include "compito.h"

GestoreMessaggi::GestoreMessaggi(int n){

    if(n < 2)
        n = 2;

    capienza_utenti = n;
    numero_utenti_presenti = 0;

    utenti = new Utente[capienza_utenti];
}

char* GestoreMessaggi::pulisci_nick(const char* id){

    int lunghezza_nick_originale = strlen(id);

    char* default_return = new char[1];
    default_return[0] = '\0';

    if(lunghezza_nick_originale == 0)
        return default_return;

    int contatore_spazi_iniziali = 0;

    while(id[contatore_spazi_iniziali] == ' ')
        contatore_spazi_iniziali++;

    if(lunghezza_nick_originale == contatore_spazi_iniziali)
        return default_return;

    int contatore_spazi_finali = 0;

    while(id[lunghezza_nick_originale - contatore_spazi_finali - 1] == ' ')
        contatore_spazi_finali++;

    int caratteri_da_copiare = lunghezza_nick_originale - contatore_spazi_finali - contatore_spazi_iniziali;

    char* nick_pulito = new char[caratteri_da_copiare+1];
    strncpy(nick_pulito, &id[contatore_spazi_iniziali], caratteri_da_copiare);
    nick_pulito[caratteri_da_copiare] = '\0';

    return nick_pulito;
}

GestoreMessaggi::Utente* GestoreMessaggi::utente_presente(const char* id){
    for(int i = 0; i < numero_utenti_presenti; ++i){
        if(strcmp(utenti[i].nick, id) == 0)
            return &utenti[i];
    }

    return nullptr;
}

bool GestoreMessaggi::registra_utente(const char* id){

    if(numero_utenti_presenti == capienza_utenti)
        return false;

    char* id_pulito = pulisci_nick(id);

    int lunghezza_id = strlen(id_pulito);

    if(lunghezza_id == 0 || lunghezza_id > lunghezza_nick){
        delete[] id_pulito;
        return false;
    }

    if(utente_presente(id_pulito) != nullptr){
        delete[] id_pulito;
        return false;
    }

    strcpy(utenti[numero_utenti_presenti].nick, id_pulito);
    numero_utenti_presenti++;

    delete[] id_pulito;

    return true;

}

void GestoreMessaggi::invia_messaggio(const char* destinatario, const char* mittente, const char* testo){

    char* mittente_pulito = pulisci_nick(mittente);
    Utente* mitt_utente = utente_presente(mittente_pulito);

    char* destinatario_pulito = pulisci_nick(destinatario);
    Utente* dest_utente = utente_presente(destinatario_pulito);

    if(mitt_utente == nullptr || dest_utente == nullptr)
        return;

    int lunghezza_testo = strlen(testo);

    if(lunghezza_testo == 0 || lunghezza_testo > lunghezza_messaggio)
        return;

    if(dest_utente->numero_messaggi == capienza_casella)
        return;

    int indice_dove_scrivere = (dest_utente->primo + dest_utente->numero_messaggi) % capienza_casella;

    strcpy(dest_utente->casella[indice_dove_scrivere].mittente, mittente_pulito);
    strcpy(dest_utente->casella[indice_dove_scrivere].messaggio, testo);
    
    dest_utente->numero_messaggi++;

    delete[] mittente_pulito;
    delete[] destinatario_pulito;
}

ostream& operator<<(ostream& os, const GestoreMessaggi& g){

    os << "Numero utenti registrati: " << g.numero_utenti_presenti << endl;
    os << "Numero spazi disponibili: " << g.capienza_utenti - g.numero_utenti_presenti << endl << endl;

    for(int i = 0; i < g.numero_utenti_presenti; ++i)
        os << g.utenti[i].nick << ": " << g.utenti[i].numero_messaggi << " messaggi da leggere" << endl;

    return os;
}

GestoreMessaggi::~GestoreMessaggi(){
    delete[] utenti;
}

const char* GestoreMessaggi::leggi_messaggio(const char* destinatario, char* nick){

    char* destinatario_pulito = pulisci_nick(destinatario);
    Utente* dest_utente = utente_presente(destinatario_pulito);

    if(dest_utente == nullptr)
        return nullptr;

    if(dest_utente->numero_messaggi == 0)
        return nullptr;

    int indice_messaggio = dest_utente->primo;
    dest_utente->primo++;
    dest_utente->primo %= capienza_casella;
    dest_utente->numero_messaggi--;

    strcpy(nick, dest_utente->casella[indice_messaggio].mittente);

    return dest_utente->casella[indice_messaggio].messaggio;
}

GestoreMessaggi::GestoreMessaggi(const GestoreMessaggi& g){

    numero_utenti_presenti = g.numero_utenti_presenti;
    capienza_utenti = g.capienza_utenti;

    utenti = new Utente[capienza_utenti];
    for(int i = 0; i < numero_utenti_presenti; ++i){
        utenti[i] = g.utenti[i];
    }
}

GestoreMessaggi operator+(int n, const GestoreMessaggi& g){

    if(n < 0)
        n = 0;
    
    GestoreMessaggi g1(n + g.capienza_utenti);
    g1.numero_utenti_presenti = g.numero_utenti_presenti;

    g1.utenti = new GestoreMessaggi::Utente[g1.capienza_utenti];
    for(int i = 0; i < g1.numero_utenti_presenti; ++i){
        g1.utenti[i] = g.utenti[i];
    }

    return g1;
}