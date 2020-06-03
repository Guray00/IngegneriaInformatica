#include "compito.h"

using namespace std;

SongPlaylist::SongPlaylist(){
   // crea una playlist vuota, con nessuna canzone in riproduzione
   s = ripr = NULL;
   ripr_sec = 0;
}

void SongPlaylist::aggiungi(const char* titolo, const char* album, const char* artista, int durata){
   if(!titolo || !album || !artista || durata < 0)
      return;
   // crea la nuova canzone
   Song* n = new Song;
   strncpy(n->titolo, titolo, 50);
   n->titolo[50] = '\0';
   strncpy(n->album, album, 50);
   n->album[50] = '\0';
   strncpy(n->artista, artista, 50);
   n->artista[50] = '\0';
   n->durata = durata;
   n->pun = NULL;
   // aggiungila in testa e mandala in riproduzione se la playlist e' vuota
   if(s == NULL){
      s = ripr = n;
      ripr_sec = 0;
      return;
   }
   // altrimenti, aggiungila in coda
   Song* ultima;
   for(ultima = s; ultima->pun != NULL; ultima = ultima->pun);
   ultima->pun = n;
}

void SongPlaylist::play(int secondi){
   if(s == NULL || secondi < 0)
      return;
   // fai avanzare la riproduzione di 'secondi'
   ripr_sec += secondi;
   // se la canzone in riproduzione e' finita, passa alle canzoni successive
   while(ripr_sec >= ripr->durata){
      ripr_sec -= ripr->durata;
      ripr = ripr->pun;
      // considera la playlist ciclica
      if(ripr == NULL)
         ripr = s;
   }
}

ostream& operator<<(ostream& os, const SongPlaylist& sp){
   for(Song* p = sp.s; p != NULL; p = p->pun){
      if(p == sp.ripr)
         os << ">[" << sp.ripr_sec / 60 << ':' << sp.ripr_sec % 60 << ']';
      os << p->titolo << '-' << p->album << '-' << p->artista << '-' << p->durata << endl;
   }
   return os;
}

void SongPlaylist::elimina(const char* titolo, const char* album, const char* artista){
   if(!titolo || !album || !artista)
      return;

   // cerca la prima occorrenza della canzone
   Song* p;
   Song* q = NULL;
   for(p = s; p != NULL; p = p->pun){
      if(strcmp(p->titolo, titolo) == 0 && strcmp(p->album, album) == 0 && strcmp(p->artista, artista) == 0)
         break;
      q = p;
   }

   if(p == NULL) // caso canzone assente
      return;

   if(p == s){ // caso eliminazione in testa
      s = s->pun;
      // se la canzone da eliminare e' in riproduzione, manda in riproduzione la successiva
      if(ripr == p){
         ripr = s;
         ripr_sec = 0;
      }
      delete p;
      return;
   }
   // caso eliminazione non in testa
   q->pun = p->pun;
   // se la canzone da eliminare e' in riproduzione, manda in riproduzione la successiva
   if(ripr == p){
      ripr = q->pun;
      ripr_sec = 0;
   }
   delete p;
}

SongPlaylist& SongPlaylist::operator+=(const SongPlaylist& sp){
   // copia tutte le canzoni della seconda playlist nella lista 'copia', 
   // senza modificare la prima playlist (per gestire caso a+=a)
   Song* copia = NULL;
   Song* p2;
   for(Song* p = sp.s; p != NULL; p = p->pun){
      if(copia == NULL){ // caso inserimento in testa
         copia = new Song;
         p2 = copia;
      }
      else{ // caso inserimento in coda
         p2->pun = new Song;
         p2 = p2->pun;
      }
      // copia una canzone della seconda playlist in fondo alla lista 'copia'
      strcpy(p2->titolo, p->titolo);
      strcpy(p2->album, p->album);
      strcpy(p2->artista, p->artista);
      p2->durata = p->durata;
      p2->pun = NULL;
   }

   // identifica l'ultima canzone della prima playlist
   Song* ultima = NULL;
   for(Song* p = s; p != NULL; p = p->pun)
      ultima = p;
   // concatena la lista 'copia' alla fine della prima playlist
   if(ultima == NULL)
      ultima = copia;
   else
      ultima->pun = copia;

   return *this;
}

SongPlaylist::operator int()const{
   if(s == NULL)
      return 0;
   int tot_sec = 0;
   // somma la durata di tutte le canzoni fino a quella in riproduzione
   for(Song* p = s; p != ripr; p = p->pun)
      tot_sec += p->durata;
   // somma i secondi riprodotti della canzone in riproduzione
   tot_sec += ripr_sec;
   return tot_sec;
}

SongPlaylist::~SongPlaylist(){
   // elimina tutte le canzoni
   Song* p = s;
   while(p != NULL){
      Song* q = p;
      p = p->pun;
      delete q;
   }
}
