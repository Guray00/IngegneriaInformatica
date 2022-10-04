/*
Scrivere un programma che legga da tastiera una sequenza di N interi dis-
tinti e li inserisca in un albero binario di ricerca (senza ribilanciamento).
Il programma deve visitare opportunamente l’albero e restituire la sua al-
tezza.
Nella prima riga dell’input si trova la lunghezza N della sequenza; nelle
successive N righe si trovano gli interi che compongono la sequenza.
L’output contiene unicamente l’altezza dell’albero.
*/
#include <iostream>
using namespace std;

//----- Definizione Struttura Nodo dell'albero
struct Nodo{
	int valore;
	Nodo *dx;
	Nodo *sx;

	//Inizializzatore Nuovo Nodo
	Nodo(int init):
		valore(init), dx(NULL), sx(NULL) {}
};

//----- Definizione della Classe di Manipolazione Albero
class AlberoBinario{
	 Nodo *root_;
public:
	AlberoBinario();
	Nodo * getRoot();
	void inserimento(const int);
	void stampa_altezza();
private:
	void private_inserimento(const int, Nodo *&);
	int private_altezza(Nodo *&);
};

AlberoBinario::AlberoBinario(){ root_=NULL; }
Nodo * AlberoBinario::getRoot(){ return root_; }
void AlberoBinario::inserimento(const int valore){ private_inserimento(valore,root_); }
void AlberoBinario::stampa_altezza(){ cout<<private_altezza(root_)<<endl;}
int AlberoBinario::private_altezza(Nodo *&nodo){
	int altezzaDx;
	int altezzaSx;
	if(nodo==NULL)
		return 0;
	
	altezzaSx=private_altezza(nodo->sx);
	altezzaDx=private_altezza(nodo->dx);
	
	if(altezzaSx>=altezzaDx)
		return 1+altezzaSx;
	else
		return 1+altezzaDx;
}
void AlberoBinario::private_inserimento(const int valore, Nodo *&start){
	//Creazione nodo vergine
	Nodo *newNodo = new Nodo(valore);
	Nodo *preNodo = NULL;
	Nodo *postNodo = start;
	//Ricerca Posizione
	while(postNodo!=NULL){
		preNodo=postNodo;
		if(valore<= postNodo->valore)
			postNodo=postNodo->sx;
		else
			postNodo=postNodo->dx;
	}
	//Inserimento Nodo Aggiuntivo
	if(preNodo==NULL)
		start=newNodo;
	else if(valore<=preNodo->valore)
		preNodo->sx=newNodo;
	else
		preNodo->dx=newNodo;
}

int main(){
	int lunghezzaSequenza=0;
	int valore;
	//Inizializzazione Albero Binario
	AlberoBinario tree;
	
	cin>>lunghezzaSequenza;
	for(int i=0; i<lunghezzaSequenza; i++){
		cin>>valore;
		tree.inserimento(valore);
	}
	tree.stampa_altezza(); //Stampo Altezza Albero
}
