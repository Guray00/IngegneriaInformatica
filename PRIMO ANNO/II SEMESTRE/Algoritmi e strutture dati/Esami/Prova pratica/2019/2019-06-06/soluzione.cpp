#include <algorithm>
#include <iostream>
#include <unordered_map>
#include <set>
#include "cpp-btree/btree_set.h"

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


int fill_map(const Node *n, std::unordered_map<const Node *, int> &v) {
    if (n == nullptr) {
        return 0;
    }
    int l_h = fill_map(n->left, v);
    int r_h = fill_map(n->right, v);
    return v[n] = 1 + std::max(l_h, r_h);
}

void print(const std::unordered_map<const Node*, int> &v, Node *n, int h_target, int &k) {
    if (n == nullptr || k == 0) {
        return;
    }
    print(v, n->left, h_target, k);
    if (v.at(n) == h_target) {
        if (k > 0) {
            std::cout << n->label << std::endl;
            k--;
        }
    }
    print(v, n->right, h_target, k);
}

int main2() {
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


    // we could also insert height in the node struct, 
    // but we are supposing that we can't modify the struct,
    std::unordered_map<const Node *, int> map{};
    int h = fill_map(node, map);
    print(map, node, h / 2, k);

    // destroy_tree(node);

    return 0;
}


int fill_map2(const Node *n, std::unordered_map<int, btree::btree_set<int>> &v) {
    if (n == nullptr) {
        return 0;
    }
    int l_h = fill_map2(n->left, v);
    int r_h = fill_map2(n->right, v);
    int h = 1 + std::max(l_h, r_h);
    v[h].insert(n->label);
    return h;
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


    // we could also insert height in the node struct, 
    // but we are supposing that we can't modify the struct,
    std::unordered_map<int, btree::btree_set<int>> map{};
    int h = fill_map2(node, map);
    for (int scan : map[h / 2]) {
        if (k == 0) {
            break;
        }
        std::cout << scan << std::endl;
        k--;
    }

    // destroy_tree(node);

    return 0;
}

