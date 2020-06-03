#include "compito.h"
#include <math.h>

Libretto::Libretto(int N){
   nVoci = ( N <= 0) ? 1: N;
   vett = new riga[nVoci];
   quanteVoci = 0;
}

ostream& operator<<(ostream& os, const Libretto& l){  
  int i;
  for(i = 0; i< l.quanteVoci; i++)
      os << "ESAME" << (i+1) << ": <"<<l.vett[i].id<<","
       <<l.vett[i].voto<<","<<l.vett[i].cfu<< ">" <<endl;
   
  for(; i< l.nVoci; i++)
         os << "ESAME" << (i+1) << ": <>"<<endl;
  return os;
}

bool Libretto::aggiungi(const char*  id, int voto, int cfu){
  if (quanteVoci == nVoci)
    return false;
 
  if ((voto < 18) || ((voto >30) && (voto != 33)))
    return false;
  if ((cfu != 6) && (cfu != 9) && (cfu != 12))
     return false;  
  if (strlen(id)>5)
     return false;
 
  for (int i = 0; i < quanteVoci; i++)
    if (!strcmp(id,vett[i].id))
        return false;

    strcpy(vett[quanteVoci].id,  id);
    vett[quanteVoci].voto = voto;
	vett[quanteVoci].cfu = cfu;
	quanteVoci++;
 }

double Libretto::media(){
	double sum = 0;
	if (quanteVoci == 0)
       return sum;
    
	for  (int i=0; i<quanteVoci;i++){
		sum+=vett[i].voto;
	}
	double media = sum / quanteVoci;
	return media;
}


// --- SECONDA PARTE ---
  
Libretto& Libretto::operator = (const Libretto& l){
  if (this != &l){
     if (nVoci != l.nVoci){
	    delete [] vett;
	    nVoci = l.nVoci;
	    vett = new riga[nVoci];	
	 }
	 quanteVoci = l.quanteVoci;	
	 for(int i = 0; i < quanteVoci; i++) 
	    vett[i] = l.vett[i];
  }
  return *this;
}


double Libretto::laurea(){
    if (quanteVoci < nVoci) 
		return 0;
	double mediaPonderata;
	double sum=0;
	double  cfuSum=0;
	for  (int i=0; i<quanteVoci;i++){
		sum += vett[i].voto*vett[i].cfu;
		cfuSum += vett[i].cfu;
	}
	mediaPonderata = sum / cfuSum;
	double votoPartenza = (mediaPonderata*3) + 22;
	return votoPartenza;	
}

Libretto::~Libretto(){
  delete []vett;
}


