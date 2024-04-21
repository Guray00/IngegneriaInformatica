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


void do_get_nodes_distances(const Node *node, 
                            const Node *good_ancestor, 
                            std::vector<std::pair<const Node *, int> > &m, 
                            int dist = -1) {
    if (node == nullptr) {
        return;
    }
    m.emplace_back(node, dist);
    if (node->label % 2 == 0) {
        good_ancestor = node;
        dist = 1;
    } else if (good_ancestor != nullptr) {
        dist += 1;
    }
    
    do_get_nodes_distances(node->left, good_ancestor, m, dist);
    do_get_nodes_distances(node->right, good_ancestor, m, dist);
}


auto get_nodes_distances(const Node *node, const size_t n) -> std::vector<std::pair<const Node *, int> > {
    std::vector<std::pair<const Node *, int> > v{};
    v.reserve(n);
    do_get_nodes_distances(node, nullptr, v);
    std::sort(v.begin(), v.end(), [](const auto &a, const auto &b) {
        auto [node_a, dist_a] = a;
        auto [node_b, dist_b] = b;
        return dist_a > dist_b || (dist_a == dist_b && node_a->label > node_b->label);
    });
    return v;
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

    auto v = get_nodes_distances(node, n);
    
    for (auto [node, _] : v) {
        if (k == 0) {
            break;
        }
        std::cout << node->label << std::endl;
        k--;
    }

    // destroy_tree(node);

    return 0;
}

