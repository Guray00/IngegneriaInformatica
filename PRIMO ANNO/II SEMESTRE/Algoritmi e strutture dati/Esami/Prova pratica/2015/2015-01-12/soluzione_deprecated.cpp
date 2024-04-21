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

int Verifica(Node *root, bool &flag) {
    if (root == nullptr) return 0;
    
    // La proprietà deve essere vera per ogni nodo, se non è verificata per un
    // nodo posso fermarmi senza visitare il resto dell'albero
    if (flag == false) return 0;

    int LHeight = Verifica(root->left, flag);
    int RHeight = Verifica(root->right, flag);

    flag = flag && (LHeight - RHeight >= -1 && LHeight - RHeight <= 1);

    return ((LHeight > RHeight)? LHeight:RHeight) + 1;
}

int main(void) {
    int N;
    int tmp;

    cin >> N;
    for (int i = 0; i < N; ++i) {
        cin >> tmp;
        Insert(tmp);
    }

    bool f = true;
    Verifica(root, f); // Si assume che `f` inizialmente sia impostato a `true`
    cout << (f? "ok":"no");

    return 0;
}
