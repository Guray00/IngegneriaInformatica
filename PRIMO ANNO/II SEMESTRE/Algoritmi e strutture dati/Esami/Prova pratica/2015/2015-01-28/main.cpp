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
    int label;
    int lsum;
    int rsum;

    Node *left;
    Node *right;

    explicit Node(int n):label(n), lsum(0), rsum(0) {
        left = right = nullptr;
    }
} *root = nullptr;

void Insert(Node *tree, int val) {
    Node *NewNode = new Node(val);

    Node *actual, *prec;
    actual = prec = root;
    while (actual) {
        prec = actual;

        if (val <= actual->label)
            actual = actual->left;
        else
            actual = actual->right;
    }

    if (!root)
        root = NewNode;
    else if (val <= prec->label)
        prec->left = NewNode;
    else
        prec->right = NewNode;
}

void Sum(Node *tree) {
    if (tree == nullptr) return;
    Sum(tree->left);
    Sum(tree->right);

    if (tree->left != nullptr)
        tree->lsum = tree->left->lsum + tree->left->rsum + tree->left->label;
    if (tree->right != nullptr)
        tree->rsum = tree->right->lsum + tree->right->rsum + tree->right->label;
}

void Print(Node *tree, const int &K) {
    if (tree == nullptr) return;
    Print(tree->left, K);
    if (tree->lsum * K < tree->rsum)
        cout << tree->label << ' ';
    Print(tree->right, K);
}

int main()  {
    int N, K;
    cin >> N >> K;

    for (int i = 0, tmp; i < N; ++i) {
        cin >> tmp;
        Insert(root, tmp);
    }

    Sum(root);
    Print(root, K);

    return 0;
}
