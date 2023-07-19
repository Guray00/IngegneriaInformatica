#include "compito.h"
using namespace std;

SonicLevel::SonicLevel(){
    for (int j = 0; j < maxcolo; j++){
        schema[0][j] = '=';
    }
    for (int i = 1; i < maxrighe; i++){
        for (int j=0; j < maxcolo; j++){
            schema[i][j] = ' ';
        }
    }
    i_sonic = -1;
    j_sonic = -1;
    gioco_fermo = true;
}

ostream& operator<<(ostream& os, const SonicLevel &s){
    if(s.gioco_fermo){
        os << "(GIOCO FERMO)" << endl;
        return os;
    }
    os << "Anelli:" << s.anelli_racc << endl;
    for (int i = SonicLevel::maxrighe-1; i >= 0; i--){
        os << i;
        for(int j = 0; j < SonicLevel::maxcolo; j++){
            if(i == s.i_sonic && j == s.j_sonic)
                os << 'S';
            else
                os << s.schema[i][j];
        }
        os << endl;
    }
    os << ' ';
    for(int j=0; j < SonicLevel::maxcolo; j++)
        os << j % 10;
    os << endl;

    return os;
}

SonicLevel& SonicLevel::blocchi(int i, int j, int nr, int nc){
    if(!gioco_fermo) return *this;
    if(i < 0 || i + nr >= maxrighe || j < 0 || j + nc >= maxcolo)
        return *this;
    for (int _i = i; _i < i+nr; _i++){
        for(int _j = j; _j < j+nc; _j++){
            schema[_i][_j] = '=';
        }
    }
    return *this;
}

SonicLevel& SonicLevel::anello(int i, int j){
    if(!gioco_fermo) return *this;
    if(i < 0 || i >= maxrighe || j < 0 || j >= maxcolo)
        return *this;
    if (schema[i][j] == ' ')
        schema[i][j] = 'o';
    return *this;
}

void SonicLevel::avvia(int _i_sonic, int _j_sonic){
    if(_i_sonic <= 0 || _i_sonic >= maxrighe)
        return;
    if(_j_sonic < 0 || _j_sonic >= maxcolo-1)
        return;
    if(schema[_i_sonic][_j_sonic] != ' ' || schema[_i_sonic-1][_j_sonic] != '=')
        return;
    i_sonic = _i_sonic;
    j_sonic = _j_sonic;
    anelli_racc = 0;
    gioco_fermo = false;
}

SonicLevel& SonicLevel::operator+=(int n){
    if(gioco_fermo || n <= 0) return *this;
    bool corsa;
    bool invul = false; // FUNZIONALITA' DELLA SECONDA PARTE
    // Sonic cammina
    for(int i = 0; i < n; i++){
        corsa = (i >= 10);
        if(schema[i_sonic][j_sonic+1] == '=' || schema[i_sonic][j_sonic+1] == '^'){
            // Sonic smette di camminare/correre a causa di un muro
            return *this;
        }
        j_sonic++;
        if(schema[i_sonic][j_sonic] == 'o'){
            // Sonic raccoglie un anello
            anelli_racc++;
            schema[i_sonic][j_sonic] = ' ';
        }
        // FUNZIONALITA' DELLA SECONDA PARTE
        if(!invul && schema[i_sonic-1][j_sonic] == '^'){
            // Sonic tocca uno spuntone
            if(anelli_racc == 0){
                gioco_fermo = true;
                return *this;
            }
            anelli_racc = 0;
            invul = true;
        }
        // FINE FUNZIONALITA' DELLA SECONDA PARTE
        if(!corsa || (j_sonic == maxcolo-1 || i_sonic < 0 || (schema[i_sonic-1][j_sonic+1] != '=' && schema[i_sonic-1][j_sonic+1] != '^'))){
            while(i_sonic > 0 && schema[i_sonic-1][j_sonic] != '=' && schema[i_sonic-1][j_sonic] != '^' && (j_sonic < maxcolo-1 || (schema[i_sonic-1][j_sonic+1] != '=' && schema[i_sonic-1][j_sonic+1] != '^'))){
                // Sonic cade giu'
                i_sonic--;
                if(schema[i_sonic][j_sonic] == 'o'){
                    // Sonic raccoglie un anello
                    anelli_racc++;
                    schema[i_sonic][j_sonic] = ' ';
                }
                // FUNZIONALITA' DELLA SECONDA PARTE
                if(!invul && schema[i_sonic-1][j_sonic] == '^'){
                    // Sonic tocca uno spuntone
                    if(anelli_racc == 0){
                        gioco_fermo = true;
                        return *this;
                    }
                    anelli_racc = 0;
                    invul = true;
                }
                // FINE FUNZIONALITA' DELLA SECONDA PARTE
            }
        }
        if(j_sonic == maxcolo - 1){
            // Sonic vince
            gioco_fermo = true;
            return *this;
        }
    }
    return *this;
}

