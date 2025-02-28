#include "compito.h"
#include <iostream>
using namespace std;


int main() {

    cout<<"\n--- PRIMA PARTE ---\n";
	
    ListaCaratteri list;
    cout << "Lista iniziale vuota: " << list << endl;

    list.inserisci('a', true);
    list.inserisci('b', true);
    list.inserisci('c', true);
    cout << "Dopo l'inserimento in coda (a, b, c): " << list << endl;

    list.inserisci('z', false);
    cout << "Dopo l'inserimento in testa (z): " << list << endl;

    cout << "Rimozione caratteri: "<< list.rimuovi('z', false);
    cout << list.rimuovi('b', false);
    cout << list.rimuovi('x', false) << endl;

    cout << "Dopo la rimozione: " << list << endl;

    ListaCaratteri listaDaPulire;
    listaDaPulire.inserisci('r', true);
    listaDaPulire.inserisci('a', true);
    listaDaPulire.inserisci('c', true);
    listaDaPulire.inserisci('e', true);
    listaDaPulire.inserisci('c', true);
    listaDaPulire.inserisci('a', true);
    listaDaPulire.inserisci('r', true);

    cout << "Lista prima della rimozione dei caratteri 'a' e 'c': " << listaDaPulire << endl;
    listaDaPulire.rimuovi('a', true);
    listaDaPulire.rimuovi('c', true);
    cout << "Rimuovi tutti i caratteri 'a' e 'c': " << listaDaPulire << endl;



    cout<<"\n--- SECONDA PARTE ---\n";

    ListaCaratteri listaDaInvertire;
    listaDaInvertire.inserisci('r', true);
    listaDaInvertire.inserisci('a', true);
    listaDaInvertire.inserisci('c', true);

    ListaCaratteri controlloListaInversa;
    controlloListaInversa.inserisci('c', true);
    controlloListaInversa.inserisci('a', true);
    controlloListaInversa.inserisci('r', true);


    ~listaDaInvertire;
    cout << "Controllo inverso lista: " << ((listaDaInvertire == controlloListaInversa)?"Si":"No") << endl;

    ListaCaratteri listaPalindroma;
    listaPalindroma.inserisci('r', true);
    listaPalindroma.inserisci('a', true);
    listaPalindroma.inserisci('c', true);
    listaPalindroma.inserisci('e', true);
    listaPalindroma.inserisci('c', true);
    listaPalindroma.inserisci('a', true);
    listaPalindroma.inserisci('r', true);

    cout << "Controllo lista palindroma: " << (listaPalindroma.controllaPalindroma() ? "Si" : "No") << endl;

    ListaCaratteri listaDaCercare;
    listaDaCercare.inserisci('c', true);
    listaDaCercare.inserisci('a', true);
    listaDaCercare.inserisci('d', true);
    listaDaCercare.inserisci('b', true);
    cout << "Lista da cercare: " << listaDaCercare << endl;

    ListaCaratteri sottostringa;
    sottostringa.inserisci('a', true);
    sottostringa.inserisci('d', true);
    cout << "Sottostringa da trovare: " << sottostringa << endl;

    bool contieneSottostringa = listaDaCercare.cercaSottostringa(sottostringa);
    cout << "La sottostringa fa parte della lista? " << (contieneSottostringa ? "Si" : "No") << endl;

    ListaCaratteri listaEstrazione;
    listaEstrazione.inserisci('a', true);
    listaEstrazione.inserisci('b', true);
    listaEstrazione.inserisci('c', true);
    listaEstrazione.inserisci('d', true);
    listaEstrazione.inserisci('e', true);
    listaEstrazione.inserisci('f', true);
    listaEstrazione.inserisci('g', true);

    // Estrazione
    char* estratto = listaEstrazione.estraiNultimoCarattere(3);
    cout << "Estrazione del terzo elemento dalla fine: " << *estratto << endl;
	delete estratto;

    // Lista dopo estrazione
    cout << "Lista dopo l'estrazione: " << listaEstrazione << endl;


    cout<<"\n--- TERZA PARTE ---\n";
    ListaCaratteri palindromeList2;
    palindromeList2.inserisci('r', true);
    palindromeList2.inserisci('a', true);
    palindromeList2.inserisci('d', true);
    palindromeList2.inserisci('e', true);
    palindromeList2.inserisci('c', true);
    palindromeList2.inserisci('a', true);
    palindromeList2.inserisci('r', true);
    cout << "Lista palindroma: " << palindromeList2 << endl;
    cout << "La lista e' palindroma? " << (palindromeList2.controllaPalindroma() ? "Yes" : "No") << endl;
    // Test 8: Empty list operations
    ListaCaratteri emptyList;
    cout << "Lista vuota: " << emptyList << endl;
    emptyList.rimuovi('x', false);
    cout << "Prova a rimuovere un carattere dalla lista vuota: " << emptyList << endl;

    ~emptyList;  // Reversing an empty list
    cout << "Inversione della lista vuota: " << emptyList << endl;

    ListaCaratteri listaDaPulire2;
    listaDaPulire2.inserisci('a', true);
    listaDaPulire2.inserisci('a', true);
    listaDaPulire2.inserisci('a', true);
    listaDaPulire2.inserisci('a', true);
    listaDaPulire2.inserisci('a', true);
    listaDaPulire2.inserisci('a', true);
    listaDaPulire2.inserisci('a', true);

    listaDaPulire2.rimuovi('a', true);
    cout << "Rimuovi tutti i caratteri 'a': " << listaDaPulire2 << endl;

    return 0;
}