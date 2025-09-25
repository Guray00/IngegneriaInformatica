#include<iostream>
using namespace std; 
#include<algorithm>
#include<unordered_set>


// x soddisfa P se altezza sottoalberi dx, sx in x differiscono meno di K


struct Node {
	int label;
	Node* left;
	Node* right;
	explicit Node(int label) : label{label}, left{nullptr}, right{nullptr} {}
};


void insert(Node* &node, int label) {
	Node **it = &node; 
	while(*it != nullptr) {
		if(label <= (*it)->label) {
			it = &(*it)->left;
		} else {
			it = &(*it)->right;
		}
	}
	*it = new Node(label);

}


int get_nodes(const Node* n, const int k, unordered_set<const Node*> &good_nodes) {
	if(n == nullptr) return 0; 

	int l_height = get_nodes(n->left, k, good_nodes);
	int r_height = get_nodes(n->right, k, good_nodes); 

	if(abs(l_height - r_height) < k) good_nodes.insert(n);

	return 1 + max(l_height,r_height);

} 



void print_tree(const Node* n, unordered_set<const Node*> &nodes) {
	if(n == nullptr) return; 

	print_tree(n->left, nodes); 
	if(nodes.find(n) != nodes.end()) cout << n->label << endl;
	print_tree(n->right, nodes);

}




int main() {
	int n, k; 
	cin >> n >> k; 
	Node* node = nullptr; 
	for(int i = 0; i < n; i++) {
		int label; 
		cin >> label; 
		insert(node, label);
	}
	unordered_set<const Node*> good{};
	get_nodes(node, k, good); 
	print_tree(node, good); 
	return 0;

}
