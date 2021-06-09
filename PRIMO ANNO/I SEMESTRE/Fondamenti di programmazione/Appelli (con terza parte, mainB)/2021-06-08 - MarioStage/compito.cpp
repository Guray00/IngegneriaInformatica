#include "compito.h"
using namespace std;

MarioStage::MarioStage(){
    for (int i=0; i < ROWS; i++){
        for (int j=0; j < COLS; j++){
            scheme[i][j] = ' ';
        }
    }
    i_mario = -1;
    j_mario = -1;
    i_koopa = -1;
    j_koopa = -1;
    koopa_killed = false;
    game_over = true;
}

ostream& operator<<(ostream& os, const MarioStage &s){
    if(s.game_over){
        os << "(NOT PLAYING)" << endl;
        return os;
    }
    for (int i=ROWS-1; i >= 0; i--){
        os << i;
        for(int j=0; j < COLS; j++){
            if(i == s.i_mario && j == s.j_mario)
                os << 'M';
            else if(i == s.i_koopa && j == s.j_koopa && !s.koopa_killed)
                os << "K";
            else
                os << s.scheme[i][j];
        }
        os << endl;
    }
    os << ' ';
    for(int j=0; j < COLS; j++)
        os << j % 10;
    os << endl;

    return os;
}

MarioStage& MarioStage::drawBlocks(int i1, int j1, int i2, int j2){
    if(!game_over) return *this;
    if(i1 < 0 || i1 >= ROWS || j1 < 0 || j1 >= COLS)
        return *this;
    if(i2 < i1 || i2 >= ROWS || j2 < j1 || j2 >= COLS)
        return *this;
    if(i1 <= i_koopa && i_koopa <= i2 && j1 <= j_koopa && j_koopa <= j2)
        return *this;
    for (int i = i1; i <= i2; i++){
        for(int j = j1; j <= j2; j++){
            scheme[i][j] = '=';
        }
    }
    return *this;
}

void MarioStage::play(int _i_mario, int _j_mario){
    if(_i_mario <= 0 || _i_mario >= ROWS)
        return;
    if(_j_mario < 0 || _j_mario >= COLS-1)
        return;
    if(scheme[_i_mario][_j_mario] != ' ' || scheme[_i_mario-1][_j_mario] != '=')
        return;
    // FUNZIONALITA' DELLA SECONDA PARTE
    if(_i_mario == i_koopa && _j_mario == j_koopa)
        return;
    koopa_killed = false;
    // FINE FUNZIONALITA' DELLA SECONDA PARTE
    i_mario = _i_mario;
    j_mario = _j_mario;
    game_over = false;
}

MarioStage& MarioStage::walkMario(int n){
    if(game_over || n <= 0) return *this;
    for(int i = 0; i < n; i++){
        if(scheme[i_mario][j_mario+1] == '='){
            // Mario smette di camminare a causa di un muro
            return *this;
        }
        j_mario++;
        // FUNZIONALITA' DELLA SECONDA PARTE
        if(!koopa_killed && i_mario == i_koopa && j_mario == j_koopa){
            // Mario viene ucciso dalla Koopa
            game_over = true;
            return *this;
        }
        // FINE FUNZIONALITA' DELLA SECONDA PARTE
        while(i_mario > 0 && scheme[i_mario-1][j_mario] != '='){
            // Mario cade giu'
            i_mario--;
            // FUNZIONALITA' DELLA SECONDA PARTE
            if(!koopa_killed && i_mario == i_koopa && j_mario == j_koopa){
                // Mario uccide la Koopa
                koopa_killed = true;
            }
            // FINE FUNZIONALITA' DELLA SECONDA PARTE
        }
        if(i_mario == 0){
            // Mario cade nella lava
            game_over = true;
            return *this;
        }
        if(j_mario == COLS - 1){
            // Mario vince
            game_over = true;
            return *this;
        }
    }
    return *this;
}

// --- SECONDA PARTE ---
MarioStage& MarioStage::setKoopa(int i, int j){
    if(!game_over) return *this;
    if(i < 0 || i >= ROWS)
        return *this;
    if(j < 0 || j >= COLS)
        return *this;
    if(scheme[i][j] != ' ')
        return *this;
    i_koopa = i;
    j_koopa = j;

    return *this;
}

MarioStage& MarioStage::jumpMario(int n){
    if(game_over || n <= 0) return *this;

    // Mario si eleva di n celle
    for(int i = 0; i < n; i++){
        if(i_mario == ROWS-1 || scheme[i_mario+1][j_mario+1] == '='){
            // Mario non puo' muoversi avanti-su, quindi prova a muoversi solo su
            if(i_mario == ROWS-1 || scheme[i_mario+1][j_mario] == '='){
                // Mario non puo' muoversi nemmeno su, quindi smette di elevarsi e inizia a cadere
                break;
            }
            i_mario++;
        }
        else{
            // Mario si muove avanti-su
            i_mario++;
            j_mario++;
        }
        if(!koopa_killed && i_mario == i_koopa && j_mario == j_koopa){
            // Mario viene ucciso dalla Koopa
            game_over = true;
            return *this;
        }
        if(j_mario == COLS-1){
            // Mario vince
            game_over = true;
            return *this;
        }
    }

    // Mario cade finche' non atterra su un blocco (o nella lava)
    for(;;){
        if(scheme[i_mario-1][j_mario+1] == '='){
            // Mario non puo' muoversi avanti-giu', quindi si muove solo giu'
            if(scheme[i_mario-1][j_mario] == '='){
                // Mario non puo' muoversi nemmeno giu', quindi atterra
                return *this;
            }
            i_mario--;
        }
        else{
            // Mario si muove avanti-giu'
            i_mario--;
            j_mario++;
        }
        if(!koopa_killed && i_mario == i_koopa && j_mario == j_koopa){
            // Mario uccide la Koopa
            koopa_killed = true;
        }
        if(i_mario == 0){
            // Mario cade nella lava
            game_over = true;
            return *this;
        }
        if(j_mario == COLS-1){
            // Mario vince
            game_over = true;
            return *this;
        }
    }
}
