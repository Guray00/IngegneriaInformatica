#include "compito.h"
#include <iostream>

inline bool Battaglia::nonvalido(int v) {
	if ((v < 0) || (v >= m))
		return true;
	return false;
}
Battaglia::Battaglia(int m1, int n1){
  m = (m1 < 0) ? 4 : m1;
  n = (n1 < 0) ? 2 : n1;
  p = new int[m*m];
  for (int i=0; i<m*m; i++)
    p[i] = 0;
}

bool Battaglia::aggiungi(int x1, int y1, int x2, int y2, int id ){
  if( id <= 0 || id > n )  
    return false;
  
	if (nonvalido(x1) || nonvalido(y1) || nonvalido(x2) || nonvalido(y2))
		return false;
  
	if ( (x1 > x2) || (y1 > y2) )
		return false;

	for (int i = x1; i <= x2; i++)
		for (int j = y1; j <= y2; j++)
			if (p[i*m + j] != 0)
			  return false;

	for (int i = x1; i <= x2; i++)
		for (int j = y1; j <= y2; j++)
			p[i*m + j] = id;

    return true;
}

bool Battaglia::fuoco(int x, int y){
  if (nonvalido(x) || nonvalido(y))
    return false;
     
  if( p[x*m + y] > 0 ){
    // Aggiorno solo se la nave non e' stata colpita
    p[x*m + y] = -p[x*m + y];
    return true;
  }else
    return false;
}


ostream & operator<<(ostream & os, const Battaglia & b){
  for (int i = 0; i < b.m; i++){
    for (int j = 0; j < b.m; j++)
      os<<b.p[i*b.m+j]<<' ';
    os<<endl;
  }
  return os;
}

bool Battaglia::operator+=(const Battaglia & bn){
  // Controllo se la dimension o il numero di giocatori non coincide
  if ( (bn.m != m) || (bn.n != n) )    
     return false;
  // Controllo eventuali conflitti
  for( int i = 0; i < m*m ; ++i ){
    if( p[i] != 0 && bn.p[i] != 0 )
      return false;
  }
  // Unisci i campi
  for( int i = 0; i < m*m ; ++i )
    if(bn.p[i] != 0)
      p[i] = bn.p[i];    
  return true;
}

bool Battaglia::operator==(int id){
  for( int i = 0; i < m*m ; ++i )
    if( p[i] == id )      
      return true;
  return false;
}