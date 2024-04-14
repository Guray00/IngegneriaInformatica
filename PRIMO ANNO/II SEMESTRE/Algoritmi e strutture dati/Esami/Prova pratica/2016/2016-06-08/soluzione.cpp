#include <iostream>
#include <unordered_set>
#include <array>


struct Node {
    int label;
    int weight;
    int max_load;
    Node *left;
    Node *right;

    explicit Node(int label, int weight, int max_load) : 
        label{label},
        weight{weight}, 
        max_load{max_load},
        left{nullptr}, 
        right{nullptr} {
    }
};


void insert_node_bst(Node *&n, int label, int weight, int max_load) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node{label, weight, max_load};
}


int check_integrity(const Node *n, std::unordered_set<const Node *> &no_good_nodes) {
    if (n == nullptr) {
        return 0;
    }
    int l_load = check_integrity(n->left, no_good_nodes);
    int r_load = check_integrity(n->right, no_good_nodes);
    int load = l_load + r_load;
    if (load > n->max_load) {
        no_good_nodes.insert(n);
    }
    return load + n->weight;
}


void print_no_good_nodes(const Node *n, const std::unordered_set<const Node *> &no_good_nodes) {
    if (n == nullptr) {
        return;
    }
    print_no_good_nodes(n->left, no_good_nodes);  
    if (no_good_nodes.find(n) != no_good_nodes.end()) {
        std::cout << n->label << std::endl;
    }
    print_no_good_nodes(n->right, no_good_nodes);

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
        int label, weight, max_load;
        std::cin >> label >> weight >> max_load;
        insert_node_bst(node, label, weight, max_load);
    }

    std::unordered_set<const Node *> no_good_nodes{};
    check_integrity(node, no_good_nodes);

    if (no_good_nodes.empty()) {
        std::cout << "ok" << std::endl;
    } else {
        std::cout << "no" << std::endl;
        print_no_good_nodes(node, no_good_nodes);
    }

    // destroy_tree(node);

    return 0;
}
