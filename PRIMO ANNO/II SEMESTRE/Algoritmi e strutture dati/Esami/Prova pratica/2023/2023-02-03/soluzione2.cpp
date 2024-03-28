#include <algorithm>
#include <iostream>
#include <optional>
#include <vector>


// A possible different approach to create a self refential data structure, like a BST, is to use a vector of nodes
// and reference each node using its index in the vector. Basically the index has the function of the pointer. In this way,
// we can avoid using raw pointers and all possible problems that come with them, like memory leaks, dangling pointers,
// etc. Indeed, the vector will be the owner of the nodes, and it will be responsible for their destruction, and using
// indexes to it with .at() method, we can avoid to access invalid memory locations. The performance of allocation and
// deallocation of memory is also better than using new and delete operators, because the vector will allocate memory
// in blocks, and it will not need to allocate memory for each node. However, using indexes to access the nodes in the
// vector is a little bit slower than using raw pointers, but the difference is not significant. The main advantages of
// this approach are the safety and the fact that we don't use another vector to sort the nodes.


struct Node {
    int label;
    std::string name;
    // we use mutable keyword to allow the modification of the attribute in a const method
    // we will use const to guarantee that some references will remain valid
    mutable bool is_good = false;
    // NOTE: in x86_64 architecture, this struct below will occupy 16 bytes,
    // so the double of a pointer. We could optimize this using a sentinel value
    // (e.g. std::numeric_limits<size_t>::max) or using std::optional<unsigned int>,
    // in the second case limiting the number of elements to ~4GiB
    std::optional<size_t> left;
    std::optional<size_t> right;

    explicit Node(int label, std::string name) : label(label), name{std::move(name)}, left{std::nullopt},
                                                 right{std::nullopt} {
    }
};


size_t insert_node_bst(std::vector<Node> &nodes, std::optional<size_t> n, int label, std::string name) {
    auto p = n;
    std::optional<size_t> q = std::nullopt;

    while (p != std::nullopt) {
        q = p;
        auto &p_value = nodes.at(*p);
        if (label <= p_value.label) {
            p = p_value.left;
        } else {
            p = p_value.right;
        }
    }

    size_t rv = nodes.size();
    nodes.emplace_back(label, std::move(name));
    if (q != std::nullopt) {
        auto &father = nodes.at(*q);
        if (label <= father.label) {
            father.left = rv;
        } else {
            father.right = rv;
        }
    }
    return rv;
}


int insert_satisfying_nodes(const std::vector<Node> &nodes, const std::optional<size_t> index, std::vector<const std::string*> &v, const int d = 0) {
    if (index == std::nullopt) {
        return 0;
    }
    const Node &node = nodes.at(*index);
    int l_descendants = insert_satisfying_nodes(nodes, node.left, v, d + 1);
    int r_descendants = insert_satisfying_nodes(nodes, node.right, v, d + 1);

    int descendants = l_descendants + r_descendants;
    if (descendants == d) {
        // node is still valid, because we are using a const reference to nodes
        v.push_back(&node.name);
    }
    return descendants + 1;
}


int main() {
    int n;
    std::cin >> n;

    // if (n <= 0) {
    //     throw std::invalid_argument("n must be greater than 0");
    // }

    std::vector<Node> nodes{};
    std::optional<size_t> first_index{std::nullopt};
    for (int i = 0; i < n; i++) {
        int label;
        std::string name{};
        std::cin >> label >> name;
        size_t index = insert_node_bst(nodes, first_index, label, name);
        if (!first_index) {
            first_index = index;
        }
    }

    std::vector<const std::string*> v{};
    insert_satisfying_nodes(nodes, first_index, v);
    std::sort(v.begin(), v.end(), [](const std::string *a, const std::string *b) {
        return *a < *b;
    });

    for (const auto s : v) {
        std::cout << *s << std::endl;
    }

    return 0;
}

