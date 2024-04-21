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
    int intero;
    string stringa;

    Node *left;
    Node *right;

    explicit Node(int n, const string &str): intero(n), stringa(str) {
        left = right = nullptr;
    }
} *root = nullptr;

void Insert(const int n, const string &str) {
    Node *NewNode = new Node(n, str);

    Node *actual, *prec;
    actual = prec = root;
    while (actual != nullptr) {
        prec = actual;

        if (n <= actual->intero )
            actual = actual->left;
        else
            actual = actual->right;
    }

    if (root == nullptr)
        root = NewNode;
    else if (n <= prec->intero)
        prec->left = NewNode;
    else
        prec->right = NewNode;
}

void CognomiTarget(Node *root, const int&D, vector<string> &v, int h = 0) {
    if (root == nullptr) return;
    if (h > D) return; // Evito di scendere ai livelli inferiori al problema
    CognomiTarget(root->left, D, v, h+1);
    if (h == D)
        v.push_back(root->stringa);
    CognomiTarget(root->right, D, v, h+1);
}

int main(void) {
    int N, D;
    int intero;
    string stringa;


    cin >> N >> D;
    for (int i = 0; i < N; ++i) {
        cin >> intero >> stringa;
        Insert(intero, stringa);
    }

    vector<string> v;
    CognomiTarget(root, D, v);  // O(n)
    sort(v.begin(), v.end());   // k = 2^D, O(klogk)

    cout << v.size() << endl;

    for (vector<string>::iterator it = v.begin(); it != v.end(); ++it) {
        cout << *it << endl;
    }

    return 0;
}
