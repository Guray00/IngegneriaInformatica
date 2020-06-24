/* 
 * Copyright 2016 Giuseppe Fabiano
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <algorithm>
#include <cstring>
#include <iostream>
#include <vector>

using namespace std;

const int nullptr = 0;

const int a = 1000;
const int b = 2000;
const int p = 999149;
int N, K, S;

inline int Hash(const int &ID) {
    return ((( a * ID ) + b ) % p ) % S;
}

struct Node {
    int val;
    Node *left;
    Node *right;

    explicit Node(int n): val(n), left(nullptr), right(nullptr) {}
} **table;

struct H {
    int height;
    int ID;

    H(int val, int id): height(val), ID(id) {}
    bool operator() (const H &a, const H &b) const {
        if (a.height == b.height)
            return a.ID < b.ID;
        return a.height > b.height;
    }
};

void Insert(Node *&root, const int &val) {
    Node *newNode = new Node(val);

    Node *actual, *prec;
    actual = prec = root;
    while(actual != nullptr) {
        prec = actual;
        if (val <= actual->val)
            actual = actual->left;
        else
            actual = actual->right;
    }

    if (root == nullptr)
        root = newNode;
    else if (val <= prec->val)
        prec->left = newNode;
    else
        prec->right = newNode;
}

int Height(Node *root) {
    if (root == nullptr) return 0;
    int HLeft = Height(root->left);
    int HRight = Height(root->right);
    return 1 + ((HLeft > HRight)? HLeft: HRight);
}

void PrintThree(Node *root) {
    if (root == nullptr) return;
    PrintThree(root->left);
    cout << root->val << endl;
    PrintThree(root->right);
}

int main(void) {
    cin >> N >> K >> S;
    table = new Node *[S];
    memset(table, nullptr, sizeof(Node *) * S);

    for (int i = 0; i < N; ++i) {
        int hash, val;
        cin >> val;
        
        hash = Hash(val);
        Insert(table[hash], val);
    }

    vector<H> v;
    for (int i = 0; i < S; ++i) {
        H h(Height(table[i]), i);
        v.push_back(h);
    }

    H h(0,0);
    sort(v.begin(), v.end(), h);

    K = ( K > S )? S: K;
    for (int i = 0; i < K; ++i) {
        cout << v[i].ID << endl;
    }

    return 0;
}
