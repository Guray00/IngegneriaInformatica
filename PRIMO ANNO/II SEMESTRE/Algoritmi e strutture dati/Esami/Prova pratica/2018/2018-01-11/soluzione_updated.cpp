#include <iostream>
#include <vector>
using namespace std;

const int p = 999149;
const int a = 1000;
const int b = 2000;

struct Node
{
    int label;
    Node *left;
    Node *right;
    Node(int l) : label(l), left(NULL), right(NULL) {}
};

void insert_abr(Node *&node, int l)
{
    Node **scan = &node;
    while (*scan != NULL)
    {
        if (l <= (*scan)->label)
            scan = &(*scan)->left;
        else
            scan = &(*scan)->right;
    }
    *scan = new Node(l);
}

struct HashTable
{
    int size;
    vector<Node *> table;
    HashTable(int _size) : size(_size), table(_size, (Node *)NULL) {}
    int hash(int x)
    {
        long long val = (long long)a * (long long)x + (long long)b;
        val %= p;
        return (int)(val % size);
    }
    void insert(int x) { insert_abr(table[hash(x)], x); }
};

void count_leaves(Node *node, bool isRightChild, bool hasParent, int &ndx, int &nsx)
{
    if (node == NULL)
        return;
    if (node->left == NULL && node->right == NULL)
    {
        if (hasParent)
        {
            if (isRightChild)
                ndx++;
            else
                nsx++;
        }
        return;
    }
    if (node->left != NULL)
        count_leaves(node->left, false, true, ndx, nsx);
    if (node->right != NULL)
        count_leaves(node->right, true, true, ndx, nsx);
}

int main()
{
    int N, S;
    if (!(cin >> N >> S))
        return 0;
    if (S <= 0)
        return 0;
    HashTable ht(S);
    for (int i = 0; i < N; i++)
    {
        int x;
        cin >> x;
        ht.insert(x);
    }

    int idx_max_dx = 0, max_dx = -1;
    int idx_max_sx = 0, max_sx = -1;

    for (int i = 0; i < S; i++)
    {
        int ndx = 0, nsx = 0;
        if (ht.table[i] != NULL)
        {
            count_leaves(ht.table[i], false, false, ndx, nsx);
        }
        if (ndx > max_dx || (ndx == max_dx && i > idx_max_dx))
        {
            max_dx = ndx;
            idx_max_dx = i;
        }
        if (nsx > max_sx || (nsx == max_sx && i > idx_max_sx))
        {
            max_sx = nsx;
            idx_max_sx = i;
        }
    }

    cout << idx_max_dx << endl
         << idx_max_sx << endl;
    return 0;
}
