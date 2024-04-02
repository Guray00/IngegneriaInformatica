//Soluzione personale by fede_nardi
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;
vector <string> vettore;
struct Nodo{
    int identificatore;
    string etichetta;
    int altezza;
    int disc;
    bool p=false;
    Nodo* left;
    Nodo* right;
    Nodo (int id, string label, int h): identificatore(id), etichetta(label),altezza(h), disc(0), left(nullptr), right(nullptr){};
};
//Nodo* albero= nullptr; è useless perchè noi usiamo quello nel main

void add(Nodo*& albero, int id, string label, int h=0) {

    if (albero == nullptr) {
        albero = new Nodo(id, label, h);
        return;
    }
    if (id <= albero->identificatore)
        add(albero->left, id, label, h + 1);
    else if (id > albero->identificatore)
        add(albero->right, id, label, h + 1);
    albero->disc = albero->disc + 1;
}

void visita(Nodo* albero) {
    if (albero == nullptr)
        return;
    visita(albero->left);
    if (albero->disc == albero->altezza) {
        albero->p = true;
        vettore.push_back(albero->etichetta);
    }
    visita(albero->right);
}

int main() {
    int n;
    string s;
    Nodo *albero = nullptr;
    //cin>>n;
    //cin>>x>>s;
    add(albero, 100, "ab");
    add(albero, 120, "aa");
    add(albero, 90, "ga");
    add(albero, 115, "bb");
    add(albero, 140, "cc");
    add(albero, 130, "gg");
    add(albero, 200, "hi");
    add(albero, 1, "co");
    visita(albero);

    sort(vettore.begin(), vettore.end());
    for (int i = 0; i < vettore.size(); i++)
        cout << vettore[i] << endl;
    return 0;
}
