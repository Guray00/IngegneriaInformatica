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

// ATTENZIONE: Su questa prova non sono stati eseguiti i TestSet siccome non li
//             possiedo

#include <iostream>
#include <string>
#include <algorithm>
#include <vector>

using namespace std;

const int nullptr = 0;

struct Node {
    int val;
    int dx;
    int lx;

    Node *left;
    Node *right;

    explicit Node(int n): val(n), dx(0), lx(0) {
        left = right = nullptr;
    }
} *root = nullptr;

void Insert(const int n) {
    Node *NewNode = new Node(n);

    Node *actual, *prec;
    actual = prec = root;
    while (actual != nullptr) {
        prec = actual;

        // Ogni volta che scendo di livello incremento la distanza dalla radice
        NewNode->dx++;

        if (n <= actual->val)
            actual = actual->left;
        else
            actual = actual->right;
    }

    if (root == nullptr)
        root = NewNode;
    else if (n <= prec->val)
        prec->left = NewNode;
    else
        prec->right = NewNode;
}

int CountLX(Node *root) {
    if (root == nullptr) return 0;
    int l = CountLX(root->left);
    int r = CountLX(root->right);

    root->lx = ((l > r)?l:r);

    return root->lx + 1;
}

void Print(Node *root, const int &K) {
    static int h = 0;
    if (root == nullptr) return;
    Print(root->left, K);

    if (h++ >= K) {
        h = 0;
        return;
    }

    if (root->lx - root->dx <= 1 &&
        root->lx - root->dx >= -1) {
        cout << root->val << endl;
    }

    Print(root->right, K);
}

int main(void) {
    int N, K;
    int tmp;

    cin >> N >> K;
    for (int i = 0; i < N; ++i) {
        cin >> tmp;
        Insert(tmp);
    }

    CountLX(root);
    Print(root, K);

    return 0;
}
