#include<iostream>
using namespace std;
#include<vector>
#include<string>
#include<algorithm>
const int p=999149 , a=1000, b=2000;
struct Node {
	int label;
	string s;
	Node* right;
	Node* left;
	explicit Node(int l, string _s) : label(l), s(_s), right(NULL), left(NULL) {}

};

void insert_tree(Node* &node, int l, string s) {
	Node** scan = &node;

	while(*scan != NULL) {
		if((*scan)->label > l) scan = &(*scan)->left;
		else scan = &(*scan)->right;
	}
	*scan = new Node(l, s);
}


struct HashTable {
	vector<Node*> table;

	HashTable(int m)  : table(m, NULL) {}
	int hash(int l, int m) { return ((a * l + b) % p) % m; }

	void insert(int l, string s, int m) {
		insert_tree(table[hash(l,m)], l, s);
	}
};


// sx-dx <= lev -> valid
int solve(Node* node, int lvl, int &v) {
	if(node == NULL) return 0;
	int sx = solve(node->left, lvl+1, v);
	int dx = solve(node->right, lvl+1, v);
	int maxlen = max(max(((int)(node->s).size()), dx), sx); // current len
	if(abs(sx - dx) <= lvl) v++;
	return (maxlen);
}

int main() {
	int n,k,m; cin >> n >> k >> m;
	HashTable ht(m);
	while(n--) {
		int x; string s;
		cin >> x >> s;
		ht.insert(x,s,m);
	}

	int v;
	for(int i = 0; i < ht.table.size(); i++) {
		v = 0;
		solve(ht.table[i], 0, v);
		if(v >= k) cout << i << endl;
	}
}



