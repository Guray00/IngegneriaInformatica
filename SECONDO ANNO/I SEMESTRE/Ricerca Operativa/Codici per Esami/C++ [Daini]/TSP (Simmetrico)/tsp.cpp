
//
// Created by Utente on 09/06/2023.
//

#include "tsp.h"

tsp::tsp() {
    cout << "Inserire in ordine lessicografico i valori dei costi dei nodi del TSP simmetrico:" << endl;
    int appoggio[10];
    for(int i = 0; i < 10; i++){
        cin >> appoggio[i];
        v[i] = appoggio[i];
    }
    cout << "La tabella e' la seguente:" << endl;
    cout << "  ";
    for(int i = 2; i < 6; ++i)
        cout << i << ' ';//scrittura colonne
    cout << endl;

    for(int i = 0, k = 0; i < 4;++i){
        cout << i+1 << ' ';//scrittura indice riga

        for(int h = 4 - i ; h < 4; ++h) // valori non necessari da conoscere per la simmetria del problema
            cout << '-' << ' ';

        for(int j = i; j < 4;++j,++k)
            cout << v[k] << ' ';//scrittura valore

        cout << endl;
    }
    bool esatto;
    cout << "Digitare 1 per confermare la combinazione e 0 per correggere l'errore" << endl;
    cin >> esatto;
    if(!esatto){
        int quanti;
        cout << "Digitare quanti errori sono:" << endl;
        cin >> quanti;
        cout << "Digitare per ciascuna iterazione il valore e la posizione dell'indice da correggere:" << endl;
        int pos,val;
        for(int i = 0; i < quanti;++i){
            cin >> val >> pos;
            v[pos] = val;
        }

    }
    testa = nullptr;

    for(int i = 0; i < 15; ++i){
        w[i].Vi = 0;
        w[i].Vs = 0;
        w[i].hamiltoniano = false;
        w[i].vuoto = false;
        w[i].tagliato = false;
    }

}

void tsp::converti_indice(int indice, int &riga, int &colonna) {
    switch(indice){
        case 0: riga = 1; colonna = 2; break;
        case 1: riga = 1; colonna = 3; break;
        case 2: riga = 1; colonna = 4; break;
        case 3: riga = 1; colonna = 5; break;
        case 4: riga = 2; colonna = 3; break;
        case 5: riga = 2; colonna = 4; break;
        case 6: riga = 2; colonna = 5; break;
        case 7: riga = 3; colonna = 4; break;
        case 8: riga = 3; colonna = 5; break;
        case 9: riga = 4; colonna = 5; break;
    }
}

bool tsp::hamiltoniano(int * scelti) {
    int riga;
    // conto, fissata la riga, tutte le colonne
    int i = 0;
    int quanti_2 = 0;
    for(int i = 1; i < 5;++i){
        int quanti_archi = conta_nodi_collegati(i,scelti,-1);
        if(quanti_archi == 2) quanti_2++;
    }
    if(quanti_2 == 4) return true;
    return false;
}
int tsp::nodo_vicino(int k,int primo,int *& scelti,int& tot,int quanti) {
    if(k < 0 || k > 5) return 0;
    int appoggio = k;
    if(quanti == 5)
        return 0;
    // qui l'algoritmo è differente, perché devo trovare i nodo minimo, senza verifiche
    if(quanti < 4)
        k = trova_min_k(k,scelti);

    int r,c;

    if(quanti == 4){
        // devo creare la combinazione esistente
        int indice;
        if(primo < appoggio){
            r = primo;
            c = appoggio;
        }
        else{
            r = appoggio;
            c = primo;
        }

    }
    if(quanti < 4)
        converti_indice(k,r,c);
    else
        k = converti_riga_colonna(r,c);
    //output
    if(quanti == 0)
        cout << "Archi: (" << r << '-' << c << ')' << ',';
    else
        cout << "(" << r << '-' << c << ')' << ',';
    if(quanti < 4) escludi_nodi_k(appoggio,scelti);
    int nodo = (appoggio == r)? c : r;
    int zero = 0;
    tot = v[k] + nodo_vicino(nodo,primo,scelti,tot,++quanti);
    return tot;
}

