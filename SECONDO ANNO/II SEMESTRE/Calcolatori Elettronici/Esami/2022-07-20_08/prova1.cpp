// prova1.cpp
#include "cc.h"
int main()
{   st s = { 1,2,3,4, 1,2,3,4 };
    char v[4] = {10,11,12,13 };
    int d = 2;
    cl cc1(v); cc1.stampa();
    cc1.elab1(s, d); cc1.stampa();
}
    
