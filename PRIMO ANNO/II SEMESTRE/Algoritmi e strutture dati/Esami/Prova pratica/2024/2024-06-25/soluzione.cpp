#include <algorithm>
#include <functional>
#include <optional>
#include <iostream>
#include <vector>
#include <string>
#include <cstdint>
#include <limits>

using u32 = std::uint32_t;


template <typename K, typename V>
struct BstNode {
    K key;
    V value;
    std::optional<u32> left;
    std::optional<u32> right;

    BstNode(K key, V value) : key{key}, value{value}, left{std::nullopt}, right{std::nullopt} {  }
};


u32 as_u32(size_t t) {
    static_assert(sizeof(size_t) >= sizeof(u32));
    if (t > std::numeric_limits<u32>::max()) {
        throw std::invalid_argument("size_t is too large to fit in u32");
    }
    return static_cast<u32>(t);
}


template <typename K, typename V>
struct Bst {
    // Utilize a std::vector to store the nodes, leveraging the compiler-generated 
    // copy and move constructors which are sufficient for our use case.
    // Moreover, using raw pointers is extremely error-prone, and in C++ if we can avoid them, we should.
    std::vector<BstNode<K, V>> nodes;
    std::optional<u32> root;

    Bst() : root{std::nullopt} {  }

    std::optional<V> insert(K key, V value) {
        std::optional<u32> p = root;
        std::optional<u32> q = std::nullopt;

        while (p != std::nullopt) {
            auto &tmp = nodes[*p];
            if (key < tmp.key) {
                q = p;
                p = tmp.left;
            } else if (key > tmp.key) {
                q = p;
                p = tmp.right;
            } else {
                auto old_value = tmp.value;
                tmp.value = value;
                return old_value;
            }
        }

        u32 id = as_u32(nodes.size());
        nodes.emplace_back(key, value);

        if (q == std::nullopt) {
            root = id;
        } else {
            if (key < nodes[*q].key) {
                nodes[*q].left = id;
            } else {
                nodes[*q].right = id;
            }
        }
        return std::nullopt;
    }
};


size_t abs_diff(size_t a, size_t b) {
    return a > b ? a - b : b - a;
}


size_t __get_valid(const std::vector<BstNode<int, std::string>> &nodes, 
        std::optional<int> n, 
        size_t &v, 
        size_t level) {

    if (n == std::nullopt) {
        return 0;
    }

    const BstNode<int, std::string> &node = nodes[*n];
    size_t l = __get_valid(nodes, node.left, v, level + 1);
    size_t r = __get_valid(nodes, node.right, v, level + 1);
    if (abs_diff(l, r) <= level) {
        v++;
    }
    return std::max({node.value.size(), l, r});
}


size_t get_valid(const Bst<int, std::string> &bst) {
    size_t v = 0;
    __get_valid(bst.nodes, bst.root, v, 0);
    return v;
}


template <typename K, typename V>
struct HashTableNode {
    K key;
    V value;

    HashTableNode(K key, V value) : key{key}, value{value} {  }
};


template <typename K, typename V>
struct HashTable {
    std::vector<Bst<K, V>> table;
    std::function<int(const K&)> hash;

    HashTable(std::function<int(const K&)> hash, size_t size) : table{size}, hash{std::move(hash)} {  }

    std::optional<V> insert(K key, V value) {
        int index = hash(key) % table.size(); 
        Bst<K, V> &bucket = table[index];
        return bucket.insert(key, value);
    }

};


int main() {
    int n, k, m;
    std::cin >> n >> k >> m;
    
    // if (n < 0) {
    //     throw std::invalid_argument("n must be non-negative");
    // }

    // if (k < 0) {
    //     throw std::invalid_argument("k must be non-negative");
    // }

    // if (m < 0) {
    //     throw std::invalid_argument("m must be non-negative");
    // }
    
    static constexpr int P = 999149, A = 1000, B = 2000;
    auto hash = [=](const int &i) { return (A * i + B) % P % m; };

    std::vector<Bst<int, std::string>> v;
    {
        HashTable<int, std::string> table{hash, (size_t) m};

        for (int i = 0; i < n; i++) {
            int integer;
            std::string s;
            std::cin >> integer >> s;
            table.insert(integer, s);
        }
        v = std::move(table.table);
    }

    for (size_t i = 0; i < v.size(); i++) {
        if (get_valid(v[i]) >= k) {
            std::cout << i << std::endl;
        }
    }
    
    return 0;
}


