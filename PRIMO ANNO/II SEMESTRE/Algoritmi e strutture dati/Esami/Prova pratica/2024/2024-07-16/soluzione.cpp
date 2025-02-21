#include <iostream>
#include <vector>


struct Node {
    int id;
    int w;
    Node *left;
    Node *right;

    explicit Node(int id, int w) : id{id}, w{w}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_bst(Node *&n, int id, int w) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (id <= (*scan)->id) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node{id, w};
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }


void foo(const Node *n, 
        int c, 
        int len, 
        std::pair<int /* id */, int /* len */> &res) {
    if (n == nullptr || c < 0) {
        return;
    }

    if (n->left == nullptr && n->right == nullptr) {
        if (c + n->w < 0) {
            return;
        }

        auto [max_id, max_l] = res;
        if (len > max_l || len == max_l && n->id < max_id) {
            res = {n->id, len};
        }
        return;
    }

    foo(n->left, c + n->w, len + 1, res);
    foo(n->right, c + n->w, len + 1, res);
}


int main() {
    int n, c;
    std::cin >> n >> c;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    // if (c < 0) {
    //     throw std::invalid_argument("c must be greater or equal to 0");
    // }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int id, w;
        std::cin >> id >> w;
        insert_node_bst(node, id, w);
    }

    std::pair<int, int> res = {-1, -1};
    foo(node, c, -1, res);
    auto [id, len] = res;
    std::cout << id << " " << len << std::endl;

    // destroy_tree(node);

    return 0;
}



