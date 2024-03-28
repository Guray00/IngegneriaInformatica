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


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


int find_valid_nodes(const Node *n, const Node *father, int a, int b, std::unordered_set<const Node *> &valid_nodes) {
    if (n == nullptr) {
        return 0;
    }

    if (n->left == nullptr && n->right == nullptr) {
        return father == nullptr ? 0 : father->left == nullptr || father->right == nullptr;
    }

    int l_tree_unique_leaves = find_valid_nodes(n->left, n, a, b, valid_nodes);
    int r_tree_unique_leaves = find_valid_nodes(n->right, n, a, b, valid_nodes);
    int unique_leaves = l_tree_unique_leaves + r_tree_unique_leaves;
    if (unique_leaves >= a && unique_leaves <= b) {
        valid_nodes.insert(n);
    }
    return unique_leaves;
}

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
    int n, a, b;
    std::cin >> n >> a >> b;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    // if (a < 0) {
    //     throw std::invalid_argument("a must be greater or equal to 0");
    // }


    // if (b < 0) {
    //     throw std::invalid_argument("b must be greater or equal to 0");
    // }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }

    std::unordered_set<const Node *> valid_nodes{};
    find_valid_nodes(node, nullptr, a, b, valid_nodes);
    print_tree(node, valid_nodes);

    // destroy_tree(node);

    return 0;
}

