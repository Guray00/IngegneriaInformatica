#include <algorithm>
#include <iostream>
#include <vector>

struct Node {
    int label;
    int mass;
    Node *left;
    Node *right;

    explicit Node(int label, int mass) : label{label}, mass{mass}, left{nullptr}, right{nullptr} {
    }
};

void insert_node_bst(Node *&n, int label, int mass) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node(label, mass);
}


int get_weight(const Node &n, int d) {
    int multiplier = (n.left == nullptr && n.right == nullptr) ? 2 : 1;
    return n.mass * multiplier - d;
}

int fill_nodes_loades(Node *n, std::vector<int> &nodes_loads, int d = 0) {
    if (n == nullptr) {
        return 0;
    }
    int l_load = fill_nodes_loades(n->left, nodes_loads, d + 1);
    int r_load = fill_nodes_loades(n->right, nodes_loads, d + 1);
    int load = l_load + r_load;
    nodes_loads.push_back(load);
    return load + get_weight(*n, d);
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

    // if (k <= 0) {
    //     throw std::invalid_argument("k must be greater than 0");
    // }

    k = std::min(n, k);

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label, mass;
        std::cin >> label >> mass;
        insert_node_bst(node, label, mass);
    }

    std::vector<int> nodes_weights{};
    fill_nodes_loades(node, nodes_weights);
    std::sort(nodes_weights.begin(), nodes_weights.end(), [](int a, int b) {
        return a > b;
    });

    for (int i = 0; i < k; i++) {
        std::cout << nodes_weights[i] << std::endl;
    }

    // destroy_tree(node);

    return 0;
}
