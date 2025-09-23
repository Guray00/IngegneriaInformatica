#include<iostream>
using namespace std;

#include<algorithm>
#include<vector>

// percorso percorribile + lungo 
// a parita' considerare id in ordine non decr 

struct Node {
	int id;
	int w;
	Node* left;
	Node* right;
	explicit Node(int _id, int _w) : id(_id), w(_w), left(NULL), right(NULL) { }
};

void insert(Node* &node, int id, int w) {
	Node** scan = &node;
	while(*scan != NULL) {
		if(id <= (*scan)->id) scan = &(*scan)->left;
		else scan = &(*scan)->right;
	}
	*scan = new Node(id, w);
}

void solve(Node* node, int cost, int len, pair<int, int> &path) {
	if(node == NULL || cost < 0) return;

	// leaf
	if(node->left == NULL && node->right == NULL) {
		//cout << node->id << endl;
		if(node->w + cost < 0) return;
		if(len > path.second || ((len == path.second) && (node->id < path.first))) 
			path = make_pair(node->id, len);
		return;
	}

	// continue
	solve(node->left, cost + node->w, len+1, path);
	solve(node->right, cost + node->w, len+1, path);
}

bool comparator(pair<int,int> a, pair<int,int> b) {
	return a.second > b.second || ((a.second == b.second) && (a.first < b.first)); 
}

int main() {
	int n, c; cin >> n >> c;
	Node* root = NULL;
	while(n--) {
		int id, w; cin >> id >> w;
		insert(root, id, w);
	}
	pair<int,int> path = make_pair(-1,-1);
	solve(root, c, -1, path);
	cout << path.first << ' ' << path.second << endl;
	

}
