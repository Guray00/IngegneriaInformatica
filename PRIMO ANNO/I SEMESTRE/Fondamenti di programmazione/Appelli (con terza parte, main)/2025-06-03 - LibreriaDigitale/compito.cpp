#include <cstring>
#include "compito.h"

//prima parte

LibreriaDigitale::LibreriaDigitale() {
    head = nullptr;
}

ostream& operator<<(ostream& os, const LibreriaDigitale& ld) {
    for (Scaffale* s = ld.head; s != nullptr; s = s->next) {
        os << "- Scaffale: " << s->nome << endl;
        int i = 1;
        for (Libro* l = s->libri; l != nullptr; l = l->next, i++) {
            os << "  " << i << ". '" << l->titolo << "' (" << (l->usato ? "Usato" : "Nuovo") << ")" << endl;
        }
        os << "  Totale libri: " << s->numLibri << "/" << s->capacita << endl;
    }
    return os;
}

void LibreriaDigitale::aggiungiScaffale(const char* nome, int capacita) {
    if (strlen(nome)==0 || strlen(nome) > MAX_NOME_SCAFFALE || capacita <= 0)
        return;

    for (Scaffale* s = head; s != nullptr; s = s->next)
        if (strcmp(s->nome, nome) == 0)
            return;

    Scaffale* p = nullptr, *s;
    for (s = head; s != nullptr; s = s->next)
        p = s;

    s = new Scaffale;
    strcpy(s->nome, nome);
    s->capacita = capacita;
    s->numLibri = 0;
    s->libri = nullptr;
    s->next = nullptr;

    if (p)
        p -> next = s;
    else
        head = s;
}

bool LibreriaDigitale::aggiungiLibro(const char* nomeScaffale, const char* titolo, bool condizione) {
    if (strlen(titolo) == 0 || strlen(titolo) > MAX_TITOLO_LIBRO)
        return false;

    for (Scaffale* s = head; s != nullptr; s = s->next) {
        if (strcmp(s->nome, nomeScaffale) == 0) {
            if (s->numLibri >= s->capacita)
                return false;

            Libro* p = nullptr, *l;
            for (l = s->libri; l != nullptr; l = l->next) {
                if (strcmp(l->titolo, titolo) == 0)
                    return false;
                p = l;
            }

            l = new Libro;
            strcpy(l->titolo, titolo);
            l->usato = condizione;
            l->next = nullptr;

            if (p)
                p -> next = l;
            else
                s->libri = l;

            s->numLibri++;
            return true;
        }
    }
    //scaffale non presente
    return false;
}

//seconda parte

LibreriaDigitale::LibreriaDigitale(const LibreriaDigitale& other) {
    head = nullptr;

    for (Scaffale* s = other.head; s != nullptr; s = s->next) {
        aggiungiScaffale(s->nome, s->capacita);
        for (Libro* l = s->libri; l != nullptr; l = l->next) {
            aggiungiLibro(s->nome, l->titolo, l->usato);
        }
    }
}

LibreriaDigitale::~LibreriaDigitale() {
    while (head) {
        Scaffale* tempS = head;
        head = head->next;

        while (tempS->libri) {
            Libro* tempL = tempS->libri;
            tempS->libri = tempL->next;
            delete tempL;
        }

        delete tempS;
    }
}

void LibreriaDigitale::rimuoviLibro(const char* nomeScaffale, const char* titolo) {
    for (Scaffale* s = head; s != nullptr; s = s->next) {
        if (strcmp(s->nome, nomeScaffale) == 0) {
            Libro* prev = nullptr;
            Libro* l = s->libri;
            while (l) {
                if (strcmp(l->titolo, titolo) == 0) {
                    if (prev) prev->next = l->next;
                    else s->libri = l->next;
                    delete l;
                    s->numLibri--;
                    return;
                }
                prev = l;
                l = l->next;
            }
        }
    }
}

LibreriaDigitale LibreriaDigitale::operator~() const {
    LibreriaDigitale nuovo = *this;
    for (Scaffale* s = nuovo.head; s != nullptr; s = s->next) {
        for (Libro* l = s->libri; l != nullptr; l = l->next) {
            if (l->usato)
                l->usato = false;
            else
                l->usato = true;
        }
    }
    return nuovo;
}

LibreriaDigitale& LibreriaDigitale::operator!() {
    for (Scaffale* s = head; s != nullptr; s = s->next) {
        int usati = 0;
        for (Libro* l = s->libri; l != nullptr; l = l->next)
            if (l->usato) usati++;

        if (s->numLibri > 0 && usati * 2 >= s->numLibri) {
            Libro* l = s->libri;
            while (l) {
                Libro* next = l->next;
                if (l->usato) {
                    rimuoviLibro(s->nome, l->titolo);
                }
                l = next;
            }
        }
    }
    return *this;
}