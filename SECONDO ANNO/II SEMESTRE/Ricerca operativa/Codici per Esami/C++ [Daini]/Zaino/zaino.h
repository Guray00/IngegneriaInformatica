//
// Created by Utente on 14/06/2023.
//

#ifndef ZAINO_ZAINO_H
#define ZAINO_ZAINO_H
using namespace std;
#include<iostream>
#include<vector>
#include<algorithm>
#include<cmath>
#include<list>
class zaino {
vector<int> v;
vector<int> funzione_obbiettivo;
vector<int> Vs_vet;
vector<bool>includi_vet;
int capienza_massima;

//funzioni di utilità;
vector<double> trova_rendimento();
int Vs_zaino(int &, vector<int>&, int);
static void togli_1(vector<int>&);
void includi(vector<int>&,int);
void escludi(vector<int>&,int);
void costruisci_albero(vector<int>&,int,int,int *,int = 0);
void aggiorna_vettore_Vs(int);
void taglia(bool*&,int);
int trova_Vi(int*,int,int,bool *);
public:
    zaino();
    ~zaino(){v.clear();funzione_obbiettivo.clear();Vs_vet.clear(); includi_vet.clear();}
    void risolvi_zaino_intero();
    void risolvi_zaino_binario(int &, int &, int &);
    void Branch_Bound();

};


#endif //ZAINO_ZAINO_H