int tsp::trova_min_k(int k,int *& scelti) {
    int indice_min = 0;
    int min = INT32_MAX;

    if(k == 1){
        for(int i = 0; i < 4; ++i)
            if(!scelti[i] && v[i] < min) {
                min = v[i];
                indice_min = i;
            }

    }

    else if(k == 2){
        int trova[4] = {0,4,5,6};

        for(int i = 0; i < 4;++i){
            if(!scelti[trova[i]] && min > v[trova[i]]){
                min = v[trova[i]];
                indice_min = trova[i];
            }
        }
    }

    else if(k == 3){
        int trova[4] = {1,4,7,8};

        for(int i = 0; i < 4;++i){
            if(!scelti[trova[i]] && min > v[trova[i]]){
                min = v[trova[i]];
                indice_min = trova[i];
            }
        }
    }

    else if (k == 4){
        int trova[4] = {2,5,7,9};

        for(int i = 0; i < 4;++i){
            if(!scelti[trova[i]] && min > v[trova[i]]){
                min = v[trova[i]];
                indice_min = trova[i];
            }
        }
    }

    else{
        int trova[4] = {3,6,8,9};

        for(int i = 0; i < 4;++i){
            if(!scelti[trova[i]] && min > v[trova[i]]){
                min = v[trova[i]];
                indice_min = trova[i];
            }
        }
    }

    scelti[indice_min] = true;
    return indice_min;
}

int tsp::k_albero(int k,bool stampa,int *& scelti) {
    if(k < 0 || k > 5) return 0;
    int somma = 0;
    int indice = 0;
    //devo contare quanti erano già scelti tra quelli che non erano archi collegati al nodo k
    int quanti = 0;
    int * no = trova_indici_proibiti(k);
    int quanti_u = 0;
    // devo contare gli archi già scelti, escluso il nodo k:
    for(int i = 0; i < 10 && quanti < 3;++i) {
        int u = 0;

        for(; u < 4;++u)
            if (scelti[i] == 2 && i == no[u])
                break;

        if(scelti[i] == 2 && u == 4)
            quanti++;

    }

    for(int i = 0; i < 3 - quanti;) {
        indice = trova_min(k, scelti);
        int r, c;
        if (ciclo(scelti, k)) {
            scelti[indice] = 3;
        } else {
            if (scelti[indice] == 1) {
                converti_indice(indice, r, c);
                somma += v[indice];
                if (stampa)
                    cout << "Archi non collegati a " << k << ":(" << r << ',' << c << ')' << endl;
                ++i;
            }
        }
    }
    // devo contare quanti archi collegati a k che erano già stati scelti
    for(int i = 0; i < 10;++i){
        int u = 0;

        for(; u < 4;++u)
            if(scelti[i] == 2 && i == no[u])
                break;

        if(scelti[i] == 2 && u != 4)
            quanti_u++;

    }

    if(quanti_u >= 3){
        cout << "Errore: non possono esserci piu' di 3 k-archi" << endl;
        exit(1);
    }

    int r,c;
    if(stampa)
        cout << "Archi collegati a " << k << ": ";
    for(int i = 0; i < 2 - quanti_u; ++i){
        if(stampa && i != 0)
            cout << ',';

        indice = trova_min_k(k,scelti);
        converti_indice(indice,r,c);
        if(stampa)
            cout << '(' << r << ',' << c << ')';
        somma += v[indice];
    }

    //pulisco i 2 utilizzati in prestito[i]:
    for(int i = 0; i < 10;++i)
        if(scelti[i] == 3)
            scelti[i] = 0;

    cout << endl;
    if(stampa)
        cout << "Vi = " << somma << endl;
    return somma;
}

bool tsp::ciclo(int *scelti,int k) {
    int r,c;
    //devo controllare per ciascun nodo quanti sono i vincoli di grado accettati: se sono 3 ho un ciclo chiuso
    int quanti = 0;
    int riga,colonna;
    for(int i = 1; i <= 5;++i) {
        converti_indice(i,riga,colonna);

        int quanti_scelti = conta_nodi_collegati(i,scelti,k);
        if(quanti_scelti == 2) quanti++;
    }

    if(quanti == 3) return true;

    return false;
}

