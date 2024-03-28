#include <iostream>
#include <variant>


template <typename... Ts>
struct overloaded : Ts... {
    using Ts::operator()...;
};
template <typename... Ts>
overloaded(Ts...) -> overloaded<Ts...>;


struct Server{};
struct Client{};
struct Filter{};
struct Router{};

struct NodeType : public std::variant<Server, Client, Filter, Router> {
    explicit NodeType(char c) {
        switch (c) {
            case 'S':
                emplace<Server>();
                break;
            case 'C':
                emplace<Client>();
                break;
            case 'F':
                emplace<Filter>();
                break;
            case 'R':
                emplace<Router>();
                break;
            default:
                throw std::invalid_argument("Invalid node type");
        }
    }
};


struct Node {
    int id;
    int g = 0;
    NodeType type;
    Node *left;
    Node *right;

    explicit Node(int id, NodeType type) : id{id}, type{type}, left{nullptr}, right{nullptr} {
    }
};


void insert_node_bst(Node *&n, int id, NodeType type) {
    Node **scan = &n;
    while (*scan != nullptr) {
        if (id <= (*scan)->id) {
            scan = &(*scan)->left;
        } else {
            scan = &(*scan)->right;
        }
    }
    *scan = new Node(id, type);
}


// void destroy_tree(Node *n) {
//     if (n == nullptr) {
//         return;
//     }
//     destroy_tree(n->left);
//     destroy_tree(n->right);
//     delete n;
// }



void insert_g(Node *n, Node *server, int n_filters) {
    if (n == nullptr) {
        return;
    }

    std::visit(overloaded{
        [&](Server) {
            server = n;
            n_filters = 0;
        },
        [&](Filter) {
            n_filters++;
        },
        [&](Client) {
            if (server != nullptr && n_filters >= 1) {
                server->g++;
            }
        },
        [&](Router) { /* do nothing */ }
    }, n->type);

    insert_g(n->left, server, n_filters);
    insert_g(n->right, server, n_filters);
    
}


void print_servers(Node *n) {
    if (n == nullptr) {
        return;
    }
    print_servers(n->left);
    if (std::get_if<Server>(&n->type)) {
        std::cout << n->id << " " << n->g << std::endl;
    } 
    print_servers(n->right);
}

int main() {
    int n;
    std::cin >> n;

    //  if (n <= 0) {
    //      throw std::invalid_argument("n must be greater than 0");
    //  }

    Node *node = nullptr;
    for (int i = 0; i < n; i++) {
        int id;
        char type;
        std::cin >> id >> type;
        insert_node_bst(node, id, NodeType{type});
    }

    Node *server = nullptr;
    int n_filters = 0;
    insert_g(node, server, n_filters);

    print_servers(node);

    // destroy_tree(node);


    return 0;
}

