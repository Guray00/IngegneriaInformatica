#include <algorithm>
#include <iostream>
#include <vector>

struct Node {
    int label;
    Node *left;
    Node *right;

    explicit Node(int label) : label{label}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_abr(Node *&n, int label) {
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


std::pair<int, int> fill_vector_with_satisfying(
    Node *n,
    Node *parent,
    std::vector<Node *> &nodes
) {
    if (n == nullptr) {
        return {0, 0};
    }

    auto [cl, dl] = fill_vector_with_satisfying(n->left, n, nodes);
    auto [cr, dr] = fill_vector_with_satisfying(n->right, n, nodes);
    int concordants = cl + cr;
    int discordants = dl + dr;
    if (concordants > discordants) {
        nodes.push_back(n);
    }
    if (parent != nullptr) {
        int inc = n->left == nullptr && n->right == nullptr ? 2 : 1;
        if (n->label % 2 == parent->label % 2) {
            concordants += inc;
        } else {
            discordants += inc;
        }
    }

    return {concordants, discordants};
}


std::vector<Node *> foo(Node *n) {
    std::vector<Node *> nodes{};
    (void) fill_vector_with_satisfying(n, nullptr, nodes);
    std::sort(nodes.begin(), nodes.end(), [](Node *a, Node *b) {
        return a->label < b->label;
    });
    return nodes;
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
        insert_node_abr(node, label);
    }

    auto rv = foo(node);
    for (auto n: rv) {
        std::cout << n->label << std::endl;
    }

    // destroy_tree(node);

    return 0;
}

