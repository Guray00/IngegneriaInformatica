#include <iostream>
#include <optional>
#include <vector>

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


bool is_leaf(Node *n) {
    return n != nullptr && n->left == nullptr && n->right == nullptr;
}

bool is_node_balanced(Node *n) {
    if (n == nullptr) {
        return false;
    }
    return is_leaf(n->left) && is_leaf(n->right);
}

Node *some_if_only_child(const Node &n) {
    if (n.left != nullptr && n.right == nullptr) {
        return n.left;
    }

    if (n.left == nullptr && n.right != nullptr) {
        return n.right;
    }
    return nullptr;
}

bool is_node_not_balanced(const Node &n) {
    Node *only_child = some_if_only_child(n);
    return only_child != nullptr && is_leaf(only_child);
}

std::pair<int, int> get_winner(Node *n, std::optional<std::pair<Node *, int> > &winner) {
    if (n == nullptr) {
        return {0, 0};
    }
    auto [neq_l, eq_l] = get_winner(n->left, winner);
    auto [neq_r, eq_r] = get_winner(n->right, winner);
    auto neq = neq_l + neq_r + is_node_not_balanced(*n);
    auto eq = eq_l + eq_r + is_node_balanced(n);
    int f = neq - eq;
    if (
        winner == std::nullopt
        || f > winner->second
        || (f == winner->second && n->label < winner->first->label)
    ) {
        winner = {n, f};
    }

    return {neq, eq};
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


    std::optional<std::pair<Node *, int> > winner = std::nullopt;
    get_winner(node, winner);
    if (winner.has_value()) {
        auto [winner_node, f] = winner.value();
        std::cout << winner_node->label << std::endl;
        std::cout << f << std::endl;
    } else {
        std::cout << "No winner" << std::endl;
    }


    // destroy_tree(node);

    return 0;
}

