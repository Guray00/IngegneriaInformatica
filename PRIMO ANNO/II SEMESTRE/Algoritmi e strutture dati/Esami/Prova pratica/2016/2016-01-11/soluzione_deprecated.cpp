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
#include <cstring>

using namespace std;

const int nullptr = 0;

struct Node {
    int valore;
    Node *left;
    Node *right;

    explicit Node(int val): valore(val), left(nullptr), right(nullptr) {}
} **threes;

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

void LowHigh(int &low, int &high, const int &D) {
    low = high = 0;
    if (D <= 0) return;

    int HLow, HHigh;
    HLow = HHigh = Height(threes[0]);

    for (int i = 0; i < D; ++i) {
        int tmp = Height(threes[i]);
        if (tmp < HLow) {
            HLow = tmp;
            low = i;
        }
        if (tmp >= HHigh) {
            HHigh = tmp;
            high = i;
        }
    }
}

void MergeLowHigh(Node *low, const int &high, const int &D) {
    if (low == nullptr) return;
    MergeLowHigh(low->left, high, D);
    InsertAt(low->valore, high, D);
    MergeLowHigh(low->right, high, D);
}

void PrintThree(Node *root) {
    if (root == nullptr) return;
    PrintThree(root->left);
    cout << root->valore << endl;
    PrintThree(root->right);
}

void PrintLeaves(Node *root) {
    if (root == nullptr) return;
    PrintLeaves(root->left);
    if (!root->left && !root->right)
        cout << root->valore << endl;
    PrintLeaves(root->right);
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

    int low, high;
    LowHigh(low, high, D);
    MergeLowHigh(threes[low], high, D);
    PrintLeaves(threes[high]);
    
    return 0;
}