int tsp::trova_min(int indice, int *& scelti) {
    int r,c;
    int min = INT32_MAX;
    int indice_min = 0;
    int * ignora;
    ignora = trova_indici_proibiti(indice);
    for(int i = 0; i < 10; ++i){
        // se ho trovato l'indice da ignorare che è collegato con il nodo indice, allora non lo prendo in considerazione
        int k = 0;
        for(; k < 4;++k)
            if(ignora[k] == i)
                break;

        if( k == 4 && !scelti[i] && min > v[i]){
            min = v[i];
            indice_min = i;
        }
    }

    scelti[indice_min] = 1;
    return indice_min;
}

void tsp::crea_albero(scelta *& tree, int pos,int riga, int colonna,bool includi,int h) {
    if(h < 0 || h > pos ) return;
    if(pos == 1 && !tree){
        tree = new scelta;
        tree->includi = false;
        tree->sinistra  = tree->destra = nullptr;
        tree->riga = tree->colonna = tree->Vi = tree->Vs = -1;
        //istanzio a sinistra e a destra gli archi
        tree->sinistra = new scelta;
        tree->sinistra->includi = false;
        tree->sinistra->sinistra = tree->sinistra->destra = nullptr;
        tree->sinistra->riga = riga;
        tree->sinistra->colonna = colonna;
        tree->sinistra->Vs =tree->Vi = -1;

        tree->destra = new scelta;
        tree->destra->includi = true;
        tree->destra->sinistra = tree->destra->destra = nullptr;
        tree->destra->riga = riga;
        tree->destra->colonna = colonna;
        tree->destra->Vs = tree->destra->Vi = -1;
        return;
    }

    if(!tree){
        tree = new scelta;
        tree->sinistra = tree->destra = nullptr;
        tree->riga = riga;
        tree->colonna = colonna;
        tree->Vi = tree->Vs = -1;
        tree->includi = includi;
    }

    crea_albero(tree->sinistra,pos,riga,colonna,false,++h);
    --h;
    crea_albero(tree->destra,pos,riga,colonna,true,++h);
    --h;
}

void tsp::Branch_Bound() {
    int * scelti;
    scelti = new int[10];
    for(int i = 0; i < 10;++i)
        scelti[i] = false;
    int indice_Vi,indice_Vs;
    cout << "Digitare rispettivamente gli indici per il k_albero e il nodo vicino" << endl;
    cin >> indice_Vi >> indice_Vs;
    int * scelto = scelti;
    int Vi = k_albero(indice_Vi,true,scelto);
    cout << endl;
    cout << "I nodi violati sono: " << endl;
    //trovare i nodi violati.
    list<int>lista_nodi;
    for(int i = 1; i <= 5; ++i) {
        int quanti_nodi = conta_nodi_collegati(i, scelti, -1);
        if(quanti_nodi != 0 && quanti_nodi != 2)
            lista_nodi.push_back(i);
    }
    //per ciascun elemento della lista scriviamo l'equazione
    for(auto it = lista_nodi.begin(); it != lista_nodi.end();it++){
        stampa_nodo(*it,scelti);
    }
    cout << endl;
    resetta(scelto);
    int Vs = 0;
    nodo_vicino(indice_Vs,indice_Vs,scelto,Vs);
    cout << "Vs = " << Vs;
    cout << endl;
    resetta(scelti,false);
    // dobbiamo chiamare la funzione che ci consente di chiamare più volte il k_albero
    int riga, colonna;
    cout << "Scrivere quali sono i nodi interessati per il Branch e Bound per 3 volte di fila, rispettando l'ordine in cui si desidera istanziarle: " << endl;
    bool ok = false;
    int r[3],c[3];
    while(!ok){
        for(int i = 0; i < 3;++i){
            cin >> r[i] >> c[i];
        }
        cout << "Digitare 1 per confermare la combinazione,0 per ripeterla" << endl;
        cin >> ok;
    }

    for(int i = 0; i < 3; ++i)
        crea_albero(testa,i+1,r[i],c[i]);

    branch(testa,testa,indice_Vi,Vs,Vi,scelti);
    aggiorna_Vs();
    taglia_rami();
    stampa_risultato();
}

void tsp::resetta(int *& scelti,bool non_ammessi) {
    for(int i = 0; i < 10;++i)
        if( (non_ammessi && scelti[i] != -1 && scelti[i] != 2) || (!non_ammessi && scelti[i] != 2))
            scelti[i] = false;
}

