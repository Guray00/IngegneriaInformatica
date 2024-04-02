//Soluzione personale by fede_nardi, qui ho avuto diversi aiuti da Sara Aliani
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;
struct Nodo{
    int valore;
    int nC;
    int nD;
    Nodo* left;
    Nodo* right;
    Nodo(int v): valore(v), nC(0),nD(0),left(nullptr),right(nullptr){};
};
void aggiungi(Nodo*& albero, int v) {
    if (!albero) {
        albero = new Nodo(v);
        return;
    }
    if (v <= albero->valore) {
        aggiungi(albero->left, v);
    } else if (v > albero->valore) {
        aggiungi(albero->right, v);
    }
}

int sommaconcordanti(Nodo* albero) {
    if (!albero) {
        return 0;
    }

// Calcola la somma totale dei nodi concordi per il sottoalbero sinistro
    int sumLeft = sommaconcordanti(albero->left);

// Calcola la somma totale dei nodi concordi per il sottoalbero destro
    int sumRight = sommaconcordanti(albero->right);


    albero->nC = (sumLeft + sumRight);
// Calcola la somma totale di nodi concordi per il nodo corrente
    if (albero->valore % 2 == 0 && (albero->left && albero->left->valore % 2 == 0)) {
        albero->nC++;
        if (albero->left && albero->left->left == nullptr &&
            albero->left->right == nullptr) //controllo che ci siano foglie nel sottoalbero sinistro
            albero->nC++;
    }
    if (albero->valore % 2 == 0 && (albero->right && albero->right->valore % 2 == 0)) {
        albero->nC++;
        if (albero->right && albero->right->left == nullptr &&
            albero->right->right == nullptr) //controllo che ci siano foglie nel sottoalbero destro
            albero->nC++;
    }
// Calcola la somma totale di nodi concordi per il nodo corrente
    if (albero->valore % 2 != 0 && (albero->left && albero->left->valore % 2 != 0)) {
        albero->nC++;
        if (albero->left && albero->left->left == nullptr &&
            albero->left->right == nullptr) //controllo che ci siano foglie nel sottoalbero sinistro
            albero->nC++;
    }
    if (albero->valore % 2 != 0 && (albero->right && albero->right->valore % 2 != 0)) {
        albero->nC++;
        if (albero->right && albero->right->left == nullptr &&
            albero->right->right == nullptr) //controllo che ci siano foglie nel sottoalbero destro
            albero->nC++;
    }

// Aggiorna il conteggio complessivo e ritorna la somma totale
    return albero->nC;
}


int sommadiscordanti(Nodo* albero) {
    if (!albero) {
        return 0;
    }

    int sumLeft = sommadiscordanti(albero->left);

// Calcola la somma totale dei nodi discordi per il sottoalbero destro
    int sumRight = sommadiscordanti(albero->right);
    albero->nD = (sumLeft + sumRight);
// Calcola la somma totale di nodi discordi per il nodo corrente
    if (albero->valore % 2 != 0 && albero->left && albero->left->valore % 2 == 0) {
        albero->nD++;
        if (albero->left && albero->left->left == nullptr && albero->left->right == nullptr) //controllo che ci siano foglie nel sottoalbero sinistro
            albero->nD++;
    }
    if (albero->valore % 2 != 0 && albero->right && albero->right->valore % 2 == 0) {
        albero->nD++;
        if (albero->right && albero->right->left == nullptr && albero->right->right == nullptr)
            albero->nD++;

    }
    if (albero->valore % 2 == 0 && (albero->left && albero->left->valore % 2 != 0)) {
        albero->nD++;
        if (albero->left && albero->left->left == nullptr && albero->left->right == nullptr) //controllo che ci siano foglie nel sottoalbero sinistro
            albero->nD++;
    }
    if (albero->valore % 2 == 0 && (albero->right && albero->right->valore % 2 != 0)) {
        albero->nD++;
        if (albero->right && albero->right->left == nullptr && albero->right->right == nullptr) //controllo che ci siano foglie nel sottoalbero destro
            albero->nD++;
    }
// Aggiorna il conteggio complessivo e ritorna la somma totale
    return albero->nD;
}

void visita(Nodo* albero) {
    if (!albero)
        return;
//faccio visita inorder così stampo in ordine crescente
    visita(albero->left);
    if (albero->nC > albero->nD)
        cout << albero->valore << " concordi: " << albero->nC << ", discordi: " << albero->nD << endl;
    visita(albero->right);
}
int main() {
    Nodo *albero = nullptr;
    aggiungi(albero, 10);
    aggiungi(albero, 5);
    aggiungi(albero, 3);
    aggiungi(albero, 1);
    aggiungi(albero, 7);
    aggiungi(albero, 4);
    aggiungi(albero, 8);
    aggiungi(albero, 15);
    aggiungi(albero, 20);
    aggiungi(albero, 40);
    sommaconcordanti(albero);
    sommadiscordanti(albero);
    visita(albero);
    return 0;
}
