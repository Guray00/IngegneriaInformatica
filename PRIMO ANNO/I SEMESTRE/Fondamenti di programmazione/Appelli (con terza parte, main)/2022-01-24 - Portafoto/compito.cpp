#include <iostream>
#include "compito.h"
using namespace std;

Portafoto::Portafoto(int d) {
	
    // sanitizzazione degli input
    if(dim<=0)
        dim = 3;
	
    dim = d;
    supporto = new foto*[dim];
    for(int i=0; i<dim; ++i)
        supporto[i] = nullptr;
}

ostream& operator<<(ostream& os, const Portafoto& p){
	
    // stampa del supporto
    for(int i=0; i<2*p.dim+1; ++i)
        os<<'_';
    os<<endl;

    // N.B.: la stampa procede una posizione alla volta lungo tutte le colonne

    int num_terminate = 0; // contatore informato di quante colonne sono giÃ  state stampate
    int pos = 1; // la variabile contenente la corrente posizione delle foto che stanno venendo stampate
    bool terminate[p.dim]; // vettore informato di quali colonne la stampa Ã¨ giÃ  terminata

    while(num_terminate!=p.dim){
        num_terminate = 0;
		
        // ciclo che aggiorna l'informazione di terminazione di stampa delle colonne facendo
        // riferimento alla posizione corrente 
        for(int col=1; col<=p.dim; ++col)
            if(p.get_foto(col, pos)==nullptr) {
                terminate[col] = true;
                num_terminate++;
            }
            else
                terminate[col] = false;
        // se tutte le colonne sono state stampate, termina il ciclo di stampa
        if(num_terminate==p.dim)
            break;

        // porzione di codice per la stampa delle due stanghette | e dell'asterisco *
        // esegue per ogni colonna (mantenendo fissa la posizione)
        for(int j=1; j<=3; ++j) {
            for (int col=1; col <= p.dim; ++col) {
                if (!terminate[col])
                    if (j < 3)
                        os << " |";
                    else
                        os << " *";
                else
                    os << "  ";
            }
            os << endl;
        }
	// incremento della posizione di stampa
        pos++;
    }

    // Idea per la stampa delle associazioni: scorro tutte le foto e quando
    // ne trovo una che Ã¨ associata ad un'altra (ovvero il puntatore ass non Ã¨ null)
    // "entro" in quella associata e ne stampo la posizione

    os<<"Associazioni:"<<endl;
    pos = 1;
    Portafoto::foto* q = nullptr;
    for(int col=1; col<=p.dim; ++col) {
        pos = 1;
        q = p.get_foto(col, pos);
        while(q!=nullptr){
            if(q->ass!=nullptr)
                os<<'('<<col<<','<<pos<<") -> ("<<q->ass->col<<','<<q->ass->pos<<')'<<endl;
            q = q->next;
            pos++;
        }
    }

    return os;
}

// funzione di utilitÃ  che restituisce un puntatore alla foto posizione pos lungo la colonna col
// in caso non sia presente, restituisce nullptr
Portafoto::foto* Portafoto::get_foto(int col, int pos) const { //non controlla input
    foto* p = supporto[--col];
    for(int posizione=1; p!= nullptr && posizione<pos; ++posizione)
        p = p->next;

    return p;
}

// funzione di utilitÃ  che incrementa di 1 l'informazione riguardo la posizione della 
// foto puntata da p e di tutte le sue successive lungo la relativa colonna 
void Portafoto::incrementa_posizioni(foto *p) {
    while(p!=nullptr){
        p->pos++;
        p=p->next;
    }
}

// funzione di utiliÃ  che esegue l'esatto opposto della precedente, ovvero decrementa
// l'informazione di posizione di *p e di tutte le sue successive
void Portafoto::decrementa_posizioni(foto *p) {
    while(p!=nullptr){
        p->pos--;
        p=p->next;
    }
}

// funzione che elimina l'associazione di tutte le foto nel Portafoto con quella
// salvata all'indirizzo indirizzo_foto
void Portafoto::deassocia(const foto* indirizzo_foto) {
    foto* p = nullptr;
    for(int i=0; i<dim; ++i){
        p = supporto[i];
        while(p!=nullptr){
            if(p->ass==indirizzo_foto)
                p->ass = nullptr;
            p = p->next;
        }
    }
}

bool Portafoto::aggiungi(int col, int pos) {
    // posizione non valida
    if(pos<=0 || col<=0 || col>dim)
        return false;

    // inserimento in testa
    if(pos==1){
        foto* f = new foto();
        f->col = col;
        f->pos = pos;
        f->ass = nullptr;
        f->next = supporto[col-1];
        supporto[col-1] = f;
        incrementa_posizioni(f->next);

        return true;
    }

    //inserimento generico
    foto* p = get_foto(col, pos-1);
    if(p==nullptr)
        return false;

    foto* f = new foto();
    f->col = col;
    f->pos = pos;
    f->ass = nullptr;
    f->next = p->next;
    p->next = f;
    incrementa_posizioni(f->next);

    return true;
}

bool Portafoto::associa(int col, int pos, int col_ass, int pos_ass) {

    // posizione non valida
    if(pos<=0 || col<=0 || col>dim || pos_ass<=0 || col_ass<=0 || col_ass>dim)
        return false;

    foto* f = get_foto(col, pos);
    if(f==nullptr)
        return false;

    f->ass = get_foto(col_ass, pos_ass);
    if(f->ass==nullptr)
        return false;

    return true;
}

bool Portafoto::elimina(int col, int pos){
    // posizione non valida
    if(pos<=0 || col<=0 || col>dim || (pos==1 && supporto[col-1]==nullptr))
        return false;

    // eliminazione in testa
    if(pos==1){
        foto* p = supporto[col-1];
        supporto[col-1] = p->next;
        deassocia(p);
        delete p;
        decrementa_posizioni(supporto[col-1]);

        return true;
    }

    //eliminazione generica
    foto* p = get_foto(col, pos-1);
    if(p->next==nullptr)
        return false;

    foto*q = p->next;
    p->next = p->next->next;
    deassocia(q);
    delete q;
    decrementa_posizioni(p->next);

    return true;
}

void Portafoto::dealloca() {
    foto* p = nullptr;
    for(int i=0; i<dim; ++i)
        while(supporto[i]!= nullptr){
            p = supporto[i];
            supporto[i] = p->next;
            delete p;
        }
    delete[] supporto;
}

Portafoto& Portafoto::operator=(const Portafoto &p){
    if(this==&p)
        return *this;

    dealloca();
    dim = p.dim;
    supporto = new foto*[dim];
    for(int i=0; i<dim; ++i)
        supporto[i] = nullptr;

    foto* q = nullptr;
    int pos = 1;

    // popolazione del nuovo Portafoto
    for(int col=1; col<=dim; ++col) {
        q = p.supporto[col-1];
        pos = 1;
        while(q!=nullptr) {
            this->aggiungi(col, pos++);
            q = q->next;
        }
    }

    foto* qq = nullptr;
    // Associazione del nuovo Portafoto
    for(int col=1; col<=dim; ++col) {
        q = p.supporto[col-1];
        pos = 1;
        while(q!=nullptr) {
            qq = p.get_foto(col, pos);
            if(qq->ass!=nullptr){
                this->associa(col, pos, qq->ass->col, qq->ass->pos);
            }
            q = q->next;
            pos++;
        }
    }

    return *this;
}