#include <algorithm>
#include <iostream>
#include <vector>

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

void fill_vector(Node *n, std::vector<std::pair<int, int>> &v, int level = 0) {
    if (n == nullptr) {
        return;
    }
    if (v.size() < level + 1) {
        v.emplace_back();
    }
    v[level].first += n->label;
    v[level].second = level;
    fill_vector(n->left, v, level + 1);
    fill_vector(n->right, v, level + 1);
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

    // if (k <= 0) {
    //     throw std::invalid_argument("k must be greater than 0");
    // }

    // if (k > n) {
    //     throw std::invalid_argument("k must be less than n");
    // }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }

    std::vector<std::pair<int, int>> v{};

    fill_vector(node, v);

    std::sort(v.begin(), v.end(), [](auto a, auto b) {
        auto [a_weight, a_level] = a;
        auto [b_weight, b_level] = b;
        if (a_weight > b_weight) {
            return true;
        }
        if (a_weight == b_weight) {
            return a_level > b_level;
        }
        return false;
    });

    v.resize(k);

    std::sort(v.begin(), v.end(), [](auto a, auto b) {
        auto [a_weight, a_level] = a;
        auto [b_weight, b_level] = b;
        return a_level < b_level;
    });

    for (auto [weight, _] : v) {
        std::cout << weight << std::endl;
    }

    // destroy_tree(node);

    return 0;
}


