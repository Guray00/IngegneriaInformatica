#include <iostream>
#include "compito.h"

using namespace std;

int main()
{
   cout << "--- PRIMA PARTE ---" << endl;
   cout << "Test del costruttore:" << endl;
   Log l1;
   cout << l1 << endl;

   cout << "Test della registra:" << endl;
   l1.registra('i', {2023,03,15}, {17,45}, "Applicazione 2 avviata");
   l1.registra('w', {2023,03,15}, {18,01}, "Applicazione 2 non puo' accedere la risorsa A");
   l1.registra('i', {2023,03,15}, {18,24}, "Applicazione 1 arrestata dall'amministratore");
   l1.registra('i', {2023,03,15}, {18,04}, "Applicazione 3 avviata");
   l1.registra('i', {2023,03,15}, {18,20}, "Evento che verra' cancellato");
   l1.registra('i', {2023,03,15}, {17,33}, "Applicazione 1 avviata");
   l1.registra('i', {2023,03,15}, {19,01}, "Applicazione 3 arrestata dall'amministratore");
   l1.registra('w', {2023,03,15}, {18,07}, "Applicazione 1 ha tentato di aprire file inesistente B");
   l1.registra('e', {2023,03,15}, {18,26}, "Applicazione 2 ha tentato di dividere per zero: arrestata");
   l1.registra('c', {2023,03,15}, {18,59}, "Buffer overflow nell'applicazione 3! Allarme di sicurezza!");
   cout << l1 << endl;

   cout << "Test della cancella:" << endl;
   l1.cancella("Evento che verra' cancellato");
   cout << l1 << endl;

   // SECONDA PARTE
   cout << endl << "--- SECONDA PARTE ---" << endl;
   {
      cout << "Test dell'(eventuale) distruttore:" << endl;
      Log l2;
      l2.registra('i', {2023,03,15}, {18,00}, "aaa");
      l2.registra('c', {2023,03,15}, {18,20}, "bbb");
      l2.registra('e', {2023,03,15}, {18,40}, "ccc");
   }
   cout << "(distruttore invocato)" << endl;

   cout << "Test della cancella overloaded:" << endl;
   l1.cancella({2023,03,15}, {18,04}, {2023,03,15}, {18,25});
   cout << l1 << endl;

   cout << "Test della filtra:" << endl;
   Log *p_l3 = l1.filtra('i');
   cout << *p_l3 << endl;
   delete p_l3;

   cout << "Test della biforca:" << endl;
   Log l4;
   l4.registra('e', {2023,03,15}, {18,07}, "L'applicazione 3 non puo' aprire la porta 80");
   l4.registra('e', {2023,03,15}, {18,26}, "L'applicazione 3 non puo' aprire nemmeno la porta 443");
   l4.registra('w', {2023,03,15}, {18,41}, "File C non disponibile nella cartella D");
   l4.registra('e', {2023,03,15}, {19,11}, "Errore che verra' cancellato dall'amministratore");
   l4.cancella("Errore che verra' cancellato dall'amministratore");
   l4.registra('c', {2023,03,15}, {19,25}, "OS arrabbiato perche' errore precedente cancellato");
   Log *p_l5 = l1.biforca({2023,03,15}, {18,26}, l4);
   cout << *p_l5 << endl;
   delete p_l5;

   // TERZA PARTE
   cout << endl << "--- TERZA PARTE ---" << endl;
   cout << "Test aggiuntivi della registra:" << endl;
   Log l5;
   l5.registra('e', {2023,03,15}, {19,02}, ""); // descrizione vuota (deve lasciare inalterato)
   l5.registra('i', {2023,03,15}, {19,32}, "Descrizione decisamente troppo luuuuuuuuunga per essere registrata correttamente nel log."); // descrizione troppo lunga (deve lasciare inalterato)
   l5.registra('x', {2023,03,15}, {19,35}, "aaa"); // tipo inesistente di evento
   l5.registra('i', {1967,03,15}, {19,35}, "aaa"); // data non valida
   l5.registra('i', {1971,14,15}, {19,35}, "aaa"); // data non valida
   l5.registra('i', {1971,03,34}, {19,35}, "aaa"); // data non valida
   l5.registra('i', {1971,03,29}, {24,35}, "aaa"); // ora non valida
   l5.registra('i', {1971,03,29}, {19,70}, "aaa"); // ora non valida
   l5.registra('i', {1971,03,29}, {19,35}, "aaa");
   l5.registra('i', {1971,02,29}, {19,35}, "aaa");
   l5.registra('i', {1971,03,23}, {19,35}, "aaa");
   l5.registra('i', {1971,03,29}, {19,35}, "bbb"); // data/ora gia' esistenti
   l5.registra('i', {1971,02,29}, {19,35}, "ccc"); // data/ora gia' esistenti in testa
   l5.registra('i', {2011,03,29}, {19,35}, "aaa"); // messaggio gia' esistente
   l5.registra('i', {2011,01,29}, {19,35}, "bbb"); // messaggio gia' esistente
   l5.registra('i', {2011,01,29}, {19,35}, "ccc"); // messaggio e data/ora gia' esistenti
   cout << l5 << endl;

   cout << "Test aggiuntivi della cancella:" << endl;
   l5.cancella("evento inesistente"); // evento inesistente (deve lasciare inalterato)
   l5.cancella(""); // messaggio vuoto (deve lasciare inalterato)
   l5.cancella("bbb"); // due eventi con stesso messaggio (deve cancellare il primo)
   l5.cancella("ccc"); // due eventi con stesso messaggio e stessa data/ora (deve cancellare il primo)
   cout << l5 << endl;

   // test distruttore su lista vuota
   {
      cout << "Test aggiuntivo del distruttore:" << endl;
      Log l4;
      cout << l4 << endl;
   }
   cout << "(distruttore invocato)" << endl;

   cout << "Test aggiuntivi della cancella overloaded:" << endl;
   l1.cancella({2023,03,15}, {18,04}, {2022,03,15}, {18,25}); // input non validi (deve lasciare inalterato)
   cout << l1 << endl;
   l1.cancella({2023,03,32}, {18,04}, {2023,03,15}, {18,25}); // input non validi (deve lasciare inalterato)
   cout << l1 << endl;
   l1.cancella({2023,03,15}, {18,04}, {2023,03,15}, {-1,25}); // input non validi (deve lasciare inalterato)
   cout << l1 << endl;
   l1.cancella({2023,03,15}, {00,00}, {2023,03,15}, {23,59}); // cancella tutto il log
   cout << l1 << endl;

   cout << "Test aggiuntivi della filtra:" << endl;
   p_l3 = l1.filtra('x'); // input non valido (deve restituire nullptr)
   cout << (p_l3 == nullptr) << endl;
   p_l3 = l5.filtra('c'); // nessun evento di questo tipo (deve restituire log vuoto)
   cout << *p_l3 << endl;
   delete p_l3;

   cout << "Test aggiuntivi della biforca:" << endl;
   l5.registra('i', {1971,03,29}, {19,42}, "ddd");
   Log l6;
   l6.registra('i', {1971,03,29}, {19,36}, "eee");
   l6.registra('i', {1971,03,29}, {19,42}, "fff"); // data/ora presenti anche in l5
   l6.registra('e', {1971,03,29}, {19,53}, "ggg");
   p_l3 = l5.biforca({1971,03,29}, {19,58}, l6); // solo l5
   cout << *p_l3 << endl;
   delete p_l3;
   p_l3 = l5.biforca({1971,02,29}, {19,30}, l6); // solo l6
   cout << *p_l3 << endl;
   delete p_l3;
   p_l3 = l5.biforca({1971,03,29}, {19,42}, l6); // data/ora presenti in entrambi i log (deve prendere quella di l5)
   cout << *p_l3 << endl;
   delete p_l3;

   return 0;
}