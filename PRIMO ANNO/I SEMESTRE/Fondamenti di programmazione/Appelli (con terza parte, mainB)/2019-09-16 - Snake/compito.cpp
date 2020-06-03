#include "compito.h"

using namespace std;

Snake::Snake(int r, int c){
   // sanitizza gli input
   if(r < 4)
       r = 4;
   if(c < 1)
       c = 1;
   righe = r;
   col = c;
   
   // crea uno schema vuoto
   schema = new int[r*c];
   for(int i = 0; i < righe; i++){
      for(int j = 0; j < col; j++){
         schema[i*col + j] = 0;
      }
   }
    
   // piazza il serpente lungo 4 caselle con la coda nell'angolo sud-ovest e rivolto verso nord
   schema[(righe-1)*col + 0] = 4;
   schema[(righe-2)*col + 0] = 3;
   schema[(righe-3)*col + 0] = 2;
   schema[(righe-4)*col + 0] = 1;
    
   lungh = 4;
   testa_i = righe-4;
   testa_j = 0;
   direzione = 'n';
}

ostream& operator<<(ostream& os, const Snake& s){
   // stampa il limite nord dello schema
   os << '|';
   for(int j = 0; j < s.col; j++)
      os << '-';
   os << '|' << endl;

   // stampa lo schema
   for(int i = 0; i < s.righe; i++){
      os << '|';
      for(int j = 0; j < s.col; j++){
         if(s.schema[i*s.col + j] == 0)
            os << ' '; // stampa una casella vuota
         else if(s.schema[i*s.col + j] == -1)
            os << '*'; // stampa una mela
         else
            os << (char)('0' + (char)s.schema[i*s.col + j]); // stampa il serpente
      }
      os << '|' << endl;
   }
   // stampa il limite sud dello schema
   os << '|';
   for(int j = 0; j < s.col; j++)
      os << '-';
   os << '|' << endl;
   return os;
}

Snake& Snake::muovi(char dir){
    if(dir != 'n' && dir != 's' && dir != 'o' && dir != 'e')
        return *this;
    
    // se la direzione e' opposta a quella attuale, non fa niente
    if((dir == 's' && direzione == 'n') || (dir == 'n' && direzione == 's')
       || (dir == 'e' && direzione == 'o') || (dir == 'o' && direzione == 'e'))
        return *this;

    // indici (i,j) della nuova posizione della testa
    int nuova_testa_i=0, nuova_testa_j=0;
    switch(dir){
    case('n'):
        // controlla che il serpente non vada fuori schema
        if(testa_i == 0)
            return *this;
        nuova_testa_i = testa_i - 1;
        nuova_testa_j = testa_j;
        break;
            
    case('s'):
        // controlla che il serpente non vada fuori schema
        if(testa_i == righe - 1)
            return *this;
        nuova_testa_i = testa_i + 1;
        nuova_testa_j = testa_j;
        break;
            
    case('o'):
        // controlla che il serpente non vada fuori schema
        if(testa_j == 0)
            return *this;
        nuova_testa_i = testa_i;
        nuova_testa_j = testa_j - 1;
        break;
            
    case('e'):
        // controlla che il serpente non vada fuori schema
        if(testa_j == col - 1)
            return *this;
        nuova_testa_i = testa_i;
        nuova_testa_j = testa_j + 1;
        break;
    
    }
    
    // controlla che il serpente non si mangi
    if(schema[nuova_testa_i*col + nuova_testa_j] >= 1)
        return *this;
    // controlla se il serpente sta per mangiare una mela
    bool mela_mangiata = false;
    if(schema[nuova_testa_i*col + nuova_testa_j] == -1)
        mela_mangiata = true;
    
    // aggiorna direzione
    direzione = dir;
    
    // aggiorna posizione testa
    testa_i = nuova_testa_i;
    testa_j = nuova_testa_j;
    
    // fai avanzare la testa nello schema
    schema[nuova_testa_i*col + nuova_testa_j] = 1;
    
   // fai strisciare il resto del corpo
   for(int i = 0; i < righe; i++){
      for(int j = 0; j < col; j++){
         // libera la casella dov'era la coda, a meno che il serpente 
         // non abbia mangiato una mela e possa allungarsi (in questo caso si allunga)
         if(schema[i*col + j] == lungh && !(mela_mangiata && lungh < 9))
            schema[i*col + j] = 0;
         // fai strisciare tutti i segmenti intermedi tra la testa e la coda
         else if(schema[i*col + j] >= 1 && (i != testa_i || j != testa_j))
            schema[i*col + j]++;
      }
   }
   // se il serpente ha mangiato una mela e puo' allungarsi, allungalo
   if(mela_mangiata && lungh < 9)
      lungh++;
    
   return *this;
}

Snake& Snake::mela(int i, int j){
   if(i < 0 || i > righe-1 || j < 0 || j > col-1)
      return *this;
    
   // piazza una mela solo se la casella e' libera
   if(schema[i*col + j] == 0)
      schema[i*col + j] = -1;
   
    return *this;
}

void Snake::inverti() {
    for(int i = 0; i < righe; i++) {
        for(int j = 0; j < col; j++) {
            if(schema[i*col + j] >= 1) {
                schema[i*col + j] = lungh - schema[i*col + j] + 1;
                
                // se questo elemento e' la nuova testa, aggiorna variabili di stato
                if (schema[i*col + j] == 1) {
                    testa_i = i;
                    testa_j = j;
                }
            }
        }
    }
    
   // calcola la direzione della nuova testa in base alla posizione del
   // segmento di serpente successivo alla testa (elemento con valore 2)
   char testa_dir;
   if(testa_i > 0 && schema[(testa_i-1)*col + testa_j] == 2)
      testa_dir = 's';
   else if(testa_i < righe - 1 && schema[(testa_i+1)*col + testa_j] == 2)
      testa_dir = 'n';
   else if(testa_j > 0 && schema[testa_i*col + (testa_j-1)] == 2)
      testa_dir = 'e';
   else //if(testa_j < col - 1 && schema[testa_i*col + (testa_j+1)] == 2)
      testa_dir = 'o';
}


Snake& Snake::operator--(){
   // se il serpente non puo' accorciarsi non fare nulla
   if(lungh <= 4)
      return *this;

   // elimina la coda del serpente
   for(int i = 0; i < righe; i++){
      for(int j = 0; j < col; j++){
         if(schema[i*col + j] == lungh)
            schema[i*col + j] = 0;
      }
   }
   // accorcia il serpente
   lungh--;
   return *this;
}


Snake::~Snake(){
   delete[] schema;
}
