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


int height(Node *n) {
    if (n == nullptr) {
        return 0;
    }
    int h_l = height(n->left);
    int h_r = height(n->right);
    return 1 + std::max(h_l, h_r);
}


std::pair<int, int> get_low_high(const int D, const std::vector<Node *> &trees) {
    if (D <= 0) {
        return {0, 0};
    }
    int low = 0;
    int high = 0;

    int h_low = height(trees[0]);
    int h_high = h_low;

    for (int i = 1; i < D; i++) {
        int tmp = height(trees[i]);
        if (tmp < h_low) {
            h_low = tmp;
            low = i;
        }
        if (tmp >= h_high) {
            h_high = tmp;
            high = i;
        }
    }
    return {low, high};
}


template <typename F>
void in_order_visit(const Node *n, const F &f) {
    if (n == nullptr) {
        return;
    }
    in_order_visit(n->left, f);
    f(n);
    in_order_visit(n->right, f);
}


int main(void) {
    int N, D;
    std::cin >> N >> D;
    std::vector<Node*> trees(D);
    
    for (int i = 0; i < N; i++) {
        int val, id;
        std::cin >> val >> id;
        insert_node_bst(trees[id], val);
    }

    auto [low, high] = get_low_high(D, trees);
    auto &low_tree = trees[low];
    auto &high_tree = trees[high];

    in_order_visit(low_tree, [&](const Node *n) {
        insert_node_bst(high_tree, n->label);
    });

    in_order_visit(high_tree, [](const Node *n) {
        if (!n->left && !n->right) {
            std::cout << n->label << std::endl;
        }
    });
    
    // for (auto tree : trees) {
    //     destroy_tree(tree);
    // }

    return 0;
}
