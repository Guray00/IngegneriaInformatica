#include <iostream>
#include "compito.h"
using namespace std;

int main(){

    cout<<"--- PRIMA PARTE ---"<<endl;
    cout<<"Test del costruttore"<<endl;
    LegoSet set;
    cout<<set<<endl;

    cout<<"Test della aggiungiMattoncino"<<endl;
    set.aggiungiMattoncino("AAA", 'b');
    set.aggiungiMattoncino("BBB", 'r');
    set.aggiungiMattoncino("CCC", 'b');
    set.aggiungiMattoncino("DDD", 'l');
    set.aggiungiMattoncino("EEE", 'v');
    set.aggiungiMattoncino("FFF", 'l');
    set.aggiungiMattoncino("GGG", 'l');
    cout<<set<<endl;

    cout<<"Test della eliminaMattoncino"<<endl;
    set.eliminaMattoncino("AAA");
    set.eliminaMattoncino("CCC");
    set.eliminaMattoncino("GGG");
    cout<<set<<endl;

    cout<<"Test dell'operatore resto"<<endl;
    cout<<"Numero di pezzi blu: "<<(set % 'l')<<endl;
    cout<<"Numero di pezzi bianchi: "<<(set % 'b')<<endl;

    cout<<endl<<"--- SECONDA PARTE ---"<<endl;
    cout<<"Test della eliminaMattoncino per colore"<<endl;
    set.eliminaMattoncino('l');
    cout<<set<<endl;

    cout<<"Test della aggiungiMattoncinoComune"<<endl;
    set.aggiungiMattoncinoComune(1, "HHH", 'l');
    set.aggiungiMattoncinoComune(34, "III", 'r');
    set.aggiungiMattoncinoComune(51, "JJJ", 'b');
    set.aggiungiMattoncinoComune(20, "KKK", 'n');
    cout<<set<<endl;

    cout<<"Test della aggiungiMattoncino di un mattoncino comune aggiunto da un altro LegoSet"<<endl;
    LegoSet set2;
    set2.aggiungiMattoncino("LLL", 'r');
    set2.aggiungiMattoncinoComune(1);
    set2.aggiungiMattoncinoComune(51);
    set2.aggiungiMattoncinoComune(40, "MMM", 'v');
    cout<<set2<<endl;

    set.aggiungiMattoncinoComune(40);
    cout<<set<<endl;

    cout<<"Test del distruttore"<<endl;
    {
        LegoSet set1;
        set1.aggiungiMattoncino("AAA", 'b');
        set1.aggiungiMattoncino("BBB", 'r');
        set1.aggiungiMattoncino("CCC", 'b');
        set1.eliminaMattoncino("BBB");
        set1.aggiungiMattoncinoComune(70, "NNN", 'n');
        cout << set1 << endl;
    }
    cout<<"(l'oggetto set1 e' appena stato distrutto)"<<endl;

    cout<<endl<<"--- TERZA PARTE ---"<<endl;
    cout<<"Altri test della aggiungiMattoncino"<<endl;
    set.aggiungiMattoncino("EEE", 'v'); // descrizione gia' esistente (deve aggiungerlo nuovamente)
    set.aggiungiMattoncino("DESCRIZIONE TROPPO LUNGA PER UN MATTONCINO", 'n'); // descrizione troppo lunga
    set.aggiungiMattoncino("NNN", 'x'); // colore non valido
    cout<<set<<endl;

    cout<<"Altri test della eliminaMattoncino"<<endl;
    set.eliminaMattoncino("ZZZ"); // mattoncino non esistente
    set.eliminaMattoncino("EEE"); // mattoncino presente piu' di una volta (elimina il primo)
    set.eliminaMattoncino("ALTRA DESCRIZIONE TROPPO LUNGA PER UN MATTONCINO"); // descrizione troppo lunga
    cout<<set<<endl;

    cout<<"Altri test della aggiungiMattoncinoComune"<<endl;
    set.aggiungiMattoncinoComune(34, "FFF", 'l'); // mattoncino comune gia' creato (non lo crea)
    set.aggiungiMattoncinoComune(0, "GGG", 'b'); // codice non valido
    set.aggiungiMattoncinoComune(200, "HHH", 'r'); // codice non valido
    set.aggiungiMattoncinoComune(5, "ANCORA UNA DESCRIZIONE TROPPO LUNGA PER UN MATTONCINO", 'n'); // descrizione troppo lunga
    set.aggiungiMattoncinoComune(7, "III", 'x'); // colore non valido
    cout<<set<<endl;
    set2.aggiungiMattoncinoComune(34); // deve essere rimasto quello vecchio: III
    cout<<set2<<endl;

    cout<<"Altri test della aggiungiMattoncino di un mattoncino comune aggiunto da un altro LegoSet"<<endl;
    set2.aggiungiMattoncinoComune(0); // id non valido
    set2.aggiungiMattoncinoComune(300); // id non valido
    set2.aggiungiMattoncinoComune(51); // mattoncino gia' aggiunto (deve aggiungerlo nuovamente)
    cout<<set2<<endl;

    return 0;
}