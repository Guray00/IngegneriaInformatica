#include<iostream>
#include<algorithm>
#include<vector>
using namespace std;
#include<utility> // pair
const int p=999149 , a=1000, b=2000;

struct Node {
	int label;
	Node* right;
	Node* left;
	explicit Node(int l) : label(l), left(NULL), right(NULL) {}
};

void insert_abr(Node* &node, int l) {
	Node** scan = &node;
	while(*scan != NULL) {
		if(l <= (*scan)->label) scan = &(*scan)->left;
		else scan = &(*scan)->right;
	}
	(*scan) = new Node(l);
}

struct HashTable{
	int size;
	vector<Node*> table;
	HashTable(size_t _size) : size(_size), table(size, NULL) {}

	int hash(int x) {
		return (((a * x) + b) % p) % size;
	}

	void insert(int x) {
		int idx = hash(x);
		//cout << "Inserting " << x << " at index " << idx << endl;
		insert_abr(table[idx],x);
	}
};

pair<int,int> solve(Node* node) {
	if (node == NULL) return make_pair(0, 0);

	int ndx = 0, nsx = 0;

	// left child is a leaf
	if (node->left != NULL && node->left->left == NULL && node->left->right == NULL) {
		nsx++;
	}
	// right
	if (node->right != NULL && node->right->left == NULL && node->right->right == NULL) {
		ndx++;
	}

	pair<int, int> l = solve(node->left);
	pair<int, int> r = solve(node->right);

	ndx += l.first + r.first;
	nsx += l.second + r.second;

	return make_pair(ndx, nsx);
}


int main() {
	int n, s; cin >> n >> s;
	HashTable ht(s);


	for(int i = 0; i < n; i++) {
		int x; cin >> x;
		ht.insert(x);
	}

	vector< pair<int,int> > res;

	for(int i = 0; i < ht.table.size(); i++) {
		res.push_back(solve(ht.table[i]));
		//cout << "Root " << i << ": dx = " << res[i].first << ", sx = " << res[i].second << endl;
	}

	// idx with max dx; idx with max sx
	int max_dx = 0, max_sx = 0;
	for(int i = 1; i < res.size(); i++) {
		if(ht.table[i] == NULL) continue;
		//cout << "Index: " << i << ", dx: " << res[i].first << ", sx: " << res[i].second << endl;
		if(res[i].first > res[max_dx].first || ((res[i].first == res[max_dx].first) && i > max_dx)) max_dx = i;
		if(res[i].second > res[max_sx].second  || ((res[i].second == res[max_sx].second) && i > max_sx)) max_sx = i;
	}

	cout << max_dx << endl << max_sx << endl;
}
