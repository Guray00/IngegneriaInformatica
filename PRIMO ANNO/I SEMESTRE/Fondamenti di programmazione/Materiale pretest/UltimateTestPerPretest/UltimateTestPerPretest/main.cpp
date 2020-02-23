#include <iostream>
using namespace std;

//in questo metodo var viene incrementato, dato che è passato con un reference!
void metodo(int& var)
{
    var++;
}

//in questo metodo i valori a e b vengono scambiati, anche se è void!
void scambia(int& a, int& b)
{
    int c = b;
    b = a;
    a = c;
}

//il metodo ritorna il maggiore come metodo che ritorna un REFERENCE!
//entrambi vanno passati come reference altrimenti non possono essere ritornati come reference ovviamente!
int& maggiore(int& a, int& b)
{
    //ricordiamo lo studente che questo è un una espressione in linea (è un if)
    //(condizione) ? (se è true) : (se è false)
    return a > b ? a : b;
}

//nel caso in cui non sono passati come reference ma devono esserlo, si utilizza lo static_cast
//ricordiamo che due metodi chiamati in modo uguale (polimorfismo) non possono differire solo per
//return type oppure per variabili che accetta

int& maggiore1(int a, int b)
{
    return static_cast<int&>(a > b ? a : b);
}

//passarli come const implica che non verranno modificati ma solo confrontati!
//questo metodo ha solo senso nel caso tu voglia utilizzare il metodo SOLO per referenziare la variabile massimo
//che poi NON può essere modificata dato che è const!!

const int& maggiore2(const int& a, const int& b)
{
    return a > b ? a : b;
}


