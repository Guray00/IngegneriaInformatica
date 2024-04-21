/* 
 * Copyright 2017 Giuseppe Fabiano
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

#include <iostream>
#include <string>
#include <algorithm>
#include <vector>

using namespace std;

const int nullptr = 0;

struct Node {
    int key;
    string val;

    Node *left;
    Node *right;

    explicit Node(int n, const string &v): key(n), val(v) {
        left = right = nullptr;
    }
} *root = nullptr;

void Insert(const int &n, const string &v) {
    Node *NewNode = new Node(n, v);

    Node *actual, *prec;
    actual = prec = root;
    while (actual != nullptr) {
        prec = actual;

        if (n <= actual->key)
            actual = actual->left;
        else
            actual = actual->right;
    }

    if (root == nullptr)
        root = NewNode;
    else if (n <= prec->key)
        prec->left = NewNode;
    else
        prec->right = NewNode;
}

void foo(Node *root, const int &K, vector<string> &v) {
    if (root == nullptr) return;
    if (root->key == K) return;
    v.push_back(root->val);

    foo(root->left, K, v);
    foo(root->right, K, v);
}

int main(void) {
    int N, K;
    int key;
    string val;

    cin >> N;
    for (int i = 0; i < N; ++i) {
        cin >> key >> val;
        Insert(key, val);
    }
    cin >> K;

    vector<string> v;
    foo(root, K, v); // O(n)

    // min_element è una funzione della libreria standard per trovare il minimo
    // in un vettore. E' stata usata per comodità, si poteva implementare
    // facilmente
    if (v.size() >= 1)
        cout << *min_element(v.begin(), v.end()); // O(n)
    else
        cout << "vuoto";

    return 0;
}
