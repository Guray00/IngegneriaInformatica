#include <iostream>
#include <vector>
#include <algorithm>
#include <unordered_set>

struct Node {
    int label;
    Node *left;
    Node *right;

    Node(int label) : label{label}, left{nullptr}, right{nullptr} {
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
    *scan = new Node{label};
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }

std::pair<int, int> find_satisfying(const Node* node, std::unordered_set<const Node*> &good_nodes) {
    if (!node)
        return {0, 0};

    if (node->left == nullptr && node->right == nullptr) {
        if (node->label >= 0) {
            good_nodes.insert(node);
        }
        return {0, node->label};
    }

    auto [l_i, l_f] = find_satisfying(node->left, good_nodes);
    auto [r_i, r_f] = find_satisfying(node->right, good_nodes);

    int i = node->label + l_i + r_i;
    int f = l_f + r_f;
    if (i <= f) {
        good_nodes.insert(node);
    }
    return {i, f};
}


void print(const Node *n, const std::unordered_set<const Node *> &good_nodes) {
    if (n == nullptr) {
        return;
    }
    print(n->left, good_nodes);
    if (good_nodes.find(n) != good_nodes.end()) {
        std::cout << n->label << ' '; 
    }
    print(n->right, good_nodes);
}


int main() {
    int n;
    std::cin >> n;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }

    std::unordered_set<const Node*> good_nodes{};
    find_satisfying(node, good_nodes);
    print(node, good_nodes);
    
    // destroy_tree(node);

    return 0;
}

