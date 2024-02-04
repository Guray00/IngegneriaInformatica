#include "compito.h"
#include <cstring>
#include <iostream>
using namespace std;

// --- PRIMA PARTE ------------------------------

OggettiViaggio::OggettiViaggio() {
    p0 = nullptr;
}

bool OggettiViaggio::aggiungi(const char* descr) {
    // gestisco input non valido
    if (strlen(descr) > 40)
        return false;

    // evito di aggiungere se la descrizione c'e' gia'
    elem *p, *q;
    for (p = p0; p != nullptr; p = p->pun) {
        if (strcmp(descr, p->descr) == 0)
            return false;
        q = p;
    }
    // inserisco in fondo
    elem *r = new elem;
    strcpy(r->descr, descr);
    r->preso = false;
    r->pun = nullptr;
    if (p == p0)
        p0 = r;
    else
        q->pun = r;
    return true;
}

ostream& operator<<(ostream& os, const OggettiViaggio& ov) {
    elem *p;
    for (p = ov.p0; p != nullptr; p = p->pun) {
        if (p->preso)
            os << "X ";
        else
            os << "- ";
        os << p->descr;
        os << endl;
    }
    return os;
}

bool OggettiViaggio::prendi(const char* descr) {
    elem *p;
    for (p = p0; p != nullptr && strcmp(descr, p->descr) != 0; p = p->pun);
    if (p == nullptr || p->preso)
        return false;
    p->preso = true;
    return true;
}

void OggettiViaggio::viaggia() {
    for (elem *p = p0; p != nullptr; p = p->pun)
        p->preso = false;
}

OggettiViaggio::OggettiViaggio(const OggettiViaggio& ov) {
    p0 = nullptr;
    // inserisco tutti gli elementi della seconda lista
    for (elem *p = ov.p0; p != nullptr; p = p->pun) {
        aggiungi(p->descr);
        if (p->preso)
            prendi(p->descr);
    }
}

// --- SECONDA PARTE ------------------------------

OggettiViaggio::~OggettiViaggio() {
    elem *p = p0, *q;
    while (p != nullptr) {
        q = p->pun;
        delete p;
        p = q;
    }
}

bool OggettiViaggio::rimuovi(const char* descr) {
    elem *p, *q;
    for (p = p0; p != nullptr && strcmp(descr, p->descr) != 0; p = p->pun)
        q = p;
    if (p == nullptr)
        return false;
    if (p == p0)
        p0 = p0->pun;
    else
        q->pun = p->pun;
    delete p;
    return true;
}

OggettiViaggio& OggettiViaggio::operator+=(const OggettiViaggio& ov) {
    // nel caso A+=A non faccio niente
    if (&ov == this)
        return *this;

    // inserisco tutti gli elementi della seconda lista
    for (elem *p = ov.p0; p != nullptr; p = p->pun) {
        bool aggiunto;
        aggiunto = aggiungi(p->descr);
        if (aggiunto && p->preso)
            prendi(p->descr);
    }

    return *this;
}

OggettiViaggio OggettiViaggio::operator!()const {
    OggettiViaggio ret;
    for (elem *p = p0; p != nullptr; p = p->pun)
        if (!p->preso)
            ret.aggiungi(p->descr);
    return ret;
}