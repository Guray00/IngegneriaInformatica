#include <iostream>
#include <vector>
#include <algorithm>

struct Node {
    int label;
    std::string str;
    Node *left;
    Node *right;

    explicit Node(int label, std::string str) : label{label}, str{std::move(str)}, left{nullptr}, right{nullptr} {
    }
};

void insert_node_bst(Node *&n, int label, std::string str) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node{label, str};
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


bool is_leaf(const Node *n) {
    return n->left == nullptr && n->right == nullptr;
}


int fill_vector(const Node *n, std::vector<const Node *> &nodes, int d = 0) {
    if (n == nullptr) {
        return 0;
    }

    int l_leaves = fill_vector(n->left, nodes, d + 1);
    int r_leaves = fill_vector(n->right, nodes, d + 1);

    int leaves = l_leaves + r_leaves; 
    if (leaves == d) {
        nodes.push_back(n);
    }
    return leaves + is_leaf(n);
}


int main() {
    int n;
    std::cin >> n;

    //  if (n <= 0) {
    //      throw std::invalid_argument("n must be greater than 0");
    //  }

    //  if (k <= 0) {
    //      throw std::invalid_argument("k must be greater than 0");
    //  }

    
    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::string str;
        std::cin >> label >> str;
        insert_node_bst(node, label, str);
    }

    std::vector<const Node *> nodes{};
    fill_vector(node, nodes);
    std::sort(nodes.begin(), nodes.end(), [](const Node *a, const Node *b) {
        return a->str < b->str;
    });

    for (const Node *n : nodes) {
        std::cout << n->str << std::endl;
    }


    // destroy_tree(node);

    return 0;
}

