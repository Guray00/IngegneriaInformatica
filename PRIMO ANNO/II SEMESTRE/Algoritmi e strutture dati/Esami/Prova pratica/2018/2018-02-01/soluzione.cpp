// TOOD: complexity O(n)
#include <algorithm>
#include <iostream>
#include <vector>
#include <unordered_set>

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


bool is_leaf(Node &n) {
    return n.left == nullptr && n.right == nullptr;
}

std::pair<int, int> fill_set_with_satisfying(
    Node *n,
    std::unordered_set<Node *> &nodes,
    Node *parent = nullptr
) {
    if (n == nullptr) {
        return {0, 0};
    }

    auto [cl, dl] = fill_set_with_satisfying(n->left, nodes, n);
    auto [cr, dr] = fill_set_with_satisfying(n->right, nodes, n);
    int concordants = cl + cr;
    int discordants = dl + dr;
    if (concordants >= discordants) {
        nodes.insert(n);
    }
    if (parent != nullptr && is_leaf(*n)) {
        if (n->label % 2 == parent->label % 2) {
            concordants += 1;
        } else {
            discordants += 1;
        }
    }
        
    return {concordants, discordants};
}


void print_tree(Node *n, std::unordered_set<Node *> &nodes) {
    if (n == nullptr) {
        return;
    }
    print_tree(n->left, nodes);
    if (nodes.find(n) != nodes.end()) {
        std::cout << n->label << std::endl;
    }
    print_tree(n->right, nodes);
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

    auto nodes = std::unordered_set<Node *>(n);
    (void) fill_set_with_satisfying(node, nodes);
    print_tree(node, nodes);

    // destroy_tree(node);

    return 0;
}
