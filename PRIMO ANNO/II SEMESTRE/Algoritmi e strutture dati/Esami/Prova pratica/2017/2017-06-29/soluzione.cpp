#include <algorithm>
#include <functional>
#include <iostream>
#include <type_traits>
#include <vector>

static constexpr int P = 999149, A = 1000, B = 2000;

struct Node {
    int label;
    int count;
    Node *left;
    Node *right;

    explicit Node(int label) : label{label}, count{1}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_bst(Node *&n, int label) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label < (*scan)->label) {
            scan = &(*scan)->left;
        } else if (label > (*scan)->label) {
            scan = &(*scan)->right;
        } else {
            (*scan)->count++;
            return;
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


struct NodeHashTable {
    std::vector<Node *> table;
    std::function<int(const int)> hash;

    NodeHashTable(std::function<int(const int)> hash, size_t size) : table(size), hash{std::move(hash)} { }

    void insert(int value) {
        size_t id = hash(value);
        insert_node_bst(table[id], value);
    }
};


template <typename Compare>
std::pair<int, int> get_most(std::array<std::pair<int, int>, 3> a, Compare compare_fn) {
    std::pair<int, int> rv = a[0];
    for (int i = 1; i < 3; i++) {
        if (compare_fn(a[i], rv)) {
            rv = a[i];
        }
    }
    return rv;
}


std::pair<int, int> get_d(const Node* n) {
    if (n == nullptr) {
        return {-1, -1};
    }
    
    auto l = get_d(n->left);
    auto r = get_d(n->right);

    return get_most({l, r, {n->label, n->count}}, [](auto a, auto b) {
        auto [a_label, a_count] = a;
        auto [b_label, b_count] = b;
        return a_count > b_count || (a_count == b_count && a_label > b_label);
    });
}


int main() {
    int n, k, s;
    std::cin >> n >> k >> s;
    
    // if (n < 0) {
    //     throw std::invalid_argument("n must be non-negative");
    // }

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


    std::vector<int> res{};
    for (Node *scan : v) {
        int val = get_d(scan).first;
        if (val >= 0) {
            res.push_back(val);
        }
    }

    std::sort(res.begin(), res.end(), std::greater<int>());

    k = std::min(k, (int) res.size());

    for (int i = 0; i < k; i++) {
        std::cout << res[i] << std::endl;
    }

    // for (size_t i = 0; i < s; i++) {
    //     if (v[i] == nullptr) {
    //         continue;
    //     }
    //     destroy_tree(v[i]);
    // }

    return 0;
}

