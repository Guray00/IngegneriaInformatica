#include <iostream>
#include <unordered_set>


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


int fill_nodes(const Node *n, const int k, std::unordered_set<const Node *> &good_nodes) {
    if (n == nullptr) {
        return 0;
    }
    int s = fill_nodes(n->left, k, good_nodes);
    int d = fill_nodes(n->right, k, good_nodes);
    if (s * k < d) {
        good_nodes.insert(n);
    }
    return s + d + n->label;
}


void print_good_nodes(const Node *n, const std::unordered_set<const Node *> &good_nodes) {
    if (n == nullptr) {
        return;
    }
    print_good_nodes(n->left, good_nodes);
    if (good_nodes.find(n) != good_nodes.end()) {
        std::cout << n->label << std::endl;
    }
    print_good_nodes(n->right, good_nodes);

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

    std::unordered_set<const Node *> good_nodes{};
    fill_nodes(node, k, good_nodes);   
    print_good_nodes(node, good_nodes);

    // destroy_tree(node);

    return 0;
}


