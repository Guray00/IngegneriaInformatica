#include "compito.h"
#include <iostream>
using namespace std;

int main(){
   // PRIMA PARTE:
   cout << "--- PRIMA PARTE ---" << endl;
   cout << "Test costruttore" << endl;
   PuzzleBobble pb;
   cout << pb;
   
   cout << "Test funzione fire" << endl;
   pb.fire(0,'R').fire(1,'R').fire(0,'B').fire(2,'Y');
   pb.fire(3,'Y').fire(3,'Y').fire(0,'B').fire(3,'G');
   cout << pb;
   
   cout << "Test operatore int" << endl;
   cout << "Altezza: " << int(pb) << endl;

   // SECONDA PARTE:
   cout << "--- SECONDA PARTE ---" << endl;
   cout << "Test funzionalita' scoppio bolle" << endl;
   pb.fire(0,'B'); // scoppio verticale di 3 bolle
   pb.fire(0,'R'); // no scoppio
   pb.fire(5,'Y').fire(4,'Y'); // scoppio orizzontale di 4 bolle
   pb.fire(3,'G'); // no scoppio
   cout << pb;
   
   cout << "Test funzione scroll" << endl;
   pb.scroll().scroll();
   cout << pb;

   cout << "Test funzione compact" << endl;
   pb.compact();
   cout << pb;

   // TERZA PARTE:
   cout << "--- TERZA PARTE ---" << endl;
   cout << "Test funzione fire con scoppio di file verticali e orizzontali" << endl;
   pb.fire(1,'R'); // scoppio verticale e orizzontale di tot 3 bolle
   cout << pb;
   
   cout << "Test funzione fire con input non validi" << endl;
   pb.fire(-1,'B').fire(6,'Y'); // indice colonna non valido
   pb.fire(4,'F'); // colore non valido
   cout << pb;
   
   cout << "Test funzione fire con bolle che escono dallo schema" << endl;
   pb.fire(3,'B').fire(3,'G').fire(3,'R').fire(3,'Y').fire(3,'B');
   pb.fire(3,'G'); // bolla che esce dallo schema
   cout << pb;
   
   cout << "Test funzione scroll con bolle che escono dallo schema" << endl;
   pb.scroll(); // bolle che escono dallo schema
   cout << pb;
   
   cout << "Test funzione compact con buchi multipli" << endl;
   pb.fire(0,'G').fire(0,'R');
   pb.fire(1,'B').fire(1,'G').fire(1,'Y').fire(1,'B').fire(1,'Y');
   pb.fire(2,'Y').fire(2,'G').fire(2,'R').fire(2,'R').fire(2,'B'); // lascio 3 buchi sulla riga 3 e 2 buchi sulla riga 5
   pb.compact();
   cout << pb;
   
   return 0;
}