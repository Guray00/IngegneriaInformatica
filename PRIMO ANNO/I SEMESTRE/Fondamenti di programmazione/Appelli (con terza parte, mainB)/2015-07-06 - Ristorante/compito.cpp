#include "compito.h"

// FUNZIONE DI UTILITA' che prova a fare accomodare i gruppi gruppi
// in attesa per i quali ci sono sufficienti posti liberi, partendo 
// dai gruppi arrivati prima (si tratta di estrazioni in testa multiple)
void Ristorante::estraiDallaTesta(){
  while (testa != NULL && liberi - testa->num >= 0)
  {
    gruppo* p = testa;
    testa = p->succ;
    if (testa == NULL) coda = NULL;
    liberi -= p->num;
    delete p;
  }
}

// --- PRIMA PARTE ---
Ristorante::Ristorante(int N){
  if (N <= 0) 
     N = 10;
  testa = coda = NULL; liberi = N;
}

void Ristorante::aggiungi(const char cg[], int num)
{
  if (testa != NULL || liberi - num < 0)
  {
    gruppo* q = new gruppo;    
    strncpy(q->cognome, cg, DIM-1);
    q->num = num;
    q->succ = NULL;
    if (coda == NULL)
      testa = q;
    else
      coda->succ = q;
    coda = q;
  }
  else liberi -= num;
}


ostream& operator<< (ostream& os, const Ristorante& r)
{
  Ristorante::gruppo *p;
  cout << "Posti liberi " << r.liberi << ", in attesa ";
  if (r.testa == NULL)
    os << "nessuno";
  else
  for (p = r.testa; p != NULL; p = p->succ)
    os << p->cognome << '(' << p->num << ") ";
  os << endl;
  return os;
}


Ristorante& Ristorante::operator-=(int num)
{
  liberi += num;
  estraiDallaTesta();
  return *this;
}


// --- SECONDA PARTE ---

bool Ristorante::rinuncia(const char cg[])
{
  bool trovatoInTesta = false;
  gruppo* p = NULL, *q = NULL;
  for (q = testa; q != NULL && strcmp(q->cognome, cg) != 0; q = q->succ)
    p = q;
  if (q == NULL) return false; //nessun gruppo con cognome uguale a cg
  if (q == testa){ // gruppo trovato in testa
    testa = testa->succ;
    trovatoInTesta = true;
  }
  else
    p->succ = q->succ;
  if (q == coda)
    coda = p;
  delete q;

  // quando si elimina un gruppo in testa occorre controllare 
  // se uno o più dei gruppi successivi possono essere fatti accomodare
  if (trovatoInTesta)    
    estraiDallaTesta();  
                        
  return true;
}


Ristorante::Ristorante(const Ristorante& g)
{
  liberi = g.liberi;
  testa = coda = NULL;
  for (gruppo* p = g.testa; p != NULL; p = p->succ)
  {
    gruppo* q = new gruppo;    
    strcpy(q->cognome, p->cognome);
    q->num = p->num;
    q->succ = NULL;
    if (coda == NULL)
      testa = q;
    else
      coda->succ = q;
    coda = q;
  }
}

Ristorante::~Ristorante(){
  for (gruppo* p = testa; p != NULL; p = testa) {
    testa = p->succ;    
    delete p;
  }
}
