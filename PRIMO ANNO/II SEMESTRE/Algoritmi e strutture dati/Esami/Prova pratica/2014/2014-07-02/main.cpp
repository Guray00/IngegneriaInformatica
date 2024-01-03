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

using namespace std;

const int nullptr = 0;

struct Node {
    int val;
    int I;
    int F;

    Node *left;
    Node *right;

    explicit Node(int n): val(n), I(0), F(n) {
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

int CalcIF(Node *root) {
    if (root == nullptr) return 0;
    int a = CalcIF(root->left);
    int b = CalcIF(root->right);
    if (root->left == nullptr && root->right == nullptr) {
        return 0;
    } else {
        root->F = (root->left != nullptr)? root->left->F: 0;
        root->F += (root->right != nullptr)? root->right->F: 0;
        root->I = root->val + a + b;
        return root->I;
    }
}

void Print(Node *root) {
    if (root == nullptr) return;
    Print(root->left);
    if (root->I <= root->F)
        cout << root->val << ' ';
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

    CalcIF(root);  // O(n)
    Print(root);   // O(n)

    return 0;
}
