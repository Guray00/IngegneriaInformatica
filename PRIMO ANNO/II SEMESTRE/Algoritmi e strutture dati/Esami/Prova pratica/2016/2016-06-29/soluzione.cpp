#include <iostream>
#include <algorithm>
#include <vector>
#include <array>


struct Node {
    int label;
    Node *left;
    Node *right;

    explicit Node(int label) : 
        label{label},
        left{nullptr}, 
        right{nullptr} {
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
    *scan = new Node{label};
}


bool is_leaf(Node &n) {
    return n.left == nullptr && n.right == nullptr;
}


bool is_right_leaf(Node &n, Node &father) {
    return is_leaf(n) && father.right == &n;
}


bool is_left_leaf(Node &n, Node &father) {
    return is_leaf(n) && father.left == &n;
}


std::pair<int, int> get_num_left_and_right_leaves(
    Node *n, 
    Node *father, 
    const int K, 
    std::vector<int> &vs,
    int d = 0) 
{
    if (n == nullptr) {
        return {0, 0};
    }
    auto [nsx_l, ndx_l] = get_num_left_and_right_leaves(n->left, n, K, vs, d + 1);
    auto [nsx_r, ndx_r] = get_num_left_and_right_leaves(n->right, n, K, vs, d + 1);
    int nsx = nsx_l + nsx_r;
    int ndx = ndx_l + ndx_r;
    vs.push_back(d * nsx + K * ndx);
    if (father != nullptr) {
        nsx += is_left_leaf(*n, *father);
        ndx += is_right_leaf(*n, *father);
    }
    return {nsx, ndx};
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


int main() {
    int n, k;
    std::cin >> n >> k;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label; 
        std::cin >> label;
        insert_node_bst(node, label);
    }

    std::vector<int> vs{};
    get_num_left_and_right_leaves(node, nullptr, k, vs);
    std::sort(vs.begin(), vs.end(), std::less<int>());
    for (int v : vs) {
        std::cout << v << std::endl;
    }

    // destroy_tree(node);

    return 0;
}
