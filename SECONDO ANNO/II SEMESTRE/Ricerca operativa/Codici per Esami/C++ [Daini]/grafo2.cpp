
#include "grafo2.h"


void grafo2::stampa_grafo() {
    for(int i = 0; i < dim;++i) {
        cout << '[' << i << ']';
        auto it = lista_grafo[i].begin();

        for (; it != lista_grafo[i].end(); it++){
            if(it != lista_grafo[i].end())
                cout << "->";
            tuple<int,int,int> a = *it;
            cout << '(' << get<0>(a) << ',' << get<1>(a) << ',' << get<2>(a) << ')';
        }
        cout << endl;
    }
}


void grafo2::Cammini_Minimi(int partenza, int arrivo,bool &errato) {
    if(arrivo == partenza) return;
    if(arrivo < 0 || partenza < 0 || arrivo > dim || partenza > dim){
        cout << "Errore, digitare numeri positivi e minori della dimensione scelta" << endl;
        errato = true;
        return;
    }
    int* Pr = new int[dim];//predecessori
    int* Pi = new int[dim];//Pi Greco
    bool* scelto = new bool[dim];//vettore per stabilire se il nodo è già stato scelto
    Pr[partenza] = partenza;
    Pi[partenza] = 0;
    for (int i = 0; i < dim; ++i) {
        if (i != partenza) {
            Pr[i] = -1;
            Pi[i] = INT32_MAX;
        }
    }
    for(int i = 0; i < dim;++i)
        if(i != partenza)
            scelto[i] = false;

    scelto[partenza] = true;

    for (int i = 0, k = partenza; i < dim - 1; ++i) {
        cout << "N:{";
        for (int h = 0; h < dim; ++h)
            if (scelto[h])
                cout << h << ' ';

        cout << '}';
        cout << ", CF(" << k << ")= {";
        for (auto it = lista_grafo[k].begin(); it != lista_grafo[k].end(); it++) {
            tuple<int,int,int> graph = *it;

            cout << get<0>(graph); // stampo il nodo
            auto it2 = it;
            ++it2;
            if ( it2 != lista_grafo[k].end() ) cout << ',';
            // get<1>(a) indica il costo
            if (get<1>(graph) + Pi[k] < Pi[get<0>(graph)]) {
                Pi[get<0>(graph)] = get<1>(graph) + Pi[k];
                Pr[get<0>(graph)] = k;
            }

        }
        cout << "}, p = (";

        for (int i = 0; i < dim; ++i) {
            cout << Pr[i];
            if (i < dim - 1)
                cout << ',';
        }
        cout << "), Pi = (";
        for (int j = 0; j < dim; ++j) {
            if(Pi[j] == INT32_MAX)
                cout << "+inf";
            else
                cout << Pi[j];

            if (j < dim - 1)
                cout << ',';
        }
        cout << ')';
        cout << endl;
        int minimo = INT32_MAX;
        //ricerca del nodo più piccolo non ancora scelto:
        for (int h = 0; h < dim; ++h)
            if (!scelto[h])
                minimo = min(minimo, Pi[h]);

        for (int h = 0; h < dim; ++h)
            if (!scelto[h] && Pi[h] == minimo) {
                k = h;
                scelto[h] = true;
                break;
            }
    }
    cout << endl;
}


