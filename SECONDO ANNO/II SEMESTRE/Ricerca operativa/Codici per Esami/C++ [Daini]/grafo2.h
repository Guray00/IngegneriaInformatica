//
// Created by Utente on 08/06/2023.
//

#ifndef GRAFO3_GRAFO2_H
#define GRAFO3_GRAFO2_H

#include<iostream>
#include<tuple>
#include<algorithm>
#include<utility>
#include<list>
using namespace std;

class grafo2 {
    list<tuple<int,int,int>> *lista_grafo; // nodo,costo,capacità
    int dim;
    void Cammino_Aumentante(int,int,int*&,bool &);
    void segna_predecessori(int,int,int *&);
    grafo2 & operator=(const grafo2 &);
public:
    grafo2(int n);
    void stampa_grafo();
    void Cammini_Minimi(int, int,bool &);
    ~grafo2(){lista_grafo->clear();}
    void Ford_Furkersord(int,int, bool &);
    grafo2(const grafo2 &G){
        dim = G.dim;
        lista_grafo = G.lista_grafo;
    }

};


#endif //GRAFO3_GRAFO2_H
