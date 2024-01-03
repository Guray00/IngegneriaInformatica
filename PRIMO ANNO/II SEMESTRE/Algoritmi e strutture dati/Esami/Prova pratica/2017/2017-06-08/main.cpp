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

using namespace std;

const int nullptr = 0;

struct Node {
    int val;
    int L;

    Node *left;
    Node *right;

    explicit Node(int n): val(n), L(0) {
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

int Proprieta(Node * root) {
    // La uso per ricordarmi se il padre è pari o dispari
    static bool father_pari;
    bool pari;
    if (root == nullptr) return 0;
    if (root->left != nullptr ||   // Se non siamo su una foglia aggiorno il
        root->right != nullptr) {  // valore di father_pari
        pari = father_pari = (root->val % 2 == 0)? true: false;
    } else {
        // Se siamo su una foglia controllo se il valore dell'etichetta è pari
        // e se è uguale al negato del padre (pari == !dispari) e lo restituisco
        // come risultato (quindi 1 se la proprietà è verificata, 0 altrimenti)
        return ((root->val % 2 == 0)? true: false) == !father_pari;
    }

    int LLeft, LRight;
    LLeft = Proprieta(root->left);
    // Nella chiamata ricorsiva il valore potrebbe cambiare, lo riaggiorno
    father_pari = pari;
    LRight = Proprieta(root->right);

    root->L = LLeft + LRight;

    return root->L;
}

void Print(Node *root) {
    if (root == nullptr) return;
    Print(root->left);
    cout <<root->L << endl;
    Print(root->right);
}

int main(void) {
    int N;
    int tmp;

    cin >> N;
    for (int i = 0; i < N; ++i) {
        cin >> tmp;
        Insert(tmp);
    }
    Proprieta(root); // O(n)
    Print(root);  // O(n)

    return 0;
}
