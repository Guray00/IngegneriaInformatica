#include <algorithm>
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


bool is_leaf(const Node *n) {
    return n->left == nullptr && n->right == nullptr;
}


int get_satisfying_nodes(const Node* n, const int k, std::unordered_set<const Node*> &good_nodes) {
    if (n == nullptr) {
        return 0;
    }
    int l_h = get_satisfying_nodes(n->left, k, good_nodes);
    int r_h = get_satisfying_nodes(n->right, k, good_nodes);
    if (!is_leaf(n) && std::abs(l_h - r_h) <= n->label / k) {
        good_nodes.insert(n);
    }

    return 1 + std::max(l_h, r_h);
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
    int n, k;
    std::cin >> n >> k;

    //  if (n <= 0) {
    //      throw std::invalid_argument("n must be greater than 0");
    //  }

    //  if (k <= 0) {
    //      throw std::invalid_argument("k must be greater than 0");
    //  }

    //  if (k > n) {
    //      throw std::invalid_argument("k must be less than n");
    //  }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }

    std::unordered_set<const Node *> good_nodes{};
    get_satisfying_nodes(node, k, good_nodes);
    print_tree(node, good_nodes);    

    // destroy_tree(node);

    return 0;
}

