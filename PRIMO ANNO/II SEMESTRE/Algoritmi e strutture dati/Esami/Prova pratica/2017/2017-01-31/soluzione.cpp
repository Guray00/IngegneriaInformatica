#include <iostream>
#include <unordered_set>
#include <array>

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


bool is_zig_zag(const Node &n, const Node &m) {    
    for (int index : {0, 1}) {
        bool can_return = false;
        for (auto children: {std::array{n.left, n.right}, 
                             std::array{m.left, m.right}}) {
            int other_index = 1 - index;
            if (children[index] == nullptr && children[other_index] != nullptr) {
                if (can_return) {
                    return true;
                }
                index = other_index;
                can_return = true;
            } else {
                break;
            }
        }
    }

    return false;
}

int get_zig_zag_num(const Node *n, const Node *parent = nullptr) {
    if (n == nullptr) {
        return 0;
    }
    return 
        (parent != nullptr && is_zig_zag(*n, *parent)) +
        get_zig_zag_num(n->left, n) +
        get_zig_zag_num(n->right, n);
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
    
    int result = get_zig_zag_num(node);
    std::cout << result << std::endl;

    // destroy_tree(node);

    return 0;
}

