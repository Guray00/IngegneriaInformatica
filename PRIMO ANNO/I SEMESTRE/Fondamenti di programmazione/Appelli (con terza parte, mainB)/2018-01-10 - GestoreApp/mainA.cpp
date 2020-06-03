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

//    cout << "\n--- SECONDA PARTE ---\n";
// 
//    cout << "\nTest di foreground:\n";
//    g.foreground("TripAdvisor");   
//    cout << g << endl;
//    g.foreground("YouTube");       // fallisce
//    cout << g << endl;
// 
//    cout << "\nTest operatore -=:\n";
//    g -= "Shazam";                 
//    cout << g << endl;
//    g -= "YouTube";                // fallisce
//    cout << g << endl;
//    
//    cout << "\nTest di chiudi_tutte:\n";
//    g.chiudi_tutte();
//    cout << g << endl;
//    
//    cout << "\nTest distruttore:\n";
//    {
//        GestoreApp g1;
//        g1 += "YouTube";
//        g1 += "Facebook";
//        cout << g1 << endl;
//    }
//    cout << "(g e' stato distrutto)\n";
}