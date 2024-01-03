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
#include <vector>
#include <algorithm>

using namespace std;

const int nullptr = 0;

int N, K;
vector<int> v;

struct Node {
    int label;
    int d, lsx, ldx;

    Node *left;
    Node *right;

    explicit Node(int n):label(n), left(nullptr), right(nullptr) {
        d = lsx = ldx = 0;
    }
} *root = nullptr;

void Insert(Node *&root, int n) {
    Node *NewNode = new Node(n);

    int d = 0;
    Node *actual, *prec;
    actual = prec = root;
    while (actual != nullptr) {
        prec = actual;
        if (actual->label >= n)
            actual = actual->left;
        else
            actual = actual->right;
        d++;
    }

    NewNode->d = d;

    if (root == nullptr)
        root = NewNode;
    else if (prec->label >= n)
        prec->left = NewNode;
    else
        prec->right = NewNode;
}

void LsxLdx(Node *&root) {
    if (root == nullptr) return;
    LsxLdx(root->left);
    LsxLdx(root->right);
    if (root->left) {
        if (root->left->left == nullptr && root->left->right == nullptr)
            root->lsx++;
        root->lsx += root->left->lsx;
        root->ldx += root->left->ldx;
    }
    if (root->right) {
        if (root->right->left == nullptr && root->right->right == nullptr)
            root->ldx++;
        root->lsx += root->right->lsx;
        root->ldx += root->right->ldx;
    }
}

void CalcV(Node *&root) {
    if (root == nullptr) return;
    v.push_back((root->d * root->lsx) + (K * root->ldx) );
    CalcV(root->left);
    CalcV(root->right);
}

int main(void) {
    int tmp;
    cin >> N >> K;
    for (int i = 0; i < N; ++i) {
        cin >> tmp;
        Insert(root, tmp);
    }
    LsxLdx(root);
    
    CalcV(root);
    sort(v.begin(), v.end());
    for (vector<int>::iterator i = v.begin(); i != v.end(); ++i) {
        cout << *i << endl;
    }

    return 0;
}
