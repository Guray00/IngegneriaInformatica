#include <iostream>
#include <cstring>

using namespace std;

struct Song{
    char titolo[51];
    char album[51];
    char artista[51];
    int durata;
    Song* pun;
};

class SongPlaylist{
    Song* s; // elemento di testa
    Song* ripr; // canzone in riproduzione
    int ripr_sec; // secondi riprodotti
public:
    SongPlaylist();
    void aggiungi(const char*, const char*, const char*, int);
    void play(int);
    friend ostream& operator<<(ostream&, const SongPlaylist&);
    void elimina(const char*, const char*, const char*);
    SongPlaylist& operator+=(const SongPlaylist&);
    operator int()const;
    ~SongPlaylist();
};
