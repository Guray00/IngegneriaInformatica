#include "compito.h"

// Costruttore di default di ListaCaratteri
ListaCaratteri::ListaCaratteri() : head(nullptr) {}


ostream& operator<<(ostream& os, const ListaCaratteri& list) {
    const Node* temp = list.head;
    while (temp != nullptr) {
        os << temp->data << " -> ";
        temp = temp->next;
    }
    os << "@";
    return os;
}

// Costruttore di copia di ListaCaratteri, usato come funzione di appoggio
// per la funzione controllaPalindromo
ListaCaratteri::ListaCaratteri(const ListaCaratteri& other) : head(nullptr) {
    if (other.head == nullptr) {
        return;
    }
    const Node* current = other.head;
    while (current != nullptr) {
        inserisciFine(current->data);
        current = current->next;
    }
}

// Operatore di negazione bit a bit, usato per invertire l'ordine degli elementi
// della lista
void ListaCaratteri::operator~() {
    Node* prev = nullptr;
    Node* current = head;
    Node* next = nullptr;

    while (current != nullptr) {
        next = current->next;
        current->next = prev;
        prev = current;
        current = next;
    }
    head = prev;
}

// Metodo per inserire un carattere in testa o in coda alla lista
// utiliza due funzioni di appoggio distinte per l'inserimento in testa
// e in coda
void ListaCaratteri::inserisci(const char value, const bool coda)
{
    if(coda) inserisciFine(value);
    else inserisciInizio(value);
}

// Funzione di appoggio per l'inserimento in coda di un carattere nella lista
void ListaCaratteri::inserisciFine(const char value) {
    Node* newNode = new Node;
    newNode->next = nullptr;
    newNode->data = value;
    if (head == nullptr) {
        head = newNode;
    } else {
        Node* temp = head;
        while (temp->next != nullptr) {
            temp = temp->next;
        }
        temp->next = newNode;
    }
}

// Funzione di appoggio per l'inserimento in testa di un carattere nella lista
void ListaCaratteri::inserisciInizio(const char value) {
    Node* newNode = new Node;
    newNode->next = nullptr;
    newNode->data = value;
    if (head == nullptr) {
        head = newNode;
    } else {
        newNode->next = head;
        head = newNode;
    }
}

// Metodo per rimuovere un carattere dalla lista, utilizza due funzioni di appoggio
// distinte per la rimozione di un singolo carattere e per la rimozione di tutti i caratteri
bool ListaCaratteri::rimuovi(const char value, const bool tutti)
{
    if(tutti) return rimuoviTutti(value);
    return rimuoviCarattere(value);
}

// Funzione di appoggio per la rimozione di un singolo carattere dalla lista
bool ListaCaratteri::rimuoviCarattere(const char value) {
    if (head == nullptr) return false;
    bool found = false;
    if (head->data == value) {
        const Node* temp = head;
        head = head->next;
        delete temp;
        found=true;
    }

    Node* current = head;
    while (current->next != nullptr && current->next->data != value) {
        current = current->next;
    }

    if (current->next != nullptr) {
        const Node* temp = current->next;
        current->next = temp->next;
        delete temp;
        found = true;
    }
    return found;
}

// Funzione di appoggio per la rimozione di tutti i caratteri uguali a `value` dalla lista
bool ListaCaratteri::rimuoviTutti(char value) {
    if (head == nullptr) return false;
    bool found = false;

    while (head != nullptr && head->data == value) {
        const Node* temp = head;
        head = head->next;
        delete temp;
        found=true;
    }

    if(head == nullptr)
        return found;


    Node* prev = head;
    Node* search = prev->next;

    while(search != nullptr) {
        // test di corrispondenza
        if(search->data == value) {
            const Node* tmp = search;

            prev->next = search->next;

           search = prev->next;
           delete tmp;
           found = true;
        } else {
            // avanza
            prev = search;
            search = search->next;
        }
    }

    return found;
}

// Metodo per estrarre l'ennesimo carattere dalla lista a partire dal fondo
char* ListaCaratteri::estraiNultimoCarattere(int n) {
    if (head == nullptr || n <= 0) {
        return nullptr;
    }

    // Inizializziamo due puntatori alla testa della lista
    const Node* current = head;
    Node* nBehind = head;
    Node* prev = nullptr;

    // Avanziamo il puntatore `current` di `n` posizioni in avanti
    for (int i = 0; i < n; i++) {

        // La lista e' piÃ¹ corta di `n` elementi, ritorniamo nullptr
        if (current == nullptr) {
            return nullptr;
        }
        current = current->next;
    }

    // Avanziamo i due puntatori finche' `current` non arriva alla fine della lista
    // e dunque `nBehind` sarÃ  `n` posizioni indietro rispetto a `current`
    while (current != nullptr) {
        current = current->next;
        prev = nBehind;
        nBehind = nBehind->next;
    }

    // Rimuoviamo l'elemento `nBehind` dalla lista
    if (prev == nullptr) {
        // Se `prev` e' nullptr, allora `nBehind` e' il primo elemento della lista, aggiorniamo la testa
        head = nBehind->next;
    } else {
        prev->next = nBehind->next;
    }

    // Salviamo il carattere estratto tramite un puntatore a char
    char* c = new char(nBehind->data);

    // Eliminiamo il nodo estratto dalla memoria
    nBehind->next = nullptr;
    delete(nBehind);

    return c;
}

// Operatore di confronto tra due liste di caratteri
bool ListaCaratteri::operator==(const ListaCaratteri& other) const {
    const Node* current1 = head;
    const Node* current2 = other.head;

    // Finche' entrambe le liste non sono terminate, confrontiamo i caratteri
    while (current1 != nullptr && current2 != nullptr) {

        // Se i caratteri nella stessa posizione non corrispondono, le liste non sono uguali
        if (current1->data != current2->data) {
            return false;
        }
        current1 = current1->next;
        current2 = current2->next;
    }

    // Le liste sono uguali se entrambe sono terminate contemporaneamente
    return current1 == nullptr && current2 == nullptr;
}


// Metodo per controllare se la lista e' palindroma
bool ListaCaratteri::controllaPalindroma() const {
    // Creiamo una copia della lista originale
    ListaCaratteri copyList(*this);

    // Invertiamo la lista copiata usando l'operatore ~
    ~copyList;  // Reverse the copied list using the ~ operator

    // Confrontiamo la lista originale con la copia invertita
    return *this == copyList;  // Compare the original list with the reversed copy
}

bool ListaCaratteri::cercaSottostringa(const ListaCaratteri& sublist) const {
    if (sublist.head == nullptr) return true;

    const Node* current = head;
    while (current != nullptr) {
        if (controllaSottostringa(current, sublist.head)) {
            return true;
        }
        current = current->next;
    }
    return false;
}


bool ListaCaratteri::controllaSottostringa(const Node* mainList, const Node* sublist)
{
    while (sublist != nullptr) {
        if (mainList == nullptr || mainList->data != sublist->data) {
            return false;
        }
        mainList = mainList->next;
        sublist = sublist->next;
    }
    return true;
}

// Funzione di appoggio per il distruttore di ListaCaratteri
void ListaCaratteri::pulisci() {
    Node* current = head;
    while (current != nullptr) {
        Node* temp = current;
        current = current->next;
        delete temp;
    }
    head = nullptr;
}

// Distruttore di ListaCaratteri
ListaCaratteri::~ListaCaratteri() {
    pulisci();
}


