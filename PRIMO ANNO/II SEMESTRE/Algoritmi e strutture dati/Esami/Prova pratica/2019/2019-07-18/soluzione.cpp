#include <iostream>
#include <vector>
#include <unordered_map>
#include <algorithm>
#include <functional>

static constexpr int P = 999149, A = 1000, B = 2000;

struct Vehicle {
    int plate;
    int category;
};

template<typename T>
struct HashTable {
    std::vector<std::vector<T>> table;
    std::function<int(T)> hash;

    HashTable(std::function<int(T)> hash, size_t size) : table{size}, hash{std::move(hash)} {  }

    void insert(T value) {
        table[hash(value)].push_back(value);
    }
};


int main() {
    int n, k, c;
    std::cin >> n >> k >> c;
    auto hash = [=](Vehicle vehicle) { return (A * vehicle.plate + B) % P % c; };
    std::vector<std::vector<Vehicle>> hash_table{};
    {
        HashTable<Vehicle> ht(hash, c);
        for (int i = 0; i < n; i++) {
            int plate, category;
            std::cin >> plate >> category;
            ht.insert({plate, category});
        }
        hash_table = std::move(ht.table);
    }

    std::vector<std::pair<int, int>> index_max_count{};
    {
        std::unordered_map<int, int> category_counts{};
        for (int i = 0; i < c; i++) {
            category_counts.clear();
            for (const auto& vehicle : hash_table[i]) {
                category_counts[vehicle.category]++;
            }
            int max_count = 0;
            for (auto [_category, count] : category_counts) {
                if (count > max_count) {
                    max_count = count;
                }
            }
            index_max_count.push_back({i, max_count});
        }
    }

    std::stable_sort(index_max_count.begin(), index_max_count.end(), [](auto a, auto b) {
        auto [_a_index, a_count] = a;
        auto [_b_index, b_count] = b;
        return a_count > b_count;
    });

    for (auto [index, _] : index_max_count) {
        if (k == 0) {
            break;
        }
        std::cout << index << std::endl;
        k--;
    }

    return 0;
}

