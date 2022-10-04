/*
Scrivere un programma che legga da tastiera una sequenza di N interi di-
stinti e li inserisca in un albero binario di ricerca (senza ribilanciamento).
Il programma deve quindi utilizzare un’opportuna visita dell’albero per
stampare gli interi della sequenza in ordine non decrescente.
Nella prima riga dell’input si trova la lunghezza N della sequenza; nelle
successive N righe si trovano gli interi che compongono la sequenza.
L’output contiene la sequenza ordinata degli elementi inseriti nell’albero,
uno per riga.
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
	void stampa_inorder();
private:
	void private_inserimento(const int, Nodo *&);
	void private_inorder(Nodo *&);
};

AlberoBinario::AlberoBinario(){ root_=NULL; }
Nodo * AlberoBinario::getRoot(){ return root_; }
void AlberoBinario::inserimento(const int valore){ private_inserimento(valore,root_); }
void AlberoBinario::stampa_inorder(){ private_inorder(root_);}
void AlberoBinario::private_inorder(Nodo *&nodo){
	if(nodo!=NULL){
		private_inorder(nodo->sx);
		cout<<nodo->valore<<endl;
		private_inorder(nodo->dx);
	}
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
	tree.stampa_inorder(); //Stampo Albero in ordine Descescente
}
