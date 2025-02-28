#include "compito.h"
#include <cstring>


// -------------------------- PRIMA PARTE -------------------------------


UfficioPostale::UfficioPostale(int M) {

    if (M < 1)
        M = 2;


    num_sportelli = M;
    utenti_totali = 0;
    utenti_prioritari = 0;
    utenti_non_prioritari = 0;


    ufficio = new utente*[num_sportelli];


    for (int i = 0; i < num_sportelli; i++)
        ufficio[i] = nullptr;


}


ostream& operator<<(ostream& os, const UfficioPostale& up) {


    os << "Utenti totali: " << up.utenti_totali << endl;
    os << "Prioritari: " << up.utenti_prioritari;


    for (int i = 0; i < up.num_sportelli; i++) {


        os << endl;
        os << "- Sportello " << i + 1 << ": ";


        for (utente* p = up.ufficio[i]; p != nullptr; p = p-> prossimo) {


            os << p->nome_utente;
            if (p->prioritario)
                os << " " << "(P)";
            if (p->prossimo != nullptr)
                os << ", ";
        }
    }


    return os;
}


void UfficioPostale::accodaUtente(const char *nome, int sportello) {


    // sportello non valido
    if (sportello < 1 || sportello > num_sportelli)
        return;
    // nome utente non valido
    if (strlen(nome) > NOME_UTENTE || strlen(nome) == 0)
        return;


    utente* p, *q;
    for (p = ufficio[sportello - 1]; p != nullptr; p = p -> prossimo) {


        // nome utente giÃ  presente allo sportello
        if (strcmp(nome, p -> nome_utente) == 0)
            return;


        q = p;
    }


    p = new utente;
    strcpy(p -> nome_utente, nome);
    p -> prioritario = false;
    p -> prossimo = nullptr;


    // lista era vuota
    if (ufficio[sportello - 1] == nullptr)
        ufficio[sportello -1] = p;
    else
        q -> prossimo = p;


    utenti_totali++;
    utenti_non_prioritari++;


}


bool UfficioPostale::serviUtente(int sportello) {


    // sportello non valido
    if (sportello < 1 || sportello > num_sportelli)
        return false;


    // lista vuota
    if (ufficio[sportello - 1] == nullptr)
        return false;


    utente* p = ufficio[sportello - 1] -> prossimo;


    utenti_totali--;
    if (ufficio[sportello - 1] -> prioritario)
        utenti_prioritari--;
    else
        utenti_non_prioritari--;


    delete ufficio[sportello - 1];


    ufficio[sportello - 1] = p;


    return true;


}


// -------------------------- SECONDA PARTE -------------------------------


UfficioPostale::~UfficioPostale() {


    for (int i = 0; i < num_sportelli; i++) {


        utente* p = ufficio[i];
        while(p != nullptr) {
            p = p -> prossimo;
            serviUtente(i + 1);
        }
    }


    delete[] ufficio;
}


void UfficioPostale::accodaPrioritario(const char *nome) {


    // nome utente non valido
    if (strlen(nome) > NOME_UTENTE || strlen(nome) == 0)
        return;


    int indice_sportello_meno_prioritari = 0, numero_minimo_prioritari = 0;


    // conto il numero di prioritari allo sportello 0
    for (utente* p = ufficio[0]; p != nullptr; p = p -> prossimo) {
        if (p -> prioritario)
            numero_minimo_prioritari++;
    }


    // controllo i prioritari a partire dal secondo sportello
    for (int i = 1; i < num_sportelli; i++) {
        int numero_prioritari_sportello = 0;


        for (utente* p = ufficio[i]; p != nullptr; p = p -> prossimo) {
            if (p -> prioritario)
                numero_prioritari_sportello++;
        }


        // aggiorno lo sportello solo se questo contiene meno prioritari del precedente
        if(numero_prioritari_sportello < numero_minimo_prioritari) {
            numero_minimo_prioritari = numero_prioritari_sportello;
            indice_sportello_meno_prioritari = i;
        }
    }


    // controllo se l'utente Ã¨ giÃ  presente nello sportello individuato
    for (utente* p = ufficio[indice_sportello_meno_prioritari]; p != nullptr; p = p -> prossimo) {
        if (strcmp(nome, p -> nome_utente) == 0)
            return;
    }


    // inserisco l'utente in maniera ordinata
    utente* p = nullptr, *q, *r;
    for (q = ufficio[indice_sportello_meno_prioritari]; q != nullptr && q -> prioritario; q = q -> prossimo)
        p = q;
    r = new utente;
    strcpy(r -> nome_utente, nome);
    r -> prioritario = true;
    r -> prossimo = q;
    if (q == ufficio[indice_sportello_meno_prioritari])
        ufficio[indice_sportello_meno_prioritari] = r;
    else
        p -> prossimo = r;


    utenti_totali++;
    utenti_prioritari++;
}


