#include "compito.h"
#include <cstring>

History::History()
{
    head = nullptr;
}

void History::record(int year, const char* descr)
{
    if (strlen(descr) < 1 || strlen(descr) > MAX_CHARS)
        return;

    // creazione del nuovo elemento da inserire
    elem* r = new elem;
    r->year = year;
    strcpy(r->descr, descr);

    // inserimento in ordine di anno, o in ordine di inserimento a parità di anno
    elem* p;
    elem* q;
    for(q = head; q != nullptr && q->year <= year; q = q->next)
        p = q;
    if(q == head)
    {
        // inserimento in testa:
        head = r;
        r->next = q;
    }
    else
    {
        // inserimento dopo la testa:
        p->next = r;
        r->next = q;
    }
}

void History::forget(const char* descr)
{
    elem* p;
    elem* q;
    for(q = head; q != nullptr && strcmp(q->descr, descr) != 0; q = q->next)
        p = q;
    if(q == nullptr) // evento non presente:
        return;
    if(q == head) // cancellazione in testa:
        head = q->next;
    else // cancellazione dopo la testa:
        p->next = q->next;

    delete q;
}

ostream& operator<<(ostream& os, const History& hist)
{
    os << "-- HISTORY --" << endl;
    for(elem* p = hist.head; p != nullptr; p = p->next)
    {
        if(p->year <= 0)
            os << -p->year+1 << " BC" << endl;
        else
            os << p->year << " AD" << endl;
        os << p->descr << endl;
        os << "-----" << endl;
    }
    return os;
}

History::~History()
{
    // partendo dalla testa, eliminazione di tutti gli elementi
    while (head != NULL)
    {
        elem* p = head;
        head = head->next;
        delete p;
    }
}

// SECONDA PARTE
int History::longest_period()const
{
    if(head == nullptr || head->next == nullptr)
        return -1;
    int max_period = 0;
    for(elem* p = head; p->next != nullptr; p = p->next)
    {
        int period = p->next->year - p->year;
        if(period > max_period)
            max_period = period;
    }
    return max_period;
}

void History::forget(int from_year, int to_year)
{
    elem* p;
    elem* q;
    // posizionamento di q sul primo evento da cancellare, o su nullptr se tale evento non esiste:
    for(q = head; q != nullptr && q->year < from_year; q = q->next)
        p = q;
    // cancellazione di tutti gli eventi da q fino all'anno to_year compreso:
    while(q != nullptr && q->year <= to_year)
    {
        if(q == head){
            // cancellazione in testa:
            head = q->next;
            delete q;
            q = head;
        }
        else{
            // cancellazione dopo la testa:
            p->next = q->next;
            delete q;
            q = p->next;
        }
    }
}

History* create_alternative(const History& hist1, int fork_year, const History& hist2)
{
    History* ret = new History;
    elem* p_ret = nullptr;
    // copia degli eventi <= fork_year da hist1 a ret:
    for(elem* p1 = hist1.head; p1 != nullptr && p1->year <= fork_year; p1 = p1->next)
    {
        elem* r = new elem;
        r->year = p1->year;
        strcpy(r->descr, p1->descr);
        r->next = nullptr;
        if(p_ret == nullptr) // inserimento in testa:
            ret->head = r;
        else // inserimento dopo la testa:
            p_ret->next = r;
        p_ret = r;
    }
    // copia degli eventi > fork_year da hist2 a ret:
    for(elem* p2 = hist2.head; p2 != nullptr; p2 = p2->next)
    {
        if(p2->year > fork_year)
        {
            elem* r = new elem;
            r->year = p2->year;
            strcpy(r->descr, p2->descr);
            r->next = nullptr;
            if(p_ret == nullptr) // inserimento in testa:
                ret->head = r;
            else // inserimento dopo la testa:
                p_ret->next = r;
            p_ret = r;
        }
    }
    return ret;
}