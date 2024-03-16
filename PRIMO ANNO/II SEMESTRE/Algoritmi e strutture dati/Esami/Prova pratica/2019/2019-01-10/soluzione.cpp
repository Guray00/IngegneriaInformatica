#include <iostream>
#include <vector>
#include <functional>
#include <optional>

static constexpr int P = 999149, A = 1000, B = 2000;

template<typename T>
struct HashTable {
    std::vector<std::vector<T> > table;
    std::function<int(T)> hash;

    HashTable(std::function<int(T)> hash, int size) : table{size}, hash{std::move(hash)} {
        for (auto &v: table) {
            v = std::vector<T>{};
        }
    }

    void insert(T value) {
        table[hash(value)].push_back(value);
    }
};

struct User {
    int id;
    int age;
};

int main() {
    int n, k, s;
    std::cin >> n >> k >> s;
    auto hash = [=](User user) { return (A * user.id + B) % P % s; };
    HashTable<User> table(hash, s);

    for (int i = 0; i < n; i++) {
        int id, age;
        std::cin >> id >> age;
        table.insert(User{id, age});
    }

    // using stable sort to preserve order of index with the same number of collisions
    std::stable_sort(table.table.begin(), table.table.end(), [](const auto &a, const auto &b) -> bool {
        return a.size() > b.size();
    });

    std::optional<User> max_user = std::nullopt;
    for (int i = 0; i < k; i++) {
        for (const auto &user: table.table[i]) {
            if (max_user == std::nullopt
                || user.age > max_user->age
                || (user.age == max_user->age && user.id < max_user->id)
            ) {
                max_user = user;
            }
        }
    }

    if (max_user != std::nullopt) {
        std::cout << max_user->id << std::endl;
        std::cout << max_user->age << std::endl;
    } else {
        std::cout << std::endl;
    }

    return 0;
}

