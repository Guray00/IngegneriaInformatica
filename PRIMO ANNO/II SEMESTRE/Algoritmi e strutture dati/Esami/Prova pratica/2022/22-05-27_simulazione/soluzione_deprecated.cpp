/*
Scrivere un programma che legga da tastiera un sequenza di N interi positivi
e li inserisca in un albero binario di ricerca (senza ribilanciamento) nello
stesso ordine con il quale vengono forniti in input.
Il programma deve verificare che l’albero soddisfi la seguente proprietà:
per ogni nodo dell’albero, le altezze dei suoi sottoalberi sinistro e destro
devono differire al massimo di uno.
L’input è formattato nel seguente modo: la prima riga contiene l’intero N .
Seguono N righe contenenti un intero ciascuna. L’output è formato da una
sola riga contenente la stringa ok qualora la proprietà sopra descritta sia
verificata, la stringa no altrimenti.
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
	void verifica(bool &);
private:
	void private_inserimento(const int, Nodo *&);
	int private_verifica(Nodo *&, bool &);
};

AlberoBinario::AlberoBinario(){ root_=NULL; }
Nodo * AlberoBinario::getRoot(){ return root_; }
void AlberoBinario::inserimento(const int valore){ private_inserimento(valore,root_); }
void AlberoBinario::verifica(bool &stato){ private_verifica(root_,stato); }
int AlberoBinario::private_verifica(Nodo *&nodo, bool &stato){
	int altezzaDx;
	int altezzaSx;
	if(nodo==NULL)
		return 0;

	altezzaDx=private_verifica(nodo->dx,stato);
	altezzaSx=private_verifica(nodo->sx,stato);
	if(altezzaSx>altezzaDx+1 || altezzaDx>altezzaSx+1)
		if(stato)
			stato=false;

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
	bool stato=true;
	//Inizializzazione Albero Binario
	AlberoBinario tree;
	
	cin>>lunghezzaSequenza;
	for(int i=0; i<lunghezzaSequenza; i++){
		cin>>valore;
		tree.inserimento(valore);
	}
	tree.verifica(stato);
	if(stato)
		cout<<"ok\n";
	else
		cout<<"no\n";
}
