#include <iostream>
#include <vector>
#include <functional>
#include <optional>
#include <algorithm>
#include <iostream>
#include <vector>
#include <type_traits>
#include <optional>

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


static constexpr int P = 999149, A = 1000, B = 2000;


struct NodeHashTable {
    std::vector<Node *> table;
    std::function<int(const int)> hash;

    NodeHashTable(std::function<int(const int)> hash, size_t size) : table(size), hash{std::move(hash)} { }

    void insert(int value) {
        size_t id = hash(value);
        insert_node_bst(table[id], value);
    }
};


bool is_leaf(const Node &n) {
    return n.left == nullptr && n.right == nullptr;
}


bool is_right_leaf(const Node &n, const Node &father) {
    return is_leaf(n) && father.right == &n;
}


bool is_left_leaf(const Node &n, const Node &father) {
    return is_leaf(n) && father.left == &n;
}


std::pair<int, int> get_num_left_and_right_leaves(const Node *n, const Node *father) {
    if (n == nullptr) {
        return {0, 0};
    }
    auto [nsx_l, ndx_l] = get_num_left_and_right_leaves(n->left, n);
    auto [nsx_r, ndx_r] = get_num_left_and_right_leaves(n->right, n);
    int nsx = nsx_l + nsx_r;
    int ndx = ndx_l + ndx_r;
    if (father != nullptr) {
        nsx += is_left_leaf(*n, *father);
        ndx += is_right_leaf(*n, *father);
    }
    return {nsx, ndx};
}


int main() {
    int n, s;
    std::cin >> n >> s;

    // if (s < 0) {
    //     throw std::invalid_argument("s must be non-negative");
    // }
    
    auto hash = [=](const int label) { return (A * label + B) % P % s; };
    std::vector<Node* > v{};
    {
        NodeHashTable table{hash, (size_t) s};

        for (int i = 0; i < n; i++) {
            int label;
            std::cin >> label;
            table.insert(label);
        }
        v = std::move(table.table);
    }

    std::optional<std::pair<size_t, int>> max_nsx = std::nullopt;
    std::optional<std::pair<size_t, int>> max_ndx = std::nullopt;
    for (size_t i = 0; i < s; i++) { 
        auto [nsx, ndx] = get_num_left_and_right_leaves(v[i], nullptr);
        if (max_nsx == std::nullopt || nsx >= max_nsx->second) {
            max_nsx = {i, nsx}; 
        }

        if (max_ndx == std::nullopt || ndx >= max_ndx->second) {
            max_ndx = {i, ndx};
        }
    }

    if (max_ndx != std::nullopt) {
        std::cout << max_ndx->first << std::endl;
    }

    if (max_nsx != std::nullopt) {
        std::cout << max_nsx->first << std::endl;
    }

    // for (size_t i = 0; i < s; i++) {
    //     if (v[i] == nullptr) {
    //         continue;
    //     }
    //     destroy_tree(v[i]);
    // }

    return 0;
}

