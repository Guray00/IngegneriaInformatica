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


std::pair<int, int> foo(const Node *n, int level, std::vector<const Node*> &v) {
    if (n == nullptr) {
        return {0, 0};
    }

    auto [l_evn, l_odd] = foo(n->left, level + 1, v);
    auto [r_evn, r_odd] = foo(n->right, level + 1, v);

    if (std::abs(l_odd - r_evn) <= level) {
        v.push_back(n);
    }
    int evn = l_evn + r_evn;
    int odd = l_odd + r_odd;
    if (n->label % 2 == 0) {
        return {evn + 1, odd};
    } else {
        return {evn, odd + 1};
    }
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

    std::vector<const Node*> v;
    foo(node, 0, v);
    std::sort(v.begin(), v.end(), [](const auto &a, const auto &b) {
        return a->label < b->label;
    });

    for (const Node *n : v) {
        if (k == 0) {
            break;
        }
        std::cout << n->label << std::endl;
        k--;
    }


    // destroy_tree(node);

    return 0;
}

