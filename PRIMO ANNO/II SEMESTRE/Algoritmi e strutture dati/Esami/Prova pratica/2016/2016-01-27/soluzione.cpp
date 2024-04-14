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


struct Account {
    int id;
    std::string surname;
};


int main() {
    int N;
    std::cin >> N;

    // if (N <= 0) {
    //     throw std::invalid_argument("s must be positive");
    // }

    auto hash = [=](Account user) { return (A * user.id + B) % P % (2 * N); };
    std::vector<std::vector<Account> > v{};
    {
        HashTable<Account> table{hash, (size_t) 2 * N};

        for (int i = 0; i < N; i++) {
            int id;
            std::string surname;
            std::cin >> id >> surname;
            table.insert(Account{id, surname});
        }
        v = std::move(table.table);
    }

    size_t max_idx = 0;
    size_t max_size = 0;
    
    for (size_t i = 0; i < v.size(); i++) {
        if (v[i].size() > max_size) {
            max_size = v[i].size();
            max_idx = i;
        }
    }

    const auto &bucket_target = v[max_idx];
    if (bucket_target.empty()) {
        return 0;
    }

    const std::string *surname = &bucket_target[0].surname;
    int id = bucket_target[0].id;
    for (size_t i = 1; i < bucket_target.size(); i++) {
        const auto &cur = bucket_target[i];
        if (cur.surname < *surname || (cur.surname == *surname && cur.id < id)) {
            surname = &cur.surname;
            id = cur.id;
        }
    }

    std::cout << id << std::endl;

    return 0;
}

