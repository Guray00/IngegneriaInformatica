#include "compito.h"

// funzione di utilita'
int ContenitoreDVD::char2int(char g){	
	switch (g){
		case 'D': return 1;
		case 'V': return 2;
		default:  return -1;
	}
}

// PRIMA PARTE
ContenitoreDVD::ContenitoreDVD(){	
    primo=ultimo=NULL;
    quanti[0]=quanti[1]=quanti[2]=0;
}

void ContenitoreDVD::inserisci(int n){
	if (n<0)
		return;
	elem *q=new elem;
	q->genere=n;
	q->pun=NULL;
	quanti[n]++;
	if (ultimo==NULL)
		primo=ultimo=q;
	else{
		ultimo->pun=q;
		ultimo=q;
	}
}



bool ContenitoreDVD::masterizza(char g){
    int ig=char2int(g);	
	if ( ( ig > 0 ) && quanti[0]){
		elem *q=primo;
		while(q->genere)
			q=q->pun;
		q->genere=ig;
		quanti[0]--;
		quanti[ig]++;
		return true;
	}else
		return false;
}

ostream & operator <<(ostream &os, const ContenitoreDVD &p){
	elem *q=p.primo;
	os<<'[';
	while(q != NULL){		
		switch (q->genere){
			case 1:
				os<<'D';
				break;
			case 2:
				os<<'V';
				break;
			default:
				os<<'-';				
		}
		q=q->pun;
	}
	os<<']';
    return os;
}

// SECONDA PARTE
void ContenitoreDVD::elimina(int n){
	if (quanti[n]){
		quanti[n]--;
		if (primo==ultimo){
			delete primo;
			primo=ultimo=NULL;
			return;
		}
		elem *p, *q = primo;
		while (q->genere!=n){
			p=q;
			q=q->pun;
		}
		if (q==primo)
			primo=primo->pun;
		else
			p->pun=q->pun;
		if (q==ultimo)
			ultimo=p;
		delete q;
	}
}


int ContenitoreDVD::operator%(char g){
	int ig=char2int(g);
	if ( ig > 0 )
		return quanti[ig];
	else
		return 0;
}

ContenitoreDVD::ContenitoreDVD(const ContenitoreDVD &d){
	for(int i = 0; i< 3; i++)
		quanti[i]=d.quanti[i];
	primo=ultimo=NULL;
	if (d.primo!=NULL){
		primo = new elem;
		primo->genere = d.primo->genere;
		elem *p = d.primo->pun, *q = primo;
		while(p!=NULL){
			q->pun = new elem;
			q = q->pun;
			q->genere = p->genere;
			p=p->pun;
		}
		q->pun = NULL;
		ultimo = q;
	}
}

ContenitoreDVD::~ContenitoreDVD(){
	elem *q = primo;
	while (primo != NULL){
		primo = primo->pun;
		delete q;
		q = primo;
	}	
}


