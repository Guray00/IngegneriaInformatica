#include "compito.h"

bool CampoMinato::coordinate_scorrette(int r, int c) const {
    return (r < 0 || c < 0 || r >= dimensione || c >= dimensione);
}

bool CampoMinato::cella_scoperta(char cella) {
    return ((cella >= '0' && cella <= '9') || cella == ' ');
}

CampoMinato::CampoMinato(int n) {

    if(n <= 1)
        n = 10;

    dimensione = n;
    num_mine = 0;

    tabellone = new char[dimensione*dimensione];
    for(int i = 0; i < dimensione*dimensione; ++i)
        tabellone[i] = 'X';

    stato = NON_AVVIABILE;
}

CampoMinato::~CampoMinato() {
    delete[] tabellone;
}

bool CampoMinato::aggiungi_mina(int r, int c){

    if(coordinate_scorrette(r, c))
        return false;

    if(stato != NON_AVVIABILE && stato != AVVIABILE)
        return false;

    if(tabellone[r*dimensione+c] != 'X')
        return false;

    num_mine++;
    tabellone[r*dimensione+c] = 'M';
    stato = AVVIABILE;

    return true;
}

void CampoMinato::scopri(int r, int c) {

    if(coordinate_scorrette(r, c))
        return;

    if(cella_scoperta(tabellone[r * dimensione + c]))
        return;

    if(stato == NON_AVVIABILE || stato == SCONFITTA || stato == VITTORIA)
        return;

    stato = AVVIATO;

    if(tabellone[r * dimensione + c] == 'M'){
        stato = SCONFITTA;
        return;
    }

    bool vittoria = true;
    for(int i = 0; i < dimensione*dimensione; ++i)
        if(tabellone[i] == 'X' && i != r * dimensione + c) {
            vittoria = false;
            break;
        }

    if(vittoria){
        stato = VITTORIA;
        return;
    }

    int quante_mine = 0;
    for(int i = -1; i <= 1; ++i)
        for(int j = -1; j <= 1; ++j)
            if(!coordinate_scorrette(r+i, c+j))
                if(tabellone[(r+i) * dimensione + c + j] == 'M')
                    quante_mine++;

    if(quante_mine > 0){
        tabellone[r * dimensione + c] = '0' + quante_mine;
        return;
    }


	// SECONDA PARTE

    tabellone[r * dimensione + c] = ' ';

    for(int i = -1; i <= 1; ++i)
        for(int j = -1; j <= 1; ++j)
            scopri(r+i, c+j);
}

ostream& operator<<(ostream& os, const CampoMinato& c){

    if(c.stato == CampoMinato::NON_AVVIABILE){
        os << "Inserire una mina per avviare il gioco" << endl;
        return os;
    }

    if(c.stato == CampoMinato::SCONFITTA){
        os << "Game over" << endl;
        return os;
    }

    if(c.stato == CampoMinato::VITTORIA){
        os << "Vittoria!" << endl;
        return os;
    }

    os << "Campo Minato " << c.dimensione << "x" << c.dimensione << " - ";
    os << "Mine da trovare: " << c.num_mine << endl;

    for(int i = 0; i < c.dimensione; ++i) {
        for (int j = 0; j < c.dimensione - 1; ++j)
            if (c.cella_scoperta(c.tabellone[i * c.dimensione + j]))
                os << c.tabellone[i * c.dimensione + j] << ' ';
            else
                os << "X ";

        if (c.cella_scoperta(c.tabellone[(i+1) * c.dimensione - 1]))
            os << c.tabellone[(i+1) * c.dimensione - 1];
        else
            os << 'X';

        os << endl;
    }

    return os;
}

CampoMinato::CampoMinato(const CampoMinato &c) {

    dimensione = c.dimensione;
    num_mine = c.num_mine;

    tabellone = new char[dimensione*dimensione];
    for(int i = 0; i < dimensione*dimensione; ++i)
        tabellone[i] = (c.tabellone[i] == 'M') ? 'M' : 'X';

    if(c.stato != NON_AVVIABILE)
        stato = AVVIABILE;
    else
        stato = NON_AVVIABILE;
}

CampoMinato CampoMinato::operator+(const CampoMinato &c) const {

    CampoMinato risultato(dimensione + c.dimensione);
    risultato.num_mine = num_mine + c.num_mine;
    risultato.stato = (risultato.num_mine > 0) ? AVVIABILE : NON_AVVIABILE;

    for(int i = 0; i < dimensione*dimensione; ++i)
        if(tabellone[i] == 'M')
            risultato.tabellone[(i / dimensione) * risultato.dimensione + i % dimensione] = 'M';

    for(int i = 0; i < c.dimensione*c.dimensione; ++i)
        if(c.tabellone[i] == 'M')
            risultato.tabellone[(i / c.dimensione + dimensione) * risultato.dimensione + i % c.dimensione + dimensione] = 'M';

    return risultato;
}