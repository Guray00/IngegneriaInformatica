#include <iostream>
#include <vector>
#include <functional>
#include <optional>

static constexpr int P = 999149, A = 1000, B = 2000;

template<typename T>
struct HashTable {
    std::vector<std::vector<T> > table;
    std::function<int(T)> hash;

    HashTable(std::function<int(T)> hash, size_t size) : table{size}, hash{std::move(hash)} { }

    void insert(T value) {
        table[hash(value)].push_back(value);
    }
};


struct Worker {
    int id;
    std::string surname;
};


std::optional<int> find_min(const std::vector<Worker> &v) {
    if (v.empty()) {
        return std::nullopt;
    }
    const Worker *min = &v[0];
    for (const auto &w : v) {
        if (w.surname < min->surname || (w.surname == min->surname && w.id < min->id)) {
            min = &w;
        }
    }
    return min->id;
}


int main() {
    int n, k;
    std::cin >> n >> k;

    // if (s < 0) {
    //     throw std::invalid_argument("s must be non-negative");
    // }

    auto hash = [=](Worker worker) { return (A * worker.id + B) % P % (2 * n); };
    std::vector<std::vector<Worker> > v{};
    {
        HashTable<Worker> table{hash, (size_t) 2 * n};

        for (int i = 0; i < n; i++) {
            int id;
            std::string surname;
            std::cin >> id >> surname;
            table.insert(Worker{id, surname});
        }
        v = std::move(table.table);
    }

    // using stable sort to preserve order of index with the same number of collisions
    std::stable_sort(v.begin(), v.end(), [](const auto &a, const auto &b) -> bool {
        return a.size() > b.size();
    });

    for (int i = 0; i < k; i++) {
        auto min = find_min(v[i]);
        if (min.has_value()) {
            std::cout << *min << std::endl;
        } else {
            std::cout << -1 << std::endl;
        }
    }

    return 0;
}

