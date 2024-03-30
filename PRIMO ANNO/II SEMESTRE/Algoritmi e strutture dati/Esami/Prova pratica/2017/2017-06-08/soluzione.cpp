#include <iostream>
#include <unordered_map>

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



bool is_property_satisfied(const Node &n, const Node &parent) { 
    return n.left == nullptr && n.right == nullptr && n.label % 2 != parent.label % 2;

}


int set_property_count(const Node *n, 
        std::unordered_map<const Node*, int> &m, 
        const Node *parent = nullptr) {
    if (n == nullptr) {
        return 0;
    }
    int l = set_property_count(n->left, m, n);
    int r = set_property_count(n->right, m, n);
    int count = l + r;
    m[n] = count;
    if (parent != nullptr) {
        count += is_property_satisfied(*n, *parent);
    }
    return count;
}


void print_tree(const Node *n, std::unordered_map<const Node *, int> &nodes) {
    if (n == nullptr) {
        return;
    }
    print_tree(n->left, nodes);
    std::cout << nodes[n] << std::endl;
    print_tree(n->right, nodes);
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
    
    std::unordered_map<const Node *, int> nodes(n);
    set_property_count(node, nodes);
    print_tree(node, nodes);

    // destroy_tree(node);

    return 0;
}

