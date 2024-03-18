#include <iostream>
#include <map>
#include <set>

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


// this function is O(n * log(n)) where n is the number of nodes in the tree
// since it is called in each node, and the complexity of the operation is O(log(n))
int fill_map(Node *n, std::map<int, std::multiset<int, std::greater<int>>> &nodes) {
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
    nodes[points].insert(n->label);
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
   
    std::map<int /* point */, std::multiset<int /* label */, std::greater<int> /* decreasing order */>> nodes{};
    
    fill_map(node, nodes);
    
    // maps are ordered, so we can just iterate through them and print the labels
    // to get the desired output. The operation is O(n) where n is the number of nodes in the tree
    // since iterate over an ordered map is O(n)
    for (auto [_point, point_multiset] : nodes) {        
        for (int label : point_multiset) {
            if (k == 0) {
                break;
            }
            std::cout << label << std::endl;
            k--;
        }
    }

    // destroy_tree(node);

    return 0;
}

