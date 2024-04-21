/* 
 * Copyright 2016 Giuseppe Fabiano
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
#include <cstring>

using namespace std;

const int nullptr = 0;

const int p = 999149;
const int a = 1000;
const int b = 2000;

inline int Hash(const int &id, const int &N) {
    return (((a * id) + b) % p) % (2 * N);
}

struct Conto {
    int ID;
    string Cognome;
    Conto *next;

    Conto(int id, string cognome):
        ID(id),
        Cognome(cognome),
        next(nullptr) {}
} **hashTable;

void Insert(int id, string cognome, int N) {
    Conto *NewConto = new Conto(id, cognome);

    int hash = Hash(id, N);

    if (hashTable[hash] == nullptr) {
        hashTable[hash] = NewConto;
    } else {
        Conto *actual, *prec;
        actual = prec = hashTable[hash];
        while (actual != nullptr && ( cognome > actual->Cognome ||
               cognome == actual->Cognome && id > actual->ID) ) {
            prec = actual;
            actual = actual->next;
        }

        NewConto->next = actual;
        if (actual == hashTable[hash])
            hashTable[hash] = NewConto;
        else
            prec->next = NewConto;
    }
}

void Print(const int &N) {
    int maxId = 0;
    int maxVal = 0;
    Conto *tmp;
    for (int i = 0; i < 2*N; ++i) {
        int count = 0;
        tmp = hashTable[i];
        while (tmp) {
            count++;
            tmp = tmp->next;
        }
        if (count > maxVal) {
            maxVal = count;
            maxId = i;
        }
    }

    cout << hashTable[maxId]->ID << endl;
}

int main(void) {
    int N;
    cin >> N;

    hashTable = new Conto *[2*N];
    memset(hashTable, nullptr, sizeof(Conto *) * 2*N);

    int id;
    string cognome;
    for (int i = 0; i < N; ++i) {
        cin >> id >> cognome;
        Insert(id, cognome, N);
    }

    Print(N);

    return 0;
}
