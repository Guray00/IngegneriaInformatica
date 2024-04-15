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
#include <algorithm>
#include <vector>

using namespace std;

const int nullptr = 0;

struct Node {
    int valore;
    Node *left;
    Node *right;

    explicit Node(int val): valore(val), left(nullptr), right(nullptr) {}
} **threes;

struct elem {
    int ID;
    int NAtH;

    bool operator()(elem a, elem b) {
        if (a.NAtH == b.NAtH) return a.ID > b.ID;
        return a.NAtH > b.NAtH;
    }
};

void InsertAt(int val, int id, const int &D) {
    if (id >= D) return;

    Node *NewNode = new Node(val);

    Node* actual, *prec;
    actual = prec = threes[id];
    while(actual != nullptr) {
        prec = actual;

        if (val <= actual->valore)
            actual = actual->left;
        else
            actual = actual->right;
    }

    if (threes[id] == nullptr)
        threes[id] = NewNode;
    else if (val <= prec->valore)
        prec->left = NewNode;
    else
        prec->right = NewNode;
}

int Height(Node *root) {
    if (root == nullptr) return 0;
    if (root->left == nullptr && root->right == nullptr) return 0;
    int HLeft = Height(root->left);
    int HRight = Height(root->right);
    return 1 + ((HLeft > HRight)? HLeft: HRight);
}

int MinHeight(const int &D) {
    if (D <= 0) return 0;
    int min = Height(threes[0]);
    for (int i = 1, tmp; i < D; ++i)
        if (min > (tmp = Height(threes[i])) ) min = tmp;

    return min;
}

int NodesAtH(Node *tree, int h, int k = 0) {
    if (tree == nullptr) return 0;
    if (k > h) return 0;

    int out = NodesAtH(tree->left, h, k+1) + NodesAtH(tree->right, h, k+1);
    if (h == k)
        out++;
    return out;
}

int main(void) {
    int N, D;
    cin >> N >> D;

    threes = new Node *[D];
    memset(threes, nullptr, sizeof(Node *) * D);

    for (int i = 0; i < N; ++i) {
        int val, id;
        cin >> val >> id;

        InsertAt(val, id, D);
    }

    int min = MinHeight(D);

    vector<elem> v;

    for (int i = 0; i < D; ++i) {
        elem tmp;
        tmp.ID = i;
        tmp.NAtH = NodesAtH(threes[i], min);

        v.push_back(tmp);
    }

    sort(v.begin(), v.end(), *v.begin());

    for(vector<elem>::iterator it=v.begin(); it!=v.end(); ++it) {
        cout << it->ID <<  endl;
    }

    return 0;
}
