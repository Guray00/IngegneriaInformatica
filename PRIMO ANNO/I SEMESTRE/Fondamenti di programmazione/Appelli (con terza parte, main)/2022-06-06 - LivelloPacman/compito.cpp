#include "compito.h"
using namespace std;

LivelloPacman::LivelloPacman(){
    for (int i=0; i < RIG; i++){
        for (int j=0; j < COL; j++){
            schema[i][j] = '|';
        }
    }
    pacman_r = 0;
    pacman_c = 0;
    // SECONDA PARTE:
    fantasma_r = 0;
    fantasma_c = 0;
}

void LivelloPacman::scava(int r, int c){
    if(schema[r - 1][c - 1] == '|')
        schema[r - 1][c - 1] = ' ';
}

LivelloPacman& LivelloPacman::corr(char d, int r, int c, int l){
    if(d != 'o' && d != 'v')
        return *this;
	if(l < 1 || r < 1 || r > RIG || c < 1 || c > COL)
		return *this;
    if(d == 'v' && r+l-1 > RIG)
        return *this;
    if(d == 'o' && c+l-1 > COL)
        return *this;
    for (int i = 0; i < l; i++) {
        if (d == 'o') {
            scava(r, c + i);
            scava(r, COL + 1 - (c + i));
            scava(RIG + 1 - r, c + i);
            scava(RIG + 1 - r, COL + 1 - (c + i));
        } else {
            scava(r + i, c);
            scava(r + i, COL + 1 - c);
            scava(RIG + 1 - (r + i), c);
            scava(RIG + 1 - (r + i), COL + 1 - c);
        }
    }
	return *this;
}

ostream& operator<<(ostream& os, const LivelloPacman &s){
    for (int i=0; i < RIG; i++){
        for(int j=0; j < COL; j++){
            os << s.schema[i][j];
        }
        os << endl;
    }
    return os;
}

LivelloPacman& LivelloPacman::pacman(int r, int c){
    if(pacman_r != 0)
        return *this;
	if(r < 1 || r > RIG || c < 1 || c > COL)
		return *this;
	if(schema[r-1][c-1] != ' ')
	    return *this;
	pacman_r = r;
	pacman_c = c;
    schema[r-1][c-1] = 'P';
    return *this;
}

LivelloPacman& LivelloPacman::muovi(char d, int l) {
    if (pacman_r == 0)
        return *this;
    if (d != 'd' && d != 's' && d != 'b' && d != 'a')
        return *this;
    if (l < 1)
        return *this;
    int pacman_r_prec, pacman_c_prec;
    for (int i = 0; i < l; i++) {
        pacman_r_prec = pacman_r;
        pacman_c_prec = pacman_c;
        if (d == 'd') { // movimento verso destra (numero colonna ++)
            if (pacman_c == COL && schema[pacman_r - 1][0] == ' ')
                pacman_c = 1; // effetto pacman
            else if (pacman_c == COL && schema[pacman_r - 1][0] == 'F')
                return *this; // c'e' un fantasma che impedisce l'effetto pacman
            else if (schema[pacman_r - 1][pacman_c - 1 + 1] == ' ')
                pacman_c++; // muovo pacman
            else
                return *this; // c'e' un fantasma o un muro che impedisce il movimento
        } else if (d == 's') { // movimento verso sinistra (numero colonna --)
            if (pacman_c == 1 && schema[pacman_r - 1][COL - 1] == ' ')
                pacman_c = COL; // effetto pacman
            else if (pacman_c == 1 && schema[pacman_r - 1][COL - 1] == 'F')
                return *this; // c'e' un fantasma che impedisce l'effetto pacman
            else if (schema[pacman_r - 1][pacman_c - 1 - 1] == ' ')
                pacman_c--; // muovo pacman
            else
                return *this; // c'e' un fantasma o un muro che impedisce il movimento
        } else if (d == 'b') { // movimento verso il basso (numero riga ++)
            if (pacman_r == RIG && schema[0][pacman_c - 1] == ' ')
                pacman_r = 1; // effetto pacman
            else if (pacman_r == RIG && schema[0][pacman_c - 1] == 'F')
                return *this; // c'e' un fantasma che impedisce l'effetto pacman
            else if (schema[pacman_r - 1 + 1][pacman_c - 1] == ' ')
                pacman_r++; // muovo pacman
            else
                return *this; // c'e' un fantasma o un muro che impedisce il movimento
        } else if (d == 'a') { // movimento verso l'alto (numero riga --)
            if (pacman_r == 1 && schema[RIG - 1][pacman_c - 1] == ' ')
                pacman_r = RIG; // effetto pacman
            else if (pacman_r == 1 && schema[RIG - 1][pacman_c - 1] == 'F')
                return *this; // c'e' un fantasma che impedisce l'effetto pacman
            else if (schema[pacman_r - 1 - 1][pacman_c - 1] == ' ')
                pacman_r--; // muovo pacman
            else
                return *this; // c'e' un fantasma o un muro che impedisce il movimento
        }
        schema[pacman_r_prec - 1][pacman_c_prec - 1] = ' ';
        schema[pacman_r - 1][pacman_c - 1] = 'P';
        // SECONDA PARTE:
        if (fantasma_r != 0) {
            muovi_fantasma();
            if(pacman_c == 0) // pacman e' stato acchiappato
                return *this;
        }
    }
    return *this;
}

