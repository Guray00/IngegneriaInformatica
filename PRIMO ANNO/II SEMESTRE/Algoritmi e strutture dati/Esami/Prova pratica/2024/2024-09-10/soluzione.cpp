#include <iostream>
#include <set>


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


template <typename F>
int find_valid_nodes(const Node *n, int level, std::set<std::pair<const Node *, int>, F> &valid_nodes) {
    if (n == nullptr) {
        return 0;
    }

    if (n->left == nullptr && n->right == nullptr) {
        return 1;
    }

    int l_leaves = find_valid_nodes(n->left, level + 1, valid_nodes);
    int r_leaves = find_valid_nodes(n->right, level + 1, valid_nodes);
    int leaves = l_leaves + r_leaves;
    if (leaves % 2 == 0) {
        valid_nodes.insert({n, level});
    }
    return leaves;
}


int main() {
    int n, k;
    std::cin >> n >> k;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    // if (k < 0) {
    //     throw std::invalid_argument("k must be greater or equal to 0");
    // }


    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }


    auto compare = [](auto const &x, auto const &y) {
        auto [x_node, x_level] = x;
        auto [y_node, y_level] = y;

        if (x_level != y_level) {
            return x_level > y_level;
        }
        return x_node->label > y_node->label;
    };

    auto valid_nodes = std::set<std::pair<const Node *, int>, decltype(compare)>{compare};
    find_valid_nodes(node, 0, valid_nodes);

    for (const auto &[node, _] : valid_nodes) {
        if (k == 0) {
            break;
        }
        std::cout << node->label << std::endl;
        k--;
    }

    // destroy_tree(node);

    return 0;
}

