#include <algorithm>
#include <iostream>
#include <vector>
#include <unordered_set>


// I don't use intrusive fields, because I don't want to modify the Node struct adapting
// it to the specific problem. If you want to use intrusive fields, you can. But I won't do.
struct Node {
    int label;
    Node *left;
    Node *right;

    explicit Node(int label) : label(label), left(nullptr), right(nullptr) {
    }
};

void insert_node_bst(Node *&n, int label) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node(label);
}


void destroy_tree(Node *n) {
    if (n == nullptr) {
        return;
    }
    destroy_tree(n->left);
    destroy_tree(n->right);
    delete n;
}


int fill_set_with_satisfying(const Node *n, std::unordered_set<const Node*> &median_nodes, int d = 0) {
    if (n == nullptr) {
        return 0;
    }

    int ll = fill_set_with_satisfying(n->left, median_nodes, d + 1);
    int lr = fill_set_with_satisfying(n->right, median_nodes, d + 1);

    int l = std::max(ll, lr);

    if (std::abs(l - d) <= 1) {
        median_nodes.insert(n);
    }
    return l + 1;
}



void print_tree(const Node *n, const std::unordered_set<const Node*> &median_nodes, int &k) {
    if (n == nullptr) {
        return;
    }
    
    print_tree(n->left, median_nodes, k);
    if (k == 0) {
        return;
    }
    if (median_nodes.find(n) != median_nodes.end()) {
        std::cout << n->label << std::endl;
        k--;
    }
    print_tree(n->right, median_nodes, k);
  
}


int main() {
    int n, k;
    std::cin >> n >> k;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    // if (k <= 0) {
    //     throw std::invalid_argument("k must be greater than 0");
    // }

    k = std::min(n, k);

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int tmp;
        std::cin >> tmp;
        insert_node_bst(node, tmp);
    }

    std::unordered_set<const Node *> median_nodes{};

    fill_set_with_satisfying(node, median_nodes);

    print_tree(node, median_nodes, k);

    // destroy_tree(node);

    return 0;
}

