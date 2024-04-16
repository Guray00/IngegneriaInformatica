#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

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


void fill_vector(const Node *n, const int d, const int d_target, std::vector<const std::string *> &result) {
    if (n == nullptr) {
        return;
    }
    if (d == d_target) {
        result.push_back(&n->value);
        return;
    }
    fill_vector(n->left, d + 1, d_target, result);
    fill_vector(n->right, d + 1, d_target, result);

}

int main() {
    int n, d;
    std::cin >> n >> d;

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

    std::vector<const std::string *> result{};
    fill_vector(node, 0, d, result);
    std::sort(result.begin(), result.end(), [](const std::string *a, const std::string *b) {
        return *a < *b;
    });

    std::cout << result.size() << std::endl;
    for (const std::string *s : result) {
        std::cout << *s << std::endl;
    }
    
    // destroy_tree(node);

    return 0;
}

