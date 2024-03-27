#include <algorithm>
#include <iostream>
#include <vector>
#include <unordered_set>

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


std::pair<int, int> do_get_nodes_distances(Node* node, std::unordered_set<int>& distances) {
    if (node == nullptr) {
        return {-1, -1};
    }

    if (node->left == nullptr && node->right == nullptr) {
        if (node->label % 2 == 0) {
            return {1, -1};
        } else {
            return {-1, 1};
        }
    }

    auto [l_dist_evn, l_dist_odd] = do_get_nodes_distances(node->left, distances);
    auto [r_dist_evn, r_dist_odd] = do_get_nodes_distances(node->right, distances);

    int evn_distance = std::max(l_dist_evn, r_dist_evn);
    int odd_distance = std::max(l_dist_odd, r_dist_odd);

    if (node->label % 2 == 0) {
        distances.insert(evn_distance);
    } else {
        distances.insert(odd_distance);
    }

    if (evn_distance > 0) evn_distance++;
    if (odd_distance > 0) odd_distance++;

    return {evn_distance, odd_distance};
}


std::vector<int> get_nodes_distances(Node *node, size_t n) {
    std::unordered_set<int> m{};
    // O(n)
    do_get_nodes_distances(node, m);
    auto v = std::vector<int>(m.begin(), m.end());
    // O(n log n)
    std::sort(v.begin(), v.end(), std::greater<int>());
    return v;
}

int main() {
    int n;
    std::cin >> n;

    //  if (n <= 0) {
    //      throw std::invalid_argument("n must be greater than 0");
    //  }
    
    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }

    std::vector<int> v = get_nodes_distances(node, n);
    
    for (int d : v) {
        std::cout << d << std::endl;
    }

    // destroy_tree(node);

    return 0;
}