int tsp::includi(int riga,int colonna, int k,int *& scelti) {
    if(riga < 1 || colonna < 2 || riga >= colonna || riga > 4 || colonna > 5) {
        cout << "Errore indici scorretti" << endl;
        exit(1);
    }
    //conversione da riga,colonna a indice
    int indice = converti_riga_colonna(riga,colonna);
    scelti[indice] = 1;

    //conto se c'è il ciclo

    if( indice == k && conta_nodi_collegati(indice, scelti,-1) == 3)
        return -1;

    if(vuoto(scelti))
        return -1;

    return indice;
}

int tsp::converti_riga_colonna(int riga, int colonna) {
    int indice = 0;
    if(riga < 1 || riga > 4 || colonna < 2 || colonna > 5 ){
        cout << "errore: indici scorretti" << endl;
        exit(1);
    }

    if(riga == 1 && colonna == 2){
        indice = 0;
    }

    if(riga == 1 && colonna == 3){
        indice = 1;
    }

    if(riga == 1 && colonna == 4){
        indice = 2;
    }

    if(riga == 1 && colonna == 5){
        indice = 3;
    }

    if(riga == 2 && colonna == 3){
        indice = 4;
    }

    if(riga == 2 && colonna == 4){
        indice = 5;
    }

    if(riga == 2 && colonna == 5){
        indice = 6;
    }

    if(riga == 3 && colonna == 4){
        indice = 7;
    }

    if(riga == 3 && colonna == 5){
        indice = 8;
    }

    if(riga == 4 && colonna == 5){
        indice = 9;
    }
    return indice;
}

int tsp::escludi(int riga,int colonna,int * scelti) {
    if(riga < 1 || colonna < 2 || riga >= colonna || riga > 4 || colonna > 5) {
        cout << "Errore indici scorretti" << endl;
        exit(1);
    }
    int indice = converti_riga_colonna(riga,colonna);
    scelti[indice] = -1;

    return indice;


}

void tsp::branch(scelta * albero,scelta * copia,int k,int &Vs,int &Vi,int *& scelti,int h,int riga, int colonna,int i) {
    if(!albero) {
        if(h == 4) {
            int ind = converti_riga_colonna(riga,colonna);
            scelti[ind] = 0;
        }
        return;
    }

    int somma = 0;
    int ind;

    //cerco roba già inclusa e la aggiungo già alla somma
    for(int j = 0; j < 10;++j)
        if(scelti[j] == 1){
            somma += v[j];
            scelti[j] = 2;
        }

    if( albero != copia && albero->includi){
        //int riga,int colonna
        ind = includi(albero->riga,albero->colonna,k,scelti);

        if(ind == -1){
            scelti[ind] = false;
            resetta(scelti);
            trasforma_2(scelti);
            w[i].vuoto = true;
            w[i].Vi = Vi;
            w[i].Vs = Vs;
            return;
        }

        if(h == 3){
            for(int j = 1; j <= 5;++j){
                int quanti_nodi = conta_nodi_collegati(j,scelti,-1);
                if(quanti_nodi == 3){
                    scelti[ind] = false;
                    resetta(scelti);
                    trasforma_2(scelti);
                    w[i].vuoto = true;
                    w[i].Vi = Vi;
                    w[i].Vs = Vs;
                    return;
                }

            }
        }
        // devo contare i nodi e vedere quanti ce ne sono già collegati
        somma += v[ind];
        scelti[ind] = 2;
        somma += k_albero(k,false,scelti);
        //devo trasformare quell'elemento incluso in scelto di tipo 2
        w[i].Vi = somma;
        w[i].Vs = Vs;
    }else if(albero != copia && !albero->includi){
        //int riga,int colonna
        ind = escludi(albero->riga,albero->colonna,scelti);
        // devo controllare se i nodi dell'albero hanno 2 nodi
        int quanti_tolti = 0;
        if(h == 3)
            for (int j = 1; j <= 5;++j)
                if (conta_nodi_mancanti(j,scelti) == 3) {
                    scelti[ind] = false;
                    resetta(scelti);
                    trasforma_2(scelti);
                    w[i].Vi = Vi;
                    w[i].Vs = Vs;
                    w[i].vuoto = true;
                    return;
                }

        somma += k_albero(k,false,scelti);
        w[i].Vi = somma;
        w[i].Vs = Vs;
    }

    if(albero != copia && hamiltoniano(scelti)){
        albero->Vs = somma;
        albero->Vi = somma;
        Vi = Vs = somma;
        scelti[ind] = 0;
        resetta(scelti);
        trasforma_2(scelti);
        w[i].hamiltoniano = true;
        w[i].Vs = Vs;
        w[i].Vi = Vi;
        return;
    }

    if(albero != copia) {
        Vi = somma;
        albero->Vi = Vi;
        albero->Vs = Vs;
        w[i].Vs = Vs;
        w[i].Vi = Vi;
    }
    else{
        w[i].Vi = Vi;
        w[i].Vs = Vs;
    }

    resetta(scelti);

    if(h == 3)
        scelti[ind] = 0;

    // i 2 rimasti diventano 1
    trasforma_2(scelti);

    branch(albero->sinistra,copia,k,Vs,Vi,scelti,++h,albero->riga,albero->colonna,i * 2 + 1);
    --h;

    int indi;
    branch(albero->destra,copia,k,Vs,Vi,scelti,++h,albero->riga,albero->colonna,i * 2 + 2);
    --h;


    if(albero != copia) {
        indi = converti_riga_colonna(albero->riga, albero->colonna);
        scelti[indi] = 0;
    }

}

