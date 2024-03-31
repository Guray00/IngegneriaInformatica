//Dopo il main ho scritto una funzione che conta le foglie di ogni nodo per ripassare
//Ho ottimizzato al massimo il codice
//Soluzione personale by fede_nardi
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;
struct Nodo {
    int value;
    Nodo* left;
    Nodo* right;
    Nodo(int val) : value(val), left(nullptr), right(nullptr) {}
};
vector <int> v;
// Funzione per inserire un nodo nell'albero binario di ricerca
void add(Nodo*& albero, int val) {
    if (albero == nullptr) {
        albero = new Nodo(val);
        return;
    }
    if (val <= albero->value) {
        add(albero->left, val);
    } else if (val > albero->value) {
        add(albero->right, val);
    }
}
//Funzione che conta le foglie uniche di ogni sottoalbero
int contafoglieuniche(Nodo* albero) {
    if (albero == nullptr) {
        return 0;
    }
    int leftFoglie = contafoglieuniche(albero->left);
    int rightFoglie = contafoglieuniche(albero->right);
//Se è una foglia e il suo genitore ha un solo figlio, è unica
    if ((albero->left == nullptr && albero->right != nullptr) ||
        (albero->left != nullptr && albero->right == nullptr)) {
        return 1 + leftFoglie + rightFoglie;
    }
    return leftFoglie + rightFoglie;
}
//Funzione ricorsiva per buttare ne vettore le etichette dei nodi validi
void nodovalido(Nodo* albero, int A, int B) {
    if (albero == nullptr) {
        return;
    }
//Calcola il numero di foglie uniche nel sottoalbero radicato in questo nodo
    int fogliaunica = contafoglieuniche(albero);
//Verifica se il nodo è valido e lo inserisce nel vettore dinamico
    if (fogliaunica >= A && fogliaunica <= B) {
        v.push_back(albero->value);
    }
//Chiamo le ricorsive per i sottoalberi sinistro e destro
    nodovalido(albero->left, A, B);
    nodovalido(albero->right, A, B);
}

int main() {
    Nodo *albero = nullptr;
    int a = 1, b = 2;
    add(albero, 10);
    add(albero, 5);
    add(albero, 3);
    add(albero, 1);
    add(albero, 7);
    add(albero, 4);
    add(albero, 8);
    add(albero, 15);
    add(albero, 20);
    contafoglieuniche(albero);
    nodovalido(albero, a, b);
    sort(v.begin(), v.end());
    for (int i = 0; i < v.size(); i++)
        cout << v[i] << endl;
    return 0;
}
//Funzione che conta le foglie per ogni nodo padre l'ho scritta per ripassare
/*int contafoglie(Nodo* albero) {
    // Se il nodo è una foglia, restituisci 0
    if (albero == nullptr) {
        return 0;
    }
    // Se il nodo non ha figli, è una foglia
    if (albero->left == nullptr && albero->right == nullptr) {
        return 1;
    }
    // Conta le foglie nei nodi figli
    return albero->foglie = contafoglie(albero->left) + contafoglie(albero->right);
}
*/
