#include <algorithm>
#include <functional>
#include <unordered_map>
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

    V* get_mut(const K& key) {
        std::optional<u32> scan = root;
        while (scan != std::nullopt) {
            auto &tmp = nodes[*scan];
            if (key < tmp.key) {
                scan = tmp.left;
            } else if (key > tmp.key) {
                scan = tmp.right;
            } else {
                return &tmp.value;
            }
        }
        return nullptr;
    }

    template <typename F>
    void for_each(F f) const {
        for (auto const &node : nodes) {
            f(node.key, node.value);
        }
    }
};


template <typename K, typename V>
struct HashTableNode {
    K key;
    V value;

    HashTableNode(K key, V value) : key{key}, value{value} {  }
};


template <typename K, typename V>
struct HashTable {
    std::vector<std::vector<HashTableNode<K, V>>> table;
    std::function<int(const K&)> hash;

    HashTable(std::function<int(const K&)> hash, size_t size) : table{size}, hash{std::move(hash)} {  }

    std::optional<V> insert(K key, V value) {
        int index = hash(key) % table.size(); 
        std::vector<HashTableNode<K, V>> &bucket = table[index];
        auto it = std::find_if(bucket.begin(), bucket.end(), [&](const auto& x) { 
            return x.key == key; 
        });
        auto node = HashTableNode<K, V>{key, value};
        if (it == bucket.end()) {
            bucket.push_back(node);
            return std::nullopt;
        } else {
            auto ret = *it;
            *it = node;
            return ret.value;
        }
    }

    V* get_mut(const K& key) {
        int index = hash(key) % table.size(); 
        for (auto& t : table[index]) {
            if (t.key == key) {
                return &t.value;
            }
        }
        return nullptr;
    }


    template <typename F>
    void for_each(F f) const {
        for (const auto& bucket : table) {
            for (const auto& node : bucket) {
                f(node.key, node.value);
            }
        }
    }
};


struct Teacher {
    std::string name;
    Bst<int /* local id */, int /* members count */> courses;

    explicit Teacher(std::string name) : name{std::move(name)} {  }
};


int main() {
    int n, m;
    std::cin >> n >> m;
    
    // if (n < 0) {
    //     throw std::invalid_argument("n must be non-negative");
    // }

    // if (m < 0) {
    //     throw std::invalid_argument("m must be non-negative");
    // }
    
    static constexpr int P = 999149, A = 1000, B = 2000;
    auto hash = [=](const int &x) { return (A * x + B) % P % (n * 2); };
    
    HashTable<int, Teacher> table{hash, (size_t) n * 2};

    for (int i = 0; i < n; i++) {
        int id;
        std::string name;
        std::cin >> id >> name;
        table.insert(id, Teacher{name});
    }

    
    for (int i = 0; i < m; i++) {
        int id;
        int code;
        std::cin >> id >> code;
        Teacher *teacher = table.get_mut(id);
        if (teacher == nullptr) {
            throw std::invalid_argument("teacher not found");
        }
        if (int *t = teacher->courses.get_mut(code)) {
            *t += 1;
        } else {
            teacher->courses.insert(code, 1);
        }
    }

    std::unordered_map<const Teacher*, int> max_courses;

    // O(n * m)
    table.for_each([&](auto _, const Teacher &teacher) {
        int max = 0;
        teacher.courses.for_each([&](auto _, int members) {
            max = std::max(max, members);
        });
        max_courses[&teacher] = max;
    });

    // O(n)
    auto max = std::max_element(max_courses.begin(), max_courses.end(), [](const auto &a, const auto &b) {
        auto [name_a, members_a] = a;
        auto [name_b, members_b] = b;
        return members_a < members_b || (members_a == members_b && name_a->name > name_b->name);
    });
    
    auto [teacher, members] = *max;
    std::cout << teacher->name << std::endl;

    return 0;
}

