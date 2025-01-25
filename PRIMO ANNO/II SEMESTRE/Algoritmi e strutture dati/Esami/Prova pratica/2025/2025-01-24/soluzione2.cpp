// Simplified solution, avoiding requirements of custom data structures, but using STL ones.
// It should be clear how the use of custom containers is just an implementation detail in this case.

#include <algorithm>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

struct Teacher {
    std::string name;
    std::unordered_map<int, int> courses;

    Teacher() = default;

    explicit Teacher(std::string name) : name{std::move(name)}, courses{} {  }
};


int main() {
    int N, M;
    std::cin >> N >> M;
   
    std::unordered_map<int, Teacher> teachers;

    for (int i = 0; i < N; i++) {
        int id;
        std::string name;
        std::cin >> id >> name;
        teachers[id] = Teacher{name};
    }

    for (int i = 0; i < M; i++) {
        int id, code;
        std::cin >> id >> code;
        if (teachers.find(id) == teachers.end()) {
            throw std::invalid_argument("teacher not found");
        }
        teachers[id].courses[code]++;
    }

    std::vector<std::pair<int, std::string>> stats;

    for (auto &[_, teacher] : teachers){
        int max_members = 0;
        for(auto [_, members] : teacher.courses){
            max_members = std::max(max_members, members);
        }
        stats.push_back({ max_members, teacher.name });
    }

    auto best = std::max_element(stats.begin(), stats.end(), [](const auto &a, const auto &b) {
        auto [max_members_a, name_a] = a;
        auto [max_members_b, name_b] = b;

        if (max_members_a < max_members_b) {
            return true;
        }
        if (max_members_a > max_members_b) {
            return false;
        }
        return name_a > name_b;

    });

    std::cout << best->second << std::endl;


    return 0;
}

