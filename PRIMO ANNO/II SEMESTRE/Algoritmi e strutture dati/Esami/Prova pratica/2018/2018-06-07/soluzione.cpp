#include <iostream>
#include <vector>

struct Node {
    int label;
    int color;
    Node *left;
    Node *right;

    explicit Node(int label, int color) : label{label}, color{color}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_bst(Node *&n, int label, int color) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node{label, color};
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


void fill_vector(const Node *n, std::vector<int> &paths, int c, int len) {
    if (n == nullptr) {
        return;
    }

    if (c == n->color) {
        len++;
    } else {
        len = 1;
        c = n->color;
    }

    if (paths[c] < len) {
        paths[c] = len;
    }

    fill_vector(n->left, paths, c, len);
    fill_vector(n->right, paths, c, len);
}


int main() {
    int n, c;
    std::cin >> n >> c;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label, color;
        std::cin >> label >> color;
        insert_node_bst(node, label, color);
    }

    std::vector<int> paths(c, 0);
    fill_vector(node, paths, -1, 0);

    for (int color : paths) {
        std::cout << color << std::endl;
    }

    // destroy_tree(node);

    return 0;
}


