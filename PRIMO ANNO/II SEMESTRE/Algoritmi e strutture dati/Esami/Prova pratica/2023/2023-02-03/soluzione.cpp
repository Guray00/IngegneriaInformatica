#include <algorithm>
#include <iostream>
#include <vector>

struct Node {
    int label;
    std::string name;
    Node *left;
    Node *right;

    explicit Node(int label, std::string name) : label(label), name{std::move(name)}, left(nullptr), right(nullptr) {
    }
};

void insert_node_bst(Node *&n, int label, std::string name) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node(label, std::move(name));
}



int do_get_satisfying_nodes(const Node *n, int d, std::vector<const std::string*> &v) {
    if (n == nullptr) {
        return 0;
    }
    int l_descendants = do_get_satisfying_nodes(n->left, d + 1, v);
    int r_descendants = do_get_satisfying_nodes(n->right, d + 1, v);

    int descendants = l_descendants + r_descendants;
    if (descendants == d) {
        v.push_back(&n->name);
    }

    return descendants + 1;
}


//void destroy_tree(Node *n) {
//    if (n == nullptr) {
//        return;
//    }
//    destroy_tree(n->left);
//    destroy_tree(n->right);
//    delete n;
//}


std::vector<const std::string*> get_satisfying_nodes(const Node *n) {
    std::vector<const std::string*> v{};
    do_get_satisfying_nodes(n, 0, v);
    std::sort(v.begin(), v.end(), [](const std::string *a, const std::string *b) {
        return *a < *b;
    });
    return v;
}

int main() {
    int n;
    std::cin >> n;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int label;
        std::string name{};
        std::cin >> label >> name;
        insert_node_bst(node, label, name);
    }

    // since we can assume lifetime of the tree is the same as the program
    // and we use a constant reference to the tree, we can safely use
    // a vector of pointers to strings
    std::vector<const std::string*> v = get_satisfying_nodes(node);
    for (const std::string *scan : v) {
        std::cout << *scan << std::endl;
    }

    // destroy_tree(node);

    return 0;
}

