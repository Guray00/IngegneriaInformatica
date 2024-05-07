#include <iostream>
#include <optional>


struct Node {
    int label;
    int weight;
    Node *left;
    Node *right;

    explicit Node(int label, int weight) : label{label}, weight{weight}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_bst(Node *&n, int label, int weight) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node(label, weight);
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


std::pair<const Node *, const Node *> get_max_satisfying(const Node *n, int k, const Node *&curr) {
    if (n == nullptr) {
        return {nullptr, nullptr};
    }

    auto [l_nephew1, l_nephew2] = get_max_satisfying(n->left, k, curr);
    auto [r_nephew1, r_nephew2] = get_max_satisfying(n->right, k, curr);

    int tmp = 0;
    for (const Node *scan : {(const Node *) n->left,
                            l_nephew1, 
                            l_nephew2, 
                            (const Node*) n->right, 
                            r_nephew1, 
                            r_nephew2}) {
        if (scan != nullptr) {
            tmp += scan->weight;
        }
    }

    if (n->weight * k < tmp) {
         if (curr == nullptr
            || curr->weight < n->weight 
            || (curr->weight == n->weight && curr->label < n->label)
        ) {
            curr = n;
        }
    }
    return {n->left, n->right};
}


std::optional<int> get_max_property_label(const Node *node, int k) {
    const Node *n = nullptr;
    auto _ = get_max_satisfying(node, k, n);
    return n == nullptr ? std::nullopt : std::optional{n->label};
}


int main() {
    int n, k;

    std::cin >> n >> k;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    // if (k <= 0) {
    //     throw std::invalid_argument("k must be greater than 0");
    // }
    
    // if (k > n) {
    //     throw std::invalid_argument("k must be less than n");
    // }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label, weight;
        std::cin >> label >> weight;
        insert_node_bst(node, label, weight);
    }

    if (auto v = get_max_property_label(node, k)) {
        std::cout << *v << std::endl;
    } else {
        std::cout << std::endl;
    
    }

    // destroy_tree(node);

    return 0;
}
