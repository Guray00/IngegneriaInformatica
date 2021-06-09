#include <iostream>
using namespace std;

const int ROWS = 8;
const int COLS = 32;

class MarioStage{
    char scheme[ROWS][COLS];
    int i_mario;
    int j_mario;
    bool game_over;
    int i_koopa;
    int j_koopa;
    bool koopa_killed;
public:
    // --- PRIMA PARTE ---
    MarioStage();
    friend ostream& operator<<(ostream&, const MarioStage&);
    MarioStage& drawBlocks(int, int, int, int);
    void play(int, int);
    MarioStage& walkMario(int);
    // --- SECONDA PARTE ---
    MarioStage& setKoopa(int, int);
    MarioStage& jumpMario(int);
};