int *tsp::trova_indici_proibiti(int k) {
    int * v;
    v = new int[4];
    if(k == 1) {
        int trova[4] = {0, 1, 2, 3};
        for(int i = 0; i < 4;++i)
            v[i] = trova[i];
    }

    else if(k == 2) {
        int trova[4] = {0, 4, 5, 6};
        for(int i = 0; i < 4; ++i)
            v[i] = trova[i];
    }

    else if(k == 3) {
        int trova[4] = {1, 4, 7, 8};
        for(int i = 0; i < 4; ++i)
            v[i] = trova[i];
    }

    else if (k == 4) {
        int trova[4] = {2, 5, 7, 9};
        for(int i = 0; i < 4; ++i)
            v[i] = trova[i];
    }

    else {
        int trova[4] = {3, 6, 8, 9};
        for(int i = 0; i < 4; ++i)
            v[i] = trova[i];
    }

    return v;
}

void tsp::escludi_nodi_k(int nodo,int *& scelti) {
    if(nodo <= 0 || nodo > 5){
        cout << "Errore: i nodi sono numeri interi positivi e sono previsti al piu' 5 nodi" << endl;
        exit(1);
    }
    int * proibito = trova_indici_proibiti(nodo);
    for(int i = 0; i < 4;++i)
        if(!scelti[proibito[i]])
            scelti[proibito[i]] = -1;
}

tsp::~tsp() {
    elimina_albero(testa);
}

void tsp::elimina_albero(scelta *& elimina) {
    if(!elimina) return ;
    elimina_albero(elimina->sinistra);
    elimina_albero(elimina->destra);
    delete elimina;
    elimina = nullptr;
}

int tsp::conta_nodi_collegati(int nodo, int *scelti,int k) {
    if(nodo < 1 || nodo > 5){
        cout << "I nodi sono naturali e non puo' essere piu' grande di 5" << endl;
        exit(1);
    }
    int riga,colonna;
    int quanti_scelti = 0;
    if(nodo == 1){
        for(int j = 0; j < 4;++j) {
            converti_indice(j,riga,colonna);
            if ( (k == -1 && ( scelti[j] == 1 || scelti[j] == 2)) || (k != -1 && k != riga && k != colonna && (scelti[j] == 1 || scelti[j] == 2)) )
                quanti_scelti++;
        }
    }

    else if (nodo == 2){
        for(int j = 0 ; j < 7;){

            converti_indice(j,riga,colonna);
            if ( (k == -1 && (scelti[j] == 1 || scelti[j] == 2) ) || (k != -1 && k != riga && k != colonna && (scelti[j] == 1 || scelti[j] == 2)) )
                quanti_scelti++;

            if(!j)
                j = 4;

            else ++j;
        }
    }

    else if (nodo == 3){
        for(int j = 1; j < 9;){

            converti_indice(j,riga,colonna);
            if ( (k == -1 && ( scelti[j] == 1 || scelti[j] == 2) ) || (k != -1 && k != riga && k != colonna && (scelti[j] == 1 || scelti[j] == 2)) )
                quanti_scelti++;

            if(j == 1)
                j = 4;

            else if(j == 4)
                j = 7;

            else
                ++j;
        }
    }

    else if(nodo == 4){
        for(int j = 2; j < 10;){

            converti_indice(j,riga,colonna);
            if ( (k == -1 && (scelti[j] == 1 || scelti[j] == 2) ) || (k != -1 && k != riga && k != colonna && (scelti[j] == 1 || scelti[j] == 2)) )
                quanti_scelti++;

            if(j == 2)
                j = 5;

            else if(j == 5)
                j = 7;

            else if(j == 7)
                j = 9;

            else
                ++j;
        }
    }
    else{
        for(int j = 3; j < 10;) {

            converti_indice(j,riga,colonna);
            if ( (k == -1 && (scelti[j] == 1 || scelti[j] == 2) ) || (k != -1 && k != riga && k != colonna && (scelti[j] == 1 || scelti[j] == 2)) )
                quanti_scelti++;

            if (j == 3)
                j = 6;

            else if(j == 6)
                j = 8;

            else ++j;

        }
    }
    return quanti_scelti;
}

