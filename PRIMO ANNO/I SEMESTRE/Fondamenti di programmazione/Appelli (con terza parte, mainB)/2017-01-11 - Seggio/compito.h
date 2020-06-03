#include <iostream>
#include <cstring>
using namespace std;
enum voto {favorevole, contrario};

struct utente{
  int id;
  utente* pun;
};


class Seggio{
  utente* codaElettori;
  utente* codaVotanti;
  int quantiE;
  int quantiV;
  int favorevoli;
  int contrari;
  
  friend ostream& operator<<(ostream&, const Seggio&);
public:
  Seggio();
  bool nuovoElettore(int);
  // --- SECONDA PARTE ---
  bool nuovoVoto(voto);
  bool spoglioDeiVoti();
  ~Seggio();
};
