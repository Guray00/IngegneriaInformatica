/* DISCLAIMER: questa soluzione non è probabilmente quella migliore e/o più efficiente, ma i test tornano tutti e la complessità rispetta i limiti imposti nel testo dell'esercizio (ove presenti), s
pero comunque che possa essere d'aiuto e se riuscite a trovare una soluzione migliore vi invito a condividerla e aggiungerla alla repository del corso :) 
- Azzurra */

#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

struct node {
	int targa;
	int categoria;
	node *next;
};

struct stats {
	int M;
	int V;
};

struct stats_index{
	int index;
	int V;
};

// a parità di numero di veicoli considero la categoria in ordine crescente 
bool sortDesc(stats a, stats b) {
	if(a.V > b.V) 
		return true;
	else if (a.V == b.V) {
		if(a.M < b.M)
			return true;
		else 
			return false;
	}
	else
		return false;
}

void insert(vector<node*>& table, int index, int t, int cat) {
	node* n = new node;
	n->targa = t;
	n->categoria = cat;
	n->next = NULL;

	if(table[index]==NULL) {
		table[index] = n;
	}
	else {
		node* temp = table[index];
		while (temp->next != NULL) {
			temp = temp->next;
		}
		temp->next = n;
	}
		
}

bool sort_res(stats_index a, stats_index b) {
	if (a.V > b.V) 
		return true;
	else if (a.V == b.V) {
		if (a.index < b.index) 
			return true;
		else
			return false;
	}
	else 
		return false;
}

// Funzione di utilità per il debug 
/*
void print(vector<node*> table, int C) {
	for (int i = 0; i < C; i++) {
		cout<<"h["<<i<<"]: ";
		node *temp = table[i];
		if(!temp) {
			cout<<endl;
			continue;
		}
		// stampo il primo elemento 
		cout<<"("<<temp->targa<<","<<temp->categoria<<") -> ";
		while(temp->next!= NULL) {
			cout<<"("<<temp->next->targa<<","<<temp->next->categoria<<") -> ";
			temp = temp->next;
		}
		cout<<endl;
	}
}
*/	

int main() { 
	int n, k, c, h;
	cin>>n>>k>>c;	

	// tabella hash = vettore lungo C di puntatori a node 
	vector<node*> table;	
	for (int i = 0; i < c; i++) 
		table.push_back(NULL);	

	int t, cat;	
	for (int i = 0; i < n; i++) {
		// leggo targa e categoria		
		cin>>t>>cat;
		// calcolo h
		h = (((1000 * t) + 2000) % 999149) % c;
		// inserisco l'elemento nella tabella 
		insert(table, h, t, cat);
	}



	/* Per ogni indice i scorro la lista degli elementi, quindi scorro un vettore mv in cui metto categoria e numero di veicoli di quella categoria trovati nella lista;
		quindi ordino il vettore in base al numero di veicoli decrescente (a parità si prende la categoria in ordine crescente), prendo il primo elemento e lo metto in un vettore di 			elementi stat_index insieme all'indice i */
	int j;
	vector<stats_index> s_i;
	for (int i = 0; i < c; i++) {
		// scorro la lista di indice i 
		vector<stats> mv;
		stats temp;
		stats_index s_temp;
		if(table[i]) {
			node* head;
			head = table[i];
			// scorrimento della lista		
			while(head) {
				for(j=0; j<mv.size();j++) {
					if(head->categoria == mv[j].M) {
						mv[j].V += 1;
						break;
					}
				}
				// se esco e non ho trovato un elemento di mv con M == categoria allora devo aggiungerlo con contatore di veicoli 1
				if(j==mv.size()) {
					temp.M = head->categoria;
					temp.V = 1;
					mv.push_back(temp);
				}
				head = head->next;
			}

			// finito di scorrere tutti gli elementi della lista ordino l'array mv per prendere il valore maggiore di V 
			sort(mv.begin(), mv.end(), sortDesc);
			s_temp.index = i;
			s_temp.V = mv[0].V;
			s_i.push_back(s_temp);
			
		}
		// se table[i] è vuoto semplicemente metto 0 come numero di veicoli 
		else {
			s_temp.index = i;
			s_temp.V = 0;
			s_i.push_back(s_temp);
		}
	}

	// ora ho nell'arrai s_i le corrispondenze (indice, V(i)) quindi lo ordino in ordine decrescente (a partà di V considero gli i in ordine crescente) 
	sort(s_i.begin(), s_i.end(), sort_res);
	// stampo i primi k indici 
	for(int i = 0; i < k; i++) 
		cout<<s_i[i].index<<endl;
	return 0;
}

	
		









