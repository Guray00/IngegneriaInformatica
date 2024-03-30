//Soluzione personale by fede_nardi
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
vector <int> v;
struct Nodo{
    int valore;
    int dx;
    int lx;
    Nodo* left;
    Nodo* right;
    Nodo (int v,int d): valore(v), dx(d),lx(0), left(nullptr), right(nullptr){};
};
void aggiungi(Nodo*& albero, int v, int d=0) {
    if (albero == nullptr) {
        albero = new Nodo(v,d);
        return;
    }
    if (v <= albero->valore)
        aggiungi(albero->left,v,albero->dx+1);
    else if(v>albero->valore)
        aggiungi(albero->right,v, albero->dx+1);
//ricorda che dx è altezza dell'albero
}
int calcolalx (Nodo* albero) {
    // Nodo nullo, profondità 0.
    if (albero == nullptr) {
        return 0;
    }
    // Se il nodo è una foglia
    if (albero->left == nullptr && albero->right == nullptr) {
        return albero->lx = 0;
    }
    //Calcola la profondità massima dei sottoalberi sinistro e destro.
    int l = calcolalx(albero->left);
    int r = calcolalx(albero->right);
    // Restituisci la distanza massima tra le foglie del sottoalbero sinistro e destro + 1.
    return albero->lx = max(l, r) + 1;
}
void calcola(Nodo* albero){
    if (albero == nullptr)
        return;
    if(albero->lx-albero->dx==1 || albero->lx-albero->dx==-1 )
        v.push_back(albero->valore);
    calcola(albero->left);
    calcola(albero->right);
}
int main() {
    //int n, x, s;
    Nodo *albero = nullptr;
    //cin>>n;
    //cin>>x>>s;
    aggiungi(albero, 10);
    aggiungi(albero, 5);
    aggiungi(albero, 20);
    aggiungi(albero, 15);
    aggiungi(albero, 30);
    aggiungi(albero, 25);
    calcolalx(albero);
    calcola(albero);
    sort(v.begin(), v.end());
    for (int i = 0; i < v.size(); i++)
        cout << v[i] << endl;
    return 0;
}
