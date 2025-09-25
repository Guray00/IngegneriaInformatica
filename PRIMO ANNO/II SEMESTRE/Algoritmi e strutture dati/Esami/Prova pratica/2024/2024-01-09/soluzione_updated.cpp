#include<iostream>
using namespace std;
#include<vector>
struct Node {
	int label; 
	Node* right;
	Node* left;
	explicit Node(int label): label{label}, left{nullptr}, right{nullptr};
	
}

void insert(Node* &node, int label) {
	Node** scan = &node;
	while((*scan) != nullptr) {
		if(label > (*scan)->label) scan = &(*scan)->right;
		else scan = &(*scan)->right;
	}
	(*scan) = new Node(label);
}

void solve(Node* node, Node* ancestor, int dist, vector<pair<const Node*, int>> &good) {
	if(node == nullptr) return 0;

	if(node->label % 2 == 0) {
		ancestor = node;
		dist = 1;
	} 
	else if (ancestor != nullptr) dist++;

	solve(node->left, ancestor, dist, good);
	solve(node->right, ancestor, dist, good);

}



int main() {

	int n, k, x; cin >> n >> k;
	Node* root = nullptr;
	while(n--) { cin >> x; insert(root, x); } 
	vector<int> good; 
	solve(root, good);

}
