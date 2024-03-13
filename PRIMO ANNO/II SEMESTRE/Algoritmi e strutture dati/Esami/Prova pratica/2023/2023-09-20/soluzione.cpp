#include <iostream>
#include <optional>
#include <queue>
#include <vector>

struct Node {
    int label;
    int weight;
    Node *left;
    Node *right;

    explicit Node(int label, int weight) : label{label}, weight{weight}, left{nullptr}, right{nullptr} {
    }
};

void insert_node_abr(Node *&n, int val, int weight) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (val <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node(val, weight);
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }



bool is_property_satisfied(Node *n, int k) {
    int tmp = 0;
    for (auto child : {n->left, n->right}) {
        if (child != nullptr) {
            tmp += child->weight;
            for (auto nephew : {child->left, child->right}) {
                if (nephew != nullptr) {
                    tmp += nephew->weight;
                }
            }
        }
    }
    return n->weight * k < tmp;
}

template<typename F>
void insert_satisfying_into_queue(Node *n, int k, std::priority_queue<Node*, std::vector<Node*>, F> &res) {
    if (n == nullptr) {
        return;
    }
    if (is_property_satisfied(n, k)) {
        res.push(n);
    }
    insert_satisfying_into_queue(n->left, k, res);
    insert_satisfying_into_queue(n->right, k, res);
}


std::optional<int> get_max_property_label(Node *node, int k) {
    auto compare = [](Node *a, Node *b) {
        if (a->weight == b->weight) {
            return a->label < b->label;
        }
        return a->weight < b->weight;
    };
    auto queue = std::priority_queue<Node*, std::vector<Node*>, decltype(compare)>{compare};
    insert_satisfying_into_queue(node, k, queue);
    if (!queue.empty()) {
        return queue.top()->label;
    }
    return std::nullopt;
}

int main() {
    int n, k;
    std::cin >> n >> k;
    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }
    // if (k <= 0) {
    //     throw std::invalid_argument("k must be greater than 0");
    // }
    //
    // if (k > n) {
    //     throw std::invalid_argument("k must be less than n");
    // }
    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label, weight;
        std::cin >> label >> weight;
        insert_node_abr(node, label, weight);
    }

    auto v = get_max_property_label(node, k);
    if (v.has_value()) {
        std::cout << v.value() << std::endl;
    } else {
        std::cout << std::endl;
    }
    // // destroy_tree(node);

    return 0;
}