// --- SECONDA PARTE ---
SonicLevel& SonicLevel::spuntone(int i, int j){
    if(!gioco_fermo) return *this;
    if(i < 0 || i >= maxrighe)
        return *this;
    if(j < 0 || j >= maxcolo)
        return *this;
    if(schema[i][j] != ' ' && schema[i][j] != '=')
        return *this;
    schema[i][j] = '^';

    return *this;
}

SonicLevel& SonicLevel::operator*=(int n){
    if(gioco_fermo || n <= 0) return *this;

    // Sonic si eleva di n celle
    for(int i = 0; i < n; i++){
        if(i_sonic == maxrighe-1 || schema[i_sonic+1][j_sonic+1] == '=' || schema[i_sonic+1][j_sonic+1] == '^'){
            // Sonic non puo' muoversi avanti-su, quindi prova a muoversi solo su
            if(i_sonic == maxrighe-1 || schema[i_sonic+1][j_sonic] == '=' || schema[i_sonic+1][j_sonic] == '^'){
                // Sonic non puo' muoversi nemmeno su, quindi smette di elevarsi e inizia a cadere
                break;
            }
            i_sonic++;
        }
        else{
            // Sonic si muove avanti-su
            i_sonic++;
            j_sonic++;
        }
        if(j_sonic == maxcolo-1){
            // Sonic vince
            gioco_fermo = true;
            return *this;
        }
        if(schema[i_sonic][j_sonic] == 'o'){
            // Sonic raccoglie un anello
            anelli_racc++;
            schema[i_sonic][j_sonic] = ' ';
        }
    }

    // Sonic cade finche' non atterra su un blocco (o su uno spuntone)
    for(;;){
        if(schema[i_sonic-1][j_sonic] == '=' || schema[i_sonic-1][j_sonic] == '^'){
            // Sonic atterra perche' ha un blocco (o uno spuntone) sotto ai piedi
            if(schema[i_sonic-1][j_sonic] == '=')
                return *this;
            else if(anelli_racc == 0){
                // Sonic muore
                gioco_fermo = true;
                return *this;
            }
            else{
                anelli_racc = 0;
                if(j_sonic == maxcolo-1){
                    // Sonic vince
                    gioco_fermo = true;
                }
                return *this;
            }
        }
        else if(schema[i_sonic-1][j_sonic+1] == '=' || schema[i_sonic-1][j_sonic+1] == '^'){
            // Sonic non puo' muoversi avanti-giu', quindi si muove solo giu'
            i_sonic--;
        }
        else{
            // Sonic si muove avanti-giu'
            i_sonic--;
            j_sonic++;
        }
        if(schema[i_sonic][j_sonic] == 'o'){
            // Sonic raccoglie un anello
            anelli_racc++;
            schema[i_sonic][j_sonic] = ' ';
        }
        if(j_sonic == maxcolo-1){
            // Sonic vince
            gioco_fermo = true;
            return *this;
        }
    }
}