void UfficioPostale::passaAvanti(const char* nome, int sportello, int posizioni) {


    if (sportello < 1 || sportello > num_sportelli)
        return;


    int posizione_utente = 1;


    utente* p = nullptr, *q;
    for (q = ufficio[sportello -1]; q != nullptr && strcmp(q->nome_utente, nome) != 0; q = q -> prossimo) {
        posizione_utente++;
        p = q;
    }


    // utente non presente allo sportello
    if (q == nullptr)
        return;


    // controllo posizioni
    if (posizioni <= 0 || posizioni >= posizione_utente)
        return;


    // per avanzare l'utente, lo elimino dalla posizione attuale e lo reinserisco nella nuova posizione
    // prima rimuovo
    p -> prossimo = q -> prossimo;
    bool utente_prioritario = q -> prioritario;
    delete q;


    // poi reinserisco
    int nuova_posizione = 1;
    p = nullptr;
    utente* r;
    for (q = ufficio[sportello -1]; q != nullptr && nuova_posizione < posizione_utente - posizioni; q = q -> prossimo) {
        nuova_posizione++;
        p = q;
    }
    r = new utente;
    strcpy(r -> nome_utente, nome);
    if (q -> prioritario && !utente_prioritario) {
        r -> prioritario = true;
        utenti_non_prioritari--;
        utenti_prioritari++;
    }
    r -> prossimo = q;
    if (q == ufficio[sportello - 1])
        ufficio[sportello - 1] = r;
    else
        p -> prossimo = r;
}


UfficioPostale& UfficioPostale::operator!() {


    // prima cambio lo stato di prioritÃ  per tutti gli utenti ad ogni sportello
    for (int i = 0; i < num_sportelli; i++) {
        for (utente* p = ufficio[i]; p != nullptr; p = p-> prossimo)
            p -> prioritario = !p->prioritario;
    }


    // poi, per ogni lista, riaggiorno i puntatori opportunamente


    // solo nel caso in cui gli utenti ad uno sportello non abbiano tutti stessa prioritÃ , cambia_prossimo permette
    // di aggiornare il puntatore al prossimo elemento dopo l'ultimo utente a prioritÃ  N.
    // Questo N dovrÃ  puntare a nullptr. Ma questo cambiamento lo posso fare solo all'iterazione successive
    // in quanto se lo facessi a questa iterazione, il loop terminerebbe per la condizione di controllo
    // stessa_priorita dice se gli utenti ad una cosa sono tutti di stessa priorita. Mi serve per evitare di aggiornare
    // alla vecchia testa il puntatore "prossimo" dopo l'ultimo utente P prima del riordino. Se lo facessi, creerei
    // un loop infinito
    utente* testa_tmp;
    bool cambia_prossimo, stessa_priorita;
    for (int i = 0; i < num_sportelli; i++) {
        testa_tmp = ufficio[i];
        cambia_prossimo = false;
        stessa_priorita = true;
        utente* p = nullptr;
        for (utente* q = ufficio[i]; q != nullptr; q = q-> prossimo){


            // cambio il puntatore dopo l'ultimo utente N e aggiorno la testa
            if (cambia_prossimo) {
                ufficio[i] = q;
                p -> prossimo = nullptr;
                cambia_prossimo = false;
            }


            // metto cambia_prossimo=true quando mi trovo tra l'ultimo utente N ed il primo utente P
            if (!q -> prioritario && (q -> prossimo != nullptr && q -> prossimo -> prioritario)) {
                cambia_prossimo = true;
                stessa_priorita = false;
            }


            p = q;
        }


        if (!stessa_priorita)
            p -> prossimo = testa_tmp;
    }


    // adesso modifico i contatori per gli utenti prioritari e i non prioritari
    int tmp_prioritari = utenti_prioritari;
    utenti_prioritari = utenti_non_prioritari;
    utenti_non_prioritari = tmp_prioritari;


    return *this;
}


