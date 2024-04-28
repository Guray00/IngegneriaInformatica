//
// Created by Utente on 14/06/2023.
//

#include "zaino.h"

zaino::zaino() {
    cout << "Inserire la dimensione" << endl;

    int dim;
    cin >> dim;

    v.resize(dim);
    Vs_vet.resize(15);
    funzione_obbiettivo.resize(dim);
    includi_vet.resize(14);
    for(int i = 0; i < 14; ++i)
            includi_vet[i] = (i%2 != 0);



    cout << endl << "Indicare i valori v(i coefficienti della funzione obbiettivo):" << endl;
    for (int i = 0; i < v.size(); ++i)
        cin >> funzione_obbiettivo[i];

    cout << endl << "digitare i pesi in ordine, come il problema elenca(elementi del vincolo del problema dello zaino): " << endl;
    for (int i = 0; i < v.size(); ++i)
        cin >> v[i];

    int cap;
    cout << endl << "Indicare la capienza massima:" << endl;
    cin >> cap;
    capienza_massima = cap;
}

void zaino::risolvi_zaino_intero() {
    //x >= 0 => problema
    vector<double>r = trova_rendimento();
    // il primo elemento trovato
    int i = 0;
    for(; i < v.size();i++)
        if(r[0] == double(funzione_obbiettivo[i])/double(v[i]))
            break;
    int pos = 0;
    cout << "La soluzione dello zaino intero con rilassato x >= 0 e': (";
    for(int k = 0; k < v.size();++k){
        if(k != 0)
            cout << ", ";

        if(k == i) {
            cout << capienza_massima << '/' << v[i];
            pos = i;
        }
        else
            cout << '0';
    }
    cout << "), con Vs = " << floor(double(capienza_massima)/double(v[pos]) * double(funzione_obbiettivo[pos]));

}

vector<double> zaino::trova_rendimento() {
    vector<double> r;
    r.resize(v.size());

        for (int i = 0; i < v.size(); ++i) {
            r[i] = double(funzione_obbiettivo[i]) / double(v[i]);
        }
    sort(r.begin(),r.end());
    reverse(r.begin(),r.end());
    return r;
}

void zaino::risolvi_zaino_binario(int &Vi, int &Vs, int&pos) {
    vector<double> r = trova_rendimento();
    int k = 0, i = 0;
    int somma = 0;
    int pos_fraz = 0;
    bool trovato[r.size()];

    for(; i < r.size();i++)
        trovato[i] = false;


    while(true) {
        i = 0;
        for (; i < v.size(); ++i)
            if (r[k] == double(funzione_obbiettivo[i]) / double(v[i])) {
                ++k;
                trovato[i] = true;
                break;
            }

        if (somma + v[i] > capienza_massima){
            pos_fraz = i;
            trovato[i] = true;
            break;
    }
        somma += v[i];
    }
    // ora ho il valore di Vi
    // soluzione per il Vi
    cout << "Soluzione per lo zaino binario per trovare la valutazione inferiore: (";
    for(int h = 0; h < v.size();++h){
        if(h != 0)
            cout << ", ";

        if(!trovato[h] || (h == pos_fraz))
            cout << '0';
        else
            cout << '1';
    }

    int somma_valore = 0;


    for(i = 0; i < v.size();++i)
        if(trovato[i] && i != pos_fraz)
            somma_valore += funzione_obbiettivo[i];

    Vi = somma_valore;

    cout << "), con Vi = " << Vi << endl;

    // soluzione per il Vf
    cout << "Soluzione per lo zaino binario per trovare la valutazione superiore: (";
    for(int h = 0; h < v.size();++h){
        if(h != 0)
            cout << ", ";

        if(!trovato[h])
            cout << '0';

        else if(trovato[h] && h != pos_fraz)
            cout << '1';

        else if(trovato[h] && h == pos_fraz)
            cout << capienza_massima - somma << '/' << v[pos_fraz];
    }

    Vs = Vi + floor((capienza_massima - somma) * funzione_obbiettivo[pos_fraz]/v[pos_fraz]);
    cout << "), con Vs = " << Vs << endl;
    pos = pos_fraz;
}

void zaino::Branch_Bound() {
    int Vi = 0, Vs = 0,pos = 0;

    risolvi_zaino_binario(Vi,Vs,pos);
    //ora possiamo costruire l'albero dinamicamente:
    vector<int>ammesso(v.size(),0);
    int * v = new int[3];
    pos = 0;
    int Vi2 = 0;
    costruisci_albero(ammesso,pos,Vi2,v);
    delete []v;

    // possiamo aggiornare il vettore
    aggiorna_vettore_Vs(Vi);
}

