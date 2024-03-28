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

void insert_node_bst(Node *&n, int val, int weight) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (val <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node(val, weight);
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


bool is_property_satisfied(Node *n, int k) {
    int tmp = 0;
    for (auto child: {n->left, n->right}) {
        if (child != nullptr) {
            tmp += child->weight;
            for (auto nephew: {child->left, child->right}) {
                if (nephew != nullptr) {
                    tmp += nephew->weight;
                }
            }
        }
    }
    return n->weight * k < tmp;
}


void get_max_satisfying(Node *n, int k, Node * &curr) {
    if (n == nullptr) {
        return;
    }
    if (is_property_satisfied(n, k)) {
        if (curr == nullptr
            || curr->weight < n->weight
            || (curr->weight == n->weight && curr->label < n->label)
        ) {
            curr = n;
        }
    }
    get_max_satisfying(n->left, k, curr);
    get_max_satisfying(n->right, k, curr);
}


std::optional<int> get_max_property_label(Node *node, int k) {
    Node *n = nullptr;
    get_max_satisfying(node, k, n);
    return n == nullptr ? std::nullopt : std::optional(n->label);
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
    //
    // if (k > n) {
    //     throw std::invalid_argument("k must be less than n");
    // }
    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label, weight;
        std::cin >> label >> weight;
        insert_node_bst(node, label, weight);
    }

    auto v = get_max_property_label(node, k);
    if (v.has_value()) {
        std::cout << v.value() << std::endl;
    } else {
        std::cout << std::endl;
    }
    // destroy_tree(node);

    return 0;
}
