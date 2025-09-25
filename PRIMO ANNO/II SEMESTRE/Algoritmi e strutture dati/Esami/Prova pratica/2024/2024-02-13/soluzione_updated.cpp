#include<iostream> 
#include<vector> 
#include<algorithm> 
using namespace std; 


struct Node {
	int label; 
	Node* left; 
	Node* right; 
	explicit Node(int l): label(l), left(nullptr), right(nullptr) {}

} 


void insert(const Node* node, int label) {
	Node** it = &node; 
	while(*it != nullptr) {
		if(label <= (*it)->label) {
			it = &(*it)->left; 
		} else {
			it = &(*it)->right; 
		}
	} 
	*it = new Node(label);
} 



void solve(const Node* node, int sum, vector<pair<int, const Node*>> &v) {
	if(node == nullptr) return 0; 

	// sum = somma totale labels antenati 
	// l = somma labels sottoalbero sx, r = somma labels sottoalbero dx

	// recursive call to left and right 
	int l = solve(node->left, sum + node->label, v);
	int r = solve(node->right, sum + node->label, v); 
	int res = sum - l - r; // calc res f
	v.push_back({res, node});
	return r + l + n->label; // update total sum
}




int main() {
	int n, k; cin >> n >> k; 
	Node* node = nullptr;
	for(int i = 0; i < n; i++)  {
		int label; cin >> label; 
		insert(node, label);
	} 

	vector<pair<int, const Node*>> v; 
	solve(node, 0, v); 
	sort(v.begin(), v.end(), [](const auto &a, const auto& b) {
		auto [a_res, a_n] = a;
		auto [b_res, b_n] = b; 
		if(a_res == b_res) return a_n->label < b_n->label; // ordine non decrescente
		else return a_res < b_res;
	}); 

	for(auto [_,n] : v) {
		if(k == 0) break; 
		cout << n->label << endl;
		k--;

	}


}
