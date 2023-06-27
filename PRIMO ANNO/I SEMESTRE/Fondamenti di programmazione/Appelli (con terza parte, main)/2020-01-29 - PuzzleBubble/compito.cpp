#include "compito.h"

// --- PRIMA PARTE ------------------------------

PuzzleBobble::PuzzleBobble(){
   for(int i = 0; i < HEIGHT; i++){
      for(int j = 0; j < WIDTH; j++)
         tiles[i][j] = ' ';
   }
}

PuzzleBobble& PuzzleBobble::fire(int column, char color){
   // gestisco input non valido
   if(column < 0 || column >= WIDTH)
      return *this;
   if(color != 'R' && color != 'B' && color != 'G' && color != 'Y')
      return *this;

   // se non c'e' spazio per inserire la bolla, non faccio niente
   if(tiles[HEIGHT-1][column] != ' ')
      return *this;

   // inserisco la bolla nell'ultima casella libera a partire dal basso
   int row;
   for(row = HEIGHT-2; row >= 0; row--){
      if(tiles[row][column] != ' ')
         break;
   }
   row++;
   tiles[row][column] = color;

   // FUNZIONALITA' SECONDA PARTE:
   // se le bolle da scoppiare sono 3 o piu', le scoppio
   int count = count_bubbles(row, column, false);
   if(count >= 3)
      count_bubbles(row, column, true);

   return *this;
}

PuzzleBobble::operator int()const{
   for(int i = HEIGHT-1; i >= 0; i--){
      for(int j = 0; j < WIDTH; j++){
         if(tiles[i][j] != ' ' && tiles[i][j] != '=')
            return i+1;
      }
   }
   return 0;
}

ostream& operator<<(ostream& os, const PuzzleBobble& pb){
   for(int j = 0; j < WIDTH+2; j++)
      os << '=';
   os << endl;
   for(int i = 0; i < HEIGHT; i++){
      os << '|';
      for(int j = 0; j < WIDTH; j++)
         os << pb.tiles[i][j];
      os << '|' << endl;
   }
   for(int j = 0; j < WIDTH+2; j++)
      os << '=';
   os << endl;
   return os;
}

// --- SECONDA PARTE ------------------------------

int PuzzleBobble::count_bubbles(int row, int column, bool pop_them){
   char color = tiles[row][column];
   int count = 1;
   if(pop_them)
      tiles[row][column] = ' ';

   // conto/scoppio le bolle contigue verso l'alto
   for(int i = row-1; i >= 0; i--){
      if(tiles[i][column] == color){
         count++;
         if(pop_them)
            tiles[i][column] = ' ';
      }
      else
         break; // non ci sono piu' bolle contigue
   }
   
   // conto/scoppio le bolle contigue verso sinistra
   for(int j = column-1; j >= 0; j--){
      if(tiles[row][j] == color){
         count++;
         if(pop_them)
            tiles[row][j] = ' ';
      }
      else
         break; // non ci sono piu' bolle contigue
   }

   // conto/scoppio le bolle contigue verso destra
   for(int j = column+1; j < WIDTH; j++){
      if(tiles[row][j] == color){
         count++;
         if(pop_them)
            tiles[row][j] = ' ';
      }
      else
         break; // non ci sono piu' bolle contigue
   }
   return count;
}

PuzzleBobble& PuzzleBobble::scroll(){
   for(int j = 0; j < WIDTH; j++)
      if(tiles[HEIGHT-1][j] != ' ')
         return *this;
   for(int i = HEIGHT-1; i >= 1; i--){
      for(int j = 0; j < WIDTH; j++)
         tiles[i][j] = tiles[i-1][j];
   }
   for(int j = 0; j < WIDTH; j++)
      tiles[0][j] = '=';
   return *this;
}

void PuzzleBobble::compact(){
   for(int j = 0; j < WIDTH; j++){
      int move_to_row = 0;
      for(int i = 0; i < HEIGHT; i++){
         if(tiles[i][j] != ' '){
            tiles[move_to_row][j] = tiles[i][j];
            move_to_row++;
         }
      }
      for(int i = move_to_row; i < HEIGHT; i++)
         tiles[i][j] = ' ';
   }
}
