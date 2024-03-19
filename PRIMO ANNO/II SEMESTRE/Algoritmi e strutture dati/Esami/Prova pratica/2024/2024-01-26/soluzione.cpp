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


int get_satisfying_nodes(Node* n, const int k, std::vector<Node *> &v) {
    if (n == nullptr) {
        return 0;
    }
    int l_h = get_satisfying_nodes(n->left, k, v);
    int r_h = get_satisfying_nodes(n->right, k, v);
    if (std::abs(l_h - r_h) < k) {
        v.push_back(n);
    }

    return 1 + std::max(l_h, r_h);
}


int main() {
    int n, k;
    std::cin >> n >> k;

    //  if (n <= 0) {
    //      throw std::invalid_argument("n must be greater than 0");
    //  }

    //  if (k <= 0) {
    //      throw std::invalid_argument("k must be greater than 0");
    //  }

    //  if (k > n) {
    //      throw std::invalid_argument("k must be less than n");
    //  }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }

    std::vector<Node *> v{};
    get_satisfying_nodes(node, k, v);
    std::sort(v.begin(), v.end(), [](Node *a, Node *b) {
        return a->label < b->label; 
    });

    for (auto &i : v) {
        std::cout << i->label << std::endl;
    }

    // destroy_tree(node);

    return 0;
}

