#include<iostream>
using namespace std;
#include<vector>
#include<algorithm>

struct Node {
	int label;
	Node* right;
	Node* left;
	explicit Node(int l) : label(l), right(NULL), left(NULL) {}
};


void insert(Node* &node, int l) {
	Node** scan = &node;
	while(*scan != NULL) {
		if(l <= (*scan)->label) scan = &(*scan)->left;
		else scan = &(*scan)->right;
	}
	*scan = new Node(l);
}

int solve(Node* node, vector< pair<int,int> > &res, int lvl) {
	if(node == NULL) return 0;
	if(node->left == NULL && node->right == NULL) return 1;
	int leaves = solve(node->left, res, lvl+1) + solve(node->right, res, lvl+1);
	//cout << leaves << endl;
	if(leaves % 2 == 0) res.push_back(make_pair(node->label, lvl));
	return leaves;
}

bool cmp(pair<int,int> a, pair<int,int> b) {
	return (a.second > b.second) || ((a.second == b.second) && (a.first > b.first));
}

int main() {
	int n, k; cin >> n >> k;
	Node* root = NULL;
	while(n--) {
		int l; cin >> l;
		insert(root,l);
	}

	vector< pair<int,int> > res;
	solve(root, res, 0);
	sort(res.begin(), res.end(), cmp);
	for(int i = 0; i < res.size() && i < k; i++) cout << res[i].first << endl;

}
