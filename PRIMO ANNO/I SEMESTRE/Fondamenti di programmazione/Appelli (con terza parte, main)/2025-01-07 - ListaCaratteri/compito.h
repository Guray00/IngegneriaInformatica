#include <iostream>
using namespace std;

struct Node{
    char data;
    Node* next;
};

class ListaCaratteri{
    Node* head;
    void inserisciFine(char value);
    void inserisciInizio(char value);
    bool rimuoviCarattere(char value);
    bool rimuoviTutti(char value);
    static bool controllaSottostringa(const Node* mainList, const Node* sublist);
    void pulisci();
    ListaCaratteri(const ListaCaratteri& other);

public:
    // PRIMA PARTE
    ListaCaratteri();
    void inserisci(char value, bool coda);
    bool rimuovi(char value, bool tutti);
    friend ostream& operator<<(ostream& os, const ListaCaratteri& list);
    bool controllaPalindroma() const;

    // SECONDA PARTE
    bool operator==(const ListaCaratteri& other) const;
    void operator~();
    bool cercaSottostringa(const ListaCaratteri& sublist) const;
    char* estraiNultimoCarattere(int n);
	~ListaCaratteri();
};