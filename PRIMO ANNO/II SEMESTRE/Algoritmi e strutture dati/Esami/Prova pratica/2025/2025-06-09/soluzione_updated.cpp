#include<iostream>
using namespace std;
#include<vector>

const int p = 999149, a = 1000, b = 2000;

struct Missione {
	int mat;
	int cat;
	float spesa;
	Missione(int m, int c, float s) : mat(m), cat(c), spesa(s) {}

};

struct Node {
	int label;
	Missione m;
	Node* right;
	Node* left;
	Node(Missione _m) : label(_m.mat), m(_m), right(NULL), left(NULL) { }
};


void insert_tree(Node* &node, Missione m) {
	Node** scan = &node;
	while(*scan != NULL) {
		if(m.mat <= (*scan)->label) scan = &(*scan)->left;
		else scan = &(*scan)->right;
	}
	*scan = new Node(m);
};

struct Info {
	int num;
	float spesa;
	Info() : num(0), spesa(0) { }

};

struct HashTable {
	vector<Node*> table;
	vector< vector<Info> > s_c;

	HashTable(int C) {
		table = vector<Node*>(C, NULL);
		s_c = vector< vector<Info> >(C);
		for (int i = 0; i < C; ++i)
			s_c[i].resize(C);
	}

	int hash(int C, int m) {
		return ((a * m + b) % p) % C;
	}

	void insert(int C, Missione m) {
		int idx = hash(C, m.mat);
		insert_tree(table[idx], m);
		s_c[idx][m.cat].num++;
		s_c[idx][m.cat].spesa += m.spesa;
	}

};


void print_tree(int categoria, Node* node) { 
	if(node == NULL) return;
	print_tree(categoria, node->left);
	if(node->m.cat == categoria) cout << node->label << ' ';
	print_tree(categoria, node->right);
}

int main() {
	int N, C; cin >> N >> C;
	HashTable ht(C);

	while(N--) {
		int mat, cat; float spesa;
		cin >> mat >> cat >> spesa;
		ht.insert(C, Missione(mat,cat,spesa));
	}

	for(int i = 0; i < C; i++) {
		int cat_max = -1; float s_max = 0;
		for(int j = 0; j < C; j++) {
			if(ht.s_c[i][j].num != 0 && ((ht.s_c[i][j].spesa / ht.s_c[i][j].num) > s_max)) {
					s_max = ht.s_c[i][j].spesa / ht.s_c[i][j].num;
					cat_max = j;
			}
		} 

		//cout << i << ' ' << cat_max << ' ' << s_max << endl;

		// max found for an idx, print tree 
		print_tree(cat_max, ht.table[i]);
		cout << endl;
	}
}
