#include<iostream>
#include<vector>
#include<utility>
#include<algorithm>
using namespace std;

struct Node {
	int label;
	Node* right;
	Node* left;
	explicit Node(int l): label(l), right(NULL), left(NULL) {}

};

void insert(Node* &node, int l) {
	Node** scan = &node;
	while(*scan != NULL)  {
		if(l <= (*scan)->label) scan = &(*scan)->left;
		else scan = &(*scan)->right;
	}
	*scan = new Node(l);
}

int find_height(Node* node, int dist) {
	if(node == NULL)  return dist-1; 
	return max(find_height(node->left, dist+1), find_height(node->right, dist+1));
}

void in_order_insert(Node* &high_node,Node* low_node) {
	if(low_node == NULL) return;
	in_order_insert(high_node, low_node->left);
	insert(high_node, low_node->label);
	in_order_insert(high_node, low_node->right);
}

void in_order_leaves(Node* node) {
	if(node == NULL) return;
	in_order_leaves(node->left);
	if(node->left == NULL && node->right == NULL) cout << node->label << endl;
	in_order_leaves(node->right);
}

int main() {
	int n,  d; cin >> n >> d;
	vector<Node*> trees(d, NULL); 
	while(n--) {
		int l, idx; cin >> l >> idx;
		insert(trees[idx], l);
		//cout << trees[idx] << endl;
	}

	// low, high
	pair<int,int> low = make_pair(0,find_height(trees[0], 0)); 
	pair<int,int> high = low;
	for(int i = 1; i < d; i++) {
		int tmp = find_height(trees[i], 0);
		//cout << tmp << endl;
		if(tmp > high.second || (tmp == high.second && i > high.first)) high = make_pair(i, tmp);
		if(tmp < low.second || (tmp == low.second && i < low.first)) low = make_pair(i, tmp);
	} 

	//cout << high.first << ' ' << low.first << endl;

	// move tree!
	in_order_insert(trees[high.first], trees[low.first]);
	in_order_leaves(trees[high.first]);
	


}
