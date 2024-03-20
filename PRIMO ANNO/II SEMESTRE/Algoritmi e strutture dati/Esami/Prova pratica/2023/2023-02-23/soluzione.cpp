#include <algorithm>
#include <iostream>
#include <vector>

struct Node {
    int label;
    Node *left;
    Node *right;

    explicit Node(int label) : label(label), left(nullptr), right(nullptr) {
    }
};

void insert_node_abr(Node *&n, int label) {
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


void destroy_tree(Node *n) {
    if (n == nullptr) {
        return;
    }
    destroy_tree(n->left);
    destroy_tree(n->right);
    delete n;
}


int fill_vector_with_satisfying(Node *n, std::vector<Node *> &median_nodes, int d = 0) {
    if (n == nullptr) {
        return 0;
    }

    int ll = fill_vector_with_satisfying(n->left, median_nodes, d + 1);
    int lr = fill_vector_with_satisfying(n->right, median_nodes, d + 1);

    int l = std::max(ll, lr);

    if (std::abs(l - d) <= 1) {
        median_nodes.push_back(n);
    }
    return l + 1;
}

std::vector<Node *> get_satisfying(Node *n) {
    std::vector<Node *> v{};
    fill_vector_with_satisfying(n, v);
    std::sort(v.begin(), v.end(), [](auto a, auto b) {
        return a->label < b->label;
    });
    return v;
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

    k = std::min(n, k);

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int tmp;
        std::cin >> tmp;
        insert_node_abr(node, tmp);
    }

    std::vector<Node *> v = get_satisfying(node);

    for (int i = 0; i < k; i++) {
        std::cout << v[i]->label << std::endl;
    }

    // destroy_tree(node);

    return 0;
}

