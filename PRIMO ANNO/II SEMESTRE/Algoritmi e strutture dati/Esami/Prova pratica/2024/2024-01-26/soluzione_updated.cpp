#include <iostream>
#include <algorithm>
#include <vector>
#include <cmath>
using namespace std;

struct Node {
    int label;
    Node* left;
    Node* right;
    Node(int label) : label(label), left(NULL), right(NULL) {}
};

void insert(Node*& node, int label) {
    Node** it = &node;
    while (*it != NULL) {
        if (label <= (*it)->label) {
            it = &(*it)->left;
        } else {
            it = &(*it)->right;
        }
    }
    *it = new Node(label);
}

int get_nodes(const Node* n, int k, vector<const Node*>& good_nodes) {
    if (n == NULL) return 0;
    int l_height = get_nodes(n->left, k, good_nodes);
    int r_height = get_nodes(n->right, k, good_nodes);
    if (abs(l_height - r_height) < k) good_nodes.push_back(n);
    return 1 + max(l_height, r_height);
}

bool in_vector(const vector<const Node*>& v, const Node* x) {
    for (size_t i = 0; i < v.size(); i++) {
        if (v[i] == x) return true;
    }
    return false;
}

void print_tree(const Node* n, const vector<const Node*>& nodes) {
    if (n == NULL) return;
    print_tree(n->left, nodes);
    if (in_vector(nodes, n)) cout << n->label << endl;
    print_tree(n->right, nodes);
}

int main() {
    int n, k;
    cin >> n >> k;
    Node* node = NULL;
    for (int i = 0; i < n; i++) {
        int label;
        cin >> label;
        insert(node, label);
    }
    vector<const Node*> good;
    get_nodes(node, k, good);
    print_tree(node, good);
    return 0;
}

