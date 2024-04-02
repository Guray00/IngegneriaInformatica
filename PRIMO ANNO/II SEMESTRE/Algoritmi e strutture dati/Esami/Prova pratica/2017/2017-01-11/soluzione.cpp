#include <iostream>
#include <unordered_set>

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


int get_score(const Node *n, const int k, std::unordered_set<const Node*> &count) {
    if (n == nullptr) {
        return 0;
    }

    int l_score = get_score(n->left, k, count);
    int r_score = get_score(n->right, k, count);
    int score = l_score + r_score;
    if (score > k) {
        count.insert(n);
    }
     if (n->left == nullptr && n->right == nullptr) {
        score += get_points(n->label);
    }
    return score;
}


void print_tree(Node *n, std::unordered_set<const Node *> &nodes) {
    if (n == nullptr) {
        return;
    }
    print_tree(n->left, nodes);
    if (nodes.find(n) != nodes.end()) {
        std::cout << n->label << std::endl;
    }
    print_tree(n->right, nodes);
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
   
    std::unordered_set<const Node*> count{};
    get_score(node, k, count);
    print_tree(node, count);

    // destroy_tree(node);

    return 0;
}

