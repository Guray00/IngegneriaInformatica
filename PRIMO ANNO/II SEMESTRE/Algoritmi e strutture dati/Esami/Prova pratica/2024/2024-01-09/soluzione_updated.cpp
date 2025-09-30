#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

struct Node {
    int label;
    Node* left;
    Node* right;
    Node* parent;
    Node(int l) : label(l), left(NULL), right(NULL), parent(NULL) {}
};

void insert(Node*& root, int value) {
    if (root == NULL) {
        root = new Node(value);
        return;
    }
    Node* cur = root;
    Node* par = NULL;
    while (cur != NULL) {
        par = cur;
        if (value <= cur->label) cur = cur->left;
        else cur = cur->right;
    }
    Node* node = new Node(value);
    node->parent = par;
    if (value <= par->label) par->left = node;
    else par->right = node;
}

void collect_nodes(Node* node, vector<Node*>& out) {
    if (node == NULL) return;
    out.push_back(node);
    collect_nodes(node->left, out);
    collect_nodes(node->right, out);
}

bool cmp(const pair<int,int>& A, const pair<int,int>& B) {
    if (A.first != B.first) return A.first > B.first; // D decrescente
    return A.second > B.second; // label decrescente
}

int main() {
    int N, K;
    cin >> N >> K;
    Node* root = NULL;
    for (int i = 0; i < N; ++i) {
        int x; cin >> x;
        insert(root, x);
    }

    vector<Node*> all;
    collect_nodes(root, all);

    vector< pair<int,int> > res; // (D(x), label)
    for (size_t i = 0; i < all.size(); ++i) {
        Node* cur = all[i];
        int dist = 1;
        Node* p = cur->parent;
        int D = -1;
        while (p != NULL) {
            if ((p->label % 2) == 0 || p->label == 0) { D = dist; break; }
            ++dist;
            p = p->parent;
        }
        if (D > 0) res.push_back(make_pair(D, cur->label));
    }

    sort(res.begin(), res.end(), cmp);

    for (int i = 0; i < K && i < (int)res.size(); ++i) {
        cout << res[i].second << '\n';
    }

    return 0;
}

