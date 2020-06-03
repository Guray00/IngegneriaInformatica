#include <iostream>
#include "compito.h"

using namespace std;

int main() 
{
   cout << "--- PRIMA PARTE ---\n";

   cout << "Test del costruttore:\n";
   GestoreApp g;
   cout << g << endl;
   
   cout << "\nTest operatore +=:\n";
   g += "WhatsApp";
   cout << g << endl;
   
   g += "PlayStore";
   g += "TripAdvisor";
   g += "Shazam";
   g += "WhatsApp";               // fallisce
   cout << g << endl;

   cout << "\n--- SECONDA PARTE ---\n";

   cout << "\nTest di foreground:\n";
   g.foreground("TripAdvisor");   
   cout << g << endl;
   g.foreground("YouTube");       // fallisce
   cout << g << endl;

   cout << "\nTest operatore -=:\n";
   g -= "Shazam";                 
   cout << g << endl;
   g -= "YouTube";                // fallisce
   cout << g << endl;
   
   cout << "\nTest di chiudi_tutte:\n";
   g.chiudi_tutte();
   cout << g << endl;
   
   cout << "\nTest distruttore:\n";
   {
       GestoreApp g1;
       g1 += "YouTube";
       g1 += "Facebook";
       cout << g1 << endl;
   }
   cout << "(g e' stato distrutto)\n";
   
   cout << "\n--- TERZA PARTE ---\n";
   GestoreApp g2;
   // test di foreground su lista vuota
   g2.foreground("Twitter");  // fallisce
   cout << g2 << endl;
   g2 += "Twitter";
   cout << g2 << endl;
   // test operatore -= su testa della lista
   g2 -= "Twitter";
   cout << g2 << endl;
   // test operatore -= su lista vuota
   g2 -= "Telegram";          // fallisce
   cout << g2 << endl;
   // test chiudi_tutte su lista vuota
   g2.chiudi_tutte();
   cout << g2 << endl;
}