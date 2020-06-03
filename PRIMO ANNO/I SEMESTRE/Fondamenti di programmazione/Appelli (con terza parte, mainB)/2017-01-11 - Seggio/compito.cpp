#include "compito.h"

// --- PRIMA PARTE ---
Seggio::Seggio(){
    codaElettori = NULL;
    quantiE = 0;
    codaVotanti = NULL;
    quantiV = 0;
    favorevoli = 0;
    contrari = 0;
}

ostream& operator<<(ostream& os, const Seggio& s){
         
    os<<"Elettori che hanno votato: "<< s.quantiV << endl;
    utente* q = s.codaVotanti;
	while(q!=NULL) {
     	os <<"->"<<q->id;
		q = q->pun;
    }
    os<<endl<<"Elettori in coda: "<<s.quantiE<<endl;

  return os;
}


bool Seggio::nuovoElettore(int i){
	utente *q, *p;
    for(q = codaElettori; (q!=NULL) && (q->id != i); q = q->pun)
	   p = q;
 
	if (q!= NULL) 
        return false;
          
    utente* r = new utente;
   	r ->id = i;
    r -> pun = NULL;
    quantiE++;
          
    if (q==codaElettori)
		codaElettori= r;
    else 
		p->pun = r;
     
    return true;
}




// --- SECONDA PARTE ---

bool Seggio::nuovoVoto(voto v){
	if (codaElettori==NULL)
		return false;
	
	utente* p = codaElettori;
	codaElettori = codaElettori->pun;
	p->pun = NULL;
	quantiE--;
	quantiV++;

    utente* q, *r;    
    for(q = codaVotanti; q!=NULL ; q = q->pun)
        r=q;
     
    if (q==codaVotanti) 
	   codaVotanti = p;  
    else
        r->pun = p;

    if(v == favorevole) 
		favorevoli++;
    else 
		contrari++;
   
	return true;
}

bool Seggio::spoglioDeiVoti(){
	if (codaElettori!=NULL) {
            cout<<"Spoglio impossibile!"<<endl;
            return false;
	}
	cout<<"Favorevoli: "<<favorevoli<<endl;
    cout<<"Contrari: "<<contrari<<endl;
    cout<<"Vittoria dei "<<((favorevoli>contrari)?"favorevoli!":"contrari!")<<endl;
	return true;
}


Seggio::~Seggio(){
  utente* p = codaElettori;
  utente* r; 
  while( p != NULL ){
    r = p;
    p = p->pun;
    delete r;
  }
  p = codaVotanti;
  while( p != NULL ){
    r = p;
    p = p->pun;
    delete r;
  }
}



