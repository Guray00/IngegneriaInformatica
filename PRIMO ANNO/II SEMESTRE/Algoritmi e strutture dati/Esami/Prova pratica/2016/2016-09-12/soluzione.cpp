#include <iostream>
#include <vector>
#include <functional>
#include <algorithm>

struct Node {
    int label;
    Node *left;
    Node *right;

    explicit Node(int label) : label{label}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_bst(Node *&n, Node *node) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (node->label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = node;
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
    std::vector<Node*> table;
    std::function<int(const Node&)> hash;

    NodeHashTable(std::function<int(const Node&)> hash, size_t size) : table{size}, hash{std::move(hash)} { }

    void insert(Node *value) {
        size_t id = hash(*value);
        insert_node_bst(table[id], value);
    }
};


int height(Node *n) {
    if (n == nullptr) {
        return 0;
    }
    return 1 + std::max(height(n->left), height(n->right));
}


int main() {
    int n, k, s;
    std::cin >> n >> k >> s;

    // if (s < 0) {
    //     throw std::invalid_argument("s must be non-negative");
    // }

    k = std::min(k, s);
    
    auto hash = [=](const Node &node) { return (A * node.label + B) % P % s; };
    std::vector<Node* > v{};
    {
        NodeHashTable table{hash, (size_t) s};

        for (int i = 0; i < n; i++) {
            int label;
            std::cin >> label;
            Node *node = new Node(label);
            table.insert(node); 
        }

        v = std::move(table.table);
    }

    std::vector<std::pair<int, int>> vv(s);
    for (size_t i = 0; i < s; i++) {
        vv[i] = {i, height(v[i])};
    }

    // use stable_sort to keep the order of the elements with the same height
    std::stable_sort(vv.begin(), vv.end(), [](auto a, auto b) { 
        return a.second > b.second;
    });

    for (int i = 0; i < k; i++) {
        std::cout << vv[i].first << std::endl;
    }

    // for (size_t i = 0; i < s; i++) {
    //     if (v[i] == nullptr) {
    //         continue;
    //     }
    //     destroy_tree(v[i]);
    // }

    return 0;
}