// --- SECONDA PARTE ---

int LivelloPacman::spazio(char d)const{
    if(pacman_r == 0)
        return -1;
    if(d != 'd' && d != 's' && d != 'b' && d != 'a')
        return -1;
    int spazio = 0;
    int i;
    if(d == 'b') {
        i = pacman_r + 1;
        while (i <= RIG && schema[i - 1][pacman_c - 1] == ' ') {
            spazio++;
            i++;
        }
    }
    else if(d == 'a') {
        i = pacman_r - 1;
        while (i >= 1 && schema[i - 1][pacman_c - 1] == ' ') {
            spazio++;
            i--;
        }
    }
    else if(d == 'd') {
        i = pacman_c + 1;
        while (i >= 1 && schema[pacman_r - 1][i - 1] == ' ') {
            spazio++;
            i++;
        }
    }
    else if(d == 's') {
        i = pacman_c - 1;
        while (i >= 1 && schema[pacman_r - 1][i - 1] == ' ') {
            spazio++;
            i--;
        }
    }
    return spazio;
}

LivelloPacman& LivelloPacman::fantasma(int r, int c){
    if(fantasma_r != 0)
        return *this;
    if(r < 1 || r > RIG || c < 1 || c > COL)
        return *this;
    if(schema[r-1][c-1] != ' ')
        return *this;
    fantasma_r = r;
    fantasma_c = c;
    schema[r-1][c-1] = 'F';
    return *this;
}

LivelloPacman& LivelloPacman::fermo(){
    if(pacman_r != 0 && fantasma_r != 0)
        muovi_fantasma();
    return *this;
}

void LivelloPacman::muovi_fantasma(){
    int dist_rig, dist_col;
    int fantasma_r_prec = fantasma_r;
    int fantasma_c_prec = fantasma_c;

    dist_col = pacman_c - fantasma_c;
    dist_col = dist_col>0?dist_col:-dist_col;
    dist_rig = pacman_r - fantasma_r;
    dist_rig = dist_rig>0?dist_rig:-dist_rig;
    if(dist_col > dist_rig) { // la distanza maggiore e' quella orizzontale
        if (pacman_c > fantasma_c) { // fantasma cerca di muoversi verso destra
            if (schema[fantasma_r - 1][fantasma_c - 1 + 1] != '|') {
                // muovo il fantasma
                fantasma_c++;
            }
        } else { // fantasma cerca di muoversi verso sinistra
            if (schema[fantasma_r - 1][fantasma_c - 1 - 1] != '|') {
                // muovo il fantasma
                fantasma_c--;
            }
        }
    }
    else { // la distanza maggiore e' quella verticale
        if (pacman_r > fantasma_r) { // fantasma cerca di muoversi verso il basso
            if (schema[fantasma_r - 1 + 1][fantasma_c - 1] != '|') {
                // muovo il fantasma
                fantasma_r++;
            }
        } else { // fantasma cerca di muoversi verso l'alto
            if (schema[fantasma_r - 1 - 1][fantasma_c - 1] != '|') {
                // muovo il fantasma
                fantasma_r--;
            }
        }
    }
    schema[fantasma_r_prec-1][fantasma_c_prec-1] = ' ';
    schema[fantasma_r-1][fantasma_c-1] = 'F';
    if(pacman_r == fantasma_r && pacman_c == fantasma_c){
        // il fantasma ha acchiappato pacman
        pacman_r = 0;
        pacman_c = 0;
    }
}