/* DISCLAIMER: questa soluzione non è probabilmente quella migliore e/o più efficiente, ma i test tornano tutti e la complessità rispetta i limiti imposti nel testo dell'esercizio (ove presenti), s
pero comunque che possa essere d'aiuto e se riuscite a trovare una soluzione migliore vi invito a condividerla e aggiungerla alla repository del corso :) 
- Azzurra */

#include <iostream>     // std::cout
#include <algorithm>    // std::sort
#include <vector>       // std::vector
#include <fstream>
#include <math.h>       /* floor */
#include <stdlib.h>
#include <cmath>        /* pow  */
using namespace std;

struct Node{
    int value;
    Node * left;
    Node * right;
    Node( int i ): value(i) , left(NULL) , right(NULL) {}
};

class BinTree {
    Node * root_;
public:
    BinTree() { root_ = NULL ; }
    Node * getRoot() { return root_; cout << "getRoot" << endl;}

    void insert( int i ) {
        Node * node = new Node(i);
        Node * pre = NULL;
        Node * post = root_;
        while( post != NULL) {
            pre = post;
            if( i <= post->value ) {
                post = post->left;
            }
            else {
                post = post->right;
            }
        }

        if( pre == NULL )
            root_ = node;
        else if( i <= pre->value ) {
            pre->left = node;
        }
        else {
            pre->right = node;
        }
        return;
    }
};

void insert(Node*& tree, int x) {
	Node* n = new Node(x);
	if(!tree) {
		tree = n;
		return;
	}

	if(x <= tree->value) 
		insert(tree->left, x);
	else if(x > tree->value) 
		insert(tree->right, x);
}

int indicehash(int x, int s) {
	return ((((1000 * x) + 2000) % 999149) %s);
}

struct stat {
	int nsx;
	int ndx;
	int i;
};

// passo per riferimento il contatore di ndx e nsx per quell'albero, s indica se il nodo è figlio sx (0) o dx (1)
void conta(Node* tree, int s, int& ndx, int& nsx) {
	if(tree) {
		// se ho figlio sx ci chiamo la funzione passandogli s = 0
		if(tree->left) 
			conta(tree->left, 0, ndx, nsx);
		if(tree->right) 
			conta(tree->right, 1, ndx, nsx);

		// se sono su una foglia
		if(!tree->left && !tree->right) {
			if (s == 0){
				nsx++;
				//cout<<"foglia sx, nsx = "<<nsx<<endl;
			}
			else {
				ndx++;
				//cout<<"foglia dx, ndx = "<<ndx<<endl;
			}		
		}
	}
}

bool sortSx(stat a, stat b) {
	if(a.nsx > b.nsx) 
		return true;
	else if(a.nsx == b.nsx) {
		if(a.i > b.i)
			return true;
		else 
			return false;
	}
	else 
		return false;
}
			
bool sortDx(stat a, stat b) {
	if(a.ndx > b.ndx) 
		return true;
	else if(a.ndx == b.ndx) {
		if(a.i > b.i)
			return true;
		else 
			return false;
	}
	else 
		return false;
}


int main() {
	int n, s, temp;
	cin>>n>>s;

	// tabella hash: vettore di puntatori a nodo (radice dell'ABR)
	vector<Node*> table;
	for(int i=0; i<s; i++) {
		table.push_back(NULL);
	}

	for(int i=0; i<n; i++) {
		cin>>temp;
		int index = indicehash(temp, s);
		// se table[index] punta a NULL allora devo creare l'albero 
		if(table[index] == NULL) {
			//cout<<"primo nodo: "<<temp<<endl;
			BinTree tree;
			// faccio l'inserimento 
			tree.insert(temp);
			// faccio puntare table[index] alla radice
			table[index] = tree.getRoot();
		}
		// se table[index] punta a qualcosa allora è la radice dell'albero già esistente
		else {
			//cout<<"aggiungo nodo: "<<temp<<" in posizione: "<<index<<endl;
			//cout<<table[index]->value<<endl;
			insert(table[index], temp);
		}
		//cout<<temp<<" inserito in posizione: "<<index<<endl;
	}

	vector<stat> vett;
	// scorro il vettore 
	for(int i=0; i<s; i++) {
		int nsx = 0, ndx = 0;
		//cout<<"chiamo conta per i: "<<i<<endl;
		conta(table[i], 0, ndx, nsx);
	//	cout<<"nsx: "<<nsx<<" ndx: "<<ndx<<endl;
		// metto i, nsx e ndx nell'array di stat 
		stat tmp;
		tmp.nsx = nsx;
		tmp.ndx = ndx;
		tmp.i = i;
		vett.push_back(tmp);
	}
	

	// ora in vett ho tutti gli indici e i valori nsx, ndx dei relativi alberi: ordino per ndx
	sort(vett.begin(), vett.end(), sortDx);
	/*for(int i=0; i<vett.size(); i++) {
		cout<<"i: "<<vett[i].i<<" ndx: "<<vett[i].ndx<<" nsx: "<<vett[i].nsx<<endl;
	}*/
	cout<<vett[0].i<<endl;
	// ordino per nsx
	sort(vett.begin(), vett.end(), sortSx);
	cout<<vett[0].i<<endl;
	return 0;
}
	
			
			
			 











