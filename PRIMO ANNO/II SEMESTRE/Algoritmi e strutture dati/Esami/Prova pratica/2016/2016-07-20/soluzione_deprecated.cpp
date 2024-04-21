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

#include <iostream>

using namespace std;

const int nullptr = 0;

struct Node {
    int val;
    int dx, lx;

    Node *left;
    Node *right;

    explicit Node(int n): val(n), left(nullptr), right(nullptr) {
        dx = lx = 0;
    }
} *root;

/*
 * Ho pulito il codice rimuovendo la variabile ins, inutile siccome mi sono
 * accorto che nell'attributo dei due nodi successivi c'è già il risultato
 * parziale dell'altezza. Questo riduce sia il carico sullo stack che il numero
 * di istruzioni eseguite.
 */
int Insert(Node *&root, const int &n) {
    static int count = 0;  // Variabile contenente la distanza dalla radice
    if (root == nullptr) {
        root = new Node(n);
        root->dx = count;
        // Dopo l'inserimento si azzera count siccome è una variabile statica
        count = 0;
        return 1;
    }

    int HLeft, HRight;
    HLeft = 0;
    HRight = 0;
    count++;
    if (n <= root->val) {
        HLeft  = Insert(root->left, n);
        if (root->right != nullptr)
            HRight = 1 + root->right->lx;
    } else {
        if (root->left != nullptr)
            HLeft = 1 + root->left->lx;
        HRight = Insert(root->right, n);
    }

    root->lx = ((HLeft > HRight)? HLeft: HRight);

    return 1 + root->lx;
}

int N, K, J;
void Print(Node *root) {
    if (root == nullptr) return;
    Print(root->left);
    if (root->lx - root->dx <= 1 && root->lx - root->dx >= -1
        && J++ < K)
        cout << root->val << endl;
    Print(root->right);
}

int main() {
    cin >> N >> K;

    for (int i = 0; i < N; ++i) {
        int tmp;
        cin >> tmp;
        Insert(root, tmp);
    }
    J = 0;
    Print(root);

    return 0;
}
