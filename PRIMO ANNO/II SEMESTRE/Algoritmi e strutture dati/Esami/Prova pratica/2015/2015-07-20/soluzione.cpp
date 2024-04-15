#include <iostream>
#include <vector>
#include <algorithm>
#include <limits>


struct Node {
    int label;
    Node *left;
    Node *right;

    explicit Node(int label) : label{label}, left{nullptr}, right{nullptr} {
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


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


int height(Node *n) {
    if (n == nullptr) {
        return 0;
    }
    int h_l = height(n->left);
    int h_r = height(n->right);
    return 1 + std::max(h_l, h_r);
}


int n_nodes_at_height(const Node *n, const int h_target, const int d = 0) {
    if (n == nullptr) {
        return 0;
    }
    if (d == h_target) {
        return 1; 
    }
    return n_nodes_at_height(n->left, h_target, d + 1) + n_nodes_at_height(n->right, h_target, d + 1);
}


int main() {
    int N, D;
    std::cin >> N >> D;

    // if (N <= 0) {
    //     throw std::runtime_error("N must be positive");
    // }

    // if (D <= 0) {
    //     throw std::runtime_error("D must be positive");
    // }

    std::vector<Node*> trees(D);
    
    for (int i = 0; i < N; i++) {
        int val, id;
        std::cin >> val >> id;
        insert_node_bst(trees[id], val);
    }

    int min_h = std::numeric_limits<int>::max();
    for (auto scan : trees) {
        // "the height of the root node is 0"
        int h = height(scan) - 1;
        if (h < min_h) {
            min_h = h;
        }
    }

    std::vector<std::pair<int /* id */, int /* number */>> v(D);
    for (int i = 0; i < D; i++) {
        int n = n_nodes_at_height(trees[i], min_h);
        v[i] = {i, n};
    }

    std::sort(v.begin(), v.end(), [](auto a, auto b) {
        auto [id_a, n_a] = a;
        auto [id_b, n_b] = b;
        return n_a > n_b || (n_a == n_b && id_a > id_b);    
    });

    for (auto [id, _] : v) {
        std::cout << id << std::endl;
    }

    // for (auto tree : trees) {
    //     destroy_tree(tree);
    // }

    return 0;
}
