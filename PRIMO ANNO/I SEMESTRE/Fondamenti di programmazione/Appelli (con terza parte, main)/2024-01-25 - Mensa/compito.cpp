#include "compito.h"
#include <cstring>

Mensa::Mensa(int N){
    nSedie = (N <= 0) ? 1 : N;
    v = new char*[nSedie];
    for (int i = 0; i < nSedie; i++)
        v[i] = nullptr;
}

ostream& operator<<(ostream& os, const Mensa& p){
    for (int i = 0; i < p.nSedie; i++){
        if (p.v[i] != nullptr)
            os << "sedia " << (i+1) << ": " << p.v[i] << endl;
        else
            os << "sedia " << (i+1) << ": (non occupata)" << endl;
    }
    return os;
}

bool Mensa::occupa(const char id[]){
    // evito che ci siano due persone/gruppi omonimi
    for (int i = 0; i < nSedie; i++)
        if (v[i] != nullptr && strcmp(v[i], id) == 0)
            return false;

    // trovo un posto per la persona
    for (int j = 0; j < nSedie; j++)
        if (v[j] == nullptr){
            v[j] = new char[strlen(id)+1];
            strcpy(v[j], id);
            return true;
        }

    // non c'e' posto
    return false;
}

void Mensa::libera(int k){
    k--;
    if (k < 0 || k >= nSedie)
        return;
    if (v[k] != nullptr){
        delete[] v[k];
        v[k] = nullptr;
    }
}

// --- SECONDA PARTE ---

Mensa::Mensa(const Mensa& p){
    nSedie = p.nSedie;
    v = new char*[nSedie];
    for (int i = 0; i < nSedie; i++) {
        if (p.v[i] == nullptr)
            v[i] = nullptr;
        else{
            v[i] = new char[strlen(p.v[i])+1];
            strcpy(v[i], p.v[i]);
        }
    }
}

Mensa::~Mensa(){
    for (int i = 0; i < nSedie; i++)
        if (v[i] != nullptr)
            delete[] v[i];
    delete[] v;
}

bool Mensa::occupaGruppo(const char id[], int n) {
    // evito che ci siano due persone/gruppi omonimi:
    for (int i = 0; i < nSedie; i++)
        if (v[i] != nullptr && strcmp(v[i], id) == 0)
            return false;

    // trovo un posto per n persone contigue
    for (int j = 0; j <= nSedie - n; j++) {
        bool postiTrovati = true;
        for (int k = j; k < j+n; k++) {
            if (v[k] != nullptr) {
                postiTrovati = false;
                break;
            }
        }
        // se ho trovato i posti, li occupo
        if (postiTrovati) {
            for (int k = j; k < j+n; k++) {
                v[k] = new char[strlen(id) + 1];
                strcpy(v[k], id);
            }
            return true;
        }
    }
    // non c'e' posto
    return false;
}

void Mensa::ordina(){
    // ordino con selection sort
    for (int i = 0; i < nSedie-1; i++) {
        int iMax = i;
        for (int j = i + 1; j < nSedie; j++) {
            // se il massimo temporaneo e' una sedia vuota, gia' lo considero massimo definitivo
            if (v[iMax] == nullptr) break;
            // una sedia vuota e' sempre "maggiore" di una sedia occupata da qualsiasi nome
            if (v[j] == nullptr || strcmp(v[j], v[iMax]) < 0)
                iMax = j;
        }
        // scambio i puntatori alle stringhe, non le stringhe stesse
        char* aux = v[iMax];
        v[iMax] = v[i];
        v[i] = aux;
    }
}