int main() {
    //--REFERENCE REGOLA GENERALE--
    //int& ref_sbagliato; //va sempre inizializzata!
    //const int& const_ref_sbagliato; //anche se non è const!
    //const& int const_ref_sbagliato2; //errore sintattico!
    //ricordiamo che const int& o int& const sono la stessa cosa!

    //--REFERENCE + VAR--
    int var = 3;
    int& ref = var; //inizializzazione. ref referenzia var.
    ref = 4; //si può cambiare var da ref: ora var = 4.
    cout << ref; //è esattamente come fare cout << var

    //--REFERENCE CONST + VAR--
    const int& const_ref = var; //reference costante. Uguale ad un reference normale, ma...
    //const_ref = 6; //non si può cambiare il valore di "cane" attraverso il reference "madonna", dato che è CONST.

    //--REFERENCE CONST + VAR CONST--
    const int const_var = 3;
    //int& ref2 = const_var; //non si può referenziare un const da un puntatore non const.
    const int& const_ref2 = const_var; //infatti questo si può fare

    //--REFERENCE E METODI--
    metodo(ref); //si può passare ref ad un metodo che lo accetta, CLion lo rileva "&:" in automatico

    int var2 = 4;
    int& ref3 = var2;
    scambia(ref, ref3);

    maggiore(ref, ref3)++; //il maggiore tra i due viene referenziato da "maggiore" e può essere incrementato
    //in questo caso se ref > ref3, con questo metodo si può fare ref++.
    maggiore(ref, ref3) = 8; //se i numeri rimangono uguali, e ref > ref3 come prima, ora ref = 8.

    //--PUNTATORI REGOLA GENERALE--
    //i puntatori sono simili ai reference, ma hanno molti più utilizzi
    //un puntatore accetta SOLO un INDIRIZZO DI MEMORIA (&var)
    int* pun1; //NB: questo SI può fare (pun1 = indirizzo random)
    int* pun2 = &var; //anche questo si può fare
    *pun2 = 3; //*pun accede al valore puntato da pun2 e lo modifica (var = 3)
    pun2 = pun1; //copi l'indirizzo di pun1 in pun2. Entrambi ora puntano alla stessa variabile

    //--PUNTATORI + VAR--
    pun1 = &var; //i puntatori accettano indirizzi di memoria
    pun1 = &var2; //un puntatore normale può anche puntare a qualcos'altro!

    //--PUNTATORI + CONST--
    //int* pun3 = &const_var; //un puntatore normale NON può puntare ad un valore const!
    //dato che in "teoria" col puntatore normale potresti modificare il valore con *pun2 = valore!

    //--PUNTATORI CONST + VAR--
    //const* int const_pun_sbagliato; //errore sintattico!
    const int* const_pun1 = &var;
    //*const_pun1 = 3; //esattamente come coi reference, questo non si può fare!

    //-PUNTATORI + PUNTATORI--
    //entrambe le cose sono possibili!
    const int* const_pun2 = const_pun1;
    const_pun2 = pun2; //si può far puntare un const al valore puntato del puntatore normale!
    //pun3 = const_pun2; //attenzione però che il puntatore normale non può avere l'indirizzo di memoria di un const!

    //-PUNTATORI + REFERENCE-
    const_pun2 = &ref;
    const_pun2 = &const_ref;
    ref = *pun1; //valore di pun1 in ref, ok
    ref = *const_pun1; //valore di const_pun1 in ref, ok (*const_pun1 non viene modificato, perciò vabene)
    ref++; //questo si può fare!! (nonostante punti al valore di un puntatore const!)
    //entrambi vanno bene in quanto *pun1 e *const_pun1 sono valori.
    const int& const_ref3 = *pun1;
    const int& const_ref4 = *const_pun1;

    //--PUNTNATORI + VETTORI--
    //un utilizzo dei puntatori sono i vettori, dato che un puntnatore può puntare all'indirizzo di memoria
    //di un vettore (se punta al vettore intero, punta alla sua 0-esima cella)

    int v1[3] = {1, 2, 3};
    int* p_v1 = v1; //punto al vettore
    p_v1 = &v1[0]; //sono equivalenti
    p_v1 = &v1[1]; //questo è il vettore dall'indice 1 in poi (*p_v1 = 2)

    //questo è perchè il vettore è memorizzato in più celle di memoria (3 nel nostro caso)
    //le quali celle sono consecutive (una dopo l'altra)

    //--ARITMETICA DEI PUNTATORI--
    p_v1--; //sposta indietro l'indice del vettore a cui punta p_v1 (*p_v1 = 1 dato che v[0] = 1)
    *p_v1++; //sposta avanti l'indice del vettore a cui punta p_v1 (*p_v1 = 2 dato che v[1] = 2)
    *(p_v1)++; //questo invece incrementa il VALORE PUNTATO (è come scrivere v[1]++) (v[1] = 3)
    //Senza parentesi = cambia l'indice!
    (*p_v1)++; //funziona esattamente come quello scritto prima! (v[1] = 4)
    ++*(p_v1); //si può scrivere così (v[1] = 5)
    ++(*p_v1); //e anche così (v[1] = 6)

    //--CREAZIONE DI VETTORI CON I PUNTATORI--
    char* c1 = "ciao"; //questa è un PUNTATORE di char, chiamato anche STRINGA.
    char c2[] = "ciao"; //questo è un VETTORE di char, anche questo chiamato STRINGA

    int* v2; //puntatore di interi, può diventare un vettore!
    v2 = new int[var]; //creazione di un vettore di interi in heap (con la keyword NEW stai allocando memoria dinamica)
    char** v_c1; //doppio puntatore di char, può diventare un VETTORE di STRINGHE.
    v_c1 = new char*[var]; //creazione di un VETTORE di STRINGHE. Ogni cella ha un PUNTATORE di char.
    //con new char stai creando una stringa. Invece con new char* stai creando un VETTORE di stringhe.
    for(int i = 0; i < var2; i++)
        v_c1[i] = new char[var2+1]; //creazione delle singole stringhe!

    //--CREAZIONE DI MATRICI CON I PUNTATORI--
    int** v3; //doppio puntatore di interi. Può diventare una matrice!
    v3 = new int*[var]; //creazione delle righe della matrice!
    for(int i = 0; i < var2; i++)
        v3[i] = new int[var]; //creazione delle colonne per ogni riga!

    char*** v_c2; //triplo puntatore di char. Può diventare una matrice!
    v_c2 = new char**[var]; //creazione della prima dimensione della matrice di char
    for(int i = 0; i < var2; i++)
        v_c2[i] = new char*[var]; //creazione delle colonne per ogni riga!

    for(int i = 0; i < var2; i++)
        for(int j = 0; j < var2; j++)
            v_c2[i][j] = new char[var]; //creazione delle singole stringhe!

    //ricordarsi quindi che i vettori/matrici di CHAR vogliono un asterisco in più!
}