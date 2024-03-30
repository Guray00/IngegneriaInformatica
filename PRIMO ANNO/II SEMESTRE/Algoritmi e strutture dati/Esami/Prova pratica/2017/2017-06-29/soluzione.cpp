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


template<typename T, std::enable_if_t<std::is_pointer_v<T>, bool> = true>
struct HashTable {
    std::vector<T> table;
    std::function<int(std::remove_pointer_t<T>&)> hash;

    HashTable(std::function<int(std::remove_pointer_t<T>&)> hash, size_t size) : table{size}, hash{std::move(hash)} { }

    // return the first element in the bucket
    T& get(T value) {
        auto &bucket = table[hash(*value)];
        return bucket;
    }

    void insert(T value) {
        table[hash(*value)] = value;
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
    
    auto hash = [=](Node &node) { return (A * node.label + B) % P % s; };
    std::vector<Node* > v{};
    {
        HashTable<Node*> table{hash, (size_t) s};

        for (int i = 0; i < n; i++) {
            int label;
            std::cin >> label;
            auto node = Node{label};
            Node *&n = table.get(&node);
            if (n != nullptr){
                insert_node_bst(n, label);
            } else {
                auto node = new Node{label};
                table.insert(node);
            }
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

