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

// Comunicazione non più valida siccome i TestSet sono stati rilasciati
// ATTENZIONE: Su questa prova non sono stati eseguiti i TestSet siccome non li
//             possiedo

#include <iostream>

using namespace std;

const int nullptr = 0;

struct Node {
    int val;

    Node *left;
    Node *right;

    explicit Node(int n): val(n) {
        left = right = nullptr;
    }
} *root = nullptr;

void Insert(const int n) {
    Node *NewNode = new Node(n);

    Node *actual, *prec;
    actual = prec = root;
    while (actual != nullptr) {
        prec = actual;

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

int ZigZag(Node * root) {
    if (root == nullptr) return 0;
    int ZZLeft  = ZigZag(root->left);
    int ZZRight = ZigZag(root->right);

    // found viene settato ad 1 se viene trovato uno ZigZag
    int found = 0;
    // Controllo se esiste un figlio e l'unicità di tale figlio
    if ((root->left != nullptr || root->right != nullptr) &&
        !(root->left != nullptr && root->right != nullptr)) {
        Node *son = (root->left != nullptr)? root->left: root->right;
        found = (
            // Verifico se esiste il nodo dell'ultima condizione di ZigZag
            (
                (root->left != nullptr)?
                (son->right != nullptr):
                (son->left != nullptr)
            )
            // Se esite controllo che sia l'unico figlio, così da verificare la
            // condizione di ZigZag
            && !(son->left != nullptr && son->right != nullptr));
    }

    return ZZLeft + ZZRight + found;
}

int main(void) {
    int N;
    int tmp;

    cin >> N;
    for (int i = 0; i < N; ++i) {
        cin >> tmp;
        Insert(tmp);
    }

    cout << ZigZag(root);

    return 0;
}