void tsp::trasforma_2(int *& v) {
    for(int i = 0; i < 10;++i)
        if(v[i] == 2)
            v[i] = 1;
}

bool tsp::vuoto(int *scelti) {
    //devo contare tutti i nodi
    int quanti_2 = 0;
    for(int i = 1; i <= 5;++i){
        int quanti_collegati = conta_nodi_collegati(i,scelti,-1);
        if(quanti_collegati == 2) quanti_2++;
    }
    if(quanti_2 == 3) return true;
    return false;
}

void tsp::stampa_nodo(int nodo,int * scelti) {
    if (nodo < 1 || nodo > 5) {
        cout << "Errore: non puo' esserci un nodo piu' piccoo di 1 o piu' grande di 5 " << endl;
        exit(1);
    }
    int quanti_archi = 0;
    cout << "Nodo: " << nodo << " con equazione: ";
    for(int i = 1; i <= 5;++i){

        if(nodo == i)
            continue;

        cout << 'X';

        if(nodo < i)
            cout << nodo << i;

        if(nodo > i)
            cout << i << nodo;

        if(i == 5 || (nodo == 5 && i == 4))
            continue;

            cout << " + ";
    }
    cout << " = 2" << endl;
}

int tsp::conta_nodi_mancanti(int nodo, int *scelti) {
    int controlla[4];
    if(nodo == 1)
        for(int i = 0; i < 4;++i)
            controlla[i] = i;

    else if(nodo == 2){
        for(int i = 0,j = 0; i < 7 && j < 4;++j){
            controlla[j] = i;

            if(i == 0)
                i = 4;

            else ++i;
        }
    }

    else if (nodo == 3){
        for(int i = 1, j = 0; i < 9 && j < 4;++j){

            controlla[j] = i;

            if(i == 1)
                i = 4;

            else if(i == 4)
                i = 7;

            else ++i;
        }
    }

    else if(nodo == 4){
        for(int i = 2, j = 0; i < 10 && j < 4; ++j){

            controlla[j] = i;

            if(i == 2)
                i = 5;

            else if(i == 5)
                i = 7;

            else if (i == 7)
                i = 9;

            else
                ++i;
        }
    }

    else {
        for(int i = 3, j = 0; i < 10 && j < 4; ++j){

            controlla[j] = i;

            if (i == 3)
                i = 6;

            else if (i == 6)
                i = 8;

            else ++i;
        }
    }

    // a questo punto basta controllare nel vettore scelti quanti -1 ci sono:
    int quanti = 0;
    for(int i = 0; i < 4; ++i)
        if(scelti[controlla[i]] == -1)
            quanti++;

    return quanti;
}

void tsp::aggiorna_Vs() {
    int inizio = 0,fine = 0,Vs_i = 0;
    bool trovato = false;
    trova_Vs(inizio,fine,Vs_i,trovato);
    int inizio2 = 1, fine2 = 2;
    trova_Vs(inizio2,fine2,Vs_i,trovato);
    int inizio3 = 3, fine3 = 6;
    trova_Vs(inizio3,fine3,Vs_i,trovato);
    int inizio4 = 7, fine4 = 14;
    trova_Vs(inizio4,fine4,Vs_i,trovato);

}

