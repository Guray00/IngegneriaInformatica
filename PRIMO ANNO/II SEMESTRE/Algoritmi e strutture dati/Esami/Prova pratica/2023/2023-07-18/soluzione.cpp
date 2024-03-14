#include <iostream>
#include <queue>
#include <vector>

struct Node {
    int label;
    char color;
    Node *left;
    Node *right;

    explicit Node(int label, char color) : label{label}, color{color}, left{nullptr}, right{nullptr} {
    }
};

void insert_node_abr(Node *&n, int label, int color) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (label <= (*scan)->label) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node(label, color);
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }

bool is_surrounded(Node *n, Node *father) {
    if (
        father == nullptr ||
        n == nullptr ||
        n->left == nullptr ||
        n->right == nullptr
    ) {
        return false;
    }
    return father->color == n->left->color && father->color == n->right->color;
}

template<typename F>
void get_fathers_of_surrounded_children(Node *n, std::priority_queue<Node *, std::vector<Node *>, F> &p) {
    if (n == nullptr) {
        return;
    }
    for (Node *child: {n->left, n->right}) {
        if (child != nullptr && is_surrounded(child, n)) {
            p.push(n);
            break;
        }
    }
    get_fathers_of_surrounded_children(n->left, p);
    get_fathers_of_surrounded_children(n->right, p);
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
        char color;
        std::cin >> label >> color;
        insert_node_abr(node, label, color);
    }

    auto f = [](Node *n1, Node *n2) {
        return n1->label >= n2->label;
    };

    std::priority_queue<Node *, std::vector<Node *>, decltype(f)> p{f};
    get_fathers_of_surrounded_children(node, p);
    while (!p.empty()) {
        std::cout << p.top()->label << std::endl;
        p.pop();
    }


    // destroy_tree(node);

    return 0;
}
