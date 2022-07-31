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
#include <cstring>

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

inline int Max(const int &h) {
    if (h < 1) return 0;
    if (h == 1) return 1;
    return 2 << (h-2);
}

void Insert(const int n, int * const &v) {
    Node *NewNode = new Node(n);

    Node *actual, *prec;
    actual = prec = root;
    int h = 1;
    while (actual != nullptr) {
        prec = actual;
        h++;

        if (n <= actual->val)
            actual = actual->left;
        else
            actual = actual->right;
    }
    v[h-1]++;

    if (root == nullptr)
        root = NewNode;
    else if (n <= prec->val)
        prec->left = NewNode;
    else
        prec->right = NewNode;
}

void print(Node * root, const int &h) {
    static int lvl = 1;
    static bool flag;
    if (lvl <= 1) flag = false;
    if (root == nullptr || flag || lvl > h) return;
    if (lvl == h) {
        cout << root->val;
        flag = true;
        return;
    }

    lvl++;
    print(root->right, h);
    print(root->left, h);
    lvl--;
}

int main() {
    int N;
    int tmp;

    cin >> N;
    int *v = new int[N];
    memset(v, 0, sizeof(int) * N);

    for (int i = 0; i < N; ++i) {
        cin >> tmp;
        Insert(tmp, v);
    }

    float max_score = 0;
    int h_max_score = 1;
    for (int i = 0; i < N; ++i) {
        float score = (static_cast<float>(v[i])/(i+1))*Max(i+1);
        if (score >= max_score) {
            max_score = score;
            h_max_score = i + 1;
        }
    }

    print(root, h_max_score);
    return 0;
}
