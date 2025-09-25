#include<iostream>
using namespace std;
#include<vector>
#include<algorithm>
struct Node {

	int label;
	int p;
	int cmax;
	Node* right;
	Node* left;
	explicit Node(int l, int _p, int c): label(l), p(_p), cmax(c), right(NULL), left(NULL) { } 
};

void insert(Node* &node, int l, int p, int cmax) {
	Node** scan = &node;
	while(*scan != NULL) {
		if(l <= (*scan)->label) scan = &(*scan)->left;
		else scan = &(*scan)->right;
	}
	*scan = new Node(l, p, cmax);
}

// sum p, if for every nodes p < c, ok
int solve(Node* node, vector<int> &bad) {
	if(node == NULL) return 0;
	int l = solve(node->left, bad), r = solve(node->right, bad);
	if( l + r > node->cmax) {
		bad.push_back(node->label);
	}
	//cout << "id: " << node->label << ":  " <<  l+r << ' ' << node->cmax << endl;
	return l + r + node->p;
}

int main() {
	int n;
	cin >> n;
	Node* root = NULL;
	while(n--) {
		int id, p, cmax;
		cin >> id >> p >> cmax;
		insert(root, id, p, cmax);
	}

	vector<int> bad;
	solve(root, bad);
	if(bad.size() != 0) {
		cout << "no" << endl;
		sort(bad.begin(), bad.end());

		for(int i = 0; i < bad.size(); i++) cout << bad[i] << endl;

	}
	else cout << "ok" << endl;


}
