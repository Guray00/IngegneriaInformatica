#include <algorithm>
#include <iostream>
#include <vector>
#include <cassert>
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


// this function is O(n * log(n)) where n is the number of nodes in the tree
// since it is called in each node, and the complexity of the operation is O(log(n))
int fill_map(Node *n, std::map<int, std::map<int, std::vector<Node *>, DecreasingCompare>> &nodes) {
    if (n == nullptr) {
        return 0;
    }
    int l = fill_map(n->left, nodes);
    int r = fill_map(n->right, nodes);

    int tmp = 0;
    if (n->right == nullptr && n->left == nullptr) {
        tmp = get_points(n->label);
    }
    int points = l + r;
    // we know that accessing a map (implemented as a RBTree in GNU C++ Library) is O(log(n)), so
    // the complexity of this operation is O(log(n_points)) + O(log(n_labels_per_point)) which can be roughly
    // approximated to O(log(nodes)) + O(log(nodes)) = O(log(nodes))
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
   
    // this is map from ints, which are points, to map from ints, which are labels, to vector of nodes
    // so basically a bst built from inserting sequentially from this labels 10, 0, 30, 25, 16, 30, 25
    // will be represented inside this structure as:

    // 0: {
    //       30: [n1, n2];
    //       25: [n3, n4]; 
    //       0: [n5]
    //  };
    // 1: { 16: [n6] };
    // 2: { 10: [n7] };

    // where n1, n2, n3, n4, n5, n6, n7 are nodes with labels 30, 30, 25, 25, 0, 16, 10 respectively
    // and n1, n2, n3, n4, n5, n6, n7 are pointers to these nodes. 
    // 0, 1, 2 are points, and are sorted in ascending order, and 30, 25, 0, 16, 10 are labels, and are sorted in descending order

    // we could also just keep track of the number of nodes with the same label, and avoid the vector of nodes
    // but this solution is more general and maybe more intuitive

    std::map<int, std::map<int, std::vector<Node *>, DecreasingCompare>> nodes{};
    
    fill_map(node, nodes);
    
    // maps are ordered, so we can just iterate through them and print the labels
    // to get the desired output. The operation is O(n) where n is the number of nodes in the tree
    // since iterate over an ordered map is O(n)
    for (auto [_point, point_map] : nodes) {        
        for (auto [label, n] : point_map) {
            for (Node *scan : n) {
                if (k == 0) {
                    break;
                }
                assert(scan != nullptr);
                assert(scan->label == label);
                std::cout << label << std::endl;
                k--;
            }
        }
    }

    // destroy_tree(node);

    return 0;
}