int zaino::Vs_zaino(int &Vs,vector<int> &ammesso, int Vs_pos) {
    int somma_peso = 0;
    int somma = 0;
    for (int i = 0; i < ammesso.size(); ++i) {
        // se erano già stati inclusi li aggiungo alla somma
        if (ammesso[i] == 2) {
            somma_peso += v[i];
            somma += funzione_obbiettivo[i];
        }
    }


    vector<double> r = trova_rendimento();
    int k = 0;
    int pos;
    while (k != r.size()) {
        int i = 0;
        for (; i < r.size(); ++i) {

            if (r[k] == double(funzione_obbiettivo[i]) / double(v[i])) {
                ++k;

                if(ammesso[i] == 0)
                    ammesso[i] = 1;

                break;
            }
        }

                if ( (ammesso[i] != -1 && ammesso[i] != 2 && somma_peso + v[i] > capienza_massima) || i >= ammesso.size()) {
                    pos = (i >= ammesso.size())? i - 1 : i;
                    break;
                }

                if(ammesso[i] == 1)
                    somma_peso += v[i];
            }

    for(int i = 0; i < ammesso.size();++i)
        if( (ammesso[i] == 1) && i != pos)
            somma += funzione_obbiettivo[i];

    double aggiunta;
    if(pos < r.size())
        aggiunta = (double(capienza_massima - somma_peso)) /double(v[pos]) * double(funzione_obbiettivo[pos]);
    else aggiunta = 0;

    Vs_vet[Vs_pos] = int(somma + floor(aggiunta));

    if(somma_peso == capienza_massima)
        Vs_vet[Vs_pos] *= -1;
    return pos;
}


void zaino::includi(vector<int> &ammesso,int pos) {
    ammesso[pos] = 2;
}

void zaino::escludi(vector<int> &ammesso,int pos){
ammesso[pos] = -1;
}


void zaino::togli_1(vector<int> &ammesso) {

    for(int i = 0; i < ammesso.size(); ++i){
    if(ammesso[i] == 1)
        ammesso[i] = 0;
}

}