void grafo2::Ford_Furkersord(int partenza, int arrivo,bool &errato) {
    if(arrivo == partenza) return;
    if(arrivo < 0 || partenza < 0 || arrivo > dim || partenza > dim){
        cout << "Errore, digitare numeri positivi e minori della dimensione scelta" << endl;
        errato = true;
        return;
    }
    int *precedente = new int[dim];
    precedente[partenza] = partenza;

    for (int i = 0; i < dim; ++i)
        if (precedente[i] != i)
            precedente[i] = -1;
    //costruttore di copia
    grafo2 copia(*this);

    int flusso = 0;
    list<pair<int,int>> lista_appoggio;
    while (true) {
        bool fine = false;
        // creo una lista di tipo pair, dove prendo solo il padre e il figlio


        copia.Cammino_Aumentante(partenza, arrivo, precedente, fine);
        if(!fine) break;
        // mi trovo padre e figlio così da andare a cercare il minimo nel vettore di liste
        int arrivo2 = arrivo;
        for(;arrivo != partenza;arrivo = precedente[arrivo])
            lista_appoggio.emplace_front(precedente[arrivo],arrivo);

        arrivo = arrivo2;
        //stampa nodo:
        cout << "Percorso: " << partenza;
        auto it = lista_appoggio.begin();
        for(;it != lista_appoggio.end();it++){
            cout << "->" << it->second;//stampo il figlio
        }

        //devo aggiornare il grafo, trovando il minimo di capacità
        int delta = INT32_MAX;
        for(it = lista_appoggio.begin();it != lista_appoggio.end();it++){
            int padre = it->first;
            int figlio = it->second;
            auto it2 = copia.lista_grafo[padre].begin();
          //trovo l'iteratore compreso fra inizio e la fine dell'indice del padre, trovando come nodo il figlio
          for(;it2 != copia.lista_grafo[padre].end();it2++) {
              int val = get<2>(*it2);
              int nodo = get<0>(*it2);
              if(nodo == figlio)
              delta = min(delta, val); //minimo fra le capacità
          }
        }
        // ora vogliamo aggiornare la capacità delle liste
        for(it = lista_appoggio.begin();it != lista_appoggio.end();it++){
            int padre = it->first;
            int figlio = it->second;
            auto it2 = copia.lista_grafo[padre].begin();
            for(;it2 != copia.lista_grafo[padre].end();it2++) {
                int nodo = get<0>(*it2);
                if(nodo == figlio)
                    get<2>(*it2) -= delta; // decremento la capacità
            }

        }
        // vogliamo cancellare tutti i nodi
        for(it = lista_appoggio.begin();it != lista_appoggio.end();it++) {
            int padre = it->first;
            auto it2 = copia.lista_grafo[padre].begin();
            for(;it2 != copia.lista_grafo[padre].end();it2++) {
                int val = get<2>(*it2);
                if(!val) {
                    copia.lista_grafo[padre].erase(it2++);
                    break;
                }
            }
        }

        //stampare delta
        cout << ", delta = " << delta;
        flusso += delta;
        cout << ", flusso = " << flusso << endl;
        //aggiorno i nodi

        //estrazione lista
        lista_appoggio.clear();

        for (int i = 0; i < dim; ++i)
            if (precedente[i] != i)
                precedente[i] = -1;

    }
    // sono fuori dal ciclo, per cui posso trovare il piano di taglio:
    cout << "Nt: {";
    for (int i = 0; i < dim; ++i)
        if (precedente[i] == -1) cout << i << ' ';

    cout << '}' << endl << "Ns: {";
    for (int i = 0; i < dim; ++i)
        if (precedente[i] != -1) cout << i << ' ';

    cout << '}' << endl << "la capacita' del taglio minimo pari a: " << flusso;

}

void grafo2::Cammino_Aumentante(int partenza, int arrivo, int *& precedenti,bool & fine_alg) {
    if (partenza == arrivo) return;
    list<int> * empty;//nodo,capacità
    //T,list<int> *,int,int,int *&
    segna_predecessori(partenza,arrivo,precedenti);
    //dobbiamo valutare le cause per cui sono uscito dal ciclo. Se sono uscito e non ho trovato l'arrivo, posso dire che abbiamo finito con Furkersord
    if(precedenti[arrivo] != -1){
        fine_alg = true;
        return;
    }
}

void grafo2::segna_predecessori(int partenza, int arrivo, int *& precedenti) {
    if(lista_grafo[partenza].empty() || precedenti[arrivo] != -1) return;
    auto it = lista_grafo[partenza].begin();
    for(;it != lista_grafo[partenza].end();it++){
        int nodo = get<0>(*it);
        if (precedenti[nodo] == -1)
            precedenti[nodo] = partenza;
    }

    for(it = lista_grafo[partenza].begin();it != lista_grafo[partenza].end();it++) {
        int nodo = get<0>(*it);
        if (precedenti[nodo] == partenza)
            segna_predecessori( nodo, arrivo, precedenti);
    }
}

grafo2::grafo2(int n) {
    dim = n;
    lista_grafo = new list<tuple<int,int,int>>[n];

    for (int i = 0; i < n; ++i) {
        cout << "nodo: " << i << ':' << endl;
        cout << "quanti nodi? ";
        int quanti;
        cin >> quanti;
        int* v, * w, * u;
        v = new int[quanti];
        w = new int[quanti];
        u = new int[quanti];
        cout << "indicare posizione nodo(da 0 a n-1), il suo costo e la sua capacita'" << endl;
        for (int k = 0; k < quanti; ++k) {
            int val, ind, capacita;
            cin >> ind >> val >> capacita;
            v[k] = val;
            w[k] = ind;
            u[k] = capacita;
        }

        //metodo innefficiente ma semplice
        for(int k = 0; k < quanti;++k){
            int min = k;
            for(int h = k + 1; h < quanti;++h)
                if(w[h] < w[min])
                    min = h;

            swap(w[k],w[min]);
            swap(v[k],v[min]);
            swap(u[k],u[min]);

        }

        for (int k = 0; k < quanti; ++k)
            //va messo inserimento ordinato per nodi
            lista_grafo[i].emplace_back(w[k],v[k],u[k]);
        cout << '}' << endl;
    }
}


