/* DISCLAIMER: questa soluzione non è probabilmente quella migliore e/o più efficiente, ma i test tornano tutti e la complessità rispetta i limiti imposti nel testo dell'esercizio (ove presenti), s
pero comunque che possa essere d'aiuto e se riuscite a trovare una soluzione migliore vi invito a condividerla e aggiungerla alla repository del corso :) 
- Azzurra */

#include <iostream>     // std::cout
#include <algorithm>    // std::sort
#include <vector>       // std::vector
using namespace std;

struct Node{
    int value;
	int dist;
    Node * left;
    Node * right;
    Node( int i ): value(i) , dist(-1), left(NULL) , right(NULL) {}
};

struct elem {
	int id;
	int d;
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


void distance(Node* tree, vector<elem>& v, int d) {
	if(tree) {
		// salvo la distanza d passata e la metto nel vettore v
		tree->dist = d;
		elem tmp;
		tmp.d = tree->dist;
		tmp.id = tree->value;
		v.push_back(tmp);
		// se il nodo è pari e d = -1 questo è il primo nodo pari del cammino quindi metto d = 1	
		if(tree->value % 2 == 0 && d == -1) {	
			d = 1; 
		}
		// se d è != -1 questo nodo fa parte di un cammino iniziato più in alto quindi devo solo incrementare
		else if (d != -1) {
			d++;
		}
		// cout<<"nodo: "<<tree->value<<" dist: "<<tree->dist<<endl;
		// se il nodo ha figli chiamo la funzione sui figli passandogli d e il vettore v 
		if(tree->left) 
			distance(tree->left, v, d);
		if(tree->right)
			distance(tree->right, v, d);	
	}
}

// ordino il vettore con gli elementi (id, distanza) per ordine decrescente di distanza
bool sortDesc(elem a, elem b) {
	if(a.d > b.d) 
		return true;	
	else if (a.d == b.d) {
		if (a.id < b.id) 
			return true;
		else 
			return false;
	}
	else
		return false;
}

int main() {	
	int n, k; 
	cin>>n>>k;

	int temp;
	BinTree tree;
	for(int i=0; i<n; i++) {
		cin>>temp;
		tree.insert(temp);
	}

	vector<elem> v;
	distance(tree.getRoot(), v, -1);	// O(n)
	sort(v.begin(), v.end(), sortDesc);	//O(nlogn)
	// se il vettore è più piccolo lo stamperò tutto	
	if (k >= v.size())
		k = v.size();
	for(int i=0; i<k; i++) {
		if(v[i].d > 0) {
			cout<<v[i].id<<endl;
		}
	}
	return 0;
}
		
		
	
	







