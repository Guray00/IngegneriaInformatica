#include <iostream>
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


std::pair<int, int> fill_set_with_satisfying(
    const Node *n,
    std::unordered_set<const Node *> &nodes,
    const Node *parent = nullptr
) {
    if (n == nullptr) {
        return {0, 0};
    }

    auto [cl, dl] = fill_set_with_satisfying(n->left, nodes, n);
    auto [cr, dr] = fill_set_with_satisfying(n->right, nodes, n);
    int concordants = cl + cr;
    int discordants = dl + dr;
    if (concordants > discordants) {
        nodes.insert(n);
    }
    if (parent != nullptr) {
        int inc = (n->left == nullptr && n->right == nullptr) + 1;
        if (n->label % 2 == parent->label % 2) {
            concordants += inc;
        } else {
            discordants += inc;
        }
    }

    return {concordants, discordants};
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


void print_tree(const Node *n, const std::unordered_set<const Node*> &nodes) {
    if (n == nullptr) {
        return;
    }
    
    print_tree(n->left, nodes);
    if (nodes.find(n) != nodes.end()) {
        std::cout << n->label << std::endl;
    }
    print_tree(n->right, nodes);
  
}


int main() {
    int n;
    std::cin >> n;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    Node *root = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(root, label);
    }

    std::unordered_set<const Node *> nodes{};
    fill_set_with_satisfying(root, nodes);
    print_tree(root, nodes);

    // destroy_tree(node);

    return 0;
}

