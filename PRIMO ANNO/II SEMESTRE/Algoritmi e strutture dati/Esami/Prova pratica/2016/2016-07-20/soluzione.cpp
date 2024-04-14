#include <iostream>


struct Node {
    int label;
    int is_median;
    Node *left;
    Node *right;

    explicit Node(int label) : label(label), is_median{false}, left(nullptr), right(nullptr) {
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


int set_median_value_to_nodes(Node *n, int d = 0) {
    if (n == nullptr) {
        return 0;
    }

    int ll = set_median_value_to_nodes(n->left, d + 1);
    int lr = set_median_value_to_nodes(n->right, d + 1);

    int l = std::max(ll, lr);

    if (std::abs(l - d) <= 1) {
        n->is_median = true;
    }
    return l + 1;
}



void print_tree(const Node *n, int &k) {
    if (n == nullptr) {
        return;
    }
    
    print_tree(n->left, k);
    if (k == 0) {
        return;
    }
    if (n->is_median) {
        std::cout << n->label << std::endl;
        k--;
    }
    print_tree(n->right, k);
  
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
        insert_node_bst(node, tmp);
    }

    set_median_value_to_nodes(node);

    print_tree(node, k);

    // destroy_tree(node);

    return 0;
}

