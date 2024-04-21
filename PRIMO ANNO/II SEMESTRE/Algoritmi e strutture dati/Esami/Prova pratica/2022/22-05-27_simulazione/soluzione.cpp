#include <iostream>

struct Node {
    int label;

    Node *left;
    Node *right;

    explicit Node(int label) : label{label}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_bst(Node *&n, int val) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (val <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node{val};
}


std::pair<bool, int> check_balance(Node *n) {
    if (n == nullptr) {
        return {true, 0};
    }
    auto [b1, lh] = check_balance(n->left);
    if (!b1) {
        return {false, 0};
    }
    auto [b2, rh] = check_balance(n->right);
    if (!b2) {
        return {false, 0};
    }
    return {std::abs(lh - rh) <= 1, std::max(lh, rh) + 1};
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


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

    auto [b, _] = check_balance(node);
    std::cout << (b ? "ok" : "no") << std::endl;
    // destroy_tree(node);

    return 0;
}


