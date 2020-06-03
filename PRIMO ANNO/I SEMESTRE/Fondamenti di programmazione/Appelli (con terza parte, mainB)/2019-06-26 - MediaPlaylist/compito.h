#include <iostream>
#include <cstring>

using namespace std;

const int TITLEN = 20;
enum Tipo {AUDIO, VIDEO};
typedef char Titolo[TITLEN+1];

struct item {
    Tipo tipo;
    Titolo titolo;
};

struct elem {
    item info;
    elem* next;
};

class MediaPlaylist {
    elem* head;
    
    // funzione di utilita'
    void inserisciInTesta(const char* , Tipo);
    
public:
    MediaPlaylist();
    void inserisci(const char*, Tipo);
    void elimina(const char*, Tipo);
    friend ostream& operator <<(ostream& os, const MediaPlaylist& pl);
    
    // SECONDA PARTE
    MediaPlaylist(item*, int);
    MediaPlaylist(const MediaPlaylist&);
    int riproduci(const char*, Tipo&)const;
    ~MediaPlaylist();
};


