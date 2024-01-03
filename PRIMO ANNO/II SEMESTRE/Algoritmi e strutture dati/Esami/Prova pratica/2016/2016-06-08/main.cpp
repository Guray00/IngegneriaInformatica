/* 
 * Copyright 2016, 2017 Giuseppe Fabiano
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
    int ID;
    int P;
    int Cmax;
    int C;
    Node *left;
    Node *right;

    explicit Node(int id, int p, int cmax): ID(id), P(p), Cmax(cmax), C(0) {
        left = right = nullptr;
    }
} *root = nullptr;

void Insert(const int id, const int p, const int cmax) {
    Node *NewNode = new Node(id, p, cmax);

    Node *actual, *prec;
    actual = prec = root;
    while (actual != nullptr) {
        prec = actual;

        if (id <= actual->ID)
            actual = actual->left;
        else
            actual = actual->right;
    }

    if (root == nullptr)
        root = NewNode;
    else if (id <= prec->ID)
        prec->left = NewNode;
    else
        prec->right = NewNode;
}

bool Integrity(Node *&root) {
    if (root == nullptr) return true;
    bool integrity = Integrity(root->left);
    integrity = Integrity(root->right) && integrity;
    if (root->left != nullptr)
        root->C += root->left->C + root->left->P;
    if (root->right != nullptr)
        root->C += root->right->C + root->right->P;

    if (root->C > root->Cmax) return false;
    return integrity;
}

void Print(Node *root) {
    if (root == nullptr) return;
    Print(root->left);
    if (root->C > root->Cmax)
        cout << root->ID << endl;
    Print(root->right);
}

int main(void) {
    int N;
    int id, p, cmax;
    cin >> N;

    for (int i = 0; i < N; ++i) {
        cin >> id >> p >> cmax;
        Insert(id, p, cmax);
    }

    if(!Integrity(root)){
        cout << "no" << endl;
        Print(root);
    } else {

        cout << "ok" << endl;
    }


    return 0;
}
