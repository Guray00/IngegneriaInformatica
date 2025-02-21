#include <iostream>
#include <optional>
#include <vector>
#include <algorithm>

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


int foo(const Node *n, int sum, std::vector<std::pair<int, const Node*>> &v) {
    if (n == nullptr) {
        return 0;
    }

    int l = foo(n->left, sum + n->label, v);
    int r = foo(n->right, sum + n->label, v);
    int f = sum - l - r;
    v.push_back({f, n});
    return l + r + n->label;

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

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }

    std::vector<std::pair<int, const Node*>> v;
    foo(node, 0, v);
    std::sort(v.begin(), v.end(), [](const auto &a, const auto &b) {
        auto [a_f, a_n] = a;
        auto [b_f, b_n] = b;
        if (a_f == b_f) {
            return a_n->label < b_n->label;
        } else {
            return a_f < b_f;
        }
    });

    for (auto [_, n] : v) {
        if (k == 0) {
            break;
        }
        std::cout << n->label << std::endl;
        k--;
    }


    // destroy_tree(node);

    return 0;
}

