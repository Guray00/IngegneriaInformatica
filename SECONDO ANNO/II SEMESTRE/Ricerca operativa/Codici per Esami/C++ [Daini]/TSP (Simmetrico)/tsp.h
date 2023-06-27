//
// Created by Utente on 09/06/2023.
//

#ifndef TSP_TSP_H
#define TSP_TSP_H
#include<iostream>
#include<list>
using namespace std;

class tsp {
    struct scelta{
        bool includi;
        scelta * destra,* sinistra;
        int riga,colonna;
        int Vi,Vs;
    };
    scelta * testa;
    int v[10];
    //funzioni di utilità
    bool hamiltoniano(int * scelti);
    void converti_indice(int,int &, int&);
    int conta_nodi_collegati(int,int*,int);
    bool ciclo(int *,int);
    int trova_min_k(int,int *&);
    int trova_min(int,int *&);
    void crea_albero(scelta *&,int,int,int,bool = false,int = 0);
    int includi(int,int,int,int*&);
    int escludi(int,int,int*);
    int converti_riga_colonna(int,int);
    void resetta(int*&,bool = true);
    void branch(scelta *,scelta *,int,int &,int &,int*&,int = 0, int = 0, int = 0);
    int k_albero(int,bool,int*&);
    int nodo_vicino(int, int, int *&,int &,int = 0);
    int * trova_indici_proibiti(int);
    void escludi_nodi_k(int,int *& scelti);
    void elimina_albero(scelta *&);
    void trasforma_2(int *&);
    bool vuoto(int *);
    void stampa_nodo(int,int *);
    int conta_nodi_mancanti(int, int *);
    tsp & operator = (const tsp &);
    tsp(const tsp &);
public:
    tsp();
    void Branch_Bound();
    ~tsp();

};


#endif //TSP_TSP_H
