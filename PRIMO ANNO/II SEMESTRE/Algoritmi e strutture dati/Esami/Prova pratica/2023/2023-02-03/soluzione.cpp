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

void insert_node_abr(Node *&n, int label, std::string name) {
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



int do_get_satisfying_nodes(Node *n, int d, std::vector<Node *> &v) {
    if (n == nullptr) {
        return 0;
    }
    int l_descendants = do_get_satisfying_nodes(n->left, d + 1, v);
    int r_descendants = do_get_satisfying_nodes(n->right, d + 1, v);

    int descendants = l_descendants + r_descendants;
    if (descendants == d) {
        v.push_back(n);
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


std::vector<Node*> get_satisfying_nodes(Node *n) {
    std::vector<Node*> v{};
    do_get_satisfying_nodes(n, 0, v);
    std::sort(v.begin(), v.end(), [](Node *a, Node *b) { return a->name < b->name; });
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
        insert_node_abr(node, label, name);
    }

    std::vector<Node *> v = get_satisfying_nodes(node);
    for (Node *scan : v) {
        std::cout << scan->name << std::endl;
    }

    // destroy_tree(node);

    return 0;
}