void tsp::trova_Vs(int inizio, int fine, int &Vs_i, bool & trovato) {
    if(inizio < 0 || fine < 0){
        cout << "Errore: non possono essere indici negativi" << endl;
        exit(1);
    }
    if(inizio > fine){
        cout << "Errore: l'indice iniziale non puo' essere piu' grande di quella finale" << endl;
        exit(1);
    }
    if(fine >= 15){
        cout << "Errore: l'indice finale e' troppo grande" << endl;
        exit(1);
    }

    if(inizio == 0 && fine == 0){
        if(w[inizio].hamiltoniano && !w[inizio].vuoto)
            w[inizio].Vs = w[inizio].Vi;
        Vs_i = w[inizio].Vs;
    }

    else{
        bool piccolo;
        // ricerca primo hamiltoniano
        bool hamiltoniano = false;
        int i = inizio;
        int Vs;
        for(; i <= fine;++i){
            if(w[i].hamiltoniano){
                hamiltoniano = true;
                break;
            }
        }
        // se troviamo il primo, cerchiamo di trovare la Vs più piccola possibile fra le Vs possibili
        if(hamiltoniano) {
            if(!trovato)
                trovato = true;
            int primo_hamiltoniano = i;
            ++i;
            Vs = w[primo_hamiltoniano].Vi;
            for (; i <= fine; ++i) {
                if (w[i].hamiltoniano && w[i].Vi < Vs)
                    Vs = w[i].Vi;

            }
            // controllo eventualmente se la nuova Vs sia più piccola di quella già salvata
            piccolo = false;

            if(Vs_i < Vs) {
                Vs = Vs_i;
                piccolo = true;
            }

            else if(Vs_i > Vs)
                Vs_i = Vs;

            }

            else{
                Vs = Vs_i;
                piccolo = true;
            }
        // a questo punto aggiorniamo le Vs
        for (int j = inizio; j <= fine; ++j) {
            if ((!w[j].hamiltoniano && !w[j].vuoto) || (piccolo && w[j].hamiltoniano && !w[j].vuoto))
                w[j].Vs = Vs;
        }

        }

}

void tsp::stampa_risultato() {
    for (int i = 0, h = 0, j = 1; i < 15 && h != 4; ++i) {
        if (i == 0) {
            cout << "P: ";
            if (!w[i].tagliato && ( (w[i].hamiltoniano && w[i].Vi == w[i].Vs) || w[i].Vi == w[i].Vs)) {
                cout << "Vi = Vs = " << w[i].Vi << endl;
            } else if (!w[i].tagliato) {
                cout << "[Vi,Vs] = [" << w[i].Vi << ',' << w[i].Vs;
                if(w[i].hamiltoniano)
                    cout << ", e' anche un ciclo hamiltoniano" << endl;

            }
            cout << endl;
        } else {

            if (!w[i].tagliato) {
                cout << "P" << h + 1 << ',' << j << ": ";
                if ((w[i].hamiltoniano && w[i].Vi == w[i].Vs) || (!w[i].vuoto && w[i].Vi == w[i].Vs))
                    cout << "Vi = Vs = " << w[i].Vi << endl;


                else if (!w[i].vuoto) {
                    cout << "[Vi,Vs] = [" << w[i].Vi << ',' << w[i].Vs << "]\n";
                    if(w[i].hamiltoniano)
                        cout << ", e' anche un ciclo hamiltoniano" << endl;
                }

                else
                    cout << "Vuoto" << endl;

            }

                if (i == 0 || i == 2 || i == 6) {
                    ++h;
                    j = 1;
                    cout << endl;
                } else
                    ++j;

        }

    }

}

void tsp::taglia_rami() {
for(int i = 0; i < 15; ++i){
    if( ( w[i].vuoto || w[i].Vi >= w[i].Vs || w[i].hamiltoniano) && !w[i].tagliato)
        segna_tagliato(i,i);

}
}

void tsp::segna_tagliato(int pos,int inizio) {
if(pos >= 15)
    return;

    if(pos != inizio)
        w[pos].tagliato = true;

    segna_tagliato(pos * 2 + 1,inizio);
    segna_tagliato(pos * 2 + 2,inizio);
}
