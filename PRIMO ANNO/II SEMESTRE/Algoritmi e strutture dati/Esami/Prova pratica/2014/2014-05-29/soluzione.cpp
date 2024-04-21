#include <iostream>

struct Node {
    int label;
    std::string value;
    Node *left;
    Node *right;

    Node(int label, std::string value) : label{label}, value{std::move(value)}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_bst(Node *&n, int label, std::string value) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node{label, std::move(value)};
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


void find_less_than(const Node *n, const int k, const std::string *&min) {
    if (n == nullptr) {
        return;
    }
    if (n->label == k) {
        return;
    }
    if (min == nullptr || n->value < *min) {
        min = &n->value;
    }
    find_less_than(n->left, k, min);
    find_less_than(n->right, k, min);
}


const std::string *find_less_than2(const Node *n, const int k) {
    const std::string *min = nullptr;
    find_less_than(n, k, min);
    return min;
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
        std::string value;
        std::cin >> label >> value;
        insert_node_bst(node, label, std::move(value));
    }

    int k;
    std::cin >> k;

    const std::string *min = find_less_than2(node, k);
    if (min != nullptr) {
        std::cout << *min << std::endl;
    } else {
        std::cout << "vuoto" << std::endl;
    }
    
    // destroy_tree(node);

    return 0;
}

