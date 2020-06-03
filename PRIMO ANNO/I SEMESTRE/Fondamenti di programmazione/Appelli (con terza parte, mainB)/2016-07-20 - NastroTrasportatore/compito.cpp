
#include "compito.h"
#include <cstring>

NastroTrasportatore::NastroTrasportatore() { 
  _testa = NULL; 
}

NastroTrasportatore::NastroTrasportatore(const NastroTrasportatore &n) {
  _testa = NULL;

  pezzo *ultimo;
  for (pezzo *p = n._testa; p != NULL; p = p->pun) {
    pezzo *q = new pezzo;
    q->id = new char[strlen(p->id) + 1];
    strcpy(q->id, p->id);
    q->controllato = p->controllato;
    q->pun = NULL;

    // inserimento
    if (_testa == NULL)
      _testa = q;
    else
      ultimo->pun = q;

    ultimo = q;
  }
}

void NastroTrasportatore::aggiungi(const char *id) {
  // la stringa ha almeno due caratteri (lettera+cifra)
  if (strlen(id) < 2)
    return;

  // controllo prima lettera
  if (id[0] < 'A' || id[0] > 'Z')
    return;

  // controllo se i restanti caratteri sono cifre
  for (int i = 1; i < strlen(id); i++) {
    if (id[i] < '0' || id[i] > '9')
      return;
  }

  // inserimento in _testa
  pezzo *p = new pezzo;
  p->id = new char[strlen(id) + 1];
  strcpy(p->id, id);
  p->controllato = false;
  p->pun = _testa;
  _testa = p;
}

void NastroTrasportatore::rimuovi() {
  if (_testa == NULL)
    return;

  pezzo *p, *q;
  for (p = _testa; p->pun != NULL; p = p->pun)
    q = p;

  // controllo se la lista contiene un solo elemento
  if (p == _testa)
    _testa = NULL;
  else
    q->pun = NULL;

  delete[] p->id;
  delete p;
}

ostream &operator<<(ostream &os, const NastroTrasportatore &n) {
  if (n._testa == NULL)
    os << "<vuoto>";
  else {
    for (pezzo *p = n._testa; p != NULL; p = p->pun) {
      if (p != n._testa)
        os << "=";

      os << "(" << p->id;
      if (p->controllato)
        os << "*";

      os << ")";
    }
  }
  return os;
}



// --- SECONDA PARTE ---

void NastroTrasportatore::controlla(unsigned int i) {
  // controllo validita' indice e caso lista vuota
  if (i < 1 || _testa == NULL)
    return;

  // caso particolare: controllo del primo elemento
  if (i == 1) {
    _testa->controllato = true;
    return;
  }

  unsigned int c = 1;
  pezzo *p = _testa;
  pezzo *q = p;
  pezzo *r;
  while (p != NULL && c < i) {
    r = q; // r rimane due passi indietro a p
    q = p; // q rimane un passo indietro a p
    p = p->pun;
    c++;
  }

  // ho raggiunto la fine della lista
  // (non esiste l'i-esimo pezzo)
  if (p == NULL)
    return;

  // controlla se pezzo gia' controllato
  if (p->controllato)
    return;

  p->controllato = true;

  // caso particolare: sono sul secondo elemento e lo
  // devo spostare in testa
  if (r == q) {
    _testa->pun = p->pun;
    p->pun = _testa;
    _testa = p;
  } else {
    q->pun = p->pun;
    r->pun = p;
    p->pun = q;
  }
}

NastroTrasportatore::operator int() const {
  unsigned int ret = 0;
  for (pezzo *p = _testa; p != NULL; p = p->pun) {
    if (p->controllato)
      ret++;
  }
  return ret;
}

NastroTrasportatore::~NastroTrasportatore() {
  while (_testa != NULL) {
    pezzo *p = _testa;
    _testa = _testa->pun;
    delete[] p->id;
    delete p;
  }
} 

