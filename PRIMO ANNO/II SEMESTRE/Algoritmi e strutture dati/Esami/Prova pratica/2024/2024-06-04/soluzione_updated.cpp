#include<iostream>
using namespace std;
#include<vector>
#include<algorithm>


struct Node {
	int label;
	Node* right;
	Node* left;
	Node(int l): label(l), right(NULL), left(NULL) { }
};


void insert(Node* &node, int l) {
	Node** scan = &node;
	while(*scan != NULL) {
		if(l <= (*scan)->label) scan = &(*scan)->left;
		else scan = &(*scan)->right;
	}
	*scan = new Node(l);
}

pair<int,int> solve(Node* node, int lev, vector<int> &res) {
	if(node == NULL) return make_pair(0,0);
	pair<int,int> l = solve(node->left, lev+1, res);
	pair<int,int> r = solve(node->right, lev+1, res);
	if(abs(l.second - r.first) <= lev) res.push_back(node->label);
	if(node->label % 2 == 0) return make_pair(l.first + r.first + 1, r.second + l.second);
	return make_pair(l.first + r.first, r.second + l.second + 1);
}


bool cmp(int a, int b) {
	return a < b;
}

int main() {
	int n, k; cin >> n >> k;
	Node* node = NULL;
	while(n--) {
		int x; cin >> x;
		insert(node, x);
	}

	vector<int> res;
	solve(node, 0, res);
	sort(res.begin(), res.end(), cmp);
	for(int i = 0; i < res.size() && i < k; i++) cout << res[i] << endl;

}