void zaino::aggiorna_vettore_Vs(int Vi) {
    //aggiornamento Vi
    bool is_equal[4] = {false,false,false,false};
    int Vi_max[4] = {Vi,Vi,Vi,Vi};
    bool tagliato[15] = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false};
    bool *a = tagliato;
    int pos = 0;
    for(int i = 0; i < Vs_vet.size();++i){
        // caso radice
        if(i == 0 && ( (Vs_vet[i] > 0 && Vs_vet[i] < Vi_max[0]) || Vs_vet[i] < 0) ) {
            is_equal[0] = true;
            if(Vs_vet[i] < 0)
                Vi_max[0] = -Vs_vet[i];
        }
        //caso generale
        if(Vs_vet[i] < 0) {

            if(i == 0)
            Vi_max[pos] = -Vs_vet[i];

            if(i >= 1 && i <= 2) {
                pos++;
                is_equal[1] = true;
                if(Vs_vet[i] < 0 && -Vs_vet[i] > Vi_max[1])
                    Vi_max[1] = -Vs_vet[i];
            }

            if(i >= 3 && i <= 6) {
                pos++;
                is_equal[2] = true;
                if(Vs_vet[i] < 0 && -Vs_vet[i] > Vi_max[2])
                    Vi_max[2] = -Vs_vet[i];
            }

            if(i >= 7 && i <= 15) {
                pos++;
                is_equal[3] = true;
                if(Vs_vet[i] < 0 && -Vs_vet[i] > Vi_max[3])
                    Vi_max[3] = -Vs_vet[i];
            }

        }

    }


    //setto la roba tagliata
    for(int i = 0; i < 15;++i){
        if(i == 0)
            pos = 0;
        if(i>=1 && i<=2)
            pos = 1;
        if(i>=3 && i<=6)
            pos = 2;
        if(i>=7 && i<=14)
            pos = 3;

        if(Vs_vet[i] >= 0 && Vs_vet[i] < Vi_max[pos]){
            taglia(a,i*2+1);
            taglia(a,i*2+2);
        }

        if(is_equal[pos]){
                if(Vs_vet[i] < 0){
                    taglia(a,i*2+1);
                    taglia(a,i*2+2);
                }
            }
        }

    for(int i = 0; i < 15;++i){

        if(i == 0)
            pos = 0;
        if(i>=1 && i<=2)
            pos = 1;
        if(i>=3 && i<=6)
            pos = 2;
        if(i>=7 && i<=14)
            pos = 3;

        if(!tagliato[i]){
            bool * b = tagliato;
            int val = trova_Vi(Vi_max,Vs_vet[i],pos,b);
            if( Vs_vet[i] > 0 && Vs_vet[i] <= val && i != 0 && i != 1) {
                taglia(b, i * 2 + 1);
                taglia(b,i * 2 + 2);
            }
            if(i == 1 && Vi_max[0] > Vs_vet[0]){
                taglia(b, i * 2 + 1);
                taglia(b,i * 2 + 2);
            }
        }
    }

    // stampa
    for(int i = 0; i < Vs_vet.size(); ++i) {
        int altezza,riga;
        if(i == 0)
            pos = 0;
        if(i>=1 && i<=2)
            pos = 1;
        if(i>=3 && i<=6)
            pos = 2;
        if(i>=7 && i<=14)
            pos = 3;

        if (i == 0) {
            cout << "P: [" << Vi_max[pos] << ',' << (Vs_vet[i] >= 0 ? Vs_vet[i] : -Vs_vet[i]) << ']';

            cout << endl;
            continue;
        }

        if (i >= 1 && i <= 2) {
            altezza = 1;
            riga = i;
        }

        if(i>=3 && i<=6) {
            altezza = 2;
            riga = i-2;
        }

        if(i>=7 && i<=14) {
            altezza = 3;
            riga = i-6;
        }
            if(!tagliato[i]) {

                int num = -1;

                if(Vs_vet[i] < 0)
                    cout << "P" << altezza << ',' << riga << ":[" << -Vs_vet[i] << ',' << -Vs_vet[i] << ']';

                else {
                    int Vi_giusta;

                    bool * c = tagliato;

                    if(i == 0)
                        pos = 0;
                    if(i>=1 && i<=2)
                        pos = 1;
                    if(i>=3 && i<=6)
                        pos = 2;
                    if(i>=7 && i<=14)
                        pos = 3;


                    num = trova_Vi(Vi_max,Vs_vet[i],pos,c);
                    Vi_giusta = num;
                    if(i == 0)
                        Vi_giusta = Vi;
                    else if(i == 1 && Vs_vet[i] <= num)
                        Vi_giusta = Vi_max[0];
                    cout << "P" << altezza << ',' << riga << ":[" << Vi_giusta << ',' << Vs_vet[i] << ']';
                }


                if (Vs_vet[i] <0 || (i != 0 && i != 1 && Vs_vet[i] > 0 && Vs_vet[i] == num)) {
                    cout << "Vi = Vs => tagliato\n";

                }

                else if (i != 0 && i != 1 && Vs_vet[i] > 0 && Vs_vet[i] < num)
                    cout << "Vs < Vi => tagliato\n";

                else if( i == 1 && Vs_vet[i] > 0 && Vs_vet[i] < Vi_max[i])
                    cout << "Vs < Vi => tagliato \n";

                else
                    cout << endl;
            }

        }

    }
int zaino::trova_Vi(int *v,int num,int pos,bool * tagliato) {
    int i = 0;
    int pos2;
    for(; i < 15; ++i) {
        if(i == 0)
            pos2 = 0;
        if(i>=1 && i<=2)
            pos2 = 1;
        if(i>=3 && i<=6)
            pos2 = 2;
        if(i>=7 && i<=14)
            pos2 = 3;


        if (num <= v[pos2] && !tagliato[i])
            return v[pos2];
    }

    if(i == 15)
        return v[pos];
}

void zaino::costruisci_albero(vector<int> &ammesso, int pos,int Vi, int *w,int i) {
    if(pos >= 15)
        return;
    int Vs = 0;
    if(pos == 0) {
        w = new int[3];

        for(int j = 0; j < 3; ++j)
            w[j] = -1;
    }

    togli_1(ammesso);

    if(pos != 0 && !includi_vet[pos-1])
        escludi(ammesso,w[i-1]);

    else if(pos != 0)
        includi(ammesso,w[i-1]);

    w[i] = Vs_zaino(Vs, ammesso,pos);


    pos = pos * 2 + 1;
    costruisci_albero(ammesso,pos,Vi,w,++i);
    if(i > 0)
    --i;

    if(pos != 0)
        pos /= 2;

    pos = pos * 2 + 2;
    costruisci_albero(ammesso,pos,Vi,w,++i);
    if(i > 0)
        --i;
    if(i > 0)
        ammesso[w[i-1]] = 0;

    if(pos != 0)
        pos /= 2;

}

void zaino::taglia(bool *& stato,int pos) {
    if(pos <= 0 || pos >= 15)
        return;
    stato[pos] = true;
    taglia(stato,pos*2+1);
    taglia(stato,pos*2+2);
}



