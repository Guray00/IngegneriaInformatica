/* DISCLAIMER: questa soluzione non è probabilmente quella migliore e/o più efficiente, ma i test tornano tutti e la complessità rispetta i limiti imposti nel testo dell'esercizio (ove presenti), s
pero comunque che possa essere d'aiuto e se riuscite a trovare una soluzione migliore vi invito a condividerla e aggiungerla alla repository del corso :) 
- Azzurra */

#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

struct utente {
	int id;
	int eta;
	utente* next;
};

struct elem {
	int index;
	int count;
	int max_eta;
	int max_id;
	utente *pointer;
};

void insert(vector<elem>& table, int index, int id, int eta) {
	utente* u = new utente;
	u->id = id;
	u->eta = eta;
	u->next = NULL;
	if(table[index].pointer == NULL) {
		table[index].pointer = u;
	}
	else {
		utente* temp;
		temp = table[index].pointer;
		while(temp->next != NULL) {
			temp = temp->next;
		}
		temp->next = u;
	}
	// aggiorno il contatore e se l'utente è più anziano anche max_eta e max_id
	table[index].count++;
	if(table[index].max_eta < eta) {
		table[index].max_eta = eta;
		table[index].max_id = id;
	}
	else if (table[index].max_eta == eta) {
		if(table[index].max_id > id) {
			table[index].max_eta = eta;
			table[index].max_id = id;
			}
	} 
}	


// Funzione di utilità per il debug 
/* void print(vector<elem> table, int C) {
	for (int i = 0; i < C; i++) {
		cout<<"h["<<i<<"]: ";
		utente* temp = table[i].pointer;
		if(!temp) {
			cout<<endl;
			continue;
		}
		cout<<"("<<temp->id<<","<<temp->eta<<") -> ";
		while(temp->next!= NULL) {
			cout<<"("<<temp->next->id<<","<<temp->next->eta<<") -> ";
			temp = temp->next;
		}
		cout<<endl;
		cout<<"utenti: "<<table[i].count<<" max eta: "<<table[i].max_eta<<" max id: "<<table[i].max_id<<endl;
	}
}
*/

bool sortVect(elem a, elem b) {
	if (a.count > b.count) 
		return true; 
	else 
		return false; 
}

int main() {
	int n, k, s, h;
	int id, eta;
	cin>>n>>k>>s;

	vector<elem> table;
	elem etemp;
	etemp.count = 0; 
	etemp.max_eta = 0; 
	etemp.max_id = 0; 
	etemp.pointer = NULL;
	
	for (int i=0; i<=s; i++) {
		table.push_back(etemp);
	}

	for(int i=0; i<n; i++) {
		cin>>id;
		cin>>eta;
		h = ((((1000*id)+2000)%999149)%s);
		insert(table, h, id, eta);
	}
	
	// copio l'array table così lo posso riordinare per numero di collisioni 
	vector<elem> copy;
	copy = table;
	sort(copy.begin(), copy.end(), sortVect);

	// scorro l'array (solo k elementi che sono quelli dell'insieme I) e mi memorizzo id ed eta del maggiore;
	id = 0; 	
	eta = 0; 
	for(int i=0; i<k; i++) {
		if(copy[i].max_eta > eta) {
			eta = copy[i].max_eta;
			id = copy[i].max_id;
		}
		else if (copy[i].max_eta == eta) {
			if(copy[i].max_id < id) {
				eta = copy[i].max_eta;
				id = copy[i].max_id;
			}
		}
	}	
	cout<<id<<endl<<eta<<endl;
	return 0;
}
	
