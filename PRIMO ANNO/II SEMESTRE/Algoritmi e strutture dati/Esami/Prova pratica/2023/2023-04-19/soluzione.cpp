#include <algorithm>
#include <iostream>
#include <vector>
#include <map>

struct Node {
    int label;
    Node *left;
    Node *right;

    explicit Node(int label) : label{label}, left{nullptr}, right{nullptr} {
    }
};


int get_points(int label) {
    int rv = 0;
    if (label % 2 == 1) {
        rv = 1;
    } else if (label == 0) {
        rv = 2;
    } else if(label % 2 == 0) {
        rv = -1;
    }
    return rv;

}

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


struct DecreasingCompare {
    bool operator() (int a, int b) const {
        return a > b;
    }
};

int fill_vector(Node *n, std::map<int, std::map<int, std::vector<Node *>, DecreasingCompare>> &nodes) {
    if (n == nullptr) {
        return 0;
    }
    int l = fill_vector(n->left, nodes);
    int r = fill_vector(n->right, nodes);

    int tmp = 0;
    if (n->right == nullptr && n->left == nullptr) {
        tmp = get_points(n->label);
    }
    int points = l + r;
    if (nodes.find(points) == nodes.end()) {
        nodes[points] = std::map<int, std::vector<Node *>, DecreasingCompare>(DecreasingCompare{});
    }

    nodes[points][n->label].push_back(n);
    return points + tmp;
}



int main() {
    int n, k;
    std::cin >> n >> k;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    // if (k <= 0) {
    //     throw std::invalid_argument("k must be greater or equal to 0");
    // }

    // if (k > n) {
    //     throw std::invalid_argument("k must be less or equal to n");
    // }
    
    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::cin >> label;
        insert_node_bst(node, label);
    }
   
    std::map<int, std::map<int, std::vector<Node *>, DecreasingCompare>> nodes{};
    fill_vector(node, nodes);
    for (auto [_, i] : nodes) {        
        for (auto [_, j] : i) {
            for (Node *scan : j) {
                if (k == 0) {
                    break;
                }
                std::cout << scan->label << std::endl;
                k--;
            }
        }
    }

    // destroy_tree(node);

    return 0;
}
