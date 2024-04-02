#include <iostream>
#include <vector>

struct Node {
    int label;
    Node *left;
    Node *right;

    explicit Node(int label) : label{label}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_bst(Node *&n, int label) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
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


void fill_vector(const Node *n, std::vector<std::pair<int, int>> &m, int h = 1) {
    if (n == nullptr) {
        return;
    }
    
    auto [count, max_label] = m[h - 1];
    m[h - 1] = {count + 1, std::max(max_label, n->label)};

    fill_vector(n->left, m, h + 1);
    fill_vector(n->right, m, h + 1);
}


int get_score(int h, int count) {
    return (1 << h) * count / h;
}


int get_max_score_label(const std::vector<std::pair<int, int>> &m) {
    int max_score = 0;
    int max_label = 0;
    int h = 0;
    for (const auto [count, label] : m) {
        int score = get_score(h + 1, count);
        if (score >= max_score) {
            max_score = score;
            max_label = label;
        }
        h++;
    }
    return max_label;
}


int main() {
    int n;
    std::cin >> n;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }

    std::vector<std::pair<int, int>> m(n);
    fill_vector(node, m);
    std::cout << get_max_score_label(m) << std::endl;
    

    // destroy_tree(node);

    return 0;
}