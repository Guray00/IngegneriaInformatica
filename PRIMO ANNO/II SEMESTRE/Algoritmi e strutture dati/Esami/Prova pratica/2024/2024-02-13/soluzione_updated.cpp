#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

struct Node {
    int label;
    Node* left;
    Node* right;
    Node(int l) : label(l), left(NULL), right(NULL) {}
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

int solve(const Node* node, int sum, vector<pair<int, const Node*> >& v) {
    if (node == NULL) return 0;
    int l = solve(node->left, sum + node->label, v);
    int r = solve(node->right, sum + node->label, v);
    int res = sum - l - r;
    v.push_back(make_pair(res, node));
    return l + r + node->label;
}

bool cmp(const pair<int, const Node*>& a, const pair<int, const Node*>& b) {
    if (a.first == b.first) return a.second->label < b.second->label;
    return a.first < b.first;
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
    vector<pair<int, const Node*> > v;
    solve(node, 0, v);
    sort(v.begin(), v.end(), cmp);
    for (size_t i = 0; i < v.size() && k > 0; i++, k--) {
        cout << v[i].second->label << endl;
    }
    return 0;